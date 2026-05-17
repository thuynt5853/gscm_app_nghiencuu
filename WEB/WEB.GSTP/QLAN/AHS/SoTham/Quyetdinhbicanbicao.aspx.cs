using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.AHS;
using BL.GSTP.QLAN;
using BL.GSTP.Danhmuc;
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
using System.Web.Script.Serialization;

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class Quyetdinhbicanbicao : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0;
        public static string NgayThuLy;
        public static decimal LoaiQD_BatTamGiam = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            try
            {
                if (!IsPostBack)
                {
                    LoaiQD_BatTamGiam = dt.DM_QD_LOAI.Where(x => x.MA == ENUM_LOAI_QD_AHS.BAT_TAMGIAM).FirstOrDefault().ID;

                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    if (VuAnID == 0)
                        Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    LoadCombobox();
                    if (ddlLoaiQD.SelectedValue == LoaiQD_BatTamGiam.ToString())
                        pnNoiGiamGiu.Visible = true;
                    else
                        pnNoiGiamGiu.Visible = false;

                    LoadDropThuLy();
                    LoadNguoiKyDdlInfo();
                    hddPageIndex.Value = "1";
                    try
                    {
                        CheckQuyen();
                        LoadGrid();
                    }
                    catch { }

                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
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
            }
            else
            {
                hddIsSuaDoi.Value = "1";
            }

            List<AHS_SOTHAM_THULY> lstCount = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();
            decimal THULYID;
            if (lstCount.Count == 0)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return;
            }
            else
            {
                NgayThuLy = ((DateTime)lstCount[0].NGAYTHULY).ToString("dd/MM/yyyy", cul);
                THULYID = lstCount[0].ID;
            }
            
            List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID).ToList();
            if (lst == null || lst.Count == 0)
            {
                lbthongbao.Text = "Các bị can trong vụ án chưa được gán tội danh. Đề nghị cập nhật thông tin này !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                return;
            }

            /* Bản án cần kiểm tra có Chủ toạ phiên toà hay không
             * Quyết định chỉ cần kiểm tra có Thẩm phán giải quyết hay k*/
            List<AHS_THAMPHANGIAIQUYET> lst_tpgq = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM && x.THULYID == THULYID).ToList<AHS_THAMPHANGIAIQUYET>();
            if (lst_tpgq == null || lst_tpgq.Count == 0)
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
                var kcChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.ID > kc.ID && x.TINHTRANG_GIAIQUYET != 2 && x.LOAIKHANGCAO != 3 && x.LOAIKHANGCAO != 2).ToList();
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
                AHS_SOTHAM_KHANGCAO kc2 = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.VUANID == VuAnID && x.LOAIKHANGCAO != 3 && x.LOAIKHANGCAO != 2).FirstOrDefault();
                if (kc2 != null)
                {

                    lbthongbao.Text = "Vụ án đã có kháng cáo. Không được sửa đổi.";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            if (kn != null)
            {
                var knChuaGiaiQuyet = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.ID > kn.ID && x.TINHTRANG_GIAIQUYET != 3 && x.LOAIKN != 3 && x.LOAIKN != 2).ToList();
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
                AHS_SOTHAM_KHANGNGHI kn2 = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.VUANID == VuAnID && x.LOAIKN != 3 && x.LOAIKN != 2).FirstOrDefault();
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

        private void LoadCombobox()
        {
            // Load Bị can/bị can
            LoadDropBiCan();

            // Load loại quyết định và quyết định có liên quan đến bị can bị cáo (ISDUONGSUYEUCAU == 1)
            List<DM_QD_LOAI> lst = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISHINHSU == 1 && x.ISDUONGSUYEUCAU == 1).OrderBy(y => y.THUTU).ToList();
            if (lst != null)
            {
                int count_item = lst.Count;
                if (count_item > 1)
                    ddlLoaiQD.Items.Add(new ListItem("--- Chọn ---", "0"));
                if (count_item > 0)
                {
                    foreach (DM_QD_LOAI item in lst)
                        ddlLoaiQD.Items.Add(new ListItem(item.TEN, item.ID.ToString()));
                }
            }
            LoadQD();
        }
        void LoadDropBiCan()
        {
            ddlBiCan.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            List<AHS_BICANBICAO> listBiCan = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).OrderBy(x => x.HOTEN).ToList<AHS_BICANBICAO>();
            if (listBiCan != null)
            {
                int count_item = listBiCan.Count;
                if (count_item > 0)
                {
                    ddlBiCan.DataSource = listBiCan;
                    ddlBiCan.DataTextField = "HOTEN";
                    ddlBiCan.DataValueField = "ID";
                    ddlBiCan.DataBind();
                }
            }
            else
                ddlBiCan.Items.Add(new ListItem("--- Chọn ---", "0"));
        }
        private void LoadQD()
        {
            decimal LoaiQD = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            ddlQuyetdinh.Items.Clear();
            List<DM_QD_QUYETDINH> lst = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == LoaiQD && x.ISHINHSU == 1 && x.ISSOTHAM == 1 && x.MA.Contains("HS")).OrderBy(y => y.THUTU).ToList();
            if (lst.Count > 0)
            {
                ddlQuyetdinh.DataSource = lst;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
                ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
            {
                ddlQuyetdinh.Items.Add(new ListItem("--- Chọn ---", "0"));
            }
        }
        private void LoadNguoiKyInfo()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            DataTable tbl = null;
            //txtNguoiKy.Text = txtChucvu.Text = "";
            decimal CanBoID = 0;
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();

            //--------------------------------------
            tbl = cb_BL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlNguoiky.DataSource = tbl;
            ddlNguoiky.DataTextField = "MA_TEN";
            ddlNguoiky.DataValueField = "ID";
            ddlNguoiky.DataBind();

            // Trường hợp các quyết định do chánh án hoặc phó chánh án ký
            AHS_SOTHAM_HDXX oND = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AHS_SOTHAM_HDXX>();
            if (oND != null)
            {
                CanBoID = Convert.ToDecimal(oND.NGUOIPHANCONGID.ToString());//Convert.ToDecimal(oND.CANBOID.ToString());

            }
            string TenBieuMau = ddlQuyetdinh.SelectedItem.Text;
            // Các quyết định do thẩm phán được phân công giải quyết ký: 36-HS,39-HS,51-HS
            if (TenBieuMau.Contains("36-HS") || TenBieuMau.Contains("39-HS") || TenBieuMau.Contains("51-HS"))
            {
                AHS_THAMPHANGIAIQUYET obj = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM").FirstOrDefault<AHS_THAMPHANGIAIQUYET>();
                if (obj != null)
                {
                    CanBoID = obj.CANBOID + "" == "" ? 0 : (decimal)obj.CANBOID;
                }
            }
            // Các quyết định do chủ tọa ký: 07-HS,08-HS,11-HS,12-HS,37-HS,38-HS,39-HS,40-HS,51-HS,52-HS
            if (TenBieuMau.Contains("07-HS") || TenBieuMau.Contains("08-HS") || TenBieuMau.Contains("11-HS") || TenBieuMau.Contains("12-HS") || TenBieuMau.Contains("37-HS") || TenBieuMau.Contains("38-HS") || TenBieuMau.Contains("39-HS") || TenBieuMau.Contains("40-HS") || TenBieuMau.Contains("51-HS") || TenBieuMau.Contains("52-HS"))
            {
                if (oND != null)
                {
                    CanBoID = oND.CANBOID + "" == "" ? 0 : (decimal)oND.CANBOID;
                }
            }
            //DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
            //if (dtCanBo != null && dtCanBo.Rows.Count > 0)
            //{
            //    txtNguoiKy.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
            //    txtChucvu.Text = dtCanBo.Rows[0]["ChucVu"].ToString();
            //    hddNguoiKyID.Value = dtCanBo.Rows[0]["ID"].ToString();
            //}
            if (CanBoID > 0)
                ddlNguoiky.SelectedValue = CanBoID.ToString();
            hddNguoiKyID.Value = ddlNguoiky.SelectedValue;
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
            AHS_SOTHAM_HDXX oND = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).OrderByDescending(x => x.ID).FirstOrDefault<AHS_SOTHAM_HDXX>();
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
            hddNguoiKyID.Value = ddlNguoiky.SelectedValue;

        }

        private void ResetControls()
        {
            txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            ddlBiCan.SelectedIndex = ddlLoaiQD.SelectedIndex = ddlDieuLuatBS.SelectedIndex = 0;
            ddlLoaiQD_SelectedIndexChanged(new object(), new EventArgs());
            ddlQuyetdinh.SelectedIndex = 0;
            ddlQuyetdinh_SelectedIndexChanged(new object(), new EventArgs());
            lbthongbao.Text = txtSoQD.Text = txtHieulucTuNgay.Text = txtHieuLucDenNgay.Text = "";
            txtNoiGiamGiu.Text = txtNghiAnNgay.Text = "";
            hddid.Value = "0";
            hddFilePath.Value = "";
            lbtDownload.Visible = false;
            CheckQuyen();
        }
        private bool CheckValid()
        {
            if (dropThuLy.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn thụ lý. Hãy kiểm tra lại.";
                dropThuLy.Focus();
                return false;
            }
            if (ddlBiCan.SelectedValue == "" || ddlBiCan.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn bị can. Hãy chọn lại.";
                ddlBiCan.Focus();
                return false;
            }
            if (ddlLoaiQD.SelectedValue == "" || ddlLoaiQD.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn loại quyết định. Hãy chọn lại.";
                ddlLoaiQD.Focus();
                return false;
            }
            if (ddlQuyetdinh.SelectedValue == "" || ddlQuyetdinh.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn tên quyết định. Hãy chọn lại.";
                ddlQuyetdinh.Focus();
                return false;
            }
            DateTime DNgayThuLy = NgayThuLy == "" ? DateTime.MinValue : DateTime.Parse(NgayThuLy, cul, DateTimeStyles.NoCurrentDateDefault);
            if (ddlQuyetdinh.SelectedItem.Text.Contains("07-HS") || ddlQuyetdinh.SelectedItem.Text.Contains("08-HS"))
            {
                if (txtNghiAnNgay.Text != "")
                {
                    if (Cls_Comon.IsValidDate(txtNghiAnNgay.Text) == false)
                    {
                        lbthongbao.Text = "Biên bản nghị án ngày phải theo kiểu (Ngày/Tháng/Năm). Hãy nhập lại";
                        txtNghiAnNgay.Focus();
                        return false;
                    }
                }
            }

            if (ddlLoaiQD.SelectedItem.Text.ToLower().Contains("đình chỉ") || ddlLoaiQD.SelectedItem.Text.ToLower().Contains("tạm đình chỉ"))
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

            if (String.IsNullOrEmpty(txtHieulucTuNgay.Text))
            {
                lbthongbao.Text = "Bạn chưa nhập ngày hiệu lực !";
                txtHieulucTuNgay.Focus();
                return false;
            }

            if (!String.IsNullOrEmpty(txtHieulucTuNgay.Text))
            {
                if (Cls_Comon.IsValidDate(txtHieulucTuNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn chưa nhập ngày hiệu lực theo định dạng (dd/MM/yyyy) !";
                    txtHieulucTuNgay.Focus();
                    return false;
                }

                DateTime HieulucTuNgay = DateTime.Parse(txtHieulucTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                if (HieulucTuNgay > DateTime.Now)
                {
                    lbthongbao.Text = "Ngày hiệu lực  phải nhỏ hơn ngày hiện tại !";
                    txtHieulucTuNgay.Focus();
                    return false;
                }
            }

            if (ddlLoaiQD.SelectedValue == LoaiQD_BatTamGiam.ToString())
            {
                if (String.IsNullOrEmpty(txtNoiGiamGiu.Text.Trim()))
                {
                    lbthongbao.Text = "Bạn chưa nhập nơi giam giữ.";
                    txtNoiGiamGiu.Focus();
                    return false;
                }
                int NoiGGLength = txtNoiGiamGiu.Text.Trim().Length;
                if (NoiGGLength > 250)
                {
                    lbthongbao.Text = "Nơi giam giữ không nhập quá 250 ký tự.";
                    txtNoiGiamGiu.Focus();
                    return false;
                }
            }

            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal BiCanID = Convert.ToDecimal(ddlBiCan.SelectedValue), FileID = 0,
                    QDID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue), curr_id = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                //----------------------
                if (!CheckValid())
                    return;
                if (!CheckExist(curr_id))
                    return;
                ///----------------------------
                AHS_SOTHAM_QUYETDINH_BICAN oND;
                if (curr_id == 0)
                    oND = new AHS_SOTHAM_QUYETDINH_BICAN();
                else
                {
                    oND = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.ID == curr_id).FirstOrDefault();
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                }
                oND.BICANID = Convert.ToDecimal(ddlBiCan.SelectedValue);
                oND.VUANID = VuAnID;

                decimal ThuLyID = Convert.ToDecimal(dropThuLy.SelectedValue);
                oND.THULYID = ThuLyID;

                oND.LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                if (oND.LOAIQDID == LoaiQD_BatTamGiam)
                { oND.NOIGIAMGIU = txtNoiGiamGiu.Text.Trim(); }
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                if (ddlQuyetdinh.SelectedItem.Text.Contains("07-HS") || ddlQuyetdinh.SelectedItem.Text.Contains("08-HS"))
                {
                    oND.DIEULUATAPDUNGTHEM = ddlDieuLuatBS.SelectedValue;
                    if (Cls_Comon.IsValidDate(txtNghiAnNgay.Text))
                    {
                        oND.BIENBANNGHIAN_NGAY = DateTime.Parse(txtNghiAnNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                }

                //----------------------------
                decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DM_TOAAN dmToaAn = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault<DM_TOAAN>();
                if (dmToaAn != null)
                {
                    DM_DATAITEM dmDataItem = dt.DM_DATAITEM.Where(x => x.MA == dmToaAn.LOAITOA).FirstOrDefault<DM_DATAITEM>();
                    if (dmDataItem != null)
                        oND.LOAIDONVI = dmDataItem.ID;
                    else
                        oND.LOAIDONVI = 0;
                }
                oND.DONVIID = DonViID;
                oND.SOQUYETDINH = txtSoQD.Text.Trim();
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oND.NGUOIKYID = Convert.ToDecimal(ddlNguoiky.SelectedValue);

                oND.CHUCVU = ddlNguoiky.SelectedValue;
                AHS_VUAN va = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                if (va != null)
                {
                    DM_QD_QUYETDINH oQDT = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).FirstOrDefault();
                    if (oQDT != null && oQDT.MA.ToLower().Contains("-hs"))
                    {
                        decimal rFileID = UploadFileID(va, (Decimal)oND.BICANID, FileID, oQDT.MA);
                        if (rFileID > 0) oND.FILEID = rFileID;
                    }
                }
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
                            oND.NOIDUNGFILE = buff;
                            oND.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            oND.KIEUFILE = oF.Extension;
                        }
                        File.Delete(strFilePath);
                    }
                    catch (Exception ex) { lbthongbao.Text = ex.Message; }
                }

                if (curr_id == 0)
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_QUYETDINH_BICAN.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();

                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        Boolean CheckExist(Decimal CurrID)
        {
            String SoQD = txtSoQD.Text.Trim();
            Decimal BiCanID = Convert.ToDecimal(ddlBiCan.SelectedValue);
            //--------------
            Decimal LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            Decimal QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            AHS_SOTHAM_QUYETDINH_BICAN obj = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == VuAnID
                                                                                    && x.BICANID == BiCanID
                                                                                    && x.LOAIQDID == LOAIQDID
                                                                                    && x.QUYETDINHID == QUYETDINHID
                                                                                    && x.SOQUYETDINH == SoQD).FirstOrDefault();
            if (obj != null)
            {
                if (obj.ID != CurrID)
                {
                    lbthongbao.Text = "Đã có số quyết định này. Hãy kiểm tra lại!";
                    txtSoQD.Focus();
                    return false;
                }
                else
                    return true;
            }
            else
                return true;
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
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
                AHS_SOTHAM_QUYETDINH_BICAN oND = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtNoiGiamGiu.Text = "";
            decimal LoaiQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            if (LoaiQDID == LoaiQD_BatTamGiam)
            {
                pnNoiGiamGiu.Visible = true;
            }
            else
                pnNoiGiamGiu.Visible = false;
            LoadQD();
            ddlQuyetdinh_SelectedIndexChanged(sender, e);
        }
   
        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiQD.SelectedItem.Text.ToLower().Contains("đình chỉ") || ddlLoaiQD.SelectedItem.Text.ToLower().Contains("tạm đình chỉ"))
            {
                ltSoQD.Text = ltNgayQD.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltSoQD.Text = ltNgayQD.Text = "";
            }

            decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                hddThoiHanThang.Value = oT.THOIHAN_THANG == null ? "0" : oT.THOIHAN_THANG.ToString();
                hddThoiHanNgay.Value = oT.THOIHAN_NGAY == null ? "0" : oT.THOIHAN_NGAY.ToString();
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("07-HS") || ddlQuyetdinh.SelectedItem.Text.Contains("08-HS"))
            {
                pnDieuLuatBS.Visible = true;
            }
            else { pnDieuLuatBS.Visible = false; }
            LoadNguoiKyDdlInfo();
        }

        public void LoadGrid()
        {
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue);
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_ST_QD_BICAN_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int Total = oDT.Rows.Count;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                rpt.DataSource = oDT;
                rpt.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void rpt_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            List<AHS_SOTHAM_THULY> thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ToList();
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
                DataRowView dv = (DataRowView)e.Item.DataItem;
                decimal QDID = Convert.ToDecimal(dv["ID"].ToString());
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
 
                ImageButton cmdDowload = (ImageButton)e.Item.FindControl("cmdDowload");
                String tenfile = string.IsNullOrEmpty(dv["TenFile"] + "") ? "" : dv["TenFile"].ToString();
                if (tenfile.Length > 0)
                    cmdDowload.Visible = true;
                else
                    cmdDowload.Visible = false;

                //AHS_SOTHAM_QUYETDINH_VUAN qdbc_tl = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.ID == QDID && x.THULYID == THULYID).FirstOrDefault();
                //if(qdbc_tl == null)
                //{
                //    lblSua.Text = "Chi tiết";
                //    lbtXoa.Visible = false;
                //    return;
                //}
                //else
                //{


                //}
                decimal donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]?.ToString());

                decimal toaAnId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                //quyết định trước khi chuyển án không được sửa
                AHS_CHUYEN_NHAN_AN chuyenAn = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID && x.TOACHUYENID == toaAnId).OrderBy(x => x.NGAYTAO).FirstOrDefault();
                if (chuyenAn != null)
                {
                    AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => (x.LOAIKHANGCAO == 3) && x.SOQDBA == QDID && x.NGAYTAO > chuyenAn.NGAYTAO).FirstOrDefault();
                    AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => (x.LOAIKN == 3) && x.BANANID == QDID && x.NGAYTAO > chuyenAn.NGAYTAO).FirstOrDefault();
                    if (kc != null || kn != null)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                        return;
                    }

                    AHS_SOTHAM_QUYETDINH_BICAN qd = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.ID == QDID).FirstOrDefault();
                    if (qd != null && qd.NGAYTAO < chuyenAn.NGAYTAO)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                        return;
                    }
                }
                else
                {
                    AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => (x.LOAIKHANGCAO == 3) && x.SOQDBA == QDID && x.TOA_GIAIQUYET_ID == donvi_ID).FirstOrDefault();
                    AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => (x.LOAIKN == 3) && x.BANANID == QDID && x.TOA_GIAIQUYET_ID == donvi_ID).FirstOrDefault();
                    AHS_SOTHAM_QUYETDINH_VUAN qdbc_tl = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.THULYID == THULYID && x.TOA_GIAIQUYET_ID == donvi_ID).FirstOrDefault();
                    if (kc != null || kn != null || qdbc_tl != null)
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                        return;
                    }
                }

                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                string toagiaiquyetID = e.Item.Cells[8].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                //dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
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
                //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion

        public void xoa(decimal id)
        {
            AHS_SOTHAM_QUYETDINH_BICAN oND = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                // kiểm tra nếu quyết định của đơn vị khác thì không được xóa
                if (oND.DONVIID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                {
                    lbthongbao.Text = "Quyết định đang chọn thuộc thẩm quyền của tòa án khác, không được phép thay đổi !";
                    return;
                }
                // không vấn đề gì thì tiến hành xóa
                AHS_FILE file = dt.AHS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                if (file != null)
                {
                    dt.AHS_FILE.Remove(file);
                }
                //Luu thong tin Quyết định bi can Sơ thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                oND.NOIDUNGFILE = null;//anhvh add 08/05/2023 để sửa lỗi trên "Error during serialization or deserialization using the JSON JavaScriptSerializer.The length of the string exceeds the value set on the maxJsonLength property."
                var json = new JavaScriptSerializer().Serialize(oND);

                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.VUANID), 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Quyết định bi can Sơ thẩm Hình sự", "Xóa", json) == false)
                {
                    lbthongbao.Text = "Xóa không thành công!";
                    return;
                }//Ket thuc
                 //Xoa Quyết định bi can Sơ thẩm
                dt.AHS_SOTHAM_QUYETDINH_BICAN.Remove(oND);
                dt.SaveChanges();
            }
            //dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            lbthongbao.Text = "";
            AHS_SOTHAM_QUYETDINH_BICAN oND = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.ID == ID).FirstOrDefault();
            dropThuLy.SelectedValue = oND.THULYID.ToString();
            hddid.Value = oND.ID.ToString();
            try
            {
                ddlBiCan.SelectedValue = oND.BICANID.ToString();
            }
            catch { }

            try
            {
                if (oND.LOAIQDID != null)
                    ddlLoaiQD.SelectedValue = oND.LOAIQDID.ToString();
            }
            catch { }

            LoadQD();
            try
            {
                if (oND.QUYETDINHID != null)
                {
                    ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
                    if (ddlQuyetdinh.SelectedItem.Text.Contains("07-HS") || ddlQuyetdinh.SelectedItem.Text.Contains("08-HS"))
                    {
                        pnDieuLuatBS.Visible = true;
                        ddlDieuLuatBS.SelectedValue = oND.DIEULUATAPDUNGTHEM;
                        txtNghiAnNgay.Text = oND.BIENBANNGHIAN_NGAY + "" == "" ? "" : ((DateTime)oND.BIENBANNGHIAN_NGAY).ToString("dd/MM/yyyy");
                    }
                    else
                    {
                        pnDieuLuatBS.Visible = false;
                    }
                }
            }
            catch { }

            txtSoQD.Text = oND.SOQUYETDINH;
            txtNgayQD.Text = string.IsNullOrEmpty(oND.NGAYQD + "") ? "" : ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);
            txtHieulucTuNgay.Text = string.IsNullOrEmpty(oND.HIEULUCTU + "") ? "" : ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            txtHieuLucDenNgay.Text = string.IsNullOrEmpty(oND.HIEULUCDEN + "") ? "" : ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if (ddlLoaiQD.SelectedValue == LoaiQD_BatTamGiam.ToString())
            {
                pnNoiGiamGiu.Visible = true;
                txtNoiGiamGiu.Text = oND.NOIGIAMGIU + "";
            }
            else
                pnNoiGiamGiu.Visible = false;

            if (txtHieuLucDenNgay.Text == "")
                ddlQuyetdinh_SelectedIndexChanged(new object(), new EventArgs());

            DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == oND.NGUOIKYID).FirstOrDefault<DM_CANBO>();
            if (cbo != null)
                ddlNguoiky.SelectedValue = oND.NGUOIKYID.ToString();
            //txtNguoiKy.Text = cbo.HOTEN;
            //txtChucvu.Text = oND.CHUCVU;

            //txtHanTheoLuatThang.Text = oND.THEOLUAT_THANG == null ? "0" : oND.THEOLUAT_THANG.ToString();
            //txtHanTheoLuatNgay.Text = oND.THEOLUAT_NGAY == null ? "0" : oND.THEOLUAT_NGAY.ToString();
            //txtTheoLuatNgayKetThuc.Text = string.IsNullOrEmpty(oND.THEOLUAT_NGAYKETTHUC + "") ? "" : ((DateTime)oND.THEOLUAT_NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
            //txtThucTeThang.Text = oND.THUCTE_THANG == null ? "0" : oND.THUCTE_THANG.ToString();
            //txtThucTeNgay.Text = oND.THUCTE_NGAY == null ? "0" : oND.THUCTE_NGAY.ToString();
            //txtThucTeNgayKetThuc.Text = string.IsNullOrEmpty(oND.THUCTE_NGAYKETTHUC + "") ? "" : ((DateTime)oND.THUCTE_NGAYKETTHUC).ToString("dd/MM/yyyy", cul);

            if ((oND.TENFILE + "") != "")
            {
                lbtDownload.Visible = true;
            }
            else
                lbtDownload.Visible = false;
        }
        protected void rpt_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
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
                    case "Download":
                        DowloadFile(ND_id);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void DowloadFile(Decimal CurrID)
        {
            try
            {
                AHS_SOTHAM_QUYETDINH_BICAN oND = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.ID == CurrID).FirstOrDefault();
                if (oND.TENFILE != "")
                {
                    if (oND.NOIDUNGFILE != null)
                    {
                        var cacheKey = Guid.NewGuid().ToString("N");
                        Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS()+ "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                    }
                    else
                    {
                        string temp = "Tệp đính kèm không có nội dung. Không thể tải về được!";
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", temp);
                    }
                }
            }
            catch (Exception ex)
            {
                // lttThongBaoTop.Text = lbthongbao.Text = ex.Message;
            }
        }
        private decimal UploadFileID(AHS_VUAN oVuAn, decimal BiCanID, decimal FileID, string strMaBieumau)
        {
            decimal IDFIle = 0, IDBM = 0;
            List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
            if (lstBM.Count > 0)
            {
                IDBM = lstBM[0].ID;
            }
            AHS_FILE objFile = new AHS_FILE();
            if (FileID > 0)
            {
                objFile = dt.AHS_FILE.Where(x => x.ID == FileID).FirstOrDefault();
            }
            objFile.BICAOID = BiCanID;
            objFile.VUANID = oVuAn.ID;
            objFile.TOAANID = oVuAn.TOAANID;
            objFile.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
            objFile.LOAIFILE = 0;
            objFile.BIEUMAUID = IDBM;
            objFile.NAM = DateTime.Now.Year;
            objFile.NGAYTAO = DateTime.Now;
            objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            if (FileID == 0)
            {
                dt.AHS_FILE.Add(objFile);
            }
            dt.SaveChanges();
            IDFIle = objFile.ID;
            return IDFIle;
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

            List<AHS_SOTHAM_THULY> tl = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ToList();
            if (tl.Count != 0)
            {
                decimal THULYID = tl[0].ID;

                dropThuLy.SelectedValue = THULYID.ToString();
            }
            else
            {
                lbthongbao.Text = "Vụ việc chưa được thụ lý. Hãy kiểm tra lại !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }
        }

        protected void dropThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal VUANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            List<AHS_SOTHAM_THULY> thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VUANID).OrderByDescending(x => x.NGAYTHULY).ToList();
            if (thuly.Count != 0)
            {
                decimal THULYID = thuly[0].ID;

                List<AHS_SOTHAM_QUYETDINH_BICAN> qd = dt.AHS_SOTHAM_QUYETDINH_BICAN
                    .Where(x => x.VUANID == VUANID && x.THULYID == THULYID).ToList();
                List<AHS_SOTHAM_BANAN> qdBC = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VUANID && x.THULYID == THULYID)
                    .ToList();

                if (dropThuLy.SelectedValue == "0")
                {
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }
                else if (dropThuLy.SelectedValue == THULYID.ToString() && qd.Count == 0 && qdBC.Count == 0)
                {
                    Cls_Comon.SetButton(cmdUpdate, true);
                    Cls_Comon.SetButton(cmdLammoi, true);
                }
                else
                {
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }
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
    }
}