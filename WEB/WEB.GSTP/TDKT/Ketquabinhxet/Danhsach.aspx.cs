using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.TDKT.Ketquabinhxet
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const int DALUU = 1, GUITRINH = 2, TRALAI = 3, THIDUA = 1, KHENTHUONG = 2, KYLUAT = 3;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                if (!IsPostBack)
                {
                    LoadDropDonVi();
                    LoadDropHinhThuc();
                    if (Request["pag"] + "" != "")
                    {
                        int PageIndex = 0;
                        if (int.TryParse(Request["pag"] + "", out PageIndex))
                        {
                            hddPageIndex.Value = PageIndex.ToString();
                        }
                        else
                        {
                            hddPageIndex.Value = "1";
                        }
                    }
                    else
                    {
                        hddPageIndex.Value = "1";
                    }
                    LoadData();
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDropDonVi()
        {
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            string LoaiToa = "";
            DM_TOAAN ObjTA = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
            if (ObjTA != null)
            {
                LoaiToa = ObjTA.LOAITOA;
            }
            if (LoaiToa == "TOICAO")
            {
                DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                DropDonVi.DataSource = oBL.DM_TOAAN_GETBY(DonViLoginID);
                DropDonVi.DataTextField = "arrTEN";
                DropDonVi.DataValueField = "ID";
                DropDonVi.DataBind();

                DropDonVi.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
            {
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
                if (oT != null)
                    DropDonVi.Items.Add(new ListItem(oT.MA_TEN, oT.ID.ToString()));
                else
                    DropDonVi.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }
        private void LoadDropHinhThuc()
        {
            DropHinhThuc.Items.Clear();
            decimal LoaiDeNghi = Convert.ToDecimal(DropLoaiDeNghi.SelectedValue);
            string GroupName = "";
            if (LoaiDeNghi == KYLUAT)
            {
                GroupName = ENUM_DANHMUC.DM_HINHTHUC_KYLUAT;
            }
            else if (LoaiDeNghi == KHENTHUONG)
            {
                GroupName = ENUM_DANHMUC.DM_HINHTHUC_KHENTHUONG;
            }
            else if (LoaiDeNghi == THIDUA)
            {
                GroupName = ENUM_DANHMUC.DM_DANHHIEU_THIDUA;
            }
            if (GroupName != "")
            {
                DM_DATAITEM_BL bl = new DM_DATAITEM_BL();
                DataTable tbl = bl.DM_DATAITEM_GETBYGROUPNAME(GroupName);
                if (tbl.Rows.Count > 0)
                {
                    DropHinhThuc.DataSource = tbl;
                    DropHinhThuc.DataTextField = "TEN";
                    DropHinhThuc.DataValueField = "ID";
                    DropHinhThuc.DataBind();
                }
            }
            DropHinhThuc.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadData()
        {
            Lblthongbao.Text = "";
            decimal ToaAnID = Convert.ToDecimal(DropDonVi.SelectedValue),
                    Nam = TxtNam.Text.Trim() == "" ? 0 : Convert.ToDecimal(TxtNam.Text),
                    LoaiDeNghi = Convert.ToDecimal(DropLoaiDeNghi.SelectedValue),
                    HinhThucID = Convert.ToDecimal(DropHinhThuc.SelectedValue);
            int pageSize = Convert.ToInt32(HddPageSize.Value),
                pageIndex = Convert.ToInt32(hddPageIndex.Value);
            string DanhSach = TxtTenDanSach.Text.Trim();
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("IN_TOAANID",ToaAnID),
                new OracleParameter("IN_NAM",Nam),
                new OracleParameter("IN_DANHSACH",DanhSach),
                new OracleParameter("IN_LOAIDENGHI",LoaiDeNghi),
                new OracleParameter("IN_HINHTHUCID",HinhThucID),
                new OracleParameter("IN_PAGESIZE",pageSize),
                new OracleParameter("IN_PAGEINDEX",pageIndex),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TDKT_KET_QUA_BINH_XET_GETDATA", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["Total"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,0.###", cul)
                                                        + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                PanData.Visible = true;
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "";
                PanData.Visible = false;
            }
            dgList.PageSize = pageSize;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        #endregion
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal DanhSachID = Convert.ToDecimal(e.CommandArgument);
                switch (e.CommandName)
                {
                    case "KQBinhXet":
                        string link = Cls_Comon.GetRootURL() + "/TDKT/Ketquabinhxet/Edit.aspx?ds=" + DanhSachID + "&pag=" + hddPageIndex.Value;
                        Response.Redirect(link);
                        break;
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton LbtKetQuaBinhXet = (LinkButton)e.Item.FindControl("LbtKetQuaBinhXet");
            }
        }

        protected void DropLoaiDeNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHinhThuc();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void DownLoadFile(decimal ID)
        {
            TDKT_DANH_SACH Obj = dt.TDKT_DANH_SACH.Where(x => x.ID == ID).FirstOrDefault();
            if (Obj.FILE_TEN != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: Obj.FILE_NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + Obj.FILE_TEN + "&Extension=" + Obj.FILE_LOAI + "';", true);
            }
        }
        protected void BtnThemMoi_Click(object sender, EventArgs e)
        {
            string link = Cls_Comon.GetRootURL() + "/TDKT/Ketquabinhxet/Edit.aspx";
            Response.Redirect(link);
        }
        protected void BtnTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
                //if (!PanData.Visible)
                //{
                //    Lblthongbao.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm!";
                //}
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
    }
}