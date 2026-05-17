using BL.GSTP;
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

namespace WEB.GSTP.QLAN.GDTTT.Hoso.Popup
{
    public partial class Themdontrung : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DataTable lstDonVi;
        private void LoadCombobox()
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            lstDonVi = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            for (int i = 1; i < 30; i++)
            {
                ddlSoLuong.Items.Add(new ListItem(i.ToString() + " đơn trùng", i.ToString()));
            }
        }
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    LoadCombobox();
                    string strID = Request["vid"] + "";
                    decimal Toaanid = 0;
                    if (strID != "")
                    {
                        decimal ID = Convert.ToDecimal(strID);
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        txtNguoigui.Text = oT.NGUOIGUI_HOTEN + "";
                        if (oT.BAQD_LOAIQDBA == 1)
                        {//QD khang nghị
                            txtSoQDBA.Text = oT.KN_SOQD + "";
                            txtNgayBAQD.Text = oT.KN_NGAY + "" == "" ? "" : ((DateTime)oT.KN_NGAY).ToString("dd/MM/yyyy");
                        }
                        else
                        {
                            if (oT.BAQD_CAPXETXU == 2)
                            {
                                txtSoQDBA.Text = oT.BAQD_SO_ST + "";
                                txtNgayBAQD.Text = oT.BAQD_NGAYBA_ST + "" == "" ? "" : ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }
                            else if (oT.BAQD_CAPXETXU == 3)
                            {
                                txtSoQDBA.Text = oT.BAQD_SO_PT + "";
                                txtNgayBAQD.Text = oT.BAQD_NGAYBA_PT + "" == "" ? "" : ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }
                            else
                            {
                                txtSoQDBA.Text = oT.BAQD_SO + "";
                                txtNgayBAQD.Text = oT.BAQD_NGAYBA + "" == "" ? "" : ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                        }
                        if (oT.BAQD_CAPXETXU == 2)
                        {
                            Toaanid = Convert.ToDecimal(oT.BAQD_TOAANID_ST);
                        }else if (oT.BAQD_CAPXETXU == 3)
                        {
                            Toaanid = Convert.ToDecimal(oT.BAQD_TOAANID_PT);
                        }
                        else
                            Toaanid = Convert.ToDecimal(oT.BAQD_TOAANID);

                        if (Toaanid>0)
                        {
                            
                            DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == Toaanid).FirstOrDefault();
                            txtToaXX.Text = oTA.MA_TEN;
                        }
                        DataTable obj = getTable(1);
                        dgList.DataSource = obj;
                        dgList.DataBind();
                    }
                }
            }
        }
        protected void cmdTiepTuc_Click(object sender, EventArgs e)
        {
            DataTable obj = getTable(Convert.ToInt32(ddlSoLuong.SelectedValue));
            dgList.DataSource = obj;
            dgList.DataBind();

        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            string strID = Request["vid"] + "";
            decimal ID = Convert.ToDecimal(strID);
            decimal DontrungID = ID;
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oDon.DONTRUNGID > 0)
            {
                DontrungID = (decimal)oDon.DONTRUNGID;
            }
            GDTTT_DON_BL dsBL = new GDTTT_DON_BL();
            string strErr = "";
            foreach (DataGridItem item in dgList.Items)
            {
                TextBox txtNgaynhandon = (TextBox)item.FindControl("txtNgaynhandon");
                TextBox txtNgayghitrendon = (TextBox)item.FindControl("txtNgayghitrendon");
                DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgaynhandon.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgaynhandon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime dNgaytrendon = (String.IsNullOrEmpty(txtNgayghitrendon.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayghitrendon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                string strTT = item.Cells[0].Text;
                if (dNgayNhan != DateTime.MinValue && dNgaytrendon != DateTime.MinValue)
                {

                }
                else
                {
                    if (strErr == "") strErr = strTT;
                    else strErr = strErr + "," + strTT;
                }
            }
            if (strErr != "")
            {
                lbthongbao.Text = "Lỗi nhập ngày tháng đơn dòng số " + strErr;
            }
            else
            {
                foreach (DataGridItem item in dgList.Items)
                {
                    TextBox txtSohieudon = (TextBox)item.FindControl("txtSohieudon");
                    TextBox txtNgaynhandon = (TextBox)item.FindControl("txtNgaynhandon");
                    TextBox txtNgayghitrendon = (TextBox)item.FindControl("txtNgayghitrendon");
                    DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgaynhandon.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgaynhandon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    DateTime dNgaytrendon = (String.IsNullOrEmpty(txtNgayghitrendon.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayghitrendon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    string strTT = item.Cells[0].Text;

                    CheckBox chkIsCV = (CheckBox)item.FindControl("chkIsCV");

                    TextBox txtSoCV = (TextBox)item.FindControl("txtSoCV");
                    TextBox txtNgayCV = (TextBox)item.FindControl("txtNgayCV");
                    CheckBox chkIsTrongnganh = (CheckBox)item.FindControl("chkIsTrongnganh");
                    TextBox txtDonvi = (TextBox)item.FindControl("txtDonvi");
                    DropDownList ddlDonvi = (DropDownList)item.FindControl("ddlDonvi");

                    if (dNgayNhan != DateTime.MinValue && dNgaytrendon != DateTime.MinValue)
                    {
                        GDTTT_DON obj = new GDTTT_DON();
                        obj.TOAANID = oDon.TOAANID;
                        
                        obj.BAQD_LOAIAN = oDon.BAQD_LOAIAN;
                        obj.BAQD_LOAIQDBA = oDon.BAQD_LOAIQDBA;
                        obj.VUVIECID = oDon.VUVIECID;
                        obj.BAQD_CAPXETXU = oDon.BAQD_CAPXETXU;
                        obj.BAQD_SO = oDon.BAQD_SO;
                        obj.BAQD_NGAYBA = oDon.BAQD_NGAYBA;
                        obj.BAQD_TOAANID = oDon.BAQD_TOAANID;

                        obj.BAQD_SO_PT = oDon.BAQD_SO_PT;
                        obj.BAQD_NGAYBA_PT = oDon.BAQD_NGAYBA_PT;
                        obj.BAQD_TOAANID_PT = oDon.BAQD_TOAANID_PT;

                        obj.BAQD_SO_ST = oDon.BAQD_SO_ST;
                        obj.BAQD_NGAYBA_ST = oDon.BAQD_NGAYBA_ST;
                        obj.BAQD_TOAANID_ST = oDon.BAQD_TOAANID_ST;



                        obj.KN_LOAI = oDon.KN_LOAI;
                        obj.KN_SOQD = oDon.KN_SOQD;
                        obj.KN_NGAY = oDon.KN_NGAY;
                        obj.LOAIDON = oDon.LOAIDON;
                        obj.CV_ISTRONGNGANH = oDon.CV_ISTRONGNGANH;
                        obj.CV_TOAANID = oDon.CV_TOAANID;
                        obj.CV_TENDONVI = oDon.CV_TENDONVI;
                        obj.CV_SO = oDon.CV_SO;
                        obj.CV_NGAY = oDon.CV_NGAY;
                        obj.CV_TINHID = oDon.CV_TINHID;
                        obj.CV_HUYENID = oDon.CV_HUYENID;
                        obj.CV_DIACHI = oDon.CV_DIACHI;
                        obj.CV_NGUOIKY = oDon.CV_NGUOIKY;
                        obj.CV_CHUCVU = oDon.CV_CHUCVU;
                       
                        obj.NGAYNHANDON = dNgayNhan;
                        obj.NGAYGHITRENDON = dNgaytrendon;
                        obj.SOHIEUDON = txtSohieudon.Text;
                        obj.DUNGDONLA = oDon.DUNGDONLA;
                        obj.NGUOIGUI_HOTEN = oDon.NGUOIGUI_HOTEN;
                        obj.NGUOIGUI_GIOITINH = oDon.NGUOIGUI_GIOITINH;
                        obj.NGUOIGUI_CMND = oDon.NGUOIGUI_CMND;
                        obj.NGUOIGUI_TINHID = oDon.NGUOIGUI_TINHID;
                        obj.NGUOIGUI_HUYENID = oDon.NGUOIGUI_HUYENID;
                        obj.NGUOIGUI_DIACHI = oDon.NGUOIGUI_DIACHI;
                        obj.NGUOIGUI_DIENTHOAI = oDon.NGUOIGUI_DIENTHOAI;
                        obj.NGUOIGUI_EMAIL = oDon.NGUOIGUI_EMAIL;
                        obj.NGUOIGUI_TUCACHTOTUNG = oDon.NGUOIGUI_TUCACHTOTUNG;
                        obj.DONGKHIEUNAI = obj.NGUOIGUI_HOTEN;

                        obj.NOIDUNGDON = oDon.NOIDUNGDON;
                        obj.SOLUONGDON = 1;
                        obj.SOTHUTUDON = oDon.SOTHUTUDON;
                       

                        obj.PHANLOAIXULY = 3;
                        obj.TRALOIDON = oDon.TRALOIDON;
                        obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        obj.NGAYTAO = DateTime.Now;
                        obj.NGUOISUA = null;
                        obj.NGAYSUA =null;
                        obj.TT = dsBL.GETNEWTT((decimal)obj.TOAANID);
                        obj.MADON = ENUM_LOAIVUVIEC.AN_GDTTT + Session[ENUM_SESSION.SESSION_MADONVI] + obj.TT.ToString();


                        obj.MAGIAIDOAN = oDon.MAGIAIDOAN;
                        obj.LOAICONGVAN = oDon.LOAICONGVAN;
                        obj.DONVIUUTIEN = oDon.DONVIUUTIEN;
                        obj.NGUOIKHANGNGHI = oDon.NGUOIKHANGNGHI;
                        
                        obj.CV_NHACLAIID = oDon.CV_NHACLAIID;

                        obj.DONTRUNGID = DontrungID;
                        obj.ISCHUYENXULY = oDon.ISCHUYENXULY;
                        obj.DONVIXULYID = oDon.DONVIXULYID;
                        obj.CV_NHACLAITEXT = oDon.CV_NHACLAITEXT;
                        obj.DONTRUNGTEXT = oDon.DONTRUNGTEXT;
                        obj.CV_TRALOI_SO = oDon.CV_TRALOI_SO;
                        obj.CV_TRALOI_NGAY = oDon.CV_TRALOI_NGAY;
                        obj.CV_TRALOI_NOIDUNG = oDon.CV_TRALOI_NOIDUNG;
                        obj.CD_LOAI = oDon.CD_LOAI;
                        obj.CD_TA_DONVIID = oDon.CD_TA_DONVIID;
                        obj.CD_TA_TRANGTHAI = oDon.CD_TA_TRANGTHAI;
                        obj.CD_TA_LYDO_ISBAQD = oDon.CD_TA_LYDO_ISBAQD;
                        obj.CD_TA_LYDO_ISXACNHAN = oDon.CD_TA_LYDO_ISXACNHAN;
                        obj.CD_TA_LYDO_ISKHAC = oDon.CD_TA_LYDO_ISKHAC;

                        obj.CD_TK_DONVIID = oDon.CD_TK_DONVIID;
                        obj.CD_TK_NOIGUI = oDon.CD_TK_NOIGUI;
                        obj.CD_NTA_TENDONVI = oDon.CD_NTA_TENDONVI;
                        obj.CD_TRALAI_LYDOID = oDon.CD_TRALAI_LYDOID;
                        obj.CD_TRALAI_YEUCAU = oDon.CD_TRALAI_YEUCAU;
                        obj.CD_TRALAI_SOPHIEU = oDon.CD_TRALAI_SOPHIEU;
                        obj.CD_TRALAI_NGAYTRA = oDon.CD_TRALAI_NGAYTRA;
                        obj.CD_TRANGTHAI = 0;
                        // obj.CD_NGAYXULY = oDon.CD_NGAYXULY;
                        obj.GHICHU = oDon.GHICHU;
                        obj.TRANGTHAIDON = 0;

                        if (oDon.ISTHULY == 1)
                        {
                            obj.ISTHULY = 2;
                            obj.TL_SO = oDon.TL_SO;
                            obj.TL_NGAY = oDon.TL_NGAY;
                            obj.TL_NGUOI = oDon.TL_NGUOI;
                        }
                        else
                        {
                            obj.ISTHULY = oDon.ISTHULY;
                            obj.TL_SO = oDon.TL_SO;
                            obj.TL_NGAY = oDon.TL_NGAY;
                            obj.TL_NGUOI = oDon.TL_NGUOI;
                        }

                      

                        obj.THAMPHANID = oDon.THAMPHANID;
//                        obj.CD_NGUOIKY = oDon.CD_NGUOIKY;
//                        obj.CD_SOCV = oDon.CD_SOCV;
//                        obj.CD_NGAYCV = oDon.CD_NGAYCV;
                        obj.NOIDUNGTOMTAT = oDon.NOIDUNGTOMTAT;
                        obj.ISSHOWFULL = oDon.ISSHOWFULL;
                     
                        obj.CD_TRALAI_LYDOKHAC = oDon.CD_TRALAI_LYDOKHAC;
                        obj.CD_TA_LYDO_KHAC = oDon.CD_TA_LYDO_KHAC;
                        if (chkIsCV.Checked)
                        {
                            obj.LOAIDON = 3;
                            obj.CV_SO = txtSoCV.Text;
                            DateTime dNgayCV = (String.IsNullOrEmpty(txtNgayCV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            obj.CV_NGAY = dNgayCV;
                            if (chkIsTrongnganh.Checked)
                            {
                                obj.CV_ISTRONGNGANH = 1;
                                obj.CV_TOAANID = Convert.ToDecimal(ddlDonvi.SelectedValue);
                                obj.CV_TENDONVI = ddlDonvi.SelectedItem.Text;
                                obj.CV_NHACLAIID = 4;
                            }
                            else
                            {
                                obj.CV_ISTRONGNGANH = 0;
                                obj.CV_TENDONVI = txtDonvi.Text;
                            }
                        }
                        dt.GDTTT_DON.Add(obj);
                        dt.SaveChanges();                    
                            oDon.SOLUONGDON = 1;  
                        dt.SaveChanges();
                    }
                }
                lbthongbao.Text = "Hoàn thành cập nhật";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "window.opener.location.reload();window.close();");
            }
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            oBL.UPDATESOLUONGDON(ID);
        }


        private DataTable getTable(int SL)
        {
            DataTable obj = new DataTable();
            obj.Columns.Add("TT");
            obj.Columns.Add("SOHIEUDON");
            obj.Columns.Add("NGAYNHANDON");
            obj.Columns.Add("NGAYGHIDON");
            obj.Columns.Add("HINHTHUCDON");
            obj.Columns.Add("SOCV");
            obj.Columns.Add("NGAYCV");
            obj.Columns.Add("LOAIDONVI");
            obj.Columns.Add("DONVIGUI");
            obj.AcceptChanges();
            for (int i = 1; i <= SL; i++)
            {
                DataRow r = obj.NewRow();
                r["TT"] = i.ToString();
                r["HINHTHUCDON"] = "0";
                r["LOAIDONVI"] = "0";
                obj.Rows.Add(r);
            }
            obj.AcceptChanges();

            return obj;
        }

        protected void ddlSoLuong_SelectedIndexChanged(object sender, EventArgs e)
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            lstDonVi = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            DataTable obj = getTable(Convert.ToInt32(ddlSoLuong.SelectedValue));
            dgList.DataSource = obj;
            dgList.DataBind();
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    DropDownList ddlDonvi = (DropDownList)e.Item.FindControl("ddlDonvi");
                    ddlDonvi.DataSource = lstDonVi;
                    ddlDonvi.DataTextField = "TEN";
                    ddlDonvi.DataValueField = "ID";
                    ddlDonvi.DataBind();
                }
                catch (Exception ex) { }
            }
        }
        public bool GetNumber(object obj)
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
      
        protected void chkIsCV_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            string ID = chk.ToolTip;           
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkIsCV = (CheckBox)Item.FindControl("chkIsCV");
                TextBox txtSoCV = (TextBox)Item.FindControl("txtSoCV");
                TextBox txtNgayCV = (TextBox)Item.FindControl("txtNgayCV");
                CheckBox chkIsTrongnganh = (CheckBox)Item.FindControl("chkIsTrongnganh");
                TextBox txtDonvi = (TextBox)Item.FindControl("txtDonvi");
                DropDownList ddlDonvi = (DropDownList)Item.FindControl("ddlDonvi");
                if (chk.ToolTip == chkIsCV.ToolTip)
                {
                    if (chk.Checked)
                    {
                        txtSoCV.Visible = true;
                        txtNgayCV.Visible = true;
                        chkIsTrongnganh.Visible = true;
                        txtDonvi.Visible = true;
                        ddlDonvi.Visible = false;
                    }
                    else
                    {
                        txtSoCV.Visible = false;
                        txtNgayCV.Visible = false;
                        chkIsTrongnganh.Visible = false;
                        txtDonvi.Visible = false;
                        ddlDonvi.Visible = false;
                    }
                }
            }
        }
        protected void chkIsTrongnganh_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            string ID = chk.ToolTip;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkIsTrongnganh = (CheckBox)Item.FindControl("chkIsTrongnganh");
                TextBox txtDonvi = (TextBox)Item.FindControl("txtDonvi");
                DropDownList ddlDonvi = (DropDownList)Item.FindControl("ddlDonvi");
                if (chk.ToolTip == chkIsTrongnganh.ToolTip)
                {
                    if (chk.Checked)
                    {                      
                        txtDonvi.Visible = false;
                        ddlDonvi.Visible = true;
                    }
                    else
                    {                       
                        txtDonvi.Visible = true;
                        ddlDonvi.Visible = false;
                    }
                }
            }
        }
    }
}