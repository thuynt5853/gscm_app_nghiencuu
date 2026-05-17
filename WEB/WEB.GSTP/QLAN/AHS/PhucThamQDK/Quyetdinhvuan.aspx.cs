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
    public partial class Quyetdinhvuan : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        private decimal VuAnID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                if (!IsPostBack)
                {
                    hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                    if (VuAnID == 0) Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");

                    LoadQD();

                    txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    SetNewSoQD();

                    LoadNguoiKyTxtInfo();
                    LoadNguoiKyDdlInfo();
                    hddPageIndex.Value = "1";
                    dgList.CurrentPageIndex = 0;

                    CheckQuyen();
                    LoadGrid();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);

            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable QDKetThuc = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID);

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

            if (QDKetThuc != null && QDKetThuc.Rows.Count > 0)
            {
                lbthongbao.Text = "Đã có kêt quả phúc thẩm , Không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            //Kiểm tra thẩm phán giải quyết đơn
            List<AHS_KCKNQDK_PHUCTHAM_THULY> lstCount = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_THULY>($"VUANID = {VuAnID}").ToList();
            if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            if (!Check_Phancongthamphan())
            {
                lbthongbao.Text = "Vụ việc chưa được phân công thẩm phán. Đề nghị cập nhật thông tin 'Phân công thẩm phán giải quyết' !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
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
            txtSoQD.Text = oSTBL.GET_SQD_NEW(DonViID, "AHS_PT", ngayBD, LoaiQD).ToString();
        }

        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        {
            SetNewSoQD();
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

                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                // check quyền để hiển thị nút xoá
                string toaGiaiQuyetID = e.Item.Cells[9].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

            }
        }

        private Boolean Check_Phancongthamphan()
        {
            Decimal VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

            try
            {
                List<AHS_THAMPHANGIAIQUYET> lst = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList<AHS_THAMPHANGIAIQUYET>();
                if (lst != null && lst.Count > 0)
                    return true;
                else
                    return false;
            }
            catch { return false; }
        }

        private void LoadCombobox()
        {
            // Loại quyết định bắt tạm giam không hiển thị ở quyết định vụ án (ISDUONGSUYEUCAU=1)
            ddlLoaiQD.DataSource = dt.DM_QD_LOAI.Where(x => x.HIEULUC == 1 && x.ISHINHSU == 1 && x.ISDUONGSUYEUCAU != 1).OrderBy(y => y.THUTU).ToList();
            ddlLoaiQD.DataTextField = "TEN";
            ddlLoaiQD.DataValueField = "ID";
            ddlLoaiQD.DataBind();
            ddlLoaiQD.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            LoadQD();
        }

        private void LoadQD()
        {
            //Load Tên quyết định PKG_LOAD_DM_QDVUAN
            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable oDT = oBL.AHS_DM_QUYETDINH_VUAN_PTTDC();

            if (oDT != null)
            {
                ddlQuyetdinh.DataSource = oDT;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }

            //ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
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
            if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử"))
            {
                ltNMPT.Text = "<span style='color:red'>(*)</span>";
            }
            else
            {
                ltNMPT.Text = "";
            }

            //decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_KCKNQDK_PHUCTHAM_BL oBL = new AHS_KCKNQDK_PHUCTHAM_BL();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                if (ddlQuyetdinh.SelectedItem.Text.Contains("Thông báo sửa chữa"))
                {
                    Cls_Comon.SetButton(cmdUpdate, true);
                    return;
                }
                else
                {
                    Cls_Comon.SetButton(cmdUpdate, false);
                    return;
                }
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
            ddlNguoiDuocPC.Items.Clear();
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            string tucach = ddlThayDoi.SelectedValue == "1" ? "TP" : (ddlThayDoi.SelectedValue == "2" ? "HTND" : "THUKY");
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable tbl = objBL.DMCANBO_DUOCPC_BM03HS_PT(ToaAnID, VuAnID, tucach);
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
            DataTable tbl = objBL.DMCANBO_NGUOIBITHAYDOI_TCTT_PT(VuAnID, tucach);
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

        private void LoadNguoiKyTxtInfo()
        {
            decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            AHS_KCKNQDK_PHUCTHAM_HDXX oND = DataExtensions.GetAllWithClause<AHS_KCKNQDK_PHUCTHAM_HDXX>($"VUANID = {DonID} AND MAVAITRO = '{ENUM_NGUOITIENHANHTOTUNG.THAMPHAN}'").OrderByDescending(x => x.ID).FirstOrDefault();
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
                AHS_THAMPHANGIAIQUYET oTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == DonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).OrderByDescending(x => x.ID).FirstOrDefault();
                if (oTP != null)
                {
                    decimal CanBoID = Convert.ToDecimal(oTP.CANBOID.ToString());
                    DataTable dtCanBo = cb_BL.DM_CANBO_GETINFOBYID(CanBoID);
                    if (dtCanBo.Rows.Count > 0)
                    {
                        txtNguoiKy.Text = dtCanBo.Rows[0]["HOTEN"].ToString();
                        txtChucvu.Text = "Thẩm phán chủ tọa";
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
            ddlLoaiQD.SelectedIndex = 0;
            ddlQuyetdinh.SelectedIndex = 0;
            ddlLydo.SelectedIndex = 0; ddlLydo_BM03.SelectedIndex = 0;
            pnLyDo.Visible = false;
            pnLyDo_BM03.Visible = false;
            pntxtLydo.Visible = false;

            //LoadQD();
            lbthongbao.Text = txtSoQD.Text = txtHieulucTuNgay.Text = txtHieuLucDenNgay.Text = "";
            //txtHanTheoLuatThang.Text = txtHanTheoLuatNgay.Text = "";
            //txtTheoLuatNgayKetThuc.Text = txtThucTeThang.Text = txtThucTeNgay.Text = txtThucTeNgayKetThuc.Text = "";
            //txtGhichu.Text = "";
            hddid.Value = "0";
            hddFilePath.Value = "";
            lbtDownload.Visible = false;
        }

        private bool CheckValid()
        {
            if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") && ddlHTXX.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn hình thức xét xử";
                return false;
            }
            if (ddlQuyetdinh.SelectedItem.Text.Contains("Quyết định đưa vụ án ra xét xử") && Cls_Comon.IsValidDate(txtNgayMoPhienToa.Text) == false)
            {
                lbthongbao.Text = "Chưa nhập ngày mở phiên toà hoặc không hợp lệ !";
                txtNgayMoPhienToa.Focus();
                return false;
            }
            if (ddlQuyetdinh.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn quyết định!";
                ddlQuyetdinh.Focus();
                return false;
            }
            if (pntxtLydo.Visible)
            {
                if (txtLydo.Text == "" || txtLydo.Text == null)
                {
                    lbthongbao.Text = "Bạn chưa nhập lý do. Hãy nhập lại!";
                    txtLydo.Focus();
                    return false;
                }
            }

            if (!String.IsNullOrEmpty(txtSoQD.Text))
            {
                int lengthSQD = txtSoQD.Text.Trim().Length;
                if (lengthSQD == 0)
                {
                    lbthongbao.Text = "Bạn chưa nhập số quyết định!";
                    txtSoQD.Focus();
                    return false;
                }
                if (lengthSQD > 50)
                {
                    lbthongbao.Text = "Số quyết định không quá 50 ký tự. Hãy nhập lại!";
                    txtSoQD.Focus();
                    return false;
                }
            }
            if (!String.IsNullOrEmpty(txtNgayQD.Text))
            {
                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbthongbao.Text = "Chưa nhập ngày quyết định hoặc không hợp lệ !";
                    txtNgayQD.Focus();
                    return false;
                }
            }
            if (!String.IsNullOrEmpty(txtHieulucTuNgay.Text))
            {
                if (Cls_Comon.IsValidDate(txtHieulucTuNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập hiệu lực từ ngày theo định dạng (dd/MM/yyyy)!";
                    txtHieulucTuNgay.Focus();
                    return false;
                }
            }
            if (!String.IsNullOrEmpty(txtHieuLucDenNgay.Text) && !String.IsNullOrEmpty(txtHieulucTuNgay.Text))
            {
                if (Cls_Comon.IsValidDate(txtHieuLucDenNgay.Text))
                {
                    DateTime tuNgay = DateTime.Parse(txtHieulucTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    DateTime denNgay = DateTime.Parse(txtHieuLucDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (DateTime.Compare(tuNgay, denNgay) > 0)
                    {
                        lbthongbao.Text = "Hiệu lực từ ngày phải nhỏ hơn hiệu lực đến ngày !";
                        txtHieuLucDenNgay.Focus();
                        return false;
                    }
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
                Decimal CheckID = oSTBL.CHECK_SQDTheoLoaiAn(DonViID, "AHS_PT", so, ngay, LoaiQD);
                if (CheckID > 0)
                {
                    String strMsg = "";
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHS_PT", ngay, LoaiQD).ToString();
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
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>(ID);
                }
                oND.VUANID = VuAnID;
                oND.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                oND.NGAYMOPT = (String.IsNullOrEmpty(txtNgayMoPhienToa.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayMoPhienToa.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.DIADIEMMOPT = txtDiaDiem.Text.Trim();

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
                                DataExtensions.Insert(obj);
                            }
                            else
                            {
                                DataExtensions.Update(obj);
                            }
                        }
                    }
                    oND.THAYDOITCTT = Convert.ToDecimal(ddlThayDoi.SelectedValue);
                    oND.NGUOIDUOCPHANCONG = Convert.ToDecimal(ddlNguoiDuocPC.SelectedValue);
                    oND.NGUOIBITHAY = Convert.ToDecimal(ddlNguoiBiThayDoi.SelectedValue);
                }
                oND.DONVIID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                oND.SOQUYETDINH = txtSoQD.Text;
                oND.HINHTHUCXETXU = Convert.ToDecimal(ddlHTXX.SelectedValue);
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCTU = (String.IsNullOrEmpty(txtHieulucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieulucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HIEULUCDEN = (String.IsNullOrEmpty(txtHieuLucDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
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

                DM_QD_QUYETDINH oQDT = dt.DM_QD_QUYETDINH.Where(x => x.ID == oND.QUYETDINHID).FirstOrDefault();
                if (oQDT != null)
                {
                    oND.LOAIQDID = oQDT.LOAIID;
                    oND.FILEID = UploadFileID(VuAnID, oQDT.MA);
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
                if (hddid.Value == "" || hddid.Value == "0")
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
            DataTable oDT = oBL.DGLIST_QUYETDINH_PTTDC(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, ID);
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
            pnHinhThucXetXu.Visible = false;
            ResetControls();
            ddlQuyetdinh_SelectedIndexChanged(new object(), new EventArgs());
        }

        public void xoa(decimal id)
        {
            AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>(id);
            //Luu thong tin Quyết định vụ việc Phúc thẩm trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oND);
            ADS_DON_BL oBL = new ADS_DON_BL();
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.VUANID), 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Quyết định vụ việc Phúc thẩm Hình sự", "Xóa", json) == false)
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }//Ket thuc
             //Xoa Quyết định vụ việc Phúc thẩm
            DataExtensions.Delete(oND);
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }

        public void loadedit(decimal ID)
        {
            lbthongbao.Text = "";
            AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>(ID);
            hddid.Value = oND.ID.ToString();
            if (oND.QUYETDINHID != null) ddlQuyetdinh.SelectedValue = oND.QUYETDINHID.ToString();
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
                get_valueLydo(ID);
            }
            txtDiaDiem.Text = oND.DIADIEMMOPT + "";
            if (oND.NGAYMOPT != null) txtNgayMoPhienToa.Text = ((DateTime)oND.NGAYMOPT).ToString("dd/MM/yyyy", cul);
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
                    //ddlLoaiQD.SelectedValue = oT.LOAIID + "";
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
            //if (cbo != null)
            //{
            //    txtNguoiKy.Text = cbo.HOTEN;
            //}
            //txtChucvu.Text = oND.CHUCVU;

            if ((oND.TENFILE + "") != "")
            {
                lbtDownload.Visible = true;
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
                        AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>(ND_id);
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
                AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN oND = DataExtensions.FindById<AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN>(ID);
                if (oND.TENFILE != "")
                {
                    var cacheKey = Guid.NewGuid().ToString("N");
                    Context.Cache.Insert(key: cacheKey, value: oND.NOIDUNGFILE, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + oND.TENFILE + "&Extension=" + oND.KIEUFILE + "';", true);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        //protected void ddlLoaiQD_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    LoadQD();
        //    ddlQuyetdinh_SelectedIndexChanged(new object(), new EventArgs());
        //}
        protected void ddlQuyetdinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);
                DM_QD_QUYETDINH oT = dt.DM_QD_QUYETDINH.Where(x => x.ID == ID).FirstOrDefault();

                //Load số quyêt định với các loại QD Hinh Su sau
                if (ID == 127 || ID == 203 || ID == 206 || ID == 61)
                {
                    // lấy số mới nhất
                    Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DateTime ngayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    ADS_SOTHAM_BL oSTBL = new ADS_SOTHAM_BL();
                    String STTNew = oSTBL.GET_SQD_NEW(DonViID, "AHS_PT", ngayQD, ID).ToString();
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
                objFile.TOAANID = oVuAn.TOAPHUCTHAMID;
                objFile.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                objFile.LOAIFILE = 0;
                objFile.BIEUMAUID = IDBM;
                objFile.NAM = DateTime.Now.Year;
                objFile.NGAYTAO = DateTime.Now;
                objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (isNew)
                {
                    dt.AHS_FILE.Add(objFile);
                }
                dt.SaveChanges();
                IDFIle = objFile.ID;
            }
            return IDFIle;
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
    }
}