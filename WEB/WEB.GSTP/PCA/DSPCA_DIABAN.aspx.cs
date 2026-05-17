
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.GSTP;
using BL.DonKK;
using BL.GSTP;
using BL.GSTP.Danhmuc;
using Module.Common;

using System.Globalization;


namespace WEB.GSTP.PCA
{
    public partial class DSPCA_DIABAN : System.Web.UI.Page
    {
        //DKKContextContainer dt = new DKKContextContainer();
        private const int ROOT = 0;
        Decimal CurrUserID = 0;
        Decimal PhongBanID = 0;
        Decimal LoginDonViID = 0;
        DataTable tblLanhDao = null;
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            LoginDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {                    
                    LoadDropLanhDao(dropLD, 0, true);
                    LoadDropToaan();
                    LoadGrid();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        void LoadDropToaan()
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL obj = new DM_TOAAN_BL();
            
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            //LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");
            DataTable tbl = obj.DM_TOAAN_DIABAN(CanboID, LoginDonViID);
            
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropToaAn.DataSource = tbl;
                dropToaAn.DataValueField = "ID";
                dropToaAn.DataTextField = "TEN";
                dropToaAn.DataBind();
                dropToaAn.Items.Insert(0, new ListItem("--Tất cả--", "0"));
            }
            else
                dropToaAn.Items.Insert(0, new ListItem("--Tất cả--", "0"));
        }
        void LoadDropLanhDao(DropDownList control, Decimal LanhDaoID_select, bool ShowNodeEmpty)
        {
            control.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            

            if (tblLanhDao == null || tblLanhDao.Rows.Count==0)
                tblLanhDao = obj.DM_PCA_GetByDONVI(LoginDonViID);
            if (tblLanhDao != null && tblLanhDao.Rows.Count>0)
            {
                control.DataSource = tblLanhDao;
                control.DataValueField = "ID";
                control.DataTextField = "hoten";
                control.DataBind();
                if (ShowNodeEmpty)
                    control.Items.Insert(0, new ListItem("--Tất cả--", "0"));
                if (LanhDaoID_select > 0)
                    Cls_Comon.SetValueComboBox(control, LanhDaoID_select);
            }
            else
                control.Items.Insert(0, new ListItem("--Tất cả--", "0"));
        }
        public void LoadGrid()
        {
            lblThongBao.Text = "";
            DataTable tbl = null;
            int page_size = Convert.ToInt32(hddPageSize.Value);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            decimal LanhDaoID = Convert.ToDecimal(dropLD.SelectedValue);
            decimal ToaAn = Convert.ToDecimal(dropToaAn.SelectedValue);
            DM_CANBO_BL obj = new DM_CANBO_BL();
            tblLanhDao = obj.DM_PCA_GetByDONVI(LoginDonViID);

            tbl = obj.DM_PCA_AND_DIABAN(LoginDonViID, LanhDaoID, ToaAn);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
            }
            else
            {
                rpt.Visible = false;
                lblThongBao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
        
        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }

        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                int lanhdaoid = (string.IsNullOrEmpty(dv["PCAID"] + "")) ? 0 : Convert.ToInt32(dv["PCAID"] + "");
                DropDownList dropLanhDao = (DropDownList)e.Item.FindControl("dropLanhDao");
                LoadDropLanhDao(dropLanhDao, lanhdaoid, true);
                
                Cls_Comon.SetValueComboBox(dropLanhDao, lanhdaoid);
               
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }
        }
        #endregion

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                Decimal ToaanID = 0, CurrPCAID = 0, Old_PCAID = 0;
                DateTime NgayPC;
                foreach(RepeaterItem item in rpt.Items)
                {
                    ToaanID = CurrPCAID = Old_PCAID = 0;
                    DropDownList drop = (DropDownList)item.FindControl("dropLanhDao");
                    HiddenField hddPCAID = (HiddenField)item.FindControl("hddPCAID");
                    HiddenField hddToaanID = (HiddenField)item.FindControl("hddToaanID");
                    TextBox txtNgayPC = (TextBox)item.FindControl("txtNgayPC");
                    if (!String.IsNullOrEmpty(txtNgayPC.Text))
                        NgayPC = DateTime.Parse(txtNgayPC.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    else
                        NgayPC = DateTime.Now;

                    DM_CANBO_BL obj = new DM_CANBO_BL();
                    if (!String.IsNullOrEmpty (hddToaanID.Value ))
                    {
                        ToaanID = Convert.ToDecimal(hddToaanID.Value);
                        if (!String.IsNullOrEmpty(hddPCAID.Value))
                            Old_PCAID = Convert.ToDecimal(hddPCAID.Value);
                        else
                            Old_PCAID = 0;
                        CurrPCAID = Convert.ToDecimal(drop.SelectedValue);
                       
                        //Cap nhat cau hinh
                        obj.UPDATE_PCA_AND_DIABAN(LoginDonViID, CurrPCAID, Old_PCAID, ToaanID, NgayPC);
                    }
                }
                
                lblThongBao.Text = "Cập nhật dữ liệu thành công!";
            }
            catch (Exception ex) { lblThongBao.Text = ex.Message; }

        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            //SetGetSessionTK(true);
            String SessionName = "GDTTT_ConfigTTV".ToUpper();
            
            //----------------------------------------
            DataTable tbl = null;
            int page_size =50000;
            int pageindex = 1;

            decimal LanhDaoID = Convert.ToDecimal(dropLD.SelectedValue);
            decimal TTV = Convert.ToDecimal(dropToaAn.SelectedValue);
            DM_CANBO_BL obj = new DM_CANBO_BL();
            tbl = obj.DM_CANBO_PB_CHUCDANH(PhongBanID, "TTV", LanhDaoID, TTV, pageindex, page_size);
            Session[SessionName] = tbl;

            string URL = "/QLAN/GDTTT/QT/ViewBC.aspx";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupCenter('" + URL + "','In báo cáo',1000,600)");

        }
    }
}