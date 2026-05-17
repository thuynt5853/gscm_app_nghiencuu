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
    public partial class pSuaCongvan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
      
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
        String UserName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            string current_id = Request["ID"] + "";
            hddSOPHATHANH_ID.Value = Request["ID"] + "";

            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                   
                    Load_Data(Convert.ToDecimal(current_id));

                }

                   
            }
        }

        private DataTable getDS(decimal vSOPHATHANH_ID)
        {

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable oDT = oBL.GDTTT_SUASOVB_SEARCH(vSOPHATHANH_ID);
            return oDT;
        }
        private DataTable checkdonchuyen(decimal vSOPHATHANH_ID)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable oDT = oBL.CHECK_GDTTT_SUASOVB(vSOPHATHANH_ID);
            return oDT;
        }
        private void Load_Data(decimal vSOPHATHANH_ID)
        {
            DataTable oDT = getDS(vSOPHATHANH_ID);
            decimal v_pagesie;
            string v_LoaiVB = "";
            string v_Nguoiky = "";
            if (oDT != null && oDT.Rows.Count > 0)
            {
                hddTotalPage.Value = "1";
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count + " </b> đơn trong <b> Sổ " + oDT.Rows[0]["TenSOVB"] +"</b>";
                v_pagesie = oDT.Rows.Count;
                v_LoaiVB = oDT.Rows[0]["MaSOVB"] + "";
                v_Nguoiky = oDT.Rows[0]["NGUOIKY"] + "";

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

            // Load Ngườiky
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlNguoiKy.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_ARR_CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                "023,022", v_LoaiVB);
            ddlNguoiKy.DataTextField = "MA_TEN";
            ddlNguoiKy.DataValueField = "MA_TEN";
            ddlNguoiKy.DataBind();
            //ddlNguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            if (v_Nguoiky != "")
                ddlNguoiKy.SelectedValue = v_Nguoiky.ToString();

        }
        
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            //Viet ham kiem tra neu Văn bản đã chuyển 1 đơn trở lên thì không được phép sửa hoặc xóa Số Văn bản
            string strMsg;
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable oDT = oBL.CHECK_GDTTT_SUASOVB(Convert.ToDecimal(hddSOPHATHANH_ID.Value));
            if (oDT.Rows.Count > 0 && Convert.ToDecimal(oDT.Rows[0]["vcheck"]) > 0)
            {
                strMsg = "Văn bản đã được chuyển đi không được phép sửa!";
            }
            else
            {
                string vNguoiKy = ddlNguoiKy.SelectedValue;
                decimal vindex = vNguoiKy.IndexOf("-");
                string v_chucvu = "";
                string v_hoten = "";
                if (ddlNguoiKy.SelectedValue.toNumber() > 0)
                {
                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                    v_hoten = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }
                //chỉ cho phép cập nhật Ngày Văn Bản
                DateTime ngaycv = DateTime.ParseExact(txtALL_NGAYCV.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                if (oBL.SOVANBAN_UPDATE(Convert.ToDecimal(hddSOPHATHANH_ID.Value), 
                    //txtALL_SOCV.Text, 
                    txtALL_NGAYCV.Text, v_hoten, v_chucvu, UserName) == true)
                {
                    strMsg = "Cập nhật Số Văn bản thành công!";
                }
                else
                    strMsg = "Cập nhật Số Văn bản lỗi. Liên hệ với quản trị để được hỗ trợ!";
                
                
                Load_Data(Convert.ToDecimal(hddSOPHATHANH_ID.Value));

            }

           
        }
        protected void cmdXoaCV_Click(object sender, EventArgs e)
        {
            string strMsg;
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable oDT = oBL.CHECK_GDTTT_SUASOVB(Convert.ToDecimal(hddSOPHATHANH_ID.Value));
            if (oDT.Rows.Count > 0 && Convert.ToDecimal(oDT.Rows[0]["vcheck"]) > 0)
            {
                strMsg = "Văn bản đã được chuyển đi không được phép xóa!";
            }
            else
            {
                foreach (DataGridItem Item in dgList.Items)
                {
                    
                    CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                    //if(((CheckBox)Item.FindControl("chkChonAll")).Checked == true)
                    if (chk.Checked)
                    {
                        string strID = Item.Cells[0].Text;
                        decimal DonID = Convert.ToDecimal(strID);
                        oBL.DELETE_ONE_SOVANBAN(DonID, Convert.ToDecimal(hddSOPHATHANH_ID.Value));

                    }

                }
                strMsg = "Xóa thành cống số Công văn của các đơn đã chọn!";
            }
            Load_Data(Convert.ToDecimal(hddSOPHATHANH_ID.Value));

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("/QLAN/GDTTT/Hoso/Quanlycapso.aspx");
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
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
                if (chkAll.Checked)
                {
                    cmdLuu.Visible = cmdXoaCV.Visible =  true;
                    lblAllSoCV.Visible = lblAllNgayCV.Visible = lblAllNguoiky.Visible = txtALL_SOCV.Visible = txtALL_NGAYCV.Visible = txtALL_NGUOIKY.Visible = true;
                }
                else
                {
                    cmdLuu.Visible = cmdXoaCV.Visible = false;
                    lblAllSoCV.Visible = lblAllNgayCV.Visible = lblAllNguoiky.Visible = txtALL_SOCV.Visible = txtALL_NGAYCV.Visible = txtALL_NGUOIKY.Visible = true;
                }
            }
        }
        protected void chkChon_CheckChange(object sender, EventArgs e)
        {
            //CheckBox curr_chk = (CheckBox)sender;
            //foreach (DataGridItem Item in dgList.Items)
            //{

            //    TextBox txtCD_SOCV = (TextBox)Item.FindControl("txtCD_SOCV");
            //    TextBox txtCD_NGAYCV = (TextBox)Item.FindControl("txtCD_NGAYCV");
            //    TextBox txtCD_NGUOIKY = (TextBox)Item.FindControl("txtCD_NGUOIKY");

            //    CheckBox chk = (CheckBox)Item.FindControl("chkChon");
            //    if (chk.Checked)
            //    {
            //        txtCD_SOCV.Enabled = txtCD_NGAYCV.Enabled = txtCD_NGUOIKY.Enabled = true;
            //        cmdLuu.Visible = cmdXoaCV.Visible = true;
            //    }
            //    else
            //    {
            //        txtCD_SOCV.Enabled = txtCD_NGAYCV.Enabled = txtCD_NGUOIKY.Enabled = false;
            //    }
            //}
        }
    }
}