using BL.GSTP;
using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.QLAN.GDTTT.In;
using System.Reflection;
using System.IO;
using GDTTT_DON_YEUCAU_BOSUNG = BL.GSTP.BANGSETGET.GDTTT_DON_YEUCAU_BOSUNG;
using System.Configuration;
using Aspose.Words;
using Aspose.Words.Tables;

namespace WEB.GSTP.QLAN.GDTTT.Hoso.Popup
{
    public partial class YCBoSung : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        Decimal CurrentUserID = 0, CurrDonViID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    string strVID = Request["vid"] + "";
                    if (strVID != "")
                    {
                        string isYCBS = Request["ycbs"] + "";
                        if (isYCBS == "0")
                        {
                            Cls_Comon.SetButton(cmdUpdate, false);
                            Cls_Comon.SetButton(cmdLammoi, false);
                            dgDS.Columns[8].Visible = false;
                            dgDS.Columns[9].Visible = false;
                        }
                        else dgDS.Columns[10].Visible = false;
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal ID = Convert.ToDecimal(strVID);
                        LoadDSTL();
                        LoadLanThu();
                        GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        try
                        {
                            txtSoThongBao.Text = oBL.YC_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Cls_Comon.GetNumber(oDon.BAQD_LOAIAN)).ToString();
                            txtNgayThongBao.Text = DateTime.Now.ToString("dd/MM/yyyy");
                            dropLanThu.SelectedValue = oBL.YC_GETMAXLANTHU(ID).ToString();
                            chkLydoCDDK.Items[0].Selected = oDon.CD_TA_LYDO_ISBAQD == 1 ? true : false;
                            chkLydoCDDK.Items[1].Selected = oDon.CD_TA_LYDO_ISXACNHAN == 1 ? true : false;
                            chkLydoCDDK.Items[2].Selected = oDon.CD_TA_LYDO_ISKHAC == 1 ? true : false;
                            txtNoiDung.Visible = oDon.CD_TA_LYDO_ISKHAC == 1 ? true : false;
                            txtNoiDung.Text = oDon.CD_TA_LYDO_KHAC;
                        }
                        catch (Exception ex) { }
                    }
                }
            }
        }
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        private string getDiaDiem(decimal ToaAnID)
        {
            try
            {
                string strDiadiem = "";
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                strDiadiem = oT.TEN.Replace("Tòa án nhân dân ", "");
                switch (oT.LOAITOA)
                {
                    case "CAPHUYEN":
                        DM_TOAAN opT = dt.DM_TOAAN.Where(x => x.ID == oT.CAPCHAID).FirstOrDefault();
                        strDiadiem = opT.TEN.Replace("Tòa án nhân dân ", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPTINH":
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPCAO":
                        strDiadiem = strDiadiem.Replace("cấp cao", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                }
                return strDiadiem;
            }
            catch (Exception ex) { return ""; }
        }
        private void LoadLanThu()
        {
            dropLanThu.Items.Clear();
            for (int i = 1; i <= 10; i++)
            {
                dropLanThu.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
        }

        private void LoadDSTL()
        {
            string strVID = Request["vid"] + "";
            if (strVID != "")
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                decimal ID = Convert.ToDecimal(strVID);
                dgDS.DataSource = oBL.YEUCAUBOSUNG(ID);
                dgDS.DataBind();
                //Cls_Comon.CallFunctionJS(this, this.GetType(), "window.opener.__doPostBack('UpdtPnlForGrdVw.ClientID', '');");
            }
        }
        private bool CheckValid()
        {
            if (txtNgayThongBao.Text == "" || Cls_Comon.IsValidDate(txtNgayThongBao.Text) == false)
            {
                lbthongbao.Text = "Ngày thông báo chưa nhập hoặc không hợp lệ. Hãy nhập lại!";
                txtNgayThongBao.Focus();
                return false;
            }
            if (txtSoThongBao.Text == "")
            {
                lbthongbao.Text = "Số thông báo chưa nhập. Hãy nhập lại!";
                txtSoThongBao.Focus();
                return false;
            }
            int countAlpha = Regex.Matches(txtSoThongBao.Text.Trim(), @"[a-zA-Z]").Count;
            int countSpecial = Regex.Matches(txtSoThongBao.Text.Trim(), "[~!@#$%^&*()_+{}:\"<>?]").Count;
            char cLast = txtSoThongBao.Text[txtSoThongBao.Text.Trim().Length - 1];
            if (countAlpha > 1 || (countAlpha == 1 && char.IsDigit(cLast)) || countSpecial > 0)
            {
                lbthongbao.Text = "Số thông báo phải là số hoặc hậu tố là chữ cái ( VD: 123, 123A, 123a). Hãy nhập lại!";
                txtSoThongBao.Focus();
                return false;
            }
            if (txtNguoiKy.Text == "")
            {
                lbthongbao.Text = "Người ký chưa nhập. Hãy nhập lại!";
                txtNguoiKy.Focus();
                return false;
            }
            if (chkLydoCDDK.Items[2].Selected)//Lý do khác
            {
                if (txtNoiDung.Text == "")
                {
                    lbthongbao.Text = "Chưa nhập lý  do khác!";
                    txtNoiDung.Focus();
                    return false;
                }
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckValid()) return;
            GDTTT_DON_YEUCAU_BOSUNG oT = new GDTTT_DON_YEUCAU_BOSUNG();
            string strVID = Request["vid"] + "";
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal DONID = Convert.ToDecimal(strVID);
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == DONID).FirstOrDefault();

            if (hddid.Value == "" || hddid.Value == "0")
            {
                oT.ID = 0;
            }
            else
            {
                oT.ID = Convert.ToDecimal(hddid.Value);
            }
            //Check trùng lần thứ
            DataTable obj = oBL.CHECK_YEUCAU_LANTHUTRUNG(oT.ID, DONID, Convert.ToDecimal(dropLanThu.SelectedValue));
            if (obj.Rows.Count > 0)
            {
                lbthongbao.Text = "Lần thứ đã tồn tại. Hãy nhập lại!";
                dropLanThu.Focus();
                return;
            }
            //Check trùng số thông báo
            DataTable objTB = oBL.CHECK_YEUCAU_SOTHONGBAO_TRUNG(oT.ID, DONID, txtSoThongBao.Text.Trim());
            if (objTB.Rows.Count > 0)
            {
                lbthongbao.Text = "Số thông báo đã tồn tại. Hãy nhập lại!";
                dropLanThu.Focus();
                return;
            }
            //Check ngày thông báo
            DataTable objNTB = oBL.CHECK_YEUCAU_NGAYTHONGBAO(oT.ID, DONID, txtNgayThongBao.Text.Trim(), Convert.ToDecimal(dropLanThu.SelectedValue));
            if (objNTB.Rows.Count > 0)
            {
                lbthongbao.Text = "Ngày thông báo không hợp lệ. Hãy nhập lại!";
                txtNgayThongBao.Focus();
                return;
            }

            oT.DONID = DONID;
            oT.LANTHU = Convert.ToDecimal(dropLanThu.SelectedValue);
            oT.NGUOIKY = txtNguoiKy.Text;
            oT.NGAYTHONGBAO = DateTime.Parse(this.txtNgayThongBao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oT.SOTHONGBAO = txtSoThongBao.Text.Trim();
            oT.CD_TA_LYDO_ISBAQD = chkLydoCDDK.Items[0].Selected ? 1 : 0;
            oT.CD_TA_LYDO_ISXACNHAN = chkLydoCDDK.Items[1].Selected ? 1 : 0;
            oT.CD_TA_LYDO_ISKHAC = chkLydoCDDK.Items[2].Selected ? 1 : 0;
            oT.NOIDUNG = txtNoiDung.Text;
            oT.KETQUA = rdbKQ.SelectedValue + "" == "" ? 0 : Convert.ToDecimal(rdbKQ.SelectedValue);
            oT.NOIDUNGKQ = txtNoiDungKQ.Text;
            oT.NGAYBOSUNG = (String.IsNullOrEmpty(txtNgayBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oBL.GDTTT_DON_YEUCAU_BOSUNG_INSERT_UPDAT(oT);
            string mess = "Lưu thành công!";
            lbthongbao.Text = mess;
            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + mess + "');", true);
            LoadDSTL();
            Reset();
        }
        private void Reset()
        {
            string strVID = Request["vid"] + "";
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal DONID = Convert.ToDecimal(strVID);
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == DONID).FirstOrDefault();
            txtNgayThongBao.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSoThongBao.Text = oBL.YC_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Cls_Comon.GetNumber(oDon.BAQD_LOAIAN)).ToString();
            dropLanThu.SelectedValue = oBL.YC_GETMAXLANTHU(DONID).ToString();
            txtNoiDung.Text = oDon.CD_TA_LYDO_KHAC;
            txtNguoiKy.Text = "";
            txtNoiDungKQ.Text = "";
            txtNgayBS.Text = "";
            hddid.Value = "0";
            chkLydoCDDK.Items[0].Selected = oDon.CD_TA_LYDO_ISBAQD == 1 ? true: false;
            chkLydoCDDK.Items[1].Selected = oDon.CD_TA_LYDO_ISXACNHAN == 1 ? true : false;
            chkLydoCDDK.Items[2].Selected = oDon.CD_TA_LYDO_ISKHAC == 1 ? true : false;
            rdbKQ.SelectedValue = "1";
            txtNoiDung.Visible = oDon.CD_TA_LYDO_ISKHAC == 1 ? true : false;
            lbthongbao.Text = "";
            pnYC.Visible = true; pnKQ.Visible = false;
        }
        protected void dgDS_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    pnYC.Visible = true; pnKQ.Visible = false;
                    decimal bsID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    DataTable obj = oBL.GDTTT_DON_YEUCAU_BOSUNG_GETBYID(bsID);
                    hddid.Value = obj.Rows[0]["ID"].ToString();
                    txtNgayThongBao.Text = ((DateTime)obj.Rows[0]["NGAYTHONGBAO"]).ToString("dd/MM/yyyy");
                    txtSoThongBao.Text = obj.Rows[0]["SOTHONGBAO"].ToString();
                    txtNguoiKy.Text = obj.Rows[0]["NGUOIKY"].ToString();
                    //if (obj.Rows[0]["LYDO"].ToString() == "3")
                    //{
                    //    rdbLyDo.SelectedValue = "3";
                    //    txtNoiDung.Text = obj.Rows[0]["NOIDUNG"].ToString();
                    //    txtNoiDung.Visible = true;
                    //}
                    //else
                    //{
                    //    rdbLyDo.SelectedValue = obj.Rows[0]["LYDO"].ToString();
                    //    txtNoiDung.Visible = false;
                    //}
                    chkLydoCDDK.Items[0].Selected = obj.Rows[0]["CD_TA_LYDO_ISBAQD"].ToString() == "1" ? true : false;
                    chkLydoCDDK.Items[1].Selected = obj.Rows[0]["CD_TA_LYDO_ISXACNHAN"].ToString() == "1" ? true : false;
                    chkLydoCDDK.Items[2].Selected = obj.Rows[0]["CD_TA_LYDO_ISKHAC"].ToString() == "1" ? true : false;
                    chkLydoCDDK_SelectedIndexChanged(source, e);
                    txtNoiDung.Text = obj.Rows[0]["NOIDUNG"].ToString();
                    dropLanThu.SelectedValue = obj.Rows[0]["LANTHU"].ToString();
                    if (obj.Rows[0]["KETQUA"].ToString() != "0") rdbKQ.SelectedValue = obj.Rows[0]["KETQUA"].ToString();
                    txtNoiDungKQ.Text = obj.Rows[0]["NOIDUNGKQ"].ToString();
                    if (obj.Rows[0]["NGAYBOSUNG"] + "" != "" && ((DateTime)obj.Rows[0]["NGAYBOSUNG"]).ToString("dd/MM/yyyy") != "01/01/0001")
                        txtNgayBS.Text = ((DateTime)obj.Rows[0]["NGAYBOSUNG"]).ToString("dd/MM/yyyy", cul);
                    break;
                case "KetQua":
                    lbthongbao.Text = "";
                    Cls_Comon.SetButton(cmdUpdate, true);
                    Cls_Comon.SetButton(cmdLammoi, true);
                    string isYCBS = Request["ycbs"] + "";
                    txtNoiDung.Visible = true;
                    txtSoThongBao.Enabled = txtNgayThongBao.Enabled = txtNoiDung.Enabled = txtNguoiKy.Enabled = dropLanThu.Enabled = chkLydoCDDK.Enabled = false;
                    //if (isYCBS == "0")
                    //{
                    //    pnYC.Visible = true;
                    //    txtNoiDung.Visible = true;
                    //    txtSoThongBao.Enabled = txtNgayThongBao.Enabled = txtNoiDung.Enabled = txtNguoiKy.Enabled = dropLanThu.Enabled = rdbLyDo.Enabled = false;
                    //}
                    //else { pnYC.Visible = false; txtNoiDung.Visible = false; }
                    pnKQ.Visible = true;
                    decimal kqID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BL oBLKQ = new GDTTT_DON_BL();
                    DataTable objKQ = oBLKQ.GDTTT_DON_YEUCAU_BOSUNG_GETBYID(kqID);
                    hddid.Value = objKQ.Rows[0]["ID"].ToString();
                    txtNgayThongBao.Text = ((DateTime)objKQ.Rows[0]["NGAYTHONGBAO"]).ToString("dd/MM/yyyy");
                    txtSoThongBao.Text = objKQ.Rows[0]["SOTHONGBAO"].ToString();
                    txtNguoiKy.Text = objKQ.Rows[0]["NGUOIKY"].ToString();
                    chkLydoCDDK.Items[0].Selected = objKQ.Rows[0]["CD_TA_LYDO_ISBAQD"].ToString() == "1" ? true : false;
                    chkLydoCDDK.Items[1].Selected = objKQ.Rows[0]["CD_TA_LYDO_ISXACNHAN"].ToString() == "1" ? true : false;
                    chkLydoCDDK.Items[2].Selected = objKQ.Rows[0]["CD_TA_LYDO_ISKHAC"].ToString() == "1" ? true : false;
                    chkLydoCDDK_SelectedIndexChanged(source, e);
                    txtNoiDung.Text = objKQ.Rows[0]["NOIDUNG"].ToString();
                    dropLanThu.SelectedValue = objKQ.Rows[0]["LANTHU"].ToString();
                    rdbKQ.SelectedValue = objKQ.Rows[0]["KETQUA"].ToString() == "0" ? "1" : objKQ.Rows[0]["KETQUA"].ToString();
                    txtNoiDungKQ.Text = objKQ.Rows[0]["NOIDUNGKQ"].ToString();
                    if (((DateTime)objKQ.Rows[0]["NGAYBOSUNG"]).ToString("dd/MM/yyyy") != "01/01/0001")
                        txtNgayBS.Text = ((DateTime)objKQ.Rows[0]["NGAYBOSUNG"]).ToString("dd/MM/yyyy", cul);
                    break;
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BL oBLDel = new GDTTT_DON_BL();
                    oBLDel.GDTTT_DON_YEUCAU_BOSUNG_DEL(ID);
                    string mess = "Xóa thành công!";
                    //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + mess + "');", true);
                    LoadDSTL();
                    Reset();
                    lbthongbao.Text = mess;
                    break;
                case "ChiTiet":
                    lbthongbao.Text = "";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    pnYC.Visible = true; pnKQ.Visible = true;
                    decimal ctID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BL oBLct = new GDTTT_DON_BL();
                    DataTable objCT = oBLct.GDTTT_DON_YEUCAU_BOSUNG_GETBYID(ctID);
                    hddid.Value = objCT.Rows[0]["ID"].ToString();
                    txtNgayThongBao.Text = ((DateTime)objCT.Rows[0]["NGAYTHONGBAO"]).ToString("dd/MM/yyyy");
                    txtSoThongBao.Text = objCT.Rows[0]["SOTHONGBAO"].ToString();
                    txtNguoiKy.Text = objCT.Rows[0]["NGUOIKY"].ToString();
                    chkLydoCDDK.Items[0].Selected = objCT.Rows[0]["CD_TA_LYDO_ISBAQD"].ToString() == "1" ? true : false;
                    chkLydoCDDK.Items[1].Selected = objCT.Rows[0]["CD_TA_LYDO_ISXACNHAN"].ToString() == "1" ? true : false;
                    chkLydoCDDK.Items[2].Selected = objCT.Rows[0]["CD_TA_LYDO_ISKHAC"].ToString() == "1" ? true : false;
                    chkLydoCDDK_SelectedIndexChanged(source, e);
                    txtNoiDung.Text = objCT.Rows[0]["NOIDUNG"].ToString();
                    dropLanThu.SelectedValue = objCT.Rows[0]["LANTHU"].ToString();
                    rdbKQ.SelectedValue = objCT.Rows[0]["KETQUA"].ToString() == "0" ? "1" : objCT.Rows[0]["KETQUA"].ToString();
                    txtNoiDungKQ.Text = objCT.Rows[0]["NOIDUNGKQ"].ToString();
                    if (((DateTime)objCT.Rows[0]["NGAYBOSUNG"]).ToString("dd/MM/yyyy") != "01/01/0001")
                        txtNgayBS.Text = ((DateTime)objCT.Rows[0]["NGAYBOSUNG"]).ToString("dd/MM/yyyy", cul);
                    break;
            }
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            Reset();
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ChangeCheck();");
        }

        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgDS.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }

        protected void btnNBInThongbao_Click(object sender, EventArgs e)
        {
            if (CurrDonViID != 1)
            {
                string strVID = Request["vid"] + "";
                decimal idYC = Convert.ToDecimal(strVID);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                Session["GDTTT_MABM"] = "NOIBO_THONGBAOLD";            
                DataTable oDT   = oBL.GDTTT_DON_SEARCH(0,null,null,"", "", "", "", "", "", "", "", Session[ENUM_SESSION.SESSION_USERID] + "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, "", "", "", "", null, null, 0, "", 0, 0, "", null,"", "", 0, "", -1, -1, 0, -1, "CVPC", null, null, "," + idYC + ",", -1, 0, null, null, "", -1, -1, 0, DateTime.Now, 0, 0, 0, null, null, 1, 0, 0, "", "", "", -1, 0, 1, 1); 
                if (oDT != null)
                {
                    if (oDT.Rows.Count == 0)
                    {
                        lbthongbao.Text = "Không có đơn kèm công văn";
                        return;
                    }
                    //Thông tin tờ trình
                    DTGDTTT objds = new DTGDTTT();
                    string strTendonvi = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                    DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                    strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                    string strHauto = "";
                    if (oNSD.PHONGBANID != null)
                    {
                        DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                        if (oPB != null)
                        {
                            strDiachi = oPB.DIACHI + "";
                            strHauto = oPB.HAUTOCV + "";
                        }

                    }
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                        strDiadiem = "Hà Nội";
                    else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    string TAND_NHAN_ = "";
                    

                    DataTable oYC = oBL.YEUCAUBOSUNG(idYC);
                    DataRow obj = oDT.Rows[0];
                    bool hasCheck = false;

                    string vLoaiAn = obj["BAQD_LOAIAN"] + "";
                    string vTempFile = "";

                    if (Session["CAP_XET_XU"] + "" == "TOICAO")
                    {
                        TAND_NHAN_ = "TANDTC";
                        vTempFile = "rptThongBaoYCBS.doc";
                    }
                    else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        TAND_NHAN_ = "TANDCC";
                        //PhuongNM yeu cau sua lai Bieu mau YCBS theo loai an 20/02/2025
                        if (vLoaiAn == "1")
                        {
                            vTempFile = "rptThongBaoYCBS_HS.doc";
                        }
                        else if (vLoaiAn == "6")
                        {
                            vTempFile = "rptThongBaoYCBS_HC.doc";
                        }
                        else
                        {
                            vTempFile = "rptThongBaoYCBS_DS.doc";
                        }
                    }



                    string fileName = ConfigurationManager.AppSettings["TemplateWord"] + vTempFile;
                    string saveAs = ConfigurationManager.AppSettings["TemplateWord"] + "rptThongBaoYCBS" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";
                    string fileNameSave = "rptThongBaoYCBS_" + obj["DONGKHIEUNAI"] + ".doc"; ;
                    Document doc = new Document();
                    foreach (DataGridItem Item in dgDS.Items)
                    {
                        CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                        HiddenField hddID = (HiddenField)Item.FindControl("hddID");
                        int index = Convert.ToInt16(hddID.Value);
                        if (chk.Checked)
                        {
                            Document baoCao = new Document(fileName);
                            string loaiGDTTT = obj["LOAIGDTT"].ToString();

                            hasCheck = true;
                            decimal DonID = Convert.ToDecimal(oYC.Rows[index]["DONID"]);
                            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                            strSo = oYC.Rows[index]["SOTHONGBAO"] + "";
                            strNguoiky = oYC.Rows[index]["NGUOIKY"] + "";
                            DateTime dNgayCV = Convert.ToDateTime(oYC.Rows[index]["NGAYTHONGBAO"] + "");
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();

                            DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                            rds.GIOITINH = "";
                            rds.GIOITINHHOA = "";
                            if ((obj["DUNGDONLA"] + "") == "1")
                            {
                                if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                                {
                                    rds.GIOITINH = "ông ";
                                    rds.GIOITINHHOA = "Ông ";
                                }
                                else
                                {
                                    rds.GIOITINH = "bà ";
                                    rds.GIOITINHHOA = "Bà ";
                                }
                            }
                            else if ((obj["DUNGDONLA"] + "") == "2")
                            {
                                rds.GIOITINH = "các ông, bà ";
                                rds.GIOITINHHOA = "Các ông, bà ";
                            }
                            else
                            {
                                rds.GIOITINH = "";
                                rds.GIOITINHHOA = "";
                            }

                            rds.NGUOIGUI = rds.GIOITINH + obj["DONGKHIEUNAI"] + "";
                            rds.DIACHI = obj["Diachigui"] + "";
                            rds.TENDONVI = strTendonvi;
                            bool isDacoSo = false;
                            string loaiBAQD = "",loaiAn = "";
                            if (oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3)
                            {
                                if (strSo != "")
                                {
                                    oT.TB1_SO = reStr(strSo);
                                    if (dNgayCV != DateTime.MinValue)
                                        oT.TB1_NGAY = dNgayCV;
                                    oT.CD_NGUOIKY = strNguoiky;
                                    rds.SOTHONGBAO = reStr(strSo);
                                    rds.NGUOIKY = strNguoiky;
                                    rds.SOTOTRINH = strSo + strHauto;
                                    rds.NGAY = strNgay;
                                    rds.THANG = strThang;
                                    rds.NAM = strNam;
                                    isDacoSo = true;
                                }
                            }
                            if (isDacoSo == false)
                            {
                                rds.SOTHONGBAO = Cls_Comon.toFullNumber(oT.TB1_SO, false) + "";
                                rds.NGUOIKY = oT.CD_NGUOIKY + "";
                                rds.SOTOTRINH = Cls_Comon.toFullNumber(oT.CD_SOCV, false) + "";
                                if (oT.TB1_NGAY != null)
                                {
                                    DateTime dtNTB1 = (DateTime)oT.TB1_NGAY;
                                    rds.NGAY = Cls_Comon.toFullNumber(dtNTB1.Day.ToString(), false);
                                    rds.THANG = Cls_Comon.toFullNumber(dtNTB1.Month.ToString(), true);
                                    rds.NAM = dtNTB1.Year.ToString();
                                }
                            }
                            rds.DIADIEM = strDiadiem;
                            rds.LOAIAN = obj["BAQD_LOAIAN"] + "";
                            if (obj["NGAYGHITRENDON"] != null)
                                rds.NGAYGUIDON = GetDate(obj["NGAYGHITRENDON"]);
                            
                            if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                            {
                                rds.BA_SO = obj["BAQD_SO"] + "";
                                rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                                if (rds.BA_NGAY != "")
                                    rds.BA_NGAY = GetDate(rds.BA_NGAY);
                                rds.BA_TOAXX = obj["TOAXX"] + "";
                                loaiBAQD = "Bản án";
                            }
                            else//QĐKN
                            {
                                rds.BA_SO = obj["BAQD_SO"] + "";
                                rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                                if (rds.BA_NGAY != "")
                                    rds.BA_NGAY = GetDate(rds.BA_NGAY);
                                rds.BA_TOAXX = obj["TOAXX"] + "";
                                loaiBAQD = "Quyết định";
                            }
                            rds.NOIDUNG = "";
                            if ((obj["CD_TA_LYDO_ISBAQD"] + "") == "1")
                            {
                                if (loaiGDTTT.Trim() + "" == "tái thẩm")
                                    rds.NOIDUNG = "- Cung cấp bản sao bản án/quyết định đã có hiệu lực pháp luật và các tài liệu, chứng cứ liên quan đến việc đề nghị tái thẩm.";
                                else
                                    rds.NOIDUNG = "- Cung cấp bản sao bản án/quyết định đã có hiệu lực pháp luật và các tài liệu, chứng cứ liên quan đến việc đề nghị giám đốc thẩm.";
                            }
                            if ((obj["CD_TA_LYDO_ISXACNHAN"] + "") == "1")
                            {
                                if (rds.NOIDUNG != "")
                                    rds.NOIDUNG += "\n";
                                rds.NOIDUNG += "- Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.";
                            }
                            if ((obj["CD_TA_LYDO_ISKHAC"] + "") == "1")
                            {
                                if (rds.NOIDUNG != "")
                                    rds.NOIDUNG += "\n";
                                rds.NOIDUNG += "- " + obj["CD_TA_LYDO_KHAC"];
                            }
                            rds.DIACHIPHONGBAN = strDiachi;
                            rds.BIDANH = obj["BIDANH"] + "";
                            rds.TAND_NHAN = TAND_NHAN_;
                            string capXX = obj["BAQD_CAPXETXU"] + "" == "2"? " sơ thẩm" : " phúc thẩm";
                            switch (rds.LOAIAN)
                            {
                                case "1": loaiAn = " hình sự"; break;
                                case "2": loaiAn = " dân sự"; break;
                                case "3": loaiAn = " hôn nhân và gia đình"; break;
                                case "4": loaiAn = " kinh doanh thương mại"; break;
                                case "5": loaiAn = " lao động"; break;
                                case "6": loaiAn = " hành chính"; break;
                                case "7": loaiAn = " phá sản"; break;
                            }
                            //Tạo file word biểu mẫu   
                            if (loaiGDTTT.Trim() + "" == "")
                            {
                                loaiGDTTT = "giám đốc thẩm/tái thẩm";
                            }
                            string dieu357 = "";
                           
                            if ((obj["BAQD_LOAIAN"] + "") == "6")
                            {
                                if (loaiGDTTT.Trim().ToLower() + "" == "tái thẩm")
                                {
									//PhuongNM - Riêng với CCHN án HC thủ tục Tái thẩm sẽ là điều 280 và điều 282
                                    if((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "4")
                                    {
                                        dieu357 = "Điều 280 và Điều 282 Luật Tố tụng hành chính";
                                    }
                                    else
                                    {
                                        dieu357 = "Điều 258 và Điều 282 Luật Tố tụng hành chính";
                                    }
                                }
                                else
                                {
                                    dieu357 = "khoản 2 Điều 258 Luật Tố tụng hành chính";
                                }

                            }
                            else if ((obj["BAQD_LOAIAN"] + "") == "1")
                            {
                                dieu357 = "quy định của Bộ luật Tố tụng hình sự";
                            }
                            else
                            {
                                if (loaiGDTTT.Trim().ToLower() + "" == "tái thẩm")
                                {
                                    dieu357 = "Điều 351 và Điều 357 Bộ luật Tố tụng dân sự";
                                }
                                else
                                {
                                    dieu357 = "khoản 2 Điều 329 Bộ luật Tố tụng dân sự";
                                }
                            }

                            baoCao.MailMerge.Execute(new[] { "LOAIGDTT" }, new[] { loaiGDTTT });
                            baoCao.MailMerge.Execute(new[] { "DIEU357" }, new[] { dieu357 });
                            baoCao.MailMerge.Execute(new[] { "TENDONVIHOA" }, new[] { rds["TENDONVI"].ToString().ToUpper() });
                            baoCao.MailMerge.Execute(new[] { "TENDONVI" }, new[] { rds.TENDONVI });
                            baoCao.MailMerge.Execute(new[] { "GIOITINHHOA" }, new[] { rds.GIOITINHHOA });
                            baoCao.MailMerge.Execute(new[] { "GIOITINH" }, new[] { rds.GIOITINH });
                            baoCao.MailMerge.Execute(new[] { "NGUOIGUI" }, new[] { rds.NGUOIGUI });
                            baoCao.MailMerge.Execute(new[] { "DIACHI" }, new[] { rds.DIACHI });
                            baoCao.MailMerge.Execute(new[] { "NGAY" }, new[] { rds.NGAY });
                            baoCao.MailMerge.Execute(new[] { "THANG" }, new[] { rds.THANG });
                            baoCao.MailMerge.Execute(new[] { "NAM" }, new[] { rds.NAM });
                            baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { rds.NGUOIKY }); 
                            baoCao.MailMerge.Execute(new[] { "SO" }, new[] { rds.SOTHONGBAO });
                            baoCao.MailMerge.Execute(new[] { "NOIDUNG" }, new[] { rds.NOIDUNG });
                            baoCao.MailMerge.Execute(new[] { "NGAYGUIDON" }, new[] { rds.NGAYGUIDON });
                            baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { rds.DIADIEM });
                            baoCao.MailMerge.Execute(new[] { "TENBANAN" }, new[] { loaiBAQD + loaiAn + capXX });
                            baoCao.MailMerge.Execute(new[] { "BA_SO" }, new[] { rds.BA_SO });
                            baoCao.MailMerge.Execute(new[] { "BA_NGAY" }, new[] { rds.BA_NGAY });
                            baoCao.MailMerge.Execute(new[] { "BA_TOAXX" }, new[] { rds.BA_TOAXX });
                            baoCao.MailMerge.Execute(new[] { "BIDANH" }, new[] { rds.BIDANH });
                            doc.AppendDocument(baoCao, ImportFormatMode.KeepSourceFormatting);
                        }
                    }
                    if (!hasCheck)
                    {
                        string mess = "Bạn chưa chọn yêu cầu bổ sung!";
                        lbthongbao.Text = mess;
                        return;
                    }
                    doc.Sections[0].Range.Delete(); 
                    doc.Save(saveAs);
                    ExportData(fileNameSave, (string)saveAs);
                }
            }
            else
            {
                string strVID = Request["vid"] + "";
                decimal idYC = Convert.ToDecimal(strVID);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                Session["GDTTT_MABM"] = "NOIBO_THONGBAOLD";             
                DataTable oDT = oBL.GDTTT_DON_SEARCH( 0,null, null, "", "", "", "", "", "", "", "", Session[ENUM_SESSION.SESSION_USERID] + "", 1, 0, "", "", "", "", null, null, 0, "", 0, 0, "", null, "", "", 0, "", -1, -1, 0, -1, "CVPC", null, null, "," + idYC + ",", -1, 0, null, null, "", -1, -1, 0, DateTime.Now, 0, 0, 0, null, null, 1, 0, 0, "", "", "", -1, 0, 1, 1);
                if (oDT != null)
                {
                    if (oDT.Rows.Count == 0)
                    {
                        lbthongbao.Text = "Không có đơn kèm công văn";
                        return;
                    }
                    //Thông tin tờ trình
                    DTGDTTT objds = new DTGDTTT();
                    string strTendonvi = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                    DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                    strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                    string strHauto = "";
                    if (oNSD.PHONGBANID != null)
                    {
                        DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                        if (oPB != null)
                        {
                            strDiachi = oPB.DIACHI + "";
                            strHauto = oPB.HAUTOCV + "";
                        }

                    }
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                        strDiadiem = "Hà Nội";
                    else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    string TAND_NHAN_ = "";
                    if (Session["CAP_XET_XU"] + "" == "TOICAO")
                    {
                        TAND_NHAN_ = "TANDTC";
                    }
                    else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        TAND_NHAN_ = "TANDCC";
                    }

                    DataTable oYC = oBL.YEUCAUBOSUNG(idYC);
                    DataRow obj = oDT.Rows[0];
                    bool hasCheck = false;
                    foreach (DataGridItem Item in dgDS.Items)
                    {
                        CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                        HiddenField hddID = (HiddenField)Item.FindControl("hddID");
                        int index = Convert.ToInt16(hddID.Value);
                        if (chk.Checked)
                        {
                            hasCheck = true;
                            decimal DonID = Convert.ToDecimal(oYC.Rows[index]["DONID"]);
                            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                            strSo = oYC.Rows[index]["SOTHONGBAO"] + "";
                            strNguoiky = oYC.Rows[index]["NGUOIKY"] + "";
                            DateTime dNgayCV = Convert.ToDateTime(oYC.Rows[index]["NGAYTHONGBAO"] + "");
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();

                            DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                            rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                            rds.DIACHI = obj["Diachigui"] + "";
                            rds.TENDONVI = strTendonvi;
                            bool isDacoSo = false;
                            if (oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3)
                            {
                                if (strSo != "")
                                {
                                    oT.TB1_SO = reStr(strSo);
                                    if (dNgayCV != DateTime.MinValue)
                                        oT.TB1_NGAY = dNgayCV;
                                    oT.CD_NGUOIKY = strNguoiky;
                                    rds.SOTHONGBAO = reStr(strSo);
                                    rds.NGUOIKY = strNguoiky;
                                    rds.SOTOTRINH = strSo + strHauto;
                                    rds.NGAY = strNgay;
                                    rds.THANG = strThang;
                                    rds.NAM = strNam;
                                    isDacoSo = true;
                                }
                            }
                            if (isDacoSo == false)
                            {
                                rds.SOTHONGBAO = Cls_Comon.toFullNumber(oT.TB1_SO, false) + "";
                                rds.NGUOIKY = oT.CD_NGUOIKY + "";
                                rds.SOTOTRINH = Cls_Comon.toFullNumber(oT.CD_SOCV, false) + "";
                                if (oT.TB1_NGAY != null)
                                {
                                    DateTime dtNTB1 = (DateTime)oT.TB1_NGAY;
                                    rds.NGAY = Cls_Comon.toFullNumber(dtNTB1.Day.ToString(), false);
                                    rds.THANG = Cls_Comon.toFullNumber(dtNTB1.Month.ToString(), true);
                                    rds.NAM = dtNTB1.Year.ToString();
                                }
                            }
                            rds.DIADIEM = strDiadiem;
                            rds.LOAIAN = obj["BAQD_LOAIAN"] + "";
                            if (obj["NGAYGHITRENDON"] != null)
                                rds.NGAYGUIDON = GetDate(obj["NGAYGHITRENDON"]);
                            rds.GIOITINH = "";
                            rds.GIOITINHHOA = "";
                            if ((obj["DUNGDONLA"] + "") == "1")
                            {
                                if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                                {
                                    rds.GIOITINH = "ông";
                                    rds.GIOITINHHOA = "Ông";
                                }
                                else
                                {
                                    rds.GIOITINH = "bà";
                                    rds.GIOITINHHOA = "Bà";
                                }
                            }
                            else if ((obj["DUNGDONLA"] + "") == "2")
                            {
                                rds.GIOITINH = "các ông, bà";
                                rds.GIOITINHHOA = "Các ông, bà";
                            }
                            if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                            {
                                rds.BA_SO = obj["BAQD_SO"] + "";
                                rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                                if (rds.BA_NGAY != "")
                                    rds.BA_NGAY = GetDate(rds.BA_NGAY);
                                rds.BA_TOAXX = obj["TOAXX"] + "";
                            }
                            else//QĐKN
                            {
                                rds.BA_SO = obj["BAQD_SO"] + "";
                                rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                                if (rds.BA_NGAY != "")
                                    rds.BA_NGAY = GetDate(rds.BA_NGAY);
                                rds.BA_TOAXX = obj["TOAXX"] + "";
                            }
                            rds.NOIDUNG = "";
                            if ((oYC.Rows[index]["CD_TA_LYDO_ISBAQD"] + "") == "1")
                            {
                                rds.NOIDUNG = "          - Cung cấp bản sao bản án/quyết định đã có hiệu lực pháp luật và các tài liệu, chứng cứ liên quan đến việc đề nghị giám đốc thẩm.";
                            }
                            if ((oYC.Rows[index]["CD_TA_LYDO_ISXACNHAN"] + "") == "1")
                            {
                                if (rds.NOIDUNG != "")
                                    rds.NOIDUNG += "\n";
                                rds.NOIDUNG += "          - Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.";
                            }
                            if ((oYC.Rows[index]["CD_TA_LYDO_ISKHAC"] + "") == "1")
                            {
                                if (rds.NOIDUNG != "")
                                    rds.NOIDUNG += "\n";
                                rds.NOIDUNG += "          - " + oYC.Rows[index]["NOIDUNG"] + "";
                            }
                            rds.DIACHIPHONGBAN = strDiachi;
                            rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                            rds.TAND_NHAN = TAND_NHAN_;
                            objds.DT_NOIBO_THONGBAO.AddDT_NOIBO_THONGBAORow(rds);
                            objds.AcceptChanges();
                        }
                    }
                    if (!hasCheck)
                    {
                        string mess = "Bạn chưa chọn yêu cầu bổ sung!";
                        lbthongbao.Text = mess;
                        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + mess + "');", true);
                        return;
                    }
                    dt.SaveChanges();
                    Session["NOIBO_DATASET"] = objds;
                }
                string StrMsg = "/QLAN/GDTTT/In/ViewReport.aspx";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(800/2); var Mtop = (screen.height/2)-(800/2); javascript:window.open('" + StrMsg + "', '_blank', 'height=800px,width=800px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=no,scrollbars=0'); ", true);
            }

        }

        protected void btnNBInThongbaoTG_Click(object sender, EventArgs e)
        {
            string strVID = Request["vid"] + "";
            decimal idYC = Convert.ToDecimal(strVID);
            Session["GDTTT_MABM"] = "NOIBO_THONGBAOTG";
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
          
            DataTable oDT = oBL.GDTTT_DON_SEARCH(0,null, null, "", "", "", "", "", "", "", "", Session[ENUM_SESSION.SESSION_USERID] + "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, "", "", "", "", null, null, 0, "", 0, 0, "", null, "", "", 0, "", -1, -1, 0, -1, "CVPC", null, null, "," + idYC + ",", -1, 0, null, null, "", -1, 1, 0, DateTime.Now, 0, 0, 0, null, null, 1, 0, 0, "", "", "", -1, 0, 1, 1); 
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                //Thông tin tờ trình
                DTGDTTT objds = new DTGDTTT();
                string strTendonvi = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    if (oPB != null)
                    {
                        strDiachi = oPB.DIACHI + "";
                    }
                }

                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                DataTable oYC = oBL.YEUCAUBOSUNG(idYC);
                DataRow obj = oDT.Rows[0];
                bool hasCheck = false;
                string fileName = ConfigurationManager.AppSettings["TemplateWord"] + "rptThongBaoYCBS_TG.doc";
                string saveAs = ConfigurationManager.AppSettings["TemplateWord"] + "rptThongBaoYCBS_TG" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";
                string fileNameSave = "rptThongBaoYCBS_TG_" + obj["DONGKHIEUNAI"] + ".doc"; ;
                Document doc = new Document();
                foreach (DataGridItem Item in dgDS.Items)
                {
                    CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                    HiddenField hddID = (HiddenField)Item.FindControl("hddID");
                    int index = Convert.ToInt16(hddID.Value);
                    if (chk.Checked)
                    {
                        hasCheck = true;
                        decimal DonID = Convert.ToDecimal(oYC.Rows[index]["DONID"]);
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                        strSo = oYC.Rows[index]["SOTHONGBAO"] + "";
                        strNguoiky = oYC.Rows[index]["NGUOIKY"] + "";
                        DateTime dNgayCV = Convert.ToDateTime(oYC.Rows[index]["NGAYTHONGBAO"] + "");
                        strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                        strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                        strNam = dNgayCV.Year.ToString();

                        DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                        rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                        rds.DIACHI = obj["Diachigui"] + "";
                        rds.TENDONVI = strTendonvi;
                        bool isDacoSo = false;
                        if (oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3)
                        {
                            if (strSo != "")
                            {
                                oT.TB1_SO = reStr(strSo);
                                if (dNgayCV != DateTime.MinValue)
                                    oT.TB1_NGAY = dNgayCV;
                                oT.CD_NGUOIKY = strNguoiky;
                                rds.SOTHONGBAO = reStr(strSo);
                                rds.NGUOIKY = strNguoiky;
                                rds.NGAY = strNgay;
                                rds.THANG = strThang;
                                rds.NAM = strNam;
                                isDacoSo = true;
                            }
                        }
                        if (isDacoSo == false)
                        {
                            rds.SOTHONGBAO = reStr(oT.TB1_SO + "");
                            rds.NGUOIKY = oT.CD_NGUOIKY + "";
                            if (oT.TB1_NGAY != null)
                            {
                                DateTime dtNTB1 = (DateTime)oT.TB1_NGAY;
                                rds.NGAY = Cls_Comon.toFullNumber(dtNTB1.Day.ToString(), false);
                                rds.THANG = Cls_Comon.toFullNumber(dtNTB1.Month.ToString(), true);
                                rds.NAM = dtNTB1.Year.ToString();
                            }
                        }
                        rds.DIADIEM = strDiadiem;
                        if (obj["NGAYGHITRENDON"] != null)
                            rds.NGAYGUIDON = GetDate(obj["NGAYGHITRENDON"]);
                        rds.GIOITINH = "";
                        rds.GIOITINHHOA = "";
                        if ((obj["DUNGDONLA"] + "") == "1")
                        {
                            if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                            {
                                rds.GIOITINH = "ông";
                                rds.GIOITINHHOA = "Ông";
                            }
                            else
                            {
                                rds.GIOITINH = "bà";
                                rds.GIOITINHHOA = "Bà";
                            }
                        }
                        else if ((obj["DUNGDONLA"] + "") == "2")
                            rds.GIOITINH = "Các ông, bà";
                        if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                        {
                            rds.BA_SO = obj["BAQD_SO"] + "";
                            rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                            if (rds.BA_NGAY != "")
                                rds.BA_NGAY = GetDate(rds.BA_NGAY);
                            rds.BA_TOAXX = obj["TOAXX"] + "";
                        }
                        else//QĐKN
                        {
                            rds.BA_SO = obj["BAQD_SO"] + "";
                            rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                            if (rds.BA_NGAY != "")
                                rds.BA_NGAY = GetDate(rds.BA_NGAY);
                            rds.BA_TOAXX = obj["TOAXX"] + "";
                        }
                        rds.NOIDUNG = "";
                        if ((oYC.Rows[index]["CD_TA_LYDO_ISBAQD"] + "") == "1")
                        {
                            rds.NOIDUNG = "- Cung cấp bản sao bản án/quyết định đã có hiệu lực pháp luật và các tài liệu, chứng cứ liên quan đến việc đề nghị giám đốc thẩm.";
                        }
                        if ((oYC.Rows[index]["CD_TA_LYDO_ISXACNHAN"] + "") == "2")
                        {
                            if (rds.NOIDUNG != "")
                                rds.NOIDUNG += "\n";
                            rds.NOIDUNG += "- Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.";
                        }
                        if ((oYC.Rows[index]["CD_TA_LYDO_ISKHAC"] + "") == "3")
                        {
                            if (rds.NOIDUNG != "")
                                rds.NOIDUNG += "\n";
                            rds.NOIDUNG += "- " + oYC.Rows[index]["NOIDUNG"];
                        }
                        //if (oT.NOIDUNGDON != "" && oT.NOIDUNGDON != null)
                        //{
                        //    rds.NOIDUNG = "          - " + oT.NOIDUNGDON;
                        //    if ((obj["CD_TA_LYDO_ISXACNHAN"] + "") == "1")
                        //    {
                        //        if (rds.NOIDUNG != "")
                        //            rds.NOIDUNG += "\n";
                        //        rds.NOIDUNG += "          - Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.";
                        //    }
                        //    if ((obj["CD_TA_LYDO_ISKHAC"] + "") == "1")
                        //    {
                        //        if (rds.NOIDUNG != "")
                        //            rds.NOIDUNG += "\n";
                        //        rds.NOIDUNG += "          - " + obj["CD_TA_LYDO_KHAC"];
                        //    }
                        //}
                        rds.TENCOQUAN = obj["CV_TENDONVI"] + "";
                        rds.TENTRAIGIAMCU = oT.CV_TENDONVI + "";
                        if ((oT.CV_TRAIGIAMHIENTAI + "") != "")
                        {
                            rds.TENCOQUAN = oT.CV_TRAIGIAMHIENTAI + "";
                        }

                        rds.NGUOIKY = strNguoiky;
                        rds.DIACHIPHONGBAN = strDiachi;
                        rds.BIDANH = obj["BIDANH"] + "";

                        //Tạo file word biểu mẫu                                
                        Document baoCao = new Document(fileName);
                        string loaiGDTTT = obj["LOAIGDTT"].ToString();
                        if (loaiGDTTT.Trim() + "" == "")
                        {
                            loaiGDTTT = "giám đốc thẩm/tái thẩm";
                        }
                        baoCao.MailMerge.Execute(new[] { "LOAIGDTT" }, new[] { loaiGDTTT });
                        baoCao.MailMerge.Execute(new[] { "TENDONVIHOA" }, new[] { rds["TENDONVI"].ToString().ToUpper() });
                        baoCao.MailMerge.Execute(new[] { "TENDONVI" }, new[] { rds.TENDONVI });
                        baoCao.MailMerge.Execute(new[] { "TENCOQUAN" }, new[] { rds.TENCOQUAN });
                        baoCao.MailMerge.Execute(new[] { "TENTRAIGIAMCU" }, new[] { rds.TENTRAIGIAMCU });
                        baoCao.MailMerge.Execute(new[] { "DIACHIPHONGBAN" }, new[] { rds.DIACHIPHONGBAN });
                        baoCao.MailMerge.Execute(new[] { "NGUOIGUI" }, new[] { rds.NGUOIGUI });
                        baoCao.MailMerge.Execute(new[] { "DIACHI" }, new[] { rds.DIACHI });
                        baoCao.MailMerge.Execute(new[] { "NGAY" }, new[] { rds.NGAY });
                        baoCao.MailMerge.Execute(new[] { "THANG" }, new[] { rds.THANG });
                        baoCao.MailMerge.Execute(new[] { "NAM" }, new[] { rds.NAM });
                        baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { rds.NGUOIKY });
                        baoCao.MailMerge.Execute(new[] { "SO" }, new[] { rds.SOTHONGBAO });
                        baoCao.MailMerge.Execute(new[] { "NOIDUNG" }, new[] { rds.NOIDUNG });
                        baoCao.MailMerge.Execute(new[] { "NGAYGUIDON" }, new[] { rds.NGAYGUIDON });
                        baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { rds.DIADIEM });
                        baoCao.MailMerge.Execute(new[] { "BA_SO" }, new[] { rds.BA_SO });
                        baoCao.MailMerge.Execute(new[] { "BA_NGAY" }, new[] { rds.BA_NGAY });
                        baoCao.MailMerge.Execute(new[] { "BA_TOAXX" }, new[] { rds.BA_TOAXX });
                        baoCao.MailMerge.Execute(new[] { "BIDANH" }, new[] { rds.BIDANH });
                        doc.AppendDocument(baoCao, ImportFormatMode.KeepSourceFormatting);
                    }
                }
                if (!hasCheck)
                {
                    string mess = "Bạn chưa chọn yêu cầu bổ sung!";
                    lbthongbao.Text = mess;
                    //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + mess + "');", true);
                    return;
                }
                doc.Sections[0].Range.Delete();
                doc.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);
                //dt.SaveChanges();
                //Session["NOIBO_DATASET"] = objds;
            }
            //string StrMsg = "/QLAN/GDTTT/In/ViewReport.aspx";
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(800/2); var Mtop = (screen.height/2)-(800/2); javascript:window.open('" + StrMsg + "', '_blank', 'height=800px,width=800px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=no,scrollbars=0'); ", true);
        }

        protected void dgDS_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string isYCBS = Request["ycbs"] + "";
                if (isYCBS == "0")
                {
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }
            }
        }

        private string reStr(string str)
        {
            if (str.Length == 1)
                str = "0" + str;
            return str;
        }

        protected void chkLydoCDDK_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (chkLydoCDDK.Items[2].Selected)
            {
                txtNoiDung.Visible = true;
            }
            else
            {
                txtNoiDung.Visible = false;
            }
        }

        protected void ExportData(string fileName, string path)
        {
            try
            {
                //copy to MemoryStream
                MemoryStream ms = new MemoryStream();
                using (FileStream fs = File.OpenRead(Path.Combine(path)))
                {
                    fs.CopyTo(ms);
                }

                //Delete file
                if (File.Exists(Path.Combine(path)))
                    File.Delete(Path.Combine(path));

                //Download file

                Response.ClearHeaders();
                Response.Clear();
                Response.ClearContent();
                Response.Buffer = true;
                Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
                Response.BinaryWrite(ms.ToArray());
                Response.Flush();
            }
            finally
            {
            }
        }

    }
}