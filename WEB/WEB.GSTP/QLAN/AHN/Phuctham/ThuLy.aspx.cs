using BL.GSTP;
using BL.GSTP.AHN;
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
using System.Web.Script.Serialization;
using System.Text.RegularExpressions;
using BL.GSTP.BANGSETGET.SYSTEM_LOG;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.AHN.Phuctham
{
    public partial class ThuLy : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private decimal magiaidoan = ENUM_GIAIDOANVUAN.PHUCTHAM;
        private decimal loaian = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH);

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    ddlSothuly.Visible = false;
                    ddlStlPhu.Visible = false;

                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id);
                    CheckShowCommand(ID);
                    LoadCombobox();

                    hddPageIndex.Value = "1";
                    LoadNguoiKyDdlInfo();
                    LoadCbxNguoikiemhoso();
                    LoadGrid();
                    if (dgList.Items.Count == 0)
                    {
                        AHN_DON oT = dt.AHN_DON.Where(x => x.ID == ID).FirstOrDefault();
                        if (oT != null)
                        {
                            ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
                            txtQuanhephapluat_name(oT);
                            if (oT.QHPLTKID != null) ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();
                        }
                        SetNewSoThuLy();
                        SetNewSoThongbao();
                    }
                    else
                    {
                        AHN_PHUCTHAM_BL oBL = new AHN_PHUCTHAM_BL();
                        DataTable oDT = oBL.AHN_PHUCTHAM_THULY_GETLIST(ID);
                        if (oDT != null && oDT.Rows.Count > 0)
                            loadedit(Convert.ToDecimal(oDT.Rows[0]["ID"]));
                    }
                    LoadTHThuyLy(ID);
                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        hddIsShowCommand.Value = "False";
                        return;
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadTHThuyLy(decimal vid)
        {
            //Load Truong hop thu lý
            AHN_DON obj = dt.AHN_DON.Where(x => x.ID == vid).FirstOrDefault();
            if (obj.HINHTHUCNHANDON == 998 || obj.TRUONGHOPTHULY == 1)
            {   // GDT huy
                ddlLoaiThuLy.SelectedValue = "998";
                ddlLoaiThuLy.Enabled = false;
            }
            else
            {
                ddlLoaiThuLy.Enabled = true;
            }
        }
        private void LoadNguoiKyDdlInfo()
        {
            DataTable tbl = null;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            //Lấy danh sách Chánh án, phó chánh án, Chánh VP, Phó chánh VP, Thẩm phán
            tbl = cb_BL.DM_CANBO_GETBYDONVI_THULY(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlNguoiky.DataSource = tbl;
            ddlNguoiky.DataTextField = "MA_TEN";
            ddlNguoiky.DataValueField = "ID";
            ddlNguoiky.DataBind();
        }
        private void LoadCbxNguoikiemhoso()
        {
            //Load cán bộ kiểm hồ sơ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlCanbokiemhoso.Items.Clear();

            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanbokiemhoso.DataSource = oCBDT;
            ddlCanbokiemhoso.DataTextField = "MA_TEN";
            ddlCanbokiemhoso.DataValueField = "ID";
            ddlCanbokiemhoso.DataBind();
            ddlCanbokiemhoso.Items.Insert(0, new ListItem("--Chọn người kiểm hồ sơ--", "0"));
            //Set mặc định cán bộ login
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlCanbokiemhoso.SelectedValue = strCBID;
            }
            catch { }
        }
        private void CheckShowCommand(decimal DonID)
        {
            AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (oT != null)
            {
                //Kiểm tra có kháng cáo, kháng nghị hay không?
                AHN_SOTHAM_BL objST = new AHN_SOTHAM_BL();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && objST.AHN_SOTHAM_KCaoKNghi_GETLIST(DonID).Rows.Count == 0)
                {
                    lbthongbao.Text = "Chưa có kháng cáo/ kháng nghị !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
            }
            AHN_PHUCTHAM_BANAN ba = dt.AHN_PHUCTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                lbthongbao.Text = "Đã có bản án phúc thẩm. Không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
        }
        private decimal SetNewSoThuLy()
        {
            ////Số thụ lý mới
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            if (String.IsNullOrEmpty(txtNgaythuly.Text))
                txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            //Số thụ lý mới
            DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            string sothulymoi = oSTBL.GET_STL_NEW(DonViID, "AHN_PT", ngaythuly).ToString();

            if (!ddlSothuly.Items.Contains(new ListItem(sothulymoi)))
            {
                ddlSothuly.Items.Add(new ListItem(sothulymoi));
            }

            if (ddlSothuly.Items.Count == 1)
            {
                ddlSothuly.SelectedValue = sothulymoi;
            }
            else
            {
                ddlSothuly.Items.Add(new ListItem(""));
                ddlSothuly.SelectedValue = "";
            }

            ddlStlPhu_AddItems();

            txtSoThuly.Text = sothulymoi;

            SetNewSoThongbao();

            return Convert.ToDecimal(sothulymoi);
        }
        void SetNewSoThongbao()
        {
            ////Số thụ lý mới
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            //So thong bao
            if (String.IsNullOrEmpty(txtNgaythongbao.Text))
                txtNgaythongbao.Text = DateTime.Now.ToString("dd/MM/yyyy");


            DateTime ngaythongbao = DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            txtSothongbao.Text = oSTBL.GET_STBTL_NEW(DonViID, "AHN_PT", ngaythongbao).ToString();

        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                LinkButton lbtXoaSothulyKhongSuDungLai = (LinkButton)e.Item.FindControl("lbtXoaSothulyKhongSuDungLai");
                Cls_Comon.SetLinkButton(lbtXoaSothulyKhongSuDungLai, oPer.XOA);

                lbtXoaSothulyKhongSuDungLai.Visible = false;

                string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT != null)
                {
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                        lbtXoaSothulyKhongSuDungLai.Visible = false;
                    }
                }
                //Tong dat roi khong duoc xao
                decimal vFILEID = Convert.ToDecimal(rowView["FILEID"]);
                AHN_FILE oF = dt.AHN_FILE.Where(x => x.ID == vFILEID).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                        lbtXoaSothulyKhongSuDungLai.Visible = false;
                    }
                }
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }

                if (!Convert.ToBoolean(hddIsShowCommand.Value))
                {
                    lbtXoa.Visible = lblSua.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
                }

                string toagiaiquyetID = e.Item.Cells[8].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
                }

                ////check vu an ket thuc de thong bao khong cho sua
                //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                //if (anKetThuc)
                //{
                //    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                //    Cls_Comon.SetButton(cmdUpdate, false);
                //    Cls_Comon.SetButton(cmdLammoi, false);
                //    hddIsShowCommand.Value = "False";
                //    lblSua.Visible = false;
                //    lbtXoa.Visible = false;
                //    lbtXoaSothulyKhongSuDungLai.Visible = false;
                //}
            }
        }
        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU_HNGD, ENUM_DANHMUC.QUANHEPL_TRANHCHAP_HNGD);

            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HONNHAN_GIADINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            //Load trường hợp thụ lý
            DM_DATAGROUP oGTHTL = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOP_GIAONHAN).FirstOrDefault();
            List<DM_DATAITEM> lstTHGN = dt.DM_DATAITEM.Where(x => x.GROUPID == oGTHTL.ID && (x.MA == "02" || x.MA == "03" || x.MA == "04" || x.MA == "10")).ToList();
            ddlLoaiThuLy.Items.Clear();
            ddlLoaiThuLy.DataSource = lstTHGN;
            ddlLoaiThuLy.DataTextField = "TEN";
            ddlLoaiThuLy.DataValueField = "ID";
            ddlLoaiThuLy.DataBind();
        }
        private void ResetControls()
        {
            txtQuanhephapluat.Text = getQHPL_NAME_DON();
            ddlQuanhephapluat.SelectedIndex = 0;

            txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            SetNewSoThuLy();
            ddlStlPhu_AddItems();

            txtSothongbao.Text = "";
            txtNgaythongbao.Text = "";

            ddlNguoiky.SelectedIndex = 0;
            ddlCanbokiemhoso.SelectedIndex = 0;

            txtSoButLuc.Text = "";
            hddid.Value = "0";

            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            lbtDownload.Visible = false;
            cbUTTP.Checked = false;
        }
        private bool CheckValid()
        {
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lbthongbao.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lbthongbao.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lbthongbao.Text = "Chưa chọn quan hệ pháp luật dùng cho thống kê !";
                return false;
            }
            decimal IDChitieuTK = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
            if (dt.DM_QHPL_TK.Where(x => x.PARENT_ID == IDChitieuTK).ToList().Count > 0)
            {
                lbthongbao.Text = "Quan hệ pháp luật dùng cho thống kê chỉ được chọn mã con, bạn hãy chọn lại !";
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaythuly.Text) == false)
            {
                lbthongbao.Text = "Ngày thụ lý chưa nhập hoặc không hợp lệ!";
                txtNgaythuly.Focus();
                return false;
            }

            //if (ddlSothuly.Text == "")
            //{
            //    lbthongbao.Text = "Chưa chọn số thụ lý";
            //    return false;
            //}
            if (!Regex.IsMatch(txtSoThuly.Text, @"^\d"))
            {
                lbthongbao.Text = "Số thụ lý phải bắt đầu bằng ký tự số";
                return false;
            }
            if (txtSoThuly.Text == "")
            {
                lbthongbao.Text = "Chưa nhập số thụ lý";
                return false;
            }

            DateTime dNgayTL = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayTL > DateTime.Now)
            {
                lbthongbao.Text = "Ngày thụ lý không được lớn hơn ngày hiện tại !";
                txtNgaythuly.Focus();
                return false;
            }
            if (ddlNguoiky.SelectedValue == "")
            {
                lbthongbao.Text = "Bạn chưa chọn người ký. Hãy kiểm tra lại!";
                ddlNguoiky.Focus();
                return false;
            }

            //string sothuly = ddlSothuly.SelectedValue;
            
            //if (!String.IsNullOrEmpty(txtNgaythuly.Text))
            //{
            //    DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            //    Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "AHN_PT", sothuly, ngaythuly);
            //    if (CheckID > 0)
            //    {
            //        Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
            //        String strMsg = "";
            //        String STTNew = oSTBL.GET_STL_NEW(DonViID, "AHN_PT", ngaythuly).ToString();
            //        if (CheckID != CurrThuLyID)
            //        {
            //            //lbthongbao.Text = "Số thụ lý này đã có!";
            //            strMsg = "Số thụ lý " + sothuly + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
            //            ddlSothuly.Items.Add(new ListItem(STTNew));
            //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
            //            ddlSothuly.Focus();
            //            return false;
            //        }
            //    }
            //}
            string sothuly = txtSoThuly.Text;

            if (!String.IsNullOrEmpty(txtNgaythuly.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "AHN_PT", sothuly, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STL_NEW(DonViID, "AHN_PT", ngaythuly).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        //lbthongbao.Text = "Số thụ lý này đã có!";
                        strMsg = "Số thụ lý " + sothuly + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoThuly.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoThuly.Focus();
                        return false;
                    }
                }
            }
            //So thong bao----------------------------
            string sothongbao = txtSothongbao.Text;
            if (!String.IsNullOrEmpty(txtNgaythuly.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTBTLTheoLoaiAn(DonViID, "AHN_PT", sothongbao, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STBTL_NEW(DonViID, "AHN_PT", ngaythuly).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        //lbthongbao.Text = "Số thụ lý này đã có!";
                        strMsg = "Số Thông báo thụ lý " + txtSothongbao.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSothongbao.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSothongbao.Focus();
                        return false;
                    }
                }
            }
            //Ngay thong bao----------------------------
            if (String.IsNullOrEmpty(txtNgaythongbao.Text))
            {
                String strMsg = "";
                strMsg = "Chưa nhập Ngày Thông báo";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                txtNgaythongbao.Focus();
                return false;
            }
            //----------------------------
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHN_DON oDon = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;
                AHN_PHUCTHAM_THULY oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND = new AHN_PHUCTHAM_THULY();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHN_PHUCTHAM_THULY.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                    if (oND != null && oND.TOA_GIAIQUYET_ID != Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                    {
                        lbthongbao.Text = "Không có quyền sửa thụ lý này.";
                        return;
                    }
                    // - vnpt 1/12/2025  check tong dat
                    AHN_TONGDAT oTD = dt.AHN_TONGDAT.Where(x => x.DONID == oND.DONID && x.MAPID == oND.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHN_PHUCTHAM_THULY).FirstOrDefault();
                    if (oTD != null)
                    {
                        lbthongbao.Text = "Bạn không thể sửa khi đã tống đạt!";
                        return;
                    }
                }
                oND.DONID = DONID;
                oND.TRUONGHOPTHULY = Convert.ToDecimal(ddlLoaiThuLy.SelectedValue);

                oND.NGAYTHULY = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.SOTHULY = ddlSothuly.SelectedValue + ddlStlPhu.SelectedValue;
                oND.SOTHULY = txtSoThuly.Text;

                oND.SOTHONGBAO = txtSothongbao.Text;
                oND.NGUOIKYID = Convert.ToDecimal(ddlNguoiky.SelectedValue);
                oND.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.NGUOIKIEMHOSOID = Convert.ToDecimal(ddlCanbokiemhoso.SelectedValue);
                oND.SOBUTLUC = txtSoButLuc.Text.Trim();

                oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);

                oND.QUANHEPHAPLUATID = null;
                oND.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;

                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                if (cbUTTP.Checked)
                    oND.UTTPDI = 1;
                else
                    oND.UTTPDI = 0;

                STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
                oQLSTL.update_STPT_QUANLY_SOTHULY(3, 3, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul), Regex.Match(oND.SOTHULY, @"\d+").Value);

                AHN_DON_BL objDBL = new AHN_DON_BL();
                decimal rFileID = UploadFileID(oDon, FileID, "65-DS", oND.SOTHONGBAO);
                if (rFileID > 0) oND.FILEID = rFileID;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    AHN_PHUCTHAM_BL oPTBL = new AHN_PHUCTHAM_BL();
                    oND.TT = oPTBL.THULYPTQDK_GETNEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])); 
                    oND.MATHULY = "P" + ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH + Session[ENUM_SESSION.SESSION_MADONVI] + oND.TT.ToString();
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
                    { oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); }
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHN_PHUCTHAM_THULY.Add(oND);
                    dt.SaveChanges();
                    //Cập nhật lại trạng thái vụ việc

                    oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                    hddid.Value = oND.ID.ToString();
                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("3", DONID, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
                lbthongbao.Text = "Lưu thành công!";
                // ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
        public void LoadGrid()
        {
            AHN_PHUCTHAM_BL oBL = new AHN_PHUCTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.AHN_PHUCTHAM_THULY_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), dgList.PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }

        public void loadedit(decimal ID)
        {
            AHN_PHUCTHAM_THULY oND = dt.AHN_PHUCTHAM_THULY.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                //txtMaThuLy.Text = oND.MATHULY;
                try
                {
                    ddlLoaiThuLy.SelectedValue = oND.TRUONGHOPTHULY.ToString();
                }
                catch { }
                hddid.Value = oND.ID.ToString();
                if (oND.NGAYTHULY != null) txtNgaythuly.Text = ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul);

                txtSoThuly.Text = oND.SOTHULY;

                ddlSothuly.Items.Clear();
                string ddlSothuly_Add = Regex.Match(oND.SOTHULY, @"\d+").Value;
                ddlSothuly.Items.Add(new ListItem(ddlSothuly_Add));
                ddlSothuly.SelectedValue = ddlSothuly_Add;

                ddlStlPhu_AddItems();
                string stlphu = oND.SOTHULY.ToString().Replace(ddlSothuly.SelectedValue, "");

                if (stlphu.Length != 0)
                {
                    if (!ddlStlPhu.Items.Contains(new ListItem(stlphu)))
                    {
                        ddlStlPhu.Items.Add(new ListItem(stlphu));
                    }
                    ddlStlPhu.SelectedValue = stlphu;
                }

                ddlLoaiQuanhe.SelectedValue = oND.LOAIQUANHE.ToString();
                ddlNguoiky.SelectedValue = oND.NGUOIKYID + "";

                if (oND.NGUOIKIEMHOSOID != null)
                {
                    ddlCanbokiemhoso.SelectedValue = oND.NGUOIKIEMHOSOID + "";
                }
                txtSoButLuc.Text = oND.SOBUTLUC + "";

                txtQuanhephapluat_name(oND);
                if (oND.QHPLTKID != null)
                    ddlQHPLTK.SelectedValue = oND.QHPLTKID.ToString();

                if ((oND.FILEID + "") != "" && (oND.FILEID + "") != "0")
                {
                    AHN_FILE objFile = dt.AHN_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                    if (objFile.TENFILE != null) lbtDownload.Visible = true;
                }
                else
                    lbtDownload.Visible = false;
                txtSothongbao.Text = oND.SOTHONGBAO + "";
                if (oND.NGAYTHONGBAO != null) txtNgaythongbao.Text = ((DateTime)oND.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);
                
                if (oND.UTTPDI == 1)
                    cbUTTP.Checked = true;
                else
                    cbUTTP.Checked = false;

            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Download":
                        var oND = dt.AHN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        break;
                    case "Sua":
                        AHN_PHUCTHAM_THULY oND1 = dt.AHN_PHUCTHAM_THULY.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND1 != null)
                        {
                            // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                            AHN_TONGDAT oTD1 = dt.AHN_TONGDAT.Where(x => x.DONID == oND1.DONID && x.MAPID == oND1.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHN_PHUCTHAM_THULY).FirstOrDefault();
                            if (oTD1 != null)
                            {
                                lbthongbao.Text = "Bạn không thể sửa khi đã tống đạt!";
                                return;
                            }
                        }
                        
                        lbthongbao.Text = "";
                        loadedit(ND_id);
                        hddid.Value = e.CommandArgument.ToString();
                        break;

                    case "Xoa":
                        AHN_PHUCTHAM_THULY oND2 = dt.AHN_PHUCTHAM_THULY.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND2 != null)
                        {
                            // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                            AHN_TONGDAT oTD2 = dt.AHN_TONGDAT.Where(x => x.DONID == oND2.DONID && x.MAPID == oND2.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHN_PHUCTHAM_THULY).FirstOrDefault();
                            if (oTD2 != null)
                            {
                                lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                                return;
                            }
                        }
                        pnCapnhat_Tieude.Text = "XÓA SỐ THỤ LÝ";
                        hddXoa_SelectedIndex.Value = "1";
                        hddThulyID.Value = ND_id.ToString();
                        mp1.Show();
                        ddlLydoXoa();
                        break;

                    case "XoaSothulyKhongSuDungLai":
                        AHN_PHUCTHAM_THULY oND3 = dt.AHN_PHUCTHAM_THULY.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND3 != null)
                        {
                            // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                            AHN_TONGDAT oTD2 = dt.AHN_TONGDAT.Where(x => x.DONID == oND3.DONID && x.MAPID == oND3.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHN_PHUCTHAM_THULY).FirstOrDefault();
                            if (oTD2 != null)
                            {
                                lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
                                return;
                            }
                        }
                        pnCapnhat_Tieude.Text = "XÓA SỐ THỤ LÝ VÀ KHÔNG SỬ DỤNG LẠI";
                        hddXoa_SelectedIndex.Value = "2";
                        hddThulyID.Value = ND_id.ToString();
                        mp1.Show();
                        ddlLydoXoa();
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadCombobox(); }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlQuanhephapluat_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal IDQHPL = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
            DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
            DM_DATAGROUP oGroup = dt.DM_DATAGROUP.Where(x => x.ID == obj.GROUPID).FirstOrDefault();
            if (oGroup.MA == ENUM_DANHMUC.QUANHEPL_TRANHCHAP)
                ddlLoaiQuanhe.SelectedValue = "1";
            else
                ddlLoaiQuanhe.SelectedValue = "2";
        }
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            decimal FileID = Convert.ToDecimal(hddFileid.Value);
            AHN_FILE oND = dt.AHN_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        private decimal UploadFileID(AHN_DON oDon, decimal FileID, string strMaBieumau, string STT)
        {
            AHN_DON_BL oBL = new AHN_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            AHN_FILE objFile = new AHN_FILE();
            if (FileID > 0)
            {
                objFile = dt.AHN_FILE.Where(x => x.ID == FileID).FirstOrDefault();

            }
            objFile.DONID = oDon.ID;
            objFile.TOAANID = oDon.TOAANID;
            objFile.MAGIAIDOAN = 3;
            objFile.LOAIFILE = 0;
            objFile.BIEUMAUID = IDBM;
            objFile.NAM = DateTime.Now.Year;
            if (hddFilePath.Value != "")
            {
                try
                {
                    string strFilePath = "";
                    if (chkKySo.Checked)
                    {
                        string[] arr = hddFilePath.Value.Split('/');
                        strFilePath = arr[arr.Length - 1];
                        strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                    }
                    else
                        strFilePath = hddFilePath.Value.Replace("/", "\\");
                    byte[] buff = null;
                    using (FileStream fs = File.OpenRead(strFilePath))
                    {
                        BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        long numBytes = oF.Length;
                        buff = br.ReadBytes((int)numBytes);
                        objFile.NOIDUNG = buff;
                        objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(strTenBM) + oF.Extension;
                        objFile.KIEUFILE = oF.Extension;
                    }
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { lbthongbao.Text = ex.Message; }
            }
            objFile.NGAYTAO = DateTime.Now;
            objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            if (FileID == 0)
            {
                if (STT != "") objFile.STT = oBL.GETFILENEWTT((decimal)objFile.TOAANID, (decimal)objFile.MAGIAIDOAN, DateTime.Now.Year, (decimal)objFile.LOAIFILE);
                //objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.AHN_FILE.Add(objFile);
            }
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }

        private string getDATAITEM(decimal DONID)
        {
            AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();

            decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
            DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
            if (obj != null) return obj.TEN.ToString();
            else return "";
        }
        private void txtQuanhephapluat_name(AHN_DON oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null) txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
                txtQuanhephapluat.Text = null;
        }
        private void txtQuanhephapluat_name(AHN_PHUCTHAM_THULY oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null) txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
            {
                AHN_DON oTT = dt.AHN_DON.Where(x => x.ID == oT.DONID).FirstOrDefault();
                txtQuanhephapluat_name(oTT);
            }
        }
        public string getQHPL_NAME_DON()
        {
            decimal DONID = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
            AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (oT.QUANHEPHAPLUAT_NAME != null && oT.QUANHEPHAPLUAT_NAME != "")
            {
                return oT.QUANHEPHAPLUAT_NAME.ToString();
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null) return obj.TEN.ToString();
                else return "";
            }
            else
            {
                return "";
            }
        }

        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            //try
            //{
            //    ddlSothuly.Items.Clear();

            //    STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
            //    DataTable dtStl = oQLSTL.get_STPT_QUANLY_SOTHULY(3, 3, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), txtNgaythuly.Text);
            //    if (dtStl != null)
            //    {
            //        ddlSothuly.DataSource = dtStl;
            //        ddlSothuly.DataTextField = "SOTHULY";
            //        ddlSothuly.DataValueField = "SOTHULY";
            //        ddlSothuly.DataBind();

            //        ddlSothuly.Items.Add(new ListItem(""));
            //        ddlSothuly.SelectedValue = "";
            //    }

            //    string check_ngaythulycuoi_trongnam = oQLSTL.get_LATEST_DATE_IN_SOTHULY(3, 3, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), txtNgaythuly.Text);

            //    DateTime check_ngaythulycuoi = DateTime.Parse(check_ngaythulycuoi_trongnam.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    if (check_ngaythulycuoi <= DateTime.Parse(txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
            //    {
            //        SetNewSoThuLy();
            //    }
            //}
            //catch
            //{
            //    lbthongbao.Text = "Lỗi lấy danh sách Số thụ lý!";
            //}
        }
        protected void txtNgaythongbao_TextChanged(object sender, EventArgs e)
        {
            SetNewSoThongbao();
        }

        protected void btnSaveLydoXoa_Insert(object sender, EventArgs e)
        {
            if (hddThulyID.Value == "0")
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }

            decimal ND_id = Convert.ToDecimal(hddThulyID.Value + "");
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            AHN_PHUCTHAM_THULY oND = dt.AHN_PHUCTHAM_THULY.Where(x => x.ID == ND_id).FirstOrDefault();

            if (oPer.XOA == false || cmdUpdate.Enabled == false)
            {
                lbthongbao.Text = "Bạn không có quyền xóa!";
                return;
            }

            if (oND != null)
            {
                //reset_TENVUVIEC(Convert.ToDecimal(oND.DONID));

                decimal FileID = 0;
                if (oND.FILEID != null) FileID = (decimal)oND.FILEID;


                //Anhpn 
                var currenttoaid = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
                AHN_DON_THAMPHAN AHN_DON_THAMPHAN = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM && x.TOA_GIAIQUYET_ID == currenttoaid).FirstOrDefault<AHN_DON_THAMPHAN>();
                if (AHN_DON_THAMPHAN != null)
                {
                    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin phân công thẩm phán giải quyết.";
                    return;
                }
                AHN_PHUCTHAM_THAMGIATOTUNG AHN_PHUCTHAM_THAMGIATOTUNG = dt.AHN_PHUCTHAM_THAMGIATOTUNG.Where(x => x.DONID == DONID && x.TOA_GIAIQUYET_ID == currenttoaid).FirstOrDefault<AHN_PHUCTHAM_THAMGIATOTUNG>();
                if (AHN_PHUCTHAM_THAMGIATOTUNG != null)
                {
                    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại người tham gia tố tụng.";
                    return;
                }
                AHN_PHUCTHAM_HDXX AHN_PHUCTHAM_HDXX = dt.AHN_PHUCTHAM_HDXX.Where(x => x.DONID == DONID && x.TOA_GIAIQUYET_ID == currenttoaid).FirstOrDefault<AHN_PHUCTHAM_HDXX>();
                if (AHN_PHUCTHAM_HDXX != null)
                {
                    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin người tiến hành tố tụng.";
                    return;
                }
                AHN_PHUCTHAM_HOAGIAI AHN_PHUCTHAM_HOAGIAI = dt.AHN_PHUCTHAM_HOAGIAI.Where(x => x.DONID == DONID && x.TOA_GIAIQUYET_ID == currenttoaid).FirstOrDefault<AHN_PHUCTHAM_HOAGIAI>();
                if (AHN_PHUCTHAM_HOAGIAI != null)
                {
                    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin hòa giải.";
                    return;
                }
                AHN_PHUCTHAM_QUYETDINH AHN_PHUCTHAM_QUYETDINH = dt.AHN_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DONID && x.TOA_GIAIQUYET_ID == currenttoaid).FirstOrDefault<AHN_PHUCTHAM_QUYETDINH>();
                if (AHN_PHUCTHAM_QUYETDINH != null)
                {
                    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại quyết định vụ việc.";
                    return;
                }
                AHN_PHUCTHAM_BANAN AHN_PHUCTHAM_BANAN = dt.AHN_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault<AHN_PHUCTHAM_BANAN>();
                if (AHN_PHUCTHAM_BANAN != null)
                {
                    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại bản án.";
                    return;
                }
                
                LICHSU_XOA_SOTHULY oLS = new LICHSU_XOA_SOTHULY();
                if (oLS.insert_LICHSU_XOA_SOTHULY(magiaidoan, ND_id, loaian, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), Session[ENUM_SESSION.SESSION_USERNAME] + "", ddlLydoXoaSothuly.SelectedItem.ToString(), DONID) == false)
                {
                    lbthongbao.Text = "Xóa không thành công!";
                    return;
                }

                if (Convert.ToDecimal(Regex.Match(oND.SOTHULY, @"\d+").Value) == SetNewSoThuLy())
                {
                    hddXoa_SelectedIndex.Value = "0";
                }

                STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
                if (oQLSTL.insert_STPT_QUANLY_SOTHULY(magiaidoan, loaian, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul),
                                                    Regex.Match(oND.SOTHULY, @"\d+").Value, Convert.ToDecimal(ddlLydoXoaSothuly.SelectedValue), ddlLydoXoaSothuly.SelectedItem.ToString(),
                                                    Session[ENUM_SESSION.SESSION_USERNAME] + "", Session[ENUM_SESSION.SESSION_USERTEN] + "", Convert.ToDecimal(hddXoa_SelectedIndex.Value + ""), DONID) == false)
                {
                    lbthongbao.Text = "Xóa không thành công!";
                    return;
                }
 
                dt.AHN_PHUCTHAM_THULY.Remove(oND);
                dt.SaveChanges();
                if (FileID > 0)
                {
                    try
                    {
                        AHN_FILE objf = dt.AHN_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                        dt.AHN_FILE.Remove(objf);
                        dt.SaveChanges();
                    }
                    catch (Exception ex) { }
                }
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
            }

            lbthongbao.Text = "Xóa thành công!";
            
            hddXoa_SelectedIndex.Value = "0";
            hddThulyID.Value = "0";
        }
        protected void ddlStlPhu_AddItems()
        {
            ddlStlPhu.Items.Clear();
            ddlStlPhu.Items.Add(new ListItem(""));
            ddlStlPhu.Items.Add(new ListItem("A"));
            ddlStlPhu.Items.Add(new ListItem("B"));
            ddlStlPhu.Items.Add(new ListItem("C"));
            ddlStlPhu.Items.Add(new ListItem("D"));
            ddlStlPhu.Items.Add(new ListItem("E"));
        }
        protected void ddlLydoXoa()
        {
            string maLydoxoa = "";
            if(hddXoa_SelectedIndex.Value == "1")
            {
                maLydoxoa = "LYDOXOATHULY";
            }
            else if (hddXoa_SelectedIndex.Value == "2")
            {
                maLydoxoa = "LYDOXOASOTHULY";
            }

            ddlLydoXoaSothuly.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(maLydoxoa);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlLydoXoaSothuly.DataSource = tbl;
                ddlLydoXoaSothuly.DataTextField = "TEN";
                ddlLydoXoaSothuly.DataValueField = "ID";
                ddlLydoXoaSothuly.DataBind();

            }
        }

        protected void btnLichsuXoaThuly_Click(object sender, EventArgs e)
        {
            mdLichsuXoaThuly.Show();
            loadGrid_LichsuXoaThuly();
        }
        protected void loadGrid_LichsuXoaThuly()
        {
            dgLichsuXoaThuly.Visible = true;
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
            List<LICHSU_XOA_SOTHULY> obj = DataExtensions.GetAllWithClause<LICHSU_XOA_SOTHULY>($"LOAIAN = {loaian} AND MAGIAIDOAN = {magiaidoan} AND TOAAN_ID = {Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])} and DONID = {DonID}");
            if (obj != null && obj.Count > 0)
            {
                dgLichsuXoaThuly.DataSource = obj;
                dgLichsuXoaThuly.DataBind();
            }
        }

    }
}