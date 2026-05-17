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
    public partial class pSuaCongvanVAKN : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        String UserName = "";

        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "") return "";
                else return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }

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
            DataTable oDT = oBL.GDTTT_SUASOVBVAKN_HCTP_SEARCH(vSOPHATHANH_ID);
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
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count + " </b> đơn trong <b> Sổ " + oDT.Rows[0]["TenSOVB"] + "</b>";
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

            decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DataTable dt1 = oDMCBBL.DM_CANBO_GETBYDONVI_ARR_CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), "023,022", v_LoaiVB);
            DataTable dt2 = oDMCBBL.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);
            dt1.Merge(dt2);

            ddlNguoiKy.DataSource = dt1;
            ddlNguoiKy.DataTextField = "MA_TEN";
            ddlNguoiKy.DataValueField = "MA_TEN";
            ddlNguoiKy.DataBind();
        }

        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            string strMsg;
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable oDT = oBL.CHECK_GDTTT_SUASOVBVAKN_HCTP(Convert.ToDecimal(hddSOPHATHANH_ID.Value));
            if (oDT.Rows.Count > 0 && Convert.ToDecimal(oDT.Rows[0]["vcheck"]) > 0)
            {
                strMsg = "Vụ án đã được chuyển cho thẩm phán, không được phép sửa!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                return;
            }
            else
            {
                string vNguoiKy = ddlNguoiKy.SelectedValue;
                decimal vindex = vNguoiKy.IndexOf("-");
                string v_chucvu = "";
                string v_hoten = "";
                if (!string.IsNullOrEmpty(ddlNguoiKy.SelectedValue))
                {
                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                    v_hoten = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }
                //chỉ cho phép cập nhật Ngày Văn Bản
                DateTime ngaycv = DateTime.ParseExact(txtALL_NGAYCV.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                if (oBL.SOVANBANVAKN_UPDATE(Convert.ToDecimal(hddSOPHATHANH_ID.Value), txtALL_NGAYCV.Text, v_hoten, v_chucvu, UserName) == true)
                {
                    strMsg = "Cập nhật Số Văn bản thành công!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                }
                else
                {
                    strMsg = "Cập nhật Số Văn bản lỗi. Liên hệ với quản trị để được hỗ trợ!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                    return;
                }

                Load_Data(Convert.ToDecimal(hddSOPHATHANH_ID.Value));
            }
        }

        protected void cmdXoaCV_Click(object sender, EventArgs e)
        {
            string strMsg;
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable oDT = oBL.CHECK_GDTTT_SUASOVBVAKN_HCTP(Convert.ToDecimal(hddSOPHATHANH_ID.Value));
            if (oDT.Rows.Count > 0 && Convert.ToDecimal(oDT.Rows[0]["vcheck"]) > 0)
            {
                strMsg = "Vụ án đã được chuyển đi không được phép xóa!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                return;
            }
            else
            {
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                    if (chk.Checked)
                    {
                        string strID = Item.Cells[0].Text;
                        decimal DonID = Convert.ToDecimal(strID);
                        oBL.DELETE_ONE_SOVANBANVAKN(DonID, Convert.ToDecimal(hddSOPHATHANH_ID.Value));
                    }
                }
                strMsg = "Xóa thành cống số Công văn của các đơn đã chọn!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
            }
            Load_Data(Convert.ToDecimal(hddSOPHATHANH_ID.Value));
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            //Response.Redirect("/QLAN/GDTTT/Hoso/QuanlySoVBVAKN.aspx");
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
                    cmdLuu.Visible = cmdXoaCV.Visible = true;
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
        }
    }
}