using BL.GSTP;
using BL.GSTP.QLAN;
using BL.GSTP.AHS;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.ADS;
using NLog;

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class NguoiTienhanhTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public string NgayHoSo;

        public Decimal VuAnID = 0;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
                {
                    VuAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_HINHSU] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

                    if (!IsPostBack)
                    {
                        //txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy");

                        if (VuAnID == 0)
                            Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");

                        LoadDropThuLy();
                        LoadCombobox();
                        ddlTucachTGTT_SelectedIndexChanged(sender, e);
                        CheckQuyen();
                        hddPageIndex.Value = "1";
                        dgList.CurrentPageIndex = 0;
                        LoadGrid();
                    }
                }
            }
            catch (Exception ex) {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("loi xay ra: " + ex);
            }
        }

        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();



            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            try
            {
                List<AHS_SOTHAM_THULY> lstCount = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(y => y.NGAYTHULY).ToList();
                decimal THULYID;
                
                if (lstCount.Count == 0)
                {
                    lbthongbao.Text = "Chưa cập nhật thông tin thụ lý sơ thẩm !";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(btnLammoi, false);
                    return;
                }
                else
                {
                    THULYID = lstCount[0].ID;
                }

                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongbao.Text = Result;
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(btnLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                List<AHS_THAMPHANGIAIQUYET> lst = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM && x.THULYID == THULYID).ToList<AHS_THAMPHANGIAIQUYET>();
                if (lst == null || lst.Count == 0)
                {
                    lbthongbao.Text = "Vụ việc chưa được phân công thẩm phán. Đề nghị cập nhật thông tin 'Phân công thẩm phán giải quyết' !";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(btnLammoi, false);
                    return;
                }
                
                AHS_SOTHAM_BANAN oBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID && x.THULYID == THULYID).FirstOrDefault();
                if (oBA != null)
                {
                    lbthongbao.Text = "Vụ việc đã có bản án, không được sửa đổi !";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(btnLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }

                DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
                DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, VuAnID, THULYID);
                if (oDT.Rows.Count > 0)
                {
                    lbthongbao.Text = "Đã có quyết định gây kết thúc, không được sửa đổi !";
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(btnLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            catch { }
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

                AHS_CHUYEN_NHAN_AN_BL _chuyenNhanBl = new AHS_CHUYEN_NHAN_AN_BL();
                bool isReadOnly = _chuyenNhanBl.CheckIsReadOnlyNguoiTTTTST(Convert.ToDecimal(rowView["ID"].ToString()), VuAnID, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || isReadOnly /*|| hddShowCommand.Value == "False"*/)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                int IsAnST = (string.IsNullOrEmpty(rowView["IsBanAnST"] + "")) ? 0 : Convert.ToInt16(rowView["IsBanAnST"] + "");
                if (IsAnST > 0)
                    lbtXoa.Visible = false;
                
                Decimal ID = Convert.ToDecimal(rowView["ID"].ToString());
                List<AHS_SOTHAM_THULY> thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();

                decimal donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]?.ToString());
                // vnpt update 11082025: check thu ly co rong hay khong
                if (thuly.Count != 0)
                {
                    decimal THULYID = thuly[0].ID;

                    AHS_SOTHAM_HDXX obj = dt.AHS_SOTHAM_HDXX.Where(x => x.ID == ID && x.THULYID == THULYID)
                        .FirstOrDefault();
                    if (obj != null)
                    {
                        //toancau Nhũng bản ghi được thêm sau khi nhận án lại để xét xử tiếp thì được áp dụng tuân theo quy trình xoá ngược ở giải đoạn sau 
                        AHS_CHUYEN_NHAN_AN chuyenan = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VuAnID)
                            .OrderByDescending(x => x.NGAYTAO).FirstOrDefault();
                        if (chuyenan != null)
                        {
                            if (obj.NGAYTAO <= chuyenan.NGAYTAO)
                            {
                                List<AHS_SOTHAM_QUYETDINH_VUAN> qd = dt.AHS_SOTHAM_QUYETDINH_VUAN
                                    .Where(x => x.VUANID == VuAnID && x.THULYID == THULYID).ToList();
                                List<AHS_SOTHAM_QUYETDINH_BICAN> qdBICAN = dt.AHS_SOTHAM_QUYETDINH_BICAN
                                    .Where(x => x.VUANID == VuAnID && x.THULYID == THULYID).ToList();
                                if ((qd != null && qd.Count > 0) || (qdBICAN != null && qdBICAN.Count > 0))
                                {
                                    lblSua.Text = "Chi tiết";
                                    lbtXoa.Visible = false;

                                }
                            }
                            else
                            {
                                List<AHS_SOTHAM_QUYETDINH_VUAN> qd = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x =>
                                        x.VUANID == VuAnID && x.NGAYTAO > chuyenan.NGAYTAO && x.THULYID == THULYID)
                                    .ToList();
                                List<AHS_SOTHAM_QUYETDINH_BICAN> qdBICAN = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x =>
                                        x.VUANID == VuAnID && x.NGAYTAO > chuyenan.NGAYTAO && x.THULYID == THULYID)
                                    .ToList();
                                if ((qd != null && qd.Count > 0) || (qdBICAN != null && qdBICAN.Count > 0))
                                {
                                    lblSua.Text = "Chi tiết";
                                    lbtXoa.Visible = false;
                                }
                            }

                        }
                        else
                        {
                            AHS_SOTHAM_QUYETDINH_VUAN qdVA = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x =>
                                    x.VUANID == VuAnID && x.TOA_GIAIQUYET_ID == donvi_ID && x.THULYID == THULYID)
                                .FirstOrDefault();
                            AHS_SOTHAM_QUYETDINH_BICAN qdBICAN = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x =>
                                    x.VUANID == VuAnID && x.TOA_GIAIQUYET_ID == donvi_ID && x.THULYID == THULYID)
                                .FirstOrDefault();
                            if ((qdVA != null || qdBICAN != null))
                            {
                                lblSua.Text = "Chi tiết";
                                lbtXoa.Visible = false;
                            }
                        }
                    }
                    else
                    {
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                    }
                }

                string toagiaiquyetID = e.Item.Cells[12].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
            }
        }
        private void LoadCombobox()
        {
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán chủ tọa phiên tòa", ENUM_NGUOITIENHANHTOTUNG.THAMPHAN));
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_NGUOITIENHANHTOTUNG.THAMPHANHDXX));
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_NGUOITIENHANHTOTUNG.THAMPHANDUKHUYET));
            ddlTucachTGTT.Items.Add(new ListItem("Hội thẩm nhân dân", ENUM_CHUCDANH.CHUCDANH_HTND));
            //ddlTucachTGTT.Items.Add(new ListItem("Thẩm tra viên", ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN));
            ddlTucachTGTT.Items.Add(new ListItem("Thư ký", ENUM_NGUOITIENHANHTOTUNG.THUKY));
            ddlTucachTGTT.Items.Add(new ListItem("Thư ký dự khuyết", ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET));
            ddlTucachTGTT.Items.Add(new ListItem("Kiểm sát viên", ENUM_CHUCDANH.CHUCDANH_KSV));
            decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),
                    VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            // Goi y tham phan chu toa la tham phan giai quyet
            if (ddlTucachTGTT.SelectedValue == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN)
            {
                try
                {
                    AHS_THAMPHANGIAIQUYET oND = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM").OrderByDescending(x => x.NGAYPHANCONG).First();
                    if (oND != null)
                        ddlThamphan.SelectedValue = oND.CANBOID.ToString();
                }
                catch { }
            }
            // Nếu đã có quyết định đưa vụ án ra xét xử thì mặc định selected thẩm phán được phân công giải quyết
            DM_QD_LOAI loaiQD = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault<DM_QD_LOAI>();
            if (loaiQD != null)
            {
                AHS_SOTHAM_QUYETDINH_VUAN qd = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && x.LOAIQDID == loaiQD.ID).FirstOrDefault<AHS_SOTHAM_QUYETDINH_VUAN>();
                if (qd != null)
                {
                    AHS_THAMPHANGIAIQUYET tpgq = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == "VTTP_GIAIQUYETSOTHAM").OrderByDescending(x => x.NGAYTAO).FirstOrDefault<AHS_THAMPHANGIAIQUYET>();
                    if (tpgq != null)
                    {
                        try { ddlThamphan.SelectedValue = tpgq.CANBOID + ""; } catch { }
                    }
                }
            }
            //
            oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlNguoiphancong.DataSource = oCBDT;
            ddlNguoiphancong.DataTextField = "MA_TEN";
            ddlNguoiphancong.DataValueField = "ID";
            ddlNguoiphancong.DataBind();
            //ddlNguoiphancong.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            ddlHTND_NguoiPC.DataSource = oCBDT;
            ddlHTND_NguoiPC.DataTextField = "MA_TEN";
            ddlHTND_NguoiPC.DataValueField = "ID";
            ddlHTND_NguoiPC.DataBind();
            //  ddlHTND_NguoiPC.Items.Insert(0, new ListItem("--Chọn--", "0"));

            ddlHTND_Thuky.Items.Insert(0, new ListItem("--Chọn--", "0"));
            ddlKSV_Nguoi.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        private void ResetControls()
        {
            ddlThamphan.SelectedIndex = 0;
            try { ddlNguoiphancong.SelectedIndex = 0; } catch { }
            txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy");
            ddlHTND_Thuky.SelectedIndex = 0;
            ddlHTND_NguoiPC.SelectedIndex = 0;
            ddlKSV_Nguoi.SelectedIndex = 0;
            ddlHTND_NguoiPC.SelectedIndex = 0;
            txtNgayketthuc.Text = lbthongbao.Text = txtSoQD.Text = txtNgayQD.Text = "";
            hddid.Value = "0";
        }
        private bool CheckValid()
        {
            string tucach = ddlTucachTGTT.SelectedValue;
            switch (tucach)
            {
                case ENUM_CHUCDANH.CHUCDANH_HTND:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Hội thẩm nhân dân !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Thẩm tra viên !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_NGUOITIENHANHTOTUNG.THUKY:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Thư ký !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Thư ký !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_CHUCDANH.CHUCDANH_KSV:
                    if (ddlKSV_Nguoi.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Kiểm sát viên !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlKSV_Nguoi.ClientID);
                        return false;
                    }
                    break;
                default:
                    if (ddlThamphan.SelectedIndex == 0)
                    {
                        lbthongbao.Text = "Chưa chọn Thẩm phán !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlThamphan.ClientID);
                        return false;
                    }
                    break;
            }
            if (dropThuLy.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn thụ lý. Hãy kiểm tra lại.";
                dropThuLy.Focus();
                return false;
            }
            if (txtNgayphancong.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgayphancong.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày phân công theo định dạng (ngày/tháng/năm).";
                txtNgayphancong.Focus();
                return false;
            }
            if (txtNhanphancong.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNhanphancong.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày nhận phân công theo định dạng (ngày/tháng/năm).";
                txtNhanphancong.Focus();
                return false;
            }

            if (txtNgayketthuc.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgayketthuc.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày kết thúc theo định dạng (ngày/tháng/năm).";
                txtNgayketthuc.Focus();
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;

                string tucach = ddlTucachTGTT.SelectedValue, TenChucDanh = "", TenCanBo = "";
                AHS_SOTHAM_HDXX oND;

                // Lấy count thụ lý và count chủ tọa để cho nhập thêm thẩm phán chủ tọa
                List<AHS_THAMPHANGIAIQUYET> countTPGQ = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM).ToList();
                List<AHS_SOTHAM_HDXX> countChuToa = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();

                Decimal CurrID = (String.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                if (CurrID == 0)
                {
                    if (tucach == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN)
                    {
                        // Kiểm tra vụ án đã có thẩm phán chủ tọa phiên tòa chưa
                        // Nếu có thì không được phép thêm thẩm phán chủ tọa phiên tòa
                        oND = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AHS_SOTHAM_HDXX>();
                        if (oND != null && countTPGQ.Count == countChuToa.Count)
                        {
                            lbthongbao.Text = "Vụ án đã có thẩm phán chủ tọa phiên tòa. Không được thêm mới!";
                            ddlThamphan.Focus();
                            return;
                        }
                    }
                    oND = new AHS_SOTHAM_HDXX();
                }
                else
                {
                    oND = dt.AHS_SOTHAM_HDXX.Where(x => x.ID == CurrID).FirstOrDefault();
                }


                decimal ThuLyID = Convert.ToDecimal(dropThuLy.SelectedValue);
                oND.THULYID = ThuLyID;

                oND.VUANID = VuAnID;
                oND.MAVAITRO = tucach;

                if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET || tucach == ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN)
                {
                    if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND)
                        TenChucDanh = "Hội thẩm nhân dân";
                    else
                        TenChucDanh = "Thư ký";
                    TenCanBo = (ddlHTND_Thuky.SelectedItem.Text.Split('-'))[0].Trim().ToString();
                    oND.CANBOID = Convert.ToDecimal(ddlHTND_Thuky.SelectedValue);
                    oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlHTND_NguoiPC.SelectedValue);
                    oND.NGAYPHANCONG = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYNHANPHANCONG = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //oND.DUKHUYET = Convert.ToDecimal(rdbDuKhuyet.SelectedValue);
                }
                else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
                {
                    TenChucDanh = "Kiểm sát viên";
                    TenCanBo = (ddlKSV_Nguoi.SelectedItem.Text.Split('-'))[0].Trim().ToString();
                    oND.CANBOID = Convert.ToDecimal(ddlKSV_Nguoi.SelectedValue);
                }
                else // Thẩm phán
                {
                    TenChucDanh = "Thẩm phán";
                    TenCanBo = (ddlThamphan.SelectedItem.Text.Split('-'))[0].Trim().ToString();
                    oND.CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                    oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
                    oND.NGAYPHANCONG = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYNHANPHANCONG = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
                oND.NGAYKETTHUC = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET || tucach == ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN)
                {
                    oND.FILEID = UploadFileID(VuAnID, "02-HS");
                }
                else if (tucach != ENUM_CHUCDANH.CHUCDANH_KSV)
                {
                    oND.FILEID = UploadFileID(VuAnID, "01-HS");
                }

                if (CurrID == 0)
                {
                    // Kiểm tra nếu thẩm phán đã được phân công rồi thì không phân lại nữa. Chọn thẩm phán khác
                    AHS_SOTHAM_HDXX CheckCanBo = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.CANBOID == oND.CANBOID).FirstOrDefault();
                    if (CheckCanBo != null && countTPGQ.Count == countChuToa.Count)
                    {
                        lbthongbao.Text = TenChucDanh + " " + TenCanBo + " đã được phân công. Hãy chọn lại!";
                        return;
                    }
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_SOTHAM_HDXX.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                oND.SOQD = txtSoQD.Text.Trim();
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dt.SaveChanges();

                hddPageIndex.Value = "1";
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
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            DataTable oDT = oBL.AHS_SOTHAM_HDXX_GETLIST(VuAnID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), dgList.PageSize).ToString();
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
            AHS_SOTHAM_HDXX oND = dt.AHS_SOTHAM_HDXX.Where(x => x.ID == id).FirstOrDefault();
            dt.AHS_SOTHAM_HDXX.Remove(oND);
            dt.SaveChanges();
            hddPageIndex.Value = "1";
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            AHS_SOTHAM_HDXX oND = dt.AHS_SOTHAM_HDXX.Where(x => x.ID == ID).FirstOrDefault();
            dropThuLy.SelectedValue = oND.THULYID.ToString();
            ddlTucachTGTT.SelectedValue = oND.MAVAITRO.ToString();
            string tucach = oND.MAVAITRO.ToString();
            ddlTucachTGTT_SelectedIndexChanged(new object(), new EventArgs());
            txtSoQD.Text = oND.SOQD;
            txtNgayQD.Text = oND.NGAYQD + "" == "" ? "" : ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);
            if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET || tucach == ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN)
            {
                if (oND.CANBOID != null)
                    if (ddlHTND_Thuky.Items.FindByValue(oND.CANBOID.ToString()) != null)
                        ddlHTND_Thuky.SelectedValue = oND.CANBOID.ToString();
                if (oND.NGUOIPHANCONGID != null)
                    if (ddlHTND_NguoiPC.Items.FindByValue(oND.NGUOIPHANCONGID.ToString()) != null)
                        ddlHTND_NguoiPC.SelectedValue = oND.NGUOIPHANCONGID.ToString();
                txtNgayphancong.Text = string.IsNullOrEmpty(oND.NGAYPHANCONG + "") ? "" : ((DateTime)oND.NGAYPHANCONG).ToString("dd/MM/yyyy", cul);
                txtNhanphancong.Text = string.IsNullOrEmpty(oND.NGAYNHANPHANCONG + "") ? "" : ((DateTime)oND.NGAYNHANPHANCONG).ToString("dd/MM/yyyy", cul);
                pnThamphan.Visible = false;
                pnHTND.Visible = true;
                //pnDuKhuyet.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
            {
                if (oND.CANBOID != null)
                    if (ddlKSV_Nguoi.Items.FindByValue(oND.CANBOID.ToString()) != null)
                        ddlKSV_Nguoi.SelectedValue = oND.CANBOID.ToString();
                pnKSV.Visible = true;
                pnPhancong.Visible = false;
            }
            else // Thẩm phán
            {
                if (oND.CANBOID != null)
                    if (ddlThamphan.Items.FindByValue(oND.CANBOID.ToString()) != null)
                        ddlThamphan.SelectedValue = oND.CANBOID.ToString();
                if (oND.NGUOIPHANCONGID != null)
                {
                    if (ddlNguoiphancong.Items.FindByValue(oND.NGUOIPHANCONGID.ToString()) != null)
                        ddlNguoiphancong.SelectedValue = oND.NGUOIPHANCONGID.ToString();
                }
                txtNgayphancong.Text = string.IsNullOrEmpty(oND.NGAYPHANCONG + "") ? "" : ((DateTime)oND.NGAYPHANCONG).ToString("dd/MM/yyyy", cul);
                txtNhanphancong.Text = string.IsNullOrEmpty(oND.NGAYNHANPHANCONG + "") ? "" : ((DateTime)oND.NGAYNHANPHANCONG).ToString("dd/MM/yyyy", cul);
                pnThamphan.Visible = true;
                pnHTND.Visible = pnKSV.Visible = false;//pnDuKhuyet.Visible = false;
                pnPhancong.Visible = true;
            }
            txtNgayketthuc.Text = string.IsNullOrEmpty(oND.NGAYKETTHUC + "") ? "" : ((DateTime)oND.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Sua":
                        lbthongbao.Text = "";
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
                        hddid.Value = e.CommandArgument.ToString();
                        break;
                    case "Xoa":
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
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
        protected void ddlTucachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string tucach = ddlTucachTGTT.SelectedValue;
            if (tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET || tucach == ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN)
            {
                pnThamphan.Visible = false;
                pnHTND.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;
                ddlHTND_Thuky.Items.Clear();
                if (tucach == ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN)
                {
                    lblHTND.Text = "Thẩm tra viên";
                    tbl = objBL.DM_CANBO_GetAllThuKy_TTV(DonViID, ENUM_CHUCDANH.CHUCDANH_TTV);
                }
                else
                {
                    lblHTND.Text = "Thư ký phiên tòa";
                    tbl = objBL.DM_CANBO_GetAllThuKy_TTV(DonViID, ENUM_CHUCDANH.CHUCDANH_THUKY);
                }
                ddlHTND_Thuky.DataSource = tbl;
                ddlHTND_Thuky.DataTextField = "MA_TEN";
                ddlHTND_Thuky.DataValueField = "ID";
                ddlHTND_Thuky.DataBind();
                ddlHTND_Thuky.Items.Insert(0, new ListItem("--Chọn--", "0"));
                Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND)
            {
                pnThamphan.Visible = false;
                pnHTND.Visible = true;
                //pnDuKhuyet.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;
                lblHTND.Text = "Hội thẩm nhân dân";
                LoadDrop_CanBoVKS(ddlHTND_Thuky);
                Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
            {
                pnThamphan.Visible = pnHTND.Visible = false; //pnDuKhuyet.Visible = false;
                pnKSV.Visible = true;
                pnPhancong.Visible = false;
                LoadDrop_CanBoVKS(ddlKSV_Nguoi);
                Cls_Comon.SetFocus(this, this.GetType(), ddlKSV_Nguoi.ClientID);
            }
            else
            {
                pnThamphan.Visible = true;
                pnHTND.Visible = pnKSV.Visible = false; //pnDuKhuyet.Visible = false;
                pnPhancong.Visible = true;
                Cls_Comon.SetFocus(this, this.GetType(), ddlThamphan.ClientID);
            }
        }
        void LoadDrop_CanBoVKS(DropDownList drop)
        {
            String ma_loai_chucdanh = ddlTucachTGTT.SelectedValue;
            Decimal CurrDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_CANBOVKS_BL objBL = new DM_CANBOVKS_BL();
            DataTable tbl = objBL.DM_CANBOVKS_GETBYDONVI_LOAI(CurrDonViID, ma_loai_chucdanh);
            drop.Items.Clear();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                drop.DataSource = tbl;
                drop.DataTextField = "MA_TEN";
                drop.DataValueField = "ID";
                drop.DataBind();

                drop.Items.Insert(0, new ListItem("--Chọn--", "0"));
            }
            else
                drop.Items.Insert(0, new ListItem("--Chọn--", "0"));
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
                AHS_FILE objFile = dt.AHS_FILE.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && x.BIEUMAUID == IDBM).FirstOrDefault();
                if (objFile == null)
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
                if (isNew)
                {
                    dt.AHS_FILE.Add(objFile);
                }
                dt.SaveChanges();
                IDFIle = objFile.ID;
            }
            return IDFIle;
        }
        protected void txtNgayQD_TextChanged(object sender, EventArgs e)
        {
            txtNgayphancong.Text = txtNhanphancong.Text = txtNgayQD.Text;
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
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
            }
        }

        protected void dropThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal VUANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            
            List<AHS_SOTHAM_THULY> thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VUANID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();
            // vnpt update 11082025: check thu ly co rong hay khong
            if (thuly.Count != 0)
            {

                decimal THULYID = thuly[0].ID;

                List<AHS_SOTHAM_QUYETDINH_VUAN> qd = dt.AHS_SOTHAM_QUYETDINH_VUAN
                    .Where(x => x.VUANID == VUANID && x.THULYID == THULYID).ToList();
                List<AHS_SOTHAM_BANAN> qdBC = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VUANID && x.THULYID == THULYID)
                    .ToList();

                if (dropThuLy.SelectedValue == "0")
                {
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(btnLammoi, false);
                }
                else if (dropThuLy.SelectedValue == THULYID.ToString() && qd.Count == 0 && qdBC.Count == 0)
                {
                    Cls_Comon.SetButton(btnUpdate, true);
                    Cls_Comon.SetButton(btnLammoi, true);
                }
                else
                {
                    Cls_Comon.SetButton(btnUpdate, false);
                    Cls_Comon.SetButton(btnLammoi, false);
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