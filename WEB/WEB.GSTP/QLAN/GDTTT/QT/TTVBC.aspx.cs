
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


namespace WEB.GSTP.QLAN.GDTTT.QT
{
    public partial class TTVBC : System.Web.UI.Page
    {
        //DKKContextContainer dt = new DKKContextContainer();
        private const int ROOT = 0;
        Decimal CurrUserID = 0;
        Decimal PhongBanID = 0;
        DataTable tblLanhDao = null;
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");  
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {                    
                    LoadDropLanhDao(dropLD, 0, true);
                    LoadDropTTV();
                    LoadGrid();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        void LoadDropTTV()
        {
            dropTTV.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTTV.DataSource = tbl;
                dropTTV.DataValueField = "CanBoID";
                dropTTV.DataTextField = "TenCanBo";
                dropTTV.DataBind();
                dropTTV.Items.Insert(0, new ListItem("--Tất cả--", "0"));
            }
            else
                dropTTV.Items.Insert(0, new ListItem("--Tất cả--", "0"));
        }
        void LoadDropLanhDao(DropDownList control, Decimal LanhDaoID_select, bool ShowNodeEmpty)
        {
            control.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            if (tblLanhDao == null || tblLanhDao.Rows.Count==0)
                tblLanhDao = obj.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);
            if (tblLanhDao != null && tblLanhDao.Rows.Count>0)
            {
                control.DataSource = tblLanhDao;
                control.DataValueField = "ID";
                control.DataTextField = "MA_TEN";
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
            decimal TTV = Convert.ToDecimal(dropTTV.SelectedValue);
            DM_CANBO_BL obj = new DM_CANBO_BL();
            tblLanhDao = obj.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);

            tbl = obj.DM_CANBO_PB_CHUCDANH(PhongBanID, "TTV", LanhDaoID, TTV, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["Total"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                 lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                
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
                int lanhdaoid = (string.IsNullOrEmpty(dv["LanhDaoID"] + "")) ? 0 : Convert.ToInt32(dv["LanhDaoID"] + "");
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
                Decimal CanBoID = 0, CurrLanhDaoID=0, Old_LanhDaoID =0;
                foreach(RepeaterItem item in rpt.Items)
                {
                    CanBoID = CurrLanhDaoID = Old_LanhDaoID = 0;
                    DropDownList drop = (DropDownList)item.FindControl("dropLanhDao");
                    HiddenField hddCanBoID = (HiddenField)item.FindControl("hddCanBoID");
                    HiddenField hddLanhDaoID = (HiddenField)item.FindControl("hddLanhDaoID");
                    GDTTT_CACVU_CAUHINH objConfig = null;
                    if (!String.IsNullOrEmpty (hddCanBoID.Value ))
                    {
                        CanBoID = Convert.ToDecimal(hddCanBoID.Value);
                        Old_LanhDaoID = Convert.ToDecimal(hddLanhDaoID.Value);
                        CurrLanhDaoID = Convert.ToDecimal(drop.SelectedValue);

                        if (CurrLanhDaoID != Old_LanhDaoID)
                        {
                            if (CurrLanhDaoID ==0)
                            {
                                //Xoa trong bang cau hinh
                                try
                                {
                                    objConfig = dt.GDTTT_CACVU_CAUHINH.Where(x => x.THAMTRAVIENID == CanBoID && x.LANHDAOID == Old_LanhDaoID).FirstOrDefault();
                                    if (objConfig !=null)
                                    {
                                        dt.GDTTT_CACVU_CAUHINH.Remove(objConfig);
                                        dt.SaveChanges();
                                    }
                                }catch(Exception ex) { }
                            }
                            else if (CurrLanhDaoID>0)
                            {
                                try
                                {
                                    if (Old_LanhDaoID > 0)
                                    {
                                        //update
                                        objConfig = dt.GDTTT_CACVU_CAUHINH.Where(x => x.THAMTRAVIENID == CanBoID
                                                                                   && x.LANHDAOID == Old_LanhDaoID).FirstOrDefault();
                                        if (objConfig != null)
                                            objConfig.LANHDAOID = CurrLanhDaoID;
                                    }
                                    else
                                    {
                                        //insert
                                        objConfig = new GDTTT_CACVU_CAUHINH();
                                        objConfig.LANHDAOID = CurrLanhDaoID;
                                        objConfig.THAMTRAVIENID = CanBoID;
                                        objConfig.PHONGBANID = PhongBanID;
                                        dt.GDTTT_CACVU_CAUHINH.Add(objConfig);
                                    }                                   
                                    dt.SaveChanges();
                                }
                                catch (Exception ex) { }
                            }
                        }
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
            decimal TTV = Convert.ToDecimal(dropTTV.SelectedValue);
            DM_CANBO_BL obj = new DM_CANBO_BL();
            tbl = obj.DM_CANBO_PB_CHUCDANH(PhongBanID, "TTV", LanhDaoID, TTV, pageindex, page_size);
            Session[SessionName] = tbl;

            string URL = "/QLAN/GDTTT/QT/ViewBC.aspx";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupCenter('" + URL + "','In báo cáo',1000,600)");

        }
    }
}