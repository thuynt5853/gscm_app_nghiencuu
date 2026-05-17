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
    public partial class Danhsach : System.Web.UI.Page
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
                Load_Data();
                MenuPermission oPer = QT_TUPHAP_BL.GetMenuPer_THADS(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
            }
        }

        private void LoadCombobox()
        {
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
        }

        private void Load_Data()
        {
            QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
            try
            {
            DataTable oDT = oBL.QT_NGUOIDUNG_SEARCH_THADS_CLIENT(Convert.ToDecimal(ddlDonvi.SelectedValue), txtDonvi.Text, Convert.ToDecimal(ddlLoaiNhom.SelectedValue), txtUserName.Text, txtHoten.Text);
            if (oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, 20).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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

            dgList.DataSource = oDT;
            dgList.DataBind();
            }
            catch (Exception ex)
            { lbthongbao.Text = ex.Message; }

        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }


        protected void btnThemmoi_Click(object sender, EventArgs e)
        {

            Response.Redirect("Capnhat.aspx");

        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
           
            switch (e.CommandName)
            { //--------    
                case "Reset":
                    Response.Redirect("ResetPass.aspx?vID=" + e.CommandArgument.ToString());
                    break;
                case "Sua":
                    Response.Redirect("Capnhat.aspx?CID=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    MenuPermission oPer = QT_TUPHAP_BL.GetMenuPer_THADS(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(e.CommandArgument);
                    QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
                    oBL.DeleteByID_THADS(ID);                   
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
            }
          

        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        #endregion
    }
}