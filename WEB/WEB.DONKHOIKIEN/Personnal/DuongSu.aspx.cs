
using BL.DonKK;
using BL.GSTP;
using DAL.DKK;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class DuongSu : System.Web.UI.Page
    {
        GSTPContext gsdt = new GSTPContext();
        DKKContextContainer dt = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        public int CurrYear = 0;
        public decimal CurrDonKK = 0, CurrVuViecID = 0;
        String temp = "";
        Decimal QuocTichVN = 0, UserID = 0;
        public String LoaiVuViec = "";
        public String TypeDuongSu = "";
        public string WidthCellNamSinh = "";

        String Value_NG = "NG";
        protected void Page_Load(object sender, EventArgs e)
        {
            QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
            CurrYear = DateTime.Now.Year;
            LoaiVuViec = (string.IsNullOrEmpty(Request["loaivv"] + "")) ? "" : Request["loaivv"].ToString();
            CurrDonKK = (string.IsNullOrEmpty(Request["dkkID"] + "")) ? 0 : Convert.ToDecimal(Request["dkkID"] + "");
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            TypeDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();

            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadCombobox();
                    dropLoaiDon.SelectedValue = LoaiVuViec;

                    try
                    {
                        if (Request["loaids"] != null)
                        {
                            ddlTucachTotung.SelectedValue = TypeDuongSu;
                            if (TypeDuongSu == ENUM_DANSU_TUCACHTOTUNG.KHAC)
                                ddlTucachTotung.Enabled = true;
                            else
                                ddlTucachTotung.Enabled = false;
                            WidthCellNamSinh = "margin-left:18px;";
                            switch (TypeDuongSu)
                            {
                                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                                    switch (LoaiVuViec)
                                    {
                                        case ENUM_LOAIAN.AN_DANSU:
                                            temp = "Thông tin người bị kiện khác";
                                            break;
                                        case ENUM_LOAIAN.AN_HANHCHINH:
                                            temp = "Thông tin người bị kiện khác";
                                            break;
                                        default:
                                            temp = "Thông tin người bị kiện khác";
                                            break;
                                    }
                                    break;
                                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                                    switch (LoaiVuViec)
                                    {
                                        case ENUM_LOAIAN.AN_DANSU:
                                            temp = "Thông tin người khởi kiện khác";
                                            break;
                                        case ENUM_LOAIAN.AN_HANHCHINH:
                                            temp = "Thông tin người khởi kiện khác";
                                            break;
                                        default:
                                            temp = "Thông tin người khởi kiện khác";
                                            break;
                                    }
                                    WidthCellNamSinh = "margin-left:9px;";
                                    lttValidateNamSinh.Text = "<span class='batbuoc'>*</span>";
                                    lttCheckCMND.Text = "<span class='batbuoc' id='span_CMND'>*</span>";
                                    break;
                                case ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN:
                                    temp = "Thông tin người ủy quyền";
                                    WidthCellNamSinh = "margin-left:9px;";
                                    lttValidateNamSinh.Text = "<span class='batbuoc'>*</span>";
                                    lttCheckCMND.Text = "<span class='batbuoc' id='span_CMND'>*</span>";
                                    LoadThongTinNguoiUyQuyen();
                                    break;
                                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                                    temp = "Thông tin đương sự có nghĩa vụ liên quan";
                                    lttCheckCMND.Text = "";
                                    break;
                                case ENUM_DANSU_TUCACHTOTUNG.KHAC:
                                    temp = "Thông tin người tham gia tố tụng khác";
                                    break;
                            }
                            lttTieuDe.Text = temp;
                        }
                        if (Request["dsID"] != null)
                            loadedit(Convert.ToDecimal(Request["dsID"].ToString()));
                    }
                    catch (Exception ex) { }

                    //----------------------
                    try
                    {
                        if (CurrDonKK > 0)
                            hddVuAn.Value = dt.DONKK_DON.Where(x => x.ID == CurrDonKK).Single<DONKK_DON>().VUANID.ToString();

                    }
                    catch (Exception ex) { }

                    //-----------------------------    

                    try { LoadGrid(); } catch (Exception ex) { }
                }
            }
            else Response.Redirect("/Trangchu.aspx");
        }

        //----------------------------------------
        private void LoadCombobox()
        {
            //load drop loai an 
            dropLoaiDon.Items.Clear();
            dropLoaiDon.Items.Add(new ListItem("Dân sự", ENUM_LOAIAN.AN_DANSU));
            dropLoaiDon.Items.Add(new ListItem("Hành chính", ENUM_LOAIAN.AN_HANHCHINH));
            dropLoaiDon.Items.Add(new ListItem("Hôn nhân - Gia đình", ENUM_LOAIAN.AN_HONNHAN_GIADINH));
            dropLoaiDon.Items.Add(new ListItem("Kinh doanh - Thương mại", ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI));
            dropLoaiDon.Items.Add(new ListItem("Lao động", ENUM_LOAIAN.AN_LAODONG));
            dropLoaiDon.Items.Add(new ListItem("Phá sản", ENUM_LOAIAN.AN_PHASAN));

            //---------------------------------
            LoadDropByGroupName(ddlND_Quoctich, ENUM_DANHMUC.QUOCTICH, false);

            //--------------------
            ddlTucachTotung.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            string tucachtt = "";
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTOTUNG_DS);
            if (Request["loaids"] != null)
                tucachtt = Request["loaids"].ToString();
            foreach (DataRow row in tbl.Rows)
            {
                temp = row["Ma"] + "";
                if (tucachtt == ENUM_DANSU_TUCACHTOTUNG.KHAC)
                {
                    if (temp != ENUM_DANSU_TUCACHTOTUNG.BIDON
                        && temp != ENUM_DANSU_TUCACHTOTUNG.NGUYENDON
                        && temp != ENUM_DANSU_TUCACHTOTUNG.UYQUYEN)
                        ddlTucachTotung.Items.Add(new ListItem(row["TEN"] + "", temp));
                }
                else
                    ddlTucachTotung.Items.Add(new ListItem(row["TEN"] + "", temp));
            }

            //----------------------
            LoadDMHanhChinh();
        }
        void LoadDMHanhChinh()
        {
            //----------DM hanh chinh : tinh, Quan/huyen------------
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            Decimal ParentID = 0;
            DataTable tbl = obj.GetAllByParentID(ParentID);
            //----------------
            dropToChuc_Tinh.Items.Clear();
            dropToChuc_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropToChuc_Tinh, tbl);

            dropCaNhan_TamTru_Tinh.Items.Clear();
            dropCaNhan_TamTru_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropCaNhan_TamTru_Tinh, tbl);
            try
            {
                ParentID = Convert.ToDecimal(dropToChuc_Tinh.SelectedValue);
                tbl = obj.GetAllByParentID(ParentID);

                dropToChuc_QuanHuyen.Items.Clear();
                dropToChuc_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                LoadDMHanhChinh(dropToChuc_QuanHuyen, tbl);

                dropCaNhan_TamTru_QuanHuyen.Items.Clear();
                dropCaNhan_TamTru_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                LoadDMHanhChinh(dropCaNhan_TamTru_QuanHuyen, tbl);
            }
            catch (Exception ex) { }
        }
        void LoadDMHanhChinh(DropDownList drop, DataTable tbl)
        {
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
            }
        }
        void LoadDMHanhChinhByParentID(Decimal ParentID, DropDownList drop, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            DataTable tbl = obj.GetAllByParentID(ParentID);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("---Quận/Huyện---", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
            }
            else
                drop.Items.Add(new ListItem("----Quận/Huyện---", "0"));
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("---Chọn---", "0"));
            foreach (DataRow row in tbl.Rows)
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
        }

        //----------------------------
        protected void dropToChuc_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropToChuc_Tinh.SelectedValue), dropToChuc_QuanHuyen, true);
            }
            catch (Exception ex) { }
            Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_QuanHuyen.ClientID);
        }

        protected void ddlND_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblQuanHuyen.Visible = true;
            dropCaNhan_TamTru_QuanHuyen.Visible = true;

            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            Decimal ParentID = 0;
            DataTable tbl = obj.GetAllByParentID(ParentID);
            dropCaNhan_TamTru_Tinh.Items.Clear();
            dropCaNhan_TamTru_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropCaNhan_TamTru_Tinh, tbl);
            dropCaNhan_TamTru_QuanHuyen.Items.Clear();
            dropCaNhan_TamTru_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện--", "0"));
            chkONuocNgoai.Checked = false;
            if (ddlND_Quoctich.SelectedValue == QuocTichVN.ToString())
            {
                chkONuocNgoai.Visible = true;
                if (chkONuocNgoai.Checked)
                {
                    lblQuanHuyen.Visible = false;
                    Add_ValueNG(dropCaNhan_TamTru_Tinh);
                }
                else
                    dropCaNhan_TamTru_Tinh.SelectedIndex = dropCaNhan_TamTru_QuanHuyen.SelectedIndex = 0;

            }
            else
            {
                chkONuocNgoai.Visible = false;
                Add_ValueNG(dropCaNhan_TamTru_Tinh);
                lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = false;
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtND_Ngaysinh.ClientID);
        }


        protected void dropCaNhan_TamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = true;
                if (dropCaNhan_TamTru_Tinh.SelectedValue != Value_NG.ToString())
                {
                    //chkONuocNgoai.Checked = false;
                    //if (chkONuocNgoai.Checked)
                    //{
                    //    Add_ValueNG(dropCaNhan_TamTru_Tinh);
                    //    lblQuanHuyen.Visible = false;
                    //    dropCaNhan_TamTru_QuanHuyen.Visible = false;
                    //    Cls_Comon.SetFocus(this, this.GetType(), txtCaNhan_TamTru_DiaChiCT.ClientID);
                    //}
                    //else
                    //{
                    lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = true;
                    LoadDMHanhChinhByParentID(Convert.ToDecimal(dropCaNhan_TamTru_Tinh.SelectedValue), dropCaNhan_TamTru_QuanHuyen, true);
                    Cls_Comon.SetFocus(this, this.GetType(), dropCaNhan_TamTru_QuanHuyen.ClientID);
                    //}
                }
                else
                {
                    //chkONuocNgoai.Checked = false;
                    lblQuanHuyen.Visible = false;
                    dropCaNhan_TamTru_QuanHuyen.Visible = false;

                    Cls_Comon.SetFocus(this, this.GetType(), txtCaNhan_TamTru_DiaChiCT.ClientID);
                    lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = false;
                }
            }
            catch (Exception ex) { }
        }
        void Add_ValueNG(DropDownList drop)
        {
            if (drop.Items.FindByValue(Value_NG) != null)
                drop.SelectedValue = Value_NG;
            else
            {
                drop.Items.Add(new ListItem("Nước ngoài", Value_NG));
                drop.SelectedValue = Value_NG;
            }
        }
        protected void chkONuocNgoai_CheckedChanged(object sender, EventArgs e)
        {
            if (ddlND_Quoctich.SelectedValue == QuocTichVN.ToString())
            {
                DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
                Decimal ParentID = 0;
                DataTable tbl = obj.GetAllByParentID(ParentID);
                dropCaNhan_TamTru_Tinh.Items.Clear();
                dropCaNhan_TamTru_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
                LoadDMHanhChinh(dropCaNhan_TamTru_Tinh, tbl);

                dropCaNhan_TamTru_QuanHuyen.Items.Clear();
                dropCaNhan_TamTru_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện--", "0"));
                if (chkONuocNgoai.Checked)
                {
                    Add_ValueNG(dropCaNhan_TamTru_Tinh);
                    lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = false;
                }
                else
                    lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = true;
            }
            else
            {
                dropCaNhan_TamTru_QuanHuyen.SelectedIndex = 0;
                Add_ValueNG(dropCaNhan_TamTru_Tinh);
                lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = false;
            }
            Cls_Comon.SetFocus(this, this.GetType(), dropCaNhan_TamTru_Tinh.ClientID);
        }

        //---------------------------------------
        protected void cmdClose_Click(object sender, EventArgs e)
        {
            //int IsReloadParent = (string.IsNullOrEmpty(hddReloadParent.Value)) ? 0 : Convert.ToInt16(hddReloadParent.Value);
            //if(IsReloadParent==1)
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
            //else
            //    Cls_Comon.CallFunctionJS(this, this.GetType(), "window.close();");
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            try
            {
                if (!CheckValid())
                    return;
                string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();

                decimal ID = (string.IsNullOrEmpty(hddDuongSuID.Value + "")) ? 0 : Convert.ToDecimal(hddDuongSuID.Value);
                DONKK_DON_DUONGSU oND;
                if (ID == 0)
                    oND = new DONKK_DON_DUONGSU();
                else
                    oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();

                oND.DONKKID = CurrDonKK;
                oND.ISDON = 1;
                oND.DUONGSUID = 0;
                oND.STOPVB = 0;
                oND.TENDUONGSU = Cls_Comon.FormatTenRieng(txtTenDuongSu.Text.Trim());
                oND.ISDAIDIEN = 0;
                oND.TUCACHTOTUNG_MA = ddlTucachTotung.SelectedValue;
                if (LoaiDuongSu == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
                {
                    oND.ISDAIDIEN = 1;
                    oND.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                }

                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                oND.SOCMND = txtND_CMND.Text;
                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);

                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;
                oND.THANGSINH = 0;
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.NGUOIDAIDIEN = txtToChuc_NguoiDD.Text;
                oND.CHUCVU = txtToChuc_NguoiDD_ChucVu.Text;
                oND.EMAIL = txtEmail.Text;
                oND.DIENTHOAI = txtDienthoai.Text;
                oND.SINHSONG_NUOCNGOAI = chkONuocNgoai.Checked == true ? 1 : 0;
                oND.FAX = txtFax.Text;

                //----------------------
                if (oND.LOAIDUONGSU == 1)
                {
                    try
                    {
                        if (dropCaNhan_TamTru_Tinh.SelectedValue != Value_NG)
                        {
                            oND.TAMTRUTINHID = oND.HKTTTINHID = Convert.ToDecimal(dropCaNhan_TamTru_Tinh.SelectedValue);
                            oND.TAMTRUID = oND.HKTTID = Convert.ToDecimal(dropCaNhan_TamTru_QuanHuyen.SelectedValue);
                        }
                        else
                        {
                            oND.TAMTRUTINHID = oND.HKTTTINHID = oND.TAMTRUID = oND.HKTTID = 0;
                        }
                    }
                    catch (Exception exx) { oND.TAMTRUID = 0; }
                    oND.TAMTRUCHITIET = oND.HKTTCHITIET = txtCaNhan_TamTru_DiaChiCT.Text;

                    oND.DIACHICOQUAN = txtCaNhan_DiaChiCoQuan.Text.Trim() + "";
                }

                //----------------------
                try
                {
                    oND.NDD_DIACHIID = Convert.ToDecimal(dropToChuc_QuanHuyen.SelectedValue);
                }
                catch (Exception exx) { oND.NDD_DIACHIID = 0; }
                oND.NDD_DIACHICHITIET = txtToChuc_DiaChiCT.Text;

                //----------------------             
                oND.TUCACHTOTUNG = ddlTucachTotung.SelectedItem.Text;
                oND.MALOAIVUVIEC = Request["loaivv"] + "";
                if (ID == 0)
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.NGUOITAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    dt.DONKK_DON_DUONGSU.Add(oND);
                    dt.SaveChanges();

                    if (CurrDonKK > 0)
                        GhiLog("THEM", oND.TENDUONGSU);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    dt.SaveChanges();
                    if (CurrDonKK > 0)
                        GhiLog("SUA", oND.TENDUONGSU);
                }

                //---------------------------
                try
                {
                    DONKK_DON_DUONGSU_BL oDonBL = new DONKK_DON_DUONGSU_BL();
                    oDonBL.Update_YeuToNuocNgoai(CurrDonKK, QuocTichVN);
                }
                catch (Exception ex) { }

                //-------------------
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";

                hddReloadParent.Value = "1";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        private void ResetControls()
        {
            txtTenDuongSu.Text = "";
            txtND_CMND.Text = "";
            txtND_Ngaysinh.Text = "";
            chkONuocNgoai.Checked = false;
            txtND_Namsinh.Text = "";
            txtCaNhan_TamTru_DiaChiCT.Text = "";
            txtCaNhan_DiaChiCoQuan.Text = "";
            txtToChuc_NguoiDD.Text = "";
            txtEmail.Text = txtDienthoai.Text = txtFax.Text = "";
            hddDuongSuID.Value = "0";
        }

        private bool CheckValid()
        {
            if (txtTenDuongSu.Text == "")
            {
                lbthongbao.Text = "Chưa nhập tên đương sự";
                return false;
            }
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                string tucachtt = Request["loaids"].ToString();

                if (tucachtt == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON || tucachtt == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
                {
                    if (txtND_Namsinh.Text == "")
                    {
                        lbthongbao.Text = "Chưa nhập năm sinh";
                        return false;
                    }
                }

                //if (lblBatbuoc1.Text != "")
                //{
                //    if (hddND_HKTTID.Value == "")
                //    {
                //        lbthongbao.Text = "Chưa chọn nơi đăng ký HKTT";
                //        return false;
                //    }
                //    if (hdd_ND_TramtruID.Value == "")
                //    {
                //        lbthongbao.Text = "Chưa chọn nơi đăng ký tạm trú";
                //        return false;
                //    }
                //}
            }
            return true;
        }

        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
            DateTime now = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);

            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                if (d > now)
                {
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", "Ngày sinh không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                    Cls_Comon.SetFocus(this, this.GetType(), txtND_Ngaysinh.ClientID);
                }
                else
                {
                    txtND_Namsinh.Text = d.Year.ToString();
                    // chkONuocNgoai.Focus();
                    Cls_Comon.SetFocus(this, this.GetType(), chkONuocNgoai.ClientID);
                }
            }
        }
        protected void txtND_Namsinh_TextChanged(object sender, EventArgs e)
        {
            int namsinh = 0;
            if (!String.IsNullOrEmpty(txtND_Ngaysinh.Text))
            {
                if (!String.IsNullOrEmpty(txtND_Namsinh.Text))
                {
                    namsinh = Convert.ToInt32(txtND_Namsinh.Text);
                    DateTime date_temp;
                    date_temp = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (date_temp != DateTime.MinValue)
                    {
                        String ngaysinh = txtND_Ngaysinh.Text.Trim();
                        String[] arr = ngaysinh.Split('/');

                        txtND_Ngaysinh.Text = arr[0] + "/" + arr[1] + "/" + namsinh.ToString();
                    }
                }
            }
            if (!String.IsNullOrEmpty(txtND_Namsinh.Text))
            {
                namsinh = Convert.ToInt32(txtND_Namsinh.Text);
                if (namsinh > DateTime.Now.Year)
                {
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", "Năm sinh không thể lớn hơn Năm hiện tại. Hãy kiểm tra lại!");
                    Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                }
            }
            Cls_Comon.SetFocus(this, this.GetType(), chkONuocNgoai.ClientID);
        }

        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (ddlLoaiNguyendon.SelectedValue)
            {
                case "1":
                    lblHoTen.Text = "Họ tên";
                    break;
                case "2":
                    lblHoTen.Text = "Tên cơ quan";
                    break;
                case "3":
                    lblHoTen.Text = "Tên tổ chức";
                    break;
            }
            lttCheckCMND.Text = "";
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
                if (TypeDuongSu == "NGUYENDON" || TypeDuongSu == "UYQUYEN" || TypeDuongSu == "NGUOIUYQUYEN")
                {
                    lttCheckCMND.Text = "<span class='batbuoc' id='span_CMND'>*</span>";
                }
                if (String.IsNullOrEmpty(txtTenDuongSu.Text.Trim()))
                    Cls_Comon.SetFocus(this, this.GetType(), txtTenDuongSu.ClientID);
                else
                    Cls_Comon.SetFocus(this, this.GetType(), txtND_CMND.ClientID);
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
                if (String.IsNullOrEmpty(txtTenDuongSu.Text.Trim()))
                    Cls_Comon.SetFocus(this, this.GetType(), txtTenDuongSu.ClientID);
                else
                    Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_Tinh.ClientID);
            }
        }

        //------------------------------
        void LoadThongTinNguoiUyQuyen()
        {
            string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();
            CurrDonKK = (string.IsNullOrEmpty(Request["dkkID"] + "")) ? 0 : Convert.ToDecimal(Request["dkkID"] + "");
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            string CurrUser = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            String MaLoaiVV = Request["loaivv"] + "";
            if (LoaiDuongSu == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
            {
                try
                {
                    DONKK_DON_DUONGSU oND = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == CurrDonKK
                                                                         && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON
                                                                         && x.ISDAIDIEN == 1
                                                                         && x.MALOAIVUVIEC == MaLoaiVV
                                                                         && x.NGUOITAO == CurrUser
                                                                      ).FirstOrDefault();
                    if (oND != null)
                    {
                        hddDuongSuID.Value = oND.ID + "";
                        Load_ThongTinDS(oND);
                    }
                }
                catch (Exception ex) { }
            }
        }

        void loadedit(decimal ID)
        {
            DONKK_DON_DUONGSU oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                hddDuongSuID.Value = oND.ID.ToString();
                Load_ThongTinDS(oND);
            }
        }
        void Load_ThongTinDS(DONKK_DON_DUONGSU oND)
        {
            string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();

            DM_HANHCHINH dm = null;
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();

            dropLoaiDon.SelectedValue = oND.MALOAIVUVIEC;

            txtTenDuongSu.Text = oND.TENDUONGSU;
            ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();
            txtND_CMND.Text = oND.SOCMND;
            ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
            if (LoaiDuongSu == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
                ddlTucachTotung.SelectedValue = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
            else
                ddlTucachTotung.SelectedValue = oND.TUCACHTOTUNG_MA;

            #region Thong tin ca nhan
            //-------------------------------
            ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            if (oND.NGAYSINH != DateTime.MinValue)
                txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
            txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            if (oND.SINHSONG_NUOCNGOAI != null)
                chkONuocNgoai.Checked = oND.SINHSONG_NUOCNGOAI == 1 ? true : false;
            if (ddlND_Quoctich.SelectedIndex > 0)
                chkONuocNgoai.Visible = false;
            else
                chkONuocNgoai.Visible = true;

            try
            {
                dropCaNhan_TamTru_Tinh.SelectedValue = oND.TAMTRUTINHID.ToString();
                dropCaNhan_TamTru_Tinh_SelectedIndexChanged(null, null);
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropCaNhan_TamTru_Tinh.SelectedValue), dropCaNhan_TamTru_QuanHuyen, true);
                dropCaNhan_TamTru_QuanHuyen.SelectedValue = oND.TAMTRUID + "";
            }
            catch (Exception ex) { }
            txtCaNhan_TamTru_DiaChiCT.Text = oND.TAMTRUCHITIET;
            txtCaNhan_DiaChiCoQuan.Text = oND.DIACHICOQUAN;

            #endregion

            //------------------------------------
            #region  Nguoi dai dien cho to chuc-----------------
            try
            {
                dm = gsdt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).Single<DM_HANHCHINH>();
                if (dm != null)
                {
                    dropToChuc_Tinh.SelectedValue = dm.CAPCHAID.ToString();
                    LoadDMHanhChinhByParentID(Convert.ToDecimal(dropToChuc_Tinh.SelectedValue), dropToChuc_QuanHuyen, true);
                    dropToChuc_QuanHuyen.SelectedValue = oND.NDD_DIACHIID + "";
                }
            }

            catch (Exception ex) { }
            txtToChuc_DiaChiCT.Text = oND.NDD_DIACHICHITIET;
            txtToChuc_NguoiDD.Text = oND.NGUOIDAIDIEN;
            txtToChuc_NguoiDD_ChucVu.Text = oND.CHUCVU;
            #endregion

            //--------------------------------
            txtEmail.Text = oND.EMAIL + "";
            txtDienthoai.Text = oND.DIENTHOAI + "";
            txtFax.Text = oND.FAX;

            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
        }

        //------------------------
        #region Load DS
        public void LoadGrid()
        {
            decimal VuAnID = Convert.ToDecimal(hddVuAn.Value);
            string tucachtt = Request["loaids"].ToString();
            String MaLoaiVuViec = Request["loaivv"] + "";
            string CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            DONKK_DON_DUONGSU_BL oBL = new DONKK_DON_DUONGSU_BL();
            DataTable tbl = oBL.GetDuongSuByUser(UserID, CurrDonKK, tucachtt, MaLoaiVuViec);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = tbl.Rows.Count;
                hddTotalPage.Value = count_all.ToString();

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pnDanhSach.Visible = true;
            }
            else
            {
                pnDanhSach.Visible = false;
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    //loadedit(ND_id);
                    string para = "?loaivv=" + Request["loaivv"].ToString()
                        + "&loaids=" + Request["loaids"].ToString()
                        + "&dsID=" + ND_id;
                    Response.Redirect("/Personnal/Duongsu.aspx" + para);
                    break;
                case "Xoa":
                    xoa(ND_id);
                    ResetControls();

                    break;
            }
        }
        public void xoa(decimal id)
        {
            String TenDuongSu = "";
            //KT: Neu da co GSTP.DonID --> xoa trong phan GSTP 
            //ko co --> xoa trong DOnKK
            DONKK_DON_DUONGSU oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            decimal DONID = (decimal)oND.DONKKID;
            TenDuongSu = oND.TENDUONGSU;
            if (oND.ISDAIDIEN == 1)
            {
                lbthongbao.Text = "Không được xóa đương sự đại diện.";
                return;
            }

            dt.DONKK_DON_DUONGSU.Remove(oND);
            dt.SaveChanges();
            //-------------------------
            if (oND.DONKKID > 0)
            {
                //chi khi edit DonKK thi moi ghi log
                String Key = "XOA";
                GhiLog(Key, TenDuongSu);
            }
            //-------------------------
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
            DONKK_DON_DUONGSU_BL oDonBL = new DONKK_DON_DUONGSU_BL();
            oDonBL.Update_YeuToNuocNgoai(DONID, QuocTichVN);
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {

            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion
        #endregion


        void GhiLog(String Key, string tenduongsu)
        {
            try
            {
                String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
                decimal UserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                String Detail_Action = CurrUserName;
                DONKK_DON objDonKK = dt.DONKK_DON.Where(x => x.ID == CurrDonKK).Single<DONKK_DON>();

                String KeyLog = Key + "DUONGSU";
                switch (Key)
                {
                    case "XOA":
                        Detail_Action = "Xóa";
                        break;
                    case "THEM":
                        Detail_Action = "Thêm mới";
                        break;
                    case "SUA":
                        Detail_Action = "Sửa thông tin";
                        break;
                }
                //-----------------------------
                string ma_tucach_tt = ddlTucachTotung.SelectedValue;
                switch (ma_tucach_tt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        Detail_Action += " " + "người bị kiện";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        Detail_Action += " " + "người khởi kiện";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.UYQUYEN:
                        Detail_Action += " " + "người ủy quyền";
                        break;
                    default:
                        Detail_Action += " " + "đương sự khác";
                        break;
                }
                Detail_Action += ": " + tenduongsu + "<br/>";

                //--------------
                Detail_Action += "- Vụ việc:<br/>";
                Detail_Action += "+ Số đơn khởi kiện:" + objDonKK.ID + "<br/>";
                Detail_Action += "+ Số vụ việc:" + objDonKK.VUANID + "<br/>";
                Detail_Action += "+ Mã vụ việc:" + objDonKK.MAVUVIEC + "<br/>";
                Detail_Action += "+ Tên vụ việc:" + objDonKK.TENVUVIEC;
                //--------------
                Detail_Action += "+ Lĩnh vực: ";
                switch (objDonKK.MALOAIVUAN)
                {
                    case ENUM_LOAIAN.AN_DANSU:
                        Detail_Action += "Dân sự";
                        break;
                    case ENUM_LOAIAN.AN_HANHCHINH:
                        Detail_Action += "Hành chính";
                        break;
                    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                        Detail_Action += "Hôn nhân & Gia đình";
                        break;
                    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                        Detail_Action += "Kinh doanh & Thương mại";
                        break;
                    case ENUM_LOAIAN.AN_LAODONG:
                        Detail_Action += "Lao động";
                        break;
                    case ENUM_LOAIAN.AN_PHASAN:
                        Detail_Action += "Phá sản";
                        break;
                }
                DONKK_USER_HISTORY_BL objBL = new DONKK_USER_HISTORY_BL();
                objBL.WriteLog(UserID, KeyLog, Detail_Action);
            }
            catch (Exception ex) { }
        }

    }
}