using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.DLQGC12;
using BL.GSTP.QLAN;
using DAL.DKK;
using DAL.GSTP;
using DevExpress.XtraBars.Alerter;
using Module.Common;
using NLog;
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
using WEB.GSTP.QLAN.AHS.PhucTham.BanAn;

namespace WEB.GSTP.QLAN.AHS.SoTham.BanAnST
{
    public partial class BanAnSoTham : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DKKContextContainer dkk = new DKKContextContainer();
        public Decimal DSID = 0;
        private const decimal BANAN = 1, QUYETDINH = 2;
        public string NgaySoSanh;
        public decimal VuAnID = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        private bool isFocus = false; // GTEL-DUCPH 22-09-2025 thêm isFocus để không focus vào txtNgayHieuLuc lần đầu load form
        private bool isDongbo = false; // đánh dấu bản án đã được đồng bộ
        private decimal IdKhoDongBo = 0; // Id kho đồng bộ

        protected void Page_Load(object sender, EventArgs e)
        {

            rdNNQuaHan.Visible = true;
            if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
            {
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                if (!IsPostBack)
                {
                    isFocus = true; // GTEL-DUCPH 22-09-2025 thêm isFocus để không focus vào txtNgayHieuLuc lần đầu load form
                    try
                    {
                        if (CheckChuaChonTDC())
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Bạn chưa cập nhật tội danh chính của bị can/bị cáo!');", true);
                        DSID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                        hddBanAnID.Value = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? "0" : Session[ENUM_LOAIAN.AN_HINHSU] + "";
                        if (hddBanAnID.Value == "0")
                            Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                        decimal VUANID = Convert.ToDecimal(hddBanAnID.Value);
                        hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                        LoadDropThuLy();

                        LoadDrop_Anle();
                        LoadNguoiKyTxtInfo();
                        LoadNguoiKyDdlInfo();
                        LoadThongTinBanAnSoTham();

                        //check bản án đồng bộ => không cho sửa, ngay sau khi load bản án
                        decimal IdBA = Convert.ToDecimal(string.IsNullOrEmpty(hddID.Value) ? "0" : hddID.Value);
                        var data = dt.KHOBAQDs.FirstOrDefault(x => x.STATUS == 1 && x.LINHVUC == "AHS" && x.IDBAQD == IdBA
                                            && x.CAPXX == 2 //cấp sơ thẩm
                                            && x.LOAIBAQD == 0 //bản án
                                            && x.TRANGTHAIBAQD != 5);// trạng thái đã thu hồi
                        //gán luôn để lấy điều kiện load thông tin bị cáo - án phí
                        if (data != null)
                        {
                            isDongbo = true;
                            IdKhoDongBo = data.ID;
                        }

                        LoadDsBiCao_AnPhi();
                        CheckQuyen(VUANID);
                        LoadQD();
                        LoadGrid();
                        CheckCongbo(VUANID);
                        LoadRdKhongBoSungDuoc();
                        LoadRdLuatSu();
                        LoadRdNguoiBaoChuaKhac();

                        //sau cùng sẽ disabled nút lưu
                        if (data != null)
                        {
                            Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                            Cls_Comon.SetButton(cmdHuyBanAn, false);
                            lttMsgBanAn.Text = lbThongBaoQD.Text = "Bản án đã được đồng bộ";
                        }
                        else
                        {
                            BL.GSTP.THA.THA_BIAN_BL objBL = new BL.GSTP.THA.THA_BIAN_BL();
                            if (objBL.CHECK_THA_BIAN_DONGBO_BY_VUANID(DSID))
                            {
                                lttMsgBanAn.Text = lbThongBaoQD.Text = "Bản án/Quyết định có bị cáo đã đồng bộ quyết định thi hành án. Không được thay đổi thông tin!";
                                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                                Cls_Comon.SetButton(cmdHuyBanAn, false);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        // ghi file log
                        lbThongBaoQD.Text = ENUM_MESSAGE.SERVER_ERROR;
                        logger.Error("loi xay ra: " + ex);
                    }
                    isFocus = false; // GTEL-DUCPH 22-09-2025 thêm isFocus để không focus vào txtNgayHieuLuc lần đầu load form
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        private void LoadDrop_Anle()
        {
            // GTEL-DUCPH  NC: 13-09-2025 thêm try/catch băt exception cho đi tiếp được
            try
            {
                CONGBO_BL TK_BL = new CONGBO_BL();
                DataTable tbl = TK_BL.DBLINK_GET_LIST_ANLE();
                ddlCBBA_Anle.DataSource = tbl;
                ddlCBBA_Anle.DataTextField = "SO_ANLE";
                ddlCBBA_Anle.DataValueField = "SO_ANLE";
                ddlCBBA_Anle.DataBind();
                ddlCBBA_Anle.Items.Insert(0, new ListItem("Không áp dụng án lệ", "0"));
            }
            catch (Exception ex)
            {
                // GTEL-DUCPH  NC: 13-09-2025 Fake rỗng
                DataTable tbl = new DataTable();
                tbl.Columns.Add("TEN", typeof(string));
                tbl.Columns.Add("SO_ANLE", typeof(string));
                ddlCBBA_Anle.DataSource = tbl;
                ddlCBBA_Anle.DataTextField = "SO_ANLE";
                ddlCBBA_Anle.DataValueField = "SO_ANLE";
                ddlCBBA_Anle.DataBind();
                ddlCBBA_Anle.Items.Insert(0, new ListItem("Không áp dụng án lệ", "0"));
            }
        }
        protected void rdbPanelQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            lbThongBaoQD.Text = "";
            if (rdbPanelQD.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAST.Visible = true;
                hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                CheckQuyen(VuAnID);
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAST.Visible = false;
                hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                Check_AnChuyenNhanQD(VuAnID);
                check_AnKCKN(VuAnID);
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToa.ClientID);
            }
        }

        private void ResetControl()
        {
            txtNgayMoPhienToa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtDiaDiem.Text = "";
            txtNgayBanAn.Text = "";
            txtSoBanAn.Text = "";
            ddlCBBA_Anle.SelectedValue = "0";
            //rdCongboBA.ClearSelection();
            rdAnRutGon.ClearSelection();
            rdBaoLucGD.ClearSelection();
            rdXetXuLuuDong.ClearSelection();
            txt_XXToiDanh_NangHon.Text = "";
            txt_XXToiDanh_NheHon.Text = "";
            txt_XXKhoan_NangHon.Text = "";
            txt_XXKhoan_NheHon.Text = "";
            txt_XXHinhPhat_NangHon.Text = "";
            txt_XXHinhPhat_NheHon.Text = "";
            txtTSChiemDoat.Text = "";
            txtTSThietHai.Text = "";
            //Tài sản thu hồi và bồi thường thiệt hại
            txtTSThuHoi.Text = "";
            txtBoiThuongTH.Text = "";

            rdPNTM_NhaNuoc.ClearSelection();
            rdPNTM_NuocNgoai.ClearSelection();
            rdViPhamHanTamGiam.ClearSelection();
            txtViPham_SoBiCao.Text = "";
            rdIsPhucHoi.ClearSelection();
            txtPhucHoi_SoBiCao.Text = "";
            rdKhoiTo.ClearSelection();
            txtKhoiTo_SoBiCao.Text = "";
            rdTraAn_VKSKoNhan.ClearSelection();
            rdViPham_CtacQuanLy.ClearSelection();
            rdToaAn_XacMinh.ClearSelection();
            rdToaAn_KoXacMinh.ClearSelection();
            rdToaAn_BSTaiLieu.ClearSelection();
            rdToaAnApDungBaoVe.ClearSelection();
            txtSoBiHai.Text = "";
            rdVuAnQuaHan.ClearSelection();
            rdNNQuaHan.ClearSelection();
            LoadDsBiCao_AnPhi();
            lbtDownload.Visible = false;
            lbtXoaFile.Visible = false;
            MSG_file.Text = string.Empty;
            hddID.Value = "0";

            //Thông tin quyết định
            ddlQuyetdinh.SelectedIndex = 0;
            txtNgayMoPhienToaQD.Text = "";
            txtDiaDiemQD.Text = "";
            ddlLydo.SelectedIndex = 0;
            pnLyDo.Visible = false;
            rdCongBoQD.SelectedValue = null;
            txtSoQD.Text = "";
            txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtHieulucTuNgay.Text = txtHieuLucDenNgay.Text = "";
            hddFilePathQD.Value = "";
        }
        bool CheckCongbo(decimal ID)
        {
            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {ID} AND LOAIANID = {ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU} AND CAPXETXU = 2 AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                pnAnPhi.Enabled = false;
                Cls_Comon.SetButton(btnUpdate, false);
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Đã có thông tin về công bố!";
                return false;
            }

            return true;
        }

        #region rdbBanan
        void CheckQuyen(decimal VuAnID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdateBanAnST, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdUpdateAnPhi, oPer.CAPNHAT);

            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lttMsgBanAn.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                pnAnPhi.Enabled = false;

                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            List<AHS_SOTHAM_THULY> lstTL = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList<AHS_SOTHAM_THULY>();

            decimal THULYID;
            if (lstTL.Count == 0)
            {
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Vụ việc chưa cập nhật thông tin thụ lý !";
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                pnAnPhi.Enabled = false;

                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            else
            {
                THULYID = lstTL[0].ID;


                DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
                DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID, THULYID);
                if (oDT.Rows.Count > 0)
                {
                    pnQDVV.Visible = true;
                    pnBAST.Visible = false;
                    //rdbPanelQD.Enabled = false;
                    rdbPanelQD.SelectedValue = QUYETDINH.ToString();

                    Cls_Comon.SetButton(btnUpdate, false);
                }
                else
                {
                    List<AHS_SOTHAM_QUYETDINH_VUAN> lstQDTHS = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && (x.QUYETDINHID == 221 || x.QUYETDINHID == 222) && x.THULYID == THULYID).ToList();
                    if (lstQDTHS.Count >= 1 && lstTL.Count <= 1)
                    {
                        pnQDVV.Visible = true;
                        pnBAST.Visible = false;
                        rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                        Cls_Comon.SetButton(btnUpdate, false);
                    }
                }

                List<AHS_SOTHAM_BANAN> lstBA;
                try
                {
                    lstBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID && x.THULYID == THULYID).ToList();
                }
                catch
                {
                    lstBA = null;
                }
                if (lstBA.Count >= 1)
                {
                    pnBAST.Visible = true;
                    rdbPanelBA.SelectedValue = BANAN.ToString();
                }
                else
                {

                }

                if (VuAnID == 0)
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");

                //Kiểm tra đã phân công thẩm phán giải quyết
                List<AHS_THAMPHANGIAIQUYET> lstTPGQ = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM" && x.THULYID == THULYID).ToList<AHS_THAMPHANGIAIQUYET>();
                if (lstTPGQ.Count == 0)
                {
                    lttMsgBanAn.Text = lbThongBaoQD.Text = "Vụ việc chưa cập nhật thông tin thẩm phán giải quyết !";
                    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                    Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                    Cls_Comon.SetButton(cmdHuyBanAn, false);
                    pnAnPhi.Enabled = false;

                    Cls_Comon.SetButton(btnUpdate, false);
                    return;
                }

                //Kiểm tra đã phân công thẩm phán chủ tọa
                List<AHS_SOTHAM_HDXX> lstTPCT = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN && x.THULYID == THULYID).ToList<AHS_SOTHAM_HDXX>();
                if (lstTPCT.Count == 0)
                {
                    lttMsgBanAn.Text = lbThongBaoQD.Text = "Vụ việc chưa cập nhật thông tin hội đồng xét xử !";
                    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                    Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                    Cls_Comon.SetButton(cmdHuyBanAn, false);
                    pnAnPhi.Enabled = false;

                    Cls_Comon.SetButton(btnUpdate, false);
                    return;
                }

                //Kiểm tra xem đã có quyết định đưa vụ việc ra xét xử hay không
                //List<AHS_SOTHAM_QUYETDINH_VUAN> lst = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && x.LOAIQDID == 5 && x.THULYID == THULYID).ToList();
                //if (lst == null || lst.Count == 0)
                //{
                //    lttMsgBanAn.Text = "Chưa cập nhật quyết định đưa vụ án ra xét xử !";
                //    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                //    Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                //    Cls_Comon.SetButton(cmdHuyBanAn, false);
                //}
            }

            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                pnAnPhi.Enabled = false;

                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }

            else if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.DINHCHI)
            {
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Vụ việc đã được đình chỉ, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                pnAnPhi.Enabled = false;

                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }
            //AnhPN - Sửa theo yc phòng 3 ngày 26/08/2025
            List<AHS_SOTHAM_QUYETDINH_VUAN> lstCaotrang = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID).ToList();
            if (lstCaotrang == null || lstCaotrang.Count == 0)
            {
                lttMsgBanAn.Text = "Quyết định vụ án chưa được cập nhật. ";
                lttMsgBanAn.Text += "Đề nghị cập nhật thông tin mục '3.3 Quyết định vụ án'!";
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                return;
            }

            AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            if (kc != null)
            {
                var kcChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2).ToList();
                if (kcChuaGiaiQuyet != null && kcChuaGiaiQuyet.Count > 0)
                {
                    lttMsgBanAn.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                    Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                    Cls_Comon.SetButton(cmdHuyBanAn, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            else
            {
                AHS_SOTHAM_KHANGCAO kc2 = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (kc2 != null)
                {
                    lttMsgBanAn.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                    Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                    Cls_Comon.SetButton(cmdHuyBanAn, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            if (kn != null)
            {
                var knChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3).ToList();
                if (knChuaGiaiQuyet != null && knChuaGiaiQuyet.Count > 0)
                {
                    lttMsgBanAn.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                    Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                    Cls_Comon.SetButton(cmdHuyBanAn, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            else
            {
                AHS_SOTHAM_KHANGNGHI kn2 = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (kn2 != null)
                {
                    lttMsgBanAn.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                    Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                    Cls_Comon.SetButton(cmdHuyBanAn, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lttMsgBanAn.Text = lbThongBaoQD.Text = Result;
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);

                Cls_Comon.SetButton(btnUpdate, false);
                return;
            }

            AHS_TONGDAT td = dt.AHS_TONGDAT.Where(x => x.VUANID == VuAnID && (x.BIEUMAUID == 290 || x.BIEUMAUID == 291)).FirstOrDefault();
            if (td != null)
            {
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Vụ án đã tống đạt không được xóa";
                Cls_Comon.SetButton(cmdHuyBanAn, false);

                Cls_Comon.SetButton(btnUpdate, false);
            }

            if (rdbPanelQD.SelectedValue == "2" && ddlQuyetdinh.SelectedValue != "0")
            {
                Cls_Comon.SetButton(btnUpdate, true);
                hddShowCommand.Value = "True";
            }

            if (oPer.CAPNHAT)
            {
                decimal IdBA = Convert.ToDecimal(string.IsNullOrEmpty(hddID.Value) ? "0" : hddID.Value);
                var data = dt.KHOBAQDs.FirstOrDefault(x => x.STATUS == 1 && x.LINHVUC == "AHS" && x.IDBAQD == IdBA
                                               && x.CAPXX == 2 //cấp sơ thẩm
                                               && x.LOAIBAQD == 0 //bản án
                                               && x.TRANGTHAIBAQD != 5);// trạng thái đã thu hồi
                if (data != null)
                {
                    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                    Cls_Comon.SetButton(cmdHuyBanAn, false);
                    lttMsgBanAn.Text = lbThongBaoQD.Text = "Bản án đã được đồng bộ";
                }
                else
                {
                    BL.GSTP.THA.THA_BIAN_BL objBL = new BL.GSTP.THA.THA_BIAN_BL();
                    decimal VuanID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

                    if (objBL.CHECK_THA_BIAN_DONGBO_BY_VUANID(VuanID))
                    {
                        lttMsgBanAn.Text = lbThongBaoQD.Text = "Bản án/Quyết định có bị cáo đã đồng bộ quyết định thi hành án. Không được thay đổi thông tin!";
                        Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                        Cls_Comon.SetButton(cmdHuyBanAn, false);
                    }
                }
            }
        }

        bool Check_AnChuyenNhanQD(Decimal VuAnID)
        {
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lttMsgQuyetDinh.Text = Result;
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return false;
            }
            else
                return true;
        }

        void check_AnKCKN(Decimal VuAnID)
        {
            AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
            if (kc != null)
            {
                var kcChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2).ToList();
                if (kcChuaGiaiQuyet != null && kcChuaGiaiQuyet.Count > 0)
                {
                    lttMsgQuyetDinh.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            else
            {
                AHS_SOTHAM_KHANGCAO kc2 = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (kc2 != null)
                {
                    lttMsgQuyetDinh.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            if (kn != null)
            {
                var knChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3).ToList();
                if (knChuaGiaiQuyet != null && knChuaGiaiQuyet.Count > 0)
                {
                    lttMsgQuyetDinh.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            else
            {
                AHS_SOTHAM_KHANGNGHI kn2 = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (kn2 != null)
                {
                    lttMsgQuyetDinh.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }

        }
        Boolean Check_Phancongthamphan(Decimal VuAnID)
        {
            try
            {
                /* Trong BanAn can check co ChuToaPhien toa, trong cac quyet dinh chi can check ThamphanGiaiQuyet*/
                //List<AHS_THAMPHANGIAIQUYET> lst = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID
                //                && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_CHUTOASOTHAM ).ToList<AHS_THAMPHANGIAIQUYET>();

                List<AHS_THAMPHANGIAIQUYET> lst = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList<AHS_THAMPHANGIAIQUYET>();
                if (lst != null && lst.Count > 0)
                    return true;
                else
                    return false;
            }
            catch { return false; }
        }
        private void LoadThongTinBanAnSoTham()
        {
            MSG_file.Text = string.Empty;
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            decimal ToaAnID = (Decimal)dt.AHS_VUAN.Where(x => x.ID == VuAnID).Single<AHS_VUAN>().TOAANID;
            hddToaAnID.Value = ToaAnID.ToString();

            try
            {
                DM_TOAAN objTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID && x.HIEULUC == 1).Single<DM_TOAAN>();
                txtToaAn.Text = objTA.TEN;
                txtDiaDiem.Text = objTA.DIACHI;
            }
            catch { }
            //-----------------------------------------------------------
            txtNgayBanAn.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);

            //-------------------------------------------
            int tucach_phapnhan_tm = 0;
            AHS_BICANBICAO oBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).FirstOrDefault();
            if (oBC != null)
            {
                tucach_phapnhan_tm = (int)oBC.LOAIDOITUONG;
                hddTuCachPN.Value = tucach_phapnhan_tm.ToString();
            }
            AHS_SOTHAM_BANAN obj = null;
            try
            {
                obj = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).SingleOrDefault();
                if (obj != null)
                {
                    // check quyền để hiển thị nút xoá
                    //string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                    //if (obj.TOA_GIAIQUYET_ID.ToString() != donviID)
                    //{
                    //    cmdUpdateAnPhi.Enabled = false;
                    //}

                    hddID.Value = obj.ID.ToString();
                    //LoadDsBiCao_AnPhi();
                    hddID.Value = obj.ID + "";

                    rdAnRutGon.SelectedValue = (string.IsNullOrEmpty(obj.ISANRUTGON + "")) ? "0" : obj.ISANRUTGON.ToString();
                    rdBaoLucGD.SelectedValue = (string.IsNullOrEmpty(obj.ISBAOLUCGIADINH + "")) ? "0" : obj.ISBAOLUCGIADINH.ToString();
                    rdXetXuLuuDong.SelectedValue = (string.IsNullOrEmpty(obj.ISXXLUUDONG + "")) ? "0" : obj.ISXXLUUDONG.ToString();

                    if ((obj.ISANLE == null || obj.ISANLE == 1) && obj.SOANLE == null)
                    {
                        ddlCBBA_Anle.Items.Insert(ddlCBBA_Anle.Items.Count, new ListItem("Hãy chọn số án lệ", "-1"));
                        ddlCBBA_Anle.SelectedValue = "-1";
                    }
                    else
                    {
                        ddlCBBA_Anle.SelectedValue = string.IsNullOrEmpty(obj.SOANLE + "") ? "0" : obj.SOANLE;
                    }

                    //rdCongboBA.SelectedValue = (string.IsNullOrEmpty(obj.ISCONGBOBA + "")) ? "0" : obj.ISCONGBOBA.ToString();
                    //-----------------------------
                    txtNgayBanAn.Text = ((DateTime)obj.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    txtSoBanAn.Text = obj.SOBANAN + "";

                    txtNgayMoPhienToa.Text = obj.NGAYMOPHIENTOA + "" == "" ? DateTime.Now.ToString("dd/MM/yyyy", cul) : ((DateTime)obj.NGAYMOPHIENTOA).ToString("dd/MM/yyyy", cul);
                    txtDiaDiem.Text = obj.DIADIEM + "";

                    //---------------------------------------
                    string temp = ((!string.IsNullOrEmpty(obj.TK_XXKHACVKS_TOIDANH_NANGHON + "")) && obj.TK_XXKHACVKS_TOIDANH_NANGHON > 0) ? obj.TK_XXKHACVKS_TOIDANH_NANGHON.ToString() : "";
                    txt_XXToiDanh_NangHon.Text = temp;
                    temp = ((!string.IsNullOrEmpty(obj.TK_XXKHACVKS_TOIDANH_NHEHON + "")) && obj.TK_XXKHACVKS_TOIDANH_NHEHON > 0) ? obj.TK_XXKHACVKS_TOIDANH_NHEHON.ToString() : "";
                    txt_XXToiDanh_NheHon.Text = temp;

                    temp = ((!string.IsNullOrEmpty(obj.TK_XXKHACVKS_KHOAN_NANGHON + "")) && obj.TK_XXKHACVKS_KHOAN_NANGHON > 0) ? obj.TK_XXKHACVKS_KHOAN_NANGHON.ToString() : "";
                    txt_XXKhoan_NangHon.Text = temp;
                    temp = ((!string.IsNullOrEmpty(obj.TK_XXKHACVKS_KHOAN_NHEHON + "")) && obj.TK_XXKHACVKS_KHOAN_NHEHON > 0) ? obj.TK_XXKHACVKS_KHOAN_NHEHON.ToString() : "";
                    txt_XXKhoan_NheHon.Text = temp;

                    temp = ((!string.IsNullOrEmpty(obj.TK_XXKHACVKS_HINHPHAT_NANGHON + "")) && obj.TK_XXKHACVKS_HINHPHAT_NANGHON > 0) ? obj.TK_XXKHACVKS_HINHPHAT_NANGHON.ToString() : "";
                    txt_XXHinhPhat_NangHon.Text = temp;
                    temp = ((!string.IsNullOrEmpty(obj.TK_XXKHACVKS_HINHPHAT_NHEHON + "")) && obj.TK_XXKHACVKS_HINHPHAT_NHEHON > 0) ? obj.TK_XXKHACVKS_HINHPHAT_NHEHON.ToString() : "";
                    txt_XXHinhPhat_NheHon.Text = temp;

                    //---------------------------------------
                    txtTSChiemDoat.Text = ((!string.IsNullOrEmpty(obj.TK_TSCHIEMDOAT + "")) && obj.TK_TSCHIEMDOAT > 0) ? obj.TK_TSCHIEMDOAT.ToString() : "";
                    txtTSThietHai.Text = ((!string.IsNullOrEmpty(obj.TK_TSTHIETHAI + "")) && obj.TK_TSTHIETHAI > 0) ? obj.TK_TSTHIETHAI.ToString() : "";

                    //Tài sản thu hồi và bồi thường thiệt hại
                    txtTSThuHoi.Text = ((!string.IsNullOrEmpty(obj.TK_TSTHUHOI + "")) && obj.TK_TSTHUHOI > 0) ? obj.TK_TSTHUHOI.ToString() : "";
                    txtBoiThuongTH.Text = ((!string.IsNullOrEmpty(obj.TK_BOITHUONGTH + "")) && obj.TK_BOITHUONGTH > 0) ? obj.TK_BOITHUONGTH.ToString() : "";

                    //---------------------------------------
                    if (tucach_phapnhan_tm == 0)
                        row_tucach_phapnhan_tm.Visible = true;
                    else
                        row_tucach_phapnhan_tm.Visible = false;
                    rdPNTM_NuocNgoai.SelectedValue = (string.IsNullOrEmpty(obj.TK_PNTM_NUOCNGOAI + "")) ? "0" : obj.TK_PNTM_NUOCNGOAI.ToString();
                    rdPNTM_NhaNuoc.SelectedValue = (string.IsNullOrEmpty(obj.TK_PNTM_NHANUOC + "")) ? "0" : obj.TK_PNTM_NHANUOC.ToString();
                    //---------------------------------------
                    rdToaAnApDungBaoVe.SelectedValue = (string.IsNullOrEmpty(obj.TK_APDUNGBAOVE + "")) ? "0" : obj.TK_APDUNGBAOVE.ToString();
                    txtSoBiHai.Text = ((!string.IsNullOrEmpty(obj.TK_APDUNGBAOVE_BIHAI + "")) && obj.TK_APDUNGBAOVE_BIHAI > 0) ? obj.TK_APDUNGBAOVE_BIHAI.ToString() : "";
                    //---------------------------------------
                    rdViPhamHanTamGiam.SelectedValue = (string.IsNullOrEmpty(obj.TK_ISVIPHAMHANTAMGIAM + "")) ? "0" : obj.TK_ISVIPHAMHANTAMGIAM.ToString();
                    txtViPham_SoBiCao.Text = ((!string.IsNullOrEmpty(obj.TK_VIPHAMTG_BICAO + "")) && obj.TK_VIPHAMTG_BICAO > 0) ? obj.TK_VIPHAMTG_BICAO.ToString() : "";

                    rdIsPhucHoi.SelectedValue = (string.IsNullOrEmpty(obj.TK_PHUCHOIAN_VUAN + "")) ? "0" : obj.TK_PHUCHOIAN_VUAN.ToString();
                    txtPhucHoi_SoBiCao.Text = ((!string.IsNullOrEmpty(obj.TK_PHUCHOIAN_BICAO + "")) && obj.TK_PHUCHOIAN_BICAO > 0) ? obj.TK_PHUCHOIAN_BICAO.ToString() : "";

                    rdKhoiTo.SelectedValue = (string.IsNullOrEmpty(obj.TK_KHOITO_VUAN + "")) ? "0" : obj.TK_KHOITO_VUAN.ToString();
                    txtKhoiTo_SoBiCao.Text = ((!string.IsNullOrEmpty(obj.TK_KHOITO_BICAO + "")) && obj.TK_KHOITO_BICAO > 0) ? obj.TK_KHOITO_BICAO.ToString() : "";

                    //---------------------------------------
                    rdToaAn_XacMinh.SelectedValue = (string.IsNullOrEmpty(obj.TK_TOAAN_SOVUXM + "")) ? "0" : obj.TK_TOAAN_SOVUXM.ToString();
                    rdToaAn_KoXacMinh.SelectedValue = (string.IsNullOrEmpty(obj.TK_TOAAN_KOXM + "")) ? "0" : obj.TK_TOAAN_KOXM.ToString();

                    //---------------------------------------
                    rdXuLyVatChung.SelectedValue = string.IsNullOrEmpty(obj.TK_XULYVATCHUNG + "") ? "0" : obj.TK_XULYVATCHUNG.ToString();
                    txtSoBiCao.Text = obj.TK_XULYVATCHUNG_SBC.ToString();

                    rdViPham_CtacQuanLy.SelectedValue = (string.IsNullOrEmpty(obj.TK_VIPHAMCONGTACQL + "")) ? "0" : obj.TK_VIPHAMCONGTACQL.ToString();
                    rdTraAn_VKSKoNhan.SelectedValue = (string.IsNullOrEmpty(obj.TK_ISTRAHS_VKSKHONGNHAN + "")) ? "0" : obj.TK_ISTRAHS_VKSKHONGNHAN.ToString();

                    if ((!string.IsNullOrEmpty(obj.TK_QUAHAN_CHUQUAN)) || (!String.IsNullOrEmpty(obj.TK_QUAHAN_KHACHQUAN)))
                    {
                        if (obj.TK_QUAHAN_CHUQUAN == "1")
                        {
                            rdVuAnQuaHan.SelectedValue = "1";
                            pnNNQuanHan.Visible = true;
                            rdNNQuaHan.SelectedIndex = 0;
                        }
                        else if (obj.TK_QUAHAN_KHACHQUAN == "1")
                        {
                            rdVuAnQuaHan.SelectedValue = "1";
                            pnNNQuanHan.Visible = true;
                            rdNNQuaHan.SelectedIndex = 1;
                        }
                        else
                        {
                            rdVuAnQuaHan.SelectedValue = "0";
                            pnNNQuanHan.Visible = false;
                            rdNNQuaHan.SelectedIndex = -1;
                        }
                    }
                    else
                    {
                        rdVuAnQuaHan.SelectedValue = "0";
                        pnNNQuanHan.Visible = false;
                        rdNNQuaHan.SelectedIndex = -1;
                    }

                    rdToaAn_BSTaiLieu.SelectedValue = (string.IsNullOrEmpty(obj.TK_YEUCAUVKSBOSUNGTL + "")) ? "0" : obj.TK_YEUCAUVKSBOSUNGTL.ToString();
                    //--------------------------------
                    if ((obj.TENFILE + "") != "")
                    {
                        lbtDownloadBA.Visible = true;
                        lbtDownloadBA.Text = obj.TENFILE + "";
                        lbtXoaFile.Visible = true;
                        pnZonekythuong.Visible = false;
                        pnFILE_DINHKEM.Visible = true;
                    }
                    else
                    {
                        pnZonekythuong.Visible = true;
                        lbtDownloadBA.Visible = false;
                        lbtXoaFile.Visible = false;
                        pnFILE_DINHKEM.Visible = false;
                    }
                    //GTEL-DUCPH 22-09-2025 thêm check có bị can chưa xác thực thì không cho Lưu
                    CheckBtnLuuBanAnST();

                    //END GTEL-DUCPH 22-09-2025 thêm check có bị can chưa xác thực thì không cho Lưu
                }
                else
                {
                    txtNgayMoPhienToa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    pnAnPhi.Enabled = false;
                    //GTEL-DUCPH 22-09-2025 thêm check có bị can chưa xác thực thì không cho Lưu
                    CheckBtnLuuBanAnST();

                    //END GTEL-DUCPH 22-09-2025 thêm check có bị can chưa xác thực thì không cho Lưu
                }
            }
            catch
            {
                obj = null;
                txtNgayMoPhienToa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                pnAnPhi.Enabled = false;
            }
        }
        //GTEL-DUCPH 22-09-2025 thêm check có bị can chưa xác thực thì không cho Lưu
        private void CheckBtnLuuBanAnST()
        {
            lttMsgBanAn.Text = "";
            AHS_BICANBICAO_NC_BL blNc = new AHS_BICANBICAO_NC_BL();
            DataTable checkBiCanChuaXacThucTbl = blNc.AHS_CHECK_BICAN_CHUAXACTHUC(VuAnID);
            if (checkBiCanChuaXacThucTbl.Rows.Count > 0)
            {
                Decimal soBiCanChuaXacThuc = Convert.ToDecimal(checkBiCanChuaXacThucTbl.Rows[0]["TOTAL"].ToString());
                if (soBiCanChuaXacThuc > 0)
                {
                    cmdUpdateBanAnST.Visible = false;
                    lttMsgBanAn.Text = "Có bị can chưa xác thực thông tin. Đề nghị xác thực tại màn hình Danh sách bị can/bị cáo.";
                    return;
                }
                else cmdUpdateBanAnST.Visible = true;
            }
            else cmdUpdateBanAnST.Visible = true;
        }

        // Update thong tin AnSoTham
        protected void cmdUpdateBanAnST_Click(object sender, EventArgs e)
        {
            string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
            decimal VUANID = Convert.ToDecimal(current_id);
            if (!CheckCongbo(VUANID))
                return;

            lttMsgBanAn.Text = lttMsgAnPhi.Text = "";
            MSG_file.Text = string.Empty;
            string so = txtSoBanAn.Text;
            DateTime ngayBA = DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            Decimal CheckID = oSTBL.CheckSoBATheoLoaiAn(DonViID, "AHS", so, ngayBA);
            if (CheckID > 0)
            {
                Decimal CurrBanAnId = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                String strMsg = "";
                String STTNew = oSTBL.GETSoBANEWTheoLoaiAn(DonViID, "AHS", ngayBA).ToString();
            }
            // 2/12/2025 vnpt check tong dat
            Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

            AHS_SOTHAM_BANAN obj = new AHS_SOTHAM_BANAN();
            if (VuAnId > 0)
            {
                obj = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnId).SingleOrDefault<AHS_SOTHAM_BANAN>();
                if (obj != null)
                {
                    AHS_TONGDAT oTD1 = dt.AHS_TONGDAT.Where(x => x.VUANID == obj.VUANID && x.MAPID == obj.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_SOTHAM_BANAN).FirstOrDefault();
                    if (oTD1 != null)
                    {
                        lttMsgBanAn.Text = "Bạn không thể sửa khi đã tống đạt!";
                        return;
                    }
                }
            }
            UpdateBanAn();
            Update_ThongTinThongKe();
            try
            {
                try
                { Update_BanAn_ToiDanh(); }
                catch { }
                hddPageIndex.Value = "1";
                LoadDsBiCao_AnPhi();
            }
            catch { }

            Capnhat_AHS_TONGHOPHINHPHAT();
        }
        void Update_BanAn_ToiDanh()
        {
            Decimal BanAnID = String.IsNullOrEmpty(hddID.Value) ? 0 : Convert.ToDecimal(hddID.Value);
            List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lst = null;
            lst = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.VUANID == VuAnID
                                                           && x.BANANID == 0
                                                        ).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET item in lst)
                {
                    item.BANANID = BanAnID;
                }
                dt.SaveChanges();
            }
        }
        void UpdateBanAn()
        {

            if (dropThuLyBA.SelectedValue == "0")
            {
                lttMsgBanAn.Text = "Chưa chọn thụ lý. Hãy kiểm tra lại.";
                dropThuLyBA.Focus();
                return;
            }

            Boolean IsUpdate = false;
            DateTime date_temp;
            Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

            AHS_SOTHAM_BANAN obj = new AHS_SOTHAM_BANAN();
            if (VuAnId > 0)
            {
                obj = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnId).SingleOrDefault<AHS_SOTHAM_BANAN>();
                if (obj != null)
                {
                    IsUpdate = true;
                }
                else
                    obj = new AHS_SOTHAM_BANAN();
            }
            else
                obj = new AHS_SOTHAM_BANAN();

            //GTEL-DUCPH 22-09-2025 thêm check có bị can chưa xác thực thì không cho Lưu

            AHS_BICANBICAO_NC_BL blNc = new AHS_BICANBICAO_NC_BL();
            DataTable checkBiCanChuaXacThucTbl = blNc.AHS_CHECK_BICAN_CHUAXACTHUC(VuAnId);
            if (checkBiCanChuaXacThucTbl.Rows.Count > 0)
            {
                Decimal soBiCanChuaXacThuc = Convert.ToDecimal(checkBiCanChuaXacThucTbl.Rows[0]["TOTAL"].ToString());
                if (soBiCanChuaXacThuc > 0)
                {
                    lttMsgBanAn.Text = "Có bị can chưa xác thực thông tin. Đề nghị xác thực tại màn hình Danh sách bị can/bị cáo.";
                    return;
                }
            }
            //END GTEL-DUCPH 22-09-2025 thêm check có bị can chưa xác thực thì không cho Lưu

            decimal ThuLyID = Convert.ToDecimal(dropThuLyBA.SelectedValue);
            obj.THULYID = ThuLyID;

            obj.VUANID = VuAnId;
            //-----------------------------------------
            date_temp = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYBANAN = date_temp;

            //-----------------------------------------
            date_temp = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYMOPHIENTOA = date_temp;
            obj.DIADIEM = txtDiaDiem.Text.Trim();
            //-----------------------------------------

            if (hddFilePath.Value != "")
            {
                try
                {
                    string strFilePath = "";

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
                        obj.NOIDUNGFILE = buff;
                        obj.TENFILE = oF.Name;
                        obj.KIEUFILE = oF.Extension;
                    }
                    File.Delete(strFilePath);
                    lbtDownload.Visible = true;
                    lbtXoaFile.Visible = true;
                    MSG_file.Text = string.Empty;
                }
                catch { }
            }

            //-----------------------------------------
            obj.NGUOIKY = (String.IsNullOrEmpty(hddNguoiKyID.Value)) ? 0 : Convert.ToDecimal(hddNguoiKyID.Value);
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            obj.TOAANID = ToaAnID;
            obj.SOBANAN = txtSoBanAn.Text.Trim();
            if (IsUpdate)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_SOTHAM_BANAN.Add(obj);
                dt.SaveChanges();
                InsertToiDanhTuCaoTrangSangBanAnSoTham(obj.ID);
                hddID.Value = obj.ID + "";
            }

            capnhat_baqd_congbo(VuAnId, obj.ID);

            /* 25.04.2025 Gọi hàm UploadFileID, lưu vào bảng AHN_FILE là có Bản án
             * File bản án nếu đính kèm sẽ lưu vào bảng AHN_SOTHAM_BANAN_FILE
             * (Bản án chỉ có 1 nên không cần tạo trường FILEID như Quyết định
             * 2022 Đã bỏ hoàn toàn và k tống đạt Bản án
             * Trước đó bắt buộc có file đính kèm mới được Tống đạt */
            AHS_VUAN_BL oBL = new AHS_VUAN_BL();
            var rFileID = UploadFileID(VuAnId, obj?.FILEID ?? 0, "27-HS");
            if (rFileID > 0)
            {
                obj.FILEID = rFileID;
                dt.SaveChanges();
            }

            lttMsgBanAn.Text = "Lưu dữ liệu bản án thành công!";
        }
        void InsertToiDanhTuCaoTrangSangBanAnSoTham(decimal BanAnID)
        {
            Boolean IsUpdate = false;
            AHS_SOTHAM_BANAN_DIEU_CHITIET BaDieuCT;
            AHS_SOTHAM_BANAN_BICAO Ba_BC;
            Decimal BiCaoID = 0;
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            AHS_SOTHAM_CAOTRANG_DIEULUAT_BL objBL = new AHS_SOTHAM_CAOTRANG_DIEULUAT_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Decimal DieuLuatID = 0, HinhPhatID = 0, ToiDanhId = 0, LoaiHinhPhat = 0;
                foreach (DataRow row in tbl.Rows)
                {
                    BiCaoID = (string.IsNullOrEmpty(row["BiCanID"] + "")) ? 0 : Convert.ToDecimal(row["BiCanID"] + "");
                    DieuLuatID = (string.IsNullOrEmpty(row["BoLuatID"] + "")) ? 0 : Convert.ToDecimal(row["BoLuatID"] + "");
                    ToiDanhId = (string.IsNullOrEmpty(row["ToiDanhID"] + "")) ? 0 : Convert.ToDecimal(row["ToiDanhID"] + "");
                    //-----------------------------------------------
                    #region Update Vao BanAn_BiCao
                    IsUpdate = false;

                    Ba_BC = dt.AHS_SOTHAM_BANAN_BICAO.Where(x => x.BANANID == BanAnID && x.BICAOID == BiCaoID).SingleOrDefault<AHS_SOTHAM_BANAN_BICAO>();
                    if (Ba_BC != null)
                        IsUpdate = true;
                    else
                    {
                        Ba_BC = new AHS_SOTHAM_BANAN_BICAO();
                    }

                    Ba_BC.BANANID = BanAnID;
                    Ba_BC.BICAOID = BiCaoID;

                    if (!IsUpdate)
                    {
                        if (Ba_BC.TOA_GIAIQUYET_ID == null)
                        {
                            Ba_BC.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        }
                        dt.AHS_SOTHAM_BANAN_BICAO.Add(Ba_BC);
                        dt.SaveChanges();
                    }

                    #endregion
                    //------------------------------------------------
                    #region Update BAnAn_Dieu_ChiTiet
                    IsUpdate = false;
                    BaDieuCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnID
                                                                       && x.BICANID == BiCaoID
                                                                       && x.DIEULUATID == DieuLuatID
                                                                       && x.TOIDANHID == ToiDanhId
                                                                    ).FirstOrDefault<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    if (BaDieuCT != null)
                        IsUpdate = true;
                    else
                        BaDieuCT = new AHS_SOTHAM_BANAN_DIEU_CHITIET();

                    BaDieuCT.BANANID = BanAnID;
                    BaDieuCT.ISCHANGE = 0;
                    BaDieuCT.BICANID = BiCaoID;
                    BaDieuCT.DIEULUATID = DieuLuatID;
                    BaDieuCT.HINHPHATID = HinhPhatID;
                    BaDieuCT.LOAIHINHPHAT = LoaiHinhPhat;
                    BaDieuCT.TOIDANHID = ToiDanhId;
                    BaDieuCT.TENTOIDANH = row["TenToiDanh"] + "";
                    BaDieuCT.ISMAIN = String.IsNullOrEmpty(row["IsMain"] + "") ? 0 : Convert.ToInt16(row["IsMain"] + "");
                    BaDieuCT.VUANID = VuAnID;
                    switch (Convert.ToInt16(BaDieuCT.LOAIHINHPHAT))
                    {
                        case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                            BaDieuCT.TF_VALUE = 0;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                            BaDieuCT.SH_VALUE = 0;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                            BaDieuCT.TG_NGAY = 0;
                            BaDieuCT.TG_THANG = 0;
                            BaDieuCT.TG_NAM = 0;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                            BaDieuCT.K_VALUE1 = 0;
                            BaDieuCT.K_VALUE2 = "";
                            break;
                    }
                    if (!IsUpdate)
                    {
                        dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Add(BaDieuCT);
                        dt.SaveChanges();
                    }
                    #endregion
                }
            }
        }

        // Update thong tin thong ke
        void Update_ThongTinThongKe()
        {
            if (ddlCBBA_Anle.SelectedValue == "-1")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Chưa chọn số án lệ áp dụng. Hãy kiểm tra lại. " + "')", true);
                lttMsgBanAn.Text = "Lỗi: Dữ liệu thống kê lưu không thành công!";
                return;
            }
            if (rdAnRutGon.SelectedValue == "-1")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + " Chưa chọn số án lệ áp dụng. Hãy kiểm tra lại. " + "')", true);
                lttMsgBanAn.Text = "Lỗi: Dữ liệu thống kê lưu không thành công!";
                return;
            }

            Boolean IsUpdate = false;
            Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

            AHS_SOTHAM_BANAN obj = new AHS_SOTHAM_BANAN();
            if (VuAnId > 0)
            {
                obj = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnId).SingleOrDefault<AHS_SOTHAM_BANAN>();
                if (obj != null)
                    IsUpdate = true;
            }
            else
                obj = new AHS_SOTHAM_BANAN();

            obj.VUANID = VuAnId;

            obj.ISANLE = ddlCBBA_Anle.SelectedValue == "0" ? 0 : 1;
            obj.SOANLE = ddlCBBA_Anle.SelectedValue;
            obj.ISANRUTGON = Convert.ToDecimal(rdAnRutGon.SelectedValue);
            obj.ISXXLUUDONG = Convert.ToDecimal(rdXetXuLuuDong.SelectedValue);
            obj.ISBAOLUCGIADINH = Convert.ToDecimal(rdBaoLucGD.SelectedValue);
            //obj.ISCONGBOBA = Convert.ToDecimal(rdCongboBA.SelectedValue);
            obj.TK_XXKHACVKS_TOIDANH_NANGHON = (string.IsNullOrEmpty(txt_XXToiDanh_NangHon.Text.Trim())) ? 0 : Convert.ToDecimal(txt_XXToiDanh_NangHon.Text.Replace(".", ""));
            obj.TK_XXKHACVKS_TOIDANH_NHEHON = (string.IsNullOrEmpty(txt_XXToiDanh_NheHon.Text.Trim())) ? 0 : Convert.ToDecimal(txt_XXToiDanh_NheHon.Text.Replace(".", ""));
            obj.TK_XXKHACVKS_KHOAN_NANGHON = (string.IsNullOrEmpty(txt_XXKhoan_NangHon.Text.Trim())) ? 0 : Convert.ToDecimal(txt_XXKhoan_NangHon.Text.Replace(".", ""));
            obj.TK_XXKHACVKS_KHOAN_NHEHON = (string.IsNullOrEmpty(txt_XXKhoan_NheHon.Text.Trim())) ? 0 : Convert.ToDecimal(txt_XXKhoan_NheHon.Text.Replace(".", ""));
            obj.TK_XXKHACVKS_HINHPHAT_NANGHON = (string.IsNullOrEmpty(txt_XXHinhPhat_NangHon.Text.Trim())) ? 0 : Convert.ToDecimal(txt_XXHinhPhat_NangHon.Text.Replace(".", ""));
            obj.TK_XXKHACVKS_HINHPHAT_NHEHON = (string.IsNullOrEmpty(txt_XXHinhPhat_NheHon.Text.Trim())) ? 0 : Convert.ToDecimal(txt_XXHinhPhat_NheHon.Text.Replace(".", ""));

            //---------------------------------------
            obj.TK_TSCHIEMDOAT = (string.IsNullOrEmpty(txtTSChiemDoat.Text)) ? 0 : Convert.ToDecimal(txtTSChiemDoat.Text.Replace(".", ""));
            obj.TK_TSTHIETHAI = (string.IsNullOrEmpty(txtTSThietHai.Text)) ? 0 : Convert.ToDecimal(txtTSThietHai.Text.Replace(".", ""));

            //Tài sản thu hồi và bồi thường thiệt hại
            obj.TK_TSTHUHOI = (string.IsNullOrEmpty(txtTSThuHoi.Text)) ? 0 : Convert.ToDecimal(txtTSThuHoi.Text.Replace(".", ""));
            obj.TK_BOITHUONGTH = (string.IsNullOrEmpty(txtBoiThuongTH.Text)) ? 0 : Convert.ToDecimal(txtBoiThuongTH.Text.Replace(".", ""));

            //Luật sư và người bào chữa khác
            obj.TK_LUATSU = Convert.ToDecimal(rdLuatSu.SelectedValue);
            obj.TK_NGUOIBAOCHUAKHAC = Convert.ToDecimal(rdNguoiBaochuaKhac.SelectedValue);

            //---------------------------------------
            obj.TK_PNTM_NUOCNGOAI = obj.TK_PNTM_NHANUOC = 0;
            if (hddTuCachPN.Value == "0")
            {
                try
                {
                    obj.TK_PNTM_NUOCNGOAI = Convert.ToDecimal(rdPNTM_NuocNgoai.SelectedValue);
                    obj.TK_PNTM_NHANUOC = Convert.ToDecimal(rdPNTM_NhaNuoc.SelectedValue);
                }
                catch (Exception)
                {
                }
            }
            obj.TK_APDUNGBAOVE = Convert.ToDecimal(rdToaAnApDungBaoVe.SelectedValue);
            obj.TK_APDUNGBAOVE_BIHAI = (string.IsNullOrEmpty(txtSoBiHai.Text)) ? 0 : Convert.ToDecimal(txtSoBiHai.Text);
            //---------------------------------------
            obj.TK_ISVIPHAMHANTAMGIAM = Convert.ToDecimal(rdViPhamHanTamGiam.SelectedValue);
            //obj.TK_VIPHAMTG_VUAN = (string.IsNullOrEmpty(txtViPham_SoVuAn.Text)) ? 0 : Convert.ToDecimal(txtViPham_SoVuAn.Text) ;
            obj.TK_VIPHAMTG_BICAO = (string.IsNullOrEmpty(txtViPham_SoBiCao.Text)) ? 0 : Convert.ToDecimal(txtViPham_SoBiCao.Text);

            obj.TK_PHUCHOIAN_VUAN = Convert.ToDecimal(rdIsPhucHoi.SelectedValue);
            obj.TK_PHUCHOIAN_BICAO = (string.IsNullOrEmpty(txtPhucHoi_SoBiCao.Text)) ? 0 : Convert.ToDecimal(txtPhucHoi_SoBiCao.Text);

            obj.TK_TOAAN_SOVUXM = Convert.ToDecimal(rdToaAn_XacMinh.SelectedValue);
            obj.TK_TOAAN_SOVUXM = Convert.ToDecimal(rdToaAn_XacMinh.SelectedValue);
            if (rdToaAn_XacMinh.SelectedValue == "1")
                obj.TK_TOAAN_KOXM = Convert.ToDecimal(rdToaAn_KoXacMinh.SelectedValue);

            obj.TK_KHOITO_VUAN = Convert.ToDecimal(rdKhoiTo.SelectedValue);
            obj.TK_KHOITO_BICAO = (string.IsNullOrEmpty(txtKhoiTo_SoBiCao.Text)) ? 0 : Convert.ToDecimal(txtKhoiTo_SoBiCao.Text);

            obj.TK_ISTRAHS_VKSKHONGNHAN = Convert.ToDecimal(rdTraAn_VKSKoNhan.SelectedValue);
            obj.TK_YEUCAUVKSBOSUNGTL = Convert.ToDecimal(rdToaAn_BSTaiLieu.SelectedValue);

            // Xét xử lại phần xử lý vật chứng và trách nhiệm dân sự
            obj.TK_XULYVATCHUNG = Convert.ToDecimal(rdXuLyVatChung.SelectedValue);
            obj.TK_XULYVATCHUNG_SBC = string.IsNullOrEmpty(txtSoBiCao.ToString()) ? 0 : Convert.ToDecimal(txtSoBiCao.Text);

            if (rdVuAnQuaHan.SelectedValue == "1")
            {
                if (rdNNQuaHan.SelectedValue == "0")
                {
                    obj.TK_QUAHAN_CHUQUAN = "1";
                    obj.TK_QUAHAN_KHACHQUAN = "0";
                }
                else if (rdNNQuaHan.SelectedValue == "1")
                {
                    obj.TK_QUAHAN_CHUQUAN = "0";
                    obj.TK_QUAHAN_KHACHQUAN = "1";
                }
                else
                {
                    lttMsgAnPhi.Text = "Vụ án quá hạn luật định lưu không thành công!";
                    obj.TK_QUAHAN_KHACHQUAN = obj.TK_QUAHAN_CHUQUAN = "0";
                }
            }
            else
            {
                obj.TK_QUAHAN_KHACHQUAN = obj.TK_QUAHAN_CHUQUAN = "0";
            }

            obj.TK_VIPHAMCONGTACQL = Convert.ToDecimal(rdViPham_CtacQuanLy.SelectedValue);
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            obj.TOAANID = ToaAnID;

            if (IsUpdate)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                AHS_SOTHAM_BANAN_BL objBL = new AHS_SOTHAM_BANAN_BL();
                if (!String.IsNullOrEmpty(txtSoBanAn.Text))
                    obj.SOBANAN = txtSoBanAn.Text.Trim();
                else
                {
                    try
                    {
                        decimal thutu = objBL.GetNewTT(ToaAnID, VuAnId);
                        obj.SOBANAN = ENUM_LOAIVUVIEC.AN_HINHSU + Session[ENUM_SESSION.SESSION_MADONVI] + thutu.ToString();
                    }
                    catch (Exception ex) { }
                }

                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_SOTHAM_BANAN.Add(obj);
                dt.SaveChanges();
                hddID.Value = obj.ID + "";
            }
            lttMsgBanAn.Text = lttMsgBanAn.Text + " " + "Lưu dữ liệu thống kê thành công!";
        }

        // Update thong tin an phi & Load DSBiCao_AnPhi
        protected void cmdUpdateAnPhi_Click(object sender, EventArgs e)
        {
            MSG_file.Text = string.Empty;
            lttMsgBanAn.Text = lttMsgAnPhi.Text = "";
            AHS_SOTHAM_BANAN_BICAO obj = null;
            Boolean IsNew = false;
            Decimal BanAnID = Convert.ToDecimal(hddID.Value);
            if (rpt.Items.Count > 0)
            {
                foreach (RepeaterItem oItem in rpt.Items)
                {

                    TextBox txtNgayHieuLuc = (TextBox)oItem.FindControl("txtNgayHieuLuc");
                    TextBox txtNgaynhanbanan = (TextBox)oItem.FindControl("txtNgaynhanbanan");
                    if (txtNgaynhanbanan.Text != "")
                    {
                        DateTime NgayNhanBA;
                        if (DateTime.TryParse(txtNgaynhanbanan.Text, cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhanBA))
                        {
                            if (DateTime.Compare(NgayNhanBA, DateTime.Now) > 0)
                            {
                                lttMsgAnPhi.Text = "Ngày nhận bản án không được lớn hơn ngày hiện tại.";
                                txtNgaynhanbanan.Focus();
                                return;
                            }
                        }
                        else
                        {
                            lttMsgAnPhi.Text = "Ngày nhận bản án không đúng kiểu ngày / tháng / năm.";
                            txtNgaynhanbanan.Focus();
                            return;
                        }


                        /*
                         GTEL-HUNGNQ: 01/10/2025 
                            - Thêm check Ngày hiệu lực không được chọn ngày tương lai
                            - phải nhập trong 30 ngày kể từ khi có ngày nhận bản ân
                         */
                        if (txtNgayHieuLuc.Text != "")
                        {
                            DateTime NgayHieuLuc;
                            if (DateTime.TryParse(txtNgayHieuLuc.Text, cul, DateTimeStyles.NoCurrentDateDefault, out NgayHieuLuc))
                            {
                                if (DateTime.Compare(NgayHieuLuc, DateTime.Now) > 0)
                                {
                                    lttMsgAnPhi.Text = "Ngày hiệu lực không được lớn hơn ngày hiện tại.";
                                    txtNgaynhanbanan.Focus();
                                    return;
                                }

                                // GTEL-HUNGNQ 06-10-2025 chỉnh lại so sánh 30 ngày 
                                TimeSpan khoangCach = NgayHieuLuc - NgayNhanBA;
                                if (khoangCach.TotalDays < 30)
                                {
                                    lttMsgAnPhi.Text = "Bạn phải nhập Ngày hiệu lực sau 30 ngày kể từ Ngày nhận bản án.";
                                    txtNgayHieuLuc.Focus();
                                    return;
                                }
                            }
                            else
                            {
                                lttMsgAnPhi.Text = "Ngày nhận bản án không đúng kiểu ngày / tháng / năm.";
                                txtNgaynhanbanan.Focus();
                                return;
                            }
                        }
                    }
                }
            }
            foreach (RepeaterItem item in rpt.Items)
            {
                IsNew = false;
                HiddenField hddBiCao = (HiddenField)item.FindControl("hddBiCao");
                CheckBox chkThamGiaPhienToa = (CheckBox)item.FindControl("chkThamGiaPhienToa");
                TextBox txtAnPhi = (TextBox)item.FindControl("txtAnPhi");
                //CheckBox chkDinhChi = (CheckBox)item.FindControl("chkDinhChi");
                TextBox txtNgaynhanbanan = (TextBox)item.FindControl("txtNgaynhanbanan");
                decimal BiCaoId = Convert.ToDecimal(hddBiCao.Value);
                obj = dt.AHS_SOTHAM_BANAN_BICAO.Where(x => x.BANANID == BanAnID && x.BICAOID == BiCaoId).SingleOrDefault<AHS_SOTHAM_BANAN_BICAO>();
                if (obj == null)
                {
                    IsNew = true;
                    obj = new AHS_SOTHAM_BANAN_BICAO();
                }

                obj.BANANID = BanAnID;
                obj.ISTHAMGIAPHIENTOA = (chkThamGiaPhienToa.Checked) ? 1 : 0;
                //obj.ISDINHCHI = (chkDinhChi.Checked) ? 1 : 0;

                obj.NGAYNHANBANAN = (String.IsNullOrEmpty(txtNgaynhanbanan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgaynhanbanan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.BICAOID = BiCaoId;
                obj.ANPHI = (string.IsNullOrEmpty(txtAnPhi.Text + "")) ? 0 : Convert.ToDecimal(txtAnPhi.Text.Replace(".", ""));


                if (IsNew)
                {
                    if (obj.TOA_GIAIQUYET_ID == null)
                    {
                        obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_BANAN_BICAO.Add(obj);
                }
                dt.SaveChanges();
                //GTEL-DUCPH 13-09-2025 Cap nhat them ngay hieu luc cho bi can
                AHS_BICANBICAO_NC_BL blNc = new AHS_BICANBICAO_NC_BL();
                TextBox txtNgayHieuLuc = (TextBox)item.FindControl("txtNgayHieuLuc");
                DateTime vNgayHieuLuc = (String.IsNullOrEmpty(txtNgayHieuLuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayHieuLuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                blNc.AHS_SOTHAM_BANAN_BICAO_UPDATE_NGAYHIEULUC(BiCaoId, vNgayHieuLuc);
                //-------- END NC: 13/09/2025 ---------------
            }

            Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]); 
            capnhat_baqd_congbo(VuAnId, BanAnID);

            lttMsgAnPhi.Text = "Lưu dữ liệu thành công!";
        }

        // Load DS BiCao AnPhi
        public void cmdReloadParent_Click(object sender, EventArgs e)
        {
            LoadDsBiCao_AnPhi();
        }
        public void LoadDsBiCao_AnPhi()
        {
            int vu_an_id = Convert.ToInt32(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            //---------- GTEL-DUCPH NC 13-09-2025 Dùng Hàm mới tránh ảnh hưởng đến code chỉ lấy thêm ngày hiệu lực ---------/
            AHS_BICANBICAO_NC_BL bl = new AHS_BICANBICAO_NC_BL();
            DataTable tbl = bl.AHS_ST_BANAN_BICAO_GetByVuAnID(vu_an_id, pageindex, page_size);
            //AHS_SOTHAM_BANAN_BL objBL = new AHS_SOTHAM_BANAN_BL();  // comment ham cu
            //DataTable tbl = objBL.GetDsBiCaoByVuAn(vu_an_id, pageindex, page_size); //comment ham cu

            // ----------- END  GTEL-DUCPH NC 13-09-2025 Dùng Hàm mới tránh ảnh hưởng đến code chỉ lấy thêm ngày hiệu lực
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataRow[] arr = tbl.Select("BICANDAUVU=1", "BICANDAUVU desc,NgayThamGia desc");
                if (arr != null && arr.Length > 0)
                {
                    row_tucach_phapnhan_tm.Visible = false;
                    rdPNTM_NhaNuoc.SelectedIndex = rdPNTM_NuocNgoai.SelectedIndex = 0;
                }

                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                // lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;
                //-----------------------------
                int IsShow = (string.IsNullOrEmpty(tbl.Rows[0]["IsShow"] + "")) ? 0 : Convert.ToInt16(tbl.Rows[0]["IsShow"] + "");
                if (IsShow > 0)
                {
                    cmdUpdateAnPhi.Enabled = true;
                    pnAnPhi.Enabled = true;
                }
                else
                {
                    // lttMsgBanAn.Text = "Chưa có bản án xét xử sơ thẩm!";
                    cmdUpdateAnPhi.Enabled = pnAnPhi.Enabled = false;
                }
            }
            else
            {
                lttMsgAnPhi.Text = "Chưa có bị cáo được xét xử sơ thẩm. Đề nghị kiểm tra lại!";
                cmdUpdateAnPhi.Enabled = pnAnPhi.Enabled = pndata.Visible = false;
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                int IsShow = Convert.ToInt16(dv["IsShow"] + "");
                if (IsShow == 0)
                {
                    Panel lnLinkToiDanh = (Panel)e.Item.FindControl("lnLinkToiDanh");
                    lnLinkToiDanh.Visible = false;
                }

                // check quyền để hiển disable
                CheckBox chkThamGiaPhienToa = (CheckBox)e.Item.FindControl("chkThamGiaPhienToa");
                TextBox txtAnPhi = (TextBox)e.Item.FindControl("txtAnPhi");
                TextBox txtNgaynhanbanan = (TextBox)e.Item.FindControl("txtNgaynhanbanan");
                TextBox txtNgayHieuLuc = (TextBox)e.Item.FindControl("txtNgayHieuLuc");

                //GTEL-DUCPH 22-09-2025 chuyển lấy tội danh lên trước để check enable cho ngày hiệu lực
                // Tong hop toi danh
                //lblTHtoidanh
                HiddenField hddBiCao = (HiddenField)e.Item.FindControl("hddBiCao");
                decimal vBicaoID = Convert.ToDecimal(hddBiCao.Value);
                Label lblTHtoidanh = (Label)e.Item.FindControl("lblTHtoidanh");
                AHS_TONGHOPHINHPHAT tonghophinhphat = DataExtensions.GetAllWithClause<AHS_TONGHOPHINHPHAT>($"VUANID= {VuAnID} AND BICAOID = {vBicaoID}").FirstOrDefault();
                try
                {
                    //GTEL-DUCPH 22-09-2025 Kiểm tra thêm nếu tonghophinhphat null không gán 
                    string hinhphatTonHopSt = string.Empty;
                    if (tonghophinhphat != null)
                    {
                        string hinhPhatTongHopSt = tonghophinhphat.Tonghophinhphat_ST(VuAnID, vBicaoID);
                        lblTHtoidanh.Text = tonghophinhphat.Tonghophinhphat_ST(VuAnID, vBicaoID);
                    }
                }
                catch (Exception ex) { }
                DateTime ngaynhan = String.IsNullOrEmpty(dv["NgayNhanBanAn"] + "") ? DateTime.MinValue : Convert.ToDateTime(dv["NgayNhanBanAn"] + "");
                //GTEL-DUCPH 22-09-2025 thêm txtNgayHieu Enable và Disable theo ngày nhận bản án

                // Từ item này, tìm TextBox khác cùng hàng
                if (ngaynhan == DateTime.MinValue)
                {
                    txtNgaynhanbanan.Text = "";
                    txtNgayHieuLuc.Enabled = false; //Nếu chưa có ngày hiệu lực thì Không Enable
                }
                else
                {
                    txtNgaynhanbanan.Text = ngaynhan.ToString("dd/MM/yyyy", cul);
                    if (!string.IsNullOrEmpty(lblTHtoidanh.Text)) txtNgayHieuLuc.Enabled = true;
                    else txtNgayHieuLuc.Enabled = false;
                }

                //check đương sự đã được đồng bộ chưa => để disabled các control
                KHOBAQD_BL ahsNCBl = new KHOBAQD_BL();
                string daDongBo = dt.KHOBAQD_DUONGSU.FirstOrDefault(x => x.STATUS == 1 && x.DUONGSUID == vBicaoID && x.KHOBAQDID == IdKhoDongBo && x.TRANGTHAIDUONGSU != 5) != null ? "1" : "0";
                HiddenField hddDaDongBo = (HiddenField)e.Item.FindControl("hddDaDongBo");
                hddDaDongBo.Value = isDongbo ? "1" : "0"; //check bản án đồng bộ => không cho chọn điều luật
                if (daDongBo == "1")
                {
                    chkThamGiaPhienToa.Enabled = false;
                    txtAnPhi.Enabled = false;
                    txtNgaynhanbanan.Enabled = false;
                    txtNgayHieuLuc.Enabled = false;
                }
                else //chưa đồng bộ đương sự
                {
                    // check quyền để hiển thị nút xoá
                    HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                    string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                    string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                    if (!string.IsNullOrEmpty(toaGiaiQuyetID) && toaGiaiQuyetID != donviID) //không có quyền
                    {
                        chkThamGiaPhienToa.Enabled = false;
                        txtAnPhi.Enabled = false;
                        txtNgaynhanbanan.Enabled = false;
                        // GTEL-DUCPH 22-09-2025 disable cả ngày hiệu lực 
                        txtNgayHieuLuc.Enabled = false;
                    }
                    else //có quyền sửa
                    {
                        if (isDongbo) //nếu bản án đã đồng bộ
                        {
                            chkThamGiaPhienToa.Enabled = false;
                            txtAnPhi.Enabled = false;
                            txtNgaynhanbanan.Enabled = false;
                            txtNgayHieuLuc.Enabled = true;
                        }
                    }
                }
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "ToiDanh":
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lttMsgAnPhi.Text = Result;
                        return;
                    }
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popupChonToiDanh(" + curr_id + ")");
                    break;
            }
        }


        protected void rdViPhamHanTamGiam_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdViPhamHanTamGiam.SelectedValue == "1")
            {
                pnViPham.Enabled = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtViPham_SoBiCao.ClientID);
            }
            else
            {
                pnViPham.Enabled = false;
                txtViPham_SoBiCao.Text = "0";
                Cls_Comon.SetFocus(this, this.GetType(), rdIsPhucHoi.ClientID);
            }
        }
        protected void rdIsPhucHoi_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdIsPhucHoi.SelectedValue == "1")
            {
                pnPhucHoi.Enabled = true;
                Cls_Comon.SetFocus(this, this.GetType(), rdKhoiTo.ClientID);
            }
            else
            {
                pnPhucHoi.Enabled = false;
                txtPhucHoi_SoBiCao.Text = "0";
                Cls_Comon.SetFocus(this, this.GetType(), txtViPham_SoBiCao.ClientID);
            }
        }
        protected void rdKhoiTo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdKhoiTo.SelectedValue == "1")
            {
                pnKhoiTo.Enabled = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtKhoiTo_SoBiCao.ClientID);
            }
            else
            {
                pnKhoiTo.Enabled = false;
                txtKhoiTo_SoBiCao.Text = "0";
                Cls_Comon.SetFocus(this, this.GetType(), rdTraAn_VKSKoNhan.ClientID);
            }
        }
        protected void rdVuAnQuaHan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdVuAnQuaHan.SelectedValue == "1")
            {
                pnNNQuanHan.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), rdNNQuaHan.ClientID);
            }
            else
            {
                pnNNQuanHan.Visible = false;
                rdNNQuaHan.ClearSelection();
                Cls_Comon.SetFocus(this, this.GetType(), cmdUpdateBanAnST.ClientID);
            }
        }

        protected void cmdHuyBanAn_Click(object sender, EventArgs e)
        {
            // Xóa thông tin bản án
            Decimal BanAnID = 0;
            decimal VuAnID = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_SOTHAM_BANAN banan = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            if (banan != null)
            {
                BanAnID = banan.ID;
                // 2/12/2025 vnpt check tong dat
                AHS_TONGDAT oTD1 = dt.AHS_TONGDAT.Where(x => x.VUANID == banan.VUANID && x.MAPID == banan.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_SOTHAM_BANAN).FirstOrDefault();
                if (oTD1 != null)
                {
                    lttMsgBanAn.Text = "Bạn không thể xóa khi đã tống đạt!";
                    return;
                }
            }

            //------Xoa toi danh---------------------
            List<AHS_SOTHAM_BANAN_DIEU_CHITIET> toiDanhs = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnID
                                                                                                    && x.VUANID == VuAnID).ToList();
            if (toiDanhs.Count > 0)
                dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.RemoveRange(toiDanhs);

            //-- Xóa thông tin bản án bị cáo------------------
            List<AHS_SOTHAM_BANAN_BICAO> biCaos = dt.AHS_SOTHAM_BANAN_BICAO.Where(x => x.BANANID == BanAnID).ToList();
            if (biCaos.Count > 0)
                dt.AHS_SOTHAM_BANAN_BICAO.RemoveRange(biCaos);
            //---------------------------
            banan.NOIDUNGFILE = null;
            //Luu thong tin Bản án Sơ thẩm trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(banan);
            ADS_DON_BL oBL = new ADS_DON_BL();
            //Thông tin Bản án Sơ tham dai quá nên không xóa được, tạm thơi khong luu thong tin chi tiet ban an
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(VuAnID), 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Bản án Sơ thẩm án Hình sự", "Xóa", null) == false)
            {
                lttMsgBanAn.Text = "Xóa không thành công!";
                return;
            }//Ket thuc

            //Xoa Bản án Sơ thẩm
            dt.AHS_SOTHAM_BANAN.Remove(banan);

            // Xóa file tống đạt bản án
            decimal BieuMauID = 0;
            DM_BIEUMAU bm = dt.DM_BIEUMAU.Where(x => x.MABM == "27-HS").FirstOrDefault();
            if (bm != null)
            {
                BieuMauID = bm.ID;
            }

            AHS_FILE file = dt.AHS_FILE.Where(x => x.VUANID == VuAnID && x.BIEUMAUID == BieuMauID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM).FirstOrDefault();
            if (file != null)
            {
                dt.AHS_FILE.Remove(file);
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {VuAnID} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)} " +
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

            Capnhat_AHS_TONGHOPHINHPHAT();

            lttMsgBanAn.Text = "Xóa bản án thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }

        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoad.HasFile)
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
                }
            }
            catch (Exception ex) { lttMsgBanAn.Text = ex.Message; }
        }
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                AHS_SOTHAM_BANAN oND = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lttMsgBanAn.Text = ex.Message; }
        }
        protected void lbtXoaFile_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                AHS_SOTHAM_BANAN oND = dt.AHS_SOTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    oND.NOIDUNGFILE = null;
                    oND.TENFILE = null;
                    oND.KIEUFILE = null;
                    dt.SaveChanges();
                    MSG_file.Text = "File bản án đã được xóa thành công";
                    lbtDownloadBA.Visible = false;
                    lbtXoaFile.Visible = false;
                    pnZonekythuong.Visible = true;
                    pnFILE_DINHKEM.Visible = false;
                }
            }
            catch (Exception ex) { lttMsgBanAn.Text = ex.Message; }
        }
        #endregion

        #region rdbQuyetdinh

        private void LoadQD()
        {
            //Load Tên quyết định PKG_LOAD_DM_QDVUAN_KETTHUC
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DM_QUYETDINH_VUAN_SOTHAM_KETTHUC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);

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
        }
        private void LoadLydo()
        {
            ddlLydo.Items.Clear();
            decimal QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            List<DM_QD_QUYETDINH_LYDO> lst = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == QUYETDINHID & x.HIEULUC == 1).OrderBy(y => y.THUTU).ToList();

            if (lst != null && lst.Count > 0)
            {
                pnLyDo.Visible = true;
            }
            else
            {
                pnLyDo.Visible = false;
            }

            ddlLydo.Items.Clear();
            ddlLydo.DataSource = lst;
            ddlLydo.DataTextField = "TEN";
            ddlLydo.DataValueField = "ID";
            ddlLydo.DataBind();

            ddlLydo.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlLydo.SelectedIndex = 0;

        }
        private void LoadNguoiKyDdlInfo()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            DataTable tbl = null;
            decimal CanBoID = 0;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();

            //--------------------------------------
            //Lấy danh sách Chánh án, phó chánh án
            tbl = cb_BL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            //Lấy chủ tọa vụ án
            AHS_SOTHAM_HDXX oND = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AHS_SOTHAM_HDXX>();
            if (oND != null)
            {
                CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());
                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    DataRow dr = tbl.NewRow();
                    dr["MA_TEN"] = dtCanBo.Rows[0]["HOTEN"].ToString() + "-Thẩm phán chủ tọa";
                    dr["ID"] = dtCanBo.Rows[0]["ID"].ToString();
                    tbl.Rows.Add(dr);
                }
            }
            else
            {
                AHS_THAMPHANGIAIQUYET oTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault();
                if (oTP != null)
                {
                    CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        DataRow dr = tbl.NewRow();
                        dr["MA_TEN"] = dtCanBo.Rows[0]["HOTEN"].ToString() + "-Thẩm phán chủ tọa";
                        dr["ID"] = dtCanBo.Rows[0]["ID"].ToString();
                        tbl.Rows.Add(dr);
                    }
                }
            }
            ddlNguoiky.DataSource = tbl;
            ddlNguoiky.DataTextField = "MA_TEN";
            ddlNguoiky.DataValueField = "ID";
            ddlNguoiky.DataBind();
            if (CanBoID > 0)
                ddlNguoiky.SelectedValue = CanBoID.ToString();
            hddNguoiKyQDID.Value = ddlNguoiky.SelectedValue;

        }
        protected void rdbPanelBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            lbThongBaoQD.Text = "";
            if (rdbPanelBA.SelectedValue == BANAN.ToString()) // Bản án
            {
                rdbPanelBA.SelectedValue = BANAN.ToString();
                pnBAST.Visible = true;
                hddShowBA.Value = "1";
                pnQDVV.Visible = false;
                CheckQuyen(VuAnID);
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToa.ClientID);
            }
            else // quyết định
            {
                rdbPanelQD.SelectedValue = QUYETDINH.ToString();
                pnBAST.Visible = false;
                hddShowBA.Value = "0";
                pnQDVV.Visible = true;
                Check_AnChuyenNhanQD(VuAnID);
                check_AnKCKN(VuAnID);
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayMoPhienToa.ClientID);
            }
        }
        private void LoadNguoiKyTxtInfo()
        {
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            AHS_SOTHAM_HDXX oND = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).OrderByDescending(x => x.NGAYPHANCONG).FirstOrDefault<AHS_SOTHAM_HDXX>();
            if (oND != null)
            {
                decimal CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());
                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    txtNguoiKy.Text = txtNguoiKyQD.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                    txtChucvu.Text = "Thẩm phán chủ tọa";
                    hddNguoiKyID.Value = hddNguoiKyTxtID.Value = dtCanBo.Rows[0]["ID"].ToString();
                }
            }
            else
            {
                AHS_THAMPHANGIAIQUYET oTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).FirstOrDefault();
                if (oTP != null)
                {
                    decimal CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        txtNguoiKy.Text = txtNguoiKyQD.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                        txtChucvu.Text = "Thẩm phán giải quyết";
                        hddNguoiKyID.Value = hddNguoiKyTxtID.Value = dtCanBo.Rows[0]["ID"].ToString();
                    }
                }
                else
                    txtNguoiKy.Text = txtNguoiKyQD.Text = txtChucvu.Text = "";
            }
        }

        private bool CheckValidQD()
        {
            if (dropThuLyQD.SelectedValue == "0")
            {
                lbThongBaoQD.Text = "Chưa chọn thụ lý. Hãy kiểm tra lại.";
                dropThuLyQD.Focus();
                return false;
            }

            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbThongBaoQD.Text = "Bạn chưa chọn quyết định!";
                ddlQuyetdinh.Focus();
                return false;
            }

            if (ddlLydo.Visible == true)
            {
                if (ddlLydo.SelectedValue == "0")
                {
                    lbThongBaoQD.Text = "Bạn chưa chọn lý do. Hãy chọn lại!";
                    ddlLydo.Focus();
                    return false;
                }
            }

            if (pnCBQD.Visible)
            {
                if (rdCongBoQD.SelectedValue == "")
                {
                    lbThongBaoQD.Text = "Bạn chưa chọn có công bố quyết định. Hãy chọn lại!";
                    rdCongBoQD.Focus();
                    return false;
                }
            }

            int lengthSQD = txtSoQD.Text.Trim().Length;
            if (lengthSQD == 0)
            {
                lbThongBaoQD.Text = "Bạn chưa nhập số quyết định!";
                txtSoQD.Focus();
                return false;
            }
            if (lengthSQD > 20)
            {
                lbThongBaoQD.Text = "Số quyết định không quá 20 ký tự. Hãy nhập lại!";
                txtSoQD.Focus();
                return false;
            }

            if (String.IsNullOrEmpty(txtNgayQD.Text))
            {
                lbThongBaoQD.Text = "Bạn chưa nhập ngày quyết định !";
                txtNgayQD.Focus();
                return false;
            }
            else
            {
                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbThongBaoQD.Text = "Bạn chưa nhập ngày quyết định theo định dạng (dd/MM/yyyy) !";
                    txtNgayQD.Focus();
                    return false;
                }

                DateTime NgayQD = DateTime.Parse(txtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                if (NgayQD > DateTime.Now)
                {
                    lbThongBaoQD.Text = "Ngày quyết định phải nhỏ hơn ngày hiện tại !";
                    txtNgayQD.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtSoQD.Text) && !String.IsNullOrEmpty(txtNgayQD.Text))
            {
                string so = txtSoQD.Text;

                DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "AHS", so, ngay, LoaiQD);

                if (CheckID > 0)
                {
                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHS", ngay, LoaiQD).ToString();
                    Decimal CurrID = (string.IsNullOrEmpty(hddidQD.Value)) ? 0 : Convert.ToDecimal(hddidQD.Value);
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
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                decimal VUANID = Convert.ToDecimal(current_id);
                if (!CheckValidQD() || !CheckCongbo(VUANID))
                    return;

                AHS_SOTHAM_QUYETDINH_VUAN oND;

                if (hddidQD.Value == "" || hddidQD.Value == "0")
                {
                    oND = new AHS_SOTHAM_QUYETDINH_VUAN();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddidQD.Value);
                    oND = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.DONVIID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                    {
                        lbThongBaoQD.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép thay đổi !";
                        return;
                    }
                }
                try
                {
                    oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                    DM_QD_QUYETDINH objQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).SingleOrDefault();
                    if (objQD != null)
                        oND.LOAIQDID = objQD.LOAIID;
                }
                catch (Exception ex)
                {
                    lbThongBaoQD.Text = ex.Message;
                }
                if (oND.LOAIQDID == 3)
                {
                    AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                    if (objAn != null)
                    {
                        objAn.NGAYSUA = DateTime.Now;
                        objAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                }

                decimal ThuLyID = Convert.ToDecimal(dropThuLyQD.SelectedValue);
                oND.THULYID = ThuLyID;

                oND.VUANID = VuAnID;
                oND.LOAIDONVI = 0;
                oND.DONVIID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.SOQUYETDINH = txtSoQD.Text;
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                //check chuc vu theo loai QĐ:
                if (oND.QUYETDINHID == 77 || oND.QUYETDINHID == 78)
                {
                    oND.NGUOIKYID = Convert.ToDecimal(ddlNguoiky.SelectedValue);
                    oND.CHUCVU = txtChucvu.Text;
                }
                else
                {
                    oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyTxtID.Value);
                    oND.CHUCVU = txtChucvu.Text;
                }
                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToaQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToaQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiemQD.Text.Trim();
                oND.LYDOID = pnLyDo.Visible ? oND.LYDOID = Convert.ToDecimal(ddlLydo.SelectedValue) : null;
                oND.ISCONGBOQD = rdCongBoQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongBoQD.SelectedValue);
                oND.HINHTHUCXETXU = 0; // Các quyết định gây kết thúc không có hình thức xét xử

                DM_QD_QUYETDINH oQDT = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).FirstOrDefault();
                oND.FILEID = oQDT != null ? UploadFileID(VuAnID, (hddidQD.Value == "" || hddidQD.Value == "0") ? 0 : (oND?.FILEID ?? 0), oQDT.MA) : (decimal?)null;

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
                catch (Exception ex)
                {
                    lbThongBaoQD.Text = ex.Message;
                }

                if (hddidQD.Value == "" || hddidQD.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_QUYETDINH_VUAN.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }

                dt.SaveChanges();

                if(oQDT.ISCONGBO == 1 && oND.HIEULUCTU != null)
                {
                    AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == VUANID).FirstOrDefault();

                    bool isnew = false;
                    var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {VuAnID} " +
                                                                            $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)} " +
                                                                            $"  AND CAPXETXU = {2} ");

                    BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                    if (temp_congbo == null)
                    {
                        isnew = true;
                        temp_congbo = new BAQD_CONGBO();
                    }

                    temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);
                    temp_congbo.CAPXETXU = 2;
                    temp_congbo.ISBA = 0;
                    temp_congbo.BAQDID = oND.ID;
                    temp_congbo.NGAYHIEULUC = oND.HIEULUCTU;
                    temp_congbo.MAVUAN = oDon.MAVUAN;
                    temp_congbo.VUVIECID = oND.VUANID.Value;

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

                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControl();

                Capnhat_AHS_TONGHOPHINHPHAT();

                lbThongBaoQD.Text = "Lưu thành công!";
                Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch (Exception ex)
            {
                lbThongBaoQD.Text = ex.Message;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            try
            {
                decimal VuAnID = Convert.ToDecimal(hddBanAnID.Value);

                DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
                DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID);

                if (oDT != null && oDT.Rows.Count > 0)
                {
                    Cls_Comon.SetButton(btnUpdate, false);
                }
                ResetControl();
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }
        public void xoa(decimal id)
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_SOTHAM_QUYETDINH_VUAN oND = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                if (oND.DONVIID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                {
                    lbThongBaoQD.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép xóa !";
                    return;
                }
                if (oND.LOAIQDID == 3)
                {
                    AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                    if (objAn != null)
                    {
                        objAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                        objAn.NGAYSUA = DateTime.Now;
                        objAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                }
                AHS_FILE file = dt.AHS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                if (file != null)
                {
                    dt.AHS_FILE.Remove(file);
                }
                dt.AHS_SOTHAM_QUYETDINH_VUAN.Remove(oND);
                dt.SaveChanges();
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {VuAnID} " +
                                                                    $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)} " +
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
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            ResetControl();
            lbThongBaoQD.Text = "Xóa thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        public void loadedit(decimal ID)
        {
            lbThongBaoQD.Text = "";

            AHS_SOTHAM_QUYETDINH_VUAN oND = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
            hddidQD.Value = oND.ID.ToString();
            dropThuLyQD.SelectedValue = dropThuLyBA.SelectedValue = oND.THULYID.ToString();

            ddlQuyetdinh.SelectedValue = oND.QUYETDINHID != null ? oND.QUYETDINHID.ToString() : "0";
            txtNgayMoPhienToaQD.Text = oND.NGAYMOPT != null ? ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul) : null;
            txtDiaDiemQD.Text = oND.DIADIEMMOPT + "";
            LoadLydo();
            ddlLydo.SelectedValue = oND.LYDOID != null && pnLyDo.Visible ? oND.LYDOID.ToString() : "0";

            rdCongBoQD.SelectedValue = oND.ISCONGBOQD != null ? oND.ISCONGBOQD.ToString() : null;

            DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == oND.NGUOIKYID).FirstOrDefault<DM_CANBO>();
            decimal qdID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            if (cbo != null)
            {
                //Check người ký theo loại QĐ:
                if (qdID == 77 || qdID == 78)
                {
                    ddlNguoiky.SelectedValue = oND.NGUOIKYID.ToString();
                    phNguoiKyDdl.Visible = true;
                    phNguoiKyTxt.Visible = false;
                }
                else
                {
                    txtNguoiKy.Text = cbo.HOTEN;
                    txtChucvu.Text = oND.CHUCVU;
                    phNguoiKyDdl.Visible = false;
                    phNguoiKyTxt.Visible = true;
                }
            }

            txtSoQD.Text = oND.SOQUYETDINH;
            txtNgayQD.Text = string.IsNullOrEmpty(oND.NGAYQD + "") ? "" : ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);
            txtHieulucTuNgay.Text = string.IsNullOrEmpty(oND.HIEULUCTU + "") ? "" : ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            txtHieuLucDenNgay.Text = string.IsNullOrEmpty(oND.HIEULUCDEN + "") ? "" : ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);

            List<AHS_SOTHAM_THULY> thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ToList();
            decimal THULYID = thuly[0].ID;
            if (oND.THULYID != THULYID)
            {
                Cls_Comon.SetButton(btnUpdate, false);
            }
            else
            {
                Cls_Comon.SetButton(btnUpdate, true);
            }
        }

        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                decimal VuAnID = Convert.ToDecimal(hddBanAnID.Value);
                DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();

                /*Quyết định HDXX phải có QĐ Đưa vụ án ra xét xử, còn lại không cần (Sở thẩm) 05/09/25 Y/c PhuongNM*/
                if ((oT.LOAIID == 2 /*Chuyển vụ án*/ ||
                    oT.TEN.Contains("cho Thẩm phán") ||
                    oT.ID == 422 /*19-VDS. Quyết định đình chỉ việc xét đơn yêu cầu giải quyết việc dân sự*/ ||
                    oT.LOAIID == 15) && oT.TEN.Contains("Hội đồng xét xử") == false/*Trả hồ sơ cho VKS*/)
                {
                    lbThongBaoQD.Text = "";
                    Cls_Comon.SetButton(btnUpdate, true);
                }
                else
                {
                    AHS_SOTHAM_QUYETDINH_VUAN QDST = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && x.LOAIQDID == 5 && x.QUYETDINHID != 147 && x.QUYETDINHID != 148 /*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/).OrderByDescending(x => x.NGAYQD).FirstOrDefault();
                    if (QDST == null)
                    {
                        lbThongBaoQD.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
                        Cls_Comon.SetButton(btnUpdate, false);
                        return;
                    }
                }

                if (ID == 77 || ID == 78 || ID == 206)
                {
                    // lấy số mới nhất
                    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DateTime ngayQD;
                    if (txtNgayQD.Text != "")
                        ngayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else
                        ngayQD = DateTime.Now;
                    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHS", ngayQD, ID).ToString();
                    txtSoQD.Text = STTNew;
                }
                //Đổi Người ký với các loại QĐ 39, 40
                if (ID == 77 || ID == 78)
                {
                    LoadNguoiKyDdlInfo();
                    phNguoiKyDdl.Visible = true;
                    phNguoiKyTxt.Visible = false;
                }
                else
                {
                    phNguoiKyDdl.Visible = false;
                    phNguoiKyTxt.Visible = true;
                }
                LoadLydo();

                //Check quyết định sửa chữa, bổ sung bản án
                CheckQuyen(VuAnID);
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");

                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = e.Item.Cells[10].Text.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }

                decimal QDID = Convert.ToDecimal(rowView["ID"].ToString());

                AHS_SOTHAM_QUYETDINH_VUAN qdva = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == QDID).FirstOrDefault();
                List<AHS_SOTHAM_THULY> thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ToList();
                decimal THULYID = thuly[0].ID;
                if (qdva.THULYID != THULYID)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                if (rowView["TENFILE"] + "" == "")
                {
                    lblDownload.Visible = false;
                }
                else
                {
                    lblDownload.Visible = true;
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                decimal VuAnID = Convert.ToDecimal(hddBanAnID.Value);

                switch (e.CommandName)
                {
                    case "DownloadQD":
                        AHS_SOTHAM_QUYETDINH_VUAN oND = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        break;
                    case "Sua":
                        LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                        if (lblSua.Text == "Sửa")
                        {
                            Cls_Comon.SetButton(btnUpdate, true);
                        }
                        else
                        {
                            Cls_Comon.SetButton(btnUpdate, false);
                        }
                        // 2/12/2025 vnpt check tong dat
                        AHS_SOTHAM_QUYETDINH_VUAN oND1 = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND1 != null)
                        {
                            AHS_TONGDAT oTD = dt.AHS_TONGDAT.Where(x => x.VUANID == oND1.VUANID && x.MAPID == oND1.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_SOTHAM_QUYETDINH_VUAN).FirstOrDefault();
                            if (oTD != null)
                            {
                                lbThongBaoQD.Text = "Bạn không thể sửa khi đã tống đạt!";
                                return;
                            }
                        }

                        loadedit(ND_id);

                        Capnhat_AHS_TONGHOPHINHPHAT();

                        hddidQD.Value = e.CommandArgument.ToString();
                        break;

                    case "Xoa":

                        AHS_SOTHAM_QUYETDINH_VUAN qdva = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ND_id).FirstOrDefault();
                        List<AHS_SOTHAM_THULY> thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ToList();
                        decimal THULYID = thuly[0].ID;
                        if (qdva.THULYID != THULYID)
                        {
                            lbThongBaoQD.Text = "Đã có thụ lý mới, bạn không có quyền xóa!";
                            return;
                        }

                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbThongBaoQD.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        if (hddIsSuaDoi.Value == "0")
                        {
                            lbThongBaoQD.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi!";
                            return;
                        }
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result != "")
                        {
                            lbThongBaoQD.Text = Result;
                            return;
                        }
                        // 2/12/2025 vnpt check tong dat
                        AHS_TONGDAT oTD1 = dt.AHS_TONGDAT.Where(x => x.VUANID == qdva.VUANID && x.MAPID == qdva.ID && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_SOTHAM_QUYETDINH_VUAN).FirstOrDefault();
                        if (oTD1 != null)
                        {
                            lbThongBaoQD.Text = "Bạn không thể xóa khi đã tống đạt!";
                            return;
                        }
                        bool isCongbo = CheckCongbo(VuAnID);
                        if (!isCongbo)
                        {
                            lbThongBaoQD.Text = "Vụ việc đã có thông tin công bố. Không được xóa.";
                            return;
                        }
                        xoa(ND_id);

                        Capnhat_AHS_TONGHOPHINHPHAT();

                        break;
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }
        public void LoadGrid()
        {
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, ID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndataQD.Visible = true;
            }
            else
            {
                pndataQD.Visible = false;
            }
        }

        private decimal UploadFileID(decimal VuAnID, decimal FileID, string strMaBieumau)
        {
            decimal IDFIle = 0, IDBM = 0;
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVuAn != null)
            {
                List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
                if (lstBM.Count > 0)
                {
                    IDBM = lstBM[0].ID;
                }
                bool isNew = false;
                //vnpt chinh luu file  4/12/2025
                //AHS_FILE objFile = dt.AHS_FILE.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && x.BIEUMAUID == IDBM).FirstOrDefault();
                AHS_FILE objFile = new AHS_FILE();
                if (FileID > 0)
                {
                    isNew = false;
                    objFile = dt.AHS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
                }
                else
                {
                    isNew = true;
                    objFile = new AHS_FILE();
                }
                objFile.VUANID = VuAnID;
                objFile.TOAANID = oVuAn.TOAANID;
                objFile.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                objFile.LOAIFILE = 0;
                objFile.BIEUMAUID = IDBM;
                objFile.NAM = DateTime.Now.Year;
                objFile.NGAYTAO = DateTime.Now;
                objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (hddFilePathQD.Value != "")
                {
                    try
                    {
                        string strFilePath = "";

                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            objFile.NOIDUNG = buff;
                            objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            objFile.KIEUFILE = oF.Extension;
                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
                }
                if (isNew)
                {
                    dt.AHS_FILE.Add(objFile);
                }
                dt.SaveChanges();
                IDFIle = objFile.ID;
            }
            return IDFIle;
        }
        protected void AsyncFileUpLoad_UploadedCompleteQD(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoadQD.HasFile)
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
                    else
                        lbThongBaoQD.Text = "chỉ lưu file .doc";
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = "Lỗi: " + ex.Message; }
        }

        #endregion

        void LoadDropThuLy()
        {
            try
            {
                dropThuLyBA.Items.Clear();
                dropThuLyQD.Items.Clear();
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                AHS_SOTHAM_THULY_BL obj = new AHS_SOTHAM_THULY_BL();
                DataTable tbl = obj.GetByVuAnID(VuAnID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string SoThuLy = "", THThuLy = "", NgayThuLy = "";
                    string temp = "";
                    int count_item = tbl.Rows.Count;
                    if (count_item > 1)
                    {
                        dropThuLyBA.Items.Add(new ListItem("---Chọn---", "0"));
                        dropThuLyQD.Items.Add(new ListItem("---Chọn---", "0"));
                        foreach (DataRow row in tbl.Rows)
                        {
                            SoThuLy = row["SoThuLy"] + "";
                            THThuLy = row["TruongHopThuLy"] + "";
                            NgayThuLy = Convert.ToDateTime(row["NgayThuLy"] + "").ToString("dd/MM/yyyy", cul);
                            temp = SoThuLy + " - " + THThuLy + " - " + NgayThuLy;
                            dropThuLyBA.Items.Add(new ListItem(temp, row["ID"] + ""));
                            dropThuLyQD.Items.Add(new ListItem(temp, row["ID"] + ""));
                        }
                    }
                    else
                    {
                        DataRow row = tbl.Rows[0];
                        SoThuLy = row["SoThuLy"] + "";
                        THThuLy = row["TruongHopThuLy"] + "";
                        NgayThuLy = Convert.ToDateTime(row["NgayThuLy"] + "").ToString("dd/MM/yyyy", cul);
                        temp = SoThuLy + " - " + THThuLy + " - " + NgayThuLy;
                        dropThuLyBA.Items.Add(new ListItem(temp, row["ID"] + ""));
                        dropThuLyQD.Items.Add(new ListItem(temp, row["ID"] + ""));

                        hddNgayThuLy.Value = NgayThuLy;
                    }
                }
                else
                {
                    dropThuLyBA.Items.Add(new ListItem("---Chọn---", "0"));
                    dropThuLyQD.Items.Add(new ListItem("---Chọn---", "0"));
                    lttMsgBanAn.Text = lbThongBaoQD.Text = "Vụ việc chưa được thụ lý. Hãy kiểm tra lại !";

                    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                    Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                    Cls_Comon.SetButton(cmdHuyBanAn, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    Cls_Comon.SetButton(btnUpdate, false);
                }

                List<AHS_SOTHAM_THULY> tl = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ToList();
                if (tl.Count > 0)
                {
                    decimal THULYID = tl[0].ID;

                    dropThuLyBA.SelectedValue = THULYID.ToString();
                    dropThuLyQD.SelectedValue = THULYID.ToString();
                }
            }
            catch (Exception Ex)
            {

            }
        }
        protected void dropThuLyBA_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropThuLyQD.SelectedValue = dropThuLyBA.SelectedValue;
            dropThuLy();
        }
        protected void dropThuLyQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropThuLyBA.SelectedValue = dropThuLyQD.SelectedValue;
            dropThuLy();
        }

        protected void dropThuLy()
        {
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            decimal THULYID = Convert.ToDecimal(dropThuLyBA.SelectedValue);

            //Nếu đã có Bản án hoặc Quyết định gây kết thúc gán theo thụ lý thì không cho nhập
            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID, THULYID);

            AHS_SOTHAM_THULY oTHULY = dt.AHS_SOTHAM_THULY.Where(x => x.ID == THULYID).FirstOrDefault();

            if (dropThuLyBA.SelectedValue == "0")
            {
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                Cls_Comon.SetButton(btnUpdate, false);
            }
            else if (oDT.Rows.Count == 0)
            {
                Cls_Comon.SetButton(cmdLammoi, true);
                Cls_Comon.SetButton(btnUpdate, true);

                //Kiểm tra xem đã có quyết định đưa vụ việc ra xét xử hay không
                List<AHS_SOTHAM_QUYETDINH_VUAN> lst = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && x.LOAIQDID == 5 && x.THULYID == THULYID).ToList();
                if (lst == null || lst.Count == 0)
                {
                    Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                    Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                    Cls_Comon.SetButton(cmdHuyBanAn, false);
                }
                else
                {
                    Cls_Comon.SetButton(cmdUpdateBanAnST, true);
                    Cls_Comon.SetButton(cmdUpdateAnPhi, true);
                    Cls_Comon.SetButton(cmdHuyBanAn, true);
                }
            }
            else
            {
                Cls_Comon.SetButton(cmdUpdateBanAnST, false);
                Cls_Comon.SetButton(cmdUpdateAnPhi, false);
                Cls_Comon.SetButton(cmdHuyBanAn, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                Cls_Comon.SetButton(btnUpdate, false);
            }

            if (dropThuLyBA.SelectedValue != "0")
            {
                string TH_ThuLy = dropThuLyBA.SelectedItem.Text;
                String[] arrThuly = TH_ThuLy.Split('-');
                foreach (String item in arrThuly)
                {
                    if (item.Length > 0)
                        hddNgayThuLy.Value = item;
                }
            }
        }


        private void Capnhat_AHS_TONGHOPHINHPHAT()
        {
            try
            {
                AHS_TONGHOPHINHPHAT saveTHHP = new AHS_TONGHOPHINHPHAT();

                List<AHS_BICANBICAO> lstTL = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_BICANBICAO>();
                foreach (var item in lstTL)
                {
                    if (!saveTHHP.Capnhat_Tonghophinhphat_byVuanAndBicanid(2, VuAnID, item.ID, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Session[ENUM_SESSION.SESSION_USERNAME] + ""))
                    {
                        lttMsgBanAn.Text = lbThongBaoQD.Text = "Lỗi Tổng hợp hình phạt!" + "(" + item.HOTEN + ")";
                        return;
                    }
                }
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                lttMsgBanAn.Text = lbThongBaoQD.Text = "Lỗi Tổng hợp hình phạt!";
                return;
            }
        }
        protected void LoadRdKhongBoSungDuoc()
        {
            if (rdToaAn_XacMinh.SelectedValue == "1")
            {
                rdKhongBoSungDuoc.Visible = true;
            }
            else
                rdKhongBoSungDuoc.Visible = false;
        }
        protected void rdToaAn_XacMinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadRdKhongBoSungDuoc();
        }

        protected void LoadRdLuatSu()
        {
            var VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            var data = (from a in dt.AHS_NGUOITHAMGIATOTUNG
                        join b in dt.AHS_NGUOITHAMGIATOTUNG_TUCACH on a.ID equals b.NGUOIID
                        select new
                        {
                            a.ID,
                            a.VUANID,
                            b.TUCACHID
                        })
                       .Where(x => x.VUANID == VuAnID)
                       .ToList();
            if (data.Where(x => x.TUCACHID == 127).Count() > 0)
                rdLuatSu.SelectedValue = "1";
            else
                rdLuatSu.SelectedValue = "0";
        }

        protected void LoadRdNguoiBaoChuaKhac()
        {
            var VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            var data = (from a in dt.AHS_NGUOITHAMGIATOTUNG
                        join b in dt.AHS_NGUOITHAMGIATOTUNG_TUCACH on a.ID equals b.NGUOIID
                        select new
                        {
                            a.ID,
                            a.VUANID,
                            b.TUCACHID
                        })
                       .Where(x => x.VUANID == VuAnID)
                       .ToList();
            if (data.Where(x => x.TUCACHID == 123 || x.TUCACHID == 130 || x.TUCACHID == 549).Count() > 0)
                rdNguoiBaochuaKhac.SelectedValue = "1";
            else
                rdNguoiBaochuaKhac.SelectedValue = "0";
        }

        protected void rdToaAnApDungBaoVe_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdToaAnApDungBaoVe.SelectedValue == "1")
            {
                pnBPBV.Enabled = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtSoBiHai.ClientID);
            }
            else
            {
                pnBPBV.Enabled = false;
                txtSoBiHai.Text = "0";
            }
        }

        protected int TongSoBiHai()
        {
            var VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            var data = (from a in dt.AHS_NGUOITHAMGIATOTUNG
                        join b in dt.AHS_NGUOITHAMGIATOTUNG_TUCACH on a.ID equals b.NGUOIID
                        select new
                        {
                            a.ID,
                            a.VUANID,
                            b.TUCACHID
                        })
                       .Where(x => x.VUANID == VuAnID)
                       .ToList();
            int count = 0;
            foreach (var item in data)
            {
                if (item.TUCACHID == 122) count++;
            }
            return count;
        }

        private bool CheckChuaChonTDC()
        {
            var VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            var data = (from a in dt.AHS_BICANBICAO
                        join b in dt.AHS_SOTHAM_CAOTRANG_DIEULUAT on a.ID equals b.BICANID
                        select new
                        {
                            a.ID,
                            b.ISMAIN,
                            b.VUANID
                        })
                       .Where(x => x.VUANID == VuAnID)
                       .GroupBy(x => new { x.ID, x.ISMAIN })
                       .ToList();
            var check = data
                .GroupBy(x => x.Key.ID)
                .Any(g => g.All(x => x.Key.ISMAIN == 0));

            return check;
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDsBiCao_AnPhi();
            }
            catch (Exception ex) { lttMsgAnPhi.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsBiCao_AnPhi();
            }
            catch (Exception ex) { lttMsgAnPhi.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDsBiCao_AnPhi();
            }
            catch (Exception ex) { lttMsgAnPhi.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDsBiCao_AnPhi();
            }
            catch (Exception ex) { lttMsgAnPhi.Text = ex.Message; }
        }

        protected void rdXuLyVatChung_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdXuLyVatChung.SelectedValue == "1")
            {
                pnXLVC.Enabled = true;
                Cls_Comon.SetFocus(this, this.GetType(), txtSoBiCao.ClientID);
            }
            else
            {
                pnXLVC.Enabled = false;
                txtSoBiCao.Text = "0";
            }
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDsBiCao_AnPhi();
            }
            catch (Exception ex) { lttMsgAnPhi.Text = ex.Message; }
        }
        #endregion

        #region GTEL-DUCPH CN: 13/09/2025 thêm xử lý khi nhập ngày nhận thì enable hay không ngày hiệu lực
        protected void txtNgaynhanbanan_TextChanged(object sender, EventArgs e)
        {
            if (isFocus) return;
            TextBox txtNgaynhanban = sender as TextBox;
            string ngayNhanBanAn = txtNgaynhanban.Text;
            // Lấy RepeaterItem chứa nó
            RepeaterItem item = (RepeaterItem)txtNgaynhanban.NamingContainer;

            // Từ item này, tìm TextBox khác cùng hàng
            TextBox txtNgayHieuLuc = (TextBox)item.FindControl("txtNgayHieuLuc");
            if (!string.IsNullOrEmpty(ngayNhanBanAn))
            {
                // Kiểm tra xem bị can đã được gán hình phạt chưa
                HiddenField hddBiCao = (HiddenField)item.FindControl("hddBiCao");
                decimal vBicaoID = Convert.ToDecimal(hddBiCao.Value);
                AHS_TONGHOPHINHPHAT tonghophinhphat = DataExtensions.GetAllWithClause<AHS_TONGHOPHINHPHAT>($"VUANID= {VuAnID} AND BICAOID = {vBicaoID}").FirstOrDefault();
                string hinhPhatTongHopSt = string.Empty;
                if (tonghophinhphat != null) hinhPhatTongHopSt = tonghophinhphat.Tonghophinhphat_ST(VuAnID, vBicaoID);
                if (string.IsNullOrEmpty(hinhPhatTongHopSt)) txtNgayHieuLuc.Enabled = false;
                else
                {
                    txtNgayHieuLuc.Enabled = true;
                    if (IsPostBack)
                        txtNgayHieuLuc.Focus();
                }
            }
            else txtNgayHieuLuc.Enabled = false;


        }
        #endregion

        protected bool Visible_BTN_DieuLuatApDung(object val)
        {
            Decimal ID = Convert.ToDecimal(val);
            Decimal ThuLyID = Convert.ToDecimal(dropThuLyBA.SelectedValue);
            VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            var qdDCBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.BICANID == ID && x.THULYID == ThuLyID && x.VUANID == VuAnID);
            var dm_QDDC = dt.DM_QD_QUYETDINH.Where(x => x.MA == "39-HS" || x.MA == "40-HS");
            var result = from a in qdDCBC
                         join b in dm_QDDC on a.QUYETDINHID equals b.ID
                         select a;
            if (result != null && result.Count() > 0)
                return false;
            return true;
        }
        
        protected void capnhat_baqd_congbo(decimal VuAnId, decimal bananid)
        {
            AHS_VUAN oDon = dt.AHS_VUAN.Where(x => x.ID == VuAnId).FirstOrDefault();
            CONGBO_BL CB_BL = new CONGBO_BL();
            DataTable Ngayhieuluc_BAST = CB_BL.GET_NGAYHIEULUC_BANAN_HINHSU_SOTHAM(bananid);
            DateTime? _ngayHieuLuc = null;
            if (Ngayhieuluc_BAST != null)
            {
                if (Ngayhieuluc_BAST.Rows.Count > 0 && Ngayhieuluc_BAST.Rows[0]["NGAYHIEULUCBANAN"] != DBNull.Value)
                {
                    _ngayHieuLuc = Convert.ToDateTime(Ngayhieuluc_BAST.Rows[0]["NGAYHIEULUCBANAN"]);
                }
            }
            if (_ngayHieuLuc != null)
            {
                bool isnew = false;
                var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {VuAnID} " +
                                                                        $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)} " +
                                                                        $"  AND CAPXETXU = {2} ");

                BAQD_CONGBO temp_congbo = list?.FirstOrDefault();
                if (temp_congbo == null)
                {
                    isnew = true;
                    temp_congbo = new BAQD_CONGBO();
                }

                temp_congbo.LOAIANID = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);
                temp_congbo.CAPXETXU = 2;
                temp_congbo.ISBA = 1;
                temp_congbo.BAQDID = bananid;
                temp_congbo.NGAYHIEULUC = _ngayHieuLuc;
                temp_congbo.MAVUAN = oDon.MAVUAN;
                temp_congbo.VUVIECID = VuAnId;

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
            else
            {
                var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>($"  VUVIECID = {VuAnID} " +
                                                        $"  AND LOAIANID = {Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)} " +
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
            }    
        }
    }
}

