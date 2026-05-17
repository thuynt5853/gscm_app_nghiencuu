using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using BL.GSTP;

namespace WEB.GSTP.Quantri.Nhomnguoidung
{
    public partial class Capnhat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCombobox();
                string strID = Request["CID"] + "";
                if (strID != "")
                {
                    decimal CID = Convert.ToDecimal(strID);
                    QT_NHOMNGUOIDUNG oT = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CID).FirstOrDefault();
                    if (oT == null) return;
                    ddlDonvi.SelectedValue = oT.LOAITOA+"";
                    ddlLoaiNhom.SelectedValue = oT.LOAI + "";
                    txtTennhom.Text = oT.TEN;                 
                  
                }
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdCapnhat, oPer.CAPNHAT);
                
            }
        }

        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlDonvi.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAITOA);
            ddlDonvi.DataTextField = "MA_TEN";
            ddlDonvi.DataValueField = "MA";
            ddlDonvi.DataBind();
            ddlLoaiNhom.Items.Clear();           
                ddlLoaiNhom.Items.Add(new ListItem("Không cho phép hỗ trợ nhập dữ liệu cho đơn vị cấp dưới, cán bộ khác", "0"));
                ddlLoaiNhom.Items.Add(new ListItem("Cho phép hỗ trợ nhập dữ liệu cho đơn vị cấp dưới, cán bộ khác", "1"));
                
            
        }


        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            string strID = Request["CID"] + "";
         
            if (strID == "")
            {
                QT_NHOMNGUOIDUNG oT = new QT_NHOMNGUOIDUNG();
                oT.LOAITOA = ddlDonvi.SelectedValue;
                oT.TEN = txtTennhom.Text;             
                oT.LOAI = Convert.ToByte(ddlLoaiNhom.SelectedValue);
                oT.NGAYTAO = DateTime.Now;
                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.QT_NHOMNGUOIDUNG.Add(oT);
                dt.SaveChanges();
            }
            else
            {
                decimal CID = Convert.ToDecimal(strID);
                QT_NHOMNGUOIDUNG oT = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CID).FirstOrDefault();
                if (oT == null) return;
                oT.LOAITOA = ddlDonvi.SelectedValue;
                oT.TEN = txtTennhom.Text;
            
                oT.LOAI = Convert.ToByte(ddlLoaiNhom.SelectedValue);
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            Response.Redirect("Danhsach.aspx");
        }

        protected void lblquaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
    }
}
