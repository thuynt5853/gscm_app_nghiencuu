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
    public partial class SuaCongvan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        List<DM_HANHCHINH> lstTinh;
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
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                    Load_Data();
            }
        }

        private DataTable getDS()
        {

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
           
            string SoCongVan, NgayCongVan;
            
            SoCongVan = txtCV_So.Text;
            NgayCongVan = txtCV_Ngay.Text;
            DataTable oDT = oBL.GDTTT_SUACONGVAN_SEARCH(ToaAnID, SoCongVan, NgayCongVan);
            return oDT;
        }
        private void Load_Data()
        {
            DataTable oDT = getDS();
            decimal v_pagesie;
            if (oDT != null && oDT.Rows.Count > 0)
            {
                hddTotalPage.Value = "1";
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count + " </b> đơn trong <b>";
                v_pagesie = oDT.Rows.Count;
            }
            else
            {
                hddTotalPage.Value = "1";
                v_pagesie = 1;
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = Convert.ToInt32(v_pagesie);
            dgList.DataSource = oDT;
            dgList.DataBind();
            
        }

        private void SaveData()
        {

           
           
        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
          
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkAll = (CheckBox)Item.FindControl("chkChonAll");
                TextBox txtCD_SOCV = (TextBox)Item.FindControl("txtCD_SOCV");
                TextBox txtCD_NGAYCV = (TextBox)Item.FindControl("txtCD_NGAYCV");
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                //if(((CheckBox)Item.FindControl("chkChonAll")).Checked == true)
                if (chk.Checked & txtALL_SOCV.Visible == true & txtALL_NGAYCV.Visible == true)
                {
                    string strID = Item.Cells[0].Text;
                    decimal ID = Convert.ToDecimal(strID);
                    GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                    //Kiem tra So CV da co chua
                    decimal soCV, Trangthaidon = 0;
                    if (obj.CD_TA_TRANGTHAI != null)
                        Trangthaidon = Convert.ToDecimal(obj.CD_TA_TRANGTHAI);
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    DateTime vCD_YEARCV = (String.IsNullOrEmpty(txtALL_NGAYCV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtALL_NGAYCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (oBL.DON_CV_CHECK(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(obj.CD_LOAI),Trangthaidon, txtALL_SOCV.Text, vCD_YEARCV.Year))
                    {
                        soCV = oBL.CV_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), vCD_YEARCV.Year, Convert.ToDecimal(obj.CD_LOAI), Trangthaidon);
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('số Công văn " + txtALL_SOCV.Text + " năm " + vCD_YEARCV.Year + " đã sử dụng, số CV gần nhất năm " + vCD_YEARCV.Year + " là " + (soCV).ToString() + "!')", true);
                        //-------------------
                        txtALL_SOCV.Focus();
                        return;
                    }

                    if (txtALL_SOCV.Text != null)
                        obj.CD_SOCV = txtALL_SOCV.Text;
                    if (txtALL_NGAYCV.Text != null)
                        obj.CD_NGAYCV = txtALL_NGAYCV.Text == "" ? (DateTime?)null : DateTime.Parse(txtALL_NGAYCV.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    dt.SaveChanges();
                }
                else if (chk.Checked)
                {
                    string strID = Item.Cells[0].Text;
                    decimal ID = Convert.ToDecimal(strID);
                    GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();

                    //Kiem tra So CV da co chua
                    decimal Trangthaidon = 0;
                    if (obj.CD_TA_TRANGTHAI != null)
                            Trangthaidon = Convert.ToDecimal(obj.CD_TA_TRANGTHAI);
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    if (txtCD_SOCV.Text != null & txtCD_NGAYCV.Text != null)
                    {
                        DateTime vCD_YEARCV = (String.IsNullOrEmpty(txtCD_NGAYCV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCD_NGAYCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        if (oBL.DON_CV_CHECK(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(obj.CD_LOAI), Trangthaidon, txtCD_SOCV.Text, vCD_YEARCV.Year))
                        {
                            decimal soCV = 0;
                           

                            soCV = oBL.CV_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), vCD_YEARCV.Year, Convert.ToDecimal(obj.CD_LOAI), Trangthaidon);
                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('số Công văn " + txtCD_SOCV.Text + " năm " + vCD_YEARCV.Year + " đã sử dụng, số CV gần nhất năm " + vCD_YEARCV.Year + " là " + (soCV).ToString() + "!')", true);
                            return;
                        }

                        obj.CD_SOCV = txtCD_SOCV.Text;
                        obj.CD_NGAYCV = txtCD_NGAYCV.Text == "" ? (DateTime?)null : DateTime.Parse(txtCD_NGAYCV.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        dt.SaveChanges();
                    }
                }
            }
            Load_Data();
            lbthongbao.Text = "Lưu thành công trang hiện tại !";
        }
        protected void cmdXoaCV_Click(object sender, EventArgs e)
        {

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkAll = (CheckBox)Item.FindControl("chkChonAll");
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                //if(((CheckBox)Item.FindControl("chkChonAll")).Checked == true)
                if (chk.Checked)
                {
                    string strID = Item.Cells[0].Text;
                    decimal ID = Convert.ToDecimal(strID);
                    GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                    if (obj.CD_TRANGTHAI == 0 || obj.CD_TRANGTHAI == 3)
                    {
                        obj.CD_SOCV = null;
                        obj.CD_NGAYCV = null;
                        obj.CD_NGUOIKY = null;
                        dt.SaveChanges();
                    }  
                }
            }
            Load_Data();
            lbthongbao.Text = "Xóa thành cống số Công văn của các đơn đã chọn!";
        }
        
        protected void btnSearch_Click(object sender, EventArgs e)
        {

            DataTable oDT = getDS();
            decimal v_pagesie;
            if (oDT != null && oDT.Rows.Count > 0)
            {
                hddTotalPage.Value = "1";
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count + " </b> đơn trong <b>";
                v_pagesie = oDT.Rows.Count;
            }
            else
            {
                hddTotalPage.Value = "1";
                v_pagesie = 1;
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = Convert.ToInt32(v_pagesie);
            dgList.DataSource = oDT;
            dgList.DataBind();

            cmdLuu.Visible = cmdXoaCV.Visible =  false;
            lblAllSoCV.Visible = lblAllNgayCV.Visible = txtALL_SOCV.Visible = txtALL_NGAYCV.Visible = false;
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            txtCV_So.Text = txtCV_Ngay.Text = null;
            Load_Data();
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
           
        }

        public string CatXau(string str, int length)
        {
            if (str.Length > length)
            {
                if (str.Substring(length, 1) == " ")
                {
                    //Hết 1 từ
                    str = str.Substring(0, length);
                }
                else
                {
                    //Cắt giữa từ
                    str = str.Substring(0, length);
                    str = str.Substring(0, str.LastIndexOf(' '));
                }
                while (str.Substring(str.Length - 1, 1) == " ") str = str.Substring(0, str.Length - 1);
                str += "...";

            }

            return str;

        }
        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;
            if (chkAll.Checked)
            {
                checkALL.Value = "1";
            }
            else
            {
                checkALL.Value = "0";
            }

            
            foreach (DataGridItem Item in dgList.Items)
            {
                TextBox txtCD_SOCV = (TextBox)Item.FindControl("txtCD_SOCV");
                TextBox txtCD_NGAYCV = (TextBox)Item.FindControl("txtCD_NGAYCV");

                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
                if (chkAll.Checked)
                {
                    txtCD_SOCV.Enabled = txtCD_NGAYCV.Enabled = false;
                    cmdLuu.Visible = cmdXoaCV.Visible =  true;
                    lblAllSoCV.Visible = lblAllNgayCV.Visible = txtALL_SOCV.Visible = txtALL_NGAYCV.Visible = true;    
                }
                else
                {
                    cmdLuu.Visible = cmdXoaCV.Visible = false;
                    lblAllSoCV.Visible = lblAllNgayCV.Visible = txtALL_SOCV.Visible = txtALL_NGAYCV.Visible = false;
                }
            }
        }
        protected void chkChon_CheckChange(object sender, EventArgs e)
        {
            CheckBox curr_chk = (CheckBox)sender;
            foreach (DataGridItem Item in dgList.Items)
            {

                TextBox txtCD_SOCV = (TextBox)Item.FindControl("txtCD_SOCV");
                TextBox txtCD_NGAYCV = (TextBox)Item.FindControl("txtCD_NGAYCV");

                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                if (chk.Checked)
                {
                    txtCD_SOCV.Enabled = txtCD_NGAYCV.Enabled = true;
                    cmdLuu.Visible = cmdXoaCV.Visible = true;
                }
                else
                {
                    txtCD_SOCV.Enabled = txtCD_NGAYCV.Enabled = false;
                }
            }
        }
    }
}