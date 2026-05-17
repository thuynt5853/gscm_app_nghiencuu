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
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.TDKT.DangKyThiDuaKhenThuong
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                if (!IsPostBack)
                {
                    LoadDropToaAn();
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
        private void LoadDropToaAn()
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
                DropToaAn.DataSource = oBL.DM_TOAAN_GETBY(DonViLoginID);
                DropToaAn.DataTextField = "arrTEN";
                DropToaAn.DataValueField = "ID";
                DropToaAn.DataBind();

                DropToaAn.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
            {
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
                if (oT != null)
                    DropToaAn.Items.Add(new ListItem(oT.MA_TEN, oT.ID.ToString()));
                else
                    DropToaAn.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            try
            {
                DropToaAn.SelectedValue = Request["dv"] + "";
            }
            catch { }
        }
        private void LoadData()
        {
            Lblthongbao.Text = "";
            string TenDanSach = TxtTenDanSach.Text.Trim(),
                   TenNguoiLap = TxtNguoiLap.Text.Trim(),
                   TenNguoiDuyet = TxtNguoiDuyet.Text.Trim(),
                   ChucVu = TxtChucVu.Text.Trim();
            decimal ToaAnID = Convert.ToDecimal(DropToaAn.SelectedValue),
                    LoaiDeNghi = Convert.ToDecimal(DropLoaiDeNghi.SelectedValue),
                    Nam = TxtNam.Text.Trim() + "" == "" ? 0 : Convert.ToDecimal(TxtNam.Text.Trim());
            int pageSize = Convert.ToInt32(HddPageSize.Value),
                pageIndex = Convert.ToInt32(hddPageIndex.Value);
            DateTime? NgayLap = TxtNgayLap.Text.Trim() + "" == "" ? (DateTime?)null : DateTime.Parse(TxtNgayLap.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("IN_TOAANID",ToaAnID),
                new OracleParameter("IN_LOAIDENGHI",LoaiDeNghi),
                new OracleParameter("IN_TENDANHSACH",TenDanSach),
                new OracleParameter("IN_NAM",Nam),
                new OracleParameter("IN_NGUOILAP",TenNguoiLap),
                new OracleParameter("IN_NGAYLAP",NgayLap),
                new OracleParameter("IN_NGUOIDUYET",TenNguoiDuyet),
                new OracleParameter("IN_CHUCVU",ChucVu),
                new OracleParameter("IN_PAGESIZE",pageSize),
                new OracleParameter("IN_PAGEINDEX",pageIndex),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TDKT_DANH_SACH_GETDATA", parameters);
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
                string[] arr = e.CommandArgument.ToString().Split(';');
                decimal ID = Convert.ToDecimal(arr[0]), ToaAnID = Convert.ToDecimal(arr[1]), LoaiDeNghi = Convert.ToDecimal(arr[2]);
                string link = "";
                switch (e.CommandName)
                {
                    case "DanhSach":
                        link = Cls_Comon.GetRootURL() + "/TDKT/DangKyThiDuaKhenThuong/Danhsachdoituong.aspx?ds=" + ID + "&dv=" + ToaAnID + "&pag=" + hddPageIndex.Value + "&ldn=" + LoaiDeNghi;
                        Response.Redirect(link);
                        break;
                    //case "Download":
                    //    DownLoadFile(ID);
                    //    break;
                    case "Sua":
                        link = Cls_Comon.GetRootURL() + "/TDKT/DangKyThiDuaKhenThuong/Edit.aspx?ds=" + ID + "&dv=" + ToaAnID + "&pag=" + hddPageIndex.Value + "&ldn=" + LoaiDeNghi;
                        Response.Redirect(link);
                        break;
                    case "Xoa":
                        if (CheckExistDoiTuong(ID))
                        {
                            Lblthongbao.Text = "Danh sách đã có đối tượng đề nghị. Không được xóa.";
                            return;
                        }
                        Xoa(ID);
                        break;
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
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
        protected void BtnThemMoi_Click(object sender, EventArgs e)
        {
            string link = Cls_Comon.GetRootURL() + "/TDKT/DangKyThiDuaKhenThuong/Edit.aspx?dv=" + DropToaAn.SelectedValue + "&pag=" + hddPageIndex.Value + "&ldn=" + DropLoaiDeNghi.SelectedValue;
            Response.Redirect(link);
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
        //protected void ImgXoa_Click(object sender, ImageClickEventArgs e)
        //{
        //    decimal ID = Convert.ToDecimal(hddID.Value);
        //    TDKT_DANH_SACH Obj = dt.TDKT_DANH_SACH.Where(x => x.ID == ID).FirstOrDefault<TDKT_DANH_SACH>();
        //    if (Obj != null)
        //    {
        //        Obj.FILE_LOAI = "";
        //        Obj.FILE_NOIDUNG = null;
        //        Obj.FILE_TEN = "";
        //        dt.SaveChanges();
        //        LoadData();
        //        #region Tệp đính kèm
        //        ImgXoa.Visible = false;
        //        LbtDownload.Text = "";
        //        #endregion
        //    }
        //}
        //private void DownLoadFile(decimal ID)
        //{
        //    TDKT_DANH_SACH Obj = dt.TDKT_DANH_SACH.Where(x => x.ID == ID).FirstOrDefault();
        //    if (Obj.FILE_TEN != "")
        //    {
        //        var cacheKey = Guid.NewGuid().ToString("N");
        //        Context.Cache.Insert(key: cacheKey, value: Obj.FILE_NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
        //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + Obj.FILE_TEN + "&Extension=" + Obj.FILE_LOAI + "';", true);
        //    }
        //}
        #endregion
        private void Xoa(decimal ID)
        {
            TDKT_DANH_SACH Obj = dt.TDKT_DANH_SACH.Where(x => x.ID == ID).FirstOrDefault<TDKT_DANH_SACH>();
            if (Obj != null)
            {
                dt.TDKT_DANH_SACH.Remove(Obj);
                dt.SaveChanges();
                hddPageIndex.Value = "1";
                LoadData();
                Lblthongbao.Text = "Xóa thành công.";
            }
        }
        private void ResetData()
        {
            Lblthongbao.Text = "";
            TxtTenDanSach.Text = "";
            DropLoaiDeNghi.SelectedIndex = 0;
            TxtNam.Text = "";
            //TxtSoQD.Text = "";
            //TxtNgayQD.Text = "";
            TxtNguoiLap.Text = "";
            TxtNgayLap.Text = "";
            TxtNguoiDuyet.Text = "";
            TxtChucVu.Text = "";
            #region Tệp đính kèm
            //LbtDownload.Text = "";
            //ImgXoa.Visible = false;
            #endregion
        }
        protected void BtnLamMoi_Click(object sender, EventArgs e)
        {
            ResetData();
        }
        private bool CheckExistDoiTuong(decimal DanhSachID)
        {
            List<TDKT_DANH_SACH_DOI_TUONG> lst = dt.TDKT_DANH_SACH_DOI_TUONG.Where(x => x.DANH_SACH_ID == DanhSachID).ToList();
            if (lst.Count > 0)
            {
                return true;
            }
            return false;
        }
    }
}