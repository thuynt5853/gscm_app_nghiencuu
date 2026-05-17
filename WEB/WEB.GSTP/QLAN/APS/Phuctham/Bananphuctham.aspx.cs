using BL.GSTP;
using BL.GSTP.APS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.Danhmuc;
using BL.GSTP.QLAN;
using DAL.DKK;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.APS.Phuctham
{
    public partial class Bananphuctham : System.Web.UI.Page
    {
        DKKContextContainer dkk = new DKKContextContainer();
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal BANAN = 1, QUYETDINH = 2;
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

                    hddDonID.Value = Session[ENUM_LOAIAN.AN_PHASAN] + "" == "" ? "0" : Session[ENUM_LOAIAN.AN_PHASAN] + "";
                    if (hddDonID.Value == "0") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Hoso/Danhsach.aspx");
                    decimal DONID = Convert.ToDecimal(hddDonID.Value);

                    LoadDropQuanhephapluat();
                    LoadDropKetQuaPhucTham();
                    LoadDropLyDoBanAn();
                    LoadBanAnInfo(DONID);
                    LoadNguoiKyInfo();
                    LoadGrid();
                    CheckQuyen();
                    CheckCongbo(DONID);
                }
            }
            catch (Exception ex) { lstErr.Text = ex.Message; }
        }
        bool CheckCongbo(decimal ID)
        {
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN} AND CAPXETXU = 3 AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                lbthongbao.Text = lbthongbaoQD.Text = "Đã có thông tin về công bố!";
                return false;
            }

            return true;
        }
        void CheckQuyen()
        {
            decimal DONID = Convert.ToDecimal(hddDonID.Value);

            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            #region  Có quyết định ẩn bản án - HIEUVM
            List<APS_PHUCTHAM_QUYETDINH> lstQD = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DONID && (x.LOAIQDID == 10 || x.QUYETDINHID == 423 || x.QUYETDINHID == 422 || x.LOAIQDID == 3 || x.QUYETDINHID == 212 || x.QUYETDINHID == 213)).ToList();
            if (lstQD.Count >= 1)
            {
                pnQDVV.Visible = true;
                pnBAPT.Visible = false;
                rdbPanelQD.Enabled = false;
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                Cls_Comon.SetButton(btnUpdate, false);
            }
            else
            {
                rdbPanelQD.Enabled = true;
            }
            List<APS_PHUCTHAM_BANAN> lstBA = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).ToList();
            if (lstBA.Count >= 1)
            {
                pnBAPT.Visible = true;
                rdbPanelBA.Enabled = false;
                rdbPanelQD.Enabled = false;
                rdbPanelBA.SelectedValue = BANAN.ToString();
            }
            else
            {
                rdbPanelBA.Enabled = true;
            }
            #endregion

            //Kiểm tra thẩm phán giải quyết đơn             
            GetTrangThaiBanDauDONKK_USER_DKNHANVB(DONID);
            APS_DON oT = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
            List<APS_PHUCTHAM_THULY> lstCount = dt.APS_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
            if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            List<APS_DON_THAMPHAN> lstTP = dt.APS_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
            if (lstTP.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            List<APS_PHUCTHAM_HDXX> lstTPCT = dt.APS_PHUCTHAM_HDXX.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();
            if (lstTPCT.Count == 0)
            {
                lstErr.Text = lbthongbaoQD.Text = "Chưa phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            
            #region hieu nếu có tống đạt thì ko được xóa bản án sơ thẩm
            APS_TONGDAT td = dt.APS_TONGDAT.Where(x => x.DONID == DONID && (x.BIEUMAUID == 230 || x.BIEUMAUID == 261)).FirstOrDefault();
            if (td != null)
            {
                lstErr.Text = lbthongbaoQD.Text = "Vụ việc đã tống đạt không được xóa";
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                Cls_Comon.SetButton(btnUpdate, false);
            }
            #endregion

            APS_PHUCTHAM_QUYETDINH oQD = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DONID && x.LOAIQDID == 5
                                                                            && x.QUYETDINHID != 147 && x.QUYETDINHID != 148 /*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/
                                                                            ).FirstOrDefault();
            if (oQD == null)
            {
                lstErr.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
                Cls_Comon.SetButton(cmdUpdate, false);
            }

            if (rdbPanelQD.SelectedValue == "2" && ddlQuyetdinh.SelectedValue != "0")
            {
                Cls_Comon.SetButton(btnUpdate, true);
                hddShowCommand.Value = "True";
            }
        }
        protected void rdCongboBA_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        private void LoadFile()
        {
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            dgFile.CurrentPageIndex = 0;
            List<APS_PHUCTHAM_BANAN_FILE> lst = dt.APS_PHUCTHAM_BANAN_FILE.Where(x => x.BANANID == ID).ToList();
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
            APS_PHUCTHAM_BANAN oT = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault<APS_PHUCTHAM_BANAN>();
            if (oT != null)
            {
               
                pnDgFile.Visible = true;
                hddBanAnID.Value = oT.ID.ToString();
                ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
                //rdCongboBA.SelectedValue = (string.IsNullOrEmpty(oT.ISCONGBOBA + "")) ? "0" : oT.ISCONGBOBA.ToString();
                ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();
                txtSobanan.Text = oT.SOBANAN;
                txtNgaymophientoa.Text = string.IsNullOrEmpty(oT.NGAYMOPHIENTOA + "") ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)oT.NGAYMOPHIENTOA).ToString("dd/MM/yyyy", cul);
                txtNgaytuyenan.Text = string.IsNullOrEmpty(oT.NGAYTUYENAN + "") ? "" : ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                txtNgayhieuluc.Text = string.IsNullOrEmpty(oT.NGAYHIEULUC + "") ? "" : ((DateTime)oT.NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                ddlKetQuaPhucTham.SelectedValue = oT.KETQUAPHUCTHAMID.ToString();
                LoadDropLyDoBanAn();
                ddlLyDoBanAn.SelectedValue = oT.LYDOBANANID.ToString();
                rdVKSCoKN.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISVKSCOKN_KDCN + "")) ? "0" : oT.TK_ISVKSCOKN_KDCN.ToString();
                rdVKSRutKN.SelectedValue = (string.IsNullOrEmpty(oT.TK_ISVKSRUTKN_DSKR + "")) ? "0" : oT.TK_ISVKSRUTKN_DSKR.ToString();
                LoadFile();
            }
            else
            {
                pnDgFile.Visible = false;
                APS_DON oDon = dt.APS_DON.Where(x => x.ID == DonID).FirstOrDefault();
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
                lstErr.Text = "Chưa nhập ngày mở phiên họp hoặc không theo mẫu như sau: ngày/tháng/năm!";
                txtNgaymophientoa.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgaytuyenan.Text) == false)
            {
                lstErr.Text = "Chưa nhập ngày quyết định hoặc theo mẫu như sau: ngày/tháng/năm!";
                txtNgaytuyenan.Focus();
                return false;
            }
            if (txtNgayhieuluc.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgayhieuluc.Text) == false)
            {
                lstErr.Text = "Bạn phải nhập ngày hiệu lực theo mẫu như sau: ngày/tháng/năm!";
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
                Decimal CheckID = oSTBL.CheckSoBATheoLoaiAn(DonViID, "APS_PT", so, ngayBA);
                if (CheckID > 0)
                {
                    Decimal CurrBanAnId = (string.IsNullOrEmpty(hddBanAnID.Value)) ? 0 : Convert.ToDecimal(hddBanAnID.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "APS_PT", ngayBA).ToString();
                    if (CheckID != CurrBanAnId)
                    {
                        strMsg = "Số bản án " + txtSobanan.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSobanan.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSobanan.Focus();
                        return false;
                    }
                }
            }
            return true;
        }
        private void LoadDropQuanhephapluat()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAUPS);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();

            //Load QHPL Thống kê QD.
            ddlQHPLQDVV.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLQDVV.DataTextField = "CASE_NAME";
            ddlQHPLQDVV.DataValueField = "ID";
            ddlQHPLQDVV.DataBind();
            ddlQHPLQDVV.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
            //decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            ddlLoaiQD.DataSource = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISPHASAN == 1).OrderBy(y => y.THUTU).ToList();
            ddlLoaiQD.DataTextField = "TEN";
            ddlLoaiQD.DataValueField = "ID";
            ddlLoaiQD.DataBind();
            ddlLoaiQD.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

            LoadQD();
            LoadDuongSuYC();
        }
        private void LoadDropKetQuaPhucTham()
        {
            ddlKetQuaPhucTham.Items.Clear();
            ddlKetQuaPhucTham.DataSource = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISAPS == 1 && x.ISBANAN == 1).OrderBy(y => y.THUTU).ToList();
            ddlKetQuaPhucTham.DataTextField = "TEN";
            ddlKetQuaPhucTham.DataValueField = "ID";
            ddlKetQuaPhucTham.DataBind();
            ddlKetQuaPhucTham.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
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
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                if (!CheckValid() || !CheckCongbo(DONID)) return;

                APS_PHUCTHAM_BANAN_FILE oTF = new APS_PHUCTHAM_BANAN_FILE();
                bool isNew = false;
                APS_PHUCTHAM_BANAN oND = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault<APS_PHUCTHAM_BANAN>();
                if (oND == null)
                {
                    oND = new APS_PHUCTHAM_BANAN(); isNew = true;
                    if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
                    { oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]); }
                }
                oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oND.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
                oND.SOBANAN = txtSobanan.Text;
                oND.NGAYMOPHIENTOA = (String.IsNullOrEmpty(txtNgaymophientoa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaymophientoa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYTUYENAN = (String.IsNullOrEmpty(txtNgaytuyenan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayhieuluc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayhieuluc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oND.ISCONGBOBA = rdCongboBA.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongboBA.SelectedValue);

                oND.KETQUAPHUCTHAMID = Convert.ToDecimal(ddlKetQuaPhucTham.SelectedValue);
                oND.LYDOBANANID = Convert.ToDecimal(ddlLyDoBanAn.SelectedValue);
                oND.TK_ISVKSCOKN_KDCN = rdVKSCoKN.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVKSCoKN.SelectedValue);
                oND.TK_ISVKSRUTKN_DSKR = rdVKSRutKN.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVKSRutKN.SelectedValue);


                if (isNew)
                {
                    oND.DONID = DONID;
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.APS_PHUCTHAM_BANAN.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                TamNgungDONKK_USER_DKNHANVB(DONID);
                dt.SaveChanges();
                //Lưu file
                try
                {
                    if (hddFilePath.Value != "")
                    {
                        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                        #region Lưu file
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oTF.BANANID = DONID;
                            oTF.NOIDUNG = buff;
                            oTF.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                            oTF.KIEUFILE = oF.Extension;
                            oTF.NGAYTAO = DateTime.Now;
                            oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.APS_PHUCTHAM_BANAN_FILE.Add(oTF);
                            dt.SaveChanges();
                        }
                        #endregion
                        File.Delete(strFilePath);
                    }
                }
                catch { }

                APS_DON oDon = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();

                if(oND.NGAYTUYENAN != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)} " +
                                                                            $"  AND CAPXETXU = {3} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);
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

                //End
                LoadBanAnInfo(DONID);
                lstErr.Text = "Lưu thành công!";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch (Exception ex)
            {
                lstErr.Text = "Lỗi: " + ex.Message;
            }
        }

        private void GetTrangThaiBanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            APS_DON oDon = dt.APS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_PHASAN && s.TRANGTHAI == 1);
            if (obj != null)
            {

                ttBanDauDONKK_USER_DKNHANVB.Value = obj.TRANGTHAI.Value.ToString();
            }
        }
        private void SetTrangThaibanDauDONKK_USER_DKNHANVB(decimal DONID)
        {
            APS_DON oDon = dt.APS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_PHASAN && s.TRANGTHAI == 3);
            if (obj != null)
            {

                obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                dkk.SaveChanges();
            }
        }
        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID)
        {
            APS_DON oDon = dt.APS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_PHASAN && s.TRANGTHAI == 1);
            if (obj != null)
            {

                obj.TRANGTHAI = 3;
                dkk.SaveChanges();
            }
        }
        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoad.HasFile && dgFile.Items.Count < 1)
                {
                    string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
                    if (extension == ".doc" || extension == ".docx" || extension == ".pdf")
                    {
                        string strFileName = AsyncFileUpLoad.FileName;
                        string path = Server.MapPath("~/TempUpload/") + strFileName;
                        AsyncFileUpLoad.SaveAs(path);
                        path = path.Replace("\\", "/");
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
                    }
                    else lstErr.Text = "chỉ lưu file .doc";
                }
                else lstErr.Text = "Chỉ được chọn 1 file.";
            }
            catch (Exception ex) { lstErr.Text = "Lỗi: " + ex.Message; }
        }

        protected void cmdThemFileTL_Click(object sender, EventArgs e)
        {
            SaveFile_KySo();
            LoadFile();
        }
        protected void cmd_load_form_Click(object sender, EventArgs e)
        {
            LoadFile();
            Load_CheckBox();
        }
        protected void Load_CheckBox()
        {
            //if (chkKySo.Checked == true)
            //{
            //    zonekythuong.Style.Add("Display", "none");
            //    zonekyso.Style.Add("Display", "block");
            //}
            //else
            //{
            //    zonekythuong.Style.Add("Display", "block");
            //    zonekyso.Style.Add("Display", "none");
            //}
        }
        void SaveFile_KySo()
        {
            string folder_upload = "/TempUpload/";
            string file_kyso = hddFilePath.Value;
            if (!String.IsNullOrEmpty(hddFilePath.Value))
            {
                String[] arr = file_kyso.Split('/');
                string file_name = arr[arr.Length - 1] + "";

                String file_path = Path.Combine(Server.MapPath(folder_upload), file_name);
                decimal DONID = Convert.ToDecimal(hddID.Value);
                APS_PHUCTHAM_BANAN_FILE oTF = new APS_PHUCTHAM_BANAN_FILE();

                byte[] buff = null;
                using (FileStream fs = File.OpenRead(file_path))
                {
                    BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(file_path);
                    string strFN = oF.Name.ToLower();

                    long numBytes = oF.Length;
                    buff = br.ReadBytes((int)numBytes);
                    oTF.BANANID = DONID;
                    oTF.NOIDUNG = buff;
                    oTF.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                    oTF.KIEUFILE = oF.Extension;
                    oTF.NGAYTAO = DateTime.Now;
                    oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.APS_PHUCTHAM_BANAN_FILE.Add(oTF);
                    dt.SaveChanges();
                }
                //xoa file
                File.Delete(file_path);
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
                    APS_PHUCTHAM_BANAN_FILE oT = dt.APS_PHUCTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    dt.APS_PHUCTHAM_BANAN_FILE.Remove(oT);
                    dt.SaveChanges();
                    LoadFile();
                    break;
                case "Download":
                    APS_PHUCTHAM_BANAN_FILE oND = dt.APS_PHUCTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;
            }
        }
        protected void txtNgaymophientoa_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgaymophientoa.Text))
            {
                if (String.IsNullOrEmpty(txtNgaytuyenan.Text))
                {
                    txtNgaytuyenan.Text = txtNgaymophientoa.Text;
                }
                if (String.IsNullOrEmpty(txtNgayhieuluc.Text))
                {
                    txtNgayhieuluc.Text = txtNgaymophientoa.Text;
                }
            }
        }
        protected void cmdHuyBanAn_Click(object sender, EventArgs e)
        {
            decimal DONID = Session[ENUM_LOAIAN.AN_PHASAN] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");
            // Xóa thông tin bản án
            APS_PHUCTHAM_BANAN banan = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
            if (banan != null)
            {
                //Luu thong tin Bản án Phúc thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var json = new JavaScriptSerializer().Serialize(banan);
                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(DONID, 7, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Bản án Phúc thẩm án Phá sản", "Xóa", json) == false)
                {
                    return;
                }//Ket thuc
                 //Xoa Bản án Phúc thẩm
                dt.APS_PHUCTHAM_BANAN.Remove(banan);
            }
            // Xóa thông tin file đính kèm
            List<APS_PHUCTHAM_BANAN_FILE> files = dt.APS_PHUCTHAM_BANAN_FILE.Where(x => x.BANANID == DONID).ToList();
            if (files.Count > 0)
            {
                dt.APS_PHUCTHAM_BANAN_FILE.RemoveRange(files);
            }
            // Xóa thông tin người tham gia tố tụng
            List<APS_PHUCTHAM_BANAN_TGTT> tGTTs = dt.APS_PHUCTHAM_BANAN_TGTT.Where(x => x.DONID == DONID).ToList();
            if (tGTTs.Count > 0)
            {
                dt.APS_PHUCTHAM_BANAN_TGTT.RemoveRange(tGTTs);
            }

            /* 25.04.2025 Bổ sung Xóa AHN_FILE khi xóa Bản án
             * AHN_FILE phục vụ mục đích lưu trữ các file theo giai đoạn vụ việc/vụ án
             */
            // Xóa file tống đạt bản án
            decimal BieuMauID = 0;
            DM_BIEUMAU bm = dt.DM_BIEUMAU.Where(x => x.MABM == "75-DS").FirstOrDefault();
            if (bm != null)
            {
                BieuMauID = bm.ID;
            }

            APS_FILE file = dt.APS_FILE.Where(x => x.DONID == DONID && x.BIEUMAUID == BieuMauID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM).FirstOrDefault();
            if (file != null)
            {
                dt.APS_FILE.Remove(file);
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {DONID} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)} " +
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

            LoadBanAnInfo(DONID);
            SetTrangThaibanDauDONKK_USER_DKNHANVB(DONID);
            dt.SaveChanges();
            ResetControl();
            lstErr.Text = "Xóa quyết định thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        private void ResetControl()
        {
            decimal DONID = Convert.ToDecimal(hddID.Value);
            LoadBanAnInfo(DONID);
            ddlQuanhephapluat.SelectedIndex = 0;
            ddlLoaiQuanhe.SelectedIndex = 0;
            txtSobanan.Text = "";
            txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgaytuyenan.Text = "";
            txtNgayhieuluc.Text = "";
            ddlKetQuaPhucTham.SelectedIndex = 0;
            ddlLyDoBanAn.SelectedIndex = 0;
            rdVKSCoKN.ClearSelection();
            rdVKSRutKN.ClearSelection();
            if (pnKetquaPhuctham.Visible == true)
            {
                ddlKetquaQuyetdinh.SelectedIndex = 0;
                if (pnLyDoKetquaPhuctham.Visible == true)
                {
                    ddlLydoQuyetdinh.SelectedIndex = 0;
                }
            }
            lstErr.Text = "";
            LoadFile();
        }
        private bool CheckValidQDVV()
        {
            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn tên quyết định. Hãy chọn lại!";
                ddlQuyetdinh.Focus();
                return false;
            }

            if (rdCongBoQD.SelectedValue == "")
            {
                lbthongbao.Text = "Bạn chưa chọn có công bố quyết định. Hãy chọn lại!";
                rdCongBoQD.Focus();
                return false;
            }
            if (ddlQuyetdinh.SelectedItem.Text == "72-DS. Quyết định giải quyết việc đề nghị, kháng nghị đối với quyết định tạm đình chỉ (đình chỉ) giải quyết vụ án")
            {
                if (ddlKetquaQuyetdinh.SelectedValue == "0")
                {
                    lbthongbaoQD.Text = "Bạn chưa chọn kết quả phúc thẩm. Hãy chọn lại!";
                    ddlKetquaQuyetdinh.Focus();
                    return false;
                }
                if (ddlLydoQuyetdinh.SelectedValue == "0" && ddlKetquaQuyetdinh.SelectedValue != "101")
                {
                    lbthongbaoQD.Text = "Bạn chưa chọn lý do. Hãy chọn lại!";
                    ddlLydoQuyetdinh.Focus();
                    return false;
                }
            }

            if (pnQHPL.Visible)
            {
                if (ddlQHPLQDVV.SelectedValue == "0")
                {
                    lbthongbao.Text = "Bạn chưa chọn quan hệ pháp luật. Hãy chọn lại!";
                    ddlQHPLQDVV.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtHieuLucTuNgay.Text))
            {
                if (Cls_Comon.IsValidDate(txtHieuLucTuNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn chưa nhập hiệu lực từ ngày theo định dạng (dd/MM/yyyy) !";
                    txtHieuLucTuNgay.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtNgayQD.Text) && !String.IsNullOrEmpty(txtHieuLucTuNgay.Text))
            {
                DateTime tuNgay = DateTime.Parse(txtHieuLucTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                DateTime NgayQD = DateTime.Parse(txtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (tuNgay < NgayQD)
                {
                    lbthongbao.Text = "Hiệu lực từ ngày phải nhỏ hơn ngày quyết định !";
                    txtHieuLucTuNgay.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtHieuLucTuNgay.Text) && !String.IsNullOrEmpty(txtHieuLucDenNgay.Text))
            {
                if (txtHieuLucDenNgay.Text != "")
                {
                    DateTime tuNgay = DateTime.Parse(txtHieuLucTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                    DateTime denNgay = DateTime.Parse(txtHieuLucDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (tuNgay > denNgay)
                    {
                        lbthongbao.Text = "Hiệu lực từ ngày phải nhỏ hơn hiệu lực đến ngày !";
                        txtHieuLucDenNgay.Focus();
                        return false;
                    }
                }
            }

            if (String.IsNullOrEmpty(txtNgayMoPhienToaQD.Text))
            {
                lbthongbaoQD.Text = "Bạn chưa nhập ngày mở quyết định !";
                txtNgayMoPhienToaQD.Focus();
                return false;
            }
            else
            {
                if (Cls_Comon.IsValidDate(txtNgayMoPhienToaQD.Text) == false)
                {
                    lbthongbaoQD.Text = "Bạn chưa nhập ngày mở phiên toà theo định dạng (dd/MM/yyyy) !";
                    txtNgayMoPhienToaQD.Focus();
                    return false;
                }

                DateTime NgayQD = DateTime.Parse(txtNgayMoPhienToaQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                if (NgayQD > DateTime.Now)
                {
                    lbthongbaoQD.Text = "ngày mở phiên toà phải nhỏ hơn ngày hiện tại !";
                    txtNgayMoPhienToaQD.Focus();
                    return false;
                }
                if (hddNgayNhanPhanCong.Value != "")
                {
                    DateTime NgayNhanPC = DateTime.Parse(hddNgayNhanPhanCong.Value, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgayQD < NgayNhanPC)
                    {
                        lbthongbaoQD.Text = "ngày mở phiên toà phải lớn hơn ngày phân công thẩm phán giải quyết " + hddNgayNhanPhanCong.Value + " !";
                        txtNgayMoPhienToaQD.Focus();
                        return false;
                    }
                }
            }

            int lengthSQD = txtSoQD.Text.Trim().Length;
            if (lengthSQD == 0)
            {
                lbthongbaoQD.Text = "Bạn chưa nhập số quyết định!";
                txtSoQD.Focus();
                return false;
            }
            if (lengthSQD > 20)
            {
                lbthongbaoQD.Text = "Số quyết định không quá 20 ký tự. Hãy nhập lại!";
                txtSoQD.Focus();
                return false;
            }

            if (String.IsNullOrEmpty(txtNgayQD.Text))
            {
                lbthongbaoQD.Text = "Bạn chưa nhập ngày quyết định !";
                txtNgayQD.Focus();
                return false;
            }
            else
            {
                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbthongbaoQD.Text = "Bạn chưa nhập ngày quyết định theo định dạng (dd/MM/yyyy) !";
                    txtNgayQD.Focus();
                    return false;
                }

                DateTime NgayQD = DateTime.Parse(txtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                if (NgayQD > DateTime.Now)
                {
                    lbthongbaoQD.Text = "Ngày quyết định phải nhỏ hơn ngày hiện tại !";
                    txtNgayQD.Focus();
                    return false;
                }
            }

            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains(" đình chỉ"))
            {
                if (pnLyDo.Visible)
                {
                    if (ddlLydo.SelectedValue == "0")
                    {
                        lbthongbaoQD.Text = "Bạn chưa nhập Lý do!";
                        return false;
                    }
                }
                else if (txtLydo.Visible)
                {
                    if (String.IsNullOrEmpty(txtLydo.Text))
                    {
                        lbthongbaoQD.Text = "Bạn chưa nhập Lý do !";
                        return false;
                    }
                }
            }

            if (!String.IsNullOrEmpty(txtNgayQD.Text) && !String.IsNullOrEmpty(txtSoQD.Text))
            {
                string so = txtSoQD.Text;

                DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "APS", so, ngay, LoaiQD);
                if (CheckID > 0)
                {
                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "APS", ngay, LoaiQD).ToString();
                    Decimal CurrID = (string.IsNullOrEmpty(hddDonID.Value)) ? 0 : Convert.ToDecimal(hddDonID.Value);
                    if (CheckID != CurrID)
                    {
                        strMsg = "Số Quyết định " + txtSoQD.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoQD.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoQD.Focus();
                        return false;
                    }
                }
            }
            return true;
        }
        #region thông tin quyết định - HIEUVM
        //thông tin quyết định
        public void LoadGrid()
        {
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN] + "");
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PT(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN, ID);
            if (oDT != null)
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
        private void LoadDuongSuYC()
        {
            ddlNguoiYC.Items.Clear(); ddlNguoiBiYC.Items.Clear();
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            List<APS_DON_DUONGSU> lstDS = dt.APS_DON_DUONGSU.Where(x => x.DONID == DonID).OrderBy(x => x.TENDUONGSU).ToList<APS_DON_DUONGSU>();
            ddlNguoiYC.DataSource = ddlNguoiBiYC.DataSource = lstDS;
            ddlNguoiYC.DataTextField = ddlNguoiBiYC.DataTextField = "TENDUONGSU";
            ddlNguoiYC.DataValueField = ddlNguoiBiYC.DataValueField = "ID";
            ddlNguoiYC.DataBind(); ddlNguoiBiYC.DataBind();
            ddlNguoiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
            ddlNguoiBiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
        }
        private void LoadQD()
        {
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DM_QUYETDINH_VUAN_PHUCTHAM_KETTHUC(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN); 

            if (oDT != null)
            {
                ddlQuyetdinh.DataSource = oDT;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }

            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlQuyetdinh.SelectedIndex = 0;

            LoadLydo();

            decimal ID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            //Load ẩn hiện QHPL         
            if (ID > 0)
            {
                DM_QD_LOAI oQD = dt.DM_QD_LOAI.Where(x => x.ID == ID).FirstOrDefault();
                if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")
                {
                    pnQHPL.Visible = true;
                }
                else pnQHPL.Visible = false;
            }
        }
        private void LoadLydo()
        {
            if (ddlQuyetdinh.Items.Count > 0)
            {
                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                List<DM_QD_QUYETDINH_LYDO> lst = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == ID & x.HIEULUC == 1).OrderBy(y => y.THUTU).ToList();
                if (lst != null && lst.Count > 0)
                {
                    if (ddlQuyetdinh.Text == "1")
                    {
                        pnLyDo.Visible = false;
                        pntxtLydo.Visible = true;
                        lbtxtLydo.InnerText = "Lý do";
                    }
                    else
                    {
                        pnLyDo.Visible = true;
                        pntxtLydo.Visible = false;
                        lbtxtLydo.InnerText = "";
                    }

                    ddlLydo.Items.Clear();
                    foreach (DM_QD_QUYETDINH_LYDO item in lst)
                    {
                        ddlLydo.Items.Insert(0, new ListItem(item.TEN, item.ID.ToString()));
                    }

                    //ddlLydo.DataSource = lst;
                    //ddlLydo.DataTextField = "TEN";
                    //ddlLydo.DataValueField = "ID";
                    //ddlLydo.DataBind();
                    ddlLydo.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                }
                else
                {
                    pnLyDo.Visible = false;
                    pntxtLydo.Visible = false;
                }
            }
        }
        private void LoadNguoiKyInfo()
        {
            decimal DonID = Convert.ToDecimal(hddDonID.Value);
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            APS_PHUCTHAM_HDXX oND = dt.APS_PHUCTHAM_HDXX.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<APS_PHUCTHAM_HDXX>();
            if (oND != null)
            {
                decimal CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());

                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    txtNguoiKyTTVV.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                    txtChucvu.Text = dtCanBo.Rows[0]["ChucVu"].ToString();
                    hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
                }
            }
            else
            {
                APS_DON_THAMPHAN oTP = dt.APS_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).FirstOrDefault();
                if (oTP != null)
                {
                    decimal CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        txtNguoiKyTTVV.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                        txtChucvu.Text = dtCanBo.Rows[0]["ChucVu"].ToString();
                        hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
                    }
                }
                else
                    txtNguoiKyTTVV.Text = txtChucvu.Text = "";
            }
        }
        private void ResetControls()
        {
            txtLydo.Text = null;
            rdCongBoQD.ClearSelection();
            ddlLoaiQD.SelectedIndex = 0;
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            ddlQuyetdinh.SelectedIndex = 0;
            LoadDuongSuYC();
            txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSoQD.Text = txtHieuLucDenNgay.Text = hddFilePath.Value = lbthongbao.Text = "";
            hddDonID.Value = "0";
            //lbtDownload.Visible = false;
            //SetNewSoQD(DateTime.Now.Year);
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Decimal ID = Convert.ToDecimal(hddDonID.Value);
            List<APS_PHUCTHAM_QUYETDINH> lstQD = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID && (x.LOAIQDID == 10 || x.QUYETDINHID == 423 || x.QUYETDINHID == 422 || x.LOAIQDID == 3 )).ToList();
            if (lstQD.Count >= 1)
            {
                Cls_Comon.SetButton(btnUpdate, false);
            }
            ResetControls();
        }
        protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD();
            Cls_Comon.SetFocus(this, this.GetType(), ddlQuyetdinh.ClientID);
        }
        public void xoa(decimal id)
        {
            APS_PHUCTHAM_QUYETDINH oND = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.ID == id).FirstOrDefault();
            //if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
            //{
            //    lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép xóa !";
            //    return;
            //}
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                        $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)} " +
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

            if (oND != null)
            {
                decimal FileID = 0;
                if (oND.FILEID != null) FileID = (decimal)oND.FILEID;

                dt.APS_PHUCTHAM_QUYETDINH.Remove(oND);
                SetTrangThaibanDauDONKK_USER_DKNHANVB(oND.DONID.Value);
                dt.SaveChanges();
                if (FileID > 0)
                {
                    try
                    {
                        APS_FILE objf = dt.APS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                        dt.APS_FILE.Remove(objf);
                        dt.SaveChanges();
                    }
                    catch (Exception ex) { }
                }
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            return;
        }
        protected void rdbPanelBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (rdbPanelBA.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAPT.Visible = true; hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgaymophientoa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAPT.Visible = false; hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToaQD.ClientID);
            }
        }
        protected void rdbPanelQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (rdbPanelQD.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAPT.Visible = true; hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgaymophientoa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAPT.Visible = false; hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToaQD.ClientID);
            }
        }
        protected void rdCongboQD_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                if (!CheckValidQDVV() || !CheckCongbo(DONID)) return;

                APS_DON oDon = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                decimal FileID = 0;

                DateTime NgayQD;
                if (!String.IsNullOrEmpty(txtNgayQD.Text)) { NgayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault); }
                else
                {
                    DateTime? a = null;
                    NgayQD = Convert.ToDateTime(a);
                }
                APS_PHUCTHAM_QUYETDINH oND;
                decimal STTQD = 0;
                if ((hddID.Value == "" || hddID.Value == "0"))
                {
                    oND = new APS_PHUCTHAM_QUYETDINH();
                    APS_DON_BL oBL = new APS_DON_BL();

                    if (!String.IsNullOrEmpty(txtNgayQD.Text.Trim()))
                        STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, NgayQD.Year, 1);
                    else
                    {
                        Decimal? a = null;
                        STTQD = oBL.GETFILENEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_GIAIDOANVUAN.SOTHAM, Convert.ToDecimal(a), 1);
                    }
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    oND = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.TOAANID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                    {
                        lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép thay đổi !";
                        return;
                    }
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                }
                try
                {
                    if (hddFilePathQD.Value != "")
                    {
                        string strFilePath = hddFilePathQD.Value.Replace("/", "\\");
                        #region Lưu file
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oND.NOIDUNGFILE = buff;
                            oND.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                            oND.KIEUFILE = oF.Extension;
                        }
                        #endregion
                        File.Delete(strFilePath);
                    }
                }
                catch { }
                oND.SOQD = txtSoQD.Text.Trim();
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToaQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToaQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();

                oND.DONID = DONID;
                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                oND.QHPLTKID = Convert.ToDecimal(ddlQHPLQDVV.SelectedValue);

                set_valueLydo(oND);
                oND.ISCONGBOQD = rdCongBoQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongBoQD.SelectedValue);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieuLucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyID.Value);
                oND.CHUCVU = txtChucvu.Text;
                if (pnDuongSuYC.Visible)
                {
                    oND.NGUOIYEUCAUID = Convert.ToDecimal(ddlNguoiYC.SelectedValue);
                    oND.NGUOIBIYEUCAUID = Convert.ToDecimal(ddlNguoiBiYC.SelectedValue);
                    oND.GHICHU = txtNoiDungYC.Text.Trim();
                }
                else
                {
                    oND.NGUOIYEUCAUID = oND.NGUOIBIYEUCAUID = 0;
                    oND.NGUOIYEUCAUID = oND.NGUOIBIYEUCAUID = 0;
                    oND.GHICHU = "";
                }

                oND.LYDOKETQUAID = pnLyDoKetquaPhuctham.Visible == true ? Convert.ToDecimal(ddlLydoQuyetdinh.SelectedValue) : 0;
                oND.KETQUAID = pnKetquaPhuctham.Visible == true ? Convert.ToDecimal(ddlKetquaQuyetdinh.SelectedValue) : 0;

                decimal rFileID = 0;
                DM_QD_QUYETDINH oQDT = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).FirstOrDefault();
                rFileID = UploadFileID(oDon, FileID, oQDT.MA, STTQD);
                if (rFileID > 0) oND.FILEID = rFileID;
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.APS_PHUCTHAM_QUYETDINH.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }

                if (oQDT.ISCONGBO == 1 && oND.NGAYQD != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)} " +
                                                                            $"  AND CAPXETXU = {3} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);
                    temp_congbo.CAPXETXU = 3;
                    temp_congbo.ISBA = 0;
                    temp_congbo.BAQDID = oND.ID;
                    temp_congbo.NGAYHIEULUC = oND.NGAYQD;
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

                TamNgungDONKK_USER_DKNHANVB(DONID, ddlQuyetdinh.SelectedItem.Text);
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch (Exception ex)
            {
                lbthongbao.Text = lbthongbaoQD.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void AsyncFileUpLoad_UploadedCompleteQD(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoadQD.HasFile && dgFile.Items.Count < 1)
                {
                    string extension = Path.GetExtension(Request.Files[0].FileName).ToLower();
                    if (extension == ".doc" || extension == ".docx" || extension == ".pdf")
                    {
                        string strFileName = AsyncFileUpLoadQD.FileName;
                        string path = Server.MapPath("~/TempUpload/") + strFileName;
                        AsyncFileUpLoadQD.SaveAs(path);
                        path = path.Replace("\\", "/");
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePathQD.ClientID + "\").value = '" + path + "';", true);
                    }
                    else lbthongbao.Text = "chỉ lưu file .doc";
                }
                else lbthongbao.Text = "Chỉ được chọn 1 file.";
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        private decimal UploadFileID(APS_DON oDon, decimal FileID, string strMaBieumau, decimal STT)
        {
            APS_DON_BL oBL = new APS_DON_BL();
            decimal IDFIle = 0;
            decimal IDBM = 0;
            string strTenBM = "";
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
                strTenBM = lstBM[0].TENBM;
            }
            APS_FILE objFile = new APS_FILE();
            if (FileID > 0)
                objFile = dt.APS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            objFile.DONID = oDon.ID;
            objFile.TOAANID = oDon.TOAANID;
            objFile.MAGIAIDOAN = oDon.MAGIAIDOAN;
            objFile.LOAIFILE = 1;
            objFile.BIEUMAUID = IDBM;
            objFile.NAM = DateTime.Now.Year;
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
                    }
                    else
                        strFilePath = hddFilePath.Value.Replace("/", "\\");
                    byte[] buff = null;
                    using (FileStream fs = File.OpenRead(strFilePath))
                    {
                        BinaryReader br = new BinaryReader(fs);
                        FileInfo oF = new FileInfo(strFilePath);
                        long numBytes = oF.Length;
                        buff = br.ReadBytes((int)numBytes);
                        objFile.NOIDUNG = buff;
                        objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(strTenBM) + oF.Extension;
                        objFile.KIEUFILE = oF.Extension;
                    }
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { lbthongbao.Text = ex.Message; }
            }
            objFile.NGAYTAO = DateTime.Now;
            objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            if (STT != 0) objFile.STT = Convert.ToDecimal(STT);
            if (FileID == 0)
                dt.APS_FILE.Add(objFile);
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
        }
        private void TamNgungDONKK_USER_DKNHANVB(decimal DONID, string TenQuyetDinh)
        {
            APS_DON oDon = dt.APS_DON.FirstOrDefault(s => s.ID == DONID);
            DONKK_USER_DKNHANVB obj = dkk.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.MAVUVIEC == oDon.MAVUVIEC && s.VUVIECID == oDon.ID && s.MALOAIVUVIEC == ENUM_LOAIAN.AN_PHASAN && s.TRANGTHAI == 1);
            if (obj != null)
            {

                if (TenQuyetDinh.StartsWith("09-HC.") || TenQuyetDinh.StartsWith("45-DS.") || TenQuyetDinh.StartsWith("46-DS.") || TenQuyetDinh.StartsWith("38-DS.") || TenQuyetDinh.StartsWith("39-DS."))
                {
                    //chuyển trang trạng thái tạm dừng
                    obj.TRANGTHAI = 3;
                    dkk.SaveChanges();
                }
                else
                {
                    obj.TRANGTHAI = Convert.ToDecimal(ttBanDauDONKK_USER_DKNHANVB.Value);
                    dkk.SaveChanges();
                }
            }
        }
        public void loadedit(decimal ID)
        {
            APS_PHUCTHAM_QUYETDINH oND = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID && (x.LOAIQDID == 15 || x.LOAIQDID == 3 || x.LOAIQDID == 10 || x.QUYETDINHID == 422 || x.QUYETDINHID == 423 || x.QUYETDINHID == 212 || x.QUYETDINHID == 213)).FirstOrDefault();
            hddID.Value = oND.ID.ToString();
            decimal IDQD = Convert.ToDecimal(oND.QUYETDINHID);
            if (oND.LOAIQDID != null) ddlLoaiQD.SelectedValue = oND.LOAIQDID.ToString();
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            if (oND.QUYETDINHID != null) ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            decimal IDLoai = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            DM_QD_LOAI oQD = dt.DM_QD_LOAI.Where(x => x.ID == IDLoai).FirstOrDefault();
            if (oQD != null)
            {
                if (/*oQD.MA == "TDC" || */oND.LOAIQDID == 10 || oND.LOAIQDID == 11 || oND.LOAIQDID == 3)
                {
                    ddlQuyetdinh.Enabled = true;
                    Cls_Comon.SetButton(btnUpdate, true);
                }

                if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")
                {
                    pnQHPL.Visible = true;
                }
                else pnQHPL.Visible = false;
                if (oQD.ISDUONGSUYEUCAU == 1)
                {
                    pnDuongSuYC.Visible = true;
                }
                else
                {
                    pnDuongSuYC.Visible = false;
                }
            }
            else
            {
                pnQHPL.Visible = false;
                pnDuongSuYC.Visible = false;

            }

            LoadLydo();
            get_valueLydo(ID);


            if (ddlQuyetdinh.SelectedItem.Text.Contains("72-DS"))
            {
                if (oND.KETQUAID != 0 && oND.KETQUAID != null)
                {
                    pnKetquaPhuctham.Visible = true;
                    LoadDropKetQuaQuyetdinhPhuctham();
                    ddlKetquaQuyetdinh.SelectedValue = oND.KETQUAID.ToString();

                    LoadDropLyDoQuyetdinh();
                    if (oND.LYDOKETQUAID != 0 && oND.LYDOKETQUAID != null)
                    {
                        pnLyDoKetquaPhuctham.Visible = true;
                        ddlLydoQuyetdinh.SelectedValue = oND.LYDOKETQUAID.ToString();
                    }
                }
            }
            else
            {
                if (pnKetquaPhuctham.Visible == true)
                {
                    ddlKetquaQuyetdinh.SelectedIndex = 0;
                    if (pnLyDoKetquaPhuctham.Visible == true)
                    {
                        ddlLydoQuyetdinh.SelectedIndex = 0;
                    }
                }
                pnKetquaPhuctham.Visible = false;
                pnLyDoKetquaPhuctham.Visible = false;
            }
            if (oND.QHPLTKID != null) ddlQHPLQDVV.SelectedValue = oND.QHPLTKID.ToString();
            if (oND.ISCONGBOQD != null) rdCongBoQD.SelectedValue = oND.ISCONGBOQD.ToString();
            txtSoQD.Text = oND.SOQD;
            if (oND.NGAYQD != null) txtNgayQD.Text = ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);

            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
            if (oND.NGAYMOPT != null) txtNgayMoPhienToaQD.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);

            if (oND.HIEULUCTU != null) txtHieuLucTuNgay.Text = ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            if (oND.HIEULUCDEN != null) txtHieuLucDenNgay.Text = ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if (pnDuongSuYC.Visible)
            {
                ddlNguoiYC.SelectedValue = oND.NGUOIYEUCAUID.ToString();
                ddlNguoiYC_SelectedIndexChanged(new object(), new EventArgs());
                ddlNguoiBiYC.SelectedValue = oND.NGUOIBIYEUCAUID.ToString();
                txtNoiDungYC.Text = oND.GHICHU;
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            decimal ID = Convert.ToDecimal(hddDonID.Value);
            switch (e.CommandName)
            {
                case "Download":
                    var oND = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;
                case "Sua":
                    hddFilePathQD.Value = "";
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddID.Value = e.CommandArgument.ToString();
                    //hddDonID.Value = "";
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    //decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU] + "");
                    //string StrMsg = "Không được sửa đổi thông tin.";
                    //string Result = new ADS_CHUYEN_NHAN_AN_BL().Check_NhanAn(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    //if (Result != "")
                    //{
                    //    lbthongbao.Text = Result;
                    //    return;
                    //}
                    bool isCongbo = CheckCongbo(ID);
                    if (!isCongbo)
                    {
                        lbthongbao.Text = "Vụ việc đã có thông tin công bố. Không được xóa.";
                        return;
                    }
                    xoa(ND_id);
                    break;
            }
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
                decimal DONID = Convert.ToDecimal(hddDonID.Value);
                APS_PHUCTHAM_QUYETDINH oT = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.ID == DONID).FirstOrDefault();
                //if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                //{
                //    lblSua.Text = "Chi tiết";
                //    lbtXoa.Visible = false;
                //}

                //decimal vFILEID = Convert.ToDecimal(rowView["FILEID"]);
                //APS_FILE oF = dt.APS_FILE.Where(x => x.ID == vFILEID).FirstOrDefault();
                //if (oF != null)
                //{
                //    if (oF.TENFILE != null)
                //    {
                //        lblSua.Text = "Chi tiết";
                //        lbtXoa.Visible = false;
                //    }
                //}
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }
                //if (rowView["IsBanAnST"].ToString() != "0")
                //    lbtXoa.Visible = false;
                //if (hddShowCommand.Value == "False")
                //{
                //    lblSua.Text = "Chi tiết";
                //    lbtXoa.Visible = false;
                //}
            }
        }
        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();

            //Check quyết định sửa chữa, bổ sung bản án
            decimal IDD = Convert.ToDecimal(hddDonID.Value);

            CheckQuyen();

            if (btnUpdate.Enabled == true)
            {
                if (oT.LOAIID == 2 /*Chuyển vụ án*/ || oT.TEN.Contains("cho Thẩm phán") || oT.ID == 422 /*19-VDS. Quyết định đình chỉ việc xét đơn yêu cầu giải quyết việc dân sự*/
                    || oT.ID == 423 || oT.ID == 429)
                {
                    lbthongbaoQD.Text = "";
                    Cls_Comon.SetButton(btnUpdate, true);
                }
                else
                {
                    APS_PHUCTHAM_QUYETDINH oQD = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.DONID == IDD && x.LOAIQDID == 5 && x.QUYETDINHID != 147 && x.QUYETDINHID != 148 /*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/).FirstOrDefault();
                    if (oQD == null)
                    {
                        lbthongbaoQD.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
                        Cls_Comon.SetButton(btnUpdate, false);
                        return;
                    }
                }
            }

            if (oT != null)
            {
                hddThoiHanThang.Value = oT.THOIHAN_THANG == null ? "0" : oT.THOIHAN_THANG.ToString();
                hddThoiHanNgay.Value = oT.THOIHAN_NGAY == null ? "0" : oT.THOIHAN_NGAY.ToString();
                ddlLoaiQD.SelectedValue = oT.LOAIID + "";
                //Load ẩn hiện QHPL
                decimal IDLoai = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                DM_QD_LOAI oQD = dt.DM_QD_LOAI.Where(x => x.ID == IDLoai).FirstOrDefault();
                if (oQD != null)
                {
                    if (oQD.MA == "DC" || oQD.MA == "CNTT" || oQD.MA == "CVA")
                    {
                        pnQHPL.Visible = true;
                    }
                    else pnQHPL.Visible = false;
                    if (oQD.ISDUONGSUYEUCAU == 1)
                    {
                        pnDuongSuYC.Visible = true;
                    }
                    else
                    {
                        pnDuongSuYC.Visible = false;
                    }
                }
                else
                {
                    pnQHPL.Visible = false;
                    pnDuongSuYC.Visible = false;
                }
                //Load số quyêt định với các loại QD Dan Su sau
                if (ID == 62 || ID == 63 || ID == 67 || ID == 68 || ID == 41 || ID == 42 || ID == 45 || ID == 147 || ID == 4 || ID == 61)
                {
                    // lấy số mới nhất 
                    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DateTime ngayQD;
                    if (txtNgayQD.Text != "")
                        ngayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else
                        ngayQD = DateTime.Now;

                    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "APS", ngayQD, ID).ToString();
                    txtSoQD.Text = STTNew;
                }
            }
            LoadLydo();
            if(ddlQuyetdinh.SelectedItem.Text == "72-DS. Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ (đình chỉ) giải quyết vụ án")
            {
                pnKetquaPhuctham.Visible = true;
                LoadDropKetQuaQuyetdinhPhuctham();
            }
            else
            {
                pnKetquaPhuctham.Visible = false;
                pnLyDoKetquaPhuctham.Visible = false;
            }
        }
        protected void ddlNguoiYC_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlNguoiBiYC.Items.Clear();
            decimal DonID = Convert.ToDecimal(hddDonID.Value),
                NguoiYC = Convert.ToDecimal(ddlNguoiYC.SelectedValue);
            List<APS_DON_DUONGSU> lstDS = dt.APS_DON_DUONGSU.Where(x => x.DONID == DonID && x.ID != NguoiYC).OrderBy(x => x.TENDUONGSU).ToList<APS_DON_DUONGSU>();
            ddlNguoiBiYC.DataSource = lstDS;
            ddlNguoiBiYC.DataTextField = "TENDUONGSU";
            ddlNguoiBiYC.DataValueField = "ID";
            ddlNguoiBiYC.DataBind();
            ddlNguoiBiYC.Items.Insert(0, new ListItem("-- Chọn --", "0"));
            Cls_Comon.SetFocus(this, this.GetType(), ddlNguoiBiYC.ClientID);
        }


        protected void ddlLydo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlQuyetdinh.Text == "42" && ddlLydo.Text == "67")
            {
                pntxtLydo.Visible = true;
            }
            else if (ddlQuyetdinh.Text == "42" && ddlLydo.Text != "67")
            {
                pntxtLydo.Visible = false;
            }
            if (ddlQuyetdinh.Text == "45" && ddlLydo.Text == "74")
            {
                pntxtLydo.Visible = true;
            }
            else if (ddlQuyetdinh.Text == "45" && ddlLydo.Text != "74")
            {
                pntxtLydo.Visible = false;
            }
        }
        protected void set_valueLydo(APS_PHUCTHAM_QUYETDINH oND)
        {
            if (ddlQuyetdinh.SelectedValue == "42" && ddlLydo.SelectedValue == "67")
            {
                oND.QUYETDINHID = 42;
                oND.LYDOID = 67;
                //oND.LYDO_NAME = txtLydo.Text;
            }
            else if (ddlQuyetdinh.SelectedValue == "45" && ddlLydo.SelectedValue == "74")
            {
                oND.QUYETDINHID = 45;
                oND.LYDOID = 74;
                //oND.LYDO_NAME = txtLydo.Text;
            }
            else if (ddlQuyetdinh.SelectedValue == "1")
            {
                oND.QUYETDINHID = 1;
                //oND.LYDO_NAME = txtLydo.Text;
            }
            else if (pnLyDo.Visible)
            {
                oND.LYDOID = Convert.ToDecimal(ddlLydo.SelectedValue);
            }
        }
        protected void get_valueLydo(decimal ID)
        {
            APS_PHUCTHAM_QUYETDINH oND = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();

            if (oND.QUYETDINHID == 42 && oND.LYDOID == 67)
            {
                pntxtLydo.Visible = true;
                lbtxtLydo.InnerText = "";

                if (oND.LYDOID != null)
                {
                    ddlLydo.SelectedValue = oND.LYDOID.ToString();
                }

                //if (oND.LYDO_NAME != null)
                //{
                //    txtLydo.Text = oND.LYDO_NAME;
                //}
            }
            else if (oND.QUYETDINHID == 45 && oND.LYDOID == 74)
            {
                pntxtLydo.Visible = true;
                lbtxtLydo.InnerText = "";

                if (oND.LYDOID != null)
                {
                    ddlLydo.SelectedValue = oND.LYDOID.ToString();
                }

                //if (oND.LYDO_NAME != null)
                //{
                //    txtLydo.Text = oND.LYDO_NAME;
                //}
            }
            else if (oND.QUYETDINHID == 1)
            {
                lbtxtLydo.InnerText = "Lý do";
                pntxtLydo.Visible = true;

                //if (oND.LYDO_NAME != null)
                //{
                //    txtLydo.Text = oND.LYDO_NAME;
                //}
                if (oND.LYDOID != null)
                {
                    ddlLydo.SelectedValue = oND.LYDOID.ToString();
                    txtLydo.Text = ddlLydo.SelectedItem.Text;
                }
            }
            else if (oND.LYDOID != null && pnLyDo.Visible)
            {
                lbtxtLydo.InnerText = "";
                ddlLydo.SelectedValue = oND.LYDOID.ToString();
            }
        }


        #endregion

        #region Quyết định giải quyết việc đề nghị, kháng nghị đối với quyết định tạm đình chỉ (đình chỉ) giải quyết vụ án
        protected void ddlKetquaQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (ddlKetquaQuyetdinh.SelectedValue == "0" || ddlKetquaQuyetdinh.SelectedValue == "101")
                {
                    ddlLydoQuyetdinh.Items.Clear();
                    pnLyDoKetquaPhuctham.Visible = false;
                }
                else
                {
                    pnLyDoKetquaPhuctham.Visible = true;
                    LoadDropLyDoQuyetdinh();
                }
            }
            catch (Exception ex) { lstErr.Text = ex.Message; }
        }
        private void LoadDropKetQuaQuyetdinhPhuctham()
        {
            ddlKetquaQuyetdinh.Items.Clear();
            ddlKetquaQuyetdinh.DataSource = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISADS == 1 && x.ISQUYETDINH == 1).OrderBy(y => y.THUTU).ToList();
            ddlKetquaQuyetdinh.DataTextField = "TEN";
            ddlKetquaQuyetdinh.DataValueField = "ID";
            ddlKetquaQuyetdinh.DataBind();
            ddlKetquaQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadDropLyDoQuyetdinh()
        {
            ddlLydoQuyetdinh.Items.Clear();
            decimal KetQuaID = Convert.ToDecimal(ddlKetquaQuyetdinh.SelectedValue);
            DM_KETQUA_PHUCTHAM_LYDO_BL kqptLyDoBL = new DM_KETQUA_PHUCTHAM_LYDO_BL();
            DataTable dtTable = kqptLyDoBL.DM_KETQUA_PT_LYDO_GETLIST(KetQuaID);
            if (dtTable != null && dtTable.Rows.Count > 0)
            {
                ddlLydoQuyetdinh.DataSource = dtTable;
                ddlLydoQuyetdinh.DataTextField = "TEN";
                ddlLydoQuyetdinh.DataValueField = "ID";
                ddlLydoQuyetdinh.DataBind();
            }
            ddlLydoQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        #endregion

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
    }
}