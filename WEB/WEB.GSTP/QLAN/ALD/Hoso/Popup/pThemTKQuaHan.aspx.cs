using BL.GSTP;
using BL.GSTP.ALD;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using BL.GSTP.BANGSETGET.QUAHAN;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.ALD.Hoso.Popup
{
    public partial class pThemTKQuaHan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private decimal loaian = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG);
        bool IsEdit => !string.IsNullOrEmpty(Request["TKID"]);
        int TKID => IsEdit ? Convert.ToInt32(Request["TKID"]) : 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsEdit)
            {
                Page.Title = "Sửa thống kê quá hạn";
            }
            else
            {
                Page.Title = "Thêm mới thống kê quá hạn";
                lbKhongCoVu.Visible = false;
            }

            if (!IsPostBack)
            {
                dropCapxx.SelectedValue = Session[TK_CANHBAO.CAPXX] + "";
                LoadKyThongKe();
                LoadCombobox();
                Load_Data();

                if (IsEdit)
                {
                    LoadDGListCon_Edit();
                }
            }
        }

        private void LoadDGListCon_Edit()
        {
            var dataTK_DonID = DataExtensions.GetAll<TK_QUAHAN_CHITIET>().Where(x => x.TKQUAHANID == TKID).Select(x => x.DONID).ToList();
            if (dataTK_DonID.Count == 0)
            {
                ViewState["DT_LIST_CON"] = null;

                dgListCon.DataSource = null;
                dgListCon.DataBind();
                lbKhongCoVu.Visible = true;
                return;
            }
            string csvIds = string.Join(",", dataTK_DonID);
            ALD_DON_BL oBL = new ALD_DON_BL();

            DataTable dt = oBL.DON_QUAHAN_CHITIET(
                Session["CAP_XET_XU"] + "",
                Session[ENUM_SESSION.SESSION_DONVIID] + "",
                TKID.ToString(),
                csvIds,
                1,
                int.MaxValue
            );

            ViewState["DT_LIST_CON"] = dt;

            dgListCon.DataSource = dt;
            dgListCon.DataBind();
            lbKhongCoVu.Visible = false;
            btnLuu.Visible = pnlTitle.Visible = true;
        }
        private string SetNgayCuoi()
        {
            string ngayCuoiText = "";

            if (!string.IsNullOrEmpty(dropThang.SelectedValue) &&
                !string.IsNullOrEmpty(dropNam.SelectedValue))
            {
                int year = int.Parse(dropNam.SelectedValue);
                int month = int.Parse(dropThang.SelectedValue);

                DateTime now = DateTime.Now;
                DateTime ngayCuoi;

                // Nếu là tháng hiện tại
                if (year == now.Year && month == now.Month)
                {
                    ngayCuoi = now;
                }
                else
                {
                    int lastDay = DateTime.DaysInMonth(year, month);
                    ngayCuoi = new DateTime(year, month, lastDay);
                }

                // Gán dạng dd/MM/yyyy
                ngayCuoiText = ngayCuoi.ToString("dd/MM/yyyy");
            }
            return ngayCuoiText;
        }
        private void Load_Data()
        {
            btnLuu.Visible = pnlTitle.Visible = dgListCon.DataSource != null;
            var toaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            ALD_DON_BL oBL = new ALD_DON_BL();
            if (dropThang.SelectedValue != "")
            {
                DataTable oDT = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_QHPL.Text.Trim(), "", txtTENDUONGSU.Text.Trim(), dropCapxx.SelectedValue, toaAnID.ToString(),
                                                "1", txtSOTHULY_THONGBAO.Text.Trim(), "", SetNgayCuoi(), ddlThamphan.SelectedValue, "1", "", "", "", "",
                                                "", "", "", "", "", "", "", 0, 0, 0, "",
                                                0, 0, 0, pageindex, page_size, 0, 0, "", "");
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
                    lstSobanghiT.Text = lstSobanghiB.Text = "Không có dữ liệu !";
                }
                dgList.PageSize = page_size;
                dgList.DataSource = oDT;
                dgList.DataBind();

            }
        }
        private void ClearData()
        {
            lstSobanghiT.Text = lstSobanghiB.Text = "";
            dgList.DataSource = null;
            dgList.DataBind();
            dgListCon.DataSource = null;
            dgListCon.DataBind();
        }
        protected void clear_form_search()
        {
            Session[TK_CANHBAO.CAPXX] = "";
            txtTenVuViec.Text = string.Empty;
            txt_QHPL.Text = string.Empty;
            txtTENDUONGSU.Text = string.Empty;
            dropCapxx.SelectedIndex = 0;
            txtSOTHULY_THONGBAO.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            LoadDropThang();
            clear_form_search();
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            LoadDropThang();
            Load_Data();

        }
        private void LoadDropThang()
        {
            int year = int.Parse(dropNam.SelectedValue);
            int thangDangChon = 0;

            if (!string.IsNullOrEmpty(dropThang.SelectedValue))
                thangDangChon = int.Parse(dropThang.SelectedValue);

            LoadThangTheoNam(year, thangDangChon);
        }
        void LoadCombobox()
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
                var toaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(toaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
        }
        private void LoadKyThongKe()
        {
            int currentYear = DateTime.Now.Year;

            // Xóa danh sách cũ
            dropNam.Items.Clear();
            for (int i = 2024; i <= currentYear; i++)
            {
                dropNam.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }

            int namDangSua = currentYear;
            int thangDangSua = 0;

            if (IsEdit)
            {
                // Lấy bản ghi đang sửa
                var tk = DataExtensions.GetAll<TK_QUAHAN>().FirstOrDefault(x => x.ID == TKID);
                if (tk != null)
                {
                    namDangSua = (int)tk.NAM;
                    thangDangSua = (int)tk.THANG;

                    dropNam.SelectedValue = tk.NAM.ToString();
                }
            }
            else
            {
                dropNam.SelectedValue = currentYear.ToString();
            }

            LoadThangTheoNam(int.Parse(dropNam.SelectedValue), thangDangSua);

            // Enable dropdown khi sửa, disable khi thêm mới
            dropNam.Enabled = !IsEdit;
            dropThang.Enabled = !IsEdit;
        }
        protected void dropNam_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedYear = int.Parse(dropNam.SelectedValue);
            LoadThangTheoNam(selectedYear);
            ClearData();
        }

        protected void dropThang_OnSelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThang();
            ClearData();
        }

        private List<decimal> GetThangDaCoData(int year)
        {
            var data = DataExtensions.GetAllWithClause<TK_QUAHAN>($"NAM = {year} AND TOAANID = {Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])} AND TRANGTHAI != 99 AND LOAIAN = {loaian}").Select(x => x.THANG).ToList();
            return data;
        }
        private void LoadThangTheoNam(int selectedYear, int thangDangSua = 0)
        {
            dropThang.Items.Clear();
            if (!IsEdit)
            {
                dropThang.Items.Add(new ListItem("-- Chọn tháng --", ""));
            }
            int currentYear = DateTime.Now.Year;
            int currentMonth = DateTime.Now.Month;
            int maxMonth = (selectedYear == currentYear) ? currentMonth : 12;

            List<decimal> thangDaCoData = GetThangDaCoData(selectedYear);

            for (int m = 1; m <= maxMonth; m++)
            {
                ListItem item = new ListItem("Tháng " + m, m.ToString());

                if (thangDaCoData.Contains(m))
                {
                    if (!IsEdit)
                    {
                        item.Attributes.Add("disabled", "disabled");
                        item.Text += " (đã thống kê)";
                    }
                }

                dropThang.Items.Add(item);

                // Chọn tháng đang sửa
                if (IsEdit && m == thangDangSua)
                    item.Selected = true;
            }
            if (!IsEdit)
            {
                if (thangDangSua == 0)
                    dropThang.SelectedIndex = 0;
                else
                    dropThang.SelectedValue = thangDangSua.ToString();

            }
        }


        protected void btnKhongCovuQuaHan_Click(object sender, EventArgs e)
        {
            if (IsEdit)
            {
                var lstQuaHanCT = DataExtensions.GetAll<TK_QUAHAN_CHITIET>().Where(x => x.TKQUAHANID == TKID).ToList();
                foreach (var item in lstQuaHanCT)
                {
                    DataExtensions.Delete(item);
                }
                var quaHan = DataExtensions.GetAll<TK_QUAHAN>().Where(x => x.ID == TKID).FirstOrDefault();
                quaHan.SOVUAN_QUAHAN = 0;
                quaHan.NGAYSUA = DateTime.Now;
                quaHan.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Update(quaHan);
                Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose_Sua()");
            }
            else
            {
                var nam = dropNam.SelectedItem.Value;
                var thang = dropThang.SelectedItem.Value;
                var tkQuaHan = new TK_QUAHAN()
                {
                    THANG = Convert.ToInt32(thang),
                    NAM = Convert.ToInt32(nam),
                    TRANGTHAI = 0,
                    NGAYTAO = DateTime.Now,
                    NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                    SOVUAN_QUAHAN = 0,
                    LOAIAN = loaian,
                    TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])
                };

                DataExtensions.Insert(tkQuaHan);
                Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");
            }


        }

        protected void cmdChonVV_Click(object sender, EventArgs e)
        {
            List<decimal> listIDChon = new List<decimal>();

            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox chk = (CheckBox)item.FindControl("chkChon");
                HiddenField hd = (HiddenField)item.FindControl("hdID");

                if (chk != null && chk.Checked)
                {
                    decimal id;
                    if (decimal.TryParse(hd.Value, out id))
                    {
                        listIDChon.Add(id);
                    }
                }
            }
            LoadDropThang();
            if (dropThang.SelectedValue == "")
            { lbtthongbao.Text = "Bạn phải chọn tháng"; }
            else if (listIDChon.Count == 0)
            {
                lbtthongbao.Text = "Bạn phải chọn ít nhất 1 vụ việc";
            }
            else
            {
                if (dropNam.SelectedValue == DateTime.Now.Year.ToString())
                {
                    var data = DataExtensions.GetAll<TK_QUAHAN>().Where(x => x.LOAIAN == loaian && x.NAM == Convert.ToDecimal(dropNam.SelectedValue) && x.THANG == Convert.ToDecimal(dropThang.SelectedValue) - 1);
                    if (data == null)
                    {
                        lbtthongbao.Text = "Tháng trước chưa có thống kê, không thể thống kê tháng này";
                    }
                }
                lbtthongbao.Text = "";
                Session["ListID_DON_QUAHAN"] = listIDChon;
                string csvIds = string.Join(",", listIDChon);
                ALD_DON_BL oBL = new ALD_DON_BL();
                DataTable oDT = oBL.DON_QUAHAN_CHITIET(Session["CAP_XET_XU"] + "", Session[ENUM_SESSION.SESSION_DONVIID] + "", IsEdit ? TKID.ToString() : "", csvIds, 1, int.MaxValue);
                ViewState["DT_LIST_CON"] = oDT;
                dgListCon.DataSource = oDT;
                dgListCon.DataBind();
                btnLuu.Visible = pnlTitle.Visible = true;
                lbKhongCoVu.Visible = false;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType != ListItemType.Item &&
                e.Item.ItemType != ListItemType.AlternatingItem)
                return;

            if (!IsEdit)
                return;

            CheckBox chk = (CheckBox)e.Item.FindControl("chkChon");
            HiddenField hd = (HiddenField)e.Item.FindControl("hdID");

            if (chk == null || hd == null)
                return;

            decimal donId;
            if (!decimal.TryParse(hd.Value, out donId))
                return;

            // Danh sách vụ việc đã có trong thống kê
            var listDonDaCo = GetDonDaThongKe();

            if (listDonDaCo.Contains(donId))
            {
                chk.Checked = true;
            }
        }
        protected void dgListCon_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DropDownList ddl = (DropDownList)e.Item.FindControl("dropLyDo");
                if (ddl != null)
                {
                    var lyDoValue = DataBinder.Eval(e.Item.DataItem, "LYDO_QUAHAN")?.ToString();
                    if (!string.IsNullOrEmpty(lyDoValue) && ddl.Items.FindByValue(lyDoValue) != null)
                    {
                        ddl.SelectedValue = lyDoValue;
                    }
                }

                TextBox txtBox = (TextBox)e.Item.FindControl("ChiTiet_LyDo");
                if (txtBox != null)
                {
                    var chitiet_lydo = DataBinder.Eval(e.Item.DataItem, "CHITIET_LYDO")?.ToString();
                    if (!string.IsNullOrEmpty(chitiet_lydo))
                    {
                        txtBox.Text = chitiet_lydo;
                    }
                }
            }
        }
        protected void dgListCon_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            if (e.CommandName != "XOA")
                return;

            decimal donId = Convert.ToDecimal(e.CommandArgument);

            DataTable dt = ViewState["DT_LIST_CON"] as DataTable;
            if (dt == null)
                return;

            DataRow row = dt.AsEnumerable()
                            .FirstOrDefault(r => Convert.ToDecimal(r["ID"]) == donId);

            if (row != null)
                dt.Rows.Remove(row);

            ViewState["DT_LIST_CON"] = dt;

            dgListCon.DataSource = dt;
            dgListCon.DataBind();

            btnLuu.Visible = pnlTitle.Visible = dt.Rows.Count > 0;

            BoTickCheckboxDon(donId);
        }
        private void BoTickCheckboxDon(decimal donId)
        {
            foreach (DataGridItem item in dgList.Items)
            {
                HiddenField hd = item.FindControl("hdID") as HiddenField;
                CheckBox chk = item.FindControl("chkChon") as CheckBox;

                if (hd != null && chk != null)
                {
                    if (hd.Value == donId.ToString())
                    {
                        chk.Checked = false;
                        break;
                    }
                }
            }
        }
        private List<decimal> GetDonDaThongKe()
        {
            if (!IsEdit)
                return new List<decimal>();

            return DataExtensions.GetAllWithClause<TK_QUAHAN_CHITIET>($"TKQUAHANID = {TKID}").Select(x => x.DONID).ToList();
        }

        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            var count = 0;
            var nam = dropNam.SelectedItem.Value;
            var thang = dropThang.SelectedItem.Value;
            DataTable dt = ViewState["DT_LIST_CON"] as DataTable;
            if (dt == null || dt.Rows.Count == 0)
                return;

            var tkQuaHan = new TK_QUAHAN();
            if (IsEdit)
            {
                tkQuaHan = DataExtensions.GetAll<TK_QUAHAN>().Where(x => x.ID == TKID).FirstOrDefault();
                tkQuaHan.NGAYSUA = DateTime.Now;
                tkQuaHan.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Update(tkQuaHan);
                var lstQuaHanCT = DataExtensions.GetAll<TK_QUAHAN_CHITIET>().Where(x => x.TKQUAHANID == TKID).ToList();
                foreach (var item in lstQuaHanCT)
                {
                    DataExtensions.Delete(item);
                }
            }
            else
            {
                tkQuaHan = new TK_QUAHAN()
                {
                    THANG = Convert.ToInt32(thang),
                    NAM = Convert.ToInt32(nam),
                    TRANGTHAI = 0,
                    NGAYTAO = DateTime.Now,
                    NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                    LOAIAN = loaian,
                    TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])
                };
                DataExtensions.Insert(tkQuaHan);

            }


            foreach (DataGridItem item in dgListCon.Items)
            {
                var saveData = new TK_QUAHAN_CHITIET();
                decimal DONID = Convert.ToDecimal(item.Cells[0].Text);
                var isST_PT = item.Cells[1].Text;
                if (isST_PT.ToLower() == "sơ thẩm")
                    saveData.ISSOTHAM = 1;
                else if (isST_PT.ToLower() == "phúc thẩm")
                    saveData.ISPHUCTHAM = 1;
                string MAVUVIEC = item.Cells[2].Text;
                string TENVUVIEC = item.Cells[3].Text;
                DropDownList ddlLyDo = (DropDownList)item.FindControl("dropLyDo");
                if (ddlLyDo != null)
                    saveData.LYDO_QUAHAN = Convert.ToInt32(ddlLyDo.SelectedValue);
                TextBox txtLyDo = (TextBox)item.FindControl("ChiTiet_LyDo");
                saveData.CHITIET_LYDO = txtLyDo.Text;
                saveData.DONID = DONID;
                saveData.MAVUVIEC = MAVUVIEC;
                saveData.TKQUAHANID = tkQuaHan.ID;
                saveData.NGAYTAO = DateTime.Now;
                saveData.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Insert(saveData);
                count++;
            }

            tkQuaHan.SOVUAN_QUAHAN = count;
            DataExtensions.Update(tkQuaHan);
            if (!IsEdit)
                Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");
            else
                Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose_Sua()");
        }

        protected void cmdDong_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "anPopup();", true);
        }

        #region phân trang
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadDropThang();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDropThang();
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadDropThang();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadDropThang();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            LoadDropThang();
            Load_Data();
        }
        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            LoadDropThang();
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            LoadDropThang();
            Load_Data();
        }
        #endregion phân trang
    }
}