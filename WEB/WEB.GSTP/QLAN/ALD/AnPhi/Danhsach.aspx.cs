using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Web.UI;
using BL.GSTP.ALD;
using BL.GSTP.TP_THADS;
using System.Net;
using Newtonsoft.Json;
using System.Configuration;
using System.Text;
using BL.GSTP.BANGSETGET;
using BL.GSTP.ADS;

namespace WEB.GSTP.QLAN.ALD.AnPhi
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    LoadDropNguoiNhan();
                    SetEnableZoneNopAnPhi(chkNopAnPhi.Checked);
                    txtHanNopAnPhi.Text = txtNgayNopAnPhi.Text = txtNgayNopBL.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    txtNgayNopBL.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //Cls_Comon.SetButton(cmdCapNhat, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdCapNhat, false);
                    LoadGrid_AnPhi();
                    LoadDropDuongSu();
                    CheckQuyen();
                }
                catch (Exception ex) { lbtthongbao.Text = ex.Message; }
            }
        }
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdCapNhat, oPer.CAPNHAT);
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal ID = Convert.ToDecimal(current_id);
            ALD_DON oT = dt.ALD_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbtthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdCapNhat, false);
                return;
            }
            ALD_DON_XULY donxl = dt.ALD_DON_XULY.Where(x => x.DONID == ID).FirstOrDefault();
            if (donxl != null)
            {
                hddNgayGQYC.Value = donxl.NGAYGQ_YC + "" == "" ? "" : ((DateTime)donxl.NGAYGQ_YC).ToString("dd/MM/yyyy");
            }
            //Kiểm tra Đơn đã trả lại đơn chưa

            List<ALD_DON_XULY> lts_donxl = dt.ALD_DON_XULY.Where(x => x.DONID == ID).ToList();

            if (lts_donxl != null && lts_donxl.Count > 0)
            {
                if (lts_donxl.Where(x => x.LOAIGIAIQUYET == 5).Count() == 0)
                {
                    lbtthongbao.Text = "Đơn chưa được giải quyết tại chức năng Giải quyết đơn !";
                    Cls_Comon.SetButton(cmdCapNhat, false);
                    return;
                }

                if (lts_donxl.Where(x => x.LOAIGIAIQUYET == 3).Count() > 0)
                {
                    lbtthongbao.Text = "Đơn đã trả lại, không được phép thụ lý !";
                    Cls_Comon.SetButton(cmdCapNhat, false);
                    return;
                }
            }

            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbtthongbao.Text = Result;
                Cls_Comon.SetButton(cmdCapNhat, false);
                return;
            }
            //List<ALD_SOTHAM_THULY> lstTL = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
            //if (lstTL.Count > 0)
            //{
            //    lbtthongbao.Text = "Đã thụ lý vụ việc không được sửa đổi !";
            //    Cls_Comon.SetButton(cmdCapNhat, false);
            //    return;
            //}

            //check vụ án đã kết thúc không cho sửa xóa
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbtthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                Cls_Comon.SetButton(cmdCapNhat, false);
                Cls_Comon.SetButton(cmdThuLy, false);
                return;
            }
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
            else
            {
                ddlNguoiNhan.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            //Set mặc định cán bộ loginf
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlNguoiNhan.SelectedValue = strCBID;
            }
            catch { }
        }
        void LoadDropDuongSu()
        {
            ddlDuongSu.Items.Clear();
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            ALD_DON_DUONGSU_BL oDSBL = new ALD_DON_DUONGSU_BL();
            //Danh mục lý do tra đơn
            ddlDuongSu.DataSource = oDSBL.ALD_DON_DUONGSU_BIENLAI_V2(DONID);
            ddlDuongSu.DataTextField = "TENDUONGSU";
            ddlDuongSu.DataValueField = "ID";
            ddlDuongSu.DataBind();
            ddlDuongSu.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        private void LoadGrid_AnPhi()
        {
            ALD_DON_BL oBL = new ALD_DON_BL();
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            DataTable oDT = oBL.ALD_ANPHI_GETBYDONID(DONID, 0, pageindex, page_size);
            if (oDT.Rows.Count > 0)
            {
                ALD_ANPHI ap = dt.ALD_ANPHI.Where(x => x.DONID == DONID && x.SOBIENLAI != null && x.TINHTRANG == 0).FirstOrDefault();
                if (ap != null)
                {
                    cmdThuLy.Visible = true;
                }
                DataRow row_last = oDT.Rows[0];
                //  LoadInfo_XuLyDon(Convert.ToDecimal(row_last["ID"] + ""));

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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

            rpt.DataSource = oDT;
            rpt.DataBind();
        }
        protected void rpt_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("lblDownloadAP_THA"));
            ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("lblDownloadAP"));
            decimal CurrID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "ENABLE":
                    ImageButton cmdENABLE = (ImageButton)e.Item.FindControl("cmdENABLE");
                    TUPHAP_QLA_BL oBLs = new TUPHAP_QLA_BL();
                    if (cmdENABLE.ImageUrl == "/UI/img/Manager/check.png")
                    {
                        oBLs.CHECK_TRANGTHAI_THULY(CurrID, "5");
                        cmdENABLE.ImageUrl = "/UI/img/Manager/Unlocked_Icon.png";
                        cmdENABLE.ToolTip = "Trạng thái mở khóa, Vụ việc chưa được thụ lý, có thể sửa được thông tin nộp án phí ở phần mềm án phí";
                    }
                    else
                    {
                        oBLs.CHECK_TRANGTHAI_THULY(CurrID, "5");
                        cmdENABLE.ImageUrl = "/UI/img/Manager/check.png";
                        cmdENABLE.ToolTip = "Trạng thái bị khóa, vụ việc đã được thụ lý, không thể sửa được thông tin nộp án phí ở phần mềm án phí";
                    }
                    break;
                case "Sua":
                    DON_MIENANPHI_BL dON_MIENANPHI_BL = new DON_MIENANPHI_BL();
                    DataTable dataTable = dON_MIENANPHI_BL.GET_DON_MIENANPHI_BY_ANPHI_ID(CurrID, 5);
                    if (dataTable != null && dataTable.Rows.Count > 0)
                    {
                        lbtthongbao.Text = "Đã miễn án phí không thể sửa!";
                        return;
                    }

                    hddCurrID.Value = CurrID.ToString();
                    CheckQuyen();
                    LoadInfo_AnPhi(CurrID);
                    break;
                case "Xoa":
                    try
                    {
                        DON_MIENANPHI_BL dON_MIENANPHI_BLs = new DON_MIENANPHI_BL();
                        DataTable dataTableXoa = dON_MIENANPHI_BLs.GET_DON_MIENANPHI_BY_ANPHI_ID(CurrID, 5);
                        if (dataTableXoa != null && dataTableXoa.Rows.Count > 0)
                        {
                            lbtthongbao.Text = "Đã miễn án phí không thể xóa!";
                            return;
                        }


                        string current_id = CurrID.ToString();
                        decimal APID = Convert.ToDecimal(current_id);
                        ALD_ANPHI objAP = dt.ALD_ANPHI.Where(x => x.ID == APID).FirstOrDefault();
                        objAP.NGAYNOPBIENLAI = (DateTime?)null;
                        objAP.SOBIENLAI = "";
                        objAP.NGUOINOP = "";
                        objAP.NGAYNOPANPHI = (DateTime?)null;

                        //dt.ALD_ANPHI.Remove(objAP);
                        dt.SaveChanges();
                        lbtthongbao.Text = "Xóa thành công!";
                        LoadGrid_AnPhi();
                    }
                    catch (Exception ex) { lbtthongbao.Text = ex.Message; }
                    break;
                case "DownloadAP":
                    DVCQG_FILE_BIENLAI oND = dt.DVCQG_FILE_BIENLAI.Where(x => x.ID == CurrID).FirstOrDefault();
                    if (oND.FILE_NAME != "")
                    {
                        //---Get file blob-----------
                        HiddenField hd_DownloadAP = (HiddenField)e.Item.FindControl("hd_DownloadAP");
                        String ND_id = hd_DownloadAP.Value;
                        String[] ND_id_arr = ND_id.Split(';');
                        TUPHAP_ANPHI_BL M_Object = new TUPHAP_ANPHI_BL();
                        String _FILE_NAME = "";
                        byte[] b = M_Object.File_Attach_Return(ND_id_arr[0], ref _FILE_NAME);
                        if (b.Length < 10000)
                        {
                            //----------call API-- update lại trường FILE_ATTACH của bảng DVCQG_FILE_BIENLAI 
                            DataTable oDT = M_Object.GET_URL_DVC_THANHTOAN(ND_id_arr[1]);//get url biên lai
                            WebClient client = new WebClient();
                            string apiUrl = ConfigurationManager.AppSettings["File_Bien_Lai"];
                            CapNhatFileModel is_file = new CapNhatFileModel();
                            is_file.DVCQG_TT_ID = ND_id_arr[1];
                            if (oDT != null)
                            {
                                is_file.URLBIENLAI = oDT.Rows[0]["URLBIENLAI"] + "";
                            }
                            var input = is_file;
                            string inputJson = JsonConvert.SerializeObject(input);
                            client.Headers.Clear();
                            client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                            client.Encoding = Encoding.UTF8;
                            string contents = client.UploadString(apiUrl, inputJson);
                            //----------call API-end
                            b = M_Object.File_Attach_Return(ND_id_arr[0], ref _FILE_NAME);
                            oND.FILE_ATTACH = b;
                        }
                        //------End----------
                        //var cacheKey = Guid.NewGuid().ToString("N");
                        //Context.Cache.Insert(key: cacheKey, value: oND.FILE_ATTACH, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.FILE_NAME + "&Extension=." + oND.FILE_NAME.Split(new char[] { '.' }, StringSplitOptions.RemoveEmptyEntries)[1] + "';", true);
                        Load_Respon_File(_FILE_NAME, b);
                    }
                    break;
                case "DownloadAP_THA":
                    String V_FILE_NAME = "";
                    TUPHAP_ANPHI_BL oBL = new TUPHAP_ANPHI_BL();
                    //--------------------
                    byte[] V_FILE_DATA = oBL.File_Attach_Anphi_Return("5", CurrID, ref V_FILE_NAME);
                    string V_FILE_TYLE = "";
                    if (V_FILE_NAME.LastIndexOf('.') > 0)
                    {
                        V_FILE_TYLE = V_FILE_NAME.Substring(V_FILE_NAME.LastIndexOf('.'));
                    }
                    if (V_FILE_NAME != "")
                    {
                        Load_Respon_File(V_FILE_NAME, V_FILE_DATA);
                        //var cacheKey = Guid.NewGuid().ToString("N");
                        //Context.Cache.Insert(key: cacheKey, value: V_FILE_DATA, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + V_FILE_NAME + "&Extension=" + V_FILE_TYLE + "';", true);
                    }
                    break;

            }
        }
        void Load_Respon_File(String _FILE_NAME, byte[] b)
        {
            string fileEx = "";
            if (_FILE_NAME.LastIndexOf('.') > 0)
            {
                fileEx = _FILE_NAME.Substring(_FILE_NAME.LastIndexOf('.'));
            }
            Response.Clear();
            Response.ContentEncoding = Encoding.Unicode;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + _FILE_NAME);
            switch (fileEx)
            {
                case ".pdf": Response.ContentType = "application/pdf"; break;
                case ".dwg": Response.ContentType = "image/vnd.dwg"; break;
                case ".doc": Response.ContentType = "application/msword"; break;
                case ".docx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.wordprocessingml.FileAttach"; break;
                case ".xls": Response.ContentType = "application/vnd.ms-excel"; break;
                case ".xlsx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.spreadsheetml.sheet"; break;
                case ".gif": Response.ContentType = "image/gif"; break;
                case ".jpeg": Response.ContentType = "image/jpg"; break;
                case ".jpg": Response.ContentType = "image/jpg"; break;
                case ".png": Response.ContentType = "image/png"; break;
                default: Response.ContentType = "application/octet-stream"; break; //getMimeType(sExtention, oConnection);  
            }
            Response.BinaryWrite(b);
            Response.Flush();
            Response.End();
        }
        void LoadInfo_AnPhi(Decimal CurrID)
        {
            string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
            decimal DONID = Convert.ToDecimal(current_id);

            List<ALD_ANPHI> lst = dt.ALD_ANPHI.Where(x => x.ID == CurrID).ToList<ALD_ANPHI>();
            if (lst != null && lst.Count > 0)
            {
                ALD_ANPHI obj = lst[0];
                //if (obj.TINHTRANG == 1)
                //    chkNopAnPhi.Checked = true;
                //else
                //    chkNopAnPhi.Checked = false;
                //SetEnableZoneNopAnPhi(chkNopAnPhi.Checked);

                hddShowNopAnPhi.Value = obj.TINHTRANG.ToString();
                //txtGiaTriTranhChap.Text = (String.IsNullOrEmpty(obj.GIATRITRANHCHAP + "")) ? "" : ((decimal)obj.GIATRITRANHCHAP).ToString("#,0.###", cul);
                //txtMucGiamAnPhi.Text = (String.IsNullOrEmpty(obj.MUCGIAMANPHI + "")) ? "" : ((decimal)obj.MUCGIAMANPHI).ToString("#,0.###", cul);
                //txtTamUngAnPhi.Text = (String.IsNullOrEmpty(obj.TAMUNGANPHI + "")) ? "" : ((decimal)obj.TAMUNGANPHI).ToString("#,0.###", cul);
                //txtAnPhi.Text = (String.IsNullOrEmpty(obj.ANPHI + "")) ? "" : ((decimal)obj.ANPHI).ToString("#,0.###", cul);
                //txtHanNopAnPhi.Text = ((String.IsNullOrEmpty(obj.HANNOP + "")) || ((DateTime)obj.HANNOP == DateTime.MinValue)) ? "" : ((DateTime)obj.HANNOP).ToString("dd/MM/yyyy", cul);
                //txtSoNgayGiaHan.Text = (String.IsNullOrEmpty(obj.SONGAYGIAHAN + "")) ? "" : ((decimal)obj.SONGAYGIAHAN).ToString("#,0.###", cul);
                ddlDuongSu.SelectedValue = obj.DUONGSU_ID + "";
                txtNguoiNop.Text = obj.NGUOINOP;
                txtNgayNopAnPhi.Text = (obj.NGAYNOPANPHI == null) ? "" : ((DateTime)obj.NGAYNOPANPHI).ToString("dd/MM/yyyy", cul);
                txtNgayNopBL.Text = (obj.NGAYNOPBIENLAI == null) ? "" : ((DateTime)obj.NGAYNOPBIENLAI).ToString("dd/MM/yyyy", cul);
                txtSoBienLai.Text = obj.SOBIENLAI;
                if (obj.NGUOINHANID != null) ddlNguoiNhan.SelectedValue = obj.NGUOINHANID.ToString();

                txtSoThongBao.Text = obj.SOTHONGBAO + "";
                try
                {
                    if (((DateTime)obj.NGAYTHONGBAO).ToString("dd/MM/yyyy") != "01/01/0001")
                        txtNgayThongBao.Text = (obj.NGAYTHONGBAO == null) ? "" : ((DateTime)obj.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);
                }
                catch
                {

                }
                //Cls_Comon.SetButton(cmdCapNhat, false);
                //List<ADS_SOTHAM_THULY> lstTL = dt.ADS_SOTHAM_THULY.Where(x => x.DONID == lst[0].DONID).ToList();
                //if (lstTL.Count > 0)
                //{
                //    lbtthongbao.Text = "Đã thụ lý vụ việc không được sửa đổi !";
                //    Cls_Comon.SetButton(cmdCapNhat, false);
                //}
            }
            else
            {
                Cls_Comon.SetButton(cmdCapNhat, true);
            }
        }
        void resertInforAnPhi()
        {
            txtSoBienLai.Text = null;
            txtNgayNopBL.Text = null;
            txtSoThongBao.Text = null;
            txtNgayThongBao.Text = null;
            txtNgayNopAnPhi.Text = null;
            ddlDuongSu.SelectedValue = "0";
            txtNguoiNop.Text = "";
            lbtthongbao.Text = "";
            hddCurrID.Value = "0";
            Cls_Comon.SetButton(cmdCapNhat, true);
        }
        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            try
            {
                if (chkNopAnPhi.Checked == false)
                {
                    DateTime NgayNopAnPhi = DateTime.MinValue;
                    DateTime NgayNopBienLai = DateTime.MinValue;
                    if (txtNgayNopAnPhi.Text == "")
                    {
                        lbtthongbao.Text = "Chưa nhập ngày nộp tạm ứng án phí !";
                        return;
                    }
                    else
                    {
                        if (!DateTime.TryParseExact(txtNgayNopAnPhi.Text, "dd/MM/yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayNopAnPhi))
                        {
                            lbtthongbao.Text = "Bạn phải nhập ngày nộp tạm ứng án phí theo định dạng (dd/MM/yyyy) !";
                            txtNgayNopAnPhi.Focus();
                            return;
                        }
                        if (NgayNopAnPhi > DateTime.Today)
                        {
                            lbtthongbao.Text = "Ngày nộp tạm ứng án phí phải nhỏ hơn ngày hiện tại!";
                            txtNgayNopAnPhi.Focus();
                            return;
                        }
                    }
                    if (ddlNguoiNhan.SelectedValue == "0")
                    {
                        lbtthongbao.Text = "Chưa chọn cán bộ nhận biên lai !";
                        ddlNguoiNhan.Focus();
                        return;
                    }
                    if (txtSoBienLai.Text == "")
                    {
                        lbtthongbao.Text = "Chưa nhập số biên lai !";
                        txtSoBienLai.Focus();
                        return;
                    }
                    if (txtNgayNopBL.Text == "")
                    {
                        lbtthongbao.Text = "Chưa nhập ngày nộp biên lai !";
                        txtNgayNopBL.Focus();
                        return;
                    }
                    else
                    {
                        if (!DateTime.TryParseExact(txtNgayNopBL.Text, "dd/MM/yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayNopBienLai))
                        {
                            lbtthongbao.Text = "Bạn phải nhập ngày nộp biên lai theo định dạng (dd/MM/yyyy) !";
                            txtNgayNopBL.Focus();
                            return;
                        }
                        if (NgayNopBienLai > DateTime.Today)
                        {
                            lbtthongbao.Text = "Ngày nộp biên lai phải nhỏ hơn hoặc bằng ngày hiện tại!";
                            txtNgayNopBL.Focus();
                            return;
                        }
                        if (NgayNopBienLai < NgayNopAnPhi)
                        {
                            lbtthongbao.Text = "Ngày nộp biên lai phải lớn hơn hoặc bằng ngày nộp tạm ứng án phí!";
                            txtNgayNopBL.Focus();
                            return;
                        }
                    }
                }
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                int APId = Convert.ToInt32(hddCurrID.Value);

                //-------Update bang an phi----------
                ALD_ANPHI objAP = new ALD_ANPHI();
                #region Update bang an phi
                try
                {
                    try
                    {
                        objAP = dt.ALD_ANPHI.Where(x => x.ID == APId).FirstOrDefault();

                        if (objAP != null)
                        {
                            objAP.NGAYSUA = DateTime.Now;
                            objAP.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        }
                        else
                        {
                            lbtthongbao.Text = "Không tồn tại án phí ID=" + APId;
                            return;
                        }
                    }
                    catch (Exception ex) { lbtthongbao.Text = ex.Message; }
                    objAP.NGUOINOP = txtNguoiNop.Text.Trim();
                    objAP.NGUOINHANID = Convert.ToDecimal(ddlNguoiNhan.SelectedValue);
                    objAP.SOBIENLAI = txtSoBienLai.Text.Trim();
                    objAP.NGAYNOPANPHI = (String.IsNullOrEmpty(txtNgayNopAnPhi.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNopAnPhi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    objAP.NGAYNOPBIENLAI = (String.IsNullOrEmpty(txtNgayNopBL.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNopBL.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    objAP.NGAYSUA = DateTime.Now;
                    objAP.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    objAP.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.SaveChanges();
                }
                catch (Exception ex) { }
                #endregion

                //-------------------------------------
                hddPageIndex.Value = "1";
                LoadGrid_AnPhi();
                resertInforAnPhi();
                lbtthongbao.Text = "Lưu thành công!";
                //cmdThuLy.Visible = true;
                //Cls_Comon.SetButton(cmdCapNhat, false);
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void cmdThuLy_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ALD/Sotham/ThuLy.aspx");
        }
        protected void txtNgayNopAnPhi_TextChanged(object sender, EventArgs e)
        {
            txtNgayNopBL.Text = txtNgayNopAnPhi.Text;
        }
        protected void rpt_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("lblDownloadAP_THA"));
                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl((ImageButton)e.Item.FindControl("lblDownloadAP"));
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal anPhiID = Convert.ToDecimal(rowView["ID"].ToString());

                // decimal vAPID = Convert.ToDecimal(rowView.Row[0]);

                decimal vAPID = Convert.ToDecimal(rowView.Row[0]);
                DAL.GSTP.DVCQG_THANH_TOAN oAP = dt.DVCQG_THANH_TOAN.Where(x => x.ANPHI_ID == vAPID).FirstOrDefault();
                ALD_SOTHAM_THULY oTLST = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();

                /*1. Nếu vụ án đang trong giai đoạn phúc thẩm thì không được xóa
                  2. Nếu vụ án đã có thụ lý sơ thẩm thì không được xóa
                  3. Nếu vụ án đã có biên lai án phí thì không được sửa và xóa*/
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oTLST != null)
                {
                    lblSua.Visible = lbtXoa.Visible = false;
                }
                else if (oAP != null)
                {
                    if (oAP.TRANGTHAITHANHTOAN == 1)
                    {
                        lblSua.Visible = lbtXoa.Visible = false;
                    }
                }
                else
                {
                    lblSua.Visible = lbtXoa.Visible = true;
                }

                ImageButton lblDownloadAP = (ImageButton)e.Item.FindControl("lblDownloadAP");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownloadAP.Visible = false;
                }
                else
                {
                    lblDownloadAP.Visible = true;
                }
                ImageButton lblDownloadAP_THA = (ImageButton)e.Item.FindControl("lblDownloadAP_THA");
                if (rowView["FILE_NAME_THA"] + "" == "")
                {
                    lblDownloadAP_THA.Visible = false;
                }
                else
                {
                    lblDownloadAP_THA.Visible = true;
                }
                ImageButton cmdENABLE = (ImageButton)e.Item.FindControl("cmdENABLE");
                if (rowView["ENABLE"] + "" == "1")
                {
                    cmdENABLE.ImageUrl = "/UI/img/Manager/check.png";
                    cmdENABLE.ToolTip = "Trạng thái bị khóa, vụ việc đã được thụ lý, không thể sửa được thông tin nộp án phí ở phần mềm án phí";
                }
                else
                {
                    cmdENABLE.ImageUrl = "/UI/img/Manager/Unlocked_Icon.png";
                    cmdENABLE.ToolTip = "Trạng thái mở khóa, Vụ việc chưa được thụ lý, có thể sửa được thông tin nộp án phí ở phần mềm án phí";
                }

                string toagiaiquyetID = rowView.Row["TOA_GIAIQUYET_ID"].ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!toagiaiquyetID.Equals(donviID))
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }

            }
        }
        protected void ddlDuongSu_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal idDS = Convert.ToDecimal(ddlDuongSu.SelectedValue);
            if (idDS != 0)
            {
                string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                decimal idAP = dt.ALD_ANPHI.Where(x => x.DONID == DONID && x.DUONGSU_ID == idDS).FirstOrDefault().ID;
                hddCurrID.Value = idAP.ToString();
                CheckQuyen();
                LoadInfo_AnPhi(idAP);
            }
            else
            {
                resertInforAnPhi();
                Cls_Comon.SetButton(cmdCapNhat, false);
            }
        }
        protected void chkNopAnPhi_CheckedChanged(object sender, EventArgs e)
        {
            SetEnableZoneNopAnPhi(chkNopAnPhi.Checked);
        }
        void SetEnableZoneNopAnPhi(bool status)
        {
            if (status)
                hddShowNopAnPhi.Value = "1";
            else
                hddShowNopAnPhi.Value = "0";

            txtSoBienLai.Enabled = status == true ? false : true;
            txtNgayNopAnPhi.Enabled = status == true ? false : true;
            txtNgayNopBL.Enabled = status == true ? false : true;
            ddlNguoiNhan.Enabled = status == true ? false : true;
            if (hddShowNopAnPhi.Value == "0")
                pnThongTinAnPhi.Visible = false;
            else
                pnThongTinAnPhi.Visible = true;
        }

        //protected void cmdxoa_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
        //        decimal DONID = Convert.ToDecimal(current_id);
        //        ALD_ANPHI objAP = dt.ALD_ANPHI.Where(x => x.DONID == DONID).FirstOrDefault();
        //        dt.ALD_ANPHI.Remove(objAP);
        //        dt.SaveChanges();
        //        lbtthongbao.Text = "Xóa thành công!";
        //        resertInforAnPhi();
        //    }
        //    catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        //}

        //void LoadInfo_AnPhi()
        //{
        //    string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
        //    decimal DONID = Convert.ToDecimal(current_id);

        //    List<AHN_ANPHI> lst = dt.AHN_ANPHI.Where(x => x.DONID == DONID).ToList<AHN_ANPHI>();
        //    if (lst != null && lst.Count > 0)
        //    {
        //        AHN_ANPHI obj = lst[0];
        //        if (obj.TINHTRANG == 1)
        //            chkNopAnPhi.Checked = true;
        //        else
        //            chkNopAnPhi.Checked = false;
        //        //chkNopAnPhi.Enabled = false;
        //        SetEnableZoneNopAnPhi(chkNopAnPhi.Checked);

        //        hddShowNopAnPhi.Value = obj.TINHTRANG.ToString();

        //        txtHanNopAnPhi.Text = ((obj.HANNOP == null) || ((DateTime)obj.HANNOP == DateTime.MinValue)) ? "" : ((DateTime)obj.HANNOP).ToString("dd/MM/yyyy", cul);
        //        txtGiaTriTranhChap.Text = (String.IsNullOrEmpty(obj.GIATRITRANHCHAP + "")) ? "" : ((decimal)obj.GIATRITRANHCHAP).ToString("#,0.###", cul);
        //        txtMucGiamAnPhi.Text = (String.IsNullOrEmpty(obj.MUCGIAMANPHI + "")) ? "" : ((decimal)obj.MUCGIAMANPHI).ToString("#,0.###", cul);
        //        txtTamUngAnPhi.Text = (String.IsNullOrEmpty(obj.TAMUNGANPHI + "")) ? "" : ((decimal)obj.TAMUNGANPHI).ToString("#,0.###", cul);
        //        txtAnPhi.Text = (String.IsNullOrEmpty(obj.ANPHI + "")) ? "" : ((decimal)obj.ANPHI).ToString("#,0.###", cul);                
        //        txtSoNgayGiaHan.Text = (String.IsNullOrEmpty(obj.SONGAYGIAHAN + "")) ? "" : ((decimal)obj.SONGAYGIAHAN).ToString("#,0.###", cul);


        //        txtNgayNopAnPhi.Text = (obj.NGAYNOPANPHI == null) ? "" : ((DateTime)obj.NGAYNOPANPHI).ToString("dd/MM/yyyy", cul);
        //        txtNgayNopBL.Text = (obj.NGAYNOPBIENLAI == null) ? "" : ((DateTime)obj.NGAYNOPBIENLAI).ToString("dd/MM/yyyy", cul);
        //        txtSoBienLai.Text = obj.SOBIENLAI;
        //        if (obj.NGUOINHANID != null) ddlNguoiNhan.SelectedValue = obj.NGUOINHANID.ToString();
        //        txtSoThongBao.Text = obj.SOTHONGBAO + "";
        //        if (((DateTime)obj.NGAYTHONGBAO).ToString("dd/MM/yyyy") != "01/01/0001")
        //            txtNgayThongBao.Text = (obj.NGAYTHONGBAO == null) ? "" : ((DateTime)obj.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);

        //        //Cls_Comon.SetButton(cmdCapNhat, false);
        //    }
        //    else
        //    {
        //        Cls_Comon.SetButton(cmdCapNhat, true);
        //    }
        //}

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid_AnPhi();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid_AnPhi();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid_AnPhi();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid_AnPhi();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid_AnPhi();
        }

        #endregion
    }
}