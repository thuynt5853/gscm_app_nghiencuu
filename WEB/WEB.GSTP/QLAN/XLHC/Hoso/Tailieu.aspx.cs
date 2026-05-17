using BL.GSTP;

using DAL.GSTP;
using Module.Common;
using NLog;
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

namespace WEB.GSTP.QLAN.XLHC.Hoso
{
    public partial class Tailieu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    hddDonID.Value = current_id;
                    LoadDropNguoiBanGiao();
                    LoadDropNguoiNhan();
                    txtNgayBanGiao.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    decimal ID = Convert.ToDecimal(current_id);
                    CheckQuyen(ID);
                    hddPageIndex.Value = "1";
                    LoadGridNgayBanGiao();
                    txtNguoiBanGiao.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
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
            // string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg);

            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(ID, StrMsg);

            if (Result != "")
            {
                lbthongbao.Visible = true;
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                .FirstOrDefault();
            if (chuyenNhanAn != null)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển xét xử cấp phúc thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc == true)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }
        }
        private void LoadDropNguoiBanGiao()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            List<XLHC_DUONGSU> lstBidon = dt.XLHC_DUONGSU.Where(x => x.DONID == DonID).ToList();

            ddlNguoiBanGiao.Items.Clear();

            ddlNguoiBanGiao.DataSource = lstBidon;
            ddlNguoiBanGiao.DataTextField = "HOTEN";
            ddlNguoiBanGiao.DataValueField = "ID";
            ddlNguoiBanGiao.DataBind();

            // Nếu cần thêm item mặc định
            //ddlNguoiBanGiao.Items.Insert(0, new ListItem("-- Chọn người bàn giao --", "0"));
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
            //ddlNguoiBanGiao.SelectedIndex = ddlNguoiNhan.SelectedIndex = 0; rdbTuCachToTung.ClearSelection();
            lbthongbao.Text = hddFilePath.Value = "";
            //txtNgayBanGiao.Text = DateTime.Now.ToString("dd/MM/yyyy");
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
            DateTime NgayBanGiao = DateTime.Parse(txtNgayBanGiao.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            if (hddNgayNhanDon.Value != "")
            {
                DateTime NgayNhanDon = DateTime.Parse(hddNgayNhanDon.Value, cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgayBanGiao < NgayNhanDon)
                {
                    lbthongbao.Text = "Bạn phải nhập ngày bàn giao lớn hơn ngày nhận đơn " + hddNgayNhanDon.Value + " !";
                    txtNgayBanGiao.Focus();
                    return false;
                }
            }
            if (NgayBanGiao > DateTime.Now)
            {
                lbthongbao.Text = "Bạn phải nhập ngày bàn giao nhỏ hơn ngày hiện tại !";
                txtNgayBanGiao.Focus();
                return false;
            }
            //if (rdbTuCachToTung.SelectedValue == "")
            //{
            //    lbthongbao.Text = "Bạn chưa chọn tư cách tố tụng. Hãy chọn lại!";
            //    rdbTuCachToTung.Focus();
            //    return false;
            //}


            if (idNguonBanGiao.SelectedValue == "1" || idNguonBanGiao.SelectedValue == "3")
            {
                if (txtNguoiBanGiao.Text.Trim() == "")
                {
                    lbthongbao.Text = "Bạn chưa nhập người bàn giao. Hãy chọn lại!";
                    txtNguoiBanGiao.Focus();
                    return false;
                }


            }
            if (idNguonBanGiao.SelectedValue == "2")
            {
                if (ddlNguoiBanGiao.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn người bàn giao. Hãy chọn lại!";
                    ddlNguoiBanGiao.Focus();
                    return false;
                }
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
        //protected void btnUpdate_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        if (!CheckValid()) return;
        //        decimal DonID = Convert.ToDecimal(hddDonID.Value), NguoiNhan = Convert.ToDecimal(ddlNguoiNhan.SelectedValue);
        //        decimal NguoiGiao = Convert.ToDecimal(ddlNguoiBanGiao.SelectedValue);
        //        //decimal LoaiDoiTuong = Convert.ToDecimal(rdbTuCachToTung.SelectedValue);
        //        DateTime NgayGiao = DateTime.Parse(this.txtNgayBanGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
        //        string strFilePath = hddFilePath.Value.Replace("/", "\\");
        //        // Nếu chọn file thì kiểm tra file trùng và thêm mới
        //        XLHC_DON_TAILIEU donFile = new XLHC_DON_TAILIEU();
        //        decimal TLID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
        //        if (TLID > 0)
        //            donFile = dt.XLHC_DON_TAILIEU.Where(x => x.ID == TLID).FirstOrDefault<XLHC_DON_TAILIEU>();
        //        else
        //            donFile = new XLHC_DON_TAILIEU();
        //        try
        //        {
        //            if (hddFilePath.Value != "")
        //            {
        //                FileInfo oF = new FileInfo(strFilePath);
        //                #region Lưu file
        //                byte[] buff = null;
        //                using (FileStream fs = File.OpenRead(strFilePath))
        //                {
        //                    BinaryReader br = new BinaryReader(fs);
        //                    long numBytes = oF.Length;
        //                    buff = br.ReadBytes((int)numBytes);
        //                    donFile.NOIDUNG = buff;
        //                    donFile.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
        //                    donFile.LOAIFILE = oF.Extension;
        //                }
        //                #endregion
        //            }
        //            File.Delete(strFilePath);
        //        }
        //        catch { }

        //        //--------------
        //        donFile.TENTAILIEU = txtTenTL.Text;
        //        //donFile.LOAIDOITUONG = LoaiDoiTuong;
        //        donFile.NGAYBANGIAO = NgayGiao;
        //        donFile.NGUOIBANGIAO = NguoiGiao;
        //        donFile.NGUOINHANID = NguoiNhan;

        //        if (hddID.Value == "" || hddID.Value == "0")
        //        {
        //            donFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
        //            donFile.NGAYTAO = DateTime.Now;
        //            donFile.DONID = DonID;
        //            dt.XLHC_DON_TAILIEU.Add(donFile);
        //        }
        //        else
        //        {
        //            donFile.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
        //            donFile.NGAYSUA = DateTime.Now;
        //        }
        //        dt.SaveChanges();
        //        hddPageIndex.Value = "1";
        //        LoadGridNgayBanGiao();
        //        ResetControls();
        //        lbthongbao.Text = "Lưu thành công!";
        //    }
        //    catch (Exception ex)
        //    {
        //        lbthongbao.Text = "Lỗi: " + ex.Message;
        //    }
        //}

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                // Kiểm tra tính hợp lệ của form trước khi xử lý
                if (!CheckValid()) return;

                decimal DonID = Convert.ToDecimal(hddDonID.Value);
                decimal NguoiNhan = Convert.ToDecimal(ddlNguoiNhan.SelectedValue);
                decimal nguonBanGiao = Convert.ToDecimal(idNguonBanGiao.SelectedValue);

                string nguoiBanGiao = string.Empty;
                // Kiểm tra nếu người dùng chọn Đơn vị đề nghị (1) hoặc Khác (3)
                if (nguonBanGiao == 1 || nguonBanGiao == 3)
                {
                    nguoiBanGiao = txtNguoiBanGiao.Text.Trim();
                }
                // Kiểm tra nếu người dùng chọn Người đề nghị (2)
                else if (nguonBanGiao == 2)
                {
                    nguoiBanGiao = ddlNguoiBanGiao.SelectedItem.Text; // Lấy giá trị text từ DropDownList
                }

                DateTime NgayGiao = DateTime.Parse(this.txtNgayBanGiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                string strFilePath = hddFilePath.Value.Replace("/", "\\");

                decimal TLID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

                XLHC_DON_BL oXLHCDONBL = new XLHC_DON_BL();

                byte[] fileContent = null;
                string fileName = "";
                string fileExtension = "";

                if (!string.IsNullOrEmpty(hddFilePath.Value))
                {
                    try
                    {
                        FileInfo oF = new FileInfo(strFilePath);

                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            long numBytes = oF.Length;
                            fileContent = br.ReadBytes((int)numBytes);
                            fileName = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                            fileExtension = oF.Extension;
                        }

                        File.Delete(strFilePath);
                    }
                    catch (Exception fileEx)
                    {
                        System.Diagnostics.Debug.WriteLine("Lỗi khi xử lý file: " + fileEx.Message);
                    }
                }

                // Tạo Dictionary chứa các tham số cho stored procedure với đúng tên tham số
                Dictionary<string, object> parameters = new Dictionary<string, object>()
                    {
                        { "p_ID", TLID },
                        { "p_DONID", DonID },
                        { "p_TENTAILIEU", txtTenTL.Text },
                        { "p_NGUONBANGIAO", nguonBanGiao },
                        { "p_NGAYBANGIAO", NgayGiao },
                        { "p_NGUOIBANGIAO_NEW", nguoiBanGiao }, // Chú ý tên tham số có dấu gạch dưới
                        { "p_NGUOINHANID", NguoiNhan },
                        { "p_NGUOITHUCHIEN", Session[ENUM_SESSION.SESSION_USERNAME] + "" },
                        { "p_OPERATION", TLID > 0 ? "UPDATE" : "INSERT" },
                        { "p_TOA_GIAIQUYET_ID", Session[ENUM_SESSION.SESSION_DONVIID] + "" },
                    };

                // Thêm tham số file nếu có, ngược lại truyền DBNull
                parameters.Add("p_NOIDUNG", fileContent != null ? (object)fileContent : DBNull.Value);
                parameters.Add("p_TENFILE",
                    !string.IsNullOrEmpty(fileName) ?
                    Path.GetFileNameWithoutExtension(fileName) :
                    (object)DBNull.Value);
                parameters.Add("p_LOAIFILE", !string.IsNullOrEmpty(fileExtension) ? fileExtension : (object)DBNull.Value);

                // Gọi stored procedure
                int result = oXLHCDONBL.XLHC_GIAO_NHAN_CHUNG_CU_TAI_LIEU(parameters);

                // Xử lý kết quả
                if (result > 0)
                {
                    hddPageIndex.Value = "1";
                    LoadGridNgayBanGiao();
                    ResetControls();
                    lbthongbao.Text = "Lưu thành công!";
                }
                else
                {
                    lbthongbao.Text = "Lưu không thành công!";
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi trong btnUpdate_Click:: " + ex.Message;
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
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            int Total = 0;
            XLHC_DON_BL donBL = new XLHC_DON_BL();
            DataTable tbl = donBL.XLHC_DON_BanGiaoTaiLieu_GETLIST_V2(DonID);
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
            XLHC_DON_TAILIEU oT = dt.XLHC_DON_TAILIEU.Where(x => x.ID == ID).FirstOrDefault();
            dt.XLHC_DON_TAILIEU.Remove(oT);
            dt.SaveChanges();
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
                        decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg);
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
                        XLHC_DON_TAILIEU bgtl = dt.XLHC_DON_TAILIEU.Where(x => x.ID == ID).FirstOrDefault();

                        if (bgtl != null)
                        {
                            // Load common data first
                            txtTenTL.Text = bgtl.TENTAILIEU;
                            txtNgayBanGiao.Text = bgtl.NGAYBANGIAO + "" == "" ? "" : ((DateTime)bgtl.NGAYBANGIAO).ToString("dd/MM/yyyy");
                            ddlNguoiNhan.SelectedValue = bgtl.NGUOINHANID + "" == "" ? "0" : bgtl.NGUOINHANID.ToString();

                            // First, load all possible dropdown values
                            LoadDropNguoiBanGiao();

                            // Now set the selection source
                            idNguonBanGiao.SelectedValue = bgtl.NGUONBANGIAO.ToString();

                            // Trigger the visibility change based on source
                            rdbNguonBanGiao_SelectedIndexChanged(new object(), new EventArgs());

                            // Now handle the specific source type
                            if (bgtl.NGUONBANGIAO == 1 || bgtl.NGUONBANGIAO == 3)
                            {
                                // For manual entry cases
                                txtNguoiBanGiao.Text = bgtl.NGUOIBANGIAO_NEW;
                            }
                            else if (bgtl.NGUONBANGIAO == 2)
                            {
                                // For dropdown selection cases
                                // First try to find the user by direct name match in existing items
                                ListItem existingItem = null;

                                foreach (ListItem item in ddlNguoiBanGiao.Items)
                                {
                                    if (item.Text == bgtl.NGUOIBANGIAO_NEW)
                                    {
                                        existingItem = item;
                                        break;
                                    }
                                }

                                if (existingItem != null)
                                {
                                    // User found by name in dropdown
                                    ddlNguoiBanGiao.SelectedValue = existingItem.Value;
                                }
                                else
                                {
                                    // Try to find by querying the database for the user ID
                                    XLHC_DUONGSU nguoiBanGiao = dt.XLHC_DUONGSU.Where(x => x.HOTEN == bgtl.NGUOIBANGIAO_NEW).FirstOrDefault();
                                    if (nguoiBanGiao != null)
                                    {
                                        // Check if the item exists in the dropdown by ID
                                        ListItem foundItem = ddlNguoiBanGiao.Items.FindByValue(nguoiBanGiao.ID.ToString());
                                        if (foundItem != null)
                                        {
                                            ddlNguoiBanGiao.SelectedValue = nguoiBanGiao.ID.ToString();
                                        }
                                        else
                                        {
                                            // If the user isn't in the dropdown, add them
                                            ddlNguoiBanGiao.Items.Add(new ListItem(nguoiBanGiao.HOTEN, nguoiBanGiao.ID.ToString()));
                                            ddlNguoiBanGiao.SelectedValue = nguoiBanGiao.ID.ToString();
                                        }
                                    }
                                    // If we can't find the user, leave the default selection
                                }
                            }
                        }

                        hddID.Value = ID.ToString();
                        break;
                    case "Download":
                        XLHC_DON_TAILIEU oND = dt.XLHC_DON_TAILIEU.Where(x => x.ID == ID).FirstOrDefault();
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.LOAIFILE + "';", true);
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
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
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
                
                decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                    .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                    .FirstOrDefault();
                if (chuyenNhanAn != null)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển xét xử cấp phúc thẩm, không được sửa đổi !";
                    lbtXoa.Visible = false;
                }
                string toagiaiquyetID = rowView["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!toagiaiquyetID.Equals(donviID))
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
            }
        }

        protected void rdbNguonBanGiao_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string selectedValue = idNguonBanGiao.SelectedValue;

                if (selectedValue == "1" || selectedValue == "3")
                {
                    txtNguoiBanGiao.Visible = true;
                    ddlNguoiBanGiao.Visible = false;
                }
                else if (selectedValue == "2")
                {
                    txtNguoiBanGiao.Visible = false;
                    ddlNguoiBanGiao.Visible = true;
                    LoadDropNguoiBanGiao(); // Load dữ liệu từ DB mỗi khi chọn Người đề nghị
                }

                // Set focus to the appropriate control
                if (txtNguoiBanGiao.Visible)
                {
                    Cls_Comon.SetFocus(this, this.GetType(), txtNguoiBanGiao.ClientID);
                }
                else if (ddlNguoiBanGiao.Visible)
                {
                    Cls_Comon.SetFocus(this, this.GetType(), ddlNguoiBanGiao.ClientID);
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi trong rdbNguonBanGiao_SelectedIndexChanged: " + ex.Message;
            }
        }


    }
}