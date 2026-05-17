using BL.GSTP;
using BL.GSTP.AHS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class KhangNghi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public string NgayHoSo;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");
                LoadCombobox();
                LoadCheckListYeuCauKhangNghi();
                LoadGrid();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            }
        }
        private void LoadCheckListYeuCauKhangNghi()
        {
            DM_DATAITEM_BL dtItemBL = new DM_DATAITEM_BL();
            DataTable tbl = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKNHINHSU);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                chkYeuCauKN.DataSource = tbl;
                chkYeuCauKN.DataTextField = "TEN";
                chkYeuCauKN.DataValueField = "ID";
                chkYeuCauKN.DataBind();
            }
        }
        private void LoadCombobox()
        {
            string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ADS_DON_DUONGSU_BL oDSBL = new ADS_DON_DUONGSU_BL();
            LoadQD_BA();
        }
        private void LoadQD_BA()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            if (rdbLoaiKN.SelectedValue == "0")
            {
                ddlSOQDBA.DataSource = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).OrderByDescending(y => y.NGAYBANAN).ToList();
                ddlSOQDBA.DataTextField = "SOBANAN";
                ddlSOQDBA.DataValueField = "ID";
                ddlSOQDBA.DataBind();
            }
            else
            {
                ddlSOQDBA.DataSource = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID).OrderByDescending(y => y.NGAYQD).ToList();
                ddlSOQDBA.DataTextField = "SOQUYETDINH";
                ddlSOQDBA.DataValueField = "ID";
                ddlSOQDBA.DataBind();
            }
            LoadQD_BA_Info();
        }
        private void LoadQD_BA_Info()
        {
            if (ddlSOQDBA.Items.Count == 0) return;
            if (rdbLoaiKN.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA.SelectedValue);
                AHS_SOTHAM_BANAN oT = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA.Text = string.IsNullOrEmpty(oT.NGAYBANAN + "") ? "" : ((DateTime)oT.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                else  txtNgayQDBA.Text = ""; 
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA.SelectedValue);
                AHS_SOTHAM_QUYETDINH_VUAN oT = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    txtNgayQDBA.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                else txtNgayQDBA.Text = "";
            }
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVuAn != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oVuAn.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                     txtToaAnQD.Text = oToaAn.TEN; 
                else  txtToaAnQD.Text = ""; 
            }
            else
                txtToaAnQD.Text = "";
        }
        private void ResetControls()
        {
            lbthongbao.Text = txtSokhangnghi.Text = txtNgaykhangnghi.Text = "";
            rdbCapkhangnghi.SelectedValue = "1";
            rdbLoaiKN.SelectedValue = "0";
            LoadQD_BA_Info();
            txtNoidung.Text = "";
            if (chkYeuCauKN.Items.Count > 0)
            {
                foreach (ListItem item in chkYeuCauKN.Items)
                    item.Selected = false;
            }
            hddid.Value = "0";
            hddFilePath.Value = "";
            lbtDownload.Visible = false;
        }
        private bool CheckValid()
        {
            if (txtSokhangnghi.Text == "")
            {
                lbthongbao.Text = "Chưa nhập số kháng nghị !";
                txtSokhangnghi.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaykhangnghi.Text) == false)
            {
                lbthongbao.Text = "Ngày kháng nghị chưa nhập hoặc không hợp lệ !";
                txtNgaykhangnghi.Focus();
                return false;
            }
            if (ddlSOQDBA.Items.Count == 0)
            {
                lbthongbao.Text = "Chưa chọn số QĐ/BA";
                return false;
            }
            if (txtNoidung.Text.Trim().Length > 1000)
            {
                lbthongbao.Text = "Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!";
                txtNoidung.Focus();
                return false;
            }
            bool isSelected = false;
            foreach (ListItem item in chkYeuCauKN.Items)
            {
                if (item.Selected)
                {
                    isSelected = true;
                    break;
                }
            }
            if (!isSelected)
            {
                lbthongbao.Text = "Bạn chưa chọn yêu cầu kháng nghị!";
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                AHS_SOTHAM_KHANGNGHI oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new AHS_SOTHAM_KHANGNGHI();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.VUANID = VuAnID;
                oND.SOKN = txtSokhangnghi.Text;
                oND.NGAYKN = (String.IsNullOrEmpty(txtNgaykhangnghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangnghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DONVIKN = Convert.ToDecimal(rdbDonVi.SelectedValue);
                oND.CAPKN = Convert.ToDecimal(rdbCapkhangnghi.SelectedValue);
                oND.LOAIKN = Convert.ToDecimal(rdbLoaiKN.SelectedValue);
                oND.BANANID = Convert.ToDecimal(ddlSOQDBA.SelectedValue);
                oND.NGAYBANAN = (String.IsNullOrEmpty(txtNgayQDBA.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.TOAANRAQDID = oVuAn.TOAANID;
                oND.NOIDUNGKN = txtNoidung.Text;

                if (hddFilePath.Value != "")
                {
                    try
                    {
                        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oND.NOIDUNGFILE = buff;
                            oND.TENFILE =Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            oND.KIEUFILE = oF.Extension;

                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbthongbao.Text = ex.Message; }
                }
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    // insert toa_gq_id
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_KHANGNGHI.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();
                // Update yêu cầu kháng nghị
                UpdateYeuCauKhangNghi(oND.ID);
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        private void UpdateYeuCauKhangNghi(Decimal KhangNghiID)
        {
            AHS_SOTHAM_KHANGNGHI_YEUCAU obj = null;
            // lấy ra tất cả các yêu cầu cũ
            string StrKhangCaoYC = "|";
            if (KhangNghiID > 0)
            {
                List<AHS_SOTHAM_KHANGNGHI_YEUCAU> lst = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == KhangNghiID).ToList<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (AHS_SOTHAM_KHANGNGHI_YEUCAU item in lst)
                        StrKhangCaoYC += item.YEUCAUID + "|";
                }
            }
            // Phát hiện yêu cầu mới thì thêm, trùng với yêu cầu cũ thì loại khỏi danh sách
            Boolean IsNew = false;
            decimal yeuCauID = 0;
            foreach (ListItem item in chkYeuCauKN.Items)
            {
                IsNew = false;
                if (item.Selected)
                {
                    if (StrKhangCaoYC == "|")
                        IsNew = true;
                    else
                    {
                        if (StrKhangCaoYC.Contains("|" + item.Value + "|"))
                        {
                            yeuCauID = Convert.ToDecimal(item.Value);
                            obj = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == KhangNghiID && x.YEUCAUID == yeuCauID).FirstOrDefault<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                            if (obj != null)
                            {
                                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                obj.NGAYSUA = DateTime.Now;
                                dt.SaveChanges();
                            }
                            StrKhangCaoYC = StrKhangCaoYC.Replace("|" + item.Value + "|", "|");
                            IsNew = false;
                        }
                        else
                            IsNew = true;
                    }
                    if (IsNew)
                    {
                        obj = new AHS_SOTHAM_KHANGNGHI_YEUCAU();
                        obj.KHANGNGHIID = KhangNghiID;
                        obj.YEUCAUID = Convert.ToDecimal(item.Value);
                        obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        obj.NGAYTAO = DateTime.Now;
                        dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Add(obj);
                        dt.SaveChanges();
                    }
                }
            }
            // yêu cầu còn lại cần phải xóa
            if (StrKhangCaoYC != "|")
            {
                String[] arr = StrKhangCaoYC.Split('|');
                foreach (String item in arr)
                {
                    if (item.Length > 0)
                    {
                        yeuCauID = Convert.ToDecimal(item);
                        obj = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.ID == yeuCauID).FirstOrDefault();
                        if (obj != null)
                        {
                            dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Remove(obj);
                            dt.SaveChanges();
                        }
                    }
                }
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }
        public void xoa(decimal id)
        {
            AHS_SOTHAM_KHANGNGHI oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            { 
                //Luu thong tin Kháng nghị Sơ thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var json = new JavaScriptSerializer().Serialize(oND);
                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.VUANID), 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Kháng nghị Sơ thẩm án Hình sự", "Xóa", json) == false)
                {
                    lbthongbao.Text = "Xóa không thành công!";
                    return;
                }//Ket thuc
                 //Xoa Kháng nghị Sơ thẩm
                dt.AHS_SOTHAM_KHANGNGHI.Remove(oND);
                List<AHS_SOTHAM_KHANGNGHI_YEUCAU> listKNyc = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == id).ToList<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
                if (listKNyc != null && listKNyc.Count > 0)
                {
                    dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.RemoveRange(listKNyc);
                }
                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
            }
        }
        public void loadedit(decimal ID)
        {
            AHS_SOTHAM_KHANGNGHI oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                hddid.Value = oND.ID.ToString();
                rdbDonVi.SelectedValue = oND.DONVIKN.ToString();
                txtSokhangnghi.Text = oND.SOKN;
                txtNgaykhangnghi.Text = string.IsNullOrEmpty(oND.NGAYKN + "") ? "" : ((DateTime)oND.NGAYKN).ToString("dd/MM/yyyy", cul);
                rdbCapkhangnghi.SelectedValue = oND.CAPKN.ToString();
                rdbLoaiKN.SelectedValue = oND.LOAIKN.ToString();
                ddlSOQDBA.SelectedValue = oND.BANANID.ToString();
                txtNgayQDBA.Text = string.IsNullOrEmpty(oND.NGAYBANAN + "") ? "" : ((DateTime)oND.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                if (oToaAn != null)
                { txtToaAnQD.Text = oToaAn.TEN; }
                else { txtToaAnQD.Text = ""; }
                txtNoidung.Text = oND.NOIDUNGKN;
                if (oND.TENFILE != "")
                {
                    lbtDownload.Visible = true;
                }
                else
                    lbtDownload.Visible = false;
                FillYeuCauKN(ID);
            }
        }
        private void FillYeuCauKN(Decimal KhangNghiID)
        {
            List<AHS_SOTHAM_KHANGNGHI_YEUCAU> lst = dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Where(x => x.KHANGNGHIID == KhangNghiID).ToList<AHS_SOTHAM_KHANGNGHI_YEUCAU>();
            if (lst != null && lst.Count > 0)
            {
                foreach (ListItem item in chkYeuCauKN.Items)
                {
                    item.Selected = false;
                    foreach (AHS_SOTHAM_KHANGNGHI_YEUCAU obj in lst)
                    {
                        if (Convert.ToDecimal(item.Value) == obj.YEUCAUID)
                        { item.Selected = true; }
                    }
                }
            }
        }
        public void LoadGrid()
        {
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_SOTHAM_KHANGNGHI_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(ND_id);
                    ResetControls();
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
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddid.Value);
            AHS_SOTHAM_KHANGNGHI oND = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        protected void rdbLoaiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BA();
        }
        protected void ddlSOQDBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BA_Info();
        }
    }
}