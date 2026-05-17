using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.TDKT.DangKyThiDuaKhenThuong
{
    public partial class Danhsachdoituong : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private const int TAPTHE = 1, CANHAN = 2, THIDUA = 1, KHENTHUONG = 2, KYLUAT = 3;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                if (!IsPostBack)
                {
                    LoadDropLoaiDeNghi();
                    LoadDropLoaiHinhKT();
                    LoadDropHinhThuc();
                    hddPageIndex.Value = "1";
                    LoadData();
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDropLoaiDeNghi()
        {
            int LoaiDeNghi = 0;
            int.TryParse(Request["ldn"], out LoaiDeNghi);
            if (LoaiDeNghi == KYLUAT)
            {
                DropLoaiDeNghi.Items.Add(new ListItem("Kỷ luật", "3"));
            }
            else if (LoaiDeNghi == KHENTHUONG)
            {
                DropLoaiDeNghi.Items.Add(new ListItem("Khen thưởng", "2"));
                PnlLoaiHinhKT.Visible = true;
            }
            else if (LoaiDeNghi == THIDUA)
            {
                DropLoaiDeNghi.Items.Add(new ListItem("Thi đua", "1"));
            }
            else
            {
                DropLoaiDeNghi.Items.Add(new ListItem("--- Chọn ---", "0"));
            }
            DropLoaiDeNghi_SelectedIndexChanged(new object(), new EventArgs());
        }
        private void LoadDropLoaiHinhKT()
        {
            string GroupName = ENUM_DANHMUC.DM_LOAIHINH_KHENTHUONG;
            DM_DATAITEM_BL bl = new DM_DATAITEM_BL();
            DataTable tbl = bl.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (tbl.Rows.Count > 0)
            {
                DropLoaiHinhKT.DataSource = tbl;
                DropLoaiHinhKT.DataTextField = "TEN";
                DropLoaiHinhKT.DataValueField = "ID";
                DropLoaiHinhKT.DataBind();
            }
            DropLoaiHinhKT.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadDropHinhThuc()
        {
            DropHinhThuc.Items.Clear();
            int LoaiDeNghi = Convert.ToInt32(DropLoaiDeNghi.SelectedValue);
            string GroupName = "";
            if (LoaiDeNghi == KHENTHUONG)
            {
                GroupName = ENUM_DANHMUC.DM_HINHTHUC_KHENTHUONG;
            }
            else if (LoaiDeNghi == KYLUAT)
            {
                GroupName = ENUM_DANHMUC.DM_HINHTHUC_KYLUAT;
            }
            else if (LoaiDeNghi == THIDUA)
            {
                GroupName = ENUM_DANHMUC.DM_DANHHIEU_THIDUA;
            }
            DM_DATAITEM_BL bl = new DM_DATAITEM_BL();
            DataTable tbl = bl.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (tbl.Rows.Count > 0)
            {
                DropHinhThuc.DataSource = tbl;
                DropHinhThuc.DataTextField = "TEN";
                DropHinhThuc.DataValueField = "ID";
                DropHinhThuc.DataBind();
            }
            DropHinhThuc.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        protected void DropLoaiDeNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                PnlLoaiHinhKT.Visible = false;
                int LoaiDeNghi = Convert.ToInt32(DropLoaiDeNghi.SelectedValue);
                if (LoaiDeNghi == KYLUAT)
                {
                    LtrTitleHinhThuc.Text = "Hình thức kỷ luật";
                }
                else if (LoaiDeNghi == KHENTHUONG)
                {
                    LtrTitleHinhThuc.Text = "Hình thức khen thưởng";
                    PnlLoaiHinhKT.Visible = true;
                }
                else if (LoaiDeNghi == THIDUA)
                {
                    LtrTitleHinhThuc.Text = "Danh hiệu thi đua";
                }
                else
                {
                    LtrTitleHinhThuc.Text = "Hình thức";
                }
                LoadDropHinhThuc();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadData()
        {
            Lblthongbao.Text = "";
            decimal DanhsachID = Request["ds"] + "" == "" ? 0 : Convert.ToDecimal(Request["ds"] + ""),
                    DonVi = Request["dv"] + "" == "" ? 0 : Convert.ToDecimal(Request["dv"]),
                    HinhThuc = Convert.ToDecimal(DropHinhThuc.SelectedValue);
            int LoaiDeNghi = Convert.ToInt32(DropLoaiDeNghi.SelectedValue),
                LoaiDoiTuong = Convert.ToInt32(DropLoaiDoiTuong.SelectedValue);
            int pageSize = Convert.ToInt32(HddPageSize.Value),
                pageIndex = Convert.ToInt32(hddPageIndex.Value);
            string TenDoiTuong = TxtTenDoiTuong.Text.Trim();
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("IN_DANHSACHID",DanhsachID),
                new OracleParameter("IN_DONVIID",DonVi),
                new OracleParameter("IN_LOAIDOITUONG",LoaiDoiTuong),
                new OracleParameter("IN_TEN_DOITUONG",TenDoiTuong),
                new OracleParameter("IN_LOAIDENGHI",LoaiDeNghi),
                new OracleParameter("IN_HINHTHUC",HinhThuc),
                new OracleParameter("IN_PAGESIZE",pageSize),
                new OracleParameter("IN_PAGEINDEX",pageIndex),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TDKT_DANH_SACH_DOI_TUONG_GETDATA", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                CultureInfo cul = new CultureInfo("vi-VN");
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
                decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    //case "Download":
                    //    DownLoadFile(ID);
                    //    break;
                    case "Sua":
                        string link = Cls_Comon.GetRootURL() + "/TDKT/DangKyThiDuaKhenThuong/Editdoituong.aspx?dt=" + ID.ToString() + "&pag=" + hddPageIndex.Value + "&ds=" + Request["ds"].ToString() + "&ldn=" + Request["ldn"];
                        Response.Redirect(link);
                        break;
                    case "Xoa":
                        Xoa(ID);
                        break;
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnThemMoi_Click(object sender, EventArgs e)
        {
            string link = Cls_Comon.GetRootURL() + "/TDKT/DangKyThiDuaKhenThuong/Editdoituong.aspx?pag=" + hddPageIndex.Value + "&ds=" + Request["ds"].ToString();
            Response.Redirect(link);
        }
        protected void BtnQuayLai_Click(object sender, EventArgs e)
        {
            string link = Cls_Comon.GetRootURL() + "/TDKT/DangKyThiDuaKhenThuong/Danhsach.aspx?pag=" + Request["pag"];
            Response.Redirect(link);
        }
        protected void BtnTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
                if (!PanData.Visible)
                {
                    Lblthongbao.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm!";
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        #region Tệp đính kèm
        //protected void LbtDownload_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        decimal ID = Convert.ToDecimal(hddID.Value);
        //        DownLoadFile(ID);
        //    }
        //    catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        //}
        //protected void ImgXoa_Click(object sender, ImageClickEventArgs e)
        //{
        //    decimal ID = Convert.ToDecimal(hddID.Value);
        //    TDKT_DANH_SACH_DOI_TUONG Obj = dt.TDKT_DANH_SACH_DOI_TUONG.Where(x => x.ID == ID).FirstOrDefault<TDKT_DANH_SACH_DOI_TUONG>();
        //    if (Obj != null)
        //    {
        //        Obj.FILE_LOAI = "";
        //        Obj.FILE_NOIDUNG = null;
        //        Obj.FILE_TEN = "";
        //        dt.SaveChanges();
        //        LoadData();
        //        #region Tệp đính kèm
        //        //ImgXoa.Visible = false;
        //        //LbtDownload.Text = "";
        //        #endregion
        //    }
        //}
        //private void DownLoadFile(decimal ID)
        //{
        //    TDKT_DANH_SACH_DOI_TUONG Obj = dt.TDKT_DANH_SACH_DOI_TUONG.Where(x => x.ID == ID).FirstOrDefault();
        //    if (Obj.FILE_TEN != "")
        //    {
        //        var cacheKey = Guid.NewGuid().ToString("N");
        //        Context.Cache.Insert(key: cacheKey, value: Obj.FILE_NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
        //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + Obj.FILE_TEN + "&Extension=" + Obj.FILE_LOAI + "';", true);
        //    }
        //}
        //protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        //{
        //    try
        //    {
        //        if (AsyncFileUpLoad.HasFile)
        //        {
        //            string strFileName = AsyncFileUpLoad.FileName;
        //            string path = Server.MapPath("~/TempUpload/") + strFileName;
        //            AsyncFileUpLoad.SaveAs(path);
        //            path = path.Replace("\\", "/");
        //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
        //        }
        //    }
        //    catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        //}

        #endregion
        protected void BtnLamMoi_Click(object sender, EventArgs e)
        {
            ResetData();
        }
        private void ResetData()
        {
            Lblthongbao.Text = "";
            DropLoaiDoiTuong.SelectedIndex = 0;
            DropLoaiDeNghi.SelectedIndex = 0;
            DropLoaiDeNghi_SelectedIndexChanged(new object(), new EventArgs());
            DropLoaiHinhKT.SelectedIndex = 0;
            DropHinhThuc.SelectedIndex = 0;
            TxtTenDoiTuong.Text = "";
        }
        private void Xoa(decimal ID)
        {
            TDKT_DANH_SACH_DOI_TUONG Obj = dt.TDKT_DANH_SACH_DOI_TUONG.Where(x => x.ID == ID).FirstOrDefault<TDKT_DANH_SACH_DOI_TUONG>();
            if (Obj != null)
            {
                dt.TDKT_DANH_SACH_DOI_TUONG.Remove(Obj);
                dt.SaveChanges();
                hddPageIndex.Value = "1";
                LoadData();
                Lblthongbao.Text = "Xóa thành công.";
            }
        }
    }
}