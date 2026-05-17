using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.QLAN;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class Quyetdinhvuan : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0;
        public string NgaySoSanh;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    if (VuAnID == 0)
                        Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    LoadDropThuLy();
                    LoadQD();

                    txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    SetNewSoQD();
                    LoadNguoiKyTxtInfo();
                    CheckQuyen();
                    hddPageIndex.Value = "1";
                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                }
            }
            catch (Exception ex) { 
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("loi xay ra: " + ex);
            }
        }

        private void SetNewSoQD()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
            Decimal LoaiQD = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            DateTime ngayBD;
            if (!String.IsNullOrEmpty(txtNgayQD.Text))
                ngayBD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayBD = DateTime.Now;
            txtSoQD.Text = oSTBL.GET_SQD_NEW(DonViID, "AHS", ngayBD, LoaiQD).ToString();
        }

        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        {
            SetNewSoQD();
        }

        private void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
            decimal THULYID = 0;

            //Check quyết định sửa chữa, bổ sung bản án
            if (ddlQuyetdinh.SelectedItem.Text.Contains("29-HS"))
            {
                lbthongbao.Text = "";
            }
            else
            {
                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();

                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    hddIsSuaDoi.Value = "0";
                    lbthongbao.Text = "Vụ án đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
                else
                    hddIsSuaDoi.Value = "1";

               
                List<AHS_SOTHAM_THULY> objTL = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(y => y.NGAYTHULY).ToList<AHS_SOTHAM_THULY>();
                if (objTL.Count != 0)
                {
                    NgaySoSanh = ((DateTime)objTL[0].NGAYTHULY).ToString("dd/MM/yyyy", cul);
                    THULYID = objTL[0].ID;
                }
                else
                {
                    lbthongbao.Text = "Vụ án chưa được thụ lý. Đề nghị cập nhật thông tin 'Thụ lý sơ thẩm' !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }

                /* Bản án cần kiểm tra có Chủ toạ phiên toà hay không
                 * Quyết định chỉ cần kiểm tra có Thẩm phán giải quyết hay k*/
                List<AHS_THAMPHANGIAIQUYET> lst = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM && x.THULYID == THULYID).ToList<AHS_THAMPHANGIAIQUYET>();
                if (lst == null || lst.Count == 0)
                {
                    lbthongbao.Text = "Vụ án chưa được phân công thẩm phán. Đề nghị cập nhật thông tin 'Phân công thẩm phán giải quyết' !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }

                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongbao.Text = Result;
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                AHS_SOTHAM_BANAN oBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID && x.THULYID == THULYID).FirstOrDefault();
                if (oBA != null)
                {
                    lbthongbao.Text = "Vụ việc đã có bản án, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
                DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID, THULYID);
                if (oDT.Rows.Count > 0)
                {
                    lbthongbao.Text = "Đã có quyết định gây kết thúc, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
                AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.TINHTRANG_GIAIQUYET == 1).OrderByDescending(x => x.ID).FirstOrDefault();
                if (kc != null)
                {
                    var kcChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2).ToList();
                    if (kcChuaGiaiQuyet != null && kcChuaGiaiQuyet.Count > 0)
                    {
                        lbthongbao.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
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
                        lbthongbao.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        hddShowCommand.Value = "False";
                        hddShowCommand.Value = "False";
                        return;
                    }
                }
                if (kn != null)
                {
                    var knChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3).ToList();
                    if (knChuaGiaiQuyet != null && knChuaGiaiQuyet.Count > 0)
                    {
                        lbthongbao.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
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
                        lbthongbao.Text = "Vụ án đã có kháng nghị. Không được sửa đổi.";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        hddShowCommand.Value = "False";
                        return;
                    }
                }
            }
        }

        private void LoadQD()
        {
            //Load Tên quyết định PKG_LOAD_DM_QDVUAN
            DM_QUYETDINH_VUAN oBL = new DM_QUYETDINH_VUAN();
            DataTable oDT = oBL.AHS_DM_QUYETDINH_VUAN();

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
            LoadHTXX();
        }

        private void LoadHTXX()
        {
            if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử"))
            {
                pnHinhThucXetXu.Visible = true;
            }
            else
            {
                pnHinhThucXetXu.Visible = false;
            }
            ddlHTXX.SelectedIndex = 0;
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
            phNguoiKyDdl.Visible = true;
            hddNguoiKyID.Value = ddlNguoiky.SelectedValue;
            txtNguoiKy.Text = ddlNguoiky.Text;
        }

        private void LoadNguoiKyTxtInfo()
        {
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            AHS_SOTHAM_HDXX oND = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == DonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AHS_SOTHAM_HDXX>();
            if (oND != null)
            {
                decimal CanBoID = Convert.ToDecimal(oND.CANBOID.ToString());
                DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                if (dtCanBo.Rows.Count > 0)
                {
                    txtNguoiKy.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
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
                        txtNguoiKy.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                        txtChucvu.Text = "Thẩm phán giải quyết";
                        hddNguoiKyTxtID.Value = dtCanBo.Rows[0]["ID"].ToString();
                    }
                }
                else
                    txtNguoiKy.Text = txtChucvu.Text = "";
            }
        }

        private void ResetControls()
        {
            txtLydo.Text = null;
            txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");

            ddlQuyetdinh.SelectedIndex = 0;
            ddlLydo.SelectedIndex = 0;
            ddlLydo_BM03.SelectedIndex = 0;
            pnLyDo.Visible = false;
            pnLyDo_BM03.Visible = false;
            pntxtLydo.Visible = false;

            lbthongbao.Text = txtSoQD.Text = txtHieulucTuNgay.Text = txtHieuLucDenNgay.Text = "";

            hddid.Value = "0";
            hddFilePath.Value = "";
            lbtDownload.Visible = false;

            //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
            lbxDuongSu.Items.Clear();
            ltDuongsuL.Visible = false;
        }

        private bool CheckValid()
        {
            if (dropThuLy.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn thụ lý. Hãy kiểm tra lại.";
                dropThuLy.Focus();
                return false;
            }

            if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") && ddlHTXX.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn hình thức xét xử";
                return false;
            }

            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn quyết định!";
                ddlQuyetdinh.Focus();
                return false;
            }

            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định tạm đình chỉ") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định phục hồi vụ án"))
            {
                int lengthSQD = txtSoQD.Text.Trim().Length;
                if (lengthSQD == 0)
                {
                    lbthongbao.Text = "Bạn chưa nhập số quyết định!";
                    txtSoQD.Focus();
                    return false;
                }
                if (lengthSQD > 20)
                {
                    lbthongbao.Text = "Số quyết định không quá 20 ký tự. Hãy nhập lại!";
                    txtSoQD.Focus();
                    return false;
                }

                if (String.IsNullOrEmpty(txtNgayQD.Text))
                {
                    lbthongbao.Text = "Bạn chưa nhập ngày quyết định !";
                    txtNgayQD.Focus();
                    return false;
                }
            }

            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("hoãn phiên tòa") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("hoãn phiên họp") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("tạm đình chỉ"))
            {
                if (pnLyDo.Visible)
                {
                    if (ddlLydo.SelectedValue == "0")
                    {
                        lbthongbao.Text = "Bạn chưa nhập Lý do!";
                        return false;
                    }
                }
                else
                {
                    int lengthSQD = txtLydo.Text.Trim().Length;
                    if (lengthSQD == 0)
                    {
                        lbthongbao.Text = "Bạn chưa nhập Lý do!";
                        return false;
                    }
                    if (String.IsNullOrEmpty(txtLydo.Text))
                    {
                        lbthongbao.Text = "Bạn chưa nhập Lý do !";
                        return false;
                    }
                }
            }

            //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định triệu tập đương sự"))
            {
                bool hasSelected = lbxDuongSu.Items.Cast<ListItem>().Any(i => i.Selected);

                if (!hasSelected)
                {
                    lbthongbao.Text = "Bạn chưa chọn đương sự";
                    lbxDuongSu.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtNgayQD.Text))
            {
                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbthongbao.Text = "Bạn chưa nhập ngày quyết định theo định dạng (dd/MM/yyyy) !";
                    txtNgayQD.Focus();
                    return false;
                }

                DateTime NgayQD = DateTime.Parse(txtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                if (NgayQD > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày quyết định phải nhỏ hơn ngày hiện tại !";
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
                    Decimal CurrID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
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
                if (!CheckValid()) return;
                AHS_SOTHAM_QUYETDINH_VUAN oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new AHS_SOTHAM_QUYETDINH_VUAN();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                    if (oND.DONVIID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                    {
                        lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép thay đổi !";
                        return;
                    }
                }

                decimal ThuLyID = Convert.ToDecimal(dropThuLy.SelectedValue);
                oND.THULYID = ThuLyID;

                //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
                if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định triệu tập đương sự"))
                {
                    var dsselected = lbxDuongSu.Items.Cast<ListItem>()
                               .Where(x => x.Selected)
                               .Select(x => x.Value);

                    oND.DUONGSU_IDS = string.Join(",", dsselected);
                }
                else
                {
                    oND.DUONGSU_IDS = "";
                }

                oND.VUANID = VuAnID;
                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();
                try
                {
                    oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                    DM_QD_QUYETDINH objQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).SingleOrDefault();
                    if (objQD != null)
                        oND.LOAIQDID = objQD.LOAIID;
                }
                catch (Exception exx) { }


                oND.LYDOID = (pnLyDo.Visible == true) ? Convert.ToDecimal(ddlLydo.SelectedValue) : (Decimal?)null;
                oND.LYDO_NAME = (txtLydo.Visible == true) ? txtLydo.Text : null;


                if (pnLyDo_BM03.Visible)
                {
                    oND.LYDOID = Convert.ToDecimal(ddlLydo_BM03.SelectedValue);
                    // Update Người tiến hành tố tụng
                    decimal CanBoBiThay = Convert.ToDecimal(ddlNguoiBiThayDoi.SelectedValue),
                        CanBoDuocPC = Convert.ToDecimal(ddlNguoiDuocPC.SelectedValue);
                    if (CanBoBiThay > 0)
                    {
                        AHS_SOTHAM_HDXX hdxx = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.CANBOID == CanBoBiThay).FirstOrDefault();
                        if (hdxx != null)
                        {
                            hdxx.ISTHAYDOI = 1;
                            bool isNew = false;
                            AHS_SOTHAM_HDXX obj = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.CANBOID == CanBoDuocPC).FirstOrDefault();
                            if (obj == null)
                            {
                                isNew = true;
                                obj = new AHS_SOTHAM_HDXX();
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
                                dt.AHS_SOTHAM_HDXX.Add(obj);
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
                oND.HINHTHUCXETXU = Convert.ToDecimal(ddlHTXX.SelectedValue);
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                DM_QD_QUYETDINH oQDT = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).FirstOrDefault();
                if (oQDT != null)
                {
                    decimal rFileID = 0;
                    if (hddid.Value == "" || hddid.Value == "0")
                    {
                        rFileID = 0;
                    } else
                    {
                        rFileID = oND?.FILEID ?? 0;
                    }
                    oND.FILEID = UploadFileID(VuAnID, rFileID, oQDT.MA);
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
                //oND.CHUCVU = txtChucvu.Text;
                if (hddid.Value == "" || hddid.Value == "0")
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

                if (oND.LOAIQDID == 3)
                {
                    // update giai đoạn vụ án = sotham
                    AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                    if (objAn != null)
                    {
                        // objAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.DINHCHI;
                        objAn.NGAYSUA = DateTime.Now;
                        objAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    }
                }

                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        public void LoadGrid()
        {
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_ST_QD_VUAN_KHONGKETTHUC_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                int Total = oDT.Rows.Count;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"

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
            try
            {
                pnHinhThucXetXu.Visible = false;
                //ResetControls();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        public void xoa(decimal id)
        {
            AHS_SOTHAM_QUYETDINH_VUAN oND = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                if (oND.DONVIID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                {
                    lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép xóa !";
                    return;
                }
                // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                AHS_TONGDAT oTD = dt.AHS_TONGDAT.Where(x => x.VUANID == oND.VUANID && x.MAPID == id && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_SOTHAM_QUYETDINH_VUAN).FirstOrDefault();
                if (oTD != null)
                {
                    lbthongbao.Text = "Bạn không thể xóa khi đã tống đạt!";
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
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }

        public void loadedit(decimal ID)
        {
            lbthongbao.Text = "";
            AHS_SOTHAM_QUYETDINH_VUAN oND = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
            dropThuLy.SelectedValue = oND.THULYID.ToString();
            hddid.Value = oND.ID.ToString();
            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
            if (oND.NGAYMOPT != null) txtNgayMoPhienToa.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);
            if (oND.QUYETDINHID != null)
                ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
            LoadLydo();
            LoadHTXX();
            if (pnHinhThucXetXu.Visible == true && oND.HINHTHUCXETXU != null)
            {
                ddlHTXX.SelectedValue = oND.HINHTHUCXETXU.ToString();
            }

            if (ddlQuyetdinh.SelectedItem.Text.Contains("03-HS"))
            {
                if (oND.LYDOID + "" != "")
                    ddlLydo_BM03.SelectedValue = oND.LYDOID.ToString();
            }
            else
            {

                if (oND.LYDOID != null && oND.LYDOID != 0)
                {
                    pnLyDo.Visible = true;
                    ddlLydo.SelectedValue = oND.LYDOID.ToString();
                }
                if (!string.IsNullOrEmpty(oND.LYDO_NAME + ""))
                {
                    pntxtLydo.Visible = true;
                    txtLydo.Text = oND.LYDO_NAME;
                }

            }
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
                }
                else
                {
                    txtNguoiKy.Text = cbo.HOTEN;
                    txtChucvu.Text = oND.CHUCVU;
                    phNguoiKyDdl.Visible = false;
                    phNguoiKyTxt.Visible = true;
                }
            }

            //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
            if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định triệu tập đương sự"))
            {
                LoadDropDuongSu();
                ltDuongsuL.Visible = true;
                pnHieulucngay.Visible = false;
            }
            else
            {
                lbxDuongSu.Items.Clear();
                ltDuongsuL.Visible = false;
                pnHieulucngay.Visible = true;
            }
            if (!string.IsNullOrEmpty(oND.DUONGSU_IDS))
            {
                string[] dsDuongSu = oND.DUONGSU_IDS.Split(',');
                foreach (string item in dsDuongSu)
                {
                    lbxDuongSu.Items.FindByValue(item).Selected = true;
                }
            }

            //if (cbo != null)
            //{
            //    txtNguoiKy.Text = cbo.HOTEN;
            //}
            //txtChucvu.Text = oND.CHUCVU;
            AHS_FILE file = dt.AHS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
            if (file != null)
            {
                if (file.TENFILE + "" != "")
                {
                    lbtDownload.Visible = true;
                    lbtDownload.Text = "Tải tệp đính kèm: " + file.TENFILE;
                }
            }
            else
                lbtDownload.Visible = false;

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
                switch (e.CommandName)
                {
                    case "Download":
                        AHS_FILE oND = dt.AHS_FILE.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND.TENFILE != "")
                        {
                            var cacheKey = Guid.NewGuid().ToString("N");
                            Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                        }
                        break;

                    case "Sua":
                        LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                        if (lblSua.Text == "Sửa")
                        {
                            Cls_Comon.SetButton(cmdUpdate, true);
                        }
                        else
                        {
                            Cls_Comon.SetButton(cmdUpdate, false);
                        }
                        AHS_SOTHAM_QUYETDINH_VUAN oND1 = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ND_id).FirstOrDefault();
                        if (oND1 != null)
                        {
                            // khong duoc xoa khi da Tong dat - 27/11/2025 vnpt check
                            AHS_TONGDAT oTD = dt.AHS_TONGDAT.Where(x => x.VUANID == oND1.VUANID && x.MAPID == ND_id && x.MAP_TABLE == ENUM_MAP_TABLE.AHS_SOTHAM_QUYETDINH_VUAN).FirstOrDefault();
                            if (oTD != null)
                            {
                                lbthongbao.Text = "Bạn không thể sửa khi đã tống đạt!";
                                return;
                            }
                        }
                        
                        loadedit(ND_id);
                        hddid.Value = e.CommandArgument.ToString();
                        break;

                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        if (hddIsSuaDoi.Value == "0")
                        {
                            lbthongbao.Text = "Vụ án đã được chuyển lên tòa cấp trên, không được sửa đổi!";
                            return;
                        }
                        string StrMsg = "Không được sửa đổi thông tin.";
                        string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                        if (Result != "")
                        {
                            lbthongbao.Text = Result;
                            return;
                        }
                        xoa(ND_id);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(hddid.Value);
                AHS_SOTHAM_QUYETDINH_VUAN oND = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oND != null)
                {
                    AHS_FILE file = dt.AHS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                    if (file != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: file.NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + file.TENFILE + "&Extension=" + file.KIEUFILE + "';", true);
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định tạm đình chỉ") || ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định tiếp tục giải quyết vụ án"))
                {
                    ltSoQD.Text = ltNgayQD.Text = "<span style='color:red'>(*)</span>";
                }
                else
                {
                    ltSoQD.Text = ltNgayQD.Text = "";
                }

                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                //Load số quyêt định với các loại QD Hinh Su sau
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
                    phNguoiKyDdl.Visible = false;
                    phNguoiKyTxt.Visible = true;
                }
                LoadLydo();
                LoadHTXX();

                //---------26/11/2025---- Đinh Hoàng Sơn vnpt - quyết định triệu tập đương sự
                if (ddlQuyetdinh.SelectedItem.Text.ToLower().Contains("quyết định triệu tập đương sự"))
                {
                    LoadDropDuongSu();
                    ltDuongsuL.Visible = true;
                    txtHieulucTuNgay.Text = txtHieuLucDenNgay.Text = "";
                    pnHieulucngay.Visible = false;
                }
                else
                {
                    ltDuongsuL.Visible = false;
                    pnHieulucngay.Visible = true;
                }
                //Check quyết định sửa chữa, bổ sung bản án
                CheckQuyen();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void ddlThayDoi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadNguoiDuocPhanCong();
                LoadNguoiBiThayDoi();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void ddlNguoiDuocPC_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadNguoiBiThayDoi(); }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
                } else
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
                            objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            objFile.KIEUFILE = oF.Extension;
                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
            List<AHS_SOTHAM_THULY> thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();
            decimal THULYID;
            // vnpt update 11082025: check thu ly co rong hay khong
            if (thuly.Count != 0)
            {
                THULYID = thuly[0].ID;
            }
            else
            {
                THULYID = 0;
            }

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                decimal QDID = Convert.ToDecimal(rowView["ID"].ToString());
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

                AHS_SOTHAM_QUYETDINH_VUAN qdbc_tl = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.ID == QDID && x.THULYID == THULYID).FirstOrDefault();
                if (qdbc_tl == null)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    return;
                }
                else
                {

                }

                AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => (x.LOAIKHANGCAO == 2 || x.LOAIKHANGCAO == 1 || x.LOAIKHANGCAO == 3) && x.SOQDBA == QDID).FirstOrDefault();

                AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => (x.LOAIKN == 2 || x.LOAIKN == 1 || x.LOAIKN == 3) && x.BANANID == QDID).FirstOrDefault();
                if (kc != null || kn != null)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                string toagiaiquyetID = e.Item.Cells[11].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Text = "Chi tiết";
                }
            }
        }

        //Lanh lấy danh sách nguyên đơn đại diện
        void LoadDropDuongSu()
        {
            string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
            decimal ID = Convert.ToDecimal(current_id);
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();

            List<KeyValuePair<string, decimal>> lstTGTT = new List<KeyValuePair<string, decimal>>();
            dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == ID && x.ISPHUCTHAM != 1).ToList()
                        .ForEach(x => lstTGTT.Add(new KeyValuePair<string, decimal>(x.HOTEN, x.ID)));
            dt.AHS_BICANBICAO.Where(x => x.VUANID == ID).ToList()
            .ForEach(x => lstTGTT.Add(new KeyValuePair<string, decimal>(x.HOTEN, x.ID)));
            lbxDuongSu.Items.Clear();
            if (lstTGTT != null)
            {
                lbxDuongSu.DataSource = lstTGTT;
                lbxDuongSu.DataTextField = "Key";
                lbxDuongSu.DataValueField = "Value";
                lbxDuongSu.DataBind();
            }
            else
                lbxDuongSu.Items.Add(new ListItem("--- Chọn ---", "0"));
        }
        void LoadDropThuLy()
        {
            dropThuLy.Items.Clear();
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
                    dropThuLy.Items.Add(new ListItem("---Chọn---", "0"));
                    foreach (DataRow row in tbl.Rows)
                    {
                        SoThuLy = row["SoThuLy"] + "";
                        THThuLy = row["TruongHopThuLy"] + "";
                        NgayThuLy = Convert.ToDateTime(row["NgayThuLy"] + "").ToString("dd/MM/yyyy", cul);
                        temp = SoThuLy + " - " + THThuLy + " - " + NgayThuLy;
                        dropThuLy.Items.Add(new ListItem(temp, row["ID"] + ""));
                    }
                }
                else
                {
                    DataRow row = tbl.Rows[0];
                    SoThuLy = row["SoThuLy"] + "";
                    THThuLy = row["TruongHopThuLy"] + "";
                    NgayThuLy = Convert.ToDateTime(row["NgayThuLy"] + "").ToString("dd/MM/yyyy", cul);
                    temp = SoThuLy + " - " + THThuLy + " - " + NgayThuLy;
                    dropThuLy.Items.Add(new ListItem(temp, row["ID"] + ""));

                    hddNgayThuLy.Value = NgayThuLy;
                }
            }
            else
            {
                dropThuLy.Items.Add(new ListItem("---Chọn---", "0"));
                lbthongbao.Text = "Vụ việc chưa được thụ lý. Hãy kiểm tra lại !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }

            List<AHS_SOTHAM_THULY> tl = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();
            if (tl.Count != 0)
            {
                decimal THULYID = tl[0].ID;

                dropThuLy.SelectedValue = THULYID.ToString();
            }
            else
            {
                lbthongbao.Text = "Vụ việc chưa được thụ lý. Hãy kiểm tra lại !";
                cmdUpdate.Visible = cmdLammoi.Visible = false;
            }
        }

        protected void dropThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            decimal THULYID = Convert.ToDecimal(dropThuLy.SelectedValue);

            AHS_SOTHAM_QUYETDINH_VUAN oT = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == ID && x.THULYID == THULYID).FirstOrDefault();
            AHS_SOTHAM_THULY oTHULY = dt.AHS_SOTHAM_THULY.Where(x => x.ID == THULYID).FirstOrDefault();
            if (dropThuLy.SelectedValue == "0")
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }
            else if (oT == null)
            {
                Cls_Comon.SetButton(cmdUpdate, true);
                Cls_Comon.SetButton(cmdLammoi, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }

            if (dropThuLy.SelectedValue != "0")
            {
                string TH_ThuLy = dropThuLy.SelectedItem.Text;
                String[] arrThuly = TH_ThuLy.Split('-');
                foreach (String item in arrThuly)
                {
                    if (item.Length > 0)
                        hddNgayThuLy.Value = item;
                }
            }
        }


        #region #Phân trang

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

        #endregion #Phân trang
    }
}