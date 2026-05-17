using BL.GSTP;
using BL.GSTP.ADS;
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

namespace WEB.GSTP.QLAN.AHS.PhucTham
{
    public partial class NguoiTienhanhTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy");

                    LoadCombobox();
                    ddlTucachTGTT_SelectedIndexChanged(sender, e);

                    hddPageIndex.Value = "1";
                    dgList.CurrentPageIndex = 0;
                    LoadGrid();

                    CheckQuyen();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void CheckQuyen()
        {
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");

            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(btnLammoi, oPer.CAPNHAT);

            //Kiểm tra thẩm phán giải quyết đơn                        
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }

            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }

            List<AHS_PHUCTHAM_THULY> lstCount = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == DONID).ToList();
            if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }

            List<AHS_THAMPHANGIAIQUYET> lstTP = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == DONID
                                                                                 && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
            if (lstTP.Count == 0)
            {
                lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }

            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }

            AHS_PHUCTHAM_BANAN ba = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == DONID).FirstOrDefault();
            if (ba != null)
            {
                lbthongbao.Text = "Đã có bản án, không được sửa đôi !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }

            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_PT(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, DONID);
            if (oDT.Rows.Count > 0)
            {
                lbthongbao.Text = "Đã có quyết định gây kết thúc, không được sửa đổi !";
                Cls_Comon.SetButton(btnUpdate, false);
                Cls_Comon.SetButton(btnLammoi, false);
                return;
            }
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
                decimal Donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);                
                AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == DONID).FirstOrDefault();

                //check vu an ket thuc de thong bao khong cho sua
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                    return;
                }

                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                AHS_PHUCTHAM_QUYETDINH_VUAN qdVA = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == DONID && x.TOA_GIAIQUYET_ID == Donvi_ID).FirstOrDefault();
                AHS_PHUCTHAM_QUYETDINH_BICAN qdBA = dt.AHS_PHUCTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == DONID && x.TOA_GIAIQUYET_ID == Donvi_ID).FirstOrDefault();
                if (qdVA != null || qdBA != null)
                { 
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }

                // check quyền để hiển thị nút xoá
                string toaGiaiQuyetID = e.Item.Cells[13].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                    return;
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
            // Nếu đã có quyết định đưa vụ án ra xét xử thì mặc định selected thẩm phán được phân công giải quyết
            DM_QD_LOAI loaiQD = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault<DM_QD_LOAI>();
            if (loaiQD != null)
            {
                AHS_PHUCTHAM_QUYETDINH_VUAN qd = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && x.LOAIQDID == loaiQD.ID).FirstOrDefault<AHS_PHUCTHAM_QUYETDINH_VUAN>();
                if (qd != null)
                {
                    AHS_THAMPHANGIAIQUYET tpgq = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == "VTTP_GIAIQUYETPHUCTHAM").OrderByDescending(x => x.NGAYTAO).FirstOrDefault<AHS_THAMPHANGIAIQUYET>();
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
            ddlHTND_NguoiPC.Items.Insert(0, new ListItem("--Chọn--", "0"));

            ddlHTND_Thuky.Items.Insert(0, new ListItem("--Chọn--", "0"));
            ddlKSV_Nguoi.Items.Insert(0, new ListItem("--Chọn--", "0"));
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
        private void ResetControls()
        {
            lbthongbao.Text = "";
            ddlThamphan.SelectedIndex = 0;
            ddlNguoiphancong.SelectedIndex = 0;
            ddlHTND_Thuky.SelectedIndex = 0;
            ddlHTND_NguoiPC.SelectedIndex = 0;
            ddlKSV_Nguoi.SelectedIndex = 0;
            ddlHTND_NguoiPC.SelectedIndex = 0;
            txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
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
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                string tucach = ddlTucachTGTT.SelectedValue, TenChucDanh = "", TenCanBo = "";
                AHS_PHUCTHAM_HDXX oND;

                // Lấy count thụ lý và count chủ tọa để cho nhập thêm thẩm phán chủ tọa
                List<AHS_THAMPHANGIAIQUYET> countTPGQ = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
                List<AHS_PHUCTHAM_HDXX> countChuToa = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    if (tucach == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN)
                    {
                        // Kiểm tra vụ án đã có thẩm phán chủ tọa phiên tòa chưa
                        // Nếu có thì không được phép thêm thẩm phán chủ tọa phiên tòa
                        oND = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault<AHS_PHUCTHAM_HDXX>();
                        if (oND != null && countTPGQ.Count == countChuToa.Count)
                        {
                            lbthongbao.Text = "Vụ án đã có thẩm phán chủ tọa phiên tòa. Không được thêm mới!";
                            ddlThamphan.Focus();
                            return;
                        }
                    }
                    oND = new AHS_PHUCTHAM_HDXX();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHS_PHUCTHAM_HDXX.Where(x => x.ID == ID).FirstOrDefault();
                }
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
                oND.SOQD = txtSoQD.Text.Trim();
                oND.NGAYQD = txtNgayQD.Text + "" == "" ? (DateTime?)null : DateTime.Parse(txtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKETTHUC = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET || tucach == ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN)
                {
                    oND.FILEID = UploadFileID(VuAnID, "02-HS");
                }
                else if (tucach != ENUM_CHUCDANH.CHUCDANH_KSV)
                {
                    oND.FILEID = UploadFileID(VuAnID, "01-HS");
                }
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    // Kiểm tra nếu thẩm phán đã được phân công rồi thì không phân lại nữa. Chọn thẩm phán khác
                    AHS_PHUCTHAM_HDXX CheckCanBo = dt.AHS_PHUCTHAM_HDXX.Where(x => x.VUANID == VuAnID && x.CANBOID == oND.CANBOID).FirstOrDefault();
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
                    dt.AHS_PHUCTHAM_HDXX.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
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
            lbthongbao.Text = "";
            AHS_PHUCTHAM_BL oBL = new AHS_PHUCTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_PHUCTHAM_HDXX_GETLIST(ID);
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
            AHS_PHUCTHAM_HDXX oND = dt.AHS_PHUCTHAM_HDXX.Where(x => x.ID == id).FirstOrDefault();
            //Anhpn 
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            decimal Donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //AHS_PHUCTHAM_QUYETDINH_BICAN AHS_PHUCTHAM_QUYETDINH_BICAN = dt.AHS_PHUCTHAM_QUYETDINH_BICAN.Where(x => x.ID == DONID).FirstOrDefault<AHS_PHUCTHAM_QUYETDINH_BICAN>();
            //if (AHS_PHUCTHAM_QUYETDINH_BICAN != null)
            //{
            //    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin quyết đinh bị can,bị cáo.";
            //    return;
            //}
            //AHS_SOTHAM_RUTKHANGCAO AHS_SOTHAM_RUTKHANGCAO = dt.AHS_SOTHAM_RUTKHANGCAO.Where(x => x.ID == DONID).FirstOrDefault<AHS_SOTHAM_RUTKHANGCAO>();
            //if (AHS_SOTHAM_RUTKHANGCAO != null)
            //{
            //    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin rút kháng cáo.";
            //    return;
            //}
            //AHS_SOTHAM_RUTKHANGNGHI AHS_SOTHAM_RUTKHANGNGHI = dt.AHS_SOTHAM_RUTKHANGNGHI.Where(x => x.ID == DONID).FirstOrDefault<AHS_SOTHAM_RUTKHANGNGHI>();
            //if (AHS_SOTHAM_RUTKHANGNGHI != null)
            //{
            //    lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin rút kháng nghị.";
            //    return;
            //}
            AHS_PHUCTHAM_QUYETDINH_VUAN AHS_PHUCTHAM_QUYETDINH_VUAN = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == DONID && x.TOA_GIAIQUYET_ID == Donvi_ID).FirstOrDefault<AHS_PHUCTHAM_QUYETDINH_VUAN>();
            if (AHS_PHUCTHAM_QUYETDINH_VUAN != null)
            {
                lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin quyết định vụ án.";
                return;
            }
            AHS_PHUCTHAM_BANAN AHS_PHUCTHAM_BANAN = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == DONID && x.TOA_GIAIQUYET_ID == Donvi_ID).FirstOrDefault<AHS_PHUCTHAM_BANAN>();
            if (AHS_PHUCTHAM_BANAN != null)
            {
                lbthongbao.Text = "Xóa không thành công! Do đang tồn tại bản án.";
                return;
            }
            dt.AHS_PHUCTHAM_HDXX.Remove(oND);
            dt.SaveChanges();
            hddPageIndex.Value = "1";
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            AHS_PHUCTHAM_HDXX oND = dt.AHS_PHUCTHAM_HDXX.Where(x => x.ID == ID).FirstOrDefault();
            ddlTucachTGTT.SelectedValue = oND.MAVAITRO.ToString();
            string tucach = oND.MAVAITRO.ToString();
            ddlTucachTGTT_SelectedIndexChanged(new object(), new EventArgs());
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
                pnThamphan.Visible = pnHTND.Visible = false;// pnDuKhuyet.Visible = false;
                pnKSV.Visible = true;
                pnPhancong.Visible = false;
            }
            else // Thẩm phán
            {
                if (oND.CANBOID != null)
                    if (ddlThamphan.Items.FindByValue(oND.CANBOID.ToString()) != null)
                        ddlThamphan.SelectedValue = oND.CANBOID.ToString();
                if (oND.NGUOIPHANCONGID != null)
                    if (ddlNguoiphancong.Items.FindByValue(oND.NGUOIPHANCONGID.ToString()) != null)
                        ddlNguoiphancong.SelectedValue = oND.NGUOIPHANCONGID.ToString();
                txtNgayphancong.Text = string.IsNullOrEmpty(oND.NGAYPHANCONG + "") ? "" : ((DateTime)oND.NGAYPHANCONG).ToString("dd/MM/yyyy", cul);
                txtNhanphancong.Text = string.IsNullOrEmpty(oND.NGAYNHANPHANCONG + "") ? "" : ((DateTime)oND.NGAYNHANPHANCONG).ToString("dd/MM/yyyy", cul);
                pnThamphan.Visible = true;
                pnHTND.Visible = pnKSV.Visible = false;// pnDuKhuyet.Visible = false;
                pnPhancong.Visible = true;
            }
            txtSoQD.Text = oND.SOQD + "";
            txtNgayQD.Text = oND.NGAYQD + "" == "" ? "" : ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy");
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
        #endregion
        protected void ddlTucachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable tbl = null;
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();

            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string tucach = ddlTucachTGTT.SelectedValue;
            if (tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET || tucach == ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN)
            {
                pnThamphan.Visible = false;
                pnHTND.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;
                if (tucach == ENUM_NGUOITIENHANHTOTUNG.THAMTRAVIEN)
                {
                    lblHTND.Text = "Thẩm tra viên";
                    tbl = oDMCBBL.DM_CANBO_GetAllThuKy_TTV(DonViID, ENUM_CHUCDANH.CHUCDANH_TTV);
                }
                else
                {
                    lblHTND.Text = "Thư ký phiên tòa";
                    tbl = oDMCBBL.DM_CANBO_GetAllThuKy_TTV(DonViID, ENUM_CHUCDANH.CHUCDANH_THUKY);
                }
                ddlHTND_Thuky.DataSource = tbl;
                ddlHTND_Thuky.DataTextField = "MA_TEN";
                ddlHTND_Thuky.DataValueField = "ID";
                ddlHTND_Thuky.DataBind();
                ddlHTND_Thuky.Items.Insert(0, new ListItem("--Chọn--", "0"));
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND)
            {
                pnThamphan.Visible = false;
                pnHTND.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;
                lblHTND.Text = "Tên Hội thẩm nhân dân";
                LoadDrop_CanBoVKS(ddlHTND_Thuky);
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
            {
                pnThamphan.Visible = pnHTND.Visible = false;// pnDuKhuyet.Visible = false;
                pnKSV.Visible = true;
                pnPhancong.Visible = false;
                LoadDrop_CanBoVKS(ddlKSV_Nguoi);
            }
            else
            {
                pnThamphan.Visible = true;
                pnHTND.Visible = pnKSV.Visible = false;// pnDuKhuyet.Visible = false;
                pnPhancong.Visible = true;
            }
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
                if (isNew)
                {
                    dt.AHS_FILE.Add(objFile);
                }
                dt.SaveChanges();
                IDFIle = objFile.ID;
            }
            return IDFIle;
        }
    }
}