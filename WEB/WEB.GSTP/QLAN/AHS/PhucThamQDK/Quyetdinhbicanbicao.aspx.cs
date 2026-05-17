using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.AHS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.PhucThamQDK
{
    public partial class Quyetdinhbicanbicao : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        public static string NgayThuLy;
        public static decimal LoaiQD_BatTamGiam = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoaiQD_BatTamGiam = dt.DM_QD_LOAI.Where(x => x.MA == ENUM_LOAI_QD_AHS.BAT_TAMGIAM).FirstOrDefault().ID;
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    if (current_id == "")
                        Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    LoadCombobox();
                    //---------------
                    decimal LoaiQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                    if (LoaiQDID == LoaiQD_BatTamGiam)
                    {
                        pnThoigiangiam.Visible = pnNoiGiamGiu.Visible = true;
                    }
                    else
                        pnThoigiangiam.Visible = pnNoiGiamGiu.Visible = false;
                    //--------------
                    //LoadNguoiKyInfo();
                    LoadNguoiKyDdlInfo();
                    hddPageIndex.Value = "1";
                    dgList.CurrentPageIndex = 0;
                    check_quyen();
                    LoadGrid();
                    decimal VuAnID = Convert.ToDecimal(current_id);
                    AHS_KCKNQDK_PHUCTHAM_THULY objTL = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_THULY>($"VUANID = {VuAnID}").OrderByDescending(y => y.NGAYTHULY).FirstOrDefault();
                    if (objTL != null)
                        NgayThuLy = ((DateTime)objTL.NGAYTHULY).ToString("dd/MM/yyyy");
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
                string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
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
                string toaGiaiQuyetID = e.Item.Cells[8].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
            }
        }

        private void check_quyen()
        {
            hddShowCommand.Value = "True";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);

            //Kiểm tra thẩm phán giải quyết đơn
            decimal VuANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable QDKetThuc = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuANID);

            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuANID).FirstOrDefault();
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

            if (QDKetThuc != null && QDKetThuc.Rows.Count > 0)
            {
                lbthongbao.Text = "Đã có kết quả phúc thẩm , Không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            int MaGiaiDoan = (int)oT.MAGIAIDOAN;

            List<AHS_KCKNQDK_PHUCTHAM_THULY> lstCount = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_THULY>($"VUANID = {VuANID}").ToList();
            if (lstCount.Count == 0
                || MaGiaiDoan == ENUM_GIAIDOANVUAN.HOSO
                || MaGiaiDoan == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            //if (!Check_Phancongthamphan())
            //{
            //    lbthongbao.Text = "Vụ việc chưa được phân công thẩm phán. Đề nghị cập nhật thông tin 'Phân công thẩm phán giải quyết' !";
            //    Cls_Comon.SetButton(cmdUpdate, false);
            //    Cls_Comon.SetButton(cmdLammoi, false);
            //}
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
        }

        private Boolean Check_Phancongthamphan()
        {
            Decimal VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

            try
            {
                List<AHS_THAMPHANGIAIQUYET> lst = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID
                                                        && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList<AHS_THAMPHANGIAIQUYET>();
                if (lst != null && lst.Count > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception exx) { return false; }
        }

        private void LoadCombobox()
        {
            // Load Bị can/bị can
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_KCKNQDK_PHUCTHAM_BL objBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable tbl = objBL.GetAllBiCanPhucTham(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlBiCan.DataSource = tbl;
                ddlBiCan.DataTextField = "TenBiCan";
                ddlBiCan.DataValueField = "BiCanID";
                ddlBiCan.DataBind();
            }
            else
            {
                ddlBiCan.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }

            // Load loại quyết định và quyết định  có liên quan đến bị can bị cáo (ISDUONGSUYEUCAU == 1)
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

        private void LoadQD()
        {
            decimal ID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            ddlQuyetdinh.Items.Clear();
            List<DM_QD_QUYETDINH> lst = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == ID && x.ISHINHSU == 1 && x.ISPHUCTHAM == 1 && x.MA.Contains("HS")).OrderBy(y => y.THUTU).ToList();
            if (lst != null && lst.Count > 0)
            {
                ddlQuyetdinh.DataSource = lst;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
                ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
                ddlQuyetdinh.Items.Add(new ListItem("--- Chọn ---", "0"));
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
            AHS_KCKNQDK_PHUCTHAM_HDXX oND = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_HDXX>($"VUANID = {VuAnID} AND MAVAITRO = '{ENUM_NGUOITIENHANHTOTUNG.THAMPHAN}'").OrderByDescending(x => x.ID).FirstOrDefault();
            if (oND != null)
            {
                CanBoID = Convert.ToDecimal(oND.NGUOIPHANCONGID.ToString());//Convert.ToDecimal(oND.CANBOID.ToString());
            }
            string TenBieuMau = ddlQuyetdinh.SelectedItem.Text;
            // Các quyết định do thẩm phán được phân công giải quyết ký: 36-HS,39-HS,51-HS
            if (TenBieuMau.Contains("36-HS") || TenBieuMau.Contains("39-HS") || TenBieuMau.Contains("51-HS"))
            {
                AHS_THAMPHANGIAIQUYET obj = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == "VTTP_GIAIQUYETPHUCTHAM").OrderByDescending(x => x.ID).FirstOrDefault<AHS_THAMPHANGIAIQUYET>();
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
            AHS_KCKNQDK_PHUCTHAM_HDXX oND = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_HDXX>($"VUANID = {VuAnID} AND MAVAITRO = '{ENUM_NGUOITIENHANHTOTUNG.THAMPHAN}'").OrderByDescending(x => x.ID).FirstOrDefault();
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
                AHS_THAMPHANGIAIQUYET oTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).OrderByDescending(x => x.ID).FirstOrDefault();
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
            ddlBiCan.SelectedIndex = 0;
            ddlLoaiQD.SelectedIndex = 0;
            LoadQD();
            ddlQuyetdinh.SelectedIndex = 0;
            lbthongbao.Text = txtSoQD.Text = txtHieulucTuNgay.Text = txtHieuLucDenNgay.Text = "";
            //txtHanTheoLuatThang.Text = txtHanTheoLuatNgay.Text = "";
            //txtTheoLuatNgayKetThuc.Text = txtThucTeThang.Text = txtThucTeNgay.Text = txtThucTeNgayKetThuc.Text = "";
            txtNoiGiamGiu.Text = ""; txtNghiAnNgay.Text = ""; ddlDieuLuatBS.SelectedIndex = 0;
            hddid.Value = "0";
            hddFilePath.Value = "";
            lbtDownload.Visible = false;
            //txtChucvu.Text = "";
            //ddlNguoiky.SelectedValue = "0";
            txtSoNgay.Text = "";
            ch_tthp_va_khac.Checked = false;
        }

        private bool CheckValid()
        {
            if (ddlBiCan.SelectedValue == "" || ddlBiCan.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn bị cáo. Hãy chọn lại.";
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
            if (ddlQuyetdinh.SelectedItem.Text.Contains("11-HS") || ddlQuyetdinh.SelectedItem.Text.Contains("12-HS"))
            {
                if (txtNghiAnNgay.Text != "")
                {
                    if (Cls_Comon.IsValidDate(txtNghiAnNgay.Text) == false)
                    {
                        lbthongbao.Text = "Biên bản nghị án ngày phải theo kiểu (Ngày/Tháng/Năm). Hãy nhập lại";
                        txtNghiAnNgay.Focus();
                        return false;
                    }
                    //else
                    //{
                    //    DateTime BBNghiAnNgay = DateTime.Parse(txtNghiAnNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    //    if (BBNghiAnNgay < DNgayThuLy)
                    //    {
                    //        lbthongbao.Text = "Biên bản nghị án ngày phải lớn hơn hoặc bằng ngày thụ lý phúc thẩm (" + DNgayThuLy.ToString("dd/MM/yyyy") + "). Hãy nhập lại";
                    //        txtNghiAnNgay.Focus();
                    //        return false;
                    //    }
                    //    if (BBNghiAnNgay > DateTime.Today)
                    //    {
                    //        lbthongbao.Text = "Biên bản nghị án ngày phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại";
                    //        txtNghiAnNgay.Focus();
                    //        return false;
                    //    }
                    //}
                }
            }
            if (txtSoQD.Text.Trim() == "")
            {
                lbthongbao.Text = "Chưa nhập số quyết định. Hãy nhập lại.";
                txtSoQD.Focus();
                return false;
            }
            else
            {
                if (txtSoQD.Text.Trim().Length > 50)
                {
                    lbthongbao.Text = "Số quyết định không nhập quá 50 ký tự. Hãy nhập lại.";
                    txtSoQD.Focus();
                    return false;
                }
            }
            DateTime NgayQD;
            if (txtNgayQD.Text == "")
            {
                lbthongbao.Text = "Chưa nhập ngày quyết định. Hãy nhập lại.";
                txtNgayQD.Focus();
                return false;
            }
            else
            {
                if (!DateTime.TryParseExact(txtNgayQD.Text, "dd/MM/yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayQD))
                {
                    lbthongbao.Text = "Ngày quyết định chưa nhập đúng kiểu (Ngày/Tháng/Năm). Hãy nhập lại.";
                    txtNgayQD.Focus();
                    return false;
                }
                //if (NgayQD < DNgayThuLy)
                //{
                //    lbthongbao.Text = "Ngày quyết định phải lớn hơn ngày thụ lý phúc thẩm (" + DNgayThuLy.ToString("dd/MM/yyyy") + "). Hãy nhập lại.";
                //    txtNgayQD.Focus();
                //    return false;
                //}
                //if (NgayQD > DateTime.Today)
                //{
                //    lbthongbao.Text = "Ngày quyết định phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại.";
                //    txtNgayQD.Focus();
                //    return false;
                //}
            }
            //if (ddlNguoiky.SelectedValue == "")
            //{
            //    lbthongbao.Text = "Vụ án chưa có thẩm phán chủ tọa phiên tòa. Hãy chọn chức năng \"Người tiến hành tố tụng\" để thêm chủ tọa phiên tòa!";
            //    return false;
            //}
            DateTime HieuLucTu;
            if (txtHieulucTuNgay.Text == "")
            {
                lbthongbao.Text = "Chưa nhập hiệu lực từ ngày. Hãy nhập lại.";
                txtHieulucTuNgay.Focus();
                return false;
            }
            else
            {
                if (!DateTime.TryParseExact(txtHieulucTuNgay.Text, "dd/MM/yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out HieuLucTu))
                {
                    lbthongbao.Text = "Hiệu lực từ ngày chưa nhập đúng kiểu (Ngày/Tháng/Năm). Hãy nhập lại.";
                    txtHieulucTuNgay.Focus();
                    return false;
                }
                //if (HieuLucTu < NgayQD)
                //{
                //    lbthongbao.Text = "Hiệu lực từ ngày phải lớn hơn hoặc bằng ngày quyết định. Hãy nhập lại.";
                //    txtHieulucTuNgay.Focus();
                //    return false;
                //}
            }
            if (ddlLoaiQD.SelectedValue != "3")
            {
                if (txtHieuLucDenNgay.Text == "")
                {
                    lbthongbao.Text = "Chưa nhập hiệu lực đến ngày. Hãy nhập lại.";
                    txtHieuLucDenNgay.Focus();
                    return false;
                }
                else
                {
                    DateTime HieuLucDen;
                    if (!DateTime.TryParseExact(txtHieuLucDenNgay.Text, "dd/MM/yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out HieuLucDen))
                    {
                        lbthongbao.Text = "Hiệu lực đến ngày chưa nhập đúng kiểu (Ngày/Tháng/Năm). Hãy nhập lại.";
                        txtHieuLucDenNgay.Focus();
                        return false;
                    }
                    if (HieuLucDen < HieuLucTu)
                    {
                        lbthongbao.Text = "Hiệu lực đến ngày phải lớn hơn hoặc bằng hiệu lực từ ngày. Hãy nhập lại.";
                        txtHieuLucDenNgay.Focus();
                        return false;
                    }
                }
            }
            //------------------
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

        private Boolean CheckExist(Decimal CurrID)
        {
            String SoQD = txtSoQD.Text.Trim();
            Decimal BiCanID = Convert.ToDecimal(ddlBiCan.SelectedValue),
                VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            //--------------
            Decimal LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            Decimal QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN obj = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN>($"VUANID = {VuAnID} AND BICANID = {BiCanID} AND LOAIQDID = {LOAIQDID} AND QUYETDINHID = {QUYETDINHID} AND SOQUYETDINH ='{SoQD}'").FirstOrDefault();
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

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + ""), FileID = 0,
                    curr_id = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                if (!CheckExist(curr_id))
                    return;
                AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN oND;
                if (curr_id == 0)
                    oND = new AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN>(ID);
                    if (oND.FILEID != null) FileID = (decimal)oND.FILEID;
                }
                oND.BICANID = Convert.ToDecimal(ddlBiCan.SelectedValue);
                oND.VUANID = VuAnID;
                oND.LOAIQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                if (oND.LOAIQDID == LoaiQD_BatTamGiam)
                { oND.NOIGIAMGIU = txtNoiGiamGiu.Text.Trim(); }
                if (ddlQuyetdinh.SelectedItem.Text.Contains("11-HS") || ddlQuyetdinh.SelectedItem.Text.Contains("12-HS"))
                {
                    oND.DIEULUATAPDUNGTHEM = ddlDieuLuatBS.SelectedValue;
                    if (Cls_Comon.IsValidDate(txtNghiAnNgay.Text))
                    {
                        oND.BIENBANNGHIAN_NGAY = DateTime.Parse(txtNghiAnNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                }
                oND.DONVIID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.SOQUYETDINH = txtSoQD.Text;
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oND.NGUOIKYID = Convert.ToDecimal(hddNguoiKyID.Value);
                oND.NGUOIKYID = Convert.ToDecimal(ddlNguoiky.SelectedValue);
                //oND.CHUCVU = txtChucvu.Text;
                oND.HINHPHAT_VUAN_KHAC = Convert.ToDecimal(ch_tthp_va_khac.Checked);
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
                    DataExtensions.Insert(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Update(oND);
                }
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        public void LoadGrid()
        {
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable oDT = oBL.DGLIST_QUYETDINH_BICAN_PTDC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, ID);
            if (oDT != null)
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
            ResetControls();
        }

        public void xoa(decimal id)
        {
            AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN>(id);
            if (oND != null)
            {
                AHS_FILE file = dt.AHS_FILE.Where(x => x.ID == oND.FILEID).FirstOrDefault();
                if (file != null)
                {
                    dt.AHS_FILE.Remove(file);
                }
                //Luu thong tin Quyết định bi can Phúc thẩm trước khi xoa
                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                var json = new JavaScriptSerializer().Serialize(oND);
                ADS_DON_BL oBL = new ADS_DON_BL();
                if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.VUANID), 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Quyết định bi can Phúc thẩm Hình sự", "Xóa", json) == false)
                {
                    lbthongbao.Text = "Xóa không thành công!";
                    return;
                }//Ket thuc
                 //Xoa Quyết định bi can Phúc thẩm
                DataExtensions.Delete(oND);
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
            AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN>(ID);
            hddid.Value = oND.ID.ToString();
            ddlBiCan.SelectedValue = oND.BICANID.ToString();
            if (oND.LOAIQDID != null) ddlLoaiQD.SelectedValue = oND.LOAIQDID.ToString();
            if (ddlLoaiQD.SelectedValue == LoaiQD_BatTamGiam.ToString())
            {
                pnThoigiangiam.Visible = pnNoiGiamGiu.Visible = true;
                txtNoiGiamGiu.Text = oND.NOIGIAMGIU + "";
            }
            else
                pnThoigiangiam.Visible = pnNoiGiamGiu.Visible = false;
            LoadQD();
            if (oND.QUYETDINHID != null)
            {
                ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
                if (ddlQuyetdinh.SelectedItem.Text.Contains("11-HS") || ddlQuyetdinh.SelectedItem.Text.Contains("12-HS"))
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

            txtSoNgay.Text = (oND.HIEULUCDEN + "" == "" ? 0 : ((DateTime)oND.HIEULUCDEN).Subtract((DateTime)oND.HIEULUCTU).Days).ToString();

            txtSoQD.Text = oND.SOQUYETDINH;
            txtNgayQD.Text = string.IsNullOrEmpty(oND.NGAYQD + "") ? "" : ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);
            txtHieulucTuNgay.Text = string.IsNullOrEmpty(oND.HIEULUCTU + "") ? "" : ((DateTime)oND.HIEULUCTU).ToString("dd/MM/yyyy", cul);
            txtHieuLucDenNgay.Text = string.IsNullOrEmpty(oND.HIEULUCDEN + "") ? "" : ((DateTime)oND.HIEULUCDEN).ToString("dd/MM/yyyy", cul);
            if (txtHieuLucDenNgay.Text == "")
            {
                ddlQuyetdinh_SelectedIndexChanged(new object(), new EventArgs());
            }
            DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == oND.NGUOIKYID).FirstOrDefault<DM_CANBO>();
            if (cbo != null)
            {
                ddlNguoiky.SelectedValue = oND.NGUOIKYID.ToString();
            }
            //txtChucvu.Text = oND.CHUCVU;
            ch_tthp_va_khac.Checked = Convert.ToBoolean(oND.HINHPHAT_VUAN_KHAC);

            if ((oND.TENFILE + "") != "")
            {
                lbtDownload.Visible = true;
            }
            else
                lbtDownload.Visible = false;
        }

        protected void txtSoNgay_TextChanged(object sender, EventArgs e)
        {
            //if (dropBienPhapNganChan.SelectedValue != "0"
            //        && dropBienPhapNganChan.SelectedValue == hddBPNC_TamGiam.Value)
            //{
            if (!string.IsNullOrEmpty(txtHieulucTuNgay.Text))
            {
                DateTime ngaybatdau = DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                int songay = String.IsNullOrEmpty(txtSoNgay.Text.Trim()) ? 0 : Convert.ToInt32(txtSoNgay.Text);
                DateTime ngaykt = ngaybatdau.AddDays(songay);
                txtHieuLucDenNgay.Text = ngaykt.ToString("dd/MM/yyyy", cul);
            }
            //}
        }

        protected void txtHieulucTuNgay_TextChanged(object sender, EventArgs e)
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_KCKNQDK_PHUCTHAM_BL objBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            if (!string.IsNullOrEmpty(txtHieulucTuNgay.Text))
            {
                if (ddlLoaiQD.SelectedValue == LoaiQD_BatTamGiam.ToString())
                {
                    DataTable tbl = objBL.Get_congthuc(VuAnID, this.txtHieulucTuNgay.Text.Trim());
                    txtSoNgay.Text = tbl.Rows[0]["KETQUAS"].ToString();
                    txtSoNgay_TextChanged(sender, e);
                }
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
                        AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN>(ND_id);
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
                        xoa(ND_id);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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

        #endregion "Phân trang"

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
                AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN>(ID);
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal LoaiQDID = Convert.ToDecimal(ddlLoaiQD.SelectedValue);
            if (LoaiQDID == LoaiQD_BatTamGiam)
            {
                pnThoigiangiam.Visible = pnNoiGiamGiu.Visible = true;
            }
            else
                pnThoigiangiam.Visible = pnNoiGiamGiu.Visible = false;
            LoadQD();
            ddlQuyetdinh_SelectedIndexChanged(sender, e);
            Cls_Comon.SetFocus(this, this.GetType(), ddlQuyetdinh.ClientID);
        }

        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
            DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                hddThoiHanThang.Value = oT.THOIHAN_THANG == null ? "0" : oT.THOIHAN_THANG.ToString();
                hddThoiHanNgay.Value = oT.THOIHAN_NGAY == null ? "0" : oT.THOIHAN_NGAY.ToString();
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("11-HS") || ddlQuyetdinh.SelectedItem.Text.Contains("12-HS"))
            {
                pnDieuLuatBS.Visible = true;
            }
            else { pnDieuLuatBS.Visible = false; }
            LoadNguoiKyDdlInfo();
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
            objFile.TOAANID = oVuAn.TOAPHUCTHAMID;
            objFile.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
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
    }
}