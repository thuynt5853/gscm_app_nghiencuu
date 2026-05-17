using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.AHS;
using BL.GSTP.Danhmuc;
using DAL.DKK;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.PhucThamQDK
{
    public partial class KetQuaGiaiQuyet : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        private DKKContextContainer dkk = new DKKContextContainer();
        private Decimal ToaAnID = 0;
        private const decimal BANAN = 1, QUYETDINH = 2;
        public decimal VuAnID = 0;
        public decimal VuAnIDST = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            AHS_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
            VuAnIDST = _chuyenNhanBl.getDonIdOld(VuAnID);
            if (VuAnID > 0)
            {
                ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                if (!IsPostBack)
                {
                    //hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    hddVuAnID.Value = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? "" : Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    //if (!String.IsNullOrEmpty(txtNgayBanAn.Text))
                    //    SetNewSoQD();
                    CheckQuyen();
                    LoadQD();
                    LoadGrid();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }

        private void CheckQuyen()
        {
            hddShowCommand.Value = "True";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
            decimal VUANID = Convert.ToDecimal(hddVuAnID.Value);
            bool IsUpdateThuLyPT = true;
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VUANID).FirstOrDefault();
            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbThongBaoQD.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            if (oT != null)
            {
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    IsUpdateThuLyPT = false;
                }
            }
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VUANID, "Không được sửa đổi thông tin.", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbThongBaoQD.Text = Result;
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            List<AHS_KCKNQDK_PHUCTHAM_THULY> lstCount = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_THULY>($"VUANID = {VUANID}").ToList();
            if (lstCount.Count == 0)
            {
                IsUpdateThuLyPT = false;
            }
            if (!IsUpdateThuLyPT)
            {
                lbThongBaoQD.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            if (!Check_Phancongthamphan())
            {
                lbThongBaoQD.Text = "Vụ việc chưa được phân công thẩm phán. Đề nghị cập nhật thông tin 'Phân công thẩm phán giải quyết' !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            //if (quyetDinhId == 127 || quyetDinhId == 203)
            //{
            //    Cls_Comon.SetButton(btnUpdate, true);
            //    Cls_Comon.SetButton(cmdLammoi, true);
            //    lbThongBaoQD.Text = "";
            //    return;
            //}

            List<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN> lstQD = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>("VUANID = " + VUANID + " AND (LOAIQDID IN (21,3) OR QUYETDINHID IN (127,203,324))");
            if (lstQD.Count >= 1)
            {
                Cls_Comon.SetButton(btnUpdate, false);
            }
            /*Nếu chưa nhập quyết định đưa vụ án ra xét xử thì không cho nhập bản án*/
            //AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oQD = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>($"VUANID = {VUANID} AND LOAIQDID = 5 AND QUYETDINHID = 82").FirstOrDefault();/*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/
            //if (oQD == null)
            //{
            //    lbThongBaoQD.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
            //    Cls_Comon.SetButton(btnUpdate, false);
            //    Cls_Comon.SetButton(cmdLammoi, false);
            //    // hddShowCommand.Value = "False";
            //    return;
            //}
            //else
            //{
            //    lbThongBaoQD.Text = "";
            //    Cls_Comon.SetButton(btnUpdate, true);
            //    Cls_Comon.SetButton(cmdLammoi, true);
            //    // hddShowCommand.Value = "False";
            //    return;
            //}
        }

        private void SetNewSoQD()
        {
            DateTime ngay = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHS", ngay, LoaiQD).ToString();
            txtSoQD.Text = STTNew;
        }

        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        {
            SetNewSoQD();
        }

        private Boolean Check_Phancongthamphan()
        {
            try
            {
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                List<AHS_KCKNQDK_PHUCTHAM_HDXX> lst = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_HDXX>($"VUANID = {VuAnID} AND MAVAITRO = '{ENUM_NGUOITIENHANHTOTUNG.THAMPHAN}'").ToList();

                if (lst != null && lst.Count > 0)
                    return true;
                else
                    return false;
            }
            catch { return false; }
        }

        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            try
            {
                //decimal ID = Convert.ToDecimal(hddID.Value);
                //AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND = DataExtensions.GetAllWithClause < AHS_KCKNQDK_PHUCTHAM_BANAN.Where(x => x.ID == ID).FirstOrDefault();
                //if (oND.TENFILE != "")
                //{
                //    var cacheKey = Guid.NewGuid().ToString("N");
                //    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                //}
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }

        private void ResetControl()
        {
            //SetNewSoQDnAn();
            txtNgayMoPhienToa.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            hddID.Value = "0";
            //Thông tin quyết định
            txtLydo.Text = null;
            txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            ddlQuyetdinh.SelectedIndex = 0;
            ddlLydo.SelectedIndex = 0;
            ddlLydo_BM03.SelectedIndex = 0;
            pnLyDo.Visible = false;
            pnLyDo_BM03.Visible = false;
            pntxtLydo.Visible = false;
            txtSoQD.Text = txtHieulucTuNgay.Text = txtHieuLucDenNgay.Text = "";
            hddFilePathQD.Value = "";

            if (pnKetquaPhuctham.Visible == true)
            {
                ddlKetquaQuyetdinh.SelectedIndex = 0;
                if (pnLyDoKetquaPhuctham.Visible == true)
                {
                    ddlLydoQuyetdinh.SelectedIndex = 0;
                }
            }
        }

        #region HIEUVM Thông tin quyết định

        private void LoadQD()
        {
            //Load Tên quyết định PKG_LOAD_DM_QDVUAN_KETTHUC
            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable oDT = oBL.AHS_DM_QUYETDINHKETQUA_VUAN_PTTDC();

            if (oDT != null)
            {
                ddlQuyetdinh.DataSource = oDT;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }

            //ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlQuyetdinh.SelectedIndex = 0;
            ddlQuyetdinh_SelectedIndexChanged(new object(), new EventArgs());
            //if (ddlQuyetdinh.SelectedItem.Text == "46-HS. Quyết định giải quyết việc kháng cáo, kháng nghị đối với Quyết định tạm đình chỉ (đình chỉ) vụ án")
            //{
            //    pnKetquaPhuctham.Visible = true;
            //    LoadDropKetQuaQuyetdinhPhuctham();
            //}

            //LoadLydo();
            //LoadHTXX();
        }

        private void LoadHTXX()
        {
            //HienthiCBBkhichonquyetdinh(20-HS).
            if (ddlQuyetdinh.SelectedItem.Text.Contains("20-HS"))
            {
                ddlHTXX.SelectedIndex = 0;
                pnHinhThucXetXu.Visible = true;
                pnHinhThucXetXu.Enabled = true;
            }
            else
            {
                //ddlHTXX.SelectedItem.Value = null;
                ddlHTXX.SelectedIndex = 0;
                pnHinhThucXetXu.Visible = false;
                pnHinhThucXetXu.Enabled = false;
            }
        }

        private void LoadLydo()
        {
            ddlLydo.Items.Clear(); ddlLydo_BM03.Items.Clear();
            decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            List<DM_QD_QUYETDINH_LYDO> lst = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.QDID == ID & x.HIEULUC == 1).OrderBy(y => y.THUTU).ToList();

            if (ddlQuyetdinh.SelectedItem.Text.Contains("03-HS"))
            {
                LoadNguoiDuocPhanCong();
                LoadNguoiBiThayDoi();
                pnLyDo_BM03.Visible = true;
                pnLyDo.Visible = false;
                pntxtLydo.Visible = false;
            }
            else if (ddlQuyetdinh.Text == "201" || ddlQuyetdinh.Text == "202")
            {
                pnLyDo.Visible = false;
                pntxtLydo.Visible = true;
                pnLyDo_BM03.Visible = false;
                lbtxtLydo.InnerText = "Lý do";
            }
            else if (lst != null && lst.Count > 0)
            {
                pnLyDo.Visible = true;
                pnLyDo_BM03.Visible = false;
                pntxtLydo.Visible = false;
            }
            else
            {
                pnLyDo_BM03.Visible = false;
                pnLyDo.Visible = false;
                pntxtLydo.Visible = false;
            }

            ddlLydo.DataSource = ddlLydo_BM03.DataSource = lst;
            ddlLydo.DataTextField = ddlLydo_BM03.DataTextField = "TEN";
            ddlLydo.DataValueField = ddlLydo_BM03.DataValueField = "ID";
            ddlLydo.DataBind(); ddlLydo_BM03.DataBind();

            ddlLydo.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlLydo.SelectedIndex = 0;
            ddlLydo_BM03.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlLydo_BM03.SelectedIndex = 0;
        }

        private void LoadNguoiDuocPhanCong()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            ddlNguoiDuocPC.Items.Clear();
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            string tucach = ddlThayDoi.SelectedValue == "1" ? "TP" : (ddlThayDoi.SelectedValue == "2" ? "HTND" : "THUKY");
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable tbl = objBL.DMCANBO_DUOCPC_BM03HS_ST(ToaAnID, VuAnID, tucach);
            if (tbl.Rows.Count > 0)
            {
                ddlNguoiDuocPC.DataSource = tbl;
                ddlNguoiDuocPC.DataTextField = "MA_TEN";
                ddlNguoiDuocPC.DataValueField = "ID";
                ddlNguoiDuocPC.DataBind();
            }
            else
            {
                ddlNguoiDuocPC.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }

        private void LoadNguoiBiThayDoi()
        {
            ddlNguoiBiThayDoi.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            string tucach = ddlThayDoi.SelectedValue == "1" ? "TP" : (ddlThayDoi.SelectedValue == "2" ? "HTND" : "THUKY");
            DataTable tbl = objBL.DMCANBO_NGUOIBITHAYDOI_TCTT_ST(VuAnID, tucach);
            if (tbl.Rows.Count > 0)
            {
                ddlNguoiBiThayDoi.DataSource = tbl;
                ddlNguoiBiThayDoi.DataTextField = "HOTEN";
                ddlNguoiBiThayDoi.DataValueField = "CANBOID";
                ddlNguoiBiThayDoi.DataBind();
            }
            else
            {
                ddlNguoiBiThayDoi.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }

        private void LoadNguoiKyDdlInfo()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            DataTable tbl = null;
            decimal CanBoID = 0;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();

            //Lấy danh sách Chánh án, phó chánh án
            tbl = cb_BL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            //Lấy chủ tọa vụ án
            AHS_KCKNQDK_PHUCTHAM_HDXX oND = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_HDXX>($"VUANID = {VuAnID} AND MAVAITRO = '{ENUM_NGUOITIENHANHTOTUNG.THAMPHAN}'").FirstOrDefault();
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
                AHS_THAMPHANGIAIQUYET oTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).FirstOrDefault();
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

        private void LoadNguoiKyTxtInfo()
        {
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            AHS_KCKNQDK_PHUCTHAM_HDXX oND = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_HDXX>($"VUANID = {DonID} AND MAVAITRO = '{ENUM_NGUOITIENHANHTOTUNG.THAMPHAN}'").FirstOrDefault<AHS_KCKNQDK_PHUCTHAM_HDXX>();
            if (oND != null)
            {
                decimal CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());
                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    txtNguoiKyQDVV.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                    txtChucvu.Text = "Thẩm phán chủ tọa";
                    hddNguoiKyTxtID.Value = dtCanBo.Rows[0]["ID"].ToString();
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
                        txtNguoiKyQDVV.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                        txtChucvu.Text = "Thẩm phán giải quyết";
                        hddNguoiKyTxtID.Value = dtCanBo.Rows[0]["ID"].ToString();
                    }
                }
                else
                    txtNguoiKyQDVV.Text = txtChucvu.Text = "";
            }
        }

        private bool CheckValid()
        {
            if (rdCongBoQD.SelectedValue == "")
            {
                lbThongBaoQD.Text = "Bạn chưa chọn có công bố quyết định. Hãy chọn lại!";
                rdCongBoQD.Focus();
                return false;
            }
            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbThongBaoQD.Text = "Bạn chưa chọn quyết định!";
                ddlQuyetdinh.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayMoPhienToa.Text) == false)
            {
                lbThongBaoQD.Text = "Chưa nhập ngày mở phiên toà hoặc không hợp lệ !";
                txtNgayMoPhienToa.Focus();
                return false;
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
            if (!String.IsNullOrEmpty(txtNgayQD.Text))
            {
                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbThongBaoQD.Text = "Chưa nhập ngày quyết định hoặc không hợp lệ !";
                    txtNgayQD.Focus();
                    return false;
                }
            }
            //----------------------------
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
            if (ddlQuyetdinh.SelectedItem.Text == "46-HS. Quyết định giải quyết việc kháng cáo, kháng nghị đối với Quyết định tạm đình chỉ (đình chỉ) vụ án")
            {
                if (ddlKetquaQuyetdinh.SelectedValue == "0")
                {
                    lbThongBaoQD.Text = "Bạn chưa chọn kết quả phúc thẩm. Hãy chọn lại!";
                    ddlKetquaQuyetdinh.Focus();
                    return false;
                }
                if (ddlLydoQuyetdinh.SelectedValue == "0" && ddlKetquaQuyetdinh.SelectedValue != "101")
                {
                    lbThongBaoQD.Text = "Bạn chưa chọn lý do. Hãy chọn lại!";
                    ddlLydoQuyetdinh.Focus();
                    return false;
                }
            }
            return true;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND;
                if (hddidQD.Value == "" || hddidQD.Value == "0")
                    oND = new AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN();
                else
                {
                    decimal ID = Convert.ToDecimal(hddidQD.Value);
                    oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>(ID);
                    if (oND.DONVIID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                    {
                        lbThongBaoQD.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép thay đổi !";
                        return;
                    }
                }
                oND.VUANID = VuAnID;
                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();
                //--------------------------------
                try
                {
                    oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                    DM_QD_QUYETDINH objQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).SingleOrDefault();
                    if (objQD != null)
                        oND.LOAIQDID = objQD.LOAIID;
                }
                catch (Exception exx) { }
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

                        #endregion Lưu file

                        File.Delete(strFilePath);
                    }
                }
                catch { }
                set_valueLydo(oND);

                if (pnLyDo_BM03.Visible)
                {
                    oND.LYDOID = Convert.ToDecimal(ddlLydo_BM03.SelectedValue);
                    // Update Người tiến hành tố tụng
                    decimal CanBoBiThay = Convert.ToDecimal(ddlNguoiBiThayDoi.SelectedValue),
                        CanBoDuocPC = Convert.ToDecimal(ddlNguoiDuocPC.SelectedValue);
                    if (CanBoBiThay > 0)
                    {
                        AHS_KCKNQDK_PHUCTHAM_HDXX hdxx = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_HDXX>($"VUANID = {VuAnID} AND CANBOID = {CanBoBiThay}").FirstOrDefault();
                        if (hdxx != null)
                        {
                            hdxx.ISTHAYDOI = 1;
                            bool isNew = false;
                            AHS_KCKNQDK_PHUCTHAM_HDXX obj = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_HDXX>($"VUANID = {VuAnID} AND CANBOID = {CanBoDuocPC}").FirstOrDefault();
                            if (obj == null)
                            {
                                isNew = true;
                                obj = new AHS_KCKNQDK_PHUCTHAM_HDXX();
                            }
                            obj.CANBOID = CanBoDuocPC;
                            obj.DUKHUYET = hdxx.DUKHUYET;
                            obj.FILEID = hdxx.FILEID;
                            obj.MAVAITRO = hdxx.MAVAITRO;
                            obj.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            obj.NGAYPHANCONG = obj.NGAYQD;
                            obj.NGUOIPHANCONGID = hdxx.NGUOIPHANCONGID;
                            obj.SOQD = txtSoQD.Text;
                            obj.VUANID = VuAnID;
                            obj.NGAYTAO = DateTime.Now;
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            if (isNew)
                            {
                                if (obj.TOA_GIAIQUYET_ID == null)
                                {
                                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                }
                                DataExtensions.Insert(obj);
                            }
                            dt.SaveChanges();
                        }
                    }
                    oND.THAYDOITCTT = Convert.ToDecimal(ddlThayDoi.SelectedValue);
                    oND.NGUOIDUOCPHANCONG = Convert.ToDecimal(ddlNguoiDuocPC.SelectedValue);
                    oND.NGUOIBITHAY = Convert.ToDecimal(ddlNguoiBiThayDoi.SelectedValue);
                }
                oND.LOAIDONVI = 0;
                oND.DONVIID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.SOQUYETDINH = txtSoQD.Text;
                oND.ISCONGBOQD = rdCongBoQD.SelectedValue == "" ? 0 : Convert.ToDecimal(rdCongBoQD.SelectedValue);

                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (ddlKetquaQuyetdinh.Visible == true)
                {
                    oND.KETQUAID = Convert.ToDecimal(ddlKetquaQuyetdinh.SelectedValue);
                }
                else
                {
                    oND.KETQUAID = null;
                }

                if (ddlQuyetdinh.SelectedItem.Text == "46-HS. Quyết định giải quyết việc kháng cáo, kháng nghị đối với Quyết định tạm đình chỉ (đình chỉ) vụ án")
                {
                    oND.KETQUAID = Convert.ToDecimal(ddlKetquaQuyetdinh.SelectedValue);
                    if (ddlKetquaQuyetdinh.SelectedValue != "0" && ddlKetquaQuyetdinh.SelectedValue != "101")
                    {
                        oND.LYDOKETQUAID = Convert.ToDecimal(ddlLydoQuyetdinh.SelectedValue);
                    }
                    else
                    {
                        oND.LYDOKETQUAID = 0;
                    }
                }

                DM_QD_QUYETDINH oQDT = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).FirstOrDefault();
                if (oQDT != null)
                {
                    oND.FILEID = UploadFileID(VuAnID, oQDT.MA);
                }
                //check chuc vu theo loai QĐ:
                if (oND.QUYETDINHID == 201 || oND.QUYETDINHID == 202 || oND.QUYETDINHID == 77 || oND.QUYETDINHID == 78 || oND.QUYETDINHID == 161 || oND.QUYETDINHID == 162 || oND.QUYETDINHID == 163)
                {
                    oND.NGUOIKYID = Convert.ToDecimal(ddlNguoiky.SelectedValue);
                    oND.CHUCVU = ddlNguoiky.SelectedValue;
                }
                else
                {
                    oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyTxtID.Value);
                    oND.CHUCVU = txtChucvu.Text;
                }

                if (hddidQD.Value == "" || hddidQD.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    DataExtensions.Insert(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Update(oND);
                }

                if (oND.LOAIQDID == 3)
                {
                    // update giai đoạn vụ án = sotham
                    AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                    if (objAn != null)
                    {
                        objAn.NGAYSUA = DateTime.Now;
                        objAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                }

                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControl();
                lbThongBaoQD.Text = "Lưu thành công!";
                //Page.Response.Redirect(Page.Request.Url.ToString(), true);
            }
            catch (Exception ex)
            {
                lbThongBaoQD.Text = ex.Message;
            }
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
                    else lbThongBaoQD.Text = "chỉ lưu file .doc";
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = "Lỗi: " + ex.Message; }
        }

        public void LoadGrid()
        {
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, ID);
            if (oDT != null)
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

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            try
            {
                pnHinhThucXetXu.Visible = false;
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                List<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN> lstQD = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>($"VUANID = {VuAnID} AND (LOAIQDID IN (10,3,15) OR QUYETDINHID IN (423,422,204,205) )").ToList();
                //(x => x.VUANID == VuAnID && (x.LOAIQDID == 10 || x.QUYETDINHID == 423 || x.QUYETDINHID == 422 || x.LOAIQDID == 3 || x.LOAIQDID == 15 || x.QUYETDINHID != 204 || x.QUYETDINHID != 205)).ToList();
                if (lstQD.Count >= 1)
                {
                    Cls_Comon.SetButton(btnUpdate, false);
                }
                ResetControl();
            }
            catch (Exception ex) { }
        }

        public void xoa(decimal id)
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>(id);
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
                        //objAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
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
                DataExtensions.Delete(oND);
                dt.SaveChanges();
            }
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            ResetControl();
            lbThongBaoQD.Text = "Xóa thành công!";
            Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }

        protected void rdCongboQD_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        public void loadedit(decimal ID)
        {
            lbThongBaoQD.Text = "";
            AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>(ID);
            hddidQD.Value = oND.ID.ToString();
            decimal IDQD = Convert.ToDecimal(oND.QUYETDINHID);
            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
            Cls_Comon.SetButton(btnUpdate, true);

            if (oND.NGAYMOPT != null) txtNgayMoPhienToa.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);
            if (oND.QUYETDINHID != null)
            {
                ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            }
            LoadLydo();
            LoadHTXX();

            if (ddlQuyetdinh.SelectedItem.Text.Contains("03-HS"))
            {
                if (oND.LYDOID + "" != "")
                    ddlLydo_BM03.SelectedValue = oND.LYDOID.ToString();
            }
            else
            {
                get_valueLydo(ID);
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("46-HS"))
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
            //công bố quyết định
            if (oND.ISCONGBOQD != null)
                rdCongBoQD.SelectedValue = oND.ISCONGBOQD.ToString();
            txtSoQD.Text = oND.SOQUYETDINH;
            txtNgayQD.Text = string.IsNullOrEmpty(oND.NGAYQD + "") ? "" : ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);
            txtHieulucTuNgay.Text = string.IsNullOrEmpty(oND.HIEULUCTU + "") ? "" : ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            txtHieuLucDenNgay.Text = string.IsNullOrEmpty(oND.HIEULUCDEN + "") ? "" : ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if (txtHieuLucDenNgay.Text == "")
            {
                decimal QDID = oND.QUYETDINHID + "" == "" ? 0 : (decimal)oND.QUYETDINHID;
                DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == QDID).FirstOrDefault();
                if (oT != null)
                {
                    hddThoiHanThang.Value = oT.THOIHAN_THANG == null ? "0" : oT.THOIHAN_THANG.ToString();
                    hddThoiHanNgay.Value = oT.THOIHAN_NGAY == null ? "0" : oT.THOIHAN_NGAY.ToString();
                }
            }
            DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == oND.NGUOIKYID).FirstOrDefault<DM_CANBO>();
            decimal qdID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            if (cbo != null)
            {
                //Check người ký theo loại QĐ:
                if (qdID == 201 || qdID == 202 || qdID == 77 || qdID == 78 || qdID == 161 || qdID == 162 || qdID == 163)
                {
                    ddlNguoiky.SelectedValue = oND.NGUOIKYID.ToString();
                    phNguoiKyDdl.Visible = true;
                    phNguoiKyTxt.Visible = false;
                    ddlNguoiky.Enabled = false;
                }
                else
                {
                    txtNguoiKyQDVV.Text = cbo.HOTEN;
                    txtChucvu.Text = oND.CHUCVU;
                    phNguoiKyDdl.Visible = false;
                    phNguoiKyTxt.Visible = true;
                }
            }

            if (ddlQuyetdinh.SelectedItem.Text.Contains("03-HS"))
            {
                ddlThayDoi.SelectedValue = oND.THAYDOITCTT.ToString();
                LoadNguoiDuocPhanCong();
                LoadNguoiBiThayDoi();
                pnLyDo_BM03.Visible = true;
                pnLyDo.Visible = false;
                pntxtLydo.Visible = false;
                ddlNguoiDuocPC.SelectedValue = oND.NGUOIDUOCPHANCONG.ToString();
                ddlNguoiBiThayDoi.SelectedValue = oND.NGUOIBITHAY.ToString();
            }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                switch (e.CommandName)
                {
                    case "DownloadQD":
                        AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>($"VUANID = {VuAnID}").FirstOrDefault();
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
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
                        loadedit(ND_id);
                        hddidQD.Value = e.CommandArgument.ToString();
                        break;

                    case "Xoa":
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
                        xoa(ND_id);
                        break;
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }

        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);

                if (ID == 77 || ID == 78 || ID == 79 || ID == 80 || ID == 128 || ID == 206 || ID == 4 || ID == 61)
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
                //Đổi Người ký với các loại QĐ 43,44,39,, 40, 04, 05, 06
                if (ID == 201 || ID == 202 || ID == 77 || ID == 78 || ID == 161 || ID == 162 || ID == 163)
                {
                    LoadNguoiKyDdlInfo();
                    phNguoiKyDdl.Visible = true;
                    phNguoiKyTxt.Visible = false;
                }
                else
                {
                    LoadNguoiKyTxtInfo();
                    phNguoiKyDdl.Visible = false;
                    phNguoiKyTxt.Visible = true;
                    //txtNguoiKyQDVV.Enabled = true;
                    //txtChucvu.Enabled = true;
                }
                LoadLydo();
                LoadHTXX();

                if (ddlQuyetdinh.SelectedItem.Text == "46-HS. Quyết định giải quyết việc kháng cáo, kháng nghị đối với Quyết định tạm đình chỉ (đình chỉ) vụ án")
                {
                    pnKetquaPhuctham.Visible = true;

                    LoadDropKetQuaQuyetdinhPhuctham();
                }
                else
                {
                    pnKetquaPhuctham.Visible = false;
                    pnLyDoKetquaPhuctham.Visible = false;
                }
                check_QDXX(ID);

                //Check quyết định sửa chữa, bổ sung bản án
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }

        private void check_QDXX(Decimal quyetDinhId)
        {
            decimal VUANID = Convert.ToDecimal(hddVuAnID.Value);
            AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oQD = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>($"VUANID = {VUANID} AND LOAIQDID = 5 AND QUYETDINHID = 82").FirstOrDefault();/*Quyết định chuyển vụ án giải quyết theo thủ tục rút gọn sang giải quyết theo thủ tục thông thường*/
            List<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN> lstQD = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>("VUANID = " + VUANID + " AND (LOAIQDID IN (21,3) OR QUYETDINHID IN (127,203,324))");

            if (quyetDinhId == 127 || quyetDinhId == 203)
            {
                if (lstQD.Count >= 1)
                {
                    Cls_Comon.SetButton(btnUpdate, false);
                    lbThongBaoQD.Text = "";
                    return;
                }
                Cls_Comon.SetButton(btnUpdate, true);
                Cls_Comon.SetButton(cmdLammoi, true);
                lbThongBaoQD.Text = "";
                return;
            }
            else if (oQD == null)
            {
                lbThongBaoQD.Text = "Chưa nhập quyết định đưa vụ án ra xét xử.";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                // hddShowCommand.Value = "False";
                return;
            }
        }

        protected void txtHieulucTuNgay_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (txtHieulucTuNgay.Text != "")
                {
                    DateTime dFrom = DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (dFrom != DateTime.MinValue)
                    {
                        int SoThangTheoLuat = Convert.ToInt32(hddThoiHanThang.Value), SoNgayTheoLuat = Convert.ToInt32(hddThoiHanNgay.Value);
                        dFrom = dFrom.AddMonths(SoThangTheoLuat);
                        dFrom = dFrom.AddDays(SoNgayTheoLuat);
                        txtHieuLucDenNgay.Text = dFrom.ToString("dd/MM/yyyy", cul);
                    }
                }
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }

        protected void ddlThayDoi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadNguoiDuocPhanCong();
                LoadNguoiBiThayDoi();
            }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }

        protected void ddlNguoiDuocPC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadNguoiBiThayDoi(); }
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }

        private decimal UploadFileID(decimal VuAnID, string strMaBieumau)
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
                AHS_FILE objFile = dt.AHS_FILE.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM && x.BIEUMAUID == IDBM).FirstOrDefault();
                if (objFile == null)
                {
                    isNew = true;
                    objFile = new AHS_FILE();
                }
                objFile.VUANID = VuAnID;
                objFile.TOAANID = oVuAn.TOAANID;
                objFile.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
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

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
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
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                // check quyền để hiển thị nút xoá
                string toaGiaiQuyetID = e.Item.Cells[10].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
            }
        }

        protected void set_valueLydo(AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND)
        {
            if (ddlQuyetdinh.SelectedValue == "201")
            {
                oND.QUYETDINHID = 201;
                oND.LYDO_NAME = txtLydo.Text;
            }
            else if (ddlQuyetdinh.SelectedValue == "202")
            {
                oND.QUYETDINHID = 202;
                oND.LYDO_NAME = txtLydo.Text;
            }
            else if (pnLyDo.Visible)
            {
                oND.LYDOID = Convert.ToDecimal(ddlLydo.SelectedValue);
            }
        }

        protected void get_valueLydo(decimal ID)
        {
            AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>(ID);

            if (oND.QUYETDINHID == 201 || oND.QUYETDINHID == 202)
            {
                lbtxtLydo.InnerText = "Lý do";
                pntxtLydo.Visible = true;

                if (oND.LYDO_NAME != null)
                {
                    txtLydo.Text = oND.LYDO_NAME;
                }
                else if (oND.LYDOID != null)
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

        #endregion HIEUVM Thông tin quyết định

        #region Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ (đình chỉ) giải quyết vụ án

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
            catch (Exception ex) { lbThongBaoQD.Text = ex.Message; }
        }

        private void LoadDropKetQuaQuyetdinhPhuctham()
        {
            ddlKetquaQuyetdinh.Items.Clear();
            ddlKetquaQuyetdinh.DataSource = dt.DM_KETQUA_PHUCTHAM.Where(x => x.ISAHS == 1 && x.ISQUYETDINH == 1).OrderBy(y => y.THUTU).ToList();
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

        #endregion Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ (đình chỉ) giải quyết vụ án

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

        #endregion "Phân trang"
    }
}