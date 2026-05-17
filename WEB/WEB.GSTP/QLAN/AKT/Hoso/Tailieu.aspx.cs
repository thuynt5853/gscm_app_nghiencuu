using BL.GSTP;
using BL.GSTP.AKT;
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

namespace WEB.GSTP.QLAN.AKT.Hoso
{
    public partial class Tailieu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx");
                    hddDonID.Value = current_id;
                    LoadDropNguoiBanGiao();
                    LoadDropNguoiNhan();
                    txtNgayBanGiao.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    decimal ID = Convert.ToDecimal(current_id);
                    
                    CheckQuyen(ID);
                    AKT_DON_XULY oDXuly = dt.AKT_DON_XULY.Where(x => x.DONID == ID && x.LOAIGIAIQUYET == 1).FirstOrDefault();
                    if (oDXuly != null)
                    {
                        lbthongbao.Text = "Đơn đã chuyển sang tòa án khác xử lý !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                    }
                    hddPageIndex.Value = "1";
                    LoadGridNgayBanGiao();
                }
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            
            AKT_DON oT = dt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                hddNgayNhanDon.Value = oT.NGAYNHANDON + "" == "" ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy");
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AKT_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }


            //Nếu mà là án đã kết thúc ẩn nút lưu 
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc == true)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
            }
        }
        private void LoadDropNguoiBanGiao()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            ddlNguoiBanGiao.Items.Clear();
            if (rdbTuCachToTung.SelectedValue == "0") // Đương sự
            {
                List<AKT_DON_DUONGSU> lst = dt.AKT_DON_DUONGSU.Where(x => x.DONID == DonID).ToList();
                if (lst != null && lst.Count > 0)
                {
                    ddlNguoiBanGiao.DataSource = lst;
                    ddlNguoiBanGiao.DataTextField = "TENDUONGSU";
                    ddlNguoiBanGiao.DataValueField = "ID";
                    ddlNguoiBanGiao.DataBind();
                }
            }
            else if (rdbTuCachToTung.SelectedValue == "1") // Người tham gia tố tụng
            {
                List<AKT_DON_THAMGIATOTUNG> lst = dt.AKT_DON_THAMGIATOTUNG.Where(x => x.DONID == DonID).ToList();
                if (lst != null && lst.Count > 0)
                {
                    ddlNguoiBanGiao.DataSource = lst;
                    ddlNguoiBanGiao.DataTextField = "HOTEN";
                    ddlNguoiBanGiao.DataValueField = "ID";
                    ddlNguoiBanGiao.DataBind();
                }
            }
            ddlNguoiBanGiao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadDropNguoiNhan()
        {
            ddlNguoiNhan.Items.Clear();

            DM_CANBO_BL dmCBBL = new DM_CANBO_BL();
            DataTable tbl = dmCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlNguoiNhan.DataSource = tbl;
                ddlNguoiNhan.DataTextField = "MA_TEN";
                ddlNguoiNhan.DataValueField = "ID";
                ddlNguoiNhan.DataBind();
            }
            ddlNguoiNhan.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            //Set mặc định cán bộ login
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlNguoiNhan.SelectedValue = strCBID;
            }
            catch { }
        }
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
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
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        private void ResetControls()
        {
            //  ddlNguoiBanGiao.SelectedIndex = ddlNguoiNhan.SelectedIndex = 0; rdbTuCachToTung.ClearSelection();
            lbthongbao.Text = hddFilePath.Value = "";
            // txtNgayBanGiao.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtTenTL.Text = "";
            hddID.Value = "0";
        }
        private bool CheckValid()
        {
            if (Cls_Comon.IsValidDate(txtNgayBanGiao.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày bàn giao phải theo định dạng (dd/MM/yyyy)!";
                txtNgayBanGiao.Focus();
                return false;
            }

            if (rdbTuCachToTung.SelectedValue == "")
            {
                lbthongbao.Text = "Bạn chưa chọn tư cách tố tụng. Hãy chọn lại!";
                rdbTuCachToTung.Focus();
                return false;
            }
            if (ddlNguoiBanGiao.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn người bàn giao. Hãy chọn lại!";
                ddlNguoiBanGiao.Focus();
                return false;
            }
            if (ddlNguoiNhan.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn người nhận. Hãy chọn lại!";
                ddlNguoiNhan.Focus();
                return false;
            }
            if (txtTenTL.Text.Trim() == "")
            {
                lbthongbao.Text = "Bạn chưa nhập tên tài liệu !";
                txtTenTL.Focus();
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                decimal DonID = Convert.ToDecimal(hddDonID.Value), NguoiNhan = Convert.ToDecimal(ddlNguoiNhan.SelectedValue),
                    NguoiGiao = Convert.ToDecimal(ddlNguoiBanGiao.SelectedValue), LoaiDoiTuong = Convert.ToDecimal(rdbTuCachToTung.SelectedValue);
                DateTime NgayGiao = DateTime.Parse(this.txtNgayBanGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                // Nếu chọn file thì kiểm tra file trùng và thêm mới
                AKT_DON_TAILIEU donFile = new AKT_DON_TAILIEU();
                decimal TLID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                if (TLID > 0)
                    donFile = dt.AKT_DON_TAILIEU.Where(x => x.ID == TLID).FirstOrDefault<AKT_DON_TAILIEU>();
                else
                    donFile = new AKT_DON_TAILIEU();
                try
                {
                    if (hddFilePath.Value != "")
                    {
                        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                        FileInfo oF = new FileInfo(strFilePath);
                        #region Lưu file
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            donFile.NOIDUNG = buff;
                            donFile.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                            donFile.LOAIFILE = oF.Extension;
                        }
                        #endregion
                        File.Delete(strFilePath);
                    }
                }
                catch { }

                //--------------
                donFile.TENTAILIEU = txtTenTL.Text;
                donFile.LOAIDOITUONG = LoaiDoiTuong;
                donFile.NGAYBANGIAO = NgayGiao;
                donFile.NGUOIBANGIAO = NguoiGiao;
                donFile.NGUOINHANID = NguoiNhan;

                if (hddID.Value == "" || hddID.Value == "0")
                {
                    donFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    donFile.NGAYTAO = DateTime.Now;
                    donFile.DONID = DonID;
                    // insert toa_gq_id
                    if (donFile.TOA_GIAIQUYET_ID == null)
                    {
                        donFile.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AKT_DON_TAILIEU.Add(donFile);
                }
                else
                {
                    donFile.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    donFile.NGAYSUA = DateTime.Now;
                }
                dt.SaveChanges();

                //-------------------------
                hddPageIndex.Value = "1";
                LoadGridNgayBanGiao();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }
        #region Ngày bàn Giao
        public void LoadGridNgayBanGiao()
        {
            lbthongbao.Text = "";
            decimal DonViID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
            int Total = 0;
            AKT_DON_BL donBL = new AKT_DON_BL();
            DataTable tbl = donBL.AKT_DON_BanGiaoTaiLieu_GETLIST(DonViID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Total = Convert.ToInt32(tbl.Rows.Count);
            }
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            dgList.CurrentPageIndex = Convert.ToInt16(hddPageIndex.Value) - 1;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        public void xoaBanGiao(decimal ID)
        {
            AKT_DON_TAILIEU oT = dt.AKT_DON_TAILIEU.Where(x => x.ID == ID).FirstOrDefault();

            dt.AKT_DON_TAILIEU.Remove(oT);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGridNgayBanGiao();
            ResetControls();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                string strID = e.CommandArgument.ToString();
                decimal ID = Convert.ToDecimal(strID);
                switch (e.CommandName)
                {
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false || cmdUpdate.Enabled == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new AKT_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result != "")
                        {
                            lbthongbao.Text = Result;
                            return;
                        }
                        xoaBanGiao(ID);
                        lbthongbao.Text = "Xóa thành công!";
                        break;
                    case "Sua":
                        hddFilePath.Value = "";
                        AKT_DON_TAILIEU bgtl = dt.AKT_DON_TAILIEU.Where(x => x.ID == ID).FirstOrDefault();
                        if (bgtl != null)
                        {
                            rdbTuCachToTung.SelectedValue = bgtl.LOAIDOITUONG + "" == "" ? "" : bgtl.LOAIDOITUONG + "";
                            rdbTuCachToTung_SelectedIndexChanged(new object(), new EventArgs());
                            try { ddlNguoiBanGiao.SelectedValue = bgtl.NGUOIBANGIAO + "" == "" ? "0" : bgtl.NGUOIBANGIAO.ToString(); } catch { }
                            try { ddlNguoiNhan.SelectedValue = bgtl.NGUOINHANID + "" == "" ? "0" : bgtl.NGUOINHANID.ToString(); } catch { }
                            txtNgayBanGiao.Text = bgtl.NGAYBANGIAO + "" == "" ? "" : ((DateTime)bgtl.NGAYBANGIAO).ToString("dd/MM/yyyy");
                            txtTenTL.Text = bgtl.TENTAILIEU + "";
                            hddID.Value = ID.ToString();
                        }

                        break;
                    case "Download":
                        AKT_DON_TAILIEU oND = dt.AKT_DON_TAILIEU.Where(x => x.ID == ID).FirstOrDefault();
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.LOAIFILE + "';", true);
                        }
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #region Phân trang ngày bàn giao
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGridNgayBanGiao();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGridNgayBanGiao();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGridNgayBanGiao();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGridNgayBanGiao();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGridNgayBanGiao();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        #endregion
        protected void rdbTuCachToTung_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNguoiBanGiao();
                Cls_Comon.SetFocus(this, this.GetType(), ddlNguoiBanGiao.ClientID);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlNguoiBanGiao_SelectedIndexChanged(object sender, EventArgs e)
        {
            Cls_Comon.SetFocus(this, this.GetType(), ddlNguoiNhan.ClientID);
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AKT_DON oT = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault(); 

               
             

                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                string toagiaiquyetID = e.Item.Cells[8].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }



                //Nếu mà là án đã kết thúc ẩn nút lưu 
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc == true)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }

            }
        }
    }
}