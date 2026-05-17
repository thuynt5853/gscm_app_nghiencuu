using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.CanBoToaAn
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
      
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropToaAn();
                    LoadDropChucDanh();
                    LoadDropChucVu();
                    if (Session["SSCB_TA"] != null) DropToaAn.SelectedValue = Session["SSCB_TA"] + "";
                    if (Session["SSCB_PB"] != null) ddlPhongban.SelectedValue = Session["SSCB_PB"] + "";
                    if (Session["SSCB_CD"] != null) DropChucDanh.SelectedValue = Session["SSCB_CD"] + "";
                    if (Session["SSCB_CV"] != null) DropChucVu.SelectedValue = Session["SSCB_CV"] + "";
                    txKey.Text = Session["SSCB_TK"] + "";
                  
                    hddPageIndex.Value = "1";
                    Load_Data();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        private void LoadDropToaAn()
        {
            DropToaAn.Items.Clear();
            
            decimal DonViLogin = 0;
            if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
            {
                DonViLogin = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            }
            if (DonViLogin != 1)
            {
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViLogin).FirstOrDefault();
                DropToaAn.Items.Add(new ListItem(oT.MA_TEN,oT.ID.ToString()));
            }
            else
            {
                DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                DropToaAn.DataSource = oBL.DM_TOAAN_GETBY(DonViLogin);
                DropToaAn.DataTextField = "arrTEN";
                DropToaAn.DataValueField = "ID";
                DropToaAn.DataBind();
            }
            LoadPhongban();
            LoadPhongban_sub();
        }

        //private void LoadPhongban()
        //{
        //    decimal IDToaAn = Convert.ToDecimal(DropToaAn.SelectedValue);
        //    ddlPhongban.Items.Clear();
        //    ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == IDToaAn).OrderBy(x => x.TENPHONGBAN).ToList();
        //    ddlPhongban.DataTextField = "TENPHONGBAN";
        //    ddlPhongban.DataValueField = "ID";
        //    ddlPhongban.DataBind();
        //    ddlPhongban.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        //}
        private void LoadPhongban()
        {
            ddlPhongban.Items.Clear();
            decimal VTOAANID = Convert.ToDecimal(DropToaAn.SelectedValue);
            DM_TOAAN obta = dt.DM_TOAAN.Where(x => x.ID == VTOAANID).FirstOrDefault<DM_TOAAN>();
            if (obta.LOAITOA == "CAPTINH")
            {
                ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == null && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
                //List<DM_PHONGBAN> ilspb=dt.DM_PHONGBAN.Where(x => x.TOAANID == null && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
            }
            else
            {
                ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == VTOAANID && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
            }
            ddlPhongban.DataTextField = "TENPHONGBAN";
            ddlPhongban.DataValueField = "ID";
            ddlPhongban.DataBind();
            ddlPhongban.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        private void LoadPhongban_sub()
        {
            decimal V_CAPCHAID = 0;
            decimal VTOAANID = Convert.ToDecimal(DropToaAn.SelectedValue);
            ddlPhongban_sub.Items.Clear();
            if (ddlPhongban.SelectedValue != "0")
            {
                V_CAPCHAID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                ddlPhongban_sub.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == VTOAANID && x.CAPCHAID == V_CAPCHAID).ToList();
                ddlPhongban_sub.DataTextField = "TENPHONGBAN";
                ddlPhongban_sub.DataValueField = "ID";
                ddlPhongban_sub.DataBind();
                ddlPhongban_sub.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            else
            {
                ddlPhongban_sub.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
        }
        public void LoadDropChucDanh()
        {
            DropChucDanh.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dmChucDanh = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.CHUCDANH);
            if (dmChucDanh != null && dmChucDanh.Rows.Count > 0)
            {
                DropChucDanh.DataSource = dmChucDanh;
                DropChucDanh.DataTextField = "TEN";
                DropChucDanh.DataValueField = "ID";
                DropChucDanh.DataBind();
            }
            DropChucDanh.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        public void LoadDropChucVu()
        {
            DropChucVu.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dmChucVu = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.CHUCVU);
            if (dmChucVu != null && dmChucVu.Rows.Count > 0)
            {
                DropChucVu.DataSource = dmChucVu;
                DropChucVu.DataTextField = "TEN";
                DropChucVu.DataValueField = "ID";
                DropChucVu.DataBind();
            }
            DropChucVu.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        private void Load_Data()
        {
            DM_CANBO_BL CanBoBL = new DM_CANBO_BL();
            decimal ToaAnID = Convert.ToDecimal(DropToaAn.SelectedValue), ChucDanhID = Convert.ToDecimal(DropChucDanh.SelectedValue), ChucVuID = Convert.ToDecimal(DropChucVu.SelectedValue);
            decimal PhongbanID = Convert.ToDecimal(ddlPhongban.SelectedValue),TrangThaiCongTac=Convert.ToDecimal(DropTrangThaiCongTac.SelectedValue);
            string GroupChucDanhName = ENUM_DANHMUC.CHUCDANH, GroupChuVu = ENUM_DANHMUC.CHUCVU, KeySearch = txKey.Text.Trim();
            int CurPage = Convert.ToInt32(hddPageIndex.Value), PageSize = Convert.ToInt32(hddPageSize.Value),SearchAll=Convert.ToInt32(chkAll.Checked);
            DataTable oDT = CanBoBL.DM_CANBO_SEARCH(ToaAnID, PhongbanID,ddlPhongban_sub.SelectedValue, ChucDanhID, ChucVuID, TrangThaiCongTac, GroupChucDanhName, GroupChuVu, KeySearch, CurPage, PageSize, SearchAll);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(oDT.Rows[0]["Total"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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
            dgList.CurrentPageIndex = 0;
            dgList.PageSize = PageSize;
            dgList.DataSource = oDT;
            dgList.DataBind();

        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                Session["SSCB_TA"] = DropToaAn.SelectedValue;
                Session["SSCB_PB"] = ddlPhongban.SelectedValue;
                Session["SSCB_CD"] = DropChucDanh.SelectedValue;
                Session["SSCB_CV"] = DropChucVu.SelectedValue;
                Session["SSCB_TK"] = txKey.Text;
                hddPageIndex.Value = "1";
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            Response.Redirect("Capnhat.aspx");
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Sua":
                    Response.Redirect("Capnhat.aspx?cb=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument);
                    DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == ID).FirstOrDefault<DM_CANBO>();
                    if (cbo != null)
                    {
                        dt.DM_CANBO.Remove(cbo);
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    lbtthongbao.Text = "Xóa thành công!";
                    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    lbtSua.Visible = oPer.CAPNHAT; lbtXoa.Visible = oPer.XOA;
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        #endregion
        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPhongban();
            LoadPhongban_sub();
        }
        protected void ddlPhongban_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPhongban_sub();
        }
    }
}