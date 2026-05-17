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

namespace WEB.GSTP.QTCucTHA.Nhomnguoidung
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            
                LoadCombobox();
                Load_Data();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
              
                Cls_Comon.SetButton(cmdThemmoi, oPer.CAPNHAT);
            }
        }

        private void LoadCombobox()
        {

            QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
            ddlDonvi.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME_THADS(ENUM_DANHMUC.LOAITOA);
            ddlDonvi.DataTextField = "TEN";
            ddlDonvi.DataValueField = "MA";
            ddlDonvi.DataBind();
            ddlDonvi.Items.Insert(0, new ListItem("--Tất cả--", "TATCA"));
        }

        private void Load_Data()
        {
            QT_TUPHAP_BL oBL = new QT_TUPHAP_BL();
           DataTable lst = oBL.QT_NHOMNGUOIDUNG_SEARCHBY_THADS(ddlDonvi.SelectedValue, txtTennhom.Text);
            int iCount = lst.Rows.Count;
            if (iCount > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(iCount, 20).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + iCount.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

            }
            else
            {
                hddTotalPage.Value = "1";
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
             
            }
            dgList.DataSource = lst;
            dgList.DataBind();
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
            {
                case "Phanquyen":
                    Response.Redirect("Phanquyen.aspx?CID=" + e.CommandArgument.ToString());
                    break;
                case "Sua":
                    Response.Redirect("Capnhat.aspx?CID=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền cập nhật!";
                        return;
                    }
                    decimal CID = Convert.ToDecimal(e.CommandArgument);
                    if(dt.TUPHAP_NGUOISUDUNG.Where(x=>x.NHOMNSDID==CID).ToList().Count>0)
                    {
                        lbthongbao.Text = "Nhóm quyền đã được sử dụng, không được phép xóa!";
                        return;
                    }
                    TUPHAP_NHOMNGUOIDUNG oT = dt.TUPHAP_NHOMNGUOIDUNG.Where(x => x.ID == CID).FirstOrDefault();
                    dt.TUPHAP_NHOMNGUOIDUNG.Remove(oT);
                    dt.SaveChanges();
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