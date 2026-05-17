using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Web.UI.WebControls;
using BL.GSTP.DONGHEP;
using BL.GSTP.AHS;

namespace WEB.GSTP.QLAN.AHS.SoTham.BanAnST.Popup
{
    public partial class pChonDonKC : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal BanAnID = 0, BiCaoID = 0, VuAnID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
            {
                VuAnID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
                if (!IsPostBack)
                {
                    BiCaoID = (String.IsNullOrEmpty(Request["KCID"] + "")) ? 0 : Convert.ToDecimal(Request["KCID"] + "");

                    LoadDrop();
                    LoadGrid();
                    CheckQuyen();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        void CheckQuyen()
        {
            decimal ID = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();
        }

        void LoadDrop()
        {
            ddlNguoikhangcao.Items.Clear();
            AHS_BICANBICAO_BL oBL = new AHS_BICANBICAO_BL();
            ddlNguoikhangcao.DataSource = oBL.AHS_BICANBICAO_GetListByVuAn(VuAnID);
            ddlNguoikhangcao.DataTextField = "ArrBiCao";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.DataBind();
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlNguoikhangcao.Items.Clear();
            List<AHS_NGUOITHAMGIATOTUNG> lst = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_NGUOITHAMGIATOTUNG item in lst)
                    ddlNguoikhangcao.Items.Add(new ListItem(item.HOTEN, item.ID.ToString()));
            }
            ddlNguoikhangcao.SelectedValue = BiCaoID.ToString();
        }
        public void LoadGrid()
        {
            int hieuluc = 1;
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DONGHEP_BL objBL = new DONGHEP_BL();
            DataTable tbl = objBL.GetDonGhepDonKC_BiAnID(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), VuAnID, BiCaoID, 1, pageindex, pagesize);

            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();
                //lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "chon":
                    string IDDONKHAC = e.CommandArgument.ToString();
                    SetDonGhep(IDDONKHAC);
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "Close()");
                    break;
            }
        }

        private void SetDonGhep(string IDDONKHAC)
        {
            string keyDonID = "THONGTIN.DONKHAC.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            Session[keyDonID] = Convert.ToDecimal(IDDONKHAC);
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //Panel pnChonHinhPhat = (Panel)e.Item.FindControl("pnChonHinhPhat");
                //HiddenField hddToiDanhID = (HiddenField)e.Item.FindControl("hddToiDanhID");
                //decimal curr_toidanh = Convert.ToDecimal(hddToiDanhID.Value);
                //List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lst = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnID
                //                                                                                   && x.BICANID == BiCaoID
                //                                                                                   && x.TOIDANHID == curr_toidanh
                //                                                                                 ).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                //if (lst != null && lst.Count > 0)
                //    pnChonHinhPhat.Visible = true;
                //else
                //    pnChonHinhPhat.Visible = false;
            }
        }
    }
}