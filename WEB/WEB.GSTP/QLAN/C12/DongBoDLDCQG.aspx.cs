using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using Newtonsoft.Json;
using BL.GSTP.DLQGC12;

namespace WEB.GSTP.QLAN.C12
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
                //LoadDropNoiDongBo();
                SetGetSessionTK(false);
            }
        }

        private void LoadLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
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
                foreach (DataGridItem Item in DgList_All.Items)
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
            ddlTrangthaiDongBo.SelectedIndex = 0;
            //ddlNoiDongBo.SelectedIndex = 0;
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
            pn_thuhoi.Visible = false;
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

        #region CN: 13/09/2025
        //Viết hàm Load_Data mới comment hàm cũ lại
        void Load_Data()
        {
            dataGridAllVisible(false); // ẩn hết các grid
            DLQGC12_BL obj = new DLQGC12_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue), pageindex = Convert.ToInt32(hddPageIndex.Value), count_all = 0;
            string v_LOAIBAQD = null;
            string v_BAQD_id = null;
            string v_KHANGCAOQH = null;

            pn_thuhoi.Visible = false;

            if (ddlTrangthaiDongBo.SelectedValue == "1")
            {
                btnGuiDLC06.Visible = true;
            }
            else
            {
                btnGuiDLC06.Visible = false;
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
                    loadDataDanSu(page_size, pageindex, count_all, tbl, v_LOAIBAQD, v_BAQD_id, v_KHANGCAOQH);
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

        void loadDataDanSu(int page_size, int pageindex, int count_all, DataTable tbl, string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH)
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC12_ADS_BL obj = new DLQGC12_ADS_BL();
            if (syncStatus == "3" || syncStatus == "2") //2: đã đồng bộ, 3: bị thu hồi
            {
                tbl = obj.GetADSPaging_Search_DaDongBo_ThuHoi(null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text, syncStatus
                            , pageindex, page_size);


            }
            else
            {
                //Chua dong bo
                tbl = obj.GeADSPaging_Search_All(null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , "1", null, pageindex, page_size);
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

            visibleDataGrid(ddlTrangthaiDongBo.SelectedValue, page_size, tbl);
        }
        void loadDataHanhChinh()
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC12_AHC_BL obj = new DLQGC12_AHC_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
               pageindex = Convert.ToInt32(hddPageIndex.Value),
               count_all = 0;
            DataTable tbl = new DataTable();
            if (syncStatus == "2" || syncStatus == "3")
            {
                //Đã đồng bộ
                tbl = obj.GetAHCPaging_Search_All_DaDongBo_ThuHoi(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text, syncStatus
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
                            , "1", null, pageindex, page_size);
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

            visibleDataGrid(ddlTrangthaiDongBo.SelectedValue, page_size, tbl);
        }
        void loadDataLaoDong()
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC12_ALD_BL obj = new DLQGC12_ALD_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
               pageindex = Convert.ToInt32(hddPageIndex.Value),
               count_all = 0;

            DataTable tbl = new DataTable();
            if (syncStatus == "2" || syncStatus == "3")
            {
                //Đã đồng bộ
                tbl = obj.GetALDPaging_Search_All_DaDongBo_ThuHoi(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text, syncStatus, pageindex, page_size);



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
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text, "1", null, pageindex, page_size);

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

            visibleDataGrid(ddlTrangthaiDongBo.SelectedValue, page_size, tbl);
        }
        void loadDataKinhTe()
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC12_AKT_BL obj = new DLQGC12_AKT_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
               pageindex = Convert.ToInt32(hddPageIndex.Value),
               count_all = 0;
            DataTable tbl = new DataTable();
            if (syncStatus == "2" || syncStatus == "3")
            {
                //Đã đồng bộ
                tbl = obj.GetAKTPaging_Search_All_DaDongBo_ThuHoi(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text, syncStatus
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
                            , "1", null, pageindex, page_size);
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

            visibleDataGrid(ddlTrangthaiDongBo.SelectedValue, page_size, tbl);
        }
        void loadDataHinhSu()
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC12_AHS_BL obj = new DLQGC12_AHS_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
               pageindex = Convert.ToInt32(hddPageIndex.Value),
               count_all = 0;

            DataTable tbl = new DataTable();
            if (syncStatus == "3" || syncStatus == "2") //BỊ THU HÒI HOẶC ĐÃ ĐỒNG BỘ
            {
                //Bị thu hồi
                tbl = obj.GetAllPaging_DaDongBo_ThuHoi(null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text, syncStatus
                            , pageindex, page_size);
            }
            else
            {
                //Chua dong bo
                tbl = obj.GetAllPaging_Search_All(null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , "1", null, pageindex, page_size);
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
        }

        void loadDataHNGD(int page_size, int pageindex, int count_all, DataTable tbl, string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH)
        {
            DLQGC12_BL obj = new DLQGC12_BL();
            if (ddlTrangthaiDongBo.SelectedValue == "3" || ddlTrangthaiDongBo.SelectedValue == "2") //2: đã đồng bộ, 3: bị thu hồi
            {
                tbl = obj.GetAHNPaging_Search_DaDongBo_ThuHoi(null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text, ddlTrangthaiDongBo.SelectedValue
                            , pageindex, page_size);


            }
            else
            {
                //Chua dong bo
                tbl = obj.GetAllPaging_Search_All(v_LOAIBAQD, v_BAQD_id, v_KHANGCAOQH
                             , DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , "1", null, pageindex, page_size);
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

            visibleDataGrid(ddlTrangthaiDongBo.SelectedValue, page_size, tbl);
        }
        void dataGridAllVisible(bool isVisible)
        {
            DgList_All.Visible = isVisible;
            gvDanhSach.Visible = isVisible;
        }

        void visibleDataGrid(string status, int page_size, DataTable tbl)
        {
            // nếu trạng thái đang đồng bộ
            DgList_All.Visible = true;
            DgList_All.DataSource = tbl;
            DgList_All.PageSize = page_size;
            DgList_All.DataBind();
        }

        void visibleDataGridAhs(string status, int page_size, DataTable tbl)
        {
            gvDanhSach.DataSource = tbl;
            gvDanhSach.PageSize = page_size;
            gvDanhSach.DataBind();
            gvDanhSach.Visible = true;
        }


        protected void btnThuHoi_Click(object sender, EventArgs e)
        {
            // xử lý lấy danh sách theo loại án
            string loaiAn = ddlLoaiAn.SelectedValue;
            DLQGC12_BL oBL = new DLQGC12_BL();
            decimal vCount = 0;

            System.Web.UI.WebControls.DataGrid grid = null;

            switch (loaiAn)
            {
                case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                    grid = gvDanhSach;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    grid = DgList_All;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    grid = DgList_All;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    grid = DgList_All;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    grid = DgList_All;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                    grid = DgList_All;
                    break;
                default: return;
            }

            if (grid == null)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "Lỗi", true);
                return;
            }

            foreach (DataGridItem Item in grid.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon != null && chkChon.Checked)
                {
                    string username = Session[ENUM_SESSION.SESSION_USERNAME].ToString();

                    string input = chkChon.ToolTip;
                    string[] array = input.Split(',');
                    string kHOBAQDIDString = array[4];

                    long kHOBAQDID = 0;

                    long.TryParse(kHOBAQDIDString, out kHOBAQDID);

                    KHOBAQD kHOBAQD = dt.KHOBAQDs.FirstOrDefault(s => s.ID == kHOBAQDID);

                    // nếu trạng thái bản án là đã đồng bộ thì được phép thu hồi
                    if (kHOBAQD != null && kHOBAQD.TRANGTHAIBAQD == 2)
                    {
                        // check đương sự có bản ghi nào hợp lệ không
                        if (CheckThuHoiDuongSu(kHOBAQD.ID))
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đương sự đang đồng bộ, không thể thu hồi');", true);

                            return;
                        }

                        //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                        if (oBL.ThuHoiDuLieuDaDongBo(kHOBAQDIDString, Session[ENUM_SESSION.SESSION_USERNAME] + "", txtLyDoThuHoi.Text?.Trim()))
                        {
                            vCount++;
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);
                        }

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi thành công!');", true);
                    }
                    else // Nếu chưa đồng bộ thì hủy chuyển
                    {
                        // trạng thái bản án đang ở chờ thu hồi
                        if (kHOBAQD.TRANGTHAIBAQD == 3)
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu bản án đã được thu hồi, không thể thu hồi tiếp');", true);
                        }
                        else
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

            Load_Data();

        }

        // kiểm tra có đương sự nào vẫn đang ở trạng thái chờ đồng bộ, đang đồng bộ không
        private bool CheckThuHoiDuongSu(decimal kHOBAQDID)
        {
            return dt.KHOBAQD_DUONGSU.Any(s => s.KHOBAQDID == kHOBAQDID && s.STATUS == 1 && (s.TRANGTHAIDUONGSU == 0 || s.TRANGTHAIDUONGSU == 1));

        }

        private DataTable GetDataByLoaiAn(string lOAIAN_ID, string lOAIBAQD, string bAQD_ID, string cAPXX, string toaanId, string v_CheckNullKHOBAQD, string v_DONID)
        {
            DataTable tbl = new DataTable();

            switch (lOAIAN_ID)
            {
                case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                    DLQGC12_AHS_BL ahs = new DLQGC12_AHS_BL();
                    tbl = ahs.GetAllPaging_Search_All(lOAIBAQD, bAQD_ID, null,
                            toaanId, cAPXX, null, null
                           , null, null, null
                           , null, null, null
                           , null, null
                           , null, null, null
                           , v_CheckNullKHOBAQD, v_DONID, 1, 20);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    DLQGC12_ADS_BL ads = new DLQGC12_ADS_BL();
                    tbl = ads.GeADSPaging_Search_All
                            (lOAIBAQD, bAQD_ID, null
                            , toaanId, cAPXX, null, null
                            , null, null, null
                            , null, null, null
                            , null, null
                            , null, null, null
                            , v_CheckNullKHOBAQD, v_DONID, 1, 20);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    DLQGC12_AHC_BL ahc = new DLQGC12_AHC_BL();
                    tbl = ahc.GeAHCPaging_Search_ChuaDongBo
                                (lOAIAN_ID, lOAIBAQD, bAQD_ID, null
                            , toaanId, cAPXX, null, null
                            , null, null, null
                            , null, null, null
                            , null, null
                            , null, null, null
                            , v_CheckNullKHOBAQD, v_DONID, 1, 20);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    DLQGC12_ALD_BL ald = new DLQGC12_ALD_BL();
                    tbl = ald.GeALDPaging_Search_ChuaDongBo
                                 (lOAIAN_ID, lOAIBAQD, bAQD_ID, null
                             , toaanId, cAPXX, null, null
                             , null, null, null
                             , null, null, null
                             , null, null
                             , null, null, null
                             , v_CheckNullKHOBAQD, v_DONID, 1, 20);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    DLQGC12_AKT_BL akt = new DLQGC12_AKT_BL();
                    tbl = akt.GeAKTPaging_Search_ChuaDongBo
                                (lOAIAN_ID, lOAIBAQD, bAQD_ID, null
                            , toaanId, cAPXX, null, null
                            , null, null, null
                            , null, null, null
                            , null, null
                            , null, null, null
                            , v_CheckNullKHOBAQD, v_DONID, 1, 20);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                    DLQGC12_BL oBL = new DLQGC12_BL();
                    tbl = oBL.GetAllPaging_Search_All
                                (lOAIBAQD, bAQD_ID, null
                                , toaanId, cAPXX, null, null
                                , null, null, null
                                , null, null, null
                                , null, null
                                , null, null, null
                                , v_CheckNullKHOBAQD, v_DONID, 1, 20);
                    break;
            }

            return tbl;
        }

        private string GetLINHVUCTEXT(string LOAIAN_ID)
        {
            switch (LOAIAN_ID)
            {
                case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                    return ENUM_LOAIVUVIEC_TEXT.AN_HINHSU;
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    return ENUM_LOAIVUVIEC_TEXT.AN_DANSU;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    return ENUM_LOAIVUVIEC_TEXT.AN_HANHCHINH;
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    return ENUM_LOAIVUVIEC_TEXT.AN_LAODONG;
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    return ENUM_LOAIVUVIEC_TEXT.AN_KINHDOANH_THUONGMAI;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                    return ENUM_LOAIVUVIEC_TEXT.AN_HONNHAN_GIADINH;
            }

            return string.Empty;
        }


        private string GetLINHVUC(string LOAIAN_TEXT)
        {
            switch (LOAIAN_TEXT)
            {
                case ENUM_LOAIVUVIEC_TEXT.AN_HINHSU:
                    return ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU;
                case ENUM_LOAIVUVIEC_TEXT.AN_DANSU:
                    return ENUM_LOAIVUVIEC_NUMBER.AN_DANSU;
                case ENUM_LOAIVUVIEC_TEXT.AN_HANHCHINH:
                    return ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH;
                case ENUM_LOAIVUVIEC_TEXT.AN_LAODONG:
                    return ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG;
                case ENUM_LOAIVUVIEC_TEXT.AN_KINHDOANH_THUONGMAI:
                    return ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI;
                case ENUM_LOAIVUVIEC_TEXT.AN_HONNHAN_GIADINH:
                    return ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH;
            }

            return string.Empty;
        }

        private List<KHOBAQD_DUONGSU> GetListDuongSu(decimal donID, string LOAIAN_ID)
        {
            List<KHOBAQD_DUONGSU> lstDuongSu = new List<KHOBAQD_DUONGSU>();

            switch (LOAIAN_ID)
            {
                case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                case ENUM_LOAIVUVIEC_TEXT.AN_HINHSU:

                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_DANSU:
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    var dataDS = dt.ADS_DON_DUONGSU.Where(x => x.DONID == donID).ToList();
                    foreach (var item in dataDS)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = donID,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = donID,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = donID,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_HANHCHINH:
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    var dataHC = dt.AHC_DON_DUONGSU.Where(x => x.DONID == donID).ToList();
                    foreach (var item in dataHC)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = donID,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = donID,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = donID,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_LAODONG:
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    var dataLD = dt.ALD_DON_DUONGSU.Where(x => x.DONID == donID).ToList();
                    foreach (var item in dataLD)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = donID,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = donID,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = donID,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_KINHDOANH_THUONGMAI:
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    var dataKT = dt.AKT_DON_DUONGSU.Where(x => x.DONID == donID).ToList();
                    foreach (var item in dataKT)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = donID,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.TEN : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.TEN : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = donID,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = donID,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_HONNHAN_GIADINH:
                case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                    var dataHN = dt.AHN_DON_DUONGSU.Where(x => x.DONID == donID).ToList();

                    // lấy dữ liệu tống đạt
                    List<AHN_TONGDAT> listTongDat = dt.AHN_TONGDAT.Where(s => s.DONID == donID).ToList();

                    List<decimal> listTongDatId = listTongDat.Select(s => s.ID).ToList();

                    List<AHN_TONGDAT_DOITUONG> listTongDatDoiTuong = dt.AHN_TONGDAT_DOITUONG.Where(s => listTongDatId.Contains(s.TONGDATID ?? 0)).ToList();

                    foreach (var item in dataHN)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = donID,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                        NGAYNHANTONGDAT = listTongDatDoiTuong.FirstOrDefault(s => s.MATUCACH == item.TUCACHTOTUNG_MA)?.NGAYNHANTONGDAT
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = donID,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    NGAYNHANTONGDAT = listTongDatDoiTuong.FirstOrDefault(s => s.MATUCACH == item.TUCACHTOTUNG_MA)?.NGAYNHANTONGDAT
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = donID,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                NGAYNHANTONGDAT = listTongDatDoiTuong.FirstOrDefault(s => s.MATUCACH == item.TUCACHTOTUNG_MA)?.NGAYNHANTONGDAT
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
            }

            return lstDuongSu;
        }

        private Model_DongBoDuLieu_KHOBAQD GetDataKhoBaQD(string loaiAnId, string lOAIBAQD, string bAQD_ID, string CapXX, string toaanId, string donId)
        {
            if (loaiAnId != ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)
            {
                DataTable tbl = GetDataByLoaiAn(loaiAnId, lOAIBAQD, bAQD_ID, CapXX, toaanId, "0", donId);

                if (tbl.Rows.Count == 0)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không lấy được bản án');", true);
                    return null;
                }

                DataRow row = tbl.Rows[0];

                //Kiem tra xem duong su da duoc Lam sach chua, neu chua thi bat phải xac thuc
                string vND_XACTHUC_DLDCQG = row["ND_XACTHUC_DLDCQG"] + "";
                string vND_LOAI = row["ND_LOAIDUONGSU"] + "";
                string vND_QT = row["ND_QUOCTICHID"] + "";
                string vBD_XACTHUC_DLDCQG = row["BD_XACTHUC_DLDCQG"] + "";
                string vBD_LOAI = row["BD_LOAIDUONGSU"] + "";
                string vBD_QT = row["BD_QUOCTICHID"] + "";


                //nguyên đơn là cá nhân và là người VN và chưa xác thực
                if (vND_LOAI == "1" && vND_QT == "2" && vND_XACTHUC_DLDCQG != "1")
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn cần xác thực thông tin của Đương sự!');", true);
                    return null;
                }

                //bị đơn là cá nhân và là người VN và chưa xác thực
                else if (vBD_LOAI == "1" && vBD_QT == "2" && vBD_XACTHUC_DLDCQG != "1")
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn cần xác thực thông tin của Đương sự!');", true);
                    return null;
                }

                DateTime ngayBAQD;
                DateTime ngayHLBAQD;
                DateTime.TryParseExact(
                    row["NGAY_RA_BAN_AN"] + "",
                    "dd/MM/yyyy",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out ngayBAQD
                );
                DateTime.TryParseExact(
                    row["NGAY_HIEU_LUC_BA"] + "",
                    "dd/MM/yyyy",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out ngayHLBAQD
                    );
                decimal donID = Convert.ToDecimal(row["DONID"] ?? 0);
                decimal capxx = (row["CAPXX"] + "").ToLower() == "sơ thẩm" ? 2 : 3;

                Model_DongBoDuLieu_KHOBAQD obj = new Model_DongBoDuLieu_KHOBAQD()
                {
                    CAPXX = capxx,
                    COQUANQD = row["DON_VI_RA_BAN_AN_TEN"] + "",
                    DONID = donID,
                    IDBAQD = Convert.ToDecimal(row["BAQD_ID"] ?? 0),
                    LINHVUC = GetLINHVUCTEXT(row["LOAIAN_ID"] + ""),
                    LOAIBAQD = Convert.ToDecimal(row["LOAIBAQD"] ?? 0),
                    MACQ = row["MA_DON_VI_RA_BAN_AN_TEN"] + "",
                    MAVANBAN = "",
                    NGAYBAQD = ngayBAQD,
                    NGAYHIEULUCBAQD = ngayHLBAQD,
                    QUANHEPHAPLUATID = row["QUANHEPHAPLUATID"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["QUANHEPHAPLUATID"] ?? 0),
                    SOBAQD = row["SO_BAN_AN"] + "",
                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                    TOAANID = Convert.ToDecimal(row["DON_VI_RA_BAN_AN_ID"] ?? 0),
                    DUONGSU = GetListDuongSu(donID, loaiAnId), //lấy đương sự
                    DSBAQDLIENQUAN = GetDSBALQByLoaiAn(loaiAnId, donID, capxx.ToString(), lOAIBAQD), //lấy danh sách bản án liên quan
                    SOTHULY = row["THULY"] + "",
                    LOAIQDHN = row["TRANG_THAI_TTHN"] == DBNull.Value ? null : row["TRANG_THAI_TTHN"] + "",
                    TRANGTHAIBAQD = 0
                };

                //Kiem tra ngay hieu luc cua ban an
                if (row["NGAY_HIEU_LUC_BA"] + "" == "")
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Nhập ngày hiệu lực của BA/QD trước khi đồng bộ');", true);
                    return null;
                }

                return obj;
            }
            else if (loaiAnId == ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)
            {
                DLQGC12_AHS_BL ahsBl = new DLQGC12_AHS_BL();

                DataTable tbl = GetDataByLoaiAn(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, lOAIBAQD, bAQD_ID, CapXX, toaanId, "0", donId);
                if (tbl.Rows.Count == 0)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không lấy được bản án');", true);
                    return null;
                }

                DataRow row = tbl.Rows[0];

                DateTime ngayBAQD;
                DateTime ngayHLBAQD;

                DateTime.TryParseExact(
                    row["banan_ngay_ba"] + "",
                    new[] { "dd/MM/yyyy", "dd/MM/yyyy HH:mm:ss" },
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out ngayBAQD
                );

                DateTime.TryParseExact(
                    row["bican_ngayhieuluc"] + "",
                    new[] { "dd/MM/yyyy", "dd/MM/yyyy HH:mm:ss" },
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out ngayHLBAQD
                );
                decimal vuanID = Convert.ToDecimal(row["vuanid"] ?? 0);

                #region lấy bị can bị cáo
                DataTable lstBcbc = ahsBl.GET_BICANBICAO_BY_BAQDID(row["baqd_id"]?.ToString(), row["loaibaqd"]?.ToString(), row["capxx_ma"]?.ToString());
                List<KHOBAQD_DUONGSU> lstDuongSu = new List<KHOBAQD_DUONGSU>();
                if (lstBcbc != null && lstBcbc.Rows.Count > 0)
                {
                    foreach (DataRow item in lstBcbc.Rows)
                    {
                        KHOBAQD_DUONGSU ds = null;

                        decimal biCaoId = Convert.ToDecimal(item["ID"] ?? 0);
                        decimal quocTichID = Convert.ToDecimal(item["QUOCTICHID"] ?? 0);
                        decimal thuongtruTinhID = Convert.ToDecimal(item["HKTT"] ?? 0);
                        decimal thuongtruHuyenID = Convert.ToDecimal(item["HKTT_HUYEN"] ?? 0);
                        decimal dantocId = Convert.ToDecimal(item["DANTOCID"] ?? 0);

                        var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == quocTichID) ?? new DM_DATAITEM();
                        var dantoc = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == dantocId) ?? new DM_DATAITEM();
                        var lstDiaChi = dt.DM_HANHCHINH.Where(x => x.ID == thuongtruTinhID || x.ID == thuongtruHuyenID).ToList();

                        var tinh = lstDiaChi.FirstOrDefault(x => x.ID == thuongtruTinhID) ?? new DM_HANHCHINH();
                        var huyenXa = lstDiaChi.FirstOrDefault(x => x.ID == thuongtruHuyenID) ?? new DM_HANHCHINH();

                        if ((item["LOAIDOITUONG"] + "") == "0") //cá nhân
                        {
                            DateTime ngaySinhDate;
                            DateTime.TryParse(item["NGAYSINH"] + "", out ngaySinhDate);

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if ((item["XACTHUC_DLDCQG"] + "") == "1") //đã xác thực
                                {
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = vuanID,
                                        DUONGSUID = biCaoId,
                                        DOITUONGPHAMTOI = Convert.ToDecimal(item["LOAIDOITUONG"] ?? 0),
                                        HOVATEN = item["HOTEN"] + "",
                                        GIOITINH = Convert.ToDecimal(item["GIOITINH"] ?? 0),
                                        NAMSINH = item["NAMSINH"] + "",
                                        THANGNAM = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item["KHTTCHITIET"] + "",
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item["SO_CCCD"] + "",
                                        MAXA = ((huyenXa.TEN ?? "").ToLower().Contains("xã") ? huyenXa.MA : ""),
                                        MAHUYEN = ((huyenXa.TEN ?? "").ToLower().Contains("huyện") ? huyenXa.MA : ""),
                                        MATINH = tinh.MA,
                                        DANTOC = dantoc.MA,
                                        TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.BICAO,
                                        TENTOIDANHC06 = item["tentoidanh"] + "",
                                        TENHINHPHATC06 = item["tenhinhphat"] + "",
                                    };
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn cần xác thực thông tin của bị can, bị cáo!');", true);
                                    return null;
                                }

                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = vuanID,
                                    DUONGSUID = biCaoId,
                                    DOITUONGPHAMTOI = Convert.ToDecimal(item["LOAIDOITUONG"] ?? 0),
                                    HOTENNN = item["HOTEN"] + "",
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("dd") : "",
                                    NAMSINHNN = item["NAMSINH"] + "",
                                    THANGNAMNN = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item["GIOITINH"] + "",
                                    SODINHDANHNN = item["SO_CCCD"] + "",
                                    DIACHICHITIET = item["KHTTCHITIET"] + "",
                                    DANTOC = dantoc.MA,
                                    TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.BICAO,
                                    TENTOIDANHC06 = item["tentoidanh"] + "",
                                    TENHINHPHATC06 = item["tenhinhphat"] + "",
                                };
                            }
                        }
                        else if ((item["LOAIDOITUONG"] + "") == "1" || (item["LOAIDOITUONG"] + "") == "2") //pháp nhân thương mại || pháp nhân phi thương mại
                        {
                            if ((item["XACTHUC_DLDCQG"] + "") == "1") //đã xác thực
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = vuanID,
                                    DUONGSUID = biCaoId,
                                    DOITUONGPHAMTOI = Convert.ToDecimal(item["LOAIDOITUONG"] ?? 0),
                                    MADDTC = "",
                                    MASOTHUE = "",
                                    TENTOCHUCTIENGVIET = item["HOTEN"] + "",
                                    LOAIHINHTC = item["LOAIDOITUONG"] + "",
                                    SODINHDANHDAIDIEN = item["SO_CCCD"] + "",
                                    HOVATENDAIDIEN = null,
                                    DIACHICHITIETRUSO = item["KHTTCHITIET"] + "",
                                    MAXATRUSO = ((huyenXa.TEN ?? "").ToLower().Contains("xã") ? huyenXa.MA : ""),
                                    MAHUYENTRUSO = ((huyenXa.TEN ?? "").ToLower().Contains("huyện") ? huyenXa.MA : ""),
                                    MATINHTRUSO = tinh.MA,
                                    QUOCGIATRUSO = quocTich.MA,
                                    DANTOC = dantoc.MA,
                                    TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.BICAO,
                                    TENTOIDANHC06 = item["tentoidanh"] + "",
                                    TENHINHPHATC06 = item["tenhinhphat"] + "",
                                };
                            }
                            else
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn cần xác thực thông tin của bị can, bị cáo!');", true);
                                return null;
                            }
                        }

                        #region lấy danh sách tội danh và hình phạt
                        string lstToiDanh = "<DSToiDanh>";
                        string lstHinhPhatChinh = "<DSHinhPhatChinh>";
                        string lstHinhPhatBoSung = "<DSHinhPhatBoSung>";
                        string toiDanhJson = string.Empty;
                        DataTable toiDanh = ahsBl.GET_TOIDANH_BY_BICAO(biCaoId, CapXX, lOAIBAQD);
                        if (toiDanh.Rows.Count > 0)
                        {
                            List<ToiDanhModel> toiDanhs = new List<ToiDanhModel>();

                            foreach (DataRow rows in toiDanh.Rows)
                            {
                                ToiDanhModel toidanh = new ToiDanhModel()
                                {
                                    maToiDanh = rows["ID"].ToString(),
                                    tenToiDanh = rows["TENTOIDANH"].ToString()
                                };
                                lstToiDanh += convertToiDanh(toidanh); //convert tội danh thành XML

                                #region lấy hình phạt theo tội danh của bị cáo
                                DataTable dsHinhPhatTbl = ahsBl.GET_HINHPHAT_BY_TOIDANH_BICAO(biCaoId, Convert.ToDecimal(toidanh.maToiDanh), CapXX, lOAIBAQD);
                                if (dsHinhPhatTbl.Rows.Count > 0)
                                {
                                    List<HinhPhatModel> dsHinhPhats = new List<HinhPhatModel>();
                                    foreach (DataRow hp in dsHinhPhatTbl.Rows)
                                    {
                                        HinhPhatModel hinhPhatItem = new HinhPhatModel()
                                        {
                                            maHinhPhat = hp["MAHINHPHAT"].ToString(),
                                            tenHinhPhat = hp["TENHINHPHAT"].ToString(),
                                            thamSoHinhPhat = thamSoHinhPhat(hp),
                                            hinhPhatChinh = hp["ISCHANGE"].ToString() == "0" ? 1 : 0 // Nếu ISCHANGE = "0" là hpc; "1" là hpbs
                                        };

                                        dsHinhPhats.Add(hinhPhatItem);

                                        if (hinhPhatItem.hinhPhatChinh == 1) //là hình phạt chính
                                            lstHinhPhatChinh += convertHinhPhatChinh(hinhPhatItem);
                                        else
                                            lstHinhPhatChinh += convertHinhPhatBoSung(hinhPhatItem); //là hình phạt bổ sung
                                    }

                                    toidanh.dSachHinhPhat = dsHinhPhats;

                                }
                                toiDanhs.Add(toidanh);
                                #endregion
                            }

                            toiDanhJson = JsonConvert.SerializeObject(toiDanhs, Formatting.None);
                        }

                        lstToiDanh += "</DSToiDanh>";
                        lstHinhPhatChinh += "</DSHinhPhatChinh>";
                        lstHinhPhatBoSung += "</DSHinhPhatBoSung>";
                        #endregion

                        if (ds != null)
                        {
                            ds.DSTOIDANHC06 = toiDanhJson;
                            ds.DSTOIDANH = lstToiDanh;
                            ds.DSHINHPHATCHINH = lstHinhPhatChinh;
                            ds.DSHINHPHATBOSUNG = lstHinhPhatBoSung;
                            lstDuongSu.Add(ds);
                        }
                    }
                }
                #endregion

                Model_DongBoDuLieu_KHOBAQD obj = new Model_DongBoDuLieu_KHOBAQD()
                {
                    CAPXX = (row["CAPXX"] + "").ToLower() == "sơ thẩm" ? 2 : 3,
                    MACQ = row["macq"] + "",
                    COQUANQD = row["tencq"] + "",
                    DONID = vuanID,
                    IDBAQD = Convert.ToDecimal(row["BAQD_ID"] ?? 0),
                    LINHVUC = "AHS",
                    LOAIBAQD = Convert.ToDecimal(row["LOAIBAQD"] ?? 0),
                    MAVANBAN = "",
                    NGAYBAQD = ngayBAQD,
                    NGAYHIEULUCBAQD = ngayHLBAQD,
                    SOBAQD = row["SO_BAN_AN"] + "",
                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                    DSBAQDLIENQUAN = GetDSBALQByLoaiAn(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, vuanID, CapXX, lOAIBAQD), //lấy danh sách bản án liên quan
                    TOAANID = Convert.ToDecimal(row["toaanId"] ?? 0),
                    DUONGSU = lstDuongSu, //bị can bị cáo của vụ án
                    SOTHULY = row["thuly"] + "",
                    THAMPHAN = row["thamphan_ten"] + "",
                    TRANGTHAIBAQD = 0
                };

                return obj;
            }

            return null;
        }

        protected void btnGuiDLDB_Click(object sender, EventArgs e)
        {
            // xử lý lấy danh sách theo loại án
            string loaiAn = ddlLoaiAn.SelectedValue;
            decimal vCount = 0;
            if (loaiAn != ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU) // Nếu là HNGD giữ nguyên logic cũ
            {
                foreach (DataGridItem Item in DgList_All.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon == null || !chkChon.Checked)
                    {
                        continue;
                    }

                    string input = chkChon.ToolTip;
                    string[] array = input.Split(',');

                    if (array.Length < 6)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không lấy được bản án');", true);

                        return;
                    }

                    string lOAIAN_ID = array[0];
                    string lOAIBAQD = array[1];
                    string bAQD_ID = array[2];
                    string cAPXX = array[3];
                    string kHOBAQDID = array[4];
                    string toaanId = array[5]; //tòa án id

                    // Lấy dữ liệu từ DB
                    DLQGC12_BL oBL = new DLQGC12_BL();

                    Model_DongBoDuLieu_KHOBAQD obj = GetDataKhoBaQD(lOAIAN_ID, lOAIBAQD, bAQD_ID, cAPXX?.ToLower() == "sơ thẩm" ? "2" : "3", toaanId, null);

                    if (obj == null)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không tìm thấy bản ghi');", true);
                        return;
                    }

                    if (IsExsistKhoBAQD(obj))
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bản án đã tồn tại trong kho đồng bộ');", true);
                        return;

                    }

                    else if (oBL.Insert_DuLieu_DongBo(obj))
                    {
                        vCount = vCount + 1; //Add các doi tuong vao mang de thuc hien insert
                    }
                }

                if (vCount > 0)
                {
                    hddPageIndex.Value = "1";
                    Load_Data();

                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);


                    return;
                }

            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)
            {

                DLQGC12_BL oBL = new DLQGC12_BL();
                foreach (DataGridItem Item in gvDanhSach.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");

                    if (chkChon == null || !chkChon.Checked)
                    {
                        continue;
                    }

                    string input = chkChon.ToolTip;
                    string[] split = input.Split(',');

                    if (split.Length < 6)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không lấy được bản án');", true);

                        return;
                    }

                    string vloaibaqd = split[1];    //= 0: bản án, = 1: quyết định
                    string vbaqd_id = split[2];     //id bản án/quyết định
                    string capxx = split[3];        //cấp xét xử sơ thẩm/phúc thẩm
                    string vtoaanId = split[5];    //tòa án id

                    // Lấy dữ liệu từ DB
                    Model_DongBoDuLieu_KHOBAQD obj = GetDataKhoBaQD(loaiAn, vloaibaqd, vbaqd_id, capxx, vtoaanId, null);

                    if (obj == null)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không tìm thấy bản ghi');", true);
                        return;
                    }

                    if (IsExsistKhoBAQD(obj))
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bản án đã tồn tại trong kho đồng bộ');", true);

                    }
                    else if (oBL.Insert_DuLieu_DongBo(obj))
                    {
                        vCount = vCount + 1;
                    }
                }

                if (vCount > 0)
                {
                    hddPageIndex.Value = "1";
                    Load_Data();

                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);

                    return;
                }
            }

        }

        private bool IsExsistKhoBAQD(Model_DongBoDuLieu_KHOBAQD obj)
        {
            return dt.KHOBAQDs.Any(s => s.DONID == obj.DONID && s.LINHVUC == obj.LINHVUC && s.CAPXX == obj.CAPXX && s.STATUS == 1);
        }

        private DataTable GetDSBiCanBiCaoAnHinhSu(string vbaqd_id, string vloaibaqd, string capxx, string v_trangthai, decimal PageIndex, decimal PageSize)
        {
            DLQGC12_AHS_BL ahsBl = new DLQGC12_AHS_BL();
            DataTable lstBcbc = ahsBl.GET_PAGING_BICANBICAO_BY_BAQDID(vbaqd_id, vloaibaqd, capxx, v_trangthai, PageIndex, PageSize);
            return lstBcbc;
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chkChon = (CheckBox)sender;

            if (chkChon != null && chkChon.Checked)
            {
                string input = chkChon.ToolTip;
                string[] array = input.Split(',');
                if (array.Length < 7)
                {
                    return;
                }

                string trangThaiBanAn = array[6]; //trạng thái bản án

                // nếu bản án đã đồng bộ (tất cả đã đồng bộ)
                if (trangThaiBanAn == "2")
                {
                    pn_thuhoi.Visible = true;
                }
                else
                {
                    pn_thuhoi.Visible = false;
                }
            }
            else
            {
                pn_thuhoi.Visible = false;
            }

            foreach (DataGridItem row in DgList_All.Items)
            {
                CheckBox cb = (CheckBox)row.FindControl("chkChon");
                if (cb != null && cb != chkChon)
                {
                    cb.Checked = false;
                }
            }

            foreach (DataGridItem row in gvDanhSach.Items)
            {
                CheckBox cb = (CheckBox)row.FindControl("chkChon");
                if (cb != null && cb != chkChon)
                {
                    cb.Checked = false;
                }
            }
        }

        private string GetDSBALQByLoaiAn(string loaiAn, decimal donID, string capxx, string vloaibaqd)
        {
            string rs = string.Empty;

            switch (loaiAn)
            {
                case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                    rs = convertDSBALQHinhSu(donID, capxx, vloaibaqd);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    rs = convertDSBALQDanSu(donID, capxx, vloaibaqd);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    rs = convertDSBALQHanhChinh(donID, capxx, vloaibaqd);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    rs = convertDSBALQLaoDong(donID, capxx, vloaibaqd);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    rs = convertDSBALQKinhDoanhThuongMai(donID, capxx, vloaibaqd);
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                    rs = convertDSBALQHonNhan(donID, capxx, vloaibaqd);
                    break;
            }

            return rs;
        }

        #region Lấy bản án liên quan hôn nhân
        private string convertDSBALQHonNhan(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnHN(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnHN(donID);
                banANLienQuan += getPhucThamBanAnHN(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnHN(donID);
                banANLienQuan += getPhucThamBanAnHN(donID);
                banANLienQuan += getSoThamQuyetDinhHN(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án hôn nhân
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getSoThamBanAnHN(decimal donID)
        {
            var stba = dt.AHN_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án hôn nhân
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnHN(decimal donID)
        {
            var stba = dt.AHN_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định hôn nhân
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhHN(decimal donID)
        {
            var stba = dt.AHN_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan dân sự
        private string convertDSBALQDanSu(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnDS(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnDS(donID);
                banANLienQuan += getPhucThamBanAnDS(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnDS(donID);
                banANLienQuan += getPhucThamBanAnDS(donID);
                banANLienQuan += getSoThamQuyetDinhDS(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án dân sự
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamBanAnDS(decimal donID)
        {
            var stba = dt.ADS_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án dân sự
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnDS(decimal donID)
        {
            var stba = dt.ADS_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định dân sự
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhDS(decimal donID)
        {
            var stba = dt.ADS_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan hành chính
        private string convertDSBALQHanhChinh(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnHC(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnHC(donID);
                banANLienQuan += getPhucThamBanAnHC(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnHC(donID);
                banANLienQuan += getPhucThamBanAnHC(donID);
                banANLienQuan += getSoThamQuyetDinhHC(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án hành chính
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamBanAnHC(decimal donID)
        {
            var stba = dt.AHC_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án hành chính
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnHC(decimal donID)
        {
            var stba = dt.AHC_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định hành chính
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhHC(decimal donID)
        {
            var stba = dt.AHC_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan lao động
        private string convertDSBALQLaoDong(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnLD(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnLD(donID);
                banANLienQuan += getPhucThamBanAnLD(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnLD(donID);
                banANLienQuan += getPhucThamBanAnLD(donID);
                banANLienQuan += getSoThamQuyetDinhLD(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án lao động
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamBanAnLD(decimal donID)
        {
            var stba = dt.ALD_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án lao động
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnLD(decimal donID)
        {
            var stba = dt.ALD_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định lao động
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhLD(decimal donID)
        {
            var stba = dt.ALD_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan kinh doanh thương mại
        private string convertDSBALQKinhDoanhThuongMai(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnKT(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnKT(donID);
                banANLienQuan += getPhucThamBanAnKT(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnKT(donID);
                banANLienQuan += getPhucThamBanAnKT(donID);
                banANLienQuan += getSoThamQuyetDinhKT(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án kinh doanh thương mại
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamBanAnKT(decimal donID)
        {
            var stba = dt.AKT_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án kinh doanh thương mại
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnKT(decimal donID)
        {
            var stba = dt.AKT_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định kinh doanh thương mại
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhKT(decimal donID)
        {
            var stba = dt.AKT_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan hình sự
        private string convertDSBALQHinhSu(decimal vuanID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            if (capxx == "3") //cấp phúc thẩm
            {
                //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
                if (capxx == "3" && vloaibaqd == "0")
                    banANLienQuan += getSoThamBanAnHS(vuanID);

                //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó (k cần lấy sơ thẩm quyết định)
                if (capxx == "3" && vloaibaqd == "1")
                {
                    banANLienQuan += getSoThamBanAnHS(vuanID);
                    banANLienQuan += getPhucThamBanAnHS(vuanID);
                }
            }
            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án hình sự
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getSoThamBanAnHS(decimal vuanID)
        {
            var stba = dt.AHS_SOTHAM_BANAN.FirstOrDefault(x => x.VUANID == vuanID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam></Nam>
                                  <ThangNam></ThangNam>
                                  <NgayThangNam></NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án hình sự
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnHS(decimal vuanID)
        {
            var stba = dt.AHS_PHUCTHAM_BANAN.FirstOrDefault(x => x.VUANID == vuanID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam></Nam>
                                  <ThangNam></ThangNam>
                                  <NgayThangNam></NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region convert XML tội danh/hình phạt
        private string convertToiDanh(ToiDanhModel model)
        {
            return $@"<ToiDanh>
                        <MaToiDanh>{model.maToiDanh}</MaToiDanh>
                        <TenToiDanh>{model.tenToiDanh}</TenToiDanh>
                    </ToiDanh>";
        }

        private string convertHinhPhatChinh(HinhPhatModel model)
        {
            return $@"<HinhPhatChinh>{model.tenHinhPhat}</HinhPhatChinh>";
        }

        private string convertHinhPhatBoSung(HinhPhatModel model)
        {
            return $@"<HinhPhatBoSung>{model.tenHinhPhat}</HinhPhatBoSung>";
        }
        #endregion

        protected void btnHuyChuyenC06_Click(object sender, EventArgs e)
        {
            // xử lý lấy danh sách theo loại án
            decimal vCountSuccess = 0;
            decimal vCountFail = 0; ;
            string loaiAn = ddlLoaiAn.SelectedValue;

            System.Web.UI.WebControls.DataGrid grid = null;

            switch (loaiAn)
            {
                case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                    grid = gvDanhSach;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    grid = DgList_All;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    grid = DgList_All;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    grid = DgList_All;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    grid = DgList_All;
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                    grid = DgList_All;
                    break;
                default: return;
            }

            if (grid == null)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "Lỗi", true);
                return;
            }

            foreach (DataGridItem Item in grid.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon != null && chkChon.Checked)
                {
                    string input = chkChon.ToolTip;
                    string[] array = input.Split(',');
                    string lOAIAN_ID = array[0];
                    string lOAIBAQD = array[1];
                    string bAQD_ID = array[2];
                    string cAPXX = array[3];
                    string kHOBAQDID = array[4];
                    decimal success = 0;
                    decimal fail = 0;
                    HuyChuyen(kHOBAQDID, out success, out fail);
                    vCountSuccess = vCountSuccess + success;
                    vCountFail = vCountFail + fail;
                }
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
            DLQGC12_BL oBL = new DLQGC12_BL();
            decimal vCount = 0;
            decimal KHOBAQDID = 0;
            decimal.TryParse(vDongBoID, out KHOBAQDID);
            // lấy danh sách đương sự cần gửi lại
            KHOBAQD kHOBAQD = dt.KHOBAQDs.FirstOrDefault(s => s.ID == KHOBAQDID);
            if (kHOBAQD == null)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Kho bản án không tồn tại!');", true);
                return;
            }

            Model_DongBoDuLieu_KHOBAQD obj = GetDataKhoBaQD(GetLINHVUC(kHOBAQD.LINHVUC), null, null, kHOBAQD.CAPXX.ToString(), kHOBAQD.TOAANID.ToString(), kHOBAQD.DONID?.ToString());

            if (obj == null)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Không tìm thấy bản ghi');", true);
                return;
            }

            if (oBL.GuiLaiDuLieuDaDongBo(vDongBoID, obj, Session[ENUM_SESSION.SESSION_USERNAME] + ""))
            {
                vCount++;
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);
            }

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại thành công!');", true);

            Load_Data();

        }


        protected void HuyChuyen(string kHOBAQDIDString, out decimal vCountSuccess, out decimal vCountFail)
        {
            vCountSuccess = 0;
            vCountFail = 0;

            //Nếu đã đông bộ sang Jobshared thì khong cho thu hồi
            DLQGC12_BL oBL = new DLQGC12_BL();
            // Lấy dữ liệu từ DB

            long kHOBAQDID = 0;

            long.TryParse(kHOBAQDIDString, out kHOBAQDID);

            KHOBAQD kHOBAQD = dt.KHOBAQDs.FirstOrDefault(s => s.ID == kHOBAQDID);

            if (kHOBAQD == null)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bản án không tồn tại');", true);
                return;
            }

            // nếu đang ở trạng thái chờ đồng bộ thì được phép hủy chuyển
            if (kHOBAQD.TRANGTHAIBAQD == 0)
            {
                //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                if (oBL.HuyChuyenDuLieuDaDongBo(kHOBAQDIDString))
                {
                    //Thong bao thu hoi thanh cong
                    vCountSuccess++;
                }
                else
                {
                    vCountFail++;
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển không thành công!');", true);
                }
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã đồng bộ sang CSDL quốc gia, không được Hủy chuyển!');", true);
            }
        }

        //Chuyển sang sử dụng GridView Chung cho 3 loại trạng thái
        protected void gvDanhSach_RowDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton LinkButtonDuongSuDongBo = (LinkButton)e.Item.FindControl("LinkButtonDuongSuDongBo");
                LinkButton LinkButtonDuongSuChuaDongBo = (LinkButton)e.Item.FindControl("LinkButtonDuongSuChuaDongBo");
                LinkButton LinkButtonXemLichSu = (LinkButton)e.Item.FindControl("LinkButtonXemLichSu");
                LinkButton LinkButtonXemGuiLai = (LinkButton)e.Item.FindControl("LinkButtonXemGuiLai");

                LinkButton LinkButtonHuyChuyen = (LinkButton)e.Item.FindControl("LinkButtonHuyChuyen");

                switch (ddlTrangthaiDongBo.SelectedValue)
                {
                    // chưa đồng bộ
                    case "1":
                        LinkButtonDuongSuDongBo.Visible = false;
                        LinkButtonDuongSuChuaDongBo.Visible = false;
                        LinkButtonXemLichSu.Visible = false;
                        LinkButtonXemGuiLai.Visible = false;
                        LinkButtonHuyChuyen.Visible = false;
                        break;
                    // đã đồng bộ
                    case "2":
                        LinkButtonDuongSuDongBo.Visible = true;
                        LinkButtonDuongSuChuaDongBo.Visible = true;
                        int soDs = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "SO_DUONGSU_CHUADONGBO"));
                        if (soDs == 0)
                        {
                            LinkButtonDuongSuChuaDongBo.Visible = false;
                        }

                        soDs = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "SO_DUONGSU_DONGBO"));
                        if (soDs == 0)
                        {
                            LinkButtonDuongSuChuaDongBo.Visible = false;
                        }

                        LinkButtonXemLichSu.Visible = true;
                        LinkButtonXemGuiLai.Visible = false;
                        LinkButtonHuyChuyen.Visible = false;

                        object value = DataBinder.Eval(e.Item.DataItem, "TRANGTHAIBAQD");

                        soDs = (value == null || value == DBNull.Value)
                                ? -1
                                : Convert.ToInt32(value);
                        if (soDs == 0)
                        {
                            LinkButtonHuyChuyen.Visible = true;
                        }
                        break;
                    // thu hồi
                    case "3":
                        LinkButtonDuongSuDongBo.Visible = false;
                        LinkButtonDuongSuChuaDongBo.Visible = false;
                        LinkButtonXemLichSu.Visible = true;
                        LinkButtonHuyChuyen.Visible = false;
                        LinkButtonXemGuiLai.Visible = false;
                        value = DataBinder.Eval(e.Item.DataItem, "TRANGTHAIBAQD");

                        soDs = (value == null || value == DBNull.Value)
                                ? -1
                                : Convert.ToInt32(value);
                        // nếu đã thu hồi thì được phép gửi lại
                        if (soDs == 5)
                        {
                            LinkButtonXemGuiLai.Visible = true;
                        }

                        break;
                }
            }
        }

        private bool CheckExistKhoBAQD(string kHOBAQDIDString)
        {
            decimal kHOBAQDID = 0;
            decimal.TryParse(kHOBAQDIDString, out kHOBAQDID);

            bool isExist = dt.KHOBAQDs.Any(s => s.ID == kHOBAQDID && s.STATUS == 1);

            if (!isExist)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bản án không tồn tại, hoặc đã được hủy chuyển');", true);
            }

            return isExist;
        }


        protected void gvList_RowCommand(object sender, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "GuiLai":
                    string id = e.CommandArgument.ToString();

                    if (!CheckExistKhoBAQD(id))
                    {
                        return;
                    }

                    GuiLai(id);
                    break;
                case "HuyChuyen":
                    string CurrID = e.CommandArgument.ToString();
                    if (!CheckExistKhoBAQD(CurrID))
                    {
                        return;
                    }
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
                    if (!CheckExistKhoBAQD(IDview))
                    {
                        return;
                    }
                    string StrMsg = "PopupCenter('/QLAN/C12/LichSuDongBo.aspx?KHOBAQDID=" + IDview.ToString() + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;

                case "ViewDuongSuDongBo":
                    string input = e.CommandArgument.ToString();
                    string[] array = input.Split(',');

                    if (array.Length >= 1)
                    {
                        string kHOBAQDID = array[0];

                        if (!CheckExistKhoBAQD(kHOBAQDID))
                        {
                            return;
                        }

                        string lOAIAN_ID = array[1];
                        string donId = array[2];
                        string capxx_ma = array[3];
                        string loaibaqd = array[4];


                        string linhVuc = GetLINHVUCTEXT(lOAIAN_ID);

                        string strMsgView = "PopupCenter('/QLAN/C12/DongBoDuongSu.aspx?KHOBAQDID=" + kHOBAQDID + "&LINHVUC=" + linhVuc + "&DONID=" + donId + "&capxx=" + capxx_ma + "&loaibaqd=" + loaibaqd + "&IsDongBo=1','Đồng bộ đương sự',950,450);";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), strMsgView, true);
                    }

                    break;
                case "ViewDuongSu":
                    string inputViewDuongSu = e.CommandArgument.ToString();
                    string[] arrayViewDuongSu = inputViewDuongSu.Split(',');

                    if (arrayViewDuongSu.Length >= 1)
                    {
                        string kHOBAQDID = arrayViewDuongSu[0];
                        string lOAIAN_ID = arrayViewDuongSu[1];
                        string donId = arrayViewDuongSu[2];

                        string capxx_ma = arrayViewDuongSu[3];
                        string loaibaqd = arrayViewDuongSu[4];

                        string soBA = arrayViewDuongSu[5];
                        string ngayBA = arrayViewDuongSu[6];
                        string ngayHL = arrayViewDuongSu[7];

                        string linhVuc = GetLINHVUCTEXT(lOAIAN_ID);

                        string strMsgView = "PopupCenter('/QLAN/C12/DongBoDuongSu.aspx?KHOBAQDID=" + kHOBAQDID + "&LINHVUC=" + linhVuc + "&DONID=" + donId + "&capxx=" + capxx_ma + "&loaibaqd=" + loaibaqd + "&soBA=" + soBA + "&ngayBA=" + ngayBA + "&ngayHL=" + ngayHL + "&IsDongBo=2','Đồng bộ đương sự',950,450);";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), strMsgView, true);
                    }

                    break;
                case "ViewDuongSuChuaDongBo":
                    string inputDS = e.CommandArgument.ToString();
                    string[] arrayDS = inputDS.Split(',');

                    if (arrayDS.Length >= 1)
                    {
                        string kHOBAQDID = arrayDS[0];

                        if (!CheckExistKhoBAQD(kHOBAQDID))
                        {
                            return;
                        }

                        string lOAIAN_ID = arrayDS[1];
                        string donId = arrayDS[2];
                        string capxx_ma = arrayDS[3];
                        string loaibaqd = arrayDS[4];

                        string linhVuc = GetLINHVUCTEXT(lOAIAN_ID);

                        string strMsgView = "PopupCenter('/QLAN/C12/DongBoDuongSu.aspx?KHOBAQDID=" + kHOBAQDID + "&LINHVUC=" + linhVuc + "&DONID=" + donId + "&capxx=" + capxx_ma + "&loaibaqd=" + loaibaqd + "&IsDongBo=0&TRANGTHAIDONGBO=1','Đồng bộ đương sự',950,450);";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), strMsgView, true);
                    }

                    break;

            }
        }

        #endregion

        #region aktDgList cho 5 loại án
        protected void DgList_All_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "GuiLai":
                    string id = e.CommandArgument.ToString();
                    if (!CheckExistKhoBAQD(id))
                    {
                        return;
                    }
                    GuiLai(id);
                    break;
                case "HuyChuyen":
                    string CurrID = e.CommandArgument.ToString();
                    if (!CheckExistKhoBAQD(CurrID))
                    {
                        return;
                    }
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
                    if (!CheckExistKhoBAQD(IDview))
                    {
                        return;
                    }
                    string StrMsg = "PopupCenter('/QLAN/C12/LichSuDongBo.aspx?KHOBAQDID=" + IDview.ToString() + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;

                case "ViewDuongSuDongBo":
                    string input = e.CommandArgument.ToString();
                    string[] array = input.Split(',');

                    if (array.Length >= 1)
                    {
                        string kHOBAQDID = array[0];
                        if (!CheckExistKhoBAQD(kHOBAQDID))
                        {
                            return;
                        }
                        string lOAIAN_ID = array[1];
                        string donId = array[2];

                        string linhVuc = GetLINHVUCTEXT(lOAIAN_ID);

                        string strMsgView = "PopupCenter('/QLAN/C12/DongBoDuongSu.aspx?KHOBAQDID=" + kHOBAQDID + "&LINHVUC=" + linhVuc + "&DONID=" + donId + "&IsDongBo=1','Đồng bộ đương sự',950,450);";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), strMsgView, true);
                    }

                    break;
                case "ViewDuongSu":
                    string inputViewDuongSu = e.CommandArgument.ToString();
                    string[] arrayViewDuongSu = inputViewDuongSu.Split(',');

                    if (arrayViewDuongSu.Length >= 1)
                    {
                        string kHOBAQDID = arrayViewDuongSu[0];
                        string lOAIAN_ID = arrayViewDuongSu[1];
                        string donId = arrayViewDuongSu[2];

                        string soBA = arrayViewDuongSu[3];
                        string ngayBA = arrayViewDuongSu[4];
                        string ngayHL = arrayViewDuongSu[5];

                        string linhVuc = GetLINHVUCTEXT(lOAIAN_ID);

                        string strMsgView = "PopupCenter('/QLAN/C12/DongBoDuongSu.aspx?KHOBAQDID=" + kHOBAQDID + "&LINHVUC=" + linhVuc + "&DONID=" + donId + "&soBA=" + soBA + "&ngayBA=" + ngayBA + "&ngayHL=" + ngayHL + "&IsDongBo=2','Đồng bộ đương sự',950,450);";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), strMsgView, true);
                    }

                    break;
                case "ViewDuongSuChuaDongBo":
                    string inputDS = e.CommandArgument.ToString();
                    string[] arrayDS = inputDS.Split(',');

                    if (arrayDS.Length >= 1)
                    {
                        string kHOBAQDID = arrayDS[0];
                        if (!CheckExistKhoBAQD(kHOBAQDID))
                        {
                            return;
                        }
                        string lOAIAN_ID = arrayDS[1];
                        string donId = arrayDS[2];

                        string linhVuc = GetLINHVUCTEXT(lOAIAN_ID);

                        string strMsgView = "PopupCenter('/QLAN/C12/DongBoDuongSu.aspx?KHOBAQDID=" + kHOBAQDID + "&LINHVUC=" + linhVuc + "&DONID=" + donId + "&IsDongBo=0&TRANGTHAIDONGBO=1','Đồng bộ đương sự',950,450);";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), strMsgView, true);
                    }

                    break;

            }
        }
        protected void DgList_All_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton LinkButtonDuongSuDongBo = (LinkButton)e.Item.FindControl("LinkButtonDuongSuDongBo");
                LinkButton LinkButtonDuongSuChuaDongBo = (LinkButton)e.Item.FindControl("LinkButtonDuongSuChuaDongBo");
                LinkButton LinkButtonXemLichSu = (LinkButton)e.Item.FindControl("LinkButtonXemLichSu");
                LinkButton LinkButtonXemGuiLai = (LinkButton)e.Item.FindControl("LinkButtonXemGuiLai");

                LinkButton LinkButtonHuyChuyen = (LinkButton)e.Item.FindControl("LinkButtonHuyChuyen");

                switch (ddlTrangthaiDongBo.SelectedValue)
                {
                    // chưa đồng bộ
                    case "1":
                        LinkButtonDuongSuDongBo.Visible = false;
                        LinkButtonDuongSuChuaDongBo.Visible = false;
                        LinkButtonXemLichSu.Visible = false;
                        LinkButtonXemGuiLai.Visible = false;
                        LinkButtonHuyChuyen.Visible = false;
                        break;
                    // đã đồng bộ
                    case "2":
                        LinkButtonDuongSuDongBo.Visible = true;
                        LinkButtonDuongSuChuaDongBo.Visible = true;
                        int soDs = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "SO_DUONGSU_CHUADONGBO"));
                        if (soDs == 0)
                        {
                            LinkButtonDuongSuChuaDongBo.Visible = false;
                        }

                        soDs = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "SO_DUONGSU_DONGBO"));
                        if (soDs == 0)
                        {
                            LinkButtonDuongSuChuaDongBo.Visible = false;
                        }

                        LinkButtonXemLichSu.Visible = true;
                        LinkButtonXemGuiLai.Visible = false;
                        LinkButtonHuyChuyen.Visible = false;

                        object value = DataBinder.Eval(e.Item.DataItem, "TRANGTHAIBAQD");

                        soDs = (value == null || value == DBNull.Value)
                                ? -1
                                : Convert.ToInt32(value);
                        if (soDs == 0)
                        {
                            LinkButtonHuyChuyen.Visible = true;
                        }
                        break;
                    // thu hồi
                    case "3":
                        LinkButtonDuongSuDongBo.Visible = false;
                        LinkButtonDuongSuChuaDongBo.Visible = false;
                        LinkButtonXemLichSu.Visible = true;
                        LinkButtonHuyChuyen.Visible = false;
                        LinkButtonXemGuiLai.Visible = false;
                        value = DataBinder.Eval(e.Item.DataItem, "TRANGTHAIBAQD");

                        soDs = (value == null || value == DBNull.Value)
                                ? -1
                                : Convert.ToInt32(value);
                        // nếu đã thu hồi thì được phép gửi lại
                        if (soDs == 5)
                        {
                            LinkButtonXemGuiLai.Visible = true;
                        }

                        break;
                }
            }
        }
        #endregion
    }
}