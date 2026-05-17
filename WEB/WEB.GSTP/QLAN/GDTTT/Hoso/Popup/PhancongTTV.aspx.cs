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
    public partial class PhancongTTV : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DataTable lstTTV;
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
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                    lstTTV = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_TTV);

                    Load_Data();
                }
            }
        }
        private DataTable getDS()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaRaBAQD = 0, HinhThucDon = 0, DiaChiTinh = 0, DiaChiHuyen = 0, TraLoi = 0, vNoichuyen = 0, vTrangthai = 0, vCD_DONVIID = 0, vCD_TA_TRANGTHAI = 0, vIsThuLy = 0, vPhanloaixuly = 0;
            string SoBAQD, NgayBAQD, NguoiGui, SoCMND, SoHieuDon, DiaChiCT, SoCongVan, NgayCongVan, strNguoiNhap = "", vArrSelectID = "", vCD_TENDONVI;
            DateTime? TuNgay, DenNgay, vNgaychuyenTu, vNgaychuyenDen;

            NguoiGui = Session[SS_TK.NGUOIGUI] + "";
            SoBAQD = Session[SS_TK.SOBAQD] + "";
            NgayBAQD = Session[SS_TK.NGAYBAQD] + "";
            if (Session[SS_TK.TOAANXX] != null) ToaRaBAQD = Convert.ToDecimal(Session[SS_TK.TOAANXX]);
            TuNgay = (Session[SS_TK.NGAYNHANTU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHANTU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            DenNgay = (Session[SS_TK.NGAYNHANDEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYNHANDEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            if (Session[SS_TK.LOAICHUYEN] != null) vNoichuyen = Convert.ToDecimal(Session[SS_TK.LOAICHUYEN]);
            if (Session[SS_TK.PHONGBANCHUYEN] != null) vCD_DONVIID = Convert.ToDecimal(Session[SS_TK.PHONGBANCHUYEN]);
            if (Session[SS_TK.DIEUKIENCHUYEN] != null) vCD_TA_TRANGTHAI = Convert.ToDecimal(Session[SS_TK.DIEUKIENCHUYEN]);
            vNgaychuyenTu = (Session[SS_TK.NGAYCHUYENTU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYCHUYENTU] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            vNgaychuyenDen = (Session[SS_TK.NGAYCHUYENDEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.NGAYCHUYENDEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            if (Session[SS_TK.TOAKHACID] != null && vNoichuyen > 0) vCD_DONVIID = Convert.ToDecimal(Session[SS_TK.TOAKHACID]);
            vCD_TENDONVI = Session[SS_TK.TENNGOAITOAAN] + "";
            if (Session[SS_TK.THULYDON] != null) vIsThuLy = Convert.ToDecimal(Session[SS_TK.THULYDON]);
            if (Session[SS_TK.HINHTHUCDON] != null) HinhThucDon = Convert.ToDecimal(Session[SS_TK.HINHTHUCDON]);
            SoCMND = Session[SS_TK.SOCMND] + "";
            SoHieuDon = Session[SS_TK.MADON] + "";
            if (Session[SS_TK.TINHID] != null) DiaChiTinh = Convert.ToDecimal(Session[SS_TK.TINHID]);
            if (Session[SS_TK.HUYENID] != null) DiaChiHuyen = Convert.ToDecimal(Session[SS_TK.HUYENID]);
            DiaChiCT = Session[SS_TK.DIACHICHITIET] + "";
            if (Session[SS_TK.TRALOIDON] != null) TraLoi = Convert.ToDecimal(Session[SS_TK.TRALOIDON]);
            SoCongVan = Session[SS_TK.SOCV] + "";
            NgayCongVan = Session[SS_TK.NGAYCV] + "";
            if (Session[SS_TK.TRANGTHAICHUYEN] != null) vTrangthai = Convert.ToDecimal(Session[SS_TK.TRANGTHAICHUYEN]);
            DateTime? vNgayThulyTu = (Session[SS_TK.THULY_TU] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.THULY_TU]+""), cul, DateTimeStyles.NoCurrentDateDefault)
               , vNgayThulyDen = (Session[SS_TK.THULY_DEN] + "") == "" ? (DateTime?)null : DateTime.Parse((Session[SS_TK.THULY_DEN] + ""), cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = Session[SS_TK.SOTHULY] + "";

            decimal vPhancongTTV = 0;
            if (Session[SS_TK.PHANCONGTTV] != null) vPhancongTTV = Convert.ToDecimal(Session[SS_TK.PHANCONGTTV]);
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            decimal vloaian = Convert.ToDecimal(Session[SS_TK.LOAIAN]); ;
            DataTable oDT = oBL.GDTTT_GIAIQUYET_SEARCH(null,"0",ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
               SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
               DiaChiCT, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
               vTrangthai, vCD_DONVIID, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
               , vNgayThulyTu, vNgayThulyDen, vSoThuly, vPhancongTTV,vloaian,0, 2,0,0,pageindex, page_size);
            return oDT;
        }
        private void Load_Data()
        {
            DataTable oDT = getDS();
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> đơn trong <b>" + hddTotalPage.Value + "</b> trang";
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

        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            foreach (DataGridItem item in dgList.Items)
            {
                DropDownList ddlTTV = (DropDownList)item.FindControl("ddlTTV");              
                string strID = item.Cells[0].Text;
                decimal ID = Convert.ToDecimal(strID);
                GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                obj.GQ_THAMTRAVIENID = Convert.ToDecimal(ddlTTV.SelectedValue);
                obj.GQ_NGAYPHANCONG = DateTime.Now;
                dt.SaveChanges();
            }
            Cls_Comon.CallFunctionJS(this, this.GetType(), "window.opener.location.reload();window.close();");
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

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    DropDownList ddlTTV = (DropDownList)e.Item.FindControl("ddlTTV");
                    HiddenField hddTTVID = (HiddenField)e.Item.FindControl("hddTTVID");
                    ddlTTV.DataSource = lstTTV;
                    ddlTTV.DataTextField = "MA_TEN";
                    ddlTTV.DataValueField = "ID";
                    ddlTTV.DataBind();
                    ddlTTV.Items.Insert(0, new ListItem("--Chọn", "0"));
                    if (hddTTVID.Value != "")
                        ddlTTV.SelectedValue = hddTTVID.Value;

                }
                catch (Exception ex) { }
            }
        }

      
    }
}