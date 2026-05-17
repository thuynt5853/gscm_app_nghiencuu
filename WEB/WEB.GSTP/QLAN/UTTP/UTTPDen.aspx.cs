using BL.GSTP;
using BL.GSTP.UTTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN
{
    public partial class UTTPDen : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session[ENUM_SESSION.SESSION_DONVIID] == null)
                {
                    Response.Redirect("/Trangchu.aspx");
                    Response.End();
                }
                decimal donviId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                var donvi = dt.DM_TOAAN.FirstOrDefault(s => s.ID == donviId);
                if (donvi.LOAITOA == "CAPHUYEN")
                {
                    Response.Redirect("/Trangchu.aspx");
                    Response.End();
                }
                LoadDataQuocGiaUT();
                LoadDataCanBo();
                LoadGrid();
            }
        }
        private void LoadDataQuocGiaUT()
        {
            var dataQuocGiaUT = new DM_DATAITEM_BL().DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            ddlQuocGiaUT.DataSource = dataQuocGiaUT;
            ddlQuocGiaUT.DataTextField = "TEN";
            ddlQuocGiaUT.DataValueField = "ID";
            ddlQuocGiaUT.DataBind();
            ddlQuocGiaUT.Items.Insert(0, new ListItem("--Danh mục--", "0"));
        }
        private void LoadDataCanBo()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlNguoiThucHienUT.DataSource = oCBDT;
            ddlNguoiThucHienUT.DataTextField = "HOTEN";
            ddlNguoiThucHienUT.DataValueField = "ID";
            ddlNguoiThucHienUT.DataBind();
            ddlNguoiThucHienUT.Items.Insert(0, new ListItem("--Danh mục--", "0"));

        }

        


        public void LoadGrid()
        {
            UYTHACTUPHAP_BL bl = new UYTHACTUPHAP_BL();
            int page_size = 20,
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            DataTable oDT = bl.UYTHACTUPHAP_DEN_GETLIST(Convert.ToDecimal(ddlQuocGiaUT.SelectedValue),Convert.ToDecimal(ddlLoaiTimKiem.SelectedValue),Convert.ToDecimal(ddlKetQuaThucHienUT.SelectedValue),txtTuNgay.Text,txtDenNgay.Text,Convert.ToDecimal(ddlNguoiThucHienUT.SelectedValue), txtNoiDung.Text, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), pageindex,page_size);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows.Count);
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
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
        public void xoa(decimal id)
        {

            UYTHACTUPHAPDEN oT = dt.UYTHACTUPHAPDENs.Where(x => x.ID == id).FirstOrDefault();
            dt.UYTHACTUPHAPDENs.Remove(oT);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            //Resetcontrol();
            //lbthongbao.Text = "Xóa thành công!";
        }

        
        string s = "";
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal donvi_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    //pnTimKiem.Visible = false;
                    //pnThemUTTPDen.Visible = true;
                    //loadedit(donvi_id);
                    //hddid.Value = e.CommandArgument.ToString();
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_UTTPDen("+donvi_id+")");
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        //lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(donvi_id);
                    //Resetcontrol();

                    break;
            }

        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            ddlQuocGiaUT.SelectedIndex = 0;
            ddlLoaiTimKiem.SelectedIndex = 0;
            ddlKetQuaThucHienUT.SelectedIndex = 0;
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
            ddlNguoiThucHienUT.SelectedIndex = 0;
            txtNoiDung.Text = "";
        }
        
        protected void btnInDanhSach_Click(object sender, EventArgs e)
        {
            try
            {
                UYTHACTUPHAP_BL bl = new UYTHACTUPHAP_BL();
                DataTable tbl = bl.UYTHACTUPHAP_DEN_INDANHSACH(Convert.ToDecimal(ddlQuocGiaUT.SelectedValue), Convert.ToDecimal(ddlLoaiTimKiem.SelectedValue), Convert.ToDecimal(ddlKetQuaThucHienUT.SelectedValue), txtTuNgay.Text, txtDenNgay.Text, Convert.ToDecimal(ddlNguoiThucHienUT.SelectedValue));
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }

                string TenFile = "UyThacTuPhapDen";
                string KieuFile = ".xls";
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: Table_Str_Totals.Text, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadExcel.aspx?cacheKey=" + cacheKey + "&FileName=" + TenFile + "&Extension=" + KieuFile + "';", true);
                
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        //lbQuayLai_Click
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_UTTPDen(0)");
            //pnTimKiem.Visible = false;
            //pnThemUTTPDen.Visible = true;
        }
        protected void lbQuayLai_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            //pnTimKiem.Visible = true;
            //pnThemUTTPDen.Visible = false;
        }
    }
}