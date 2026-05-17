using BL.GSTP;
using BL.GSTP.APS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.SYSTEM_LOG;
using BL.GSTP.TP_THADS;
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

namespace WEB.GSTP.QLAN.APS.Sotham
{
    public partial class ThuLy : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private decimal magiaidoan = ENUM_GIAIDOANVUAN.SOTHAM;
        private decimal loaian = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ddlSothuly.Visible = false;
                ddlStlPhu.Visible = false;

                hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";

                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Hoso/Danhsach.aspx");

                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                decimal ID = Convert.ToDecimal(current_id);
                CheckShowCommand(ID);
                LoadCombobox();
                LoadGrid();

                txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
                if (dgList.Items.Count == 0)
                {
                    APS_DON oT = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
                    if (oT != null)
                    {
                        ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
                        ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();
                        if (oT.QHPLTKID != null) ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();
                    }
                    SetNewSoThuLy();
                    SetNewSoThongbao();
                }
                else
                {
                    APS_SOTHAM_BL oBL = new APS_SOTHAM_BL();
                    DataTable oDT = oBL.APS_SOTHAM_THULY_GETLIST(ID);
                    //if (oDT != null && oDT.Rows.Count > 0)
                    //    loadedit(Convert.ToDecimal(oDT.Rows[0]["ID"]));
                }
                LoadTHThuyLy(ID);
                LoadNguyenDon(ID);
                LoadBiDon(ID);
            }
        }
        private void LoadNguyenDon(decimal donID)
        {
            ddlNguyenDon.Items.Clear();
            //Load nguyên đơn 
            APS_DON_DUONGSU_BL oBL = new APS_DON_DUONGSU_BL();
            DataTable tb = oBL.APS_THULY_NGUYENDON(donID);
            if (tb.Rows.Count > 0)
            {
                ddlNguyenDon.DataSource = tb;
                ddlNguyenDon.DataTextField = "TENDUONGSU";
                ddlNguyenDon.DataValueField = "ID";
                ddlNguyenDon.DataBind();
            }
            else
            {
                ddlNguyenDon.Items.Insert(0, new ListItem("-- Chọn --", "0"));
                //lbthongbao.Text = "Vụ việc chưa có biên lai án phí !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
            }
        }
        private void LoadBiDon(decimal donID)
        {
            ddlBiDon.Items.Clear();
            //Load bị đơn 
            List<APS_DON_DUONGSU> tb = dt.APS_DON_DUONGSU.Where(x => x.DONID == donID && x.TUCACHTOTUNG_MA == "DNHTXBITUYENBOPS").OrderByDescending(x => x.ISDAIDIEN).ToList();
            if (tb.Count > 0)
            {
                ddlBiDon.DataSource = tb;
                ddlBiDon.DataTextField = "TENDUONGSU";
                ddlBiDon.DataValueField = "ID";
                ddlBiDon.DataBind();
            }
            else ddlBiDon.Items.Insert(0, new ListItem("-- Chọn --", "0"));
        }
        private void LoadTHThuyLy(decimal vid)
        {
            //Load Truong hop thu lý
            APS_DON obj = dt.APS_DON.Where(x => x.ID == vid).FirstOrDefault();
            if (obj.HINHTHUCNHANDON == 270)
            {   // Phúc tham huy
                ddlLoaiThuLy.SelectedValue = "3";
                ddlLoaiThuLy.Enabled = false;
            }
            else if (obj.HINHTHUCNHANDON == 1758)
            {
                //GDT huy
                ddlLoaiThuLy.SelectedValue = "3";
                ddlLoaiThuLy.Enabled = false;
            }
            else
            {
                ddlLoaiThuLy.Enabled = true;
            }
        }
        private void CheckShowCommand(decimal DonID)
        {
            APS_DON oT = dt.APS_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (oT != null)
            {
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
            }
            //Kiểm tra bản án Quyết định - HIEUVM
            APS_SOTHAM_QUYETDINH qd = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == DonID && (x.LOAIQDID == 3 || x.LOAIQDID == 10 || x.LOAIQDID == 11 || x.LOAIQDID == 21)).FirstOrDefault();
            if (qd != null)
            {
                lbthongbao.Text = "Đã có bản án - quyết định. Không được sửa đổi!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
            //Kiểm tra Đơn đã trả lại đơn chưa
            if (dt.APS_DON_XULY.Where(x => x.DONID == DonID && x.LOAIGIAIQUYET == 3).ToList().Count > 0)
            {
                lbthongbao.Text = "Đơn đã trả lại, không được phép thụ lý !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
            if (dt.APS_DON_XULY.Where(x => x.DONID == DonID && x.LOAIGIAIQUYET == 5).ToList().Count == 0)
            {
                lbthongbao.Text = "Đơn chưa được giải quyết tại chức năng Giải quyết đơn !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
            APS_SOTHAM_BANAN ba = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                lbthongbao.Text = "Đã có quyết định tuyên bố phá sản. Không được sửa đổi!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
        }
        private decimal SetNewSoThuLy()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //Số thụ lý mới
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            if (String.IsNullOrEmpty(txtNgaythuly.Text))
                txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            string sothulymoi = oSTBL.GET_STL_NEW(DonViID, "APS", ngaythuly).ToString();

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

            return Convert.ToDecimal(sothulymoi);
        }
        private void SetNewSoThongbao()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            //So thong bao
            if (String.IsNullOrEmpty(txtNgaythongbao.Text))
                txtNgaythongbao.Text = DateTime.Now.ToString("dd/MM/yyyy");
            DateTime ngaythongbao = DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            txtSothongbao.Text = oSTBL.GET_STBTL_NEW(DonViID, "APS", ngaythongbao).ToString();
        }
        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAUPS);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
        }
        private void ResetControls()
        {
            APS_SOTHAM_BL oSTBL = new APS_SOTHAM_BL();

            txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            SetNewSoThuLy();
            ddlStlPhu_AddItems();

            txtSothongbao.Text = "";
            txtNgaythongbao.Text = "";

            hddid.Value = "0";
            lbtDownload.Visible = false;
            cbUTTP.Checked = false;
            LoadNguyenDon(Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + ""));
            LoadBiDon(Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + ""));
            decimal donID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");
            APS_SOTHAM_THULY tl = dt.APS_SOTHAM_THULY.Where(x => x.DONID == donID).FirstOrDefault();
            if (tl != null)
            {
                ddlQuanhephapluat.Enabled = ddlLoaiThuLy.Enabled = ddlNguyenDon.Enabled = ddlBiDon.Enabled = cbUTTP.Enabled = ddlQHPLTK.Enabled = false;
            }
        }
        private bool CheckValid()
        {
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
                lbthongbao.Text = "Ngày thụ lý chưa nhập hoặc không hợp lệ !";
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
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
            List<APS_DON_XULY> lstGQD = dt.APS_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 5).ToList();
            if (lstGQD.Count > 0)
            {
                APS_DON_XULY oDXL = lstGQD[0];
                if (dNgayTL < oDXL.NGAYGQ_YC)
                {
                    lbthongbao.Text = "Ngày thụ lý không được trước ngày giải quyết đơn '" + ((DateTime)oDXL.NGAYGQ_YC).ToString("dd/MM/yyyy") + "' !";
                    txtNgaythuly.Focus();
                    return false;
                }
            }

            //string sothuly = ddlSothuly.SelectedValue;

            //APS_SOTHAM_THULY tl = dt.APS_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
            //if (!String.IsNullOrEmpty(txtNgaythuly.Text) && tl == null)
            //{
            //    DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            //    Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "APS", sothuly, ngaythuly);
            //    if (CheckID > 0)
            //    {
            //        Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
            //        String strMsg = "";
            //        String STTNew = oSTBL.GET_STL_NEW(DonViID, "APS", ngaythuly).ToString();

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

            APS_SOTHAM_THULY tl = dt.APS_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
            if (!String.IsNullOrEmpty(txtNgaythuly.Text) && tl == null)
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "APS", sothuly, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STL_NEW(DonViID, "APS", ngaythuly).ToString();

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
                Decimal CheckID = oSTBL.CheckSoTBTLTheoLoaiAn(DonViID, "APS", sothongbao, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STBTL_NEW(DonViID, "APS", ngaythuly).ToString();
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
                strMsg = "Chưa nhập ngày Thông báo";
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
                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                APS_DON oDon = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;
                APS_SOTHAM_THULY oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND = new APS_SOTHAM_THULY();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.APS_SOTHAM_THULY.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                }
                oND.DONID = DONID;
                //oND.MATHULY = "";
                oND.TRUONGHOPTHULY = Convert.ToDecimal(ddlLoaiThuLy.SelectedValue);

                oND.NGAYTHULY = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.SOTHULY = ddlSothuly.SelectedValue + ddlStlPhu.SelectedValue;
                oND.SOTHULY = txtSoThuly.Text;

                oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oND.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oND.SOTHONGBAO = txtSothongbao.Text;
                oND.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oND.GHICHU = txtGhichu.Text;
                if (cbUTTP.Checked)
                    oND.UTTPDI = 1;
                else
                    oND.UTTPDI = 0;

                ADS_DON_BL objDBL = new ADS_DON_BL();
                decimal rFileID = UploadFileID(oDon, FileID, "30-DS", oND.SOTHONGBAO);
                if (rFileID > 0) oND.FILEID = rFileID;
                APS_SOTHAM_BL oBL = new APS_SOTHAM_BL();
                DataTable oDT = oBL.APS_SOTHAM_THULY_GETLIST(DONID);

                STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
                if (oQLSTL.update_STPT_QUANLY_SOTHULY(2, 7, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul), Regex.Match(oND.SOTHULY, @"\d+").Value) == false)
                {
                    lbthongbao.Text = "Lưu không thành công!";
                    return;
                }

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    if (oDT != null && oDT.Rows.Count > 0)
                    {
                        lbthongbao.Text = "Đã có thông tin thụ lý. Không thể thêm mới !";
                        return;
                    }
                    else
                    {
                        APS_SOTHAM_BL oSTBL = new APS_SOTHAM_BL();
                        oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        oND.TT = oSTBL.THULY_GETNEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        oND.MATHULY = "S" + ENUM_LOAIVUVIEC.AN_PHASAN + Session[ENUM_SESSION.SESSION_MADONVI] + oND.TT.ToString();
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.APS_SOTHAM_THULY.Add(oND);
                        dt.SaveChanges();
                        //Cập nhật lại trạng thái vụ việc

                        oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        dt.SaveChanges();
                        //anhvh add 26/06/2020
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        GD.GAIDOAN_INSERT_UPDATE("7", DONID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                        //------------
                    }
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                //Cap nhat nguyen don dai dien và bi don dai dien
                decimal idNDmoi = Convert.ToDecimal(ddlNguyenDon.SelectedValue);
                decimal idBDmoi = Convert.ToDecimal(ddlBiDon.SelectedValue);
                APS_DON_DUONGSU ndcu = dt.APS_DON_DUONGSU.Where(x => x.DONID == DONID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == "NGUOIYEUCAUPS").FirstOrDefault();
                APS_DON_DUONGSU bdcu = dt.APS_DON_DUONGSU.Where(x => x.DONID == DONID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == "DNHTXBITUYENBOPS").FirstOrDefault();
                APS_DON_DUONGSU ndmoi = dt.APS_DON_DUONGSU.Where(x => x.ID == idNDmoi).FirstOrDefault();
                APS_DON_DUONGSU bdmoi = dt.APS_DON_DUONGSU.Where(x => x.ID == idBDmoi).FirstOrDefault();
                if (idNDmoi != ndcu.ID)
                {
                    ndcu.ISDAIDIEN = 0;
                    ndmoi.ISDAIDIEN = 1;
                }
                if (idBDmoi != bdcu.ID)
                {
                    bdcu.ISDAIDIEN = 0;
                    bdmoi.ISDAIDIEN = 1;
                }
                if (idNDmoi != ndcu.ID || idBDmoi != bdcu.ID)
                {
                    APS_DON don = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    don.TENVUVIEC = ndmoi.TENDUONGSU + " - " + bdmoi.TENDUONGSU + " - " + don.QUANHEPHAPLUAT_NAME;
                    dt.SaveChanges();
                    Page.Response.Redirect(Page.Request.Url.ToString(), true);
                }
                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                //--------------------------
                TUPHAP_QLA_BL oBLs = new TUPHAP_QLA_BL();
                oBLs.CHECK_ENABLE_THULY(DONID, "7");
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        public void LoadGrid()
        {
            APS_SOTHAM_BL oBL = new APS_SOTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.APS_SOTHAM_THULY_GETLIST(ID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
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
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }

        public void loadedit(decimal ID)
        {
            APS_SOTHAM_THULY oND = dt.APS_SOTHAM_THULY.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            //txtMaThuLy.Text = oND.MATHULY;
            ddlLoaiThuLy.SelectedValue = oND.TRUONGHOPTHULY.ToString();
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
            ddlQuanhephapluat.SelectedValue = oND.QUANHEPHAPLUATID.ToString();
            if (oND.QHPLTKID != null)
                ddlQHPLTK.SelectedValue = oND.QHPLTKID.ToString();
            hddFileid.Value = oND.FILEID + "";
            if ((oND.FILEID + "") != "" && (oND.FILEID + "") != "0")
            {
                APS_FILE objFile = dt.APS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                if (objFile.TENFILE != null) lbtDownload.Visible = true;
            }
            else
                lbtDownload.Visible = false;
            txtSothongbao.Text = oND.SOTHONGBAO + "";
            if (oND.NGAYTHONGBAO != null) txtNgaythongbao.Text = ((DateTime)oND.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);

            if (oND.UTTPDI == 1)
                cbUTTP.Checked = true;
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Download":
                    var oND = dt.APS_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;

                case "Xoa":

                    hddXoa_SelectedIndex.Value = "1";
                    hddThulyID.Value = ND_id.ToString();
                    mp1.Show();
                    ddlLydoXoa();
                    break;

                case "XoaSothulyKhongSuDungLai":

                    hddXoa_SelectedIndex.Value = "2";
                    hddThulyID.Value = ND_id.ToString();
                    mp1.Show();
                    ddlLydoXoa();
                    break;
            }

        }

        protected void ddlQuanhephapluat_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal IDQHPL = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
            DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
            DM_DATAGROUP oGroup = dt.DM_DATAGROUP.Where(x => x.ID == obj.GROUPID).FirstOrDefault();
            if (oGroup.MA == ENUM_DANHMUC.QUANHEPL_TRANHCHAP_HNGD)
                ddlLoaiQuanhe.SelectedValue = "1";
            else
                ddlLoaiQuanhe.SelectedValue = "2";
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

                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                APS_DON oT = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
                }

                /* Nếu đã có Phân công thẩm phán, Người tiến hành TT, Bản án sơ thẩm thì không cho sửa xóa thụ lý*/
                int CheckBanAnST = (string.IsNullOrEmpty(rowView["CheckBanAnST"] + "")) ? 0 : Convert.ToInt16(rowView["CheckBanAnST"] + "");
                int CheckPhanCongTP = (string.IsNullOrEmpty(rowView["CheckPhanCongTP"] + "")) ? 0 : Convert.ToInt16(rowView["CheckPhanCongTP"] + "");
                int CheckNguoiTienHanhTT = (string.IsNullOrEmpty(rowView["CheckNguoiTienHanhTT"] + "")) ? 0 : Convert.ToInt16(rowView["CheckNguoiTienHanhTT"] + "");

                if (CheckBanAnST > 0 || CheckPhanCongTP > 0 || CheckNguoiTienHanhTT > 0 || hddIsShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
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

                //Tong dat roi khong duoc xao
                decimal vFILEID = Convert.ToDecimal(rowView["FILEID"]);
                APS_FILE oF = dt.APS_FILE.Where(x => x.ID == vFILEID).FirstOrDefault();
                if (oF != null)
                {
                    if (oF.TENFILE != null)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                        lbtXoaSothulyKhongSuDungLai.Visible = false;
                    }
                }

                List<APS_SOTHAM_THULY> check_button_xoa = dt.APS_SOTHAM_THULY.Where(x => x.DONID == DONID).ToList();
                if (check_button_xoa.Count >= 2)
                {
                    lbtXoa.Visible = true;
                    lbtXoaSothulyKhongSuDungLai.Visible = true;
                }
            }
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
            APS_FILE oND = dt.APS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        private decimal UploadFileID(APS_DON oDon, decimal FileID, string strMaBieumau, string STT)
        {
            APS_DON_BL oBL = new APS_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            APS_FILE objFile = new APS_FILE();
            if (FileID > 0)
            {
                objFile = dt.APS_FILE.Where(x => x.ID == FileID).FirstOrDefault();

            }
            objFile.DONID = oDon.ID;
            objFile.TOAANID = oDon.TOAANID;
            objFile.MAGIAIDOAN = oDon.MAGIAIDOAN;
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
                dt.APS_FILE.Add(objFile);
            }
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }

        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            //try
            //{
            //    ddlSothuly.Items.Clear();

            //    STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
            //    DataTable dtStl = oQLSTL.get_STPT_QUANLY_SOTHULY(2, 7, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), txtNgaythuly.Text);
            //    if (dtStl != null)
            //    {
            //        ddlSothuly.DataSource = dtStl;
            //        ddlSothuly.DataTextField = "SOTHULY";
            //        ddlSothuly.DataValueField = "SOTHULY";
            //        ddlSothuly.DataBind();
            //    }

            //    string check_ngaythulycuoi_trongnam = oQLSTL.get_LATEST_DATE_IN_SOTHULY(2, 7, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), txtNgaythuly.Text);

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
            APS_SOTHAM_THULY oND = dt.APS_SOTHAM_THULY.Where(x => x.ID == ND_id).FirstOrDefault();
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");

            List<APS_SOTHAM_THULY> check_button_xoa = dt.APS_SOTHAM_THULY.Where(x => x.DONID == DonID).ToList();

            if ((oPer.XOA == false || cmdUpdate.Enabled == false) && (check_button_xoa.Count < 2))
            {
                lbthongbao.Text = "Bạn không có quyền xóa!";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "" && (check_button_xoa.Count < 2))
            {
                lbthongbao.Text = Result;
                return;
            }
            
            LICHSU_XOA_SOTHULY oLS = new LICHSU_XOA_SOTHULY();
            if (oLS.insert_LICHSU_XOA_SOTHULY(magiaidoan, ND_id, loaian, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), Session[ENUM_SESSION.SESSION_USERNAME] + "", ddlLydoXoaSothuly.SelectedItem.ToString(), DonID) == false)
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
                                                Session[ENUM_SESSION.SESSION_USERNAME] + "", Session[ENUM_SESSION.SESSION_USERTEN] + "", Convert.ToDecimal(hddXoa_SelectedIndex.Value + ""), DonID) == false)
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }

            decimal FileID = 0;

            if (check_button_xoa.Count < 2 && oND != null)
            {
                DonID = oND.DONID + "" == "" ? 0 : (decimal)oND.DONID;
                #region Kiểm tra dữ liệu liên quan trước khi xóa
                // Kiểm tra 3.4 Quyết định tuyên bố phá sản
                APS_SOTHAM_BANAN ba = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault<APS_SOTHAM_BANAN>();
                if (ba != null)
                {
                    lbthongbao.Text = "Vụ việc đã có quyết định tuyên bố phá sản. Không được xóa.";
                    return;
                }
                // Kiểm tra 3.3 Quyết định công nhận nghị quyết của HNCN thông qua phương án phục hồi hoạt động kinh doanh
                APS_SOTHAM_HN_CHUNO hncn = dt.APS_SOTHAM_HN_CHUNO.Where(x => x.DONID == DonID).FirstOrDefault<APS_SOTHAM_HN_CHUNO>();
                if (hncn != null)
                {
                    lbthongbao.Text = "Vụ việc đã có quyết định công nhận nghị quyết của HNCN thông qua phương án phục hồi hoạt động kinh doanh. Không được xóa.";
                    return;
                }
                // Kiểm tra quyết định vụ việc
                APS_SOTHAM_QUYETDINH qd = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == DonID).FirstOrDefault<APS_SOTHAM_QUYETDINH>();
                if (qd != null)
                {
                    lbthongbao.Text = "Vụ việc đã có quyết định vụ việc. Không được xóa.";
                    return;
                }
                // Kiểm tra người tiến hành tố tụng
                APS_SOTHAM_HDXX hdxx = dt.APS_SOTHAM_HDXX.Where(x => x.DONID == DonID).FirstOrDefault<APS_SOTHAM_HDXX>();
                if (hdxx != null)
                {
                    lbthongbao.Text = "Vụ việc đã có thông tin người tiến hành tố tụng. Không được xóa.";
                    return;
                }
                // Kiểm tra phân công thẩm phán giải quyết
                APS_DON_THAMPHAN gqst = dt.APS_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault<APS_DON_THAMPHAN>();
                if (gqst != null)
                {
                    lbthongbao.Text = "Vụ việc đã có thông tin phân công thẩm phán giải quyết. Không được xóa.";
                    return;
                }
                #endregion
            }

            if (oND != null)
            {
                if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
            }
            
            //Xoa Thụ lý Sơ thẩm
            dt.APS_SOTHAM_THULY.Remove(oND);
            dt.SaveChanges();
            if (FileID > 0)
            {
                APS_FILE objf = dt.APS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                if (objf != null)
                {
                    dt.APS_FILE.Remove(objf);
                    dt.SaveChanges();
                }
            }
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();

            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            lbthongbao.Text = "Xóa thành công!";

            TUPHAP_QLA_BL oBLs = new TUPHAP_QLA_BL();
            oBLs.CHECK_ENABLE_THULY(DonID, "7");

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
            if (hddXoa_SelectedIndex.Value == "1")
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
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");
            List<LICHSU_XOA_SOTHULY> obj = DataExtensions.GetAllWithClause<LICHSU_XOA_SOTHULY>($"LOAIAN = {loaian} AND MAGIAIDOAN = {magiaidoan} AND TOAAN_ID = {Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])} and DONID = {DonID}");
            if (obj != null && obj.Count > 0)
            {
                dgLichsuXoaThuly.DataSource = obj;
                dgLichsuXoaThuly.DataBind();
            }
        }

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

        #endregion
    }
}