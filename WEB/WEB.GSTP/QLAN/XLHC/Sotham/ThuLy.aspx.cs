using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace WEB.GSTP.QLAN.XLHC.Sotham
{
    public partial class ThuLy : System.Web.UI.Page
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
                    decimal ID = Convert.ToDecimal(current_id);

                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    // vnpt update 11082025: bo ham CheckShowCommand de dua noi dung vao ham CheckQuyen 
                    //CheckShowCommand(ID);
                    LoadCombobox();
                    CheckQuyen(ID);

                    InitDropdownLoaiThuLy(ID);

                    LoadGrid();
                    if (dgList.Items.Count == 0)
                    {
                        XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                        if (oT != null)
                        {
                            ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
                            ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();
                            LoadTHoiHan((decimal)oT.QUANHEPHAPLUATID);
                        }
                        //Số thụ lý mới
                        SetNewSoThuLy();
                        //Số thông báo mới
                        SetNewSoThongbao();
                    }
                    else
                    {
                        XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();
                        DataTable oDT = oBL.XLHC_SOTHAM_THULY_GETLIST_V2(ID);
                        if (oDT != null && oDT.Rows.Count > 0)
                            loadedit(Convert.ToDecimal(oDT.Rows[0]["ID"]));
                    }

                    //check vụ án đã kết thúc không cho sửa xóa
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);

                    }
                }
            }
            catch (Exception ex)
            { 
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
            

        }

        private void InitDropdownLoaiThuLy(decimal DONID)
        {
            XLHC_CHUYEN_NHAN_AN xCNA = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == DONID).FirstOrDefault();
            if (xCNA != null)
            {
                ddlLoaiThuLy.SelectedValue = "3";
            }
        }

        private void CheckQuyen(decimal DONID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);

            //Check xem vụ án đã được phân công thẩm phán giải quyết chưa
            //Check trong bang XLHC_DON_THAMPHAN voi vai tro la VTTP_GIAIQUYETSOTHAM
            XLHC_DON_THAMPHAN_BL oBL = new XLHC_DON_THAMPHAN_BL();
            DataTable oDT = oBL.XLHC_DON_THAMPHAN_GETBY(DONID, ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                lbthongbao.Text = "Vụ việc đã được phân công thẩm phán giải quyết. Không được sửa đổi.";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                //hddShowCommand.Value = "False";
                return;
            }

            XLHC_SOTHAM_KHANGCAO kc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == DONID && x.GQ_TINHTRANG == 1).FirstOrDefault();
            if (kc != null)
            {
                var kcChuaGiaiQuyet = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == DONID && x.ID > kc.ID && x.GQ_TINHTRANG != 2).ToList();
                if (kcChuaGiaiQuyet != null && kcChuaGiaiQuyet.Count > 0)
                {
                    lbthongbao.Text = "Vụ việc đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    //hddShowCommand.Value = "False";
                    return;
                }
                XLHC_SOTHAM_KHANGNGHI kn = dt.XLHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == DONID).FirstOrDefault();
                if (kn != null)
                {
                    lbthongbao.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    //hddShowCommand.Value = "False";
                    return;
                }
            }

            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                //hddShowCommand.Value = "False";
                return;
            }
            //vnpt update 11082025: dua noi dung ham CheckShowCommand vao ham CheckQuyen
            //Kiểm tra Đơn đã trả lại đơn chưa
            if (dt.XLHC_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 3).ToList().Count > 0)
            {
                lbthongbao.Text = "Đơn đã trả lại, không được phép thụ lý !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                //hddIsShowCommand.Value = "False";
                return;
            }
            if (dt.XLHC_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 5).ToList().Count == 0)
            {
                lbthongbao.Text = "Đơn chưa được giải quyết tại chức năng Giải quyết hồ sơ !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                //hddIsShowCommand.Value = "False";
                return;
            }
            XLHC_SOTHAM_BANAN ba = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
            if (ba != null)
            {
                lbthongbao.Text = "Đã có kết quả phiên họp. Không được sửa đổi!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                //hddIsShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                //hddShowCommand.Value = "False";
                return;
            }

        }

            private void SetNewSoThuLy()
        {
            if (hddid.Value == "0" || hddid.Value == "")
            {
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                //Số thụ lý mới
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();

                if (!String.IsNullOrEmpty(txtNgaythuly.Text))
                {
                    DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    txtSoThuly.Text = oSTBL.GET_STL_NEW(DonViID, "XLHC", ngaythuly).ToString();
                }
                else
                {
                    txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    txtSoThuly.Text = oSTBL.GET_STL_NEW(DonViID, "XLHC", ngaythuly).ToString();
                }
            }
        }
        private void CheckShowCommand(decimal DonID)
        {
            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (oT != null)
            {
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
            }
            //Kiểm tra Đơn đã trả lại đơn chưa
            if (dt.XLHC_DON_XULY.Where(x => x.DONID == DonID && x.LOAIGIAIQUYET == 3).ToList().Count > 0)
            {
                lbthongbao.Text = "Đơn đã trả lại, không được phép thụ lý !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
            if (dt.XLHC_DON_XULY.Where(x => x.DONID == DonID && x.LOAIGIAIQUYET == 5).ToList().Count == 0)
            {
                lbthongbao.Text = "Đơn chưa được giải quyết tại chức năng Giải quyết hồ sơ !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
            XLHC_SOTHAM_BANAN ba = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault();
            if (ba != null)
            {
                lbthongbao.Text = "Đã có kết quả phiên họp. Không được sửa đổi!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
        }
        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_DENGHI_XLHC);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
        }

        private void LoadTHoiHan(decimal QHID)
        {
            DM_DATAITEM oT = dt.DM_DATAITEM.Where(x => x.ID == QHID).FirstOrDefault();
            txtHanThang.Text = oT.SOTHANG == null ? "0" : oT.SOTHANG.ToString();
            txtHanNgay.Text = oT.SONGAY == null ? "0" : oT.SONGAY.ToString();
        }
        private void ResetControls()
        {
            // txtMaThuLy.Text = "";
            txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSoThuly.Text = this.getIncreasedSoThuLy(txtNgaythuly.Text).ToString();
            txtGhichu.Text = "";
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
            txtHanThang.Text = "";
            txtHanNgay.Text = "";
            txtNgaythongbao.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtSothongbao.Text = this.getIncreasedSoThongBao(txtNgaythongbao.Text).ToString();
            hddid.Value = "0";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }
        private bool CheckValid()
        {
            if (Cls_Comon.IsValidDate(txtNgaythuly.Text) == false)
            {
                lbthongbao.Text = "Ngày thụ lý chưa nhập hoặc không hợp lệ !";
                return false;
            }

            if (!Regex.IsMatch(txtSoThuly.Text, @"^\d"))
            {
                lbthongbao.Text = "Số thụ lý phải bắt đầu bằng ký tự số";
                return false;
            }

            if (txtSoThuly.Text == "")
            {
                lbthongbao.Text = "Chưa nhập số thụ lý";
                return false;
            }
            DateTime dNgayTL = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayTL > DateTime.Now)
            {
                lbthongbao.Text = "Ngày thụ lý không được lớn hơn ngày hiện tại !";
                txtNgaythuly.Focus();
                return false;
            }
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]);
            List<XLHC_DON_XULY> lstGQD = dt.XLHC_DON_XULY.Where(x => x.DONID == DONID && x.LOAIGIAIQUYET == 5).ToList();
            if (lstGQD.Count > 0)
            {
                XLHC_DON_XULY oDXL = lstGQD[0];
                if (dNgayTL < oDXL.NGAYGQ_YC)
                {
                    lbthongbao.Text = "Ngày thụ lý không được trước ngày giải quyết đơn '" + ((DateTime)oDXL.NGAYGQ_YC).ToString("dd/MM/yyyy") + "' !";
                    txtNgaythuly.Focus();
                    return false;
                }
            }

            if (Cls_Comon.IsValidDate(txtNgaythongbao.Text) == false)
            {
                lbthongbao.Text = "Ngày thông báo chưa nhập hoặc không hợp lệ !";
                return false;
            }

            if (txtSothongbao.Text == "")
            {
                lbthongbao.Text = "Chưa nhập số thông báo !";
                return false;
            }
            
            DateTime dNgayTB = (String.IsNullOrEmpty(txtNgaythongbao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayTB < dNgayTL)
            {
                lbthongbao.Text = "Ngày thông báo không được bé hơn ngày thụ lý !";
                txtNgaythongbao.Focus();
                return false;
            }

            //----------------------------
            string sothuly = txtSoThuly.Text;
            if (!String.IsNullOrEmpty(txtNgaythuly.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "XLHC", sothuly, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STL_NEW(DonViID, "XLHC", ngaythuly).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        //lbthongbao.Text = "Số thụ lý này đã có!";
                        strMsg = "Số thụ lý " + txtSoThuly.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoThuly.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoThuly.Focus();
                        return false;
                    }
                }
            }
            //So thong bao----------------------------
            string sothongbao = txtSothongbao.Text;
            if (!String.IsNullOrEmpty(txtNgaythuly.Text))
            {
                DateTime ngayThongBao = DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTBTLTheoLoaiAn_V2(DonViID, "XLHC", sothongbao, ngayThongBao);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STBTL_NEW_V2(DonViID, "XLHC", ngayThongBao).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        //lbthongbao.Text = "Số thụ lý này đã có!";
                        strMsg = "Số Thông báo thụ lý " + txtSothongbao.Text + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSothongbao.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSothongbao.Focus();
                        return false;
                    }
                }
            }
            
            return true;
        }

        private decimal getIncreasedSoThongBao(String ngaythongbaoStr)
        {
            DateTime ngaythongbao = DateTime.Parse(ngaythongbaoStr, cul, DateTimeStyles.NoCurrentDateDefault);
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            return oSTBL.GET_STBTL_NEW_V2(DonViID, "XLHC", ngaythongbao);
        }

        private decimal getIncreasedSoThuLy(String ngayThuLyStr)
        {
            DateTime ngayThuLy = DateTime.Parse(ngayThuLyStr, cul, DateTimeStyles.NoCurrentDateDefault);
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            return oSTBL.GET_STL_NEW(DonViID, "XLHC", ngayThuLy);
        }

        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            SetNewSoThuLy();
        }

        protected void txtNgaythongbao_TextChanged(object sender, EventArgs e)
        {
            SetNewSoThongbao();
        }

        void SetNewSoThongbao()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            //So thong bao
            if (String.IsNullOrEmpty(txtNgaythongbao.Text))
                txtNgaythongbao.Text = DateTime.Now.ToString("dd/MM/yyyy");
            DateTime ngaythongbao = DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            txtSothongbao.Text = oSTBL.GET_STBTL_NEW_V2(DonViID, "XLHC", ngaythongbao).ToString();
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_SOTHAM_BL oSTBL = new XLHC_SOTHAM_BL();
                XLHC_SOTHAM_THULY oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new XLHC_SOTHAM_THULY();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.XLHC_SOTHAM_THULY.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                //oND.MATHULY = "";
                oND.TRUONGHOPTHULY = Convert.ToDecimal(ddlLoaiThuLy.SelectedValue);

                oND.NGAYTHULY = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.SOTHULY = txtSoThuly.Text;
                oND.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oND.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);

                oND.THOIHANTUNGAY = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.THOIHANDENNGAY = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.GHICHU = txtGhichu.Text;

                oND.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.SOTHONGBAO = txtSothongbao.Text;

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oND.TT = oSTBL.THULY_GETNEWTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    oND.MATHULY = "S" + ENUM_LOAIVUVIEC.BPXLHC + Session[ENUM_SESSION.SESSION_MADONVI] + oND.TT.ToString();
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    XLHC_SOTHAM_THULY soThamThuLyExist = dt.XLHC_SOTHAM_THULY.FirstOrDefault(x => x.DONID == DONID && x.TOAANID == oND.TOAANID);
                    if (soThamThuLyExist != null)
                    {
                        lbthongbao.Text = "Đã có thông tin thụ lý. Không thể thêm mới!";
                        dgList.CurrentPageIndex = 0;
                        LoadGrid();
                        ResetControls();

                        return;
                    }
                    else
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.XLHC_SOTHAM_THULY.Add(oND);
                        dt.SaveChanges();
                        //Cập nhật lại trạng thái vụ việc
                        XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                        oDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        dt.SaveChanges();
                        //anhvh add 26/06/2020
                        GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                        // GD.GAIDOAN_INSERT_UPDATE("8", DONID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                        
                        GD.GAIDOAN_INSERT_UPDATE_V2("8", DONID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                    }
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
            XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.XLHC_SOTHAM_THULY_GETLIST_V2(ID);

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
            decimal DonID = 0;
            XLHC_SOTHAM_THULY oND = dt.XLHC_SOTHAM_THULY.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                DonID = oND.DONID + "" == "" ? 0 : (decimal)oND.DONID;
                #region Kiểm tra dữ liệu liên quan trước khi xóa
                // Kiểm tra kết quả phiên họp
                XLHC_SOTHAM_BANAN ba = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == DonID).FirstOrDefault<XLHC_SOTHAM_BANAN>();
                if (ba != null)
                {
                    lbthongbao.Text = "Vụ việc đã có kết quả phiên họp. Không được xóa.";
                    return;
                }
                // Kiểm tra quyết định  vụ việc
                XLHC_SOTHAM_QUYETDINH qd = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.DONID == DonID).FirstOrDefault<XLHC_SOTHAM_QUYETDINH>();
                if (qd != null)
                {
                    lbthongbao.Text = "Vụ việc đã có quyết định vụ việc. Không được xóa.";
                    return;
                }
                // Kiểm tra người tiến hành tố tụng
                XLHC_SOTHAM_HDXX hdxx = dt.XLHC_SOTHAM_HDXX.Where(x => x.DONID == DonID).FirstOrDefault<XLHC_SOTHAM_HDXX>();
                if (hdxx != null)
                {
                    lbthongbao.Text = "Vụ việc đã có thông tin người tiến hành tố tụng. Không được xóa.";
                    return;
                }
                // Kiểm tra phân công thẩm phán giải quyết
                XLHC_DON_THAMPHAN gqst = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault<XLHC_DON_THAMPHAN>();
                if (gqst != null)
                {
                    lbthongbao.Text = "Vụ việc đã có thông tin phân công thẩm phán giải quyết. Không được xóa.";
                    return;
                }
                #endregion
                // Chuyển giai đoạn của vụ án từ sơ thẩm về hồ sơ
                ADS_DON objDon = dt.ADS_DON.Where(x => x.ID == DonID).FirstOrDefault<ADS_DON>();
                //if (objDon != null)
                //{
                //    objDon.MAGIAIDOAN = ENUM_GIAIDOANVUAN.HOSO;
                //}
                dt.XLHC_SOTHAM_THULY.Remove(oND);
                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
            }
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            XLHC_SOTHAM_THULY oND = dt.XLHC_SOTHAM_THULY.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            //txtMaThuLy.Text = oND.MATHULY;
            ddlLoaiThuLy.SelectedValue = oND.TRUONGHOPTHULY.ToString();

            if (oND.NGAYTHULY != null) txtNgaythuly.Text = ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul);
            if (oND.SOTHULY != null) txtSoThuly.Text = oND.SOTHULY;

            if (oND.NGAYTHONGBAO != null) txtNgaythongbao.Text = ((DateTime)oND.NGAYTHONGBAO).ToString("dd/MM/yyyy", cul);
            if (oND.SOTHONGBAO != null) txtSothongbao.Text = oND.SOTHONGBAO;

            ddlLoaiQuanhe.SelectedValue = oND.LOAIQUANHE.ToString();
            ddlQuanhephapluat.SelectedValue = oND.QUANHEPHAPLUATID.ToString();

            if (oND.THOIHANTUNGAY != null) txtTuNgay.Text = ((DateTime)oND.THOIHANTUNGAY).ToString("dd/MM/yyyy", cul);
            if (oND.THOIHANDENNGAY != null) txtDenNgay.Text = ((DateTime)oND.THOIHANDENNGAY).ToString("dd/MM/yyyy", cul);
            txtGhichu.Text = oND.GHICHU;
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");

            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    CheckQuyen(DONID);
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    CheckQuyen(DONID);
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    xoa(ND_id);
                    break;
            }
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
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCombobox();
        }
        protected void ddlQuanhephapluat_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTHoiHan(Convert.ToDecimal(ddlQuanhephapluat.SelectedValue));
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
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (hddIsShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                string toagiaiquyetID = e.Item.Cells[8].Text.Trim();   // VNPT - Lê Bá Thọ check quyền sửa xóa thêm mới khi bàn qua tòa mới 19/09/2025 08:30
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
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