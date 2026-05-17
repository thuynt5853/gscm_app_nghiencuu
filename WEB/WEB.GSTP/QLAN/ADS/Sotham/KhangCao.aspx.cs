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
    public partial class KhangCao : System.Web.UI.Page
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
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal DONID = Convert.ToDecimal(current_id);

            ADS_DON_DUONGSU_BL oDSBL = new ADS_DON_DUONGSU_BL();
            //Load đương sự
            ddlNguoikhangcao.DataSource = oDSBL.ADS_SOTHAM_DUONGSU_GETBY(DONID,1);
            ddlNguoikhangcao.DataTextField = "ARRDUONGSU";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.DataBind();
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--Chọn--", "0"));
            LoadQD_BA();

            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlGQ_Thamphan.DataSource = oCBDT;
            ddlGQ_Thamphan.DataTextField = "MA_TEN";
            ddlGQ_Thamphan.DataValueField = "ID";
            ddlGQ_Thamphan.DataBind();
            ddlGQ_Thamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

        }

        private void LoadQD_BA()
        {
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            if (rdbLoaiKC.SelectedValue=="0")
            {
                ddlSOQDBA.DataSource = dt.ADS_SOTHAM_BANAN.Where(x => x.DONID == DONID).OrderByDescending(y=>y.NGAYTUYENAN).ToList();
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
            if (rdbLoaiKC.SelectedValue == "0")
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

            txtNgayvietdon.Text = "";
            txtNgaykhangcao.Text = "";
            txtNgayQDBA.Text = "";
            txtToaAnQD.Text = "";
            txtNoidung.Text = "";
            txtSobienlai.Text = "";
            txtAnphi.Text = "";
            txtNgaynopanphi.Text = "";
            hddFilePath.Value = "";
            hddid.Value = "0";
            hddFilePath.Value = "";
            txtNgaygiaiquyet.Text = "";
            //txtGQGhichu.Text = "";
            ddlGQ_Thamphan.SelectedIndex = 0;
            lbtDownload.Visible = false;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }

        private bool CheckValid()
        {
            if (Cls_Comon.IsValidDate(txtNgaykhangcao.Text) == false)
            {
                lbthongbao.Text = "Ngày kháng cáo chưa nhập hoặc không hợp lệ !";
                return false;
            }

            if (ddlNguoikhangcao.SelectedIndex==0)
            {
                lbthongbao.Text = "Chưa chọn người kháng cáo !";
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
                ADS_SOTHAM_KHANGCAO oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new ADS_SOTHAM_KHANGCAO();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.HINHTHUCNHAN = Convert.ToDecimal(rdbHinhthucnhan.SelectedValue);              
                oND.NGAYVIETDON = (String.IsNullOrEmpty(txtNgayvietdon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayvietdon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DUONGSUID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue);
                oND.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKC.SelectedValue);
                oND.SOQDBA= Convert.ToDecimal(ddlSOQDBA.SelectedValue);
                oND.TOAANRAQDID = oDon.TOAANID;
                oND.ISQUAHAN = Convert.ToDecimal(rdbQuahan.SelectedValue);
                oND.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NOIDUNGKHANGCAO = txtNoidung.Text;
                oND.ISMIENANPHI= Convert.ToDecimal(rdbMienAnphi.SelectedValue);
                oND.ANPHI = txtAnphi.Text == "" ? 0 : Convert.ToDecimal(txtAnphi.Text.Replace(".", ""));
                oND.SOBIENLAI = txtSobienlai.Text;
                oND.NGAYNOPANPHI = (String.IsNullOrEmpty(txtNgaynopanphi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaynopanphi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.GQ_NGAY = (String.IsNullOrEmpty(txtNgaygiaiquyet.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaygiaiquyet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.GQ_THAMPHANID = Convert.ToDecimal(ddlGQ_Thamphan.SelectedValue);
                oND.GQ_ISCHAPNHAN = Convert.ToDecimal(rdbChapnhan.SelectedValue);
                //oND.GQ_GHICHU = txtGQGhichu.Text;

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
                    dt.ADS_SOTHAM_KHANGCAO.Add(oND);
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
            DataTable oDT = oBL.ADS_SOTHAM_KHANGCAO_GETLIST(ID);
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

            ADS_SOTHAM_KHANGCAO oND = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.ID == id).FirstOrDefault();

            dt.ADS_SOTHAM_KHANGCAO.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }

        public void loadedit(decimal ID)
        {
            ADS_SOTHAM_KHANGCAO oND = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();

           rdbHinhthucnhan.SelectedValue = oND.HINHTHUCNHAN.ToString();
            if (oND.NGAYVIETDON != null) txtNgayvietdon.Text = ((DateTime)oND.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
            if (oND.NGAYKHANGCAO != null) txtNgaykhangcao.Text = ((DateTime)oND.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);

            ddlNguoikhangcao.SelectedValue= oND.DUONGSUID.ToString();
            rdbLoaiKC.SelectedValue= oND.LOAIKHANGCAO.ToString();
            ddlSOQDBA.SelectedValue= oND.SOQDBA.ToString();
           
            DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
            txtToaAnQD.Text = oToaAn.TEN;
            rdbQuahan.SelectedValue = oND.ISQUAHAN.ToString();
            if (oND.NGAYQDBA != null) txtNgayQDBA.Text = ((DateTime)oND.NGAYQDBA).ToString("dd/MM/yyyy", cul);
            txtNoidung.Text = oND.NOIDUNGKHANGCAO;
            rdbMienAnphi.SelectedValue= oND.ISMIENANPHI.ToString();
            txtAnphi.Text = oND.ANPHI == null ? "": oND.ANPHI.ToString();
            txtSobienlai.Text = oND.SOBIENLAI;
           if (oND.NGAYNOPANPHI != null) txtNgaynopanphi.Text = ((DateTime)oND.NGAYNOPANPHI).ToString("dd/MM/yyyy", cul);

            if (oND.GQ_NGAY != null) txtNgaygiaiquyet.Text = ((DateTime)oND.GQ_NGAY).ToString("dd/MM/yyyy", cul);

            oND.GQ_NGAY = (String.IsNullOrEmpty(txtNgaygiaiquyet.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaygiaiquyet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
          if(oND.GQ_THAMPHANID !=null) ddlGQ_Thamphan.SelectedValue = oND.GQ_THAMPHANID.ToString();
          if(oND.GQ_ISCHAPNHAN !=null)  rdbChapnhan.SelectedValue= oND.GQ_ISCHAPNHAN.ToString();
             //txtGQGhichu.Text= oND.GQ_GHICHU+"";

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
            ADS_SOTHAM_KHANGCAO oND = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
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