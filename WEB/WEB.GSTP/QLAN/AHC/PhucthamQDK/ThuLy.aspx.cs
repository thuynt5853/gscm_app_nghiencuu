using BL.GSTP;
using BL.GSTP.AHC;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.AHC;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace WEB.GSTP.QLAN.AHC.PhucthamQDK
{
    public partial class ThuLy : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Danhsach.aspx");
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id);
                    CheckShowCommand(ID);
                    LoadCombobox();
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadNguoiKyDdlInfo();
                    LoadQD();
                    LoadGrid();
                    if (dgList.Items.Count == 0)
                    {
                        AHC_DON oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
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
                        AHC_PHUCTHAM_BL oBL = new AHC_PHUCTHAM_BL();
                        DataTable oDT = oBL.AHC_KCKNQDK_PHUCTHAM_THULY_GETLIST(ID);
                        // hoangndh 160725: khong load id cua thu ly cu khi sang toa moi
                        decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        decimal toaGQID = Convert.ToDecimal(oDT.Rows[0]["TOA_GIAIQUYET_ID"]);
                        if (oDT != null && oDT.Rows.Count > 0 && DonViID == toaGQID)
                            loadedit(Convert.ToDecimal(oDT.Rows[0]["ID"]));
                    }
                    LoadTHThuyLy(ID);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void LoadTHThuyLy(decimal vid)
        {
            //Load Truong hop thu lý
            //AHC_DON obj = dt.AHC_DON.Where(x => x.ID == vid).FirstOrDefault();
            //if (obj.HINHTHUCNHANDON == 998 || obj.TRUONGHOPTHULY == 1)
            //{   // GDT huy
            //    ddlLoaiThuLy.SelectedValue = "998";
            //    ddlLoaiThuLy.Enabled = false;
            //}
            //else
            //{
            //    ddlLoaiThuLy.Enabled = true;
            //}
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

        private void CheckShowCommand(decimal DonID)
        {
            AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (oT != null)
            {
                //Kiểm tra có phân công thẩm phán
                AHC_DON_THAMPHAN_BL oBL = new AHC_DON_THAMPHAN_BL();
                DataTable oDT = oBL.AHC_DON_THAMPHAN_GETBY(DonID, ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM);
                if (oDT != null && oDT.Rows.Count > 0)
                {
                    lbthongbao.Text = "Đã phân công thẩm phán, Không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowDetail.Value = "False";
                    return;
                }

                //Kiểm tra có kháng cáo, kháng nghị hay không?
                AHC_SOTHAM_BL objST = new AHC_SOTHAM_BL();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && objST.AHC_SOTHAM_KCaoKNghi_GETLIST(DonID).Rows.Count == 0)
                {
                    lbthongbao.Text = "Chưa có kháng cáo/ kháng nghị !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
                AHC_PHUCTHAM_BANAN ba = dt.AHC_PHUCTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
                if (ba != null)
                {
                    lbthongbao.Text = "Đã có bản án phúc thẩm. Không được sửa đổi !";
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
                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowDetail.Value = "False";
                }
            }
        }

        private void SetNewSoThuLy()
        {
            //Số thụ lý mới
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            if (String.IsNullOrEmpty(txtNgaythuly.Text))
                txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            //Số thụ lý mới
            DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            txtSoThuly.Text = oSTBL.GET_STL_NEW(DonViID, "AHC_PTQDK", ngaythuly).ToString();
            SetNewSoThongbao();
        }

        private void SetNewSoThongbao()
        {
            //Số thụ lý mới
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            //So thong bao
            if (String.IsNullOrEmpty(txtNgaythongbao.Text))
                txtNgaythongbao.Text = DateTime.Now.ToString("dd/MM/yyyy");

            DateTime ngaythongbao = DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            txtSothongbao.Text = oSTBL.GET_STBTL_NEW(DonViID, "AHC_PTQDK", ngaythongbao).ToString();
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
                string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT != null)
                {
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                    }
                }
                //Tong dat roi khong duoc xao
                decimal vFILEID = Convert.ToDecimal(rowView["FILEID"]);
                AHC_FILE oF = dt.AHC_FILE.Where(x => x.ID == vFILEID).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
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
                }

                if (!Convert.ToBoolean(hddShowDetail.Value))
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                string toagiaiquyetID = rowView["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!toagiaiquyetID.Equals(donviID))
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
            }
        }

        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_KHIEUKIEN_HC);

            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            //Load trường hợp thụ lý
            DM_DATAGROUP oGTHTL = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOP_GIAONHAN).FirstOrDefault();
            //List<DM_DATAITEM> lstTHGN = dt.DM_DATAITEM.Where(x => x.GROUPID == oGTHTL.ID && (x.MA == "02" || x.MA == "03" || x.MA == "04" || x.MA == "10")).ToList();

            string cr_id = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            decimal toaanId = Convert.ToDecimal(cr_id);
            string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
            decimal idAn = Convert.ToDecimal(current_id);
            List<AHC_CHUYEN_NHAN_AN> listcna = dt.AHC_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == idAn && x.TOANHANID == toaanId).ToList();
            var idTHGN = listcna.FirstOrDefault().TRUONGHOPGIAONHANID;
            List<DM_DATAITEM> lstTHGN = dt.DM_DATAITEM.Where(x => x.ID == idTHGN).ToList();
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
            SetNewSoThuLy();
            SetNewSoThongbao();
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";

            hddid.Value = "0";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            txtSothongbao.Text = "";
            txtNgaythongbao.Text = "";
            ddlNguoiky.SelectedIndex = 0;
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
            if (!Regex.IsMatch(txtSoThuly.Text, @"^\d"))
            {
                lbthongbao.Text = "Số thụ lý phải bắt đầu bằng ký tự số";
                return false;
            }
            int lengthSoThuLy = txtSoThuly.Text.Trim().Length;//, lengthGhiChu = txtGhichu.Text.Trim().Length;
            if (lengthSoThuLy == 0)
            {
                lbthongbao.Text = "Bạn chưa nhập số thụ lý. Hãy nhập lại!";
                txtSoThuly.Focus();
                return false;
            }
            else if (lengthSoThuLy > 50)
            {
                lbthongbao.Text = "Số thụ lý không nhập quá 50 ký tự. Hãy nhập lại!";
                txtSoThuly.Focus();
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
            //----------------------------
            string sothuly = txtSoThuly.Text;
            if (!String.IsNullOrEmpty(txtNgaythuly.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "AHC_PTQDK", sothuly, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);

                    String strMsg = "";
                    String STTNew = oSTBL.GET_STL_NEW(DonViID, "AHC_PTQDK", ngaythuly).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        //lbthongbao.Text = "Số thụ lý này đã có!";
                        strMsg = "Số thụ lý " + txtSoThuly.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
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
                Decimal CheckID = oSTBL.CheckSoTBTLTheoLoaiAn(DonViID, "AHC_PTQDK", sothongbao, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STBTL_NEW(DonViID, "AHC_PTQDK", ngaythuly).ToString();
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
                string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                AHC_SOTHAM_BL oSTBL = new AHC_SOTHAM_BL();
                decimal FileID = 0;
                AHC_PHUCTHAM_BL oPTBL = new AHC_PHUCTHAM_BL();
                AHC_KCKNQDK_PHUCTHAM_THULY oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND = new AHC_KCKNQDK_PHUCTHAM_THULY();
                    //AHC_DON_BL oBL = new AHC_DON_BL();
                    //oND.SOTHONGBAO = oBL.GETFILENEWTT((decimal)oDon.TOAANID, (decimal)ENUM_GIAIDOANVUAN.PHUCTHAM, DateTime.Now.Year, 0).ToString();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = DataExtensions.FindById<AHC_KCKNQDK_PHUCTHAM_THULY>(ID);
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                }
                oND.DONID = DONID;
                //oND.MATHULY = "";
                oND.TRUONGHOPTHULY = Convert.ToDecimal(ddlLoaiThuLy.SelectedValue);

                oND.NGAYTHULY = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.SOTHULY = txtSoThuly.Text;
                oND.SOTHONGBAO = txtSothongbao.Text;
                oND.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGUOIKYID = Convert.ToDecimal(ddlNguoiky.SelectedValue);
                oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);

                oND.QUANHEPHAPLUATID = null;
                oND.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                //renameTenvuviec(txtQuanhephapluat.Text, DONID);

                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oND.THOIHANTUNGAY = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.THOIHANDENNGAY = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oND.GHICHU = txtGhichu.Text;
                oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (cbUTTP.Checked)
                    oND.UTTPDI = 1;
                else
                    oND.UTTPDI = 0;

                decimal rFileID = UploadFileID(oDon, FileID, "35-HC", oND.SOTHONGBAO);
                if (rFileID > 0) oND.FILEID = rFileID;

                AHC_PHUCTHAM_BL oBL = new AHC_PHUCTHAM_BL();
                DataTable oDT = oBL.AHC_KCKNQDK_PHUCTHAM_THULY_GETLIST(DONID);
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    if (oDT != null && oDT.Rows.Count > 0)
                    {
                        lbthongbao.Text = "Đã có thông tin thụ lý. Không thể thêm mới !";
                        return;
                    } else
                    {
                        oND.TT = oPTBL.THULYPTQDK_GETNEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        oND.MATHULY = "P" + ENUM_LOAIVUVIEC.AN_HANHCHINH + Session[ENUM_SESSION.SESSION_MADONVI] + oND.TT.ToString();
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
                        { oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); }
                        DataExtensions.Insert(oND);
                        //dt.AHC_KCKNQDK_PHUCTHAM_THULY.Add(oND);
                        //dt.SaveChanges();
                        //Cập nhật lại trạng thái vụ việc

                        oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM_QDK;
                        hddid.Value = oND.ID.ToString();
                        //anhvh add 26/06/2020
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_INSERT_UPDATE("6", DONID, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
                    }
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                try
                {
                    if (hddFilePathTL.Value != "")
                    {
                        string strFilePath = hddFilePathTL.Value.Replace("/", "\\");

                        #region Lưu file

                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oND.NOIDUNGFILE = buff;
                            oND.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                            oND.KIEUFILE = oF.Extension;
                        }

                        #endregion Lưu file

                        File.Delete(strFilePath);
                    }
                }
                catch { }
                DataExtensions.Update(oND);
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

        //Toancau them uploadfile
        protected void AsyncFileUpLoad_UploadedCompleteTL(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoadTL.HasFile && dgFile.Items.Count < 1)
                {
                    string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
                    if (extension == ".doc" || extension == ".docx" || extension == ".pdf")
                    {
                        string strFileName = AsyncFileUpLoadTL.FileName;
                        string path = Server.MapPath("~/TempUpload/") + strFileName;
                        AsyncFileUpLoadTL.SaveAs(path);
                        path = path.Replace("\\", "/");
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePathTL.ClientID + "\").value = '" + path + "';", true);
                    }
                    else lbthongbao.Text = "chỉ lưu file .doc";
                }
                else lbthongbao.Text = "Chỉ được chọn 1 file.";
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }

        public void LoadGrid()
        {
            AHC_PHUCTHAM_BL oBL = new AHC_PHUCTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.AHC_KCKNQDK_PHUCTHAM_THULY_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), dgList.PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"

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

        public void xoa(decimal id)
        {
            AHC_KCKNQDK_PHUCTHAM_THULY oND = DataExtensions.FindById<AHC_KCKNQDK_PHUCTHAM_THULY>(id);// dt.AHC_KCKNQDK_PHUCTHAM_THULY.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                //reset_TENVUVIEC(Convert.ToDecimal(oND.DONID));
                decimal FileID = 0;
                if (oND.FILEID != null) FileID = (decimal)oND.FILEID;

                //Luu thong tin Thụ lý Phúc thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var json = new JavaScriptSerializer().Serialize(oND);
                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.DONID), Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH), Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Thụ lý Phúc thẩm an Hanh chính", "Xóa", json) == false)
                {
                    lbthongbao.Text = "Xóa không thành công!";
                    return;
                }//Ket thuc
                 //Xoa Thụ lý Phúc thẩm
                DataExtensions.Delete(oND);
                //dt.AHC_KCKNQDK_PHUCTHAM_THULY.Remove(oND);
                //dt.SaveChanges();
                if (FileID > 0)
                {
                    try
                    {
                        AHC_FILE objf = dt.AHC_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                        dt.AHC_FILE.Remove(objf);
                        dt.SaveChanges();
                    }
                    catch (Exception ex) { }
                }
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
                // Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
        }

        public void loadedit(decimal ID)
        {
            AHC_KCKNQDK_PHUCTHAM_THULY oND = DataExtensions.FindById<AHC_KCKNQDK_PHUCTHAM_THULY>(ID);  //dt.AHC_KCKNQDK_PHUCTHAM_THULY.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                //txtMaThuLy.Text = oND.MATHULY;
                try
                {
                    ddlLoaiThuLy.SelectedValue = oND.TRUONGHOPTHULY.ToString();
                }
                catch (Exception ex) { }
                hddid.Value = oND.ID.ToString();
                if (oND.NGAYTHULY != null) txtNgaythuly.Text = ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                txtSoThuly.Text = oND.SOTHULY;
                ddlLoaiQuanhe.SelectedValue = oND.LOAIQUANHE.ToString();
                ddlNguoiky.SelectedValue = oND.NGUOIKYID + "";
                txtQuanhephapluat_name(oND);
                if (oND.QHPLTKID != null)
                    ddlQHPLTK.SelectedValue = oND.QHPLTKID.ToString();
                if (oND.THOIHANTUNGAY != null) txtTuNgay.Text = ((DateTime)oND.THOIHANTUNGAY).ToString("dd/MM/yyyy", cul);
                if (oND.THOIHANDENNGAY != null) txtDenNgay.Text = ((DateTime)oND.THOIHANDENNGAY).ToString("dd/MM/yyyy", cul);
                //txtGhichu.Text = oND.GHICHU;
                if ((oND.FILEID + "") != "" && (oND.FILEID + "") != "0")
                {
                    AHC_FILE objFile = dt.AHC_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
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
                //  decimal ID = Convert.ToDecimal(hddDonID.Value);
                switch (e.CommandName)
                {
                    case "Download":
                        var oND = DataExtensions.FindById<AHC_KCKNQDK_PHUCTHAM_THULY>(ND_id);
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        break;

                    case "Sua":
                        lbthongbao.Text = "";
                        loadedit(ND_id);
                        hddid.Value = e.CommandArgument.ToString();
                        break;

                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false || cmdUpdate.Enabled == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        xoa(ND_id);
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

        #endregion "Phân trang"

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
            AHC_FILE oND = dt.AHC_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }

        private decimal UploadFileID(AHC_DON oDon, decimal FileID, string strMaBieumau, string STT)
        {
            AHC_DON_BL oBL = new AHC_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            AHC_FILE objFile = new AHC_FILE();
            if (FileID > 0)
            {
                objFile = dt.AHC_FILE.Where(x => x.ID == FileID).FirstOrDefault();
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
                // update 130825
                objFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.AHC_FILE.Add(objFile);
            }
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }

        protected void txtSoThuly_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtSoThuly.Text.Trim()))
            {
                txtSothongbao.Text = txtSoThuly.Text;
            }
        }

        private string getDATAITEM(decimal DONID)
        {
            AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();

            decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
            DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
            if (obj != null) return obj.TEN.ToString();
            else return "";
        }

        private void txtQuanhephapluat_name(AHC_DON oT)
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

        private void txtQuanhephapluat_name(AHC_KCKNQDK_PHUCTHAM_THULY oT)
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
                AHC_DON oTT = dt.AHC_DON.Where(x => x.ID == oT.DONID).FirstOrDefault();
                txtQuanhephapluat_name(oTT);
            }
        }

        public string getQHPL_NAME_DON()
        {
            decimal DONID = Session[ENUM_LOAIAN.AN_HANHCHINH] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
            AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
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

        private void LoadQD()
        {
            string current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
            decimal idAn = Convert.ToDecimal(current_id);
            AHC_CHUYEN_NHAN_AN_BL aHC_CHUYEN_NHAN_AN_BL = new AHC_CHUYEN_NHAN_AN_BL();
            decimal donOld = aHC_CHUYEN_NHAN_AN_BL.getDonIdOld(idAn);

            AHC_SOTHAM_KHANGCAO aHC_SOTHAM_KHANGCAO = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == donOld && x.LOAIKHANGCAO == 2 && x.TINHTRANG_GIAIQUYET != 1).FirstOrDefault();
            AHC_SOTHAM_KHANGNGHI oKN = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == donOld && x.LOAIKN == 2 && x.TINHTRANG_GIAIQUYET != 1).FirstOrDefault();
            if (aHC_SOTHAM_KHANGCAO != null)
            {
                AHC_SOTHAM_QUYETDINH aHC_SOTHAM_QUYETDINH = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.ID == aHC_SOTHAM_KHANGCAO.SOQDBA).FirstOrDefault();
                if (aHC_SOTHAM_QUYETDINH != null)
                {
                    DM_QD_QUYETDINH dM_QD_QUYETDINH = dt.DM_QD_QUYETDINH.Where(x => x.ID == aHC_SOTHAM_QUYETDINH.QUYETDINHID).FirstOrDefault();
                    txtQDST.Text = "Số " + aHC_SOTHAM_QUYETDINH.SOQD + " - " + dM_QD_QUYETDINH.TEN;
                }
            }
            else if (oKN != null)
            {
                AHC_SOTHAM_QUYETDINH aHC_SOTHAM_QUYETDINH = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.ID == oKN.BANANID).FirstOrDefault();
                if (aHC_SOTHAM_QUYETDINH != null)
                {
                    DM_QD_QUYETDINH dM_QD_QUYETDINH = dt.DM_QD_QUYETDINH.Where(x => x.ID == aHC_SOTHAM_QUYETDINH.QUYETDINHID).FirstOrDefault();
                    txtQDST.Text = "Số " + aHC_SOTHAM_QUYETDINH.SOQD + " - " + dM_QD_QUYETDINH.TEN;
                }
            }
        }

        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
        }

        protected void txtNgaythongbao_TextChanged(object sender, EventArgs e)
        {
        }
    }
}