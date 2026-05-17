using BL.GSTP;
using BL.GSTP.AHN;
using BL.GSTP.AKT;
using BL.GSTP.QLAN;
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

namespace WEB.GSTP.QLAN.AHN.Sotham
{
    public partial class KhangCaoKhangNghi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal KHANGCAO = 1, KHANGNGHI = 2;
        public decimal DonID = 0;
        string sTGTT = "tgtt_";

        /*Lưu ý: AHN_SOTHAM_KHANGCAO.LoaiDuongSu: =0:la duong su, =1: la nguoi tham gia TT 
         * theo yeu cau của cb ben ToaAn: Nguoi TGTT cũng duoc khang cao
         */
        protected void Page_Load(object sender, EventArgs e)
        {
            DonID = (string.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");
                    LoadComboboxKhangCao();
                    LoadComboboxKhangNghi();
                    decimal ID = Convert.ToDecimal(current_id);
                    CheckQuyen(ID);
                    LoadGrid();
                    ////check vu an ket thuc de thong bao khong cho sua
                    //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    //if (anKetThuc)
                    //{
                    //    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    //    Cls_Comon.SetButton(btnUpdate, false);
                    //    Cls_Comon.SetButton(btnLammoi, false);
                    //    hddShowCommand.Value = "False";
                    //}

                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(btnLammoi, oPer.CAPNHAT);

            AHN_DON oT = dt.AHN_DON.Where(x => x.ID == ID).FirstOrDefault();
            List<AHN_SOTHAM_THULY> lstCount = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
            if (lstCount.Count == 0)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            List<AHN_DON_THAMPHAN> lstTP = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
            if (lstTP.Count == 0)
            {
                lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            //string StrMsg = "Không được sửa đổi thông tin.";
            //string Result = new AHN_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            //if (Result != "")
            //{
            //    lbthongbao.Text = Result;
            //    Cls_Comon.SetButton(btnUpdate, false);
            //    Cls_Comon.SetButton(btnLammoi, false);
            //    hddShowCommand.Value = "False";
            //    return;
            //}

        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lblchitiet = (LinkButton)e.Item.FindControl("lblchitiet");
                Cls_Comon.SetLinkButton(lblchitiet, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" != "")
                {
                    lblDownload.Visible = true;
                }
                else
                {
                    lblDownload.Visible = false;
                }
                string toagiaiquyetID = e.Item.Cells[11].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lblchitiet.Visible = false;
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
                string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    rdbPanelKC.Enabled = false;
                    rdbPanelKC.SelectedValue = "1";

                }


                Decimal IsKhangCao = Convert.ToDecimal(rowView["IsKhangCao"]);
                Decimal idKCKN = Convert.ToDecimal(rowView["ID"]);
                if (IsKhangCao == 1)
                {
                    AHN_SOTHAM_KHANGCAO oKC = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == idKCKN).FirstOrDefault();
                    if (oKC != null)
                    {
                        if (oKC.GQ_TINHTRANG == 1 || oKC.TINHTRANG_GIAIQUYET == 2 || oKC.TINHTRANG_GIAIQUYET == 1)
                        {
                            lblSua.Visible = lbtXoa.Visible = false;
                            lblchitiet.Visible = true;

                            if (toagiaiquyetID != donviID)
                            {
                                lblchitiet.Visible = false;
                                lbtXoa.Visible = false;
                                lblSua.Visible = false;
                            }
                            return;
                        }
                        string StrMsg = "Không được sửa đổi thông tin khi đã tòa cấp trên đã nhận án.";
                        string Result = new AHN_CHUYEN_NHAN_AN_BL().Check_ChuyenNhanAn(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result == "")
                        {
                            lblSua.Visible = lbtXoa.Visible = true;
                            lblchitiet.Visible = false;

                            if (toagiaiquyetID != donviID)
                            {
                                lblchitiet.Visible = false;
                                lbtXoa.Visible = false;
                                lblSua.Visible = false;
                            }
                            return;
                        }

                        else
                        {
                            //là khang cáo qua han 
                            if (oKC.ISQUAHAN == 1)
                            {
                                //da duyet thi khong cho sua, xoa
                                //Chua duyệt thi cho sửa xóa
                                if (oKC.GQ_TINHTRANG == 1)
                                {
                                    lblSua.Visible = lbtXoa.Visible = false;
                                    lblchitiet.Visible = true;

                                    if (toagiaiquyetID != donviID)
                                    {
                                        lblchitiet.Visible = false;
                                        lbtXoa.Visible = false;
                                        lblSua.Visible = false;
                                    }
                                    return;
                                }


                                else
                                {
                                    lblSua.Visible = lbtXoa.Visible = true;
                                    lblchitiet.Visible = false;

                                    if (toagiaiquyetID != donviID)
                                    {
                                        lblchitiet.Visible = false;
                                        lbtXoa.Visible = false;
                                        lblSua.Visible = false;
                                    }
                                    return;
                                }

                            }
                            //Nếu không phải quá hạn thi không cho sưa xóa
                            else
                            {
                                lblSua.Visible = lbtXoa.Visible = false;
                                lblchitiet.Visible = true;

                                if (toagiaiquyetID != donviID)
                                {
                                    lblchitiet.Visible = false;
                                    lbtXoa.Visible = false;
                                    lblSua.Visible = false;
                                }
                                return;
                            }

                        }

                    }
                }
                else
                {
                    AHN_SOTHAM_KHANGNGHI oKN = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.ID == idKCKN).FirstOrDefault();
                    if (oKN != null)
                    {
                        if (oKN.TINHTRANG_GIAIQUYET == 3 || oKN.TINHTRANG_GIAIQUYET == 1)
                        {
                            lblSua.Visible = lbtXoa.Visible = false;
                            lblchitiet.Visible = true;

                            if (toagiaiquyetID != donviID)
                            {
                                lblchitiet.Visible = false;
                                lbtXoa.Visible = false;
                                lblSua.Visible = false;
                            }
                            return;
                        }
                    }
                }
                if (rowView["READONLY"].ToString() == "1")
                {
                    lblSua.Visible = lbtXoa.Visible = false;
                    lblchitiet.Visible = true;

                    if (toagiaiquyetID != donviID)
                    {
                        lblchitiet.Visible = false;
                        lbtXoa.Visible = false;
                        lblSua.Visible = false;
                    }
                    return;
                }
                if (!Convert.ToBoolean(hddShowCommand.Value))
                {
                    lblSua.Visible = lbtXoa.Visible = false;
                    lblchitiet.Visible = true;

                    if (toagiaiquyetID != donviID)
                    {
                        lblchitiet.Visible = false;
                        lbtXoa.Visible = false;
                        lblSua.Visible = false;
                    }
                    return;
                }

                ////check vu an ket thuc de thong bao khong cho sua
                //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                //if (anKetThuc)
                //{
                //    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                //    Cls_Comon.SetButton(btnUpdate, false);
                //    Cls_Comon.SetButton(btnLammoi, false);
                //    hddShowCommand.Value = "False";
                //    lblchitiet.Visible = false;
                //    lbtXoa.Visible = false;
                //    lblSua.Visible = false;
                //}
            }
        }
        #region Kháng cáo
        private void LoadComboboxKhangCao()
        {
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");

            DataTable tbl = new DataTable();
            tbl.Columns.Add("ID", typeof(string));
            tbl.Columns.Add("ARRDUONGSU", typeof(string));

            //Load đương sự
            AHN_DON_DUONGSU_BL oDSBL = new AHN_DON_DUONGSU_BL();
            DataTable tblDS = oDSBL.AHN_DUONGSU_KHANGCAO(DonID);

            //load nguoi tham gia to tung
            AHN_DON_BL oBL = new AHN_DON_BL();
            DataTable tblTGTT = oBL.AHN_DON_TGTT_GETLIST(DonID);

            DataRow new_row = null;

            if (tblDS != null)
            {
                foreach (DataRow row in tblDS.Rows)
                {
                    new_row = tbl.NewRow();
                    new_row["ARRDUONGSU"] = row["TENDUONGSU"] + "";
                    new_row["ID"] = row["ID"] + "";
                    tbl.Rows.Add(new_row);
                }
            }

            if (tblTGTT != null)
            {

                foreach (DataRow row in tblTGTT.Rows)
                {
                    new_row = tbl.NewRow();
                    new_row["ARRDUONGSU"] = row["HOTEN"] + " -- " + row["TENTC"];
                    new_row["ID"] = sTGTT + row["ID"] + "";
                    tbl.Rows.Add(new_row);
                }
            }

            ddlNguoikhangcao.DataSource = tbl;
            ddlNguoikhangcao.DataTextField = "ARRDUONGSU";
            ddlNguoikhangcao.DataValueField = "ID";
            ddlNguoikhangcao.DataBind();
            ddlNguoikhangcao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            //---------------------------------

            LoadQD_BAKhangCao();
        }
        private void LoadQD_BAKhangCao()
        {
            ddlSOQDBA_KC.Items.Clear();
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
            if (rdbLoaiKC.SelectedValue == "0")
            {
                LoadDrop_ST_BanAn(ddlSOQDBA_KC, DonID);
            }
            else if (rdbLoaiKC.SelectedValue == "1")
                LoadDrop_ST_QuyetDinh(ddlSOQDBA_KC, DonID, 1);
            else
                LoadDrop_ST_QuyetDinh(ddlSOQDBA_KC, DonID, 2);
            LoadQD_BA_InfoKhangCao();
        }
        private void LoadQD_BA_InfoKhangCao()
        {
            if (ddlSOQDBA_KC.SelectedValue == "0") return;
            if (rdbLoaiKC.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                AHN_SOTHAM_BANAN oT = dt.AHN_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oT.NGAYTUYENAN + "") ? "" : ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA_KC.Text = ""; }
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                AHN_SOTHAM_QUYETDINH oT = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA_KC.Text = ""; }
            }
            decimal DonIDID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
            AHN_DON oDon = dt.AHN_DON.Where(x => x.ID == DonIDID).FirstOrDefault();
            if (oDon != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                { txtToaAnQD_KC.Text = oToaAn.TEN; }
                else { txtToaAnQD_KC.Text = ""; }
            }
            else
            {
                txtToaAnQD_KC.Text = "";
            }
        }
        protected void lbtDownloadKhangCao_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddid.Value);
            AHN_SOTHAM_KHANGCAO oND = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        protected void rdbLoaiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BAKhangCao();
        }
        protected void ddlSOQDBA_KC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadQD_BA_InfoKhangCao(); } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void AsyncFileUpLoadKhangCao_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKhangCao.HasFile)
            {
                string strFileName = AsyncFileUpLoadKhangCao.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKhangCao.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KC.ClientID + "\").value = '" + path + "';", true);
            }
        }
        #endregion
        #region Kháng nghị
        private void LoadComboboxKhangNghi()
        {
            LoadQD_BAKhangNghi();
        }
        private void LoadQD_BAKhangNghi()
        {
            ddlSOQDBAKhangNghi.Items.Clear();
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
            if (rdbLoaiKN.SelectedValue == "0")
            {
                LoadDrop_ST_BanAn(ddlSOQDBAKhangNghi, DonID);
            }
            else if (rdbLoaiKN.SelectedValue == "1")
                LoadDrop_ST_QuyetDinh(ddlSOQDBAKhangNghi, DONID, 1);
            else if (rdbLoaiKN.SelectedValue == "2")
                LoadDrop_ST_QuyetDinh(ddlSOQDBAKhangNghi, DONID, 2);
            LoadQD_BA_InfoKhangNghi();
        }
        void LoadDrop_ST_BanAn(DropDownList drop, Decimal DonID)
        {
            //Load số và ngày bản án để kháng cáo PAGE_KHANGCAO_ST
            PAGE_KHANGCAO_ST oBL = new PAGE_KHANGCAO_ST();
            DataTable oDT = oBL.DANHSACH_KHANGCAO_BANAN(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH, DonID);
            if (oDT != null)
            {
                drop.DataSource = oDT;
                drop.DataTextField = "TEN";
                drop.DataValueField = "ID";
                drop.DataBind();
            }

            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            drop.SelectedIndex = 0;

        }
        void LoadDrop_ST_QuyetDinh(DropDownList drop, Decimal DonID, Decimal loaiKC)
        {
            if (loaiKC == 1)
            {
                PAGE_KHANGCAO_ST oBL = new PAGE_KHANGCAO_ST();
                DataTable oDT = oBL.DANHSACH_KHANGCAO_QUYETDINH(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH, DonID);
                if (oDT != null)
                {
                    drop.DataSource = oDT;
                    drop.DataTextField = "TEN";
                    drop.DataValueField = "ID";
                    drop.DataBind();
                }
            }
            else if (loaiKC == 2)
            {
                PAGE_KHANGCAO_ST oBL = new PAGE_KHANGCAO_ST();
                DataTable oDT = oBL.DANHSACH_KHANGCAO_QUYETDINH_KHAC(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH, DonID);
                if (oDT != null)
                {
                    drop.DataSource = oDT;
                    drop.DataTextField = "TEN";
                    drop.DataValueField = "ID";
                    drop.DataBind();
                }
            }
            drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadQD_BA_InfoKhangNghi()
        {
            if (ddlSOQDBAKhangNghi.Items.Count == 0) return;
            if (rdbLoaiKN.SelectedValue == "0")
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                AHN_SOTHAM_BANAN oT = dt.AHN_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYTUYENAN + "") ? "" : ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA_KN.Text = ""; }
            }
            else
            {
                decimal ID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                AHN_SOTHAM_QUYETDINH oT = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                {
                    txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oT.NGAYQD + "") ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
                }
                else { txtNgayQDBA_KN.Text = ""; }
            }
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
            AHN_DON oDon = dt.AHN_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (oDon != null)
            {
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                if (oToaAn != null)
                { txtToaAnQD_KN.Text = oToaAn.TEN; }
                else { txtToaAnQD_KN.Text = ""; }
            }
            else
            {
                txtToaAnQD_KN.Text = "";
            }
        }
        protected void lbtDownloadKhangNghi_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddid.Value);
            AHN_SOTHAM_KHANGNGHI oND = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
            if (oND.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
            }
        }
        protected void ddlSOQDBAKhangNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD_BA_InfoKhangNghi();
        }
        protected void AsyncFileUpLoadKhangNghi_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKhangNghi.HasFile)
            {
                string strFileName = AsyncFileUpLoadKhangNghi.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKhangNghi.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KN.ClientID + "\").value = '" + path + "';", true);
            }
        }
        #endregion
        private void ResetControls()
        {
            lbthongbao.Text = "";
            rdbPanelKC.Visible = rdbPanelKN.Visible = true;
            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString() && rdbPanelKN.SelectedValue == KHANGCAO.ToString())//
            {
                #region Kháng cáo
                rdbHinhThucNhanDon.SelectedValue = "1";
                txtNgaykhangcao.Text = "";
                ddlNguoikhangcao.SelectedIndex = 0;
                rdbLoaiKC.SelectedValue = "0";
                rdbQuahan_KC.SelectedValue = "0";
                LoadQD_BAKhangCao();
                txtNoidungKC.Text = "";
                rdbMienAnphi.SelectedValue = "0";
                txtSobienlai.Text = "";
                txtAnphi.Text = "";
                txtNgaynopanphi.Text = "";
                hddFilePath_KC.Value = "";
                lbtDownloadKhangCao.Visible = false;
                #endregion
            }
            else if (rdbPanelKC.SelectedValue == KHANGNGHI.ToString() && rdbPanelKN.SelectedValue == KHANGNGHI.ToString())
            {
                #region Kháng nghị
                txtSokhangnghi.Text = txtNgaykhangnghi.Text = "";
                rdbCapkhangnghi.SelectedValue = "1";
                rdbLoaiKN.SelectedValue = "0";
                LoadQD_BA_InfoKhangNghi();
                txtNoidungKN.Text = "";
                hddFilePath_KN.Value = "";
                lbtDownloadKhangNghi.Visible = false;
                #endregion
            }
            hddid.Value = "0";
        }
        public void LoadGrid()
        {
            AHN_SOTHAM_BL oBL = new AHN_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
            DataTable oDT = oBL.AHN_SOTHAM_KCaoKNghi_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int Total = Convert.ToInt32(oDT.Rows.Count), pageSize = 20;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgList.PageSize = pageSize;
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
            try
            {
                decimal ID = 0, IsKhangCao = 0;
                string StrPara = "";
                StrPara = e.CommandArgument.ToString();
                if (StrPara.Contains(";#"))
                {
                    string[] arr = StrPara.Split(';');
                    ID = Convert.ToDecimal(arr[0] + "");
                    IsKhangCao = Convert.ToDecimal(arr[1].Replace("#", "") + "");
                }
                switch (e.CommandName)
                {
                    case "Download":
                        string TENFILE = "";
                        byte[] NOIDUNGFILE = null;
                        string KIEUFILE = "";
                        if (IsKhangCao == 1)
                        {
                            AHN_SOTHAM_KHANGCAO oKN = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                            TENFILE = oKN.TENFILE;
                            NOIDUNGFILE = oKN.NOIDUNGFILE;
                            KIEUFILE = oKN.KIEUFILE;
                        }
                        else
                        {
                            AHN_SOTHAM_KHANGNGHI oND = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                            TENFILE = oND.TENFILE;
                            NOIDUNGFILE = oND.NOIDUNGFILE;
                            KIEUFILE = oND.KIEUFILE;
                        }

                        if (!string.IsNullOrEmpty(TENFILE))
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + TENFILE + "&Extension=" + KIEUFILE + "';", true);
                        }
                        break;
                    case "Sua":
                        lbthongbao.Text = "";
                        LoadEdit(ID, IsKhangCao);
                        hddid.Value = ID.ToString();
                        break;
                    case "chitiet":
                        lbthongbao.Text = "";
                        LoadEdit(ID, IsKhangCao);
                        Cls_Comon.SetButton(btnUpdate, false);
                        Cls_Comon.SetButton(btnLammoi, false);
                        hddid.Value = ID.ToString();
                        break;
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false || btnUpdate.Enabled == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new AHN_CHUYEN_NHAN_AN_BL().Check_NhanAn(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        AHN_SOTHAM_KHANGCAO oKC = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == DonID && x.ID == ID).FirstOrDefault();
                        if (Result != "")
                        {
                            if (oKC.ISQUAHAN == 1)
                            {
                                //da duyet thi khong cho sua, xoa
                                //Chua duyệt thi cho sửa xóa
                                if (oKC.GQ_TINHTRANG == 1)
                                {
                                    lbthongbao.Text = Result;
                                    return;
                                }
                            }
                            //Nếu không phải quá hạn thi không cho sưa xóa
                            else
                            {
                                lbthongbao.Text = Result;
                                return;
                            }


                        }
                        xoa(ID, IsKhangCao);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        public void LoadEdit(decimal ID, decimal IsKhangCao)
        {
            try
            {
                lbthongbao.Text = "";
                rdbPanelKC.Visible = rdbPanelKN.Visible = true;
                if (IsKhangCao == KHANGCAO)// Kháng cáo
                {
                    rdbPanelKC.SelectedValue = rdbPanelKN.SelectedValue = KHANGCAO.ToString();
                    pnKhangCao.Visible = true;
                    pnKhangNghi.Visible = false;
                    AHN_SOTHAM_KHANGCAO oND = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND != null)
                    {
                        hddid.Value = oND.ID.ToString();
                        rdbHinhThucNhanDon.SelectedValue = oND.HINHTHUCNHAN.ToString();
                        txtNgaykhangcao.Text = string.IsNullOrEmpty(oND.NGAYKHANGCAO + "") ? "" : ((DateTime)oND.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);

                        int loaiduongsu = String.IsNullOrEmpty(oND.LOAIDUONGSU + "") ? 0 : (int)oND.LOAIDUONGSU;
                        if (loaiduongsu == 0)
                            ddlNguoikhangcao.SelectedValue = oND.DUONGSUID.ToString();
                        else
                            ddlNguoikhangcao.SelectedValue = sTGTT + oND.DUONGSUID.ToString();

                        rdbLoaiKC.SelectedValue = oND.LOAIKHANGCAO.ToString();
                        LoadQD_BAKhangCao();
                        ddlSOQDBA_KC.SelectedValue = oND.SOQDBA.ToString();
                        rdbQuahan_KC.SelectedValue = oND.ISQUAHAN.ToString();
                        txtNgayQDBA_KC.Text = string.IsNullOrEmpty(oND.NGAYQDBA + "") ? "" : ((DateTime)oND.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                        DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                        if (oToaAn != null) { txtToaAnQD_KC.Text = oToaAn.TEN; } else { txtToaAnQD_KC.Text = ""; }
                        txtNoidungKC.Text = oND.NOIDUNGKHANGCAO;

                        String DuongSuID = oND.DUONGSUID.ToString();
                        AHN_ANPHI oAP = dt.AHN_ANPHI.Where(x => x.DONID == oND.DONID && x.DUONGSU_IDS == DuongSuID && x.MAGIAIDOAN == 3).FirstOrDefault();
                        if (oAP != null)
                        {
                            rdbMienAnphi.SelectedValue = oAP.TINHTRANG.ToString();
                            txtSobienlai.Enabled = txtAnphi.Enabled = txtNgaynopanphi.Enabled = (oAP.TINHTRANG == 1) ? false : true;
                            txtAnphi.Text = (String.IsNullOrEmpty(oAP.TAMUNGANPHI + "")) ? "" : oAP.TAMUNGANPHI.ToString();
                            txtSobienlai.Text = (String.IsNullOrEmpty(oAP.SOBIENLAI + "")) ? "" : oAP.SOBIENLAI.ToString();
                            txtNgaynopanphi.Text = (String.IsNullOrEmpty(oAP.NGAYNOPANPHI + "")) ? "" : ((DateTime)oAP.NGAYNOPANPHI).ToString("dd/MM/yyyy", cul);
                        }
                        else
                        {
                            rdbMienAnphi.SelectedValue = null;
                            txtSobienlai.Enabled = txtAnphi.Enabled = txtNgaynopanphi.Enabled = false;
                            txtAnphi.Text = "0";
                            txtSobienlai.Text = "";
                            txtNgaynopanphi.Text = "";
                            lbthongbao.Text = "Bạn chưa nhập 'Thông tin tạm ứng án phí phúc thẩm'!";
                        }
                        if ((oND.TENFILE + "") != "")
                        {
                            lbtDownloadKhangCao.Visible = true;
                        }
                        else
                        { lbtDownloadKhangCao.Visible = false; }
                    }
                }
                else // Kháng nghị
                {
                    rdbPanelKC.SelectedValue = rdbPanelKN.SelectedValue = KHANGNGHI.ToString();
                    pnKhangCao.Visible = false;
                    pnKhangNghi.Visible = true;
                    AHN_SOTHAM_KHANGNGHI oND = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND != null)
                    {
                        hddid.Value = oND.ID.ToString();
                        rdbDonVi.SelectedValue = oND.DONVIKN.ToString();
                        txtSokhangnghi.Text = oND.SOKN;
                        txtNgaykhangnghi.Text = string.IsNullOrEmpty(oND.NGAYKN + "") ? "" : ((DateTime)oND.NGAYKN).ToString("dd/MM/yyyy", cul);

                        rdbLoaiKN.SelectedValue = oND.LOAIKN.ToString();
                        LoadQD_BAKhangNghi();
                        ddlSOQDBAKhangNghi.SelectedValue = oND.BANANID.ToString();
                        txtNgayQDBA_KN.Text = string.IsNullOrEmpty(oND.NGAYBANAN + "") ? "" : ((DateTime)oND.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                        DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oND.TOAANRAQDID).FirstOrDefault();
                        if (oToaAn != null)
                        { txtToaAnQD_KN.Text = oToaAn.TEN; }
                        else { txtToaAnQD_KN.Text = ""; }
                        txtNoidungKN.Text = oND.NOIDUNGKN;
                        if ((oND.TENFILE + "") != "")
                        {
                            lbtDownloadKhangNghi.Visible = true;
                        }
                        else
                            lbtDownloadKhangNghi.Visible = false;

                        rdbCapkhangnghi.Items.Clear();
                        if (rdbDonVi.SelectedValue == "0")//Chánh án
                        {
                            rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                            rdbCapkhangnghi.SelectedValue = "1";
                        }
                        else//Viện kiểm sát
                        {
                            rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                            rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                            rdbCapkhangnghi.SelectedValue = "0";
                        }
                        rdbCapkhangnghi.SelectedValue = oND.CAPKN.ToString();
                        if (rdbCapkhangnghi.SelectedValue == "0")
                        {
                            trDVKN.Visible = false;
                        }
                        else
                        {
                            trDVKN.Visible = true;
                            LoadDVKN();
                            ddlDonViKN.SelectedValue = oND.TOAAN_VKS_KN.ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        public void xoa(decimal ID, decimal IsKhangCao)
        {
            if (IsKhangCao == KHANGCAO)// Kháng cáo
            {
                AHN_SOTHAM_KHANGCAO oND = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    dt.AHN_SOTHAM_KHANGCAO.Remove(oND);
                }
                String DuongSuID = oND.DUONGSUID.ToString();
                AHN_ANPHI objAP = dt.AHN_ANPHI.Where(x => x.DONID == DonID && x.DUONGSU_IDS == DuongSuID && x.MAGIAIDOAN == 3).FirstOrDefault();
                if (objAP != null)
                {
                    dt.AHN_ANPHI.Remove(objAP);
                }
            }
            else // Kháng nghị
            {
                AHN_SOTHAM_KHANGNGHI oND = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    dt.AHN_SOTHAM_KHANGNGHI.Remove(oND);
                }
            }
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID = 0, IsKhangCao = 0, DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "");
                AHN_DON oDon = dt.AHN_DON.Where(x => x.ID == DonID).FirstOrDefault();
                if (rdbPanelKC.SelectedValue == KHANGCAO.ToString() && rdbPanelKN.SelectedValue == KHANGCAO.ToString())// Kháng cáo
                {
                    IsKhangCao = KHANGCAO;
                    if (!CheckValid(IsKhangCao)) return;
                    AHN_SOTHAM_KHANGCAO oND;
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND = new AHN_SOTHAM_KHANGCAO();
                    }
                    else
                    {
                        ID = Convert.ToDecimal(hddid.Value);
                        oND = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                    }

                    if (rdbQuahan_KC.SelectedValue == "1")
                    {
                        DM_TOAAN toa = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault<DM_TOAAN>();
                        if (toa != null)
                        {
                            oND.GQ_TOAANID = toa.CAPCHAID;
                        }
                        oND.GQ_TINHTRANG = 0;
                    }

                    oND.DONID = DonID;
                    oND.HINHTHUCNHAN = Convert.ToDecimal(rdbHinhThucNhanDon.SelectedValue);
                    oND.NGAYVIETDON = oND.NGAYKHANGCAO = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                    if (ddlNguoikhangcao.SelectedValue.Contains(sTGTT))
                    {
                        oND.DUONGSUID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue.Replace(sTGTT, ""));
                        oND.LOAIDUONGSU = 1;
                    }
                    else
                    {
                        oND.DUONGSUID = Convert.ToDecimal(ddlNguoikhangcao.SelectedValue);
                        oND.LOAIDUONGSU = 0;
                    }

                    oND.LOAIKHANGCAO = Convert.ToDecimal(rdbLoaiKC.SelectedValue);
                    oND.SOQDBA = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
                    oND.ISQUAHAN = Convert.ToDecimal(rdbQuahan_KC.SelectedValue);
                    oND.NGAYQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.TOAANRAQDID = oDon.TOAANID;
                    oND.NOIDUNGKHANGCAO = txtNoidungKC.Text;
                    oND.TINHTRANG_GIAIQUYET = 0;

                    #region Án phí
                    String DuongSuID = oND.DUONGSUID.ToString();
                    AHN_ANPHI objAP = dt.AHN_ANPHI.Where(x => x.DONID == DonID && x.DUONGSU_IDS == DuongSuID && x.MAGIAIDOAN == 3).FirstOrDefault();
                    if (objAP != null)
                    {
                        objAP.NGAYSUA = DateTime.Now;
                        objAP.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        objAP.TINHTRANG = Convert.ToDecimal(rdbMienAnphi.SelectedValue);
                        objAP.TAMUNGANPHI = (String.IsNullOrEmpty(txtAnphi.Text.Trim())) ? 0 : Convert.ToDecimal(txtAnphi.Text.Trim(), cul);
                        objAP.SOBIENLAI = txtSobienlai.Text.Trim();
                        objAP.NGAYNOPANPHI = (String.IsNullOrEmpty(txtNgaynopanphi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaynopanphi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        dt.SaveChanges();
                    }
                    else
                    {
                        AHN_ANPHI lstAPnew = new AHN_ANPHI();

                        lstAPnew.DONID = DonID;

                        lstAPnew.NGAYTAO = DateTime.Now;
                        lstAPnew.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                        lstAPnew.MAGIAIDOAN = 3;

                        lstAPnew.TINHTRANG = Convert.ToDecimal(rdbMienAnphi.SelectedValue);
                        lstAPnew.TAMUNGANPHI = (String.IsNullOrEmpty(txtAnphi.Text.Trim())) ? 0 : Convert.ToDecimal(txtAnphi.Text.Trim(), cul);
                        lstAPnew.SOBIENLAI = txtSobienlai.Text.Trim();
                        lstAPnew.NGAYNOPANPHI = (String.IsNullOrEmpty(txtNgaynopanphi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaynopanphi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        lstAPnew.DUONGSU_IDS = oND.DUONGSUID.ToString();
                        lstAPnew.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHN_ANPHI.Add(lstAPnew);
                        dt.SaveChanges();
                    }
                    #endregion



                    if (hddFilePath_KC.Value != "")
                    {
                        try
                        {
                            string strFilePath = hddFilePath_KC.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oND.NOIDUNGFILE = buff;
                                oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                                oND.KIEUFILE = oF.Extension;
                            }
                            File.Delete(strFilePath);
                        }
                        catch (Exception ex) { lbthongbao.Text = ex.Message; }
                    }
                    else if (hddFilePath_KC.Value != "" && hddFilePath_KC.Value != "0")
                    {
                        decimal ID_File = Convert.ToDecimal(hddFilePath_KC.Value.ToString());
                        DON_KHAC_FILE oD_File = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID_File).FirstOrDefault();
                        if (oD_File != null)
                        {
                            oND.NOIDUNGFILE = oD_File.NOIDUNGFILE;
                            oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oD_File.TENFILE);
                            oND.KIEUFILE = oD_File.KIEUFILE;
                        }
                    }
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHN_SOTHAM_KHANGCAO.Add(oND);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    dt.SaveChanges();
                    ID = oND.ID;
                }
                else if (rdbPanelKC.SelectedValue == KHANGNGHI.ToString() && rdbPanelKN.SelectedValue == KHANGNGHI.ToString())// Kháng nghị
                {
                    IsKhangCao = KHANGNGHI;
                    if (!CheckValid(IsKhangCao)) return;

                    AHN_SOTHAM_KHANGNGHI oND;
                    if (hddid.Value == "" || hddid.Value == "0")
                        oND = new AHN_SOTHAM_KHANGNGHI();
                    else
                    {
                        ID = Convert.ToDecimal(hddid.Value);
                        oND = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                    }
                    oND.DONID = DonID;
                    oND.SOKN = txtSokhangnghi.Text;
                    oND.NGAYKN = (String.IsNullOrEmpty(txtNgaykhangnghi.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaykhangnghi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.DONVIKN = Convert.ToDecimal(rdbDonVi.SelectedValue);
                    oND.CAPKN = Convert.ToDecimal(rdbCapkhangnghi.SelectedValue);
                    oND.LOAIKN = Convert.ToDecimal(rdbLoaiKN.SelectedValue);
                    oND.BANANID = Convert.ToDecimal(ddlSOQDBAKhangNghi.SelectedValue);
                    oND.NGAYBANAN = (String.IsNullOrEmpty(txtNgayQDBA_KN.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQDBA_KN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.TOAANRAQDID = oDon.TOAANID;
                    oND.NOIDUNGKN = txtNoidungKN.Text;
                    oND.TINHTRANG_GIAIQUYET = 0;
                    if (trDVKN.Visible)
                        oND.TOAAN_VKS_KN = Convert.ToDecimal(ddlDonViKN.SelectedValue);
                    if (hddFilePath_KN.Value != "")
                    {
                        try
                        {
                            string strFilePath = hddFilePath_KN.Value.Replace("/", "\\");
                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                oND.NOIDUNGFILE = buff;
                                oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
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
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.AHN_SOTHAM_KHANGNGHI.Add(oND);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                    dt.SaveChanges();
                    ID = oND.ID;
                }
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                rdbPanelKC.Visible = rdbPanelKN.Visible = true;
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        private bool CheckValid(decimal isKhangCao)
        {
            if (isKhangCao == KHANGCAO)// Kháng cáo
            {
                if (rdbHinhThucNhanDon.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn hình thức nhận đơn. Hãy chọn lại!";
                    return false;
                }

                if (Cls_Comon.IsValidDate(txtNgaykhangcao.Text) == false)
                {
                    lbthongbao.Text = "Ngày kháng cáo chưa nhập hoặc không theo định dạng (dd/MM/yyyy)!";
                    txtNgaykhangcao.Focus();
                    return false;
                }
                if (ddlNguoikhangcao.SelectedValue == "0")
                {
                    lbthongbao.Text = "Chưa chọn người kháng cáo. Hãy chọn lại!";
                    ddlNguoikhangcao.Focus();
                    return false;
                }
                if (rdbLoaiKC.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn loại kháng cáo. Hãy chọn lại!";
                    return false;
                }
                if (ddlSOQDBA_KC.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn số QĐ/BA. Hãy chọn lại!";
                    return false;
                }
                if (rdbQuahan_KC.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn loại kháng cáo quá hạn. Hãy chọn lại!";
                    return false;
                }
                if (rdbMienAnphi.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn mục miễn án phí. Hãy chọn lại!";
                    return false;
                }
                if (txtSobienlai.Text.Trim().Length > 20)
                {
                    lbthongbao.Text = "Số biên lai không quá 20 ký tự. Hãy nhập lại!";
                    txtSobienlai.Focus();
                    return false;
                }
                if (txtNgaynopanphi.Text.Trim().Length > 0 && Cls_Comon.IsValidDate(txtNgaynopanphi.Text) == false)
                {
                    lbthongbao.Text = "Ngày nộp án phí phải theo định dạng (dd/MM/yyyy)!";
                    txtNgaynopanphi.Focus();
                    return false;
                }

                //Kiểm tra ngày kháng cáo
                DateTime dNgayKC = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayKC > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày kháng cáo không được lớn hơn ngày hiện tại !";
                    txtNgaykhangcao.Focus();
                    return false;
                }
                DateTime dNgayQDBA = (String.IsNullOrEmpty(txtNgayQDBA_KC.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQDBA_KC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);

                if (rdbLoaiKC.SelectedValue == "0")//Bản án
                {
                    if (dNgayKC < dNgayQDBA)
                    {
                        lbthongbao.Text = "Ngày kháng cáo không được trước ngày bản án !";
                        txtNgaykhangcao.Focus();
                        return false;
                    }
                }
                else//Quyết định
                {
                    if (dNgayKC < dNgayQDBA)
                    {
                        lbthongbao.Text = "Ngày kháng cáo không được trước ngày quyết định !";
                        txtNgaykhangcao.Focus();
                        return false;
                    }

                }
            }
            else// Kháng nghị
            {
                if (txtSokhangnghi.Text == "")
                {
                    lbthongbao.Text = "Bạn chưa nhập số kháng nghị. Hãy nhập lại!";
                    txtSokhangnghi.Focus();
                    return false;
                }
                if (Cls_Comon.IsValidDate(txtNgaykhangnghi.Text) == false)
                {
                    lbthongbao.Text = "Ngày kháng nghị phải theo định dạng (dd/MM/yyyy)!";
                    txtNgaykhangnghi.Focus();
                    return false;
                }
                if (rdbCapkhangnghi.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn cấp kháng nghị. Hãy chọn lại!";
                    return false;
                }
                if (rdbLoaiKN.SelectedValue == "")
                {
                    lbthongbao.Text = "Bạn chưa chọn loại kháng nghị. Hãy chọn lại!";
                    return false;
                }
                if (ddlSOQDBAKhangNghi.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn số QĐ/BA. Hãy chọn lại!";
                    return false;
                }
                if (txtNoidungKN.Text.Trim().Length > 1000)
                {
                    lbthongbao.Text = "Nội dung kháng nghị không quá 1000 ký tự. Hãy nhập lại!";
                    txtNoidungKN.Focus();
                    return false;
                }
            }
            return true;
        }
        protected void rdbPanelKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            ResetControls();
            lbthongbao.Text = "";
            if (rdbPanelKN.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            {
                rdbPanelKC.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
            }
            else // Kháng nghị
            {
                rdbPanelKC.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;
            }

        }
        protected void rdbPanelKC_SelectedIndexChanged(object sender, EventArgs e)
        {

            lbthongbao.Text = "";

            if (rdbPanelKC.SelectedValue == KHANGCAO.ToString()) // Kháng cáo
            {
                rdbPanelKN.SelectedValue = KHANGCAO.ToString();
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
            }
            else // Kháng nghị
            {
                rdbPanelKN.SelectedValue = KHANGNGHI.ToString();
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;

                DON_KHAC oD = dt.DON_KHAC.Where(x => x.DONID == DonID && x.LOAIANID == 3 && x.LOAIKCKN == 2).FirstOrDefault();
                rdbPanelKN.SelectedValue = "2";
                rdbPanelKC.SelectedValue = "2";
                pnKhangCao.Visible = false;
                pnKhangNghi.Visible = true;
                if (oD != null)
                {
                    rdbLoaiKN.SelectedValue = oD.LOAIKHANGCAO.ToString();
                    LoadQD_BAKhangNghi();
                    rdbDonVi.SelectedValue = oD.NGUOIKCKN.ToString();
                    txtSokhangnghi.Text = oD.SOKHANGNGHI.ToString();

                    rdbCapkhangnghi.Items.Clear();
                    if (rdbDonVi.SelectedValue == "0")//Chánh án
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "1";
                    }
                    else//Viện kiểm sát
                    {
                        rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                        rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                        rdbCapkhangnghi.SelectedValue = "0";
                    }
                    if (rdbCapkhangnghi.SelectedValue == "0")
                    {
                        ddlDonViKN.Items.Clear();
                        decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                        if (lstVKS.Count > 0)
                        {
                            ddlDonViKN.Items.Add(new ListItem(lstVKS[0].TEN, lstVKS[0].ID.ToString()));
                        }
                        trDVKN.Visible = true;
                    }
                    else
                    {
                        trDVKN.Visible = true;
                        LoadDVKN();
                    }

                    rdbCapkhangnghi.SelectedValue = oD.CAPKHANGNGHI.ToString();
                    ddlDonViKN.SelectedValue = oD.DONVIKHANGNGHI.ToString();
                    if (oD.NGAYKHANGCAO != DateTime.MinValue && oD.NGAYKHANGCAO != null) txtNgaykhangnghi.Text = ((DateTime)oD.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                    if (oD.NGAYQDBA != DateTime.MinValue && oD.NGAYQDBA != null) txtNgayQDBA_KN.Text = ((DateTime)oD.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                    if (oD.SOQDBA != "" || oD.SOQDBA != null) { ddlSOQDBAKhangNghi.SelectedValue = oD.SOQDBA.ToString(); }
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oD.TOAANRAQDID).FirstOrDefault();
                    if (oToaAn != null) { txtToaAnQD_KN.Text = oToaAn.TEN; } else { txtToaAnQD_KN.Text = ""; }
                    txtNoidungKN.Text = oD.NOIDUNGDON;

                    DON_KHAC_FILE oD_File = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == oD.ID).FirstOrDefault();
                    if (oD_File != null)
                    {
                        hddChonDonKN.Value = oD_File.ID.ToString();
                        lbtDownloadKhangNghi_DonKhangCao.Visible = true;

                    }
                }
            }
            ResetControls();
        }
        protected void rdbLoaiKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadQD_BAKhangNghi(); } catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void rdbDonVi_SelectedIndexChanged(object sender, EventArgs e)
        {
            rdbCapkhangnghi.Items.Clear();
            if (rdbDonVi.SelectedValue == "0")//Chánh án
            {
                rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                rdbCapkhangnghi.SelectedValue = "1";
            }
            else//Viện kiểm sát
            {
                rdbCapkhangnghi.Items.Add(new ListItem("Cùng cấp", "0"));
                rdbCapkhangnghi.Items.Add(new ListItem("Cấp trên", "1"));
                rdbCapkhangnghi.SelectedValue = "0";
            }
            if (rdbCapkhangnghi.SelectedValue == "0")
            {
                ddlDonViKN.Items.Clear();
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                if (lstVKS.Count > 0)
                {
                    ddlDonViKN.Items.Add(new ListItem(lstVKS[0].TEN, lstVKS[0].ID.ToString()));
                }
                trDVKN.Visible = true;
            }
            else
            {
                trDVKN.Visible = true;
                LoadDVKN();
            }
        }
        private void LoadDVKN()
        {
            ddlDonViKN.Items.Clear();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
            if (rdbDonVi.SelectedValue == "0")//Tòa án
            {
                DM_TOAAN oTAP1 = dt.DM_TOAAN.Where(x => x.ID == oTA.CAPCHAID).FirstOrDefault();
                ddlDonViKN.Items.Add(new ListItem(oTAP1.TEN, oTAP1.ID.ToString()));
                if (oTAP1.CAPCHAID != 0)
                {
                    DM_TOAAN oTAP2 = dt.DM_TOAAN.Where(x => x.ID == oTAP1.CAPCHAID).FirstOrDefault();
                    ddlDonViKN.Items.Add(new ListItem(oTAP2.TEN, oTAP2.ID.ToString()));
                    if (oTAP2.CAPCHAID != 0)
                    {
                        DM_TOAAN oTAP3 = dt.DM_TOAAN.Where(x => x.ID == oTAP2.CAPCHAID).FirstOrDefault();
                        ddlDonViKN.Items.Add(new ListItem(oTAP3.TEN, oTAP3.ID.ToString()));
                    }
                }
            }
            else//Viện kiểm sát
            {
                List<DM_VKS> lstVKS = dt.DM_VKS.Where(x => x.TOAANID == ToaAnID).ToList();
                if (lstVKS.Count > 0)
                {
                    decimal IDVKS1 = (decimal)lstVKS[0].CAPCHAID;
                    DM_VKS oVKS1 = dt.DM_VKS.Where(x => x.ID == IDVKS1).FirstOrDefault();
                    ddlDonViKN.Items.Add(new ListItem(oVKS1.TEN, oVKS1.ID.ToString()));
                    if (oVKS1.CAPCHAID != 0)
                    {
                        DM_VKS oVKS2 = dt.DM_VKS.Where(x => x.ID == oVKS1.CAPCHAID).FirstOrDefault();
                        ddlDonViKN.Items.Add(new ListItem(oVKS2.TEN, oVKS2.ID.ToString()));
                        if (oVKS2.CAPCHAID != 0)
                        {
                            DM_VKS oVKS3 = dt.DM_VKS.Where(x => x.ID == oVKS2.CAPCHAID).FirstOrDefault();
                            ddlDonViKN.Items.Add(new ListItem(oVKS3.TEN, oVKS3.ID.ToString()));
                        }
                    }
                }
            }
        }
        protected void rdbCapkhangnghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbCapkhangnghi.SelectedValue == "0")
            {
                trDVKN.Visible = false;
            }
            else
            {
                trDVKN.Visible = true;
                LoadDVKN();
            }
        }
        protected void rdbMienAnphi_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbMienAnphi.SelectedValue == "1")//Miễn phí
            {
                txtSobienlai.Enabled = txtAnphi.Enabled = txtNgaynopanphi.Enabled = false;
                txtSobienlai.Text = txtAnphi.Text = txtNgaynopanphi.Text = "";
            }
            else
            {
                txtSobienlai.Enabled = txtAnphi.Enabled = txtNgaynopanphi.Enabled = true;
            }
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }

        protected void txtNgaykhangcao_TextChanged(object sender, EventArgs e)
        {
            if (rdbHinhThucNhanDon.SelectedIndex != -1)
            {
                int hinhthuc_nhandon = Convert.ToInt16(rdbHinhThucNhanDon.SelectedValue);
                if (hinhthuc_nhandon == 0)
                {
                    //CheckNgayKCQuaHan();
                }
                else
                {
                    //buu dien
                }

            }
            CheckNgayKCQuaHan();
        }

        protected void ddlNguoikhangcao_SelectedIndexChanged(object sender, EventArgs e)
        {
            string NGUOIKC = ddlNguoikhangcao.SelectedValue.ToString();

            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_loaddonkc_bc(" + DonID + "," + NGUOIKC + ")");
        }

        protected void cmdLoadDonKhac_Click(object sender, EventArgs e)
        {
            string keyDonID = "THONGTIN.DONKHAC.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            decimal ID = Convert.ToDecimal(Session[keyDonID]);
            DON_KHAC oD = dt.DON_KHAC.Where(x => x.ID == ID && x.LOAIANID == 3 && x.LOAIKCKN == 1).FirstOrDefault();
            if (oD != null)
            {
                pnKhangCao.Visible = true;
                pnKhangNghi.Visible = false;
                rdbPanelKC.SelectedValue = "1";
                rdbPanelKN.SelectedValue = "1";
                rdbLoaiKC.SelectedValue = oD.LOAIKHANGCAO.ToString();
                LoadQD_BAKhangCao();
                ddlNguoikhangcao.SelectedValue = oD.DUONGSUID.ToString();
                //if (oD.NGAYVIETDONKC != DateTime.MinValue && oD.NGAYVIETDONKC != null) txtNgayvietdonKC.Text = ((DateTime)oD.NGAYVIETDONKC).ToString("dd/MM/yyyy", cul);
                if (oD.NGAYKHANGCAO != DateTime.MinValue && oD.NGAYKHANGCAO != null) txtNgaykhangcao.Text = ((DateTime)oD.NGAYKHANGCAO).ToString("dd/MM/yyyy", cul);
                if (oD.NGAYQDBA != DateTime.MinValue && oD.NGAYQDBA != null) txtNgayQDBA_KC.Text = ((DateTime)oD.NGAYQDBA).ToString("dd/MM/yyyy", cul);
                if (oD.SOQDBA != "" && oD.SOQDBA != null) { ddlSOQDBA_KC.SelectedValue = oD.SOQDBA.ToString(); }
                rdbQuahan_KC.SelectedValue = oD.ISQUAHAN.ToString();
                DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.ID == oD.TOAANRAQDID).FirstOrDefault();
                if (oToaAn != null) { txtToaAnQD_KC.Text = oToaAn.TEN; } else { txtToaAnQD_KC.Text = ""; }
                txtNoidungKC.Text = oD.NOIDUNGDON;

                DON_KHAC_FILE oD_File = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == oD.ID).FirstOrDefault();
                if (oD_File != null)
                {
                    hddChonDonKC.Value = oD_File.ID.ToString();
                    lbtDownloadKhangCao_DonKhangCao.Visible = true;

                }
            }
        }

        protected void lbtDownloadKhangCao_DonKhangCao_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddChonDonKC.Value);
            DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
            if (oFile.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oFile.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oFile.TENFILE + "&Extension=" + oFile.KIEUFILE + "';", true);
            }
        }

        protected void lbtDownloadKhangNghi_DonKhangCao_Click(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddChonDonKN.Value);
            DON_KHAC_FILE oFile = dt.DON_KHAC_FILE.Where(x => x.DONKHAC_ID == ID).FirstOrDefault();
            if (oFile.TENFILE != "")
            {
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: oFile.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oFile.TENFILE + "&Extension=" + oFile.KIEUFILE + "';", true);
            }
        }

        void CheckNgayKCQuaHan()
        {
            int songay = 15;
            DateTime ngaysosanh = new DateTime();
            DateTime ngaykc = (String.IsNullOrEmpty(txtNgaykhangcao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaykhangcao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            Decimal banan_qd_id = Convert.ToDecimal(ddlSOQDBA_KC.SelectedValue);
            int loai_ba_qd = Convert.ToInt16(rdbLoaiKC.SelectedValue);
            //truc tiep
            if (banan_qd_id > 0)
            {
                if (loai_ba_qd == 0)
                {
                    //Khangcao ban an--> NgayQuaHan > NgayBanAn + 15 ngay
                    AHN_SOTHAM_BANAN obj = dt.AHN_SOTHAM_BANAN.Where(x => x.ID == banan_qd_id).FirstOrDefault();
                    if (obj != null)
                        ngaysosanh = Convert.ToDateTime(obj.NGAYHIEULUC);
                }
                else
                {
                    //khang cao quyet dinh
                    //Neu la quyet dinh đinh chi/tạm dinh chi --> songay =7
                    AHN_SOTHAM_QUYETDINH obj = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == banan_qd_id).FirstOrDefault();
                    if (obj != null)
                    {
                        ngaysosanh = Convert.ToDateTime(obj.NGAYQD);
                        decimal loaiqd_id = Convert.ToDecimal(obj.LOAIQDID);
                        DM_QD_LOAI objLoaiQD = dt.DM_QD_LOAI.Where(x => x.ID == loaiqd_id).FirstOrDefault();
                        if (objLoaiQD != null)
                        {
                            if (objLoaiQD.MA == "TDC" || objLoaiQD.MA == "DC")
                                songay = 7;
                        }
                    }
                }

                if (ngaykc <= (ngaysosanh.AddDays(songay)))
                    rdbQuahan_KC.SelectedValue = "0";
                else
                    rdbQuahan_KC.SelectedValue = "1";
            }
        }
    }
}