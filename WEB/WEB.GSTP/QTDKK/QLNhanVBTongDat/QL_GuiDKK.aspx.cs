using BL.GSTP;
using BL.GSTP.ADS;
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
using BL.DonKK;

namespace WEB.GSTP.QTDKK.QLNhanVBTongDat
{
    public partial class QL_GuiDKK : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
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
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadCombobox();
                    if (Session["SSND_TA"] != null) ddlDonvi.SelectedValue = Session["SSND_TA"] + "";                   
                    Load_Data();
                }
            }
            else Response.Redirect("/Login.aspx");
        }
        private void LoadCombobox()
        {
            load_donvi();
            LoadDrop_trangthai();
        }
        void load_donvi()
        {
            string strDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            if (strDonViID != "")
            {
                decimal DonViID = Convert.ToDecimal(strDonViID);
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
                if (oT.LOAITOA == "CAPCAO")
                {
                    ddlDonvi.Items.Insert(0, new ListItem(oT.TEN, oT.ID.ToString()));
                }
                else
                {
                    DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                    ddlDonvi.DataSource = oBL.DM_TOAAN_GETBY(DonViID);
                    ddlDonvi.DataTextField = "arrTEN";
                    ddlDonvi.DataValueField = "ID";
                    ddlDonvi.DataBind();
                }
                ddlDonvi.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
        }
        void LoadDrop_trangthai()
        {
            dropTrangThai.Items.Clear();
            dropTrangThai.Items.Add(new ListItem("---Tất cả----",""));
            dropTrangThai.Items.Add(new ListItem("Đơn chưa gửi", "10"));
            dropTrangThai.Items.Add(new ListItem("Đơn đã gửi và chờ giải quyết", "0"));
            dropTrangThai.Items.Add(new ListItem("Đơn chờ bổ sung theo yêu cầu của Tòa án","4"));
            dropTrangThai.Items.Add(new ListItem("Đơn bị trả lại do chưa đủ điều kiện","3"));
            dropTrangThai.Items.Add(new ListItem("Đơn đã thụ lý","5"));
            dropTrangThai.Items.Add(new ListItem("Đã tiếp nhận đơn", "1"));
            dropTrangThai.Items.Add(new ListItem("Chuyển đơn ngoài ngành", "2"));
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            Session["SSND_TA"] = ddlDonvi.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                   case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    String _ID = e.CommandArgument + "";
                    DOnKK_User_DKNhanVB_BL obj_M = new DOnKK_User_DKNhanVB_BL();
                    String _MESS = "";
                    obj_M.DKK_DELETE(_ID, ref _MESS);
                    if (_MESS == "")
                    {
                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        Load_Data();
                    }
                    else
                    {
                        lbtthongbao.Text = "Xóa không thành công. Cần xóa các thông tin đã cập nhật của vụ việc có mã: "+ _MESS;
                        return;
                    }
                    break;
            }
        }
        private void Load_Data()
        {
            DataTable oDT = null;
            DOnKK_User_DKNhanVB_BL oBL = new DOnKK_User_DKNhanVB_BL();
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
             pageindex = Convert.ToInt32(hddPageIndex.Value),
             count_all = 0;
            oDT = oBL.GetList_data_Gui_DKK(txt_MAVUVIEC.Text.Trim(),Convert.ToInt32(check_child.Checked),Session[ENUM_SESSION.SESSION_DONVIID]+"",Session["CAP_XET_XU"]+"",txt_TENNGUOIGUI.Text.Trim(),txt_MOBILE.Text.Trim(),txt_EMAIL.Text.Trim(),ddlDonvi.SelectedValue, dropTrangThai.SelectedValue,txt_TUNGAY.Text, txt_DENNGAY.Text, pageindex, page_size);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = page_size;
            dgList.DataSource = oDT;
            dgList.DataBind();
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            ddlDonvi.SelectedValue = string.Empty;
            dropTrangThai.SelectedValue = string.Empty;
            txt_MAVUVIEC.Text = string.Empty;
            txt_TUNGAY.Text = string.Empty;
            txt_DENNGAY.Text = string.Empty;
            txt_TENNGUOIGUI.Text = string.Empty;
            txt_MOBILE.Text = string.Empty;
            txt_EMAIL.Text = string.Empty;
            lbtthongbao.Text = string.Empty;
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion
    }
}