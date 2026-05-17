using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using BL.GSTP.BANGSETGET;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.AnTH
{
    public partial class DanhSachDonAnTH : System.Web.UI.Page
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
        String SessionSearch = "TTTKVISIBLE";
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadAll_TTV();
                    LoadDropToaAn();
                    if ((Session[SessionSearch] + "") == "0")
                    {
                        lbtTTTK.Text = "[ Thu gọn ]";
                        pnTTTK.Visible = true;
                    }
                    //---------------------------
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnThemmoi, oPer.TAOMOI);
                    Load_Data();
                }
                //if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                //    btnThemmoi.Visible = false;
            }
            else
                Response.Redirect("/Login.aspx");
        }
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
                Response.Redirect("ThemMoi_DonAnTH.aspx?type=newhs");
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            Load_Data();
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
        }
        protected void lbtTTTK_Click(object sender, EventArgs e)
        {
            if (pnTTTK.Visible == false)
            {
                lbtTTTK.Text = "[ Thu gọn ]";
                pnTTTK.Visible = true;
                Session[SessionSearch] = "0";
            }
            else
            {
                lbtTTTK.Text = "[ Nâng cao ]";
                pnTTTK.Visible = false;
                Session[SessionSearch] = "1";
            }
        }
        void LoadAll_TTV()
        {
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            //Thẩm tra viên
            DataTable tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
            ddlThamtravien_search.DataSource = tblTheoPB;
            ddlThamtravien_search.DataTextField = "HOTEN";
            ddlThamtravien_search.DataValueField = "ID";
            ddlThamtravien_search.DataBind();
            ddlThamtravien_search.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        private void Load_Data()
        {
            dgList.Visible = false;
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = getDS(page_size, pageindex);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án trong <b>" + hddTotalPage.Value + "</b> trang";
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
            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            dgList.DataSource = oDT;
            dgList.DataBind();
            dgList.Visible = true;
        }
        void LoadDropToaAn()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
        }

        private DataTable getDS(int page_size, int pageindex)
        {
         
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();

            decimal Loaidon = Convert.ToDecimal(ddlLoaidon.SelectedValue);
            decimal Nguoinhan = Convert.ToDecimal(ddlThamtravien_search.SelectedValue);
            decimal Loaingay = Convert.ToDecimal(dropLoaiNgay.SelectedValue);
            DateTime? vTuNgay = txtGQD_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vDenNgay = txtGQD_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtGQD_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            string vNguoigui = txtNguoigui.Text;
            string vDiachi = txt_DiachiNguoigui.Text;

            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim();
            DateTime? vNgayBAQD = txtNgayBAQD.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBAQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            
            DataTable tbl = null;
            tbl = oBL.Gdttt_Tuhinh_Don_Search(Loaidon, Nguoinhan, Loaingay, vTuNgay, vDenNgay, 
                vNguoigui, vDiachi,vSoBAQD,vNgayBAQD,vToaRaBAQD,pageindex, page_size);
            return tbl;
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                lblSua.Visible = oPer.CAPNHAT;
                lbtXoa.Visible = oPer.XOA;
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    string  _ID = e.CommandArgument.ToString();
                     Response.Redirect("ThemMoi_DonAnTH.aspx?ID=" + _ID);
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
                    decimal _dele  =  oBL.Gdttt_Tuhinh_Don_Delete(e.CommandArgument+"");
                    if (_dele == 0)
                        lbtthongbao.Text = "Bạn không được xóa khi dữ liệu nhập giải quyết xin ân giảm có thông tin!";
                    Load_Data();
                    break;
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            //  dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion
    }
}