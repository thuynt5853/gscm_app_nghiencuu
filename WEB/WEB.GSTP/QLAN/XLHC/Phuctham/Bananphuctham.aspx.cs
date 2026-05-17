using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.Phuctham
{
    public partial class Bananphuctham : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        //"KN/KN quyết định ở  3,3 ST:chỉ hiển thị 1,2,3,4,5,6,7,13 
        // KN, KN ở mục 6 :8,9,10,11,12,13
        // Kháng cáo QĐ tạm đình chỉ: 1-7,13"
        private static readonly List<String> listQĐ_muc_3_3 = new List<String> { "22-BPXLHC", "23-BPXLHC", "24-BPXLHC", "27-BPXLHC", "25-BPXLHC", "26-BPXLHC", "28-BPXLHC", "34-BPXLHC"};
        private static readonly List<String> listQĐ_muc_6 = new List<String> { "29-BPXLHC", "30-BPXLHC", "31-BPXLHC", "32-BPXLHC", "33-BPXLHC", "34-BPXLHC" };
        private static readonly List<String> listQĐ_muc_3_2 = new List<String> { "22-BPXLHC", "23-BPXLHC", "24-BPXLHC", "27-BPXLHC", "25-BPXLHC", "26-BPXLHC", "28-BPXLHC", "34-BPXLHC" };
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch { return false; }
        }
        public string GetTextDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return (Convert.ToDateTime(obj).ToString("dd/MM/yyyy", cul));
            }
            catch { return ""; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";

                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    hddID.Value = current_id.ToString();
                    decimal ID = Convert.ToDecimal(current_id);

                    LoadDropQuanhephapluat();
                    LoadDropKetQuaPhucTham();
                    LoadDropLyDoBanAn();
                    LoadBanAnInfo(ID);
                    CheckQuyen();
                    CheckCongbo(ID);
                }
            }
            catch (Exception ex) { 
                lstErr.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
        }
        void CheckQuyen()
        {
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
            hddID.Value = current_id.ToString();
            decimal DONID = Convert.ToDecimal(current_id);
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
      
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            //Kiểm tra thẩm phán giải quyết đơn             
            
            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            List<XLHC_PHUCTHAM_THULY> lstCount = dt.XLHC_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lstErr.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }
            List<XLHC_DON_THAMPHAN> lstTP = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
            if (lstTP.Count == 0)
            {
                lstErr.Text = "Chưa phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lstErr.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lstErr.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                return;
            }
            
            XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                .FirstOrDefault();
            if (chuyenNhanAn != null)
            {
                // DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault<DM_TOAAN>();
                // lstErr.Text = "Án đã chuyển đến " + oTA.TEN + ". Không thể cập nhật!";
                lstErr.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                return;
            }

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lstErr.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                return;
            }
        }
        bool CheckCongbo(decimal ID)
        {
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.BPXLHC} AND CAPXETXU = 3 AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                lstErr.Text = "Đã có thông tin về công bố!";
                return false;
            }

            return true;
        }
        private void LoadFile()
        {
            decimal ID = Convert.ToDecimal(hddID.Value);
            dgFile.CurrentPageIndex = 0;
            List<XLHC_PHUCTHAM_BANAN_FILE> lst = dt.XLHC_PHUCTHAM_BANAN_FILE.Where(x => x.BANANID == ID).ToList();
            if (lst != null && lst.Count > 0)
            {
                dgFile.DataSource = lst;
                dgFile.DataBind();
                dgFile.Visible = true;
            }
            else
            {
                dgFile.DataSource = null;
                dgFile.DataBind();
                dgFile.Visible = false;
            }
        }
        private void LoadBanAnInfo(decimal DonID)
        {
            XLHC_PHUCTHAM_BANAN oT = dt.XLHC_PHUCTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault<XLHC_PHUCTHAM_BANAN>();
            if (oT != null)
            {
                hddBanAnID.Value = oT.ID.ToString();
                ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
                ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();
                txtSobanan.Text = oT.SOBANAN;
                txtNgaymophientoa.Text = string.IsNullOrEmpty(oT.NGAYMOPHIENTOA + "") ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)oT.NGAYMOPHIENTOA).ToString("dd/MM/yyyy", cul);
                txtNgaytuyenan.Text = string.IsNullOrEmpty(oT.NGAYTUYENAN + "") ? "" : ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                txtNgayhieuluc.Text = string.IsNullOrEmpty(oT.NGAYHIEULUC + "") ? "" : ((DateTime)oT.NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                //rdbAnle.SelectedValue = oT.APDUNGANLE.ToString();
                ddlKetQuaPhucTham.SelectedValue = oT.KETQUAPHUCTHAMID.ToString();
                LoadDropLyDoBanAn();
                ddlLyDoBanAn.SelectedValue = oT.LYDOBANANID.ToString();
                rdVuAnQuaHan.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISQUAHAN + "")) ? "0" : oT.TK_ISQUAHAN.ToString();
                rdNNChuQuan.SelectedValue = (string.IsNullOrEmpty(oT.TK_QUAHAN_CHUQUAN + "")) ? "0" : oT.TK_QUAHAN_CHUQUAN.ToString();
                rdNNKhachQuan.SelectedValue = (string.IsNullOrEmpty(oT.TK_QUAHAN_KHACHQUAN + "")) ? "0" : oT.TK_QUAHAN_KHACHQUAN.ToString();
                if (rdVuAnQuaHan.SelectedValue == "1")
                    pnNguyenNhanQuaHan.Visible = true;
                else
                    pnNguyenNhanQuaHan.Visible = false;
                //Load File
                LoadFile();
            }
            else
            {
                XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DonID).FirstOrDefault();
                if (oDon != null)
                {
                    ddlLoaiQuanhe.SelectedValue = oDon.LOAIQUANHE.ToString();
                    ddlQuanhephapluat.SelectedValue = oDon.QUANHEPHAPLUATID.ToString();
                }
                txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            }
        }
        private bool CheckValid()
        {
            if (ddlQuanhephapluat.Items.Count == 0)
            {
                lstErr.Text = "Chưa chọn quan hệ pháp luật !";
                ddlQuanhephapluat.Focus();
                return false;
            }
            int lengthSoBanAn = txtSobanan.Text.Trim().Length;
            if (lengthSoBanAn == 0)
            {
                lstErr.Text = "Chưa nhập số bản án !";
                txtSobanan.Focus();
                return false;
            }
            if (lengthSoBanAn > 20)
            {
                lstErr.Text = "Số bản án không nhập quá 20 ký tự. Hãy nhập lại !";
                txtSobanan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaymophientoa.Text) == false)
            {
                lstErr.Text = "Chưa nhập ngày mở phiên họp hoặc không theo định dạng (dd/MM/yyyy)!";
                txtNgaymophientoa.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaytuyenan.Text) == false)
            {
                lstErr.Text = "Chưa nhập ngày quyết định hoặc theo định dạng (dd/MM/yyyy)!";
                txtNgaytuyenan.Focus();
                return false;
            }
            if (txtNgayhieuluc.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgayhieuluc.Text) == false)
            {
                lstErr.Text = "Bạn phải nhập ngày hiệu lực theo định dạng (dd/MM/yyyy)!";
                txtNgayhieuluc.Focus();
                return false;
            }
            if (ddlKetQuaPhucTham.SelectedIndex == 0)
            {
                lstErr.Text = "Chưa chọn kết quả bản án phúc thẩm !";
                return false;
            }
            if (ddlLyDoBanAn.SelectedIndex == 0)
            {
                lstErr.Text = "Chưa chọn lý do bản án phúc thẩm !";
                return false;
            }

            //----------------------------
            string so = txtSobanan.Text;
            if (!String.IsNullOrEmpty(txtNgaytuyenan.Text))
            {
                DateTime ngayBA = DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoBATheoLoaiAn(DonViID, "XLHC_PT", so, ngayBA);
                if (CheckID > 0)
                {
                    Decimal CurrBanAnId = (string.IsNullOrEmpty(hddBanAnID.Value)) ? 0 : Convert.ToDecimal(hddBanAnID.Value);
                    String strMsg = "";
                    //String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "XLHC_PT", ngayBA).ToString();
                    if (CheckID != CurrBanAnId)
                    {
                        strMsg = "Số bản án " + txtSobanan.Text + " đã có trong hệ thống.";
                        //txtSobanan.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        //txtSobanan.Focus();
                        //return false;
                    }
                }
            }
            return true;
        }
        private void LoadDropQuanhephapluat()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
                ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_DENGHI_XLHC);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
        }
        private void LoadDropKetQuaPhucTham()
        {
            try
            {
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                List<XLHC_SOTHAM_KHANGCAO> oDon = dt.XLHC_SOTHAM_KHANGCAO
                    .Where(x => x.DONID == DONID)
                    .ToList();

                XLHC_SOTHAM_KHANGCAO qd32 = oDon.Where(x => x.TYPE_QD == 1).FirstOrDefault();
                XLHC_SOTHAM_KHANGCAO qd33 = oDon.Where(x => x.TYPE_QD == 2).FirstOrDefault();
                XLHC_SOTHAM_KHANGCAO qd6 = oDon.Where(x => x.TYPE_QD == 3).FirstOrDefault();

                HashSet<string> resultSet = new HashSet<string>();

                if (qd32 != null)
                {
                    resultSet.UnionWith(listQĐ_muc_3_2);
                }

                if (qd33 != null)
                {
                    resultSet.UnionWith(listQĐ_muc_3_3);
                }

                if (qd6 != null)
                {
                    resultSet.UnionWith(listQĐ_muc_6);
                }

                ddlKetQuaPhucTham.Items.Clear();
                ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM
                    .Where(x => x.ISXLHC == 1 && (resultSet.Contains(x.MA)))
                    .OrderBy(y => y.THUTU)
                    .ToList();
                
                ddlKetQuaPhucTham.DataTextField = "TEN";
                ddlKetQuaPhucTham.DataValueField = "ID";
                ddlKetQuaPhucTham.DataBind();
                ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

                //if (qd32 != null && qd33 != null && qd6 != null)
                //{
                //    ddlKetQuaPhucTham.Items.Clear();
                //    ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM
                //        .Where(x => x.ISXLHC == 1 && (listQĐ_muc_3_3.Contains(x.MA) || listQĐ_muc_6.Contains(x.MA)))
                //        .OrderBy(y => y.THUTU)
                //        .ToList();
                //    ddlKetQuaPhucTham.DataTextField = "TEN";
                //    ddlKetQuaPhucTham.DataValueField = "ID";
                //    ddlKetQuaPhucTham.DataBind();
                //    ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                //}
                //else if (qd32 != null && qd33 != null)
                //{
                //    ddlKetQuaPhucTham.Items.Clear();
                //    ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM
                //        .Where(x => x.ISXLHC == 1 && (listQĐ_muc_3_3.Contains(x.MA)))
                //        .OrderBy(y => y.THUTU)
                //        .ToList();
                //    ddlKetQuaPhucTham.DataTextField = "TEN";
                //    ddlKetQuaPhucTham.DataValueField = "ID";
                //    ddlKetQuaPhucTham.DataBind();
                //    ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                //}
                //else if (qd32 != null && qd6 != null)
                //{
                //    ddlKetQuaPhucTham.Items.Clear();
                //    ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM
                //        .Where(x => x.ISXLHC == 1 && (listQĐ_muc_6.Contains(x.MA)))
                //        .OrderBy(y => y.THUTU)
                //        .ToList();
                //    ddlKetQuaPhucTham.DataTextField = "TEN";
                //    ddlKetQuaPhucTham.DataValueField = "ID";
                //    ddlKetQuaPhucTham.DataBind();
                //    ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                //}
                //else if (qd33 != null && qd6 != null)
                //{
                //    ddlKetQuaPhucTham.Items.Clear();
                //    ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM
                //        .Where(x => x.ISXLHC == 1 && (listQĐ_muc_6.Contains(x.MA) || listQĐ_muc_3_3.Contains(x.MA)))
                //        .OrderBy(y => y.THUTU)
                //        .ToList();
                //    ddlKetQuaPhucTham.DataTextField = "TEN";
                //    ddlKetQuaPhucTham.DataValueField = "ID";
                //    ddlKetQuaPhucTham.DataBind();
                //    ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                //}
                //else if (qd32 != null) {
                //    ddlKetQuaPhucTham.Items.Clear();
                //    ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM
                //        .Where(x => x.ISXLHC == 1 && (listQĐ_muc_3_3.Contains(x.MA)))
                //        .OrderBy(y => y.THUTU)
                //        .ToList();
                //    ddlKetQuaPhucTham.DataTextField = "TEN";
                //    ddlKetQuaPhucTham.DataValueField = "ID";
                //    ddlKetQuaPhucTham.DataBind();
                //    ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                //}
                //else if (qd33 != null) {
                //    ddlKetQuaPhucTham.Items.Clear();
                //    ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM
                //        .Where(x => x.ISXLHC == 1 && (listQĐ_muc_3_3.Contains(x.MA)))
                //        .OrderBy(y => y.THUTU)
                //        .ToList();
                //    ddlKetQuaPhucTham.DataTextField = "TEN";
                //    ddlKetQuaPhucTham.DataValueField = "ID";
                //    ddlKetQuaPhucTham.DataBind();
                //    ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                //}
                //else if (qd6 != null) {
                //    ddlKetQuaPhucTham.Items.Clear();
                //    ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM
                //        .Where(x => x.ISXLHC == 1 && (listQĐ_muc_6.Contains(x.MA)))
                //        .OrderBy(y => y.THUTU)
                //        .ToList();
                //    ddlKetQuaPhucTham.DataTextField = "TEN";
                //    ddlKetQuaPhucTham.DataValueField = "ID";
                //    ddlKetQuaPhucTham.DataBind();
                //    ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                //}
                //else
                //{
                //    ddlKetQuaPhucTham.Items.Clear();
                //    ddlKetQuaPhucTham.DataBind();
                //    ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Không có dữ liệu ---", "0"));
                //}
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi khi LoadDropKetQuaPhucTham: " + ex.Message);
            }
        }

        private void LoadDropLyDoBanAn()
        {
            ddlLyDoBanAn.Items.Clear();
            decimal KetQuaID = Convert.ToDecimal(ddlKetQuaPhucTham.SelectedValue);
            DM_KETQUA_PHUCTHAM_LYDO_BL kqptLyDoBL = new DM_KETQUA_PHUCTHAM_LYDO_BL();
            DataTable dtTable = kqptLyDoBL.DM_KETQUA_PT_LYDO_GETLIST(KetQuaID);
            if (dtTable != null && dtTable.Rows.Count > 0)
            {
                ddlLyDoBanAn.DataSource = dtTable;
                ddlLyDoBanAn.DataTextField = "TEN";
                ddlLyDoBanAn.DataValueField = "ID";
                ddlLyDoBanAn.DataBind();
            }
            ddlLyDoBanAn.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
           
            LoadDropQuanhephapluat();
        }
        protected void ddlKetQuaPhucTham_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadDropLyDoBanAn(); } catch (Exception ex) { lstErr.Text = ex.Message; }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                if (!CheckValid() || !CheckCongbo(DONID)) return;
                
                bool isNew = false;
                
                // XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault<XLHC_DON>();
                // if (oDon != null && oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                // {
                //     DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault<DM_TOAAN>();
                //     lstErr.Text = "Án đã được " + oTA.TEN + " nhận. Không thể cập nhật!";
                //     Cls_Comon.SetButton(cmdUpdate, false);
                //     return;
                // }
                
                XLHC_PHUCTHAM_BANAN oND = dt.XLHC_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault<XLHC_PHUCTHAM_BANAN>();
                if (oND == null)
                {
                    oND = new XLHC_PHUCTHAM_BANAN(); isNew = true;
                    if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
                    { oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); }
                }
                oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oND.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
                oND.SOBANAN = txtSobanan.Text;
                oND.NGAYMOPHIENTOA = (String.IsNullOrEmpty(txtNgaymophientoa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaymophientoa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYTUYENAN = (String.IsNullOrEmpty(txtNgaytuyenan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayhieuluc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayhieuluc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
              
                oND.KETQUAPHUCTHAMID = Convert.ToDecimal(ddlKetQuaPhucTham.SelectedValue);
                oND.LYDOBANANID = Convert.ToDecimal(ddlLyDoBanAn.SelectedValue);
                oND.TK_ISQUAHAN = rdVuAnQuaHan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVuAnQuaHan.SelectedValue);
                oND.TK_QUAHAN_CHUQUAN = rdNNChuQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNChuQuan.SelectedValue);
                oND.TK_QUAHAN_KHACHQUAN = rdNNKhachQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNKhachQuan.SelectedValue);

                if (isNew)
                {
                    oND.DONID = DONID;
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.XLHC_PHUCTHAM_BANAN.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();

                XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();

                if(oND.NGAYTUYENAN != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.BPXLHC)} " +
                                                                            $"  AND CAPXETXU = {3} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.BPXLHC);
                    temp_congbo.CAPXETXU = 3;
                    temp_congbo.ISBA = 1;
                    temp_congbo.BAQDID = oND.ID;
                    temp_congbo.NGAYHIEULUC = oND.NGAYTUYENAN;
                    temp_congbo.MAVUAN = oDon.MAVUVIEC;
                    temp_congbo.VUVIECID = oND.DONID.Value;

                    if (isnew)
                    {
                        temp_congbo.NGAYTAO = DateTime.Now;
                        temp_congbo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Insert(temp_congbo);
                    }
                    else if (temp_congbo != null && temp_congbo.TRANGTHAI != 2 && temp_congbo.TRANGTHAI != 3)
                    {
                        temp_congbo.NGAYSUA = DateTime.Now;
                        temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        DataExtensions.Update(temp_congbo);
                    }
                }    

                //Lưu file
                if (hddFilePath.Value != "")
                {
                    try
                    {
                        string strFilePath = "";
                        if (chkKySo.Checked)
                        {
                            string[] arr = hddFilePath.Value.Split('/');
                            strFilePath = arr[arr.Length - 1];
                            strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;

                            byte[] buff = null;
                            using (FileStream fs = File.OpenRead(strFilePath))
                            {
                                BinaryReader br = new BinaryReader(fs);
                                FileInfo oF = new FileInfo(strFilePath);

                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                XLHC_PHUCTHAM_BANAN_FILE oTF = new XLHC_PHUCTHAM_BANAN_FILE();
                                oTF.BANANID = DONID;
                                oTF.NOIDUNG = buff;
                                oTF.TENFILE = oF.Name;
                                oTF.KIEUFILE = oF.Extension;
                                oTF.NGAYTAO = DateTime.Now;
                                oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oTF.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                dt.XLHC_PHUCTHAM_BANAN_FILE.Add(oTF);
                                dt.SaveChanges();

                            }
                            File.Delete(strFilePath);
                        }

                    }
                    catch (Exception ex) { }
                }
                //End
                LoadBanAnInfo(DONID);
                lstErr.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lstErr.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoad.HasFile)
            {
                string strFileName = AsyncFileUpLoad.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoad.SaveAs(path);

                try
                {
                    decimal DONID = Convert.ToDecimal(hddID.Value);
                    string strFilePath = path;
                    byte[] buff = null;
                    using (FileStream fs = File.OpenRead(strFilePath))
                    {
                        BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        string strFN = oF.Name.ToLower();
                        if (dt.XLHC_PHUCTHAM_BANAN_FILE.Where(x => x.TENFILE.ToLower() == strFN).ToList().Count == 0)
                        {
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            XLHC_PHUCTHAM_BANAN_FILE oTF = new XLHC_PHUCTHAM_BANAN_FILE();
                            oTF.BANANID = DONID;
                            oTF.NOIDUNG = buff;
                            oTF.TENFILE = oF.Name;
                            oTF.KIEUFILE = oF.Extension;
                            oTF.NGAYTAO = DateTime.Now;
                            oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            oTF.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.XLHC_PHUCTHAM_BANAN_FILE.Add(oTF);
                            dt.SaveChanges();
                        }
                    }
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { lstErr.Text = ex.Message; }
            }
        }
        protected void dgFile_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lstErr.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    XLHC_PHUCTHAM_BANAN_FILE oT = dt.XLHC_PHUCTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    dt.XLHC_PHUCTHAM_BANAN_FILE.Remove(oT);
                    dt.SaveChanges();
                    LoadFile();
                    break;
                case "Download":
                    XLHC_PHUCTHAM_BANAN_FILE oND = dt.XLHC_PHUCTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;
            }

        }
        protected void rdVuAnQuaHan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdVuAnQuaHan.SelectedValue == "1")
                pnNguyenNhanQuaHan.Visible = true;
            else
                pnNguyenNhanQuaHan.Visible = false;
        }
        protected void cmdHuyBanAn_Click(object sender, EventArgs e)
        {
            // Xóa thông tin bản án
            decimal DonID = Session[ENUM_LOAIAN.BPXLHC] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            List<XLHC_PHUCTHAM_BANAN> banans = dt.XLHC_PHUCTHAM_BANAN.Where(x => x.DONID == DonID).ToList();
            if (banans.Count > 0)
            {
                dt.XLHC_PHUCTHAM_BANAN.RemoveRange(banans);
            }
            // Xóa thông tin file đính kèm
            List<XLHC_PHUCTHAM_BANAN_FILE> files = dt.XLHC_PHUCTHAM_BANAN_FILE.Where(x => x.BANANID == DonID).ToList();
            if (files.Count > 0)
            {
                dt.XLHC_PHUCTHAM_BANAN_FILE.RemoveRange(files);
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {DonID} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.BPXLHC)} " +
                                                                    $"  AND CAPXETXU = {3} ");

            BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
            if (temp_congbo != null)
            {
                temp_congbo.BAQDID = 0;
                temp_congbo.NGAYHIEULUC = null;
                temp_congbo.NGAYSUA = DateTime.Now;
                temp_congbo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Update(temp_congbo);
            }

            dt.SaveChanges();
            ResetControl();
            lstErr.Text = "Xóa thông tin thành công!";
        }
        private void ResetControl()
        {
            ddlQuanhephapluat.SelectedIndex = 0;
            ddlLoaiQuanhe.SelectedIndex = 0;
            txtSobanan.Text = "";
            txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgaytuyenan.Text = "";
            txtNgayhieuluc.Text = "";
            ddlKetQuaPhucTham.SelectedIndex = 0;
            ddlLyDoBanAn.SelectedIndex = 0;
            rdVuAnQuaHan.ClearSelection();
            rdNNChuQuan.ClearSelection();
            rdNNKhachQuan.ClearSelection();
            lstErr.Text = "";
            LoadFile();
        }

        protected void txtNgayquyetdinh_TextChanged(object sender, EventArgs e)
        {
            SetNewSoTB();
        }

        private void SetNewSoTB()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            //Số Thông báo mới
            DateTime ngayBA;
            if (!String.IsNullOrEmpty(txtNgaytuyenan.Text))
                ngayBA = DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayBA = DateTime.Now;

            String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "XLHC_PT", ngayBA).ToString();
            txtSobanan.Text = STTNew;

        }

        protected void dgFile_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                string toagiaiquyetID = e.Item.Cells[4].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                }
            }
        }
    }
}