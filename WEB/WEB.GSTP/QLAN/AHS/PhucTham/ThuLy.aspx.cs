using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.SYSTEM_LOG;
using DAL.GSTP;
using DevExpress.Utils.Extensions;
using DevExpress.Web.ASPxThemes;
using DevExpress.XtraEditors.Repository;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Printing;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.QLAN.AHS.PhucTham.BanAn;

namespace WEB.GSTP.QLAN.AHS.PhucTham
{
    public partial class ThuLy : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private decimal magiaidoan = ENUM_GIAIDOANVUAN.PHUCTHAM;
        private decimal loaian = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU);
        private static decimal bicanid = 0;
        private static decimal bananstid = 0;

        public decimal VuAnID = 0;
        Decimal PhongBanID = 0, CurrDonViID = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                ddlSothuly.Visible = false;
                ddlStlPhu.Visible = false;

                lstMsgB.Text = "";

                if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
                {
                    VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                    CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    if (!IsPostBack)
                    {
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                        Cls_Comon.SetButton(cmdThemmoi, oPer.CAPNHAT);
                        LoadDropNoidung();
                        CheckQuyen();
                        LoadThongTin_XetXuSoTham();
                        LoadNguoiKyDdlInfo();
                        LoadCbxNguoikiemhoso();
                        LoadListToiDanh_ByVuAnId();
                        LoadGrid();
                        if (rpt.Items.Count == 0)
                        {
                            SetNewSoThuLy();
                        }
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (Exception ex)
            {
                logger.Error("loi xay ra: {0}", ex);
                lstMsgB.Text = "Lỗi xảy ra. Vui lòng liên hệ ban quản trị!";
            }
        }
        void CheckQuyen()
        {
            //Kiểm tra có kháng cáo, kháng nghị hay không?
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                AHS_SOTHAM_BL objST = new AHS_SOTHAM_BL();

                AHS_SOTHAM_KHANGCAO oKC = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                AHS_SOTHAM_KHANGNGHI oKN = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID).FirstOrDefault();

                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lstMsgB.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdThemmoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && oKC == null && oKN == null)
                {
                    lstMsgB.Text = "Chưa có kháng cáo/ kháng nghị !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdThemmoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }

                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lstMsgB.Text = "Vụ án đã được chuyển lên tòa án cấp trên. Không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdThemmoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lstMsgB.Text = "Vụ án đã được chuyển xét xử lại cấp sơ thẩm. Không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdThemmoi, false);
                    hddIsShowCommand.Value = "False";
                    return;
                }
            }
            AHS_PHUCTHAM_BANAN ba = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            if (ba != null && (oT.GDTAOHS == 0 || oT.GDTAOHS == null))
            {
                lstMsgB.Text = "Vụ án đã có bản án phúc thẩm. Không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdThemmoi, false);
                hddIsShowCommand.Value = "False";
                return;
            }
        }

        void LoadThongTin_XetXuSoTham()
        {
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            LoadToaSoTham();
            LoadGrid_KhangCao();
            LoadGrid_KhangNghi();
            LoadGrid_ThamGiaPT();

            ddTruongHopTL.Items.Clear();
            AHS_CHUYEN_NHAN_AN oCN = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TOANHANID == CurrDonViID).OrderByDescending(x => x.NGAYTAO).FirstOrDefault();
            if (oCN == null)
            {
                return;
            }
            if (oCN.TRUONGHOPGIAONHANID == 998)
            {
                ddTruongHopTL.Items.Add(new ListItem("Do giám đốc thẩm hủy để xét xử lại phúc thẩm", "AHS_PT_ThuLyLai"));
                pnlNoidung.Visible = true;
                ddlNoidung.SelectedIndex = 0;
                pnlGhichu.Visible = false;
            }
            else if ((pnKC.Visible == true && pnKN.Visible == true) || (oCN.TRUONGHOPGIAONHANID == 267 && oCN.TRUONGHOPGIAONHANID == 269))
            {
                ddTruongHopTL.Items.Add(new ListItem("Do có kháng cáo và kháng nghị phúc thẩm", "AHS_PT_ThuLyKCKN"));
                pnlNoidung.Visible = false;
                ddlNoidung.SelectedIndex = 0;
                pnlGhichu.Visible = false;
            }
            else
            {
                if (pnKC.Visible == true || oCN.TRUONGHOPGIAONHANID == 267)
                {
                    ddTruongHopTL.Items.Add(new ListItem("Do có kháng cáo phúc thẩm", "AHS_PT_ThuLyKC"));
                    pnlNoidung.Visible = false;
                    ddlNoidung.SelectedIndex = 0;
                    pnlGhichu.Visible = false;
                }
                else if (pnKN.Visible == true || oCN.TRUONGHOPGIAONHANID == 269)
                {
                    ddTruongHopTL.Items.Add(new ListItem("Do có kháng nghị phúc thẩm", "AHS_PT_ThuLyKN"));
                    pnlNoidung.Visible = false;
                    ddlNoidung.SelectedIndex = 0;
                    pnlGhichu.Visible = false;
                }

            }
        }

        private void LoadGrid_ThamGiaPT()
        {
            AHS_BICANBICAO_BL objBL = new AHS_BICANBICAO_BL();
            DataTable tbl = objBL.GetAllByVuAnId_ThuLyPT(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptThuLyPT.DataSource = tbl;
                rptThuLyPT.DataBind();
                rptThuLyPT.Visible = true;
            }
            else
                rptThuLyPT.Visible = false;
        }

        void LoadToaSoTham()
        {
            AHS_VUAN obj = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (obj != null)
            {
                AHS_SOTHAM_BANAN oBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).SingleOrDefault<AHS_SOTHAM_BANAN>();
                if (oBA != null)
                {

                    lblBAQD.Text = "Số BA:<b>" + oBA.SOBANAN + "</b>";
                    string ngayBA = (((DateTime)oBA.NGAYBANAN) == DateTime.MinValue) ? "" : ((DateTime)oBA.NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    lblNgayBAQD.Text = "Ngày BA:<b>" + ngayBA + "</b>";
                }
                else
                {
                    AHS_SOTHAM_QUYETDINH_VUAN objQD = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                    if (objQD != null)
                    {
                        lblBAQD.Text = "Số QĐ:<b>" + objQD.SOQUYETDINH + "</b>";
                        string ngayba = (((DateTime)objQD.NGAYQD) == DateTime.MinValue) ? "" : ((DateTime)objQD.NGAYQD).ToString("dd/MM/yyyy", cul);
                        lblNgayBAQD.Text = " Ngày QĐ:<b>" + ngayba + "</b>";
                    }

                }
                if (obj.TOAANID > 0)
                {
                    DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANID).First();
                    lblToaxx.Text = oT.TEN;
                }

            }

            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            //DataTable tbl = oBL.AHS_SOTHAM_HDXX_GETLIST(VuAnID);
            //if (tbl != null && tbl.Rows.Count > 0)
            //{
            //    rptToaSoTham.DataSource = tbl;
            //    rptToaSoTham.DataBind();
            //    rptToaSoTham.Visible = true;
            //}
            //else rptToaSoTham.Visible = false;
            AHS_BICANBICAO_BL objBL = new AHS_BICANBICAO_BL();
            DataTable tbl = objBL.GetAllPaging(VuAnID, null, 1, 100);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptToaSoTham.DataSource = tbl;
                rptToaSoTham.DataBind();
                rptToaSoTham.Visible = true;
            }
            else
                rptToaSoTham.Visible = false;
        }
        public void LoadGrid_KhangCao()
        {
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_SoTham_GetAllKCByVuAn(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                rptKC.DataSource = oDT;
                rptKC.DataBind();
                pnKC.Visible = true;
            }
            else
                pnKC.Visible = false;
        }
        public void LoadGrid_KhangNghi()
        {
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_SOTHAM_GetAllKNByVuAn(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                rptKN.DataSource = oDT;
                rptKN.DataBind();
                pnKN.Visible = true;
            }
            else
                pnKN.Visible = false;
        }
        private void LoadNguoiKyDdlInfo()
        {
            DataTable tbl = null;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            //Lấy danh sách Chánh án, phó chánh án, Chánh VP, Phó chánh VP, Thẩm phán
            tbl = cb_BL.DM_CANBO_GETBYDONVI_THULY(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlNguoiky.DataSource = tbl;
            ddlNguoiky.DataTextField = "MA_TEN";
            ddlNguoiky.DataValueField = "ID";
            ddlNguoiky.DataBind();
        }
        private void LoadCbxNguoikiemhoso()
        {
            //Load cán bộ kiểm hồ sơ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlCanbokiemhoso.Items.Clear();

            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanbokiemhoso.DataSource = oCBDT;
            ddlCanbokiemhoso.DataTextField = "MA_TEN";
            ddlCanbokiemhoso.DataValueField = "ID";
            ddlCanbokiemhoso.DataBind();
            ddlCanbokiemhoso.Items.Insert(0, new ListItem("--Chọn người kiểm hồ sơ--", "0"));
            //Set mặc định cán bộ loginf
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "")
                    ddlCanbokiemhoso.SelectedValue = strCBID;
            }
            catch { }
        }
        void LoadDropNoidung()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NOIDUNGTHULYXXL);

            ddlNoidung.Items.Clear();
            ddlNoidung.DataSource = tbl;
            ddlNoidung.DataTextField = "TEN";
            ddlNoidung.DataValueField = "ID";
            ddlNoidung.DataBind();
            ddlNoidung.Items.Insert(0, new ListItem("--------Chọn--------", "0"));
        }

        private void LoadInfo(decimal ThuLyID)
        {
            lstMsgB.Text = "";
            AHS_PHUCTHAM_THULY obj = dt.AHS_PHUCTHAM_THULY.Where(x => x.ID == ThuLyID).FirstOrDefault<AHS_PHUCTHAM_THULY>();
            if (obj != null)
            {
                txtNgayThuLy.Text = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);

                txtSoThuly.Text = obj.SOTHULY;

                ddlSothuly.Items.Clear();
                string ddlSothuly_Add = Regex.Match(obj.SOTHULY, @"\d+").Value;
                ddlSothuly.Items.Add(new ListItem(ddlSothuly_Add));
                ddlSothuly.SelectedValue = ddlSothuly_Add;
                ddlToiDanhVuAn.SelectedValue = string.IsNullOrEmpty(obj.TOIDANHCHINH_VUAN.ToString()) ? "0" : obj.TOIDANHCHINH_VUAN.ToString();

                ddlStlPhu_AddItems();
                string stlphu = obj.SOTHULY.ToString().Replace(ddlSothuly.SelectedValue, "");

                if (stlphu.Length != 0)
                {
                    if (!ddlStlPhu.Items.Contains(new ListItem(stlphu)))
                    {
                        ddlStlPhu.Items.Add(new ListItem(stlphu));
                    }
                    ddlStlPhu.SelectedValue = stlphu;
                }

                if (obj.THOIHANTUNGAY != null)
                {
                    txtTuNgay.Text = (DateTime)obj.THOIHANTUNGAY == DateTime.MinValue ? "" : ((DateTime)obj.THOIHANTUNGAY).ToString("dd/MM/yyyy", cul);
                }

                if (obj.THOIHANDENNGAY != null)
                {
                    txtDenNgay.Text = (DateTime)obj.THOIHANDENNGAY == DateTime.MinValue ? "" : ((DateTime)obj.THOIHANDENNGAY).ToString("dd/MM/yyyy", cul);
                }

                if (obj.UTTPDI == 1)
                    cbUTTP.Checked = true;
                else
                    cbUTTP.Checked = false;

                DM_DATAITEM objDM = dt.DM_DATAITEM.Where(x => x.ID == obj.TRUONGHOPTHULY).FirstOrDefault();
                ddTruongHopTL.SelectedValue = objDM.MA.ToString();
                ddlNguoiky.SelectedValue = obj.NGUOIKYID + "";
                if (obj.NGUOIKIEMHOSOID != null)
                {
                    ddlCanbokiemhoso.SelectedValue = obj.NGUOIKIEMHOSOID + "";
                }
                txtSoButLuc.Text = obj.SOBUTLUC + "";

                if (ddTruongHopTL.SelectedValue == "AHS_PT_ThuLyLai")//Thụ lý pt xx lại
                {
                    pnlNoidung.Visible = true;
                    if (obj.NOIDUNGTLXXLAI != null)
                    {
                        ddlNoidung.SelectedValue = obj.NOIDUNGTLXXLAI + "";
                        if (ddlNoidung.SelectedValue == "2244")
                        {
                            pnlGhichu.Visible = true;
                            txtGhichu.Text = obj.GHICHUKHAC;
                        }
                        else
                        {
                            pnlGhichu.Visible = false;
                            txtGhichu.Text = "";
                        }
                    }
                }
                else
                {
                    pnlNoidung.Visible = false;
                    ddlNoidung.SelectedIndex = 0;
                    pnlGhichu.Visible = false;
                    txtGhichu.Text = "";
                }

            }
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckValidate())
                return;

            Save();
            ResetForm();
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void ddlNoidung_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlNoidung.SelectedValue == "2244")// Nội dung khác
            {
                pnlGhichu.Visible = true;
                txtGhichu.Text = "";
            }
            else
            {
                pnlGhichu.Visible = false;
                txtGhichu.Text = "";
            }
        }

        void Save()
        {
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            Decimal VuAnId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            DateTime NgayThuLy = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            Boolean IsNew = false;
            AHS_PHUCTHAM_THULY obj = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == VuAnId).FirstOrDefault<AHS_PHUCTHAM_THULY>();
            if (obj == null)
            {
                IsNew = true;
                obj = new AHS_PHUCTHAM_THULY();
            }
            obj.VUANID = VuAnId;
            obj.TOAANID = ToaAnID;
            obj.NGUOIKYID = Convert.ToDecimal(ddlNguoiky.SelectedValue);
            obj.NGUOIKIEMHOSOID = Convert.ToDecimal(ddlCanbokiemhoso.SelectedValue);
            obj.SOBUTLUC = txtSoButLuc.Text.Trim();

            if (ddTruongHopTL.SelectedValue == "AHS_PT_ThuLyLai")
            {
                obj.TRUONGHOPTHULY = 998;
                pnlNoidung.Visible = true;
                if (ddlNoidung.SelectedIndex > 0)
                {
                    obj.NOIDUNGTLXXLAI = Convert.ToDecimal(ddlNoidung.SelectedValue);
                    if (ddlNoidung.SelectedValue == "2244")
                    {
                        pnlGhichu.Visible = true;
                        obj.GHICHUKHAC = txtGhichu.Text.Trim();
                    }
                    else
                    {
                        pnlGhichu.Visible = false;
                        obj.GHICHUKHAC = "";
                    }
                }
                else
                {
                    obj.NOIDUNGTLXXLAI = null;
                    obj.GHICHUKHAC = "";
                }
            }
            else
            {
                DM_DATAITEM objDM = dt.DM_DATAITEM.Where(x => x.MA == ddTruongHopTL.SelectedValue).FirstOrDefault();
                obj.TRUONGHOPTHULY = objDM.ID;
                pnlNoidung.Visible = false;
                obj.NOIDUNGTLXXLAI = null;
                obj.GHICHUKHAC = "";
            }

            obj.SOTHULY = ddlSothuly.SelectedValue + ddlStlPhu.SelectedValue;
            obj.SOTHULY = txtSoThuly.Text;

            // Tội danh chính vụ án
            obj.TOIDANHCHINH_VUAN = Convert.ToDecimal(ddlToiDanhVuAn.SelectedValue == "" ? "0" : ddlToiDanhVuAn.SelectedValue);

            obj.NGAYTHULY = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.THOIHANDENNGAY = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? DateTime.Now.AddDays(15) : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            if (cbUTTP.Checked)
                obj.UTTPDI = 1;
            else
                obj.UTTPDI = 0;

            STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
            oQLSTL.update_STPT_QUANLY_SOTHULY(3, 1, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul), Regex.Match(obj.SOTHULY, @"\d+").Value);

            if (IsNew)
            {
                AHS_PHUCTHAM_THULY_BL objBL = new AHS_PHUCTHAM_THULY_BL();
                decimal ToaID = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                decimal STT = objBL.GETNEWTT(ToaID, NgayThuLy);
                obj.TT = STT;

                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.AHS_PHUCTHAM_THULY.Add(obj);

                // update giai đoạn vụ án
                AHS_VUAN objAn = dt.AHS_VUAN.Where(x => x.ID == VuAnId).FirstOrDefault<AHS_VUAN>();
                if (objAn != null)
                    objAn.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                //anhvh add 26/06/2020
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE("1", VuAnId, 3, 0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0);
            }
            else
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }
            dt.SaveChanges();

            //--------------------
            GanBiCaoThamGiaPT();

            lstMsgB.Text = "Lưu dữ liệu thành công!";
        }
        void GanBiCaoThamGiaPT()
        {
            string curr_user = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            List<AHS_BICANBICAO> lst = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList();
            List<AHS_NGUOITHAMGIATOTUNG> lstTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID).ToList();
            AHS_SOTHAM_BANAN bananidST = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID).FirstOrDefault();
            List<AHS_SOTHAM_KHANGNGHI> lstKN = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.BANANID == bananidST.ID).ToList();

            bool checkKCKN = false;
            try
            {


                if (lstKN != null && lstKN.Count > 0)
                {
                    checkKCKN = true;
                }
                else
                {
                    if (lstTGTT != null && lstTGTT.Count > 0)
                    {
                        foreach (AHS_NGUOITHAMGIATOTUNG item in lstTGTT)
                        {
                            AHS_SOTHAM_KHANGCAO tgttKC = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.NGUOIKCID == item.ID).FirstOrDefault();
                            if (tgttKC != null)
                            {
                                checkKCKN = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex) { }

            if (checkKCKN)
            {
                if (lst != null && lst.Count > 0)
                {
                    AHS_PHUCTHAM_BICANBICAO obj = null;
                    Boolean isnew = true;
                    foreach (AHS_BICANBICAO item in lst)
                    {
                        try
                        {
                            try
                            {
                                obj = dt.AHS_PHUCTHAM_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANID == item.ID).Single<AHS_PHUCTHAM_BICANBICAO>();
                                if (obj != null)
                                    isnew = false;
                                else
                                    obj = new AHS_PHUCTHAM_BICANBICAO();
                            }
                            catch (Exception ex) { obj = new AHS_PHUCTHAM_BICANBICAO(); }
                            obj.BICANID = item.ID;
                            obj.VUANID = VuAnID;

                            if (isnew)
                            {
                                obj.NGUOITAO = curr_user;
                                obj.NGAYTAO = DateTime.Now;
                                dt.AHS_PHUCTHAM_BICANBICAO.Add(obj);
                                dt.SaveChanges();
                            }
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                }
            }
            else
            {
                if (lst != null && lst.Count > 0)
                {
                    AHS_PHUCTHAM_BICANBICAO obj = null;
                    Boolean isnew = true;
                    foreach (AHS_BICANBICAO item in lst)
                    {
                        try
                        {
                            try
                            {
                                obj = dt.AHS_PHUCTHAM_BICANBICAO.Where(x => x.VUANID == VuAnID && x.BICANID == item.ID).Single<AHS_PHUCTHAM_BICANBICAO>();
                                if (obj != null)
                                    isnew = false;
                                else
                                    obj = new AHS_PHUCTHAM_BICANBICAO();
                            }
                            catch (Exception ex) { obj = new AHS_PHUCTHAM_BICANBICAO(); }

                            AHS_SOTHAM_KHANGCAO bcKC = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.NGUOIKCID == item.ID).FirstOrDefault();
                            if (bcKC != null)
                            {
                                obj.BICANID = item.ID;
                                obj.VUANID = VuAnID;

                                if (isnew)
                                {
                                    obj.NGUOITAO = curr_user;
                                    obj.NGAYTAO = DateTime.Now;
                                    dt.AHS_PHUCTHAM_BICANBICAO.Add(obj);
                                    dt.SaveChanges();
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                }
            }
        }
        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            txtTuNgay.Text = txtNgayThuLy.Text;
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]), LoaiToiPhamID = 0;
            DateTime NgayThuLy = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);


            SetNewSoThuLy();
            //try
            //{
            //    ddlSothuly.Items.Clear();

            //    STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
            //    DataTable dtStl = oQLSTL.get_STPT_QUANLY_SOTHULY(3, 1, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), txtNgayThuLy.Text);
            //    if (oQLSTL != null)
            //    {
            //        ddlSothuly.DataSource = dtStl;
            //        ddlSothuly.DataTextField = "SOTHULY";
            //        ddlSothuly.DataValueField = "SOTHULY";
            //        ddlSothuly.DataBind();

            //        ddlSothuly.Items.Add(new ListItem(""));
            //        ddlSothuly.SelectedValue = "";
            //    }

            //    string check_ngaythulycuoi_trongnam = oQLSTL.get_LATEST_DATE_IN_SOTHULY(3, 1, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), txtNgayThuLy.Text);

            //    DateTime check_ngaythulycuoi = DateTime.Parse(check_ngaythulycuoi_trongnam.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    if (check_ngaythulycuoi <= DateTime.Parse(txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
            //    {
            //        SetNewSoThuLy();
            //    }
            //}
            //catch
            //{
            //    lstMsgB.Text = "Lỗi lấy danh sách Số thụ lý!";
            //}

            AHS_VUAN vuan = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
            if (vuan != null)
            {
                LoaiToiPhamID = vuan.LOAITOIPHAMID + "" == "" ? 0 : (decimal)vuan.LOAITOIPHAMID;
            }
            DM_DATAITEM dmLoaiToiPham = dt.DM_DATAITEM.Where(x => x.ID == LoaiToiPhamID && x.HIEULUC == 1).FirstOrDefault<DM_DATAITEM>();
            if (dmLoaiToiPham != null)
            {
                string MaLoaiTP = dmLoaiToiPham.MA;
                txtDenNgay.Enabled = false;
                if (NgayThuLy != DateTime.MinValue)
                {
                    switch (MaLoaiTP)
                    {
                        case ENUM_AHS_LOAITOIPHAM.IT_NGHIEMTRONG:
                            txtDenNgay.Text = (NgayThuLy.AddDays(30)).ToString("dd/MM/yyyy", cul);
                            break;
                        case ENUM_AHS_LOAITOIPHAM.NGHIEMTRONG:
                            txtDenNgay.Text = (NgayThuLy.AddDays(45)).ToString("dd/MM/yyyy", cul);
                            break;
                        case ENUM_AHS_LOAITOIPHAM.RAT_NGHIEMTRONG:
                            txtDenNgay.Text = (NgayThuLy.AddMonths(2)).ToString("dd/MM/yyyy", cul);
                            break;
                        case ENUM_AHS_LOAITOIPHAM.DACBIET_NGHIEMTRONG:
                            txtDenNgay.Text = (NgayThuLy.AddMonths(3)).ToString("dd/MM/yyyy", cul);
                            break;
                        default:
                            txtDenNgay.Enabled = true;
                            break;
                    }
                }
                else
                    txtDenNgay.Enabled = true;
            }
        }
        private decimal SetNewSoThuLy()
        {
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            AHS_SOTHAM_BL oSTBL = new AHS_SOTHAM_BL();
            if (String.IsNullOrEmpty(txtNgayThuLy.Text))
                txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");

            DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            string sothulymoi = oSTBL.GET_STL_NEW_HS(DonViID, "AHS_PT", CheckThanhNien(), ngaythuly).ToString();

            if (!ddlSothuly.Items.Contains(new ListItem(sothulymoi)))
            {
                ddlSothuly.Items.Add(new ListItem(sothulymoi));
            }

            if (ddlSothuly.Items.Count == 1)
            {
                ddlSothuly.SelectedValue = sothulymoi;
            }
            else
            {
                ddlSothuly.Items.Add(new ListItem(""));
                ddlSothuly.SelectedValue = "";
            }

            ddlStlPhu_AddItems();

            txtSoThuly.Text = sothulymoi;

            return Convert.ToDecimal(sothulymoi);
        }
        private void LoadGrid()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_PHUCTHAM_THULY_BL obj = new AHS_PHUCTHAM_THULY_BL();
            DataTable tbl = obj.GetByVuAnID(VuAnID);
            rpt.DataSource = tbl;
            rpt.DataBind();
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                LinkButton lbtXoaSothulyKhongSuDungLai = (LinkButton)e.Item.FindControl("lbtXoaSothulyKhongSuDungLai");
                Cls_Comon.SetLinkButton(lbtXoaSothulyKhongSuDungLai, oPer.XOA);

                lbtXoaSothulyKhongSuDungLai.Visible = false;

                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT != null)
                {
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                        lbtXoaSothulyKhongSuDungLai.Visible = false;
                    }
                }
                if (!Convert.ToBoolean(hddIsShowCommand.Value))
                {
                    lbtXoa.Visible = lblSua.Visible = false;
                    lbtXoaSothulyKhongSuDungLai.Visible = false;
                }
                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (!String.IsNullOrEmpty(toaGiaiQuyetID) && toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ThuLyID = Convert.ToDecimal(e.CommandArgument.ToString());
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    hddID.Value = ThuLyID + "";
                    ;
                    LoadInfo(ThuLyID);
                    break;

                case "Xoa":

                    hddXoa_SelectedIndex.Value = "1";
                    hddThulyID.Value = ThuLyID.ToString();
                    mp1.Show();
                    ddlLydoXoa();
                    break;

                case "XoaSothulyKhongSuDungLai":

                    hddXoa_SelectedIndex.Value = "2";
                    hddThulyID.Value = ThuLyID.ToString();
                    mp1.Show();
                    ddlLydoXoa();
                    break;

            }
        }
        void ResetForm()
        {
            hddID.Value = "0";
            ddTruongHopTL.SelectedIndex = 0;

            txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            SetNewSoThuLy();
            ddlStlPhu_AddItems();

            ddlNguoiky.SelectedIndex = 0;
            ddlCanbokiemhoso.SelectedIndex = 0;
            txtSoButLuc.Text = "";

            cbUTTP.Checked = false;

        }
        protected void cmdThemmoi_Click(object sender, EventArgs e)
        {
            ResetForm();
            CheckQuyen();
        }
        private bool CheckValidate()
        {
            if (ddTruongHopTL.SelectedValue == "")
            {
                lstMsgB.Text = "Bạn chưa chọn trường hợp thụ lý. Hãy kiểm tra lại!";
                ddTruongHopTL.Focus();
                return false;
            }

            if (Cls_Comon.IsValidDate(txtNgayThuLy.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày thụ lý theo định dạng (dd/MM/yyyy)!";
                txtNgayThuLy.Focus();
                return false;
            }

            if (ddlNguoiky.SelectedValue == "")
            {
                lstMsgB.Text = "Bạn chưa chọn người ký. Hãy kiểm tra lại!";
                ddlNguoiky.Focus();
                return false;
            }

            //if (ddlSothuly.Text == "")
            //{
            //    lstMsgB.Text = "Chưa chọn số thụ lý";
            //    return false;
            //}
            if (!Regex.IsMatch(txtSoThuly.Text, @"^\d"))
            {
                lstMsgB.Text = "Số thụ lý phải bắt đầu bằng ký tự số";
                return false;
            }
            if (txtSoThuly.Text == "")
            {
                lstMsgB.Text = "Chưa nhập số thụ lý";
                return false;
            }

            //string sothuly = ddlSothuly.SelectedValue;

            //if (!String.IsNullOrEmpty(txtNgayThuLy.Text))
            //{
            //    DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //    AHS_SOTHAM_BL oSTBL = new AHS_SOTHAM_BL();
            //    Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "AHS_PT", CheckThanhNien(), sothuly, ngaythuly);
            //    if (CheckID > 0)
            //    {
            //        Decimal CurrThuLyID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            //        String strMsg = "";
            //        String STTNew = oSTBL.GET_STL_NEW_HS(DonViID, "AHS_PT", CheckThanhNien(), ngaythuly).ToString();
            //        if (CheckID != CurrThuLyID)
            //        {
            //            //lbthongbao.Text = "Số thụ lý này đã có!";
            //            strMsg = "Số thụ lý " + sothuly + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
            //            ddlSothuly.Items.Add(new ListItem(STTNew));
            //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
            //            ddlSothuly.Focus();
            //            return false;
            //        }
            //    }
            //}
            string sothuly = txtSoThuly.Text;

            if (!String.IsNullOrEmpty(txtNgayThuLy.Text))
            {
                DateTime ngaythuly = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                AHS_SOTHAM_BL oSTBL = new AHS_SOTHAM_BL();
                Decimal CheckID = oSTBL.CheckSoTLTheoLoaiAn(DonViID, "AHS_PT", CheckThanhNien(), sothuly, ngaythuly);
                if (CheckID > 0)
                {
                    Decimal CurrThuLyID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                    String strMsg = "";
                    String STTNew = oSTBL.GET_STL_NEW_HS(DonViID, "AHS_PT", CheckThanhNien(), ngaythuly).ToString();
                    if (CheckID != CurrThuLyID)
                    {
                        //lbthongbao.Text = "Số thụ lý này đã có!";
                        strMsg = "Số thụ lý " + sothuly + " đã có trong hệ thống. Bạn có thể dùng số " + STTNew;
                        txtSoThuly.Text = STTNew;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        txtSoThuly.Focus();
                        return false;
                    }
                }
            }
            return true;
        }
        private decimal CheckThanhNien()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.ISTHANHNIEN == 0)
            {
                return 2;
            }
            else
            {
                AHS_BICANBICAO dtBiCao = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID && x.ISTREVITHANHNIEN == 1).FirstOrDefault();
                AHS_NGUOITHAMGIATOTUNG dtTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID && x.ISTREVITHANHNIEN == 1).FirstOrDefault();
                if (dtBiCao != null || dtTGTT != null)
                {
                    return 1;
                }
                return 0;
            }
        }

        protected void btnSaveLydoXoa_Insert(object sender, EventArgs e)
        {
            if (hddThulyID.Value == "0")
            {
                lstMsgB.Text = "Xóa không thành công!";
                return;
            }

            decimal ThuLyID = Convert.ToDecimal(hddThulyID.Value + "");
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            AHS_PHUCTHAM_THULY oND = dt.AHS_PHUCTHAM_THULY.Where(x => x.ID == ThuLyID).FirstOrDefault();

            if (oPer.XOA == false)
            {
                lstMsgB.Text = "Bạn không có quyền xóa!";
                return;
            }

            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_THAMPHANGIAIQUYET AHS_THAMPHANGIAIQUYET = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).FirstOrDefault<AHS_THAMPHANGIAIQUYET>();
            if (AHS_THAMPHANGIAIQUYET != null)
            {
                lstMsgB.Text = "Xóa không thành công! Do đang tồn tại thông tin phân công thẩm phán giải quyết.";
                return;
            }
            AHS_NGUOITHAMGIATOTUNG AHS_NGUOITHAMGIATOTUNG = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == DONID && x.ISPHUCTHAM == 1).FirstOrDefault<AHS_NGUOITHAMGIATOTUNG>();
            if (AHS_NGUOITHAMGIATOTUNG != null)
            {
                lstMsgB.Text = "Xóa không thành công! Do đang tồn tại người tham gia tố tụng.";
                return;
            }
            AHS_PHUCTHAM_HDXX AHS_PHUCTHAM_HDXX = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == DONID).FirstOrDefault<AHS_PHUCTHAM_HDXX>();
            if (AHS_PHUCTHAM_HDXX != null)
            {
                lstMsgB.Text = "Xóa không thành công! Do đang tồn tại thông tin người tiến hành tố tụng.";
                return;
            }
            AHS_PHUCTHAM_QUYETDINH_VUAN AHS_PHUCTHAM_QUYETDINH_VUAN = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == DONID).FirstOrDefault<AHS_PHUCTHAM_QUYETDINH_VUAN>();
            if (AHS_PHUCTHAM_QUYETDINH_VUAN != null)
            {
                lstMsgB.Text = "Xóa không thành công! Do đang tồn tại thông tin quyết định vụ án.";
                return;
            }
            AHS_PHUCTHAM_BANAN AHS_PHUCTHAM_BANAN = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == DONID).FirstOrDefault<AHS_PHUCTHAM_BANAN>();
            if (AHS_PHUCTHAM_BANAN != null)
            {
                lstMsgB.Text = "Xóa không thành công! Do đang tồn tại bản án.";
                return;
            }

            LICHSU_XOA_SOTHULY oLS = new LICHSU_XOA_SOTHULY();
            if (oLS.insert_LICHSU_XOA_SOTHULY(magiaidoan, ThuLyID, loaian, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), Session[ENUM_SESSION.SESSION_USERNAME] + "", ddlLydoXoaSothuly.SelectedItem.ToString(), DONID) == false)
            {
                lstMsgB.Text = "Xóa không thành công!";
                return;
            }

            if (Convert.ToDecimal(Regex.Match(oND.SOTHULY, @"\d+").Value) == SetNewSoThuLy())
            {
                hddXoa_SelectedIndex.Value = "0";
            }

            STPT_QUANLY_SOTHULY oQLSTL = new STPT_QUANLY_SOTHULY();
            if (oQLSTL.insert_STPT_QUANLY_SOTHULY(magiaidoan, loaian, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ((DateTime)oND.NGAYTHULY).ToString("dd/MM/yyyy", cul),
                                                Regex.Match(oND.SOTHULY, @"\d+").Value, Convert.ToDecimal(ddlLydoXoaSothuly.SelectedValue), ddlLydoXoaSothuly.SelectedItem.ToString(),
                                                Session[ENUM_SESSION.SESSION_USERNAME] + "", Session[ENUM_SESSION.SESSION_USERTEN] + "", Convert.ToDecimal(hddXoa_SelectedIndex.Value + ""), DONID) == false)
            {
                lstMsgB.Text = "Xóa không thành công!";
                return;
            }

            dt.AHS_PHUCTHAM_THULY.Remove(oND);
            dt.SaveChanges();
            LoadGrid();

            lstMsgB.Text = "Xóa thành công!";

            hddXoa_SelectedIndex.Value = "0";
            hddThulyID.Value = "0";
        }
        protected void ddlStlPhu_AddItems()
        {
            ddlStlPhu.Items.Clear();
            ddlStlPhu.Items.Add(new ListItem(""));
            ddlStlPhu.Items.Add(new ListItem("A"));
            ddlStlPhu.Items.Add(new ListItem("B"));
            ddlStlPhu.Items.Add(new ListItem("C"));
            ddlStlPhu.Items.Add(new ListItem("D"));
            ddlStlPhu.Items.Add(new ListItem("E"));
        }
        protected void ddlLydoXoa()
        {
            string maLydoxoa = "";
            if (hddXoa_SelectedIndex.Value == "1")
            {
                maLydoxoa = "LYDOXOATHULY";
            }
            else if (hddXoa_SelectedIndex.Value == "2")
            {
                maLydoxoa = "LYDOXOASOTHULY";
            }

            ddlLydoXoaSothuly.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(maLydoxoa);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlLydoXoaSothuly.DataSource = tbl;
                ddlLydoXoaSothuly.DataTextField = "TEN";
                ddlLydoXoaSothuly.DataValueField = "ID";
                ddlLydoXoaSothuly.DataBind();

            }
        }

        protected void btnLichsuXoaThuly_Click(object sender, EventArgs e)
        {
            mdLichsuXoaThuly.Show();
            loadGrid_LichsuXoaThuly();
        }
        protected void loadGrid_LichsuXoaThuly()
        {
            dgLichsuXoaThuly.Visible = true;
            decimal vuanid = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            List<LICHSU_XOA_SOTHULY> obj = DataExtensions.GetAllWithClause<LICHSU_XOA_SOTHULY>($"LOAIAN = {loaian} AND MAGIAIDOAN = {magiaidoan} AND TOAAN_ID = {Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID])} and DONID = {vuanid}");
            if (obj != null && obj.Count > 0)
            {
                dgLichsuXoaThuly.DataSource = obj;
                dgLichsuXoaThuly.DataBind();
            }
        }
        protected bool CheckToiDanh(object val)
        {
            return val != null && val.ToString() == "1";
        }
        protected void rptThuLyPT_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Decimal BiCaoId = Convert.ToDecimal(e.CommandArgument.ToString());
            decimal BanAnStId = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET
                                .Where(x => x.VUANID == VuAnID)
                                .Select(x => (decimal?)x.BANANID)
                                .Distinct()
                                .FirstOrDefault() ?? 0;
            bananstid = BanAnStId;
            switch (e.CommandName)
            {
                case "Chon":
                    bicanid = BiCaoId;
                    bananstid = BanAnStId;
                    LoadListToiDanhByBCId(VuAnID, BiCaoId);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "hienPopup();", true);
                    break;
            }
        }

        private void LoadListToiDanhByBCId(decimal VuAnId, decimal BiCanId)
        {
            AHS_PHUCTHAM_THULY_BL objBL = new AHS_PHUCTHAM_THULY_BL();
            //AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
            DataTable tbl = objBL.GetToiDanhByBiCanId(VuAnId, BiCanId);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                //DataTable data = tbl.Select($"KHOAN IS NULL").CopyToDataTable();
                dgToiDanhChinh.DataSource = tbl;
                dgToiDanhChinh.DataBind();
            }
        }

        protected void rptThuLyPT_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lblChon = (LinkButton)e.Item.FindControl("lblChon");
                if (!Convert.ToBoolean(hddIsShowCommand.Value))
                {
                    lblChon.Visible = lblChon.Visible = false;
                }
            }
        }

        protected void btnSaveTDC_Click(object sender, EventArgs e)
        {
            Decimal toidanhid = 0;
            Decimal IsBanAn = 0;
            foreach (RepeaterItem item in dgToiDanhChinh.Items)
            {
                CheckBox chk = item.FindControl("chkLuaChon") as CheckBox;
                if (chk.Checked)
                {
                    HiddenField hd_ID = item.FindControl("hddID_ToiDanh") as HiddenField;
                    toidanhid = Convert.ToDecimal(hd_ID?.Value + "");
                    HiddenField hd_IsBanAn = item.FindControl("hdd_IsBanAn") as HiddenField;
                    IsBanAn = Convert.ToDecimal(hd_IsBanAn?.Value + "");
                }
            }
            if (toidanhid > 0)
            {
                if (IsBanAn == 1)
                {
                    var obj = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == bicanid && x.BANANID == bananstid && x.TOIDANHID == toidanhid).FirstOrDefault();
                    if (obj != null)
                    {
                        obj.ISMAIN_THULYPT = 1;
                        dt.SaveChanges();
                    }
                    // set ISMAIN = 0 cho cac toidanh khac
                    var lst = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == bicanid && x.BANANID == bananstid && x.TOIDANHID != toidanhid).ToList();
                    foreach (var item in lst)
                    {
                        if (item.ISMAIN_THULYPT == null || item.ISMAIN_THULYPT == 1)
                        {
                            item.ISMAIN_THULYPT = 0;
                            dt.SaveChanges();
                        }
                    }
                }
                else
                {
                    var objCT = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == bicanid && x.VUANID == VuAnID && x.TOIDANHID == toidanhid).FirstOrDefault();
                    if (objCT != null)
                    {
                        objCT.ISMAIN_THULYPT = 1;
                        dt.SaveChanges();
                    }
                    // set ISMAIN = 0 cho cac toidanh khac
                    var lstCT = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == bicanid && x.VUANID == VuAnID && x.TOIDANHID != toidanhid).ToList();
                    foreach (var item in lstCT)
                    {
                        if (item.ISMAIN_THULYPT == null || item.ISMAIN_THULYPT == 1)
                        {
                            item.ISMAIN_THULYPT = 0;
                            dt.SaveChanges();
                        }
                    }
                }

                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Chọn tội danh chính thành công!");
                LoadGrid_ThamGiaPT();
                LoadListToiDanh_ByVuAnId();
                txtSoThuly.Focus();
            }
        }

        protected void LoadListToiDanh_ByVuAnId()
        {

            var listToiDanhST = (
                from va in dt.AHS_VUAN
                join bc in dt.AHS_BICANBICAO on va.ID equals bc.VUANID
                join ba_dct in dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.ISMAIN_THULYPT == 1) on bc.ID equals ba_dct.BICANID into ba_dct_left
                from ba_dct in ba_dct_left.DefaultIfEmpty()
                join ct in dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.ISMAIN_THULYPT == 1) on bc.ID equals ct.BICANID into ct_left
                from ct in ct_left.DefaultIfEmpty()
                join td in dt.DM_BOLUAT_TOIDANH on (ba_dct.TOIDANHID != null ? ba_dct.TOIDANHID : ct.TOIDANHID) equals td.ID
                join kn in dt.AHS_SOTHAM_KHANGNGHI on va.ID equals kn.VUANID into knLeft
                from kn in knLeft.DefaultIfEmpty()
                join kc in dt.AHS_SOTHAM_KHANGCAO on va.ID equals kc.VUANID into kcLeft
                from kc in kcLeft.DefaultIfEmpty()
                where va.ID == VuAnID
                    && td.KHOAN == null
                    && (
                        (kn.DSNGUOIBIKN != null && kn.DSNGUOIBIKN.Contains(bc.ID.ToString()))
                        || (kn.DSNGUOIBIKN == null && kn.VUANID != null)
                        || dt.AHS_SOTHAM_KHANGCAO.Any(kc => kc.NGUOIKCID == bc.ID)
                        || (kc.DSNGUOIBIKC != null && kc.DSNGUOIBIKC.Contains(bc.ID.ToString()))
                        )
                select new
                {
                    td.ID,
                    td.TENTOIDANH,
                    BICAOID = bc.ID,
                })
                .Distinct()
                .ToList();
            var lstBC = new List<decimal>();
            foreach (RepeaterItem item in rptThuLyPT.Items)
            {
                HiddenField bicaoID = (HiddenField)item.FindControl("BICAOID");
                if (bicaoID != null && !string.IsNullOrEmpty(bicaoID.Value))
                    lstBC.Add(Convert.ToDecimal(bicaoID.Value));
            }
            ddlToiDanhVuAn.Enabled = listToiDanhST.Count() == lstBC.Count();
            ddlToiDanhVuAn.Items.Clear();

            ddlToiDanhVuAn.Items.Add(new ListItem("-- Chọn tội danh --", "0"));
            var lstToiDanh = listToiDanhST
                .Select(x => new
                {
                    x.ID,
                    x.TENTOIDANH
                })
                .Distinct()
                .ToList();
            foreach (var item in lstToiDanh)
            {
                ddlToiDanhVuAn.Items.Add(new ListItem { Text = item.TENTOIDANH, Value = item.ID.ToString() });
            }
            ddlToiDanhVuAn.SelectedIndex = 0;
        }

    }
}