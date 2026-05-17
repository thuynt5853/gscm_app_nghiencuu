using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace WEB.TP.Quantri.User
{
    public partial class Capnhat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            Decimal CurrUser = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUser == 0)
            {
                Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
            }
            if (!IsPostBack)
            {
                LoadCombobox();
                string strID = Request["CID"] + "";
                if (strID != "")
                {
                    QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
                    TUPHAP_NGUOISUDUNG oT = oBL.GetByID_THADS(Convert.ToDecimal(strID));
                    if (oT == null) return;
                    ddlDonvi.SelectedValue = oT.DONVITHA_ID.ToString();
                    txtUsername.Text = oT.USERNAME;
                    chkHieuluc.Checked = oT.HIEULUC==1?true:false;
                    txtDienthoai.Text = oT.DIENTHOAI;
                    txtEmail.Text = oT.EMAIL;
                    txtGhichu.Text = oT.GHICHU;
                    chkIsDomain.Checked = oT.ISACCDOMAIN == 1 ? true : false;
                    ddlLoaiNhom.SelectedValue = oT.LOAIUSER.ToString();
                    LoadNhomquyen(Convert.ToDecimal(ddlDonvi.SelectedValue));
                    LoadPhongban(Convert.ToDecimal(ddlDonvi.SelectedValue));
                    if (oT.NHOMNSDID != null)
                        ddlNhomquyen.SelectedValue = oT.NHOMNSDID.ToString();
                    else
                        ddlNhomquyen.SelectedValue = "0";
                    txtCanb.Text = oT.HOTEN;
                    txtPass.Enabled = false; txtRePass.Enabled = false;
                }
                MenuPermission oPer = QT_TUPHAP_BL.GetMenuPer_THADS(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            }
        }
        private void LoadCombobox()
        {
           // string strDonViID = Session["DonViID"] + "";
            string strDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            if (strDonViID != "")
            {
                decimal DonViID = Convert.ToDecimal(strDonViID);
                DM_DONVITHIHANHAN oT = dt.DM_DONVITHIHANHAN.Where(x => x.ID == DonViID).FirstOrDefault();
                if (oT.LOAITOA == "CAPCAO")
                {
                    ddlDonvi.Items.Insert(0, new ListItem(oT.TEN, oT.ID.ToString()));
                }
                else
                {
                    QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
                    ddlDonvi.DataSource = oBL.DM_TOAAN_GETBY_THADS(DonViID);
                    ddlDonvi.DataTextField = "arrTEN";
                    ddlDonvi.DataValueField = "ID";
                    ddlDonvi.DataBind();
                }
            }
            string strLoaiUser = Session["LoaiUser"] + "";

            ddlLoaiNhom.Items.Clear();
            ddlLoaiNhom.Items.Add(new ListItem("Mặc định", "0"));
            if (strLoaiUser == "2")
            {
                ddlLoaiNhom.Items.Add(new ListItem("Quản trị đơn vị", "1"));
                ddlLoaiNhom.Items.Add(new ListItem("Quản trị hệ thống", "2"));
              
            }
            LoadNhomquyen(Convert.ToDecimal(strDonViID));
            LoadPhongban(Convert.ToDecimal(strDonViID));
        }

        private void LoadPhongban(decimal DonViID)
        {
            ddlPhongban.Items.Clear();
            ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == DonViID).ToList();
            ddlPhongban.DataTextField = "TENPHONGBAN";
            ddlPhongban.DataValueField = "ID";
            ddlPhongban.DataBind();
            ddlPhongban.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        private void LoadNhomquyen(decimal DonViID)
        {
            ddlNhomquyen.Items.Clear();
            DM_DONVITHIHANHAN oTA = dt.DM_DONVITHIHANHAN.Where(x => x.ID == DonViID).FirstOrDefault();
            ddlNhomquyen.DataSource = dt.TUPHAP_NHOMNGUOIDUNG.Where(x => x.LOAITOA == oTA.LOAITOA).ToList();
            ddlNhomquyen.DataTextField = "TEN";
            ddlNhomquyen.DataValueField = "ID";
            ddlNhomquyen.DataBind();
            ddlNhomquyen.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                lbthongbao.Text = "";
                if (txtUsername.Text.Trim() == "")
                {
                    lbthongbao.Text = "User name không được để trống !";
                    return;
                }
                if (ddlNhomquyen.SelectedIndex == 0)
                {
                    lbthongbao.Text = "Chưa chọn nhóm quyền !";
                    return;
                }
                QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
                List<TUPHAP_NGUOISUDUNG> lstnguoidung = oBL.GetByUserName_THADS(txtUsername.Text.Trim());
                string strID = Request["CID"] + "";
                if (strID == "")
                {
                    if (lstnguoidung.Count > 0)
                    {
                        lbthongbao.Text = "Tên đăng nhập đã tồn tại!";
                        txtUsername.Focus();
                        return;
                    }
                    if (chkIsDomain.Checked == false)
                    {
                        //Kiểm tra mật khẩu
                        if (txtPass.Text.Length < 6)
                        {
                            lbthongbao.Text = "Mật khẩu chưa hợp lệ !";
                            txtPass.Focus();
                            return;
                        }
                        if (txtPass.Text != txtRePass.Text)
                        {
                            lbthongbao.Text = "Nhập lại mật khẩu chưa đúng !";
                            txtRePass.Focus();
                            return;
                        }
                    }
                    string strPass = Cls_Comon.MD5Encrypt(txtPass.Text);

                    TUPHAP_NGUOISUDUNG oT = new TUPHAP_NGUOISUDUNG();
                    oT.DONVITHA_ID = Convert.ToDecimal(ddlDonvi.SelectedValue);
                    oT.USERNAME = txtUsername.Text;
                    oT.PASSWORD = strPass;
                    oT.HOTEN = txtCanb.Text; 
                    oT.HIEULUC = chkHieuluc.Checked ? 1 : 0;
                    oT.DIENTHOAI = txtDienthoai.Text;
                    oT.EMAIL = txtEmail.Text;
                    oT.GHICHU = txtGhichu.Text;
                    oT.NHOMNSDID = Convert.ToDecimal(ddlNhomquyen.SelectedValue);
                    oT.LOAIUSER = Convert.ToDecimal(ddlLoaiNhom.SelectedValue);
                    oT.ISACCDOMAIN = chkIsDomain.Checked ? 1 : 0;
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.TUPHAP_NGUOISUDUNG.Add(oT);
                    dt.SaveChanges();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(strID);
                    TUPHAP_NGUOISUDUNG oT = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == ID).FirstOrDefault();
                    if (lstnguoidung.Count >= 1 && oT.USERNAME.Trim().ToUpper() != txtUsername.Text.Trim().ToUpper())
                    {
                        lbthongbao.Text = "Tên đăng nhập đã tồn tại!";
                        txtUsername.Focus();
                        return;
                    }
                    if (oT == null) return;                    
                    oT.DONVITHA_ID = Convert.ToDecimal(ddlDonvi.SelectedValue);//10/01/2025
                    oT.USERNAME = txtUsername.Text;
                    oT.HOTEN = txtCanb.Text;
                    oT.HIEULUC = chkHieuluc.Checked ? 1 : 0;
                    oT.DIENTHOAI = txtDienthoai.Text;
                    oT.EMAIL = txtEmail.Text;
                    oT.GHICHU = txtGhichu.Text;
                    oT.ISACCDOMAIN = chkIsDomain.Checked ? 1 : 0;
                    oT.NHOMNSDID = Convert.ToDecimal(ddlNhomquyen.SelectedValue);
                    oT.LOAIUSER = Convert.ToDecimal(ddlLoaiNhom.SelectedValue);
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                lbthongbao.Text = "Bạn đã lưu thành công";
                // Response.Redirect("Danhsach.aspx");
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
            

        protected void lblquaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }

        protected void ddlDonvi_TextChanged(object sender, EventArgs e)
        {
            LoadNhomquyen(Convert.ToInt32(ddlDonvi.SelectedValue));
            LoadPhongban(Convert.ToDecimal(ddlDonvi.SelectedValue));
        }

        protected void chkIsDomain_CheckedChanged(object sender, EventArgs e)
        {
            string strID = Request["CID"] + "";
            
                if (chkIsDomain.Checked)
            {
                txtPass.Enabled = false;txtRePass.Enabled = false;
            }
            else
            {
                if (strID == "") { txtPass.Enabled = true; txtRePass.Enabled = true; }
            }
        }
    }
}
