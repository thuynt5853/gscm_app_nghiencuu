

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

namespace WEB.GSTP.QLAN.XLHC.Sotham
{
    public partial class BananSotham : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private static CultureInfo cul = new CultureInfo("vi-VN");
        bool isShowlydodinhchi = false;
        private const String MA_LOAI_QUYET_DINH = "BPXLHC";
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        public static bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch
            { return false; }
        }
        public static string GetTextDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return (Convert.ToDateTime(obj).ToString("dd/MM/yyyy", cul));
            }
            catch
            { return ""; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    rowLydodinhchi.Visible = false;
                    LoadComboboxLoaiQD();
                    LoadCombobox();
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    hddID.Value = current_id.ToString();
                    decimal ID = Convert.ToDecimal(current_id);
                    CheckQuyen(ID);
                    LoadBanAnInfo(ID);
                    XLHC_DON_THAMPHAN TpGQDon = dt.XLHC_DON_THAMPHAN.Where(x => x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM && x.DONID == ID).OrderByDescending(x => x.NGAYNHANPHANCONG).FirstOrDefault();
                    if (TpGQDon != null)
                    {
                        hddNgayPCTPGQD.Value = TpGQDon.NGAYNHANPHANCONG + "" == "" ? "" : ((DateTime)TpGQDon.NGAYNHANPHANCONG).ToString("dd/MM/yyyy");
                    }
                    if (txtNgaymophientoa.Text.Trim() == "")
                    {
                        txtNgaymophientoa.Text = txtNgaytuyenan.Text;
                    }
                    CheckCongbo(ID);
                    //check vụ án đã kết thúc không cho sửa xóa
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lstErr.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdHuyThongTin, false);

                    }
                }
            }
            catch (Exception ex)
            {
                lstErr.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }


        }
        bool CheckCongbo(decimal ID)
        {
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.BPXLHC} AND CAPXETXU = 2 AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyThongTin, false);
                lstErr.Text = "Đã có thông tin về công bố!";
                return false;
            }

            return true;
        }
        private void LoadComboboxLoaiQD()
        {
            ddlLoaiQD.DataSource = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISXLHC == 1).OrderBy(y => y.THUTU).ToList();
            ddlLoaiQD.DataTextField = "TEN";
            ddlLoaiQD.DataValueField = "ID";
            ddlLoaiQD.DataBind();
            ddlLoaiQD.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            LoadQD();
        }

        protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQD();
        }
        private void LoadQD()
        {
            //lay lay loai quyet dinh xu ly hanh chinh
            DM_QD_LOAI loaiQD = dt.DM_QD_LOAI
                .Where(x => x.MA == MA_LOAI_QUYET_DINH && x.HIEULUC == 1 && x.ISXLHC == 1)
                .FirstOrDefault();

            if (loaiQD != null)
            {
                //lay quyet dinh chua ket thuc
                ddlQuyetdinh.DataSource = dt.DM_QD_QUYETDINH
                    .Where(x => x.LOAIID == loaiQD.ID && x.ISXLHC == 1 && x.ISSOTHAM == 1 && x.KET_THUC == 1 && x.HIEULUC == 1)
                    .OrderBy(y => y.TEN).ToList();

                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }

            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            LoadLydo();
            LoadHTXX();
        }

        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal quyetdinhID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            checkShowLydoDinhchi(quyetdinhID);
        }

        void checkShowLydoDinhchi(decimal quyetdinhID)
        {
            var resultQuyetdinh = dt.DM_QD_QUYETDINH.Where(x => x.ID == quyetdinhID).ToList();
            var firstQuyetdinh = resultQuyetdinh.FirstOrDefault();
            if (firstQuyetdinh != null)
            {
                var isShowLydo = firstQuyetdinh.ISSHOWLYDODINHCHI;
                if (isShowLydo > 0)
                {
                    hddIsShowLydoDinhchi.Value = "1";
                    rowLydodinhchi.Visible = true;
                }
                else
                {
                    hddIsShowLydoDinhchi.Value = "0";
                    rowLydodinhchi.Visible = false;
                }
            }
        }
        private void LoadLydo()
        {

        }

        private void LoadHTXX()
        {

        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdHuyThongTin, oPer.CAPNHAT);
            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lstErr.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyThongTin, false);
                hddShowCommand.Value = "False";
                return;
            }
            //-----------------------
            List<XLHC_SOTHAM_THULY> lstCount = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
            if (lstCount.Count == 0)
            {
                lstErr.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyThongTin, false);
                hddShowCommand.Value = "False";
                return;
            }
            //--Kiểm tra đã phân công thẩm phán chủ tọa
            //List<XLHC_SOTHAM_HDXX> lstTPCT = dt.XLHC_SOTHAM_HDXX.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();

            List<XLHC_DON_THAMPHAN> lstTP = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == ID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();

            if (lstTP.Count == 0)
            {
                lstErr.Text = "Chưa cập nhật thông tin thẩm phán giải quyết !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyThongTin, false);
                hddShowCommand.Value = "False";
                return;
            }
            List<decimal> dmQDIds = dt.DM_QD_QUYETDINH.Where(x => x.ISSOTHAM == 1 && x.ISXLHC == 1 && x.KET_THUC == 1).Select(x => x.ID).ToList();
            List<XLHC_SOTHAM_BANAN> qdKetThuc = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == ID && dmQDIds.Contains(x.QUYETDINHID.Value)).ToList();
            if (qdKetThuc.Count != 0)
            {
                XLHC_SOTHAM_KHANGCAO kc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && x.GQ_TINHTRANG != 3).FirstOrDefault();
                if (kc != null)
                {
                    lstErr.Text = "Vụ việc đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdHuyThongTin, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                XLHC_SOTHAM_KHANGNGHI kn = dt.XLHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID).FirstOrDefault();
                if (kn != null)
                {
                    lstErr.Text = "Vụ việc đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdHuyThongTin, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }

            List<XLHC_SOTHAM_QUYETDINH> qd = dt.XLHC_SOTHAM_QUYETDINH.Where(x => x.DONID == ID).ToList();
            if (qd.Count == 0)
            {
                lstErr.Text = "Chưa cập nhật thông tin kết quả giải quyết !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyThongTin, false);
                hddShowCommand.Value = "False";
                return;
            }

            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lstErr.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdHuyThongTin, false);
                hddShowCommand.Value = "False";
                return;
            }
        }
        private void LoadFile()
        {
            decimal ID = Convert.ToDecimal(hddID.Value);
            List<XLHC_SOTHAM_BANAN_FILE> listFile = dt.XLHC_SOTHAM_BANAN_FILE.Where(x => x.DONID == ID).ToList();
            if (listFile.Count == 0)
                return;

            dgFile.DataSource = listFile;
            dgFile.DataBind();



            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            int ma_gd = (int)oT.MAGIAIDOAN;
            foreach (DataGridItem item in dgFile.Items)
            {
                LinkButton lbtXoa = (LinkButton)item.FindControl("lbtXoa");
                if (ma_gd == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || ma_gd == (int)ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    Cls_Comon.SetLinkButton(lbtXoa, false);
                }
                if (hddShowCommand.Value == "False")
                {
                    lbtXoa.Visible = false;
                }
            }
        }

        private void LoadBanAnInfo(decimal DonID)
        {
            List<XLHC_SOTHAM_BANAN> lst = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == DonID).ToList();
            if (lst.Count > 0)
            {
                XLHC_SOTHAM_BANAN oT = lst[0];
                //Loại quyết định
                ddlLoaiQD.SelectedValue = oT.LOAIQDID.ToString();
                //Mã quyết định và show lý do đình chỉ nếu có
                ddlQuyetdinh.SelectedValue = oT.QUYETDINHID.ToString();
                decimal quyetdinhID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                checkShowLydoDinhchi(quyetdinhID);

                txtSobanan.Text = oT.SOBANAN;
                hddBanAnID.Value = oT.ID.ToString();
                ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();
                if (oT.NGAYMOPHIENTOA != null)
                {
                    txtNgaymophientoa.Text = ((DateTime)oT.NGAYMOPHIENTOA).ToString("dd/MM/yyyy", cul);
                }
                else
                {
                    txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                }
                if (oT.NGAYTUYENAN != null) txtNgaytuyenan.Text = ((DateTime)oT.NGAYTUYENAN).ToString("dd/MM/yyyy", cul);
                if (oT.NGAYHIEULUC != null) txtNgayhieuluc.Text = ((DateTime)oT.NGAYHIEULUC).ToString("dd/MM/yyyy", cul);

                //Lý do đình chỉ
                if (oT.LYDODINHCHI != null) txtLydodinhchi.Text = oT.LYDODINHCHI;

                if (oT.ISCHAPNHAN != null) rdbChapnhanYC.SelectedValue = oT.ISCHAPNHAN.ToString();
                txtThoihan.Text = oT.THOIHANAPDUNG + "";
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
                    ddlQuanhephapluat.SelectedValue = oDon.QUANHEPHAPLUATID.ToString();
                }
                txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            }

        }
        private bool CheckValid()
        {
            if (ddlQuyetdinh.SelectedIndex == 0)
            {
                lstErr.Text = "Bạn chưa chọn kết quả giải quyết !";
                return false;
            }

            if (txtSobanan.Text.Trim() == "")
            {
                lstErr.Text = "Chưa nhập số quyết định";
                txtSobanan.Focus();
                return false;
            }
            DateTime NgayTPGQD = DateTime.MinValue, NgayMoPhienHop = DateTime.MinValue;
            if (hddNgayPCTPGQD.Value != "")
            {
                NgayTPGQD = DateTime.Parse(hddNgayPCTPGQD.Value, cul, DateTimeStyles.NoCurrentDateDefault);
            }
            if (txtNgaymophientoa.Text != "")
            {
                if (Cls_Comon.IsValidDate(txtNgaymophientoa.Text) == false)
                {
                    lstErr.Text = "Bạn phải nhập ngày mở phiên họp theo mẫu như sau: ngày / tháng / năm !";
                    txtNgaymophientoa.Focus();
                    return false;
                }
                NgayMoPhienHop = DateTime.Parse(txtNgaymophientoa.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgayMoPhienHop > DateTime.Now)
                {
                    lstErr.Text = "Ngày mở phiên họp không được lớn hơn ngày hiện tại !";
                    txtNgaymophientoa.Focus();
                    return false;
                }
                if (NgayTPGQD != DateTime.MinValue && NgayMoPhienHop < NgayTPGQD)
                {
                    lstErr.Text = "Ngày mở phiên họp không được nhỏ hơn ngày phân công thẩm phán giải quyết đơn " + hddNgayPCTPGQD.Value + ".";
                    txtNgaymophientoa.Focus();
                    return false;
                }
            }
            if (Cls_Comon.IsValidDate(txtNgaytuyenan.Text) == false)
            {
                lstErr.Text = "Bạn phải nhập ngày quyết định theo mẫu như sau: ngày / tháng / năm !";
                txtNgaytuyenan.Focus();
                return false;
            }

            DateTime dNgayQD = (String.IsNullOrEmpty(txtNgaytuyenan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayQD > DateTime.Now)
            {
                lstErr.Text = "Ngày quyết định không được lớn hơn ngày hiện tại !";
                txtNgaytuyenan.Focus();
                return false;
            }
            if (NgayTPGQD != DateTime.MinValue && dNgayQD < NgayTPGQD)
            {
                lstErr.Text = "Ngày quyết định không được nhỏ hơn ngày phân công thẩm phán giải quyết đơn " + hddNgayPCTPGQD.Value + ".";
                txtNgaytuyenan.Focus();
                return false;
            }
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]);
            List<XLHC_SOTHAM_THULY> lstGQD = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == DONID).OrderByDescending(y => y.NGAYTHULY).ToList();
            if (lstGQD.Count > 0)
            {
                XLHC_SOTHAM_THULY oDXL = lstGQD[0];
                if (dNgayQD < oDXL.NGAYTHULY)
                {
                    lstErr.Text = "Ngày quyết định không được trước ngày thụ lý '" + ((DateTime)oDXL.NGAYTHULY).ToString("dd/MM/yyyy") + "' !";
                    txtNgaytuyenan.Focus();
                    return false;
                }
            }
            if (NgayMoPhienHop != DateTime.MinValue && dNgayQD < NgayMoPhienHop)
            {
                lstErr.Text = "Ngày quyết định không được nhỏ hơn ngày mở phiên họp !";
                txtNgaytuyenan.Focus();
                return false;
            }
            if (txtNgayhieuluc.Text != "")
            {
                if (Cls_Comon.IsValidDate(txtNgayhieuluc.Text) == false)
                {
                    lstErr.Text = "Bạn phải nhập ngày hiệu lực theo mẫu như sau: ngày / tháng / năm !";
                    txtNgayhieuluc.Focus();
                    return false;
                }
                DateTime NgayHieuLuc = DateTime.Parse(txtNgayhieuluc.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgayHieuLuc < dNgayQD)
                {
                    lstErr.Text = "Ngày hiệu lực không được nhỏ hơn ngày quyết định !";
                    txtNgayhieuluc.Focus();
                    return false;
                }
            }

            //Validate Lý do
            if (hddIsShowLydoDinhchi.Value != "0")
            {
                if (txtLydodinhchi.Text.Trim() == "")
                {
                    lstErr.Text = "Bạn phải nhập lý do đình chỉ !";
                    txtLydodinhchi.Focus();
                    return false;
                }
            }
            if (ddlQuanhephapluat.Items.Count == 0)
            {
                lstErr.Text = "Chưa chọn biện pháp đề nghị áp dụng !";
                ddlQuanhephapluat.Focus();
                return false;
            }
            if (rdbChapnhanYC.SelectedValue == "1" && txtThoihan.Text == "")
            {
                lstErr.Text = "Chưa nhập thời hạn áp dụng !";
                txtThoihan.Focus();
                return false;
            }
            if (rdVuAnQuaHan.SelectedValue == "")
            {
                lstErr.Text = "Bạn chưa chọn vụ án quá hạn luật định?";
                return false;
            }
            if (rdVuAnQuaHan.SelectedValue == "1")
            {
                if (rdNNChuQuan.SelectedValue == "")
                {
                    lstErr.Text = "Bạn chưa chọn nguyên nhân chủ quan?";
                    return false;
                }
                if (rdNNKhachQuan.SelectedValue == "")
                {
                    lstErr.Text = "Bạn chưa chọn nguyên nhân khách quan?";
                    return false;
                }
            }

            //----------------------------
            string so = txtSobanan.Text;
            if (!String.IsNullOrEmpty(txtNgaytuyenan.Text))
            {
                DateTime ngayBA = DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoBATheoLoaiAn(DonViID, "XLHC", so, ngayBA);
                if (CheckID > 0)
                {
                    Decimal CurrBanAnId = (string.IsNullOrEmpty(hddBanAnID.Value)) ? 0 : Convert.ToDecimal(hddBanAnID.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "XLHC", ngayBA).ToString();
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
        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_DENGHI_XLHC);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();

        }
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {

            LoadCombobox();
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                if (!CheckValid() || !CheckCongbo(DONID)) return;

                List<XLHC_SOTHAM_BANAN> lst = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == DONID).ToList();
                XLHC_SOTHAM_BANAN oND;
                if (lst.Count == 0)
                    oND = new XLHC_SOTHAM_BANAN();
                else
                {
                    oND = lst[0];
                }
                oND.DONID = DONID;
                oND.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.LOAIQUANHE = 0;
                oND.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
                oND.SOBANAN = txtSobanan.Text;
                oND.NGAYMOPHIENTOA = (String.IsNullOrEmpty(txtNgaymophientoa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaymophientoa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYTUYENAN = (String.IsNullOrEmpty(txtNgaytuyenan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytuyenan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayhieuluc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayhieuluc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                // giao dien khong hien thi 300725
                //oND.ISCHAPNHAN = Convert.ToDecimal(rdbChapnhanYC.SelectedValue);
                oND.TK_ISQUAHAN = rdVuAnQuaHan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdVuAnQuaHan.SelectedValue);
                oND.TK_QUAHAN_CHUQUAN = rdNNChuQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNChuQuan.SelectedValue);
                oND.TK_QUAHAN_KHACHQUAN = rdNNKhachQuan.SelectedValue == "" ? 0 : Convert.ToDecimal(rdNNKhachQuan.SelectedValue);
                oND.THOIHANAPDUNG = (String.IsNullOrEmpty(txtThoihan.Text + "")) ? 0 : Convert.ToDecimal(txtThoihan.Text);

                //Update feature 3.3 Kết quả phiên họp
                oND.LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                oND.LYDODINHCHI = txtLydodinhchi.Text.Trim();
                //End: Update feature 3.3 Kết quả phiên họp

                if (lst.Count == 0)
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.XLHC_SOTHAM_BANAN.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }

                XLHC_DON oDon = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();

                if (oND.NGAYHIEULUC != null)
                {
                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {oND.DONID.Value} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.BPXLHC)} " +
                                                                            $"  AND CAPXETXU = {2} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.BPXLHC);
                    temp_congbo.CAPXETXU = 2;
                    temp_congbo.ISBA = 1;
                    temp_congbo.BAQDID = oND.ID;
                    temp_congbo.NGAYHIEULUC = oND.NGAYHIEULUC;
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
                                //string strFN = oF.Name.ToLower();
                                //if (dt.XLHC_PHUCTHAM_BANAN_FILE.Where(x => x.TENFILE.ToLower() == strFN).ToList().Count == 0)
                                //{
                                long numBytes = oF.Length;
                                buff = br.ReadBytes((int)numBytes);
                                XLHC_SOTHAM_BANAN_FILE oTF = new XLHC_SOTHAM_BANAN_FILE();
                                oTF.DONID = DONID;
                                oTF.NOIDUNG = buff;
                                oTF.TENFILE = oF.Name;
                                oTF.KIEUFILE = oF.Extension;
                                oTF.NGAYTAO = DateTime.Now;
                                oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oTF.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                dt.XLHC_SOTHAM_BANAN_FILE.Add(oTF);
                                dt.SaveChanges();
                                // }
                            }
                            File.Delete(strFilePath);
                        }

                    }
                    catch (Exception ex) { }
                }
                LoadFile();
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
                        if (dt.XLHC_SOTHAM_BANAN_FILE.Where(x => x.TENFILE.ToLower() == strFN).ToList().Count == 0)
                        {
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);

                            XLHC_SOTHAM_BANAN_FILE oTF = new XLHC_SOTHAM_BANAN_FILE();
                            oTF.DONID = DONID;
                            oTF.NOIDUNG = buff;
                            oTF.TENFILE = oF.Name;
                            oTF.KIEUFILE = oF.Extension;
                            oTF.NGAYTAO = DateTime.Now;
                            oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            oTF.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.XLHC_SOTHAM_BANAN_FILE.Add(oTF);
                            dt.SaveChanges();
                            LoadFile();
                        }
                    }
                    File.Delete(strFilePath);
                }
                catch (Exception ex) { lstErr.Text = ex.Message; }

                //path = path.Replace("\\", "/");
                //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
            }
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
            if (chkKySo.Checked == true)
            {
                zonekythuong.Style.Add("Display", "none");
                zonekyso.Style.Add("Display", "block");
            }
            else
            {
                zonekythuong.Style.Add("Display", "block");
                zonekyso.Style.Add("Display", "none");
            }
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
                XLHC_SOTHAM_BANAN_FILE oTF = new XLHC_SOTHAM_BANAN_FILE();

                byte[] buff = null;
                using (FileStream fs = File.OpenRead(file_path))
                {
                    BinaryReader br = new BinaryReader(fs);
                    FileInfo oF = new FileInfo(file_path);
                    long numBytes = oF.Length;
                    buff = br.ReadBytes((int)numBytes);
                    oTF.DONID = DONID;
                    oTF.NOIDUNG = buff;
                    oTF.TENFILE = Cls_Comon.ChuyenTenFileUpload(oF.Name);
                    oTF.KIEUFILE = oF.Extension;
                    oTF.NGAYTAO = DateTime.Now;
                    oTF.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.XLHC_SOTHAM_BANAN_FILE.Add(oTF);
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
                    decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lstErr.Text = Result;
                        return;
                    }
                    XLHC_SOTHAM_BANAN_FILE oT = dt.XLHC_SOTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    dt.XLHC_SOTHAM_BANAN_FILE.Remove(oT);
                    dt.SaveChanges();
                    LoadFile();
                    break;
                case "Download":
                    XLHC_SOTHAM_BANAN_FILE oND = dt.XLHC_SOTHAM_BANAN_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                    if (oND.TENFILE != "")
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    break;


            }

        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var row = (DAL.GSTP.XLHC_SOTHAM_BANAN_FILE)e.Item.DataItem;
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string toagiaiquyetIDDL = e.Item.Cells[4].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetIDDL != donviID)
                {
                    lbtXoa.Visible = false;
                }

            }
        }
        protected void rdVuAnQuaHan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdVuAnQuaHan.SelectedValue == "1")
                pnNguyenNhanQuaHan.Visible = true;
            else
                pnNguyenNhanQuaHan.Visible = false;
        }
        protected void rdbChapnhanYC_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbChapnhanYC.SelectedValue == "1")
            {
                div_ThoiGianApDung.Visible = true;
                txtThoihan.Visible = true;
                lblThoihanbb.Visible = true;
            }
            else
            {
                div_ThoiGianApDung.Visible = false;
                txtThoihan.Visible = false;
                lblThoihanbb.Visible = false;
            }
        }
        protected void cmdHuyThongTin_Click(object sender, EventArgs e)
        {
            // Xóa thông tin bản án
            decimal DonID = Session[ENUM_LOAIAN.BPXLHC] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            List<XLHC_SOTHAM_BANAN> banans = dt.XLHC_SOTHAM_BANAN.Where(x => x.DONID == DonID).ToList();
            if (banans.Count > 0)
            {
                dt.XLHC_SOTHAM_BANAN.RemoveRange(banans);
            }
            // Xóa thông tin file đính kèm
            List<XLHC_SOTHAM_BANAN_FILE> files = dt.XLHC_SOTHAM_BANAN_FILE.Where(x => x.DONID == DonID).ToList();
            if (files.Count > 0)
            {
                dt.XLHC_SOTHAM_BANAN_FILE.RemoveRange(files);
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {DonID} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.BPXLHC)} " +
                                                                    $"  AND CAPXETXU = {2} ");

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
            txtSobanan.Text = "";
            txtNgaymophientoa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgaytuyenan.Text = "";
            txtNgayhieuluc.Text = "";
            rdbChapnhanYC.ClearSelection();
            txtThoihan.Text = "";
            rdVuAnQuaHan.ClearSelection();
            rdNNChuQuan.ClearSelection();
            rdNNKhachQuan.ClearSelection();
            LoadFile();
        }

        protected void txtNgaytuyenan_TextChanged(object sender, EventArgs e)
        {
            if (txtNgaymophientoa.Text.Trim() == "")
            {
                txtNgaymophientoa.Text = txtNgaytuyenan.Text;
            }
        }
    }
}