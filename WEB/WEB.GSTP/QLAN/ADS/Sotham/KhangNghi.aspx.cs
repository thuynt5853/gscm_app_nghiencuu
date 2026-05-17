using BL.GSTP;
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

namespace WEB.GSTP.QLAN.ADS.Sotham
{
    public partial class KhangNghi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");
                LoadCombobox();
                LoadGrid();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            }
        }

        private void LoadCombobox()
        {
            LoadQD_BA();         
        }
        private void LoadQD_BA()
        {
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            if (rdbLoaiKN.SelectedValue == "0")
            {
                ddlSOQDBA.DataSource = dt.ADS_SOTHAM_BANAN.Where(x => x.DONID == DONID).OrderByDescending(y => y.NGAYTUYENAN).ToList();
                ddlSOQDBA.DataTextField = "SOBANAN";
                ddlSOQDBA.DataValueField = "ID";
                ddlSOQDBA.DataBind();
            }
            else
            {
                ddlSOQDBA.DataSource = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.DONID == DONID).OrderByDescending(y => y.NGAYQD).ToList();
                ddlSOQDBA.DataTextField = "SOQD";
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
                ADS_SOTHAM_BANAN oT = dt.ADS_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.NGAYTUYENAN != null) txtNgayQDBA.Text = ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA.SelectedValue);
                ADS_SOTHAM_QUYETDINH oT = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.NGAYQD != null) txtNgayQDBA.Text = ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
            }
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
            DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
            txtToaAnQD.Text = oToaAn.TEN;
        }
        private void ResetControls()
        {

            txtSokhangnghi.Text = "";
            txtNgaykhangnghi.Text = "";
            txtNgayQDBA.Text = "";
            txtToaAnQD.Text = "";
            txtNoidung.Text = "";
          
            hddFilePath.Value = "";
            hddid.Value = "0";
            hddFilePath.Value = "";
          
            lbtDownload.Visible = false;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }

        private bool CheckValid()
        {
            if (txtSokhangnghi.Text=="")
            {
                lbthongbao.Text = "Chưa nhập số kháng nghị !";
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaykhangnghi.Text) == false)
            {
                lbthongbao.Text = "Ngày kháng cáo chưa nhập hoặc không hợp lệ !";
                return false;
            }
           
            if (ddlSOQDBA.Items.Count == 0)
            {
                lbthongbao.Text = "Chưa chọn số QĐ/BA";
                return false;
            }
            return true;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                ADS_SOTHAM_KHANGNGHI oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new ADS_SOTHAM_KHANGNGHI();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.SOKN = txtSokhangnghi.Text;
                oND.NGAYKN = (String.IsNullOrEmpty(txtNgaykhangnghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangnghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DONVIKN = Convert.ToDecimal(rdbDonVi.SelectedValue);
                oND.CAPKN = Convert.ToDecimal(rdbCapkhangnghi.SelectedValue);
                oND.LOAIKN = Convert.ToDecimal(rdbLoaiKN.SelectedValue);
                oND.BANANID = Convert.ToDecimal(ddlSOQDBA.SelectedValue);
                oND.TOAANRAQDID = oDon.TOAANID;
               
                oND.NGAYBANAN = (String.IsNullOrEmpty(txtNgayQDBA.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
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
                    dt.ADS_SOTHAM_KHANGNGHI.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        public void LoadGrid()
        {
            ADS_SOTHAM_BL oBL = new ADS_SOTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.ADS_SOTHAM_KHANGNGHI_GETLIST(ID);
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
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }

        public void xoa(decimal id)
        {

            ADS_SOTHAM_KHANGNGHI oND = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.ID == id).FirstOrDefault();

            dt.ADS_SOTHAM_KHANGNGHI.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }

        public void loadedit(decimal ID)
        {
            ADS_SOTHAM_KHANGNGHI oND = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();

            txtSokhangnghi.Text = oND.SOKN;
            if (oND.NGAYKN != null) txtNgaykhangnghi.Text = ((DateTime)oND.NGAYKN).ToString("dd/MM/yyyy", cul);
          rdbDonVi.SelectedValue = oND.DONVIKN.ToString();
            rdbCapkhangnghi.SelectedValue= oND.CAPKN.ToString();
           rdbLoaiKN.SelectedValue = oND.LOAIKN.ToString();
            ddlSOQDBA.SelectedValue= oND.BANANID.ToString();
            if (oND.NGAYBANAN != null) txtNgayQDBA.Text = ((DateTime)oND.NGAYBANAN).ToString("dd/MM/yyyy", cul);
          txtNoidung.Text = oND.NOIDUNGKN;
            DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
            txtToaAnQD.Text = oToaAn.TEN;  
            if (oND.TENFILE != "")
            {
                lbtDownload.Visible = true;
            }
            else
                lbtDownload.Visible = false;
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
            ADS_SOTHAM_KHANGNGHI oND = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
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