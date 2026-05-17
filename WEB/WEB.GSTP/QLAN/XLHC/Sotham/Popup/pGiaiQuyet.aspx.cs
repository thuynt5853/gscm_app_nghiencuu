using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.Danhmuc;
using BL.GSTP.QLAN;
using BL.GSTP.XLHC;
using NLog;

namespace WEB.GSTP.QLAN.XLHC.Sotham.Popup
{
    public partial class pGiaiQuyet : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private decimal LOAIAN = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.BPXLHC);
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    decimal donId = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                    string id = Request.QueryString["ID"];

                    if (!string.IsNullOrEmpty(Request.QueryString["DON_ID"]))
                    {
                        donId = Convert.ToDecimal(Request.QueryString["DON_ID"]);
                    }

                    if (!string.IsNullOrEmpty(id) && donId != 0)
                    {
                        ddlTucachTGTT_SelectedIndexChanged(sender, e);
                        //KHOI TAO hddVuViecID, thong tin mac dinh
                        cmdGiaiQuyet_Click(donId);
                        loadThuly(donId);
                        loadInfo_HDXX(donId);
                        loadKetQua(getIdDonHoanMien());
                    }
                }
                catch (Exception ex)
                {

                    lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                    logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
                }
            }
        }

        private bool daGiaiQuyet()
        {
            decimal id = getIdDonHoanMien();
            XLHC_DONXIN_HOAN_MIEN obj = dt.XLHC_DONXIN_HOAN_MIEN.Where(d => d.ID == id).FirstOrDefault();

            return obj != null && obj.ISGIAIQUYET == 1;
        }

        private decimal getIdDonHoanMien()
        {
            string id = Request.QueryString["ID"];
            if (!string.IsNullOrEmpty(id))
            {
                return Convert.ToDecimal(id);
            }

            return 0;
        }

        private decimal getDonId()
        {
            string id = Request.QueryString["DON_ID"];
            if (!string.IsNullOrEmpty(id))
            {
                return Convert.ToDecimal(id);
            }

            return 0;
        }

        protected void loadInfo_HDXX(decimal donId)
        {
            LoadGrid_HDXX(donId);
        }

        protected void loadKetQua(decimal idDonHM)
        {
            try
            {
                XLHC_DONXIN_HOAN_MIEN oDon = dt.XLHC_DONXIN_HOAN_MIEN.Where(d => d.ID == idDonHM).FirstOrDefault();

                if (oDon == null)
                {
                    lbthongBaoUpdateKetqua.Text = "Không tìm thấy đơn! Vui lòng thêm mới đơn đề nghị!";
                    return;
                }

                if (oDon.NGAY_QUYETDINH == null || oDon.SO_QUYETDINH == null || oDon.DM_QUYETDINH_ID == null)
                {
                    resetKetQua();
                }
                else
                {
                    txtNgayQD.Text = ((DateTime)oDon.NGAY_QUYETDINH).ToString("dd/MM/yyyy", cul);
                    txtSoQD.Text = oDon.SO_QUYETDINH.ToString();

                    if (oDon.DM_QUYETDINH_ID != null && oDon.DM_QUYETDINH_ID > 0)
                    {
                        ddlQuyetdinh.SelectedValue = oDon.DM_QUYETDINH_ID.ToString();
                    }

                    if (oDon.NGAY_BATDAU_HIEULUC != null)
                    {
                        txtHieuLucTuNgay.Text = ((DateTime)oDon.NGAY_BATDAU_HIEULUC).ToString("dd/MM/yyyy", cul);

                        if (oDon.NGAY_HET_HIEULUC != null)
                        {
                            txtDenNgay.Text = ((DateTime)oDon.NGAY_HET_HIEULUC).ToString("dd/MM/yyyy", cul);
                        }
                    }

                    if (oDon.GQ_ISQUAHAN != null)
                    {
                        rdVuAnQuaHan.SelectedValue = oDon.GQ_ISQUAHAN.ToString();
                    }
                }


                    var bg = DataExtensions.GetAllByclause("VUAN_BANGIAO_MAPPING", $"VUVIECID = '{oDon.DONID}'").FirstOrDefault();
                    if (bg != null && bg.NGAYNHAN != null && oDon.GQ_NGAY.HasValue && oDon.TOA_GIAIQUYET_ID != Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]))
                    {
                        if (bg.NGAYNHAN > oDon.GQ_NGAY.Value)
                        {
                            Cls_Comon.SetButton(cmdCapnhatKetqua, false);
                            Cls_Comon.SetButton(cmXoaKetqua, false);
                            Cls_Comon.SetButton(cmdLammoiHDXX, false);
                            Cls_Comon.SetButton(cmdCapnhaHDXX, false);
                        }
                    }
                
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateKetqua.Text = ex.Message;
            }
        }

        private void resetKetQua()
        {
            txtNgayQD.Text = "";
            txtSoQD.Text = "";
            ddlQuyetdinh.SelectedIndex = 0;
            txtHieuLucTuNgay.Text = "";
            txtDenNgay.Text = "";
            rdVuAnQuaHan.SelectedValue = "0";
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbaoTTNguoiTHToTung.Text = "";
                    loadEdit_HDXX(ND_id);
                    hddHdxxid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    decimal DonID = Convert.ToDecimal(hddVuViecID.Value);
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DonID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbaoTTNguoiTHToTung.Text = Result;
                        return;
                    }
                    xoa_HDXX(ND_id);
                    LoadGrid_HDXX(DonID);
                    break;
            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                //Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                //Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string id = Request.QueryString["ID"];
                if (!String.IsNullOrEmpty(id))
                {
                    if (!daGiaiQuyet())
                    {
                        lbtXoa.Visible = true;
                        lblSua.Visible = true;
                    }
                    else
                    {
                        lblSua.Visible = true;
                        lblSua.Text = "Chi tiết";
                        lbtXoa.Visible = false;
                    }
                }
                else
                {
                    lbtXoa.Visible = true;
                    lblSua.Visible = true;
                }

                string toagiaiquyetID = e.Item.Cells[8].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
            }
        }

        protected void cmdSuggestSoQD_Click(object sender, EventArgs e)
        {
            try
            {
                if (String.IsNullOrEmpty(txtSoQD.Text))
                {
                    setNextSoQuyetDinh();
                }
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateKetqua.Text = ex.Message;
            }

            try
            {
                decimal SOTHAM_KHANGCAO_ID = Convert.ToDecimal(hddKhangcaoID.Value);
                if (SOTHAM_KHANGCAO_ID != 0)
                {
                    ADS_SOTHAM_KHANGCAO oKhangcao = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.ID == SOTHAM_KHANGCAO_ID).FirstOrDefault<ADS_SOTHAM_KHANGCAO>();

                    STPT_KHANGCAOQUAHAN oBL = new STPT_KHANGCAOQUAHAN();

                    if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                    {
                        lbthongBaoUpdateKetqua.Text = "Bạn phải nhập ngày thụ lý theo theo định dạng (dd/MM/yyyy)!";
                        txtNgayQD.Focus();
                        return;
                    }

                    decimal VTOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    string VNGAYQUYETDINH = txtNgayQD.Text;

                    txtSoQD.Text = oBL.SOQUYETDINH_GETMAXTT(VTOAANID, VNGAYQUYETDINH).ToString();

                }

            }
            catch (Exception ex)
            {
                lbthongBaoUpdateKetqua.Text = ex.Message;
            }
        }

        protected void cmdSuggestSoThuly_Click(object sender, EventArgs e)
        {
            try
            {
                if (String.IsNullOrEmpty(txtSothuly.Text))
                {
                    SetNewSoThuLy();
                }
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateThuly.Text = ex.Message;
            }
        }

        private bool isValidThuLy()
        {
            if (daGiaiQuyet())
            {
                lbthongBaoUpdateThuly.Text = "Vụ án đã có kết quả giải quyết. Không được cập nhật thông tin!";
                return false;
            }

            if (Cls_Comon.IsValidDate(txtNgaythuly.Text) == false)
            {
                lbthongBaoUpdateThuly.Text = "Bạn phải nhập ngày thụ lý theo theo định dạng (dd/MM/yyyy)!";
                txtNgaythuly.Focus();
                return false;
            }

            DateTime dNgayTL = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayTL > DateTime.Now)
            {
                lbthongBaoUpdateThuly.Text = "Ngày thụ lý không được lớn hơn ngày hiện tại !";
                txtNgaythuly.Focus();
                return false;
            }

            if (txtSothuly.Text.Length == 0)
            {
                lbthongBaoUpdateThuly.Text = "Bạn chưa nhập số thụ lý. Hãy chọn lại!";
                txtSothuly.Focus();
                return false;
            }

            return true;
        }

        private bool CheckValid(decimal DONID)
        {
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongBaoUpdateThuly.Text = Result;
                return false;
            }

            return true;
        }

        protected void cmdCapnhatThuly_Click(object sender, EventArgs e)
        {
            try
            {
                decimal DONID = Convert.ToDecimal(hddVuViecID.Value);
                bool isCreate = false;

                if (!CheckValid(DONID))
                {
                    return;
                }

                if (!isValidThuLy())
                {
                    if (hddThulyid.Value != "0" && hddThulyid.Value != "")
                    {
                        loadThuly(DONID);
                    }

                    return;
                }

                decimal ID = 0;
                DataTable oThulyDataTable = getThuLy();

                if (oThulyDataTable == null || oThulyDataTable.Rows.Count == 0)
                {
                    isCreate = true;
                }
                else
                {
                    ID = Convert.ToDecimal(oThulyDataTable.Rows[0]["ID"]);
                }

                //if (isCreate)
                //{
                //    decimal hmId = getDonId();
                //    int count = dt.DONXINHOANMIEN_THULY.Where(d => d.DONID == DONID && d.LOAIAN == LOAIAN && d.DON_XIN_HOAN_MIEN_ID == hmId).Count();
                //    if (count > 0)
                //    {
                //        lbthongBaoUpdateThuly.Text = "Đã có thông tin thụ lý. Không thể thêm mới!";
                //        return;
                //    }
                //}

                decimal donID = DONID;
                decimal DON_XIN_HOAN_MIEN_ID = getIdDonHoanMien();
                decimal V_LOAIAN = LOAIAN;
                decimal SOTHULY = Convert.ToDecimal(txtSothuly.Text);
                DateTime? NGAYTHULY = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? (DateTime?) null : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                decimal NGUOITHULYID = (String.IsNullOrEmpty(ddlCanboThuly.SelectedValue)) ? 0 : Convert.ToDecimal(ddlCanboThuly.SelectedValue);

                Decimal currDonViId = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                String currUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                string V_NGUOITAO = "";
                DateTime? D_NGAYTAO = null;
                string V_NGUOISUA = "";
                DateTime? D_NGAYSUA = null;
                decimal? N_TOAANID = null;
               
                XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN_BL = new XLHC_DON_HOANMIEN_BL();
                DataTable donSoThulyDataTable = xLHC_DON_HOANMIEN_BL.GET_DONXINHOANMIEN_THULY_BY_SOTHULY_ID(SOTHULY, LOAIAN, ID);
                if (donSoThulyDataTable.Rows.Count > 0 )
                {
                    bool exist = false;
                    foreach (DataRow item in donSoThulyDataTable.Rows)
                    {
                        if (item["TOAANID"].ToString() == item["TOA_GIAIQUYET_ID"].ToString() && item["TOAANID"].ToString() == currDonViId.ToString())
                        {
                            exist = true;
                        }
                    }
                    if (exist)
                    {
                        SetNewSoThuLy();
                        lbthongBaoUpdateThuly.Text = "Số thụ lý đã có trong hệ thống. Bạn có thể dùng số " + txtSothuly.Text;
                        return;
                    }
                    
                }

                if (isCreate)
                {
                    D_NGAYTAO = DateTime.Now;
                    V_NGUOITAO = currUserName + "";
                    if (currDonViId > 0)
                        N_TOAANID = currDonViId;
                }
                else
                {
                    D_NGAYSUA = DateTime.Now;
                    V_NGUOISUA = currUserName + "";
                }
                decimal thulyId = xLHC_DON_HOANMIEN_BL.UPSERT_DONXINHOANMIEN_THULY(ID, V_LOAIAN, donID, N_TOAANID, DON_XIN_HOAN_MIEN_ID, 
                    SOTHULY, NGAYTHULY, NGUOITHULYID, D_NGAYTAO, D_NGAYSUA, V_NGUOITAO, V_NGUOISUA);
                hddThulyid.Value = thulyId.ToString();
                lbthongBaoUpdateThuly.Text = "Lưu thành công!";
                loadThuly(DONID);
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateThuly.Text = "Lỗi: " + ex.Message;
            }
        }

        private DataTable getThuLy()
        {
            decimal hmId = getIdDonHoanMien();
            decimal donId = getDonId();

            XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN_BL = new XLHC_DON_HOANMIEN_BL();
            DataTable dataTable = xLHC_DON_HOANMIEN_BL.GET_DONXINHOANMIEN_THULY_BY_DONID_HOAN_MIEN_ID(donId, LOAIAN, hmId);
            return dataTable;
        }

        protected void cmdXoaThuly_Click(object sender, EventArgs e)
        {
            try
            {
                if (daGiaiQuyet())
                {
                    lbthongBaoUpdateThuly.Text = "Đã có Hội đồng xét xử hoặc Kết quả giải quyết, không được xóa!";
                    return;
                }
                decimal DONID = getDonId();
                if (!CheckValid(DONID))
                {
                    return;
                }

                DataTable oND = getThuLy();
                if (oND != null && oND.Rows.Count > 0)
                {
                    XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN_BL = new XLHC_DON_HOANMIEN_BL();
                    xLHC_DON_HOANMIEN_BL.DELETE_DONXINHOANMIEN_THULY_BY_ID(Convert.ToDecimal(oND.Rows[0]["ID"]));

                    lbthongBaoUpdateThuly.Text = "Xóa thành công!";
                    resetThuly();
                }
                else
                {
                    lbthongBaoUpdateThuly.Text = "Bản ghi bị xóa không tồn tại!";
                }
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateThuly.Text = "Lỗi: " + ex.Message;
            }
        }

        protected void cmdCapnhatKetqua_Click(object sender, EventArgs e)
        {
            try
            {
                var idDonHM = getIdDonHoanMien();
                XLHC_DONXIN_HOAN_MIEN oDon = dt.XLHC_DONXIN_HOAN_MIEN.Where(d => d.ID == idDonHM).FirstOrDefault();

                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2((decimal)oDon.DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongBaoUpdateKetqua.Text = Result;
                    return;
                }

                if (oDon == null)
                {
                    lbthongBaoUpdateKetqua.Text = "Không tìm thấy đơn! Vui lòng thêm mới đơn đề nghị!";
                    return;
                }

                if (txtNgayQD.Text.Trim() == "")
                {
                    lbthongBaoUpdateKetqua.Text = "Chưa nhập ngày quyết định!";
                    txtNgayQD.Focus();
                    return;
                }

                if (Cls_Comon.IsValidDate(txtNgayQD.Text) == false)
                {
                    lbthongBaoUpdateKetqua.Text = "Bạn phải nhập ngày quyết định theo theo định dạng (dd/MM/yyyy)!";
                    txtNgayQD.Focus();
                    return;
                }

                if (String.IsNullOrEmpty(txtSoQD.Text.Trim()))
                {
                    lbthongBaoUpdateKetqua.Text = "Chưa nhập số quyết định!";
                    txtSoQD.Focus();
                    return;
                }

                decimal soQD = Convert.ToDecimal(txtSoQD.Text);
                var donviID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                int countSoQd = dt.XLHC_DONXIN_HOAN_MIEN.Where(d => d.ID != idDonHM && d.SO_QUYETDINH == soQD && d.TOAANID == donviID && d.TOA_GIAIQUYET_ID == donviID).Count();
                if (countSoQd > 0)
                {
                    //update txtSoQD.Text
                    setNextSoQuyetDinh(oDon.TOAANID);
                    lbthongBaoUpdateKetqua.Text = "Số quyết định đã có trong hệ thống. Bạn có thể dùng số " + txtSoQD.Text;
                    txtSoQD.Focus();
                    return;
                }


                if (ddlQuyetdinh.SelectedIndex == 0)
                {
                    lbthongBaoUpdateKetqua.Text = "Vui lòng chọn tên quyết định!";
                    txtSothuly.Focus();
                    return;
                }

                oDon.ISGIAIQUYET = 1;
                oDon.GQ_NGAY = DateTime.Now;
                oDon.DM_QUYETDINH_ID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);

                string ngay = txtNgayQD.Text.Trim();   // "15/09/2025"

                // Ghép ngày + giờ hiện tại theo cul
                string ngayGioChuoi = $"{ngay} {DateTime.Now.ToString("HH:mm:ss", cul)}";

                // Parse lại thành DateTime
                DateTime ngayQD = DateTime.ParseExact(
                    ngayGioChuoi,
                    "dd/MM/yyyy HH:mm:ss",
                    cul
                );

                oDon.NGAY_QUYETDINH = ngayQD;
                oDon.SO_QUYETDINH = soQD;
                oDon.NGAY_BATDAU_HIEULUC = (String.IsNullOrEmpty(txtHieuLucTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtHieuLucTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oDon.NGAY_HET_HIEULUC = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                dt.SaveChanges();
                
                lbthongBaoUpdateKetqua.Text = "Lưu thành công!";
                loadKetQua(getIdDonHoanMien());
                loadInfo_HDXX(getDonId());
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateKetqua.Text = "lỗi: " + ex.Message;
            }
        }

        private void setNextSoQuyetDinh()
        {
            decimal currId = getIdDonHoanMien();
            XLHC_DONXIN_HOAN_MIEN curr = dt.XLHC_DONXIN_HOAN_MIEN.Where(d => d.ID == currId).FirstOrDefault();

            if (curr == null)
            {
                lbthongBaoUpdateKetqua.Text = "Không tìm thấy đơn! Vui lòng thêm mới đơn đề nghị!";
                return;
            }

            this.setNextSoQuyetDinh(curr.TOAANID);
        }

        private void setNextSoQuyetDinh(decimal? donViId)
        {
            if (donViId == null)
            {
                donViId = 0;
            }

            //Số qd mới
            if (String.IsNullOrEmpty(txtNgayQD.Text))
            {
                txtNgayQD.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }

            DateTime ngayQD = DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime vFromDate = DateTime.Parse("01/01/" + ngayQD.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime vToDate = DateTime.Parse("31/12/" + ngayQD.Year, cul, DateTimeStyles.NoCurrentDateDefault);

            XLHC_DONXIN_HOAN_MIEN oDon = dt.XLHC_DONXIN_HOAN_MIEN
                .Where(x => x.TOAANID == donViId && x.TOA_GIAIQUYET_ID == x.TOAANID
                            && x.SO_QUYETDINH != null
                            && x.NGAY_QUYETDINH >= vFromDate
                            && x.NGAY_QUYETDINH <= vToDate)
                .OrderByDescending(x => x.SO_QUYETDINH).FirstOrDefault(); ;

            decimal soQdMax = 0;
            if (oDon != null && oDon.SO_QUYETDINH != null && oDon.SO_QUYETDINH > 1)
            {
                soQdMax = (decimal)oDon.SO_QUYETDINH;
            }

            txtSoQD.Text = (soQdMax + 1).ToString();
        }

        protected void cmdXoaKetqua_Click(object sender, EventArgs e)
        {
            try
            {
                var idDonHM = getIdDonHoanMien();
                XLHC_DONXIN_HOAN_MIEN oDon = dt.XLHC_DONXIN_HOAN_MIEN.Where(d => d.ID == idDonHM).FirstOrDefault();

                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2((decimal)oDon.DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongBaoUpdateKetqua.Text = Result;
                    return;
                }

                if (oDon == null)
                {
                    lbthongBaoUpdateKetqua.Text = "Không tìm thấy đơn! Vui lòng thêm mới đơn đề nghị!";
                    return;
                }

                oDon.ISGIAIQUYET = 0;
                oDon.GQ_NGAY = null;
                oDon.DM_QUYETDINH_ID = null;
                oDon.NGAY_QUYETDINH = null;
                oDon.SO_QUYETDINH = null;
                oDon.NGAY_BATDAU_HIEULUC = null;
                oDon.NGAY_HET_HIEULUC = null;

                dt.SaveChanges();

                lbthongBaoUpdateKetqua.Text = "Xóa thành công!";
                resetKetQua();
                loadInfo_HDXX(getDonId());
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateKetqua.Text = "lỗi: " + ex.Message;
            }
        }

        protected void cmdGiaiQuyet_Click(decimal donId)
        {
            hddVuViecID.Value = donId.ToString();
            if (hddVuViecID.Value + "" == "" || hddVuViecID.Value == "0")
            {
                lbthongBaoUpdateThuly.Text = "Bạn chưa chọn vụ việc để giải quyết. Hãy chọn lại!";
                return;
            }

            loadDDL_HDXX();
            LoadDropCanBoThuLy();
            LoadQuyetDinh();
        }

        private void LoadQuyetDinh()
        {
            string code = "ĐNHMCH-BPXLHC";
            
            DM_QD_LOAI loaiQD = dt.DM_QD_LOAI
                .Where(x => x.MA == code && x.HIEULUC == 1 && x.ISXLHC == 1)
                .FirstOrDefault();

            ddlQuyetdinh.Items.Clear();
            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "-1"));

            if (loaiQD != null)
            {
                var listItem = dt.DM_QD_QUYETDINH.Where(x => x.ISXLHC == 1 && x.HIEULUC == 1 && x.LOAIID == loaiQD.ID)
                    .OrderBy(y => y.TEN)
                    .ToList();

                for (int i = 1; i <= listItem.Count; i++)
                {
                    ddlQuyetdinh.Items.Insert(i, new ListItem(listItem[i - 1].TEN, listItem[i - 1].ID.ToString()));
                }
            }
        }

        private void LoadDropCanBoThuLy()
        {
            List<string> listChucDanhThuLy = new List<string>
            {
                "Thư ký",
                "Thư ký Toà án",
                "Các chức danh Thẩm phán",
                "Các chức danh Thẩm tra viên",
                "Chuyên viên",
                "Chuyên viên chính",
                "Nhân viên văn thư",
                "Thư ký Toà án không có ĐHL"
            };

            ddlCanboThuly.Items.Clear();

            DM_CANBO_BL dmCBBL = new DM_CANBO_BL();
            DataTable tbl = dmCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataTable filteredTable = tbl.Clone();

                foreach (DataRow row in tbl.Rows)
                {
                    string ten = row["TENCHUCDANH"]?.ToString() ?? "";
                    if (listChucDanhThuLy.Any(prefix => ten.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)))
                    {
                        filteredTable.ImportRow(row);
                    }
                }

                ddlCanboThuly.DataSource = filteredTable;
                ddlCanboThuly.DataTextField = "MA_TEN";
                ddlCanboThuly.DataValueField = "ID";
                ddlCanboThuly.DataBind();
            }
            ddlCanboThuly.Items.Insert(0, new ListItem("--- Chọn ---", "0"));


            ddlOldCanboThuly.Items.Clear();

            var toaGiaiQuyetId = hddToaAnGiaiQuyetId.Value;
            DataTable tbl1 = dmCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(toaGiaiQuyetId));
            if (tbl1 != null && tbl1.Rows.Count > 0)
            {
                DataTable filteredTable = tbl1.Clone();

                foreach (DataRow row in tbl1.Rows)
                {
                    string ten = row["TENCHUCDANH"]?.ToString() ?? "";
                    if (listChucDanhThuLy.Any(prefix => ten.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)))
                    {
                        filteredTable.ImportRow(row);
                    }
                }

                ddlOldCanboThuly.DataSource = filteredTable;
                ddlOldCanboThuly.DataTextField = "MA_TEN";
                ddlOldCanboThuly.DataValueField = "ID";
                ddlOldCanboThuly.DataBind();
            }
            ddlOldCanboThuly.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            //Set mặc định cán bộ login
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlCanboThuly.SelectedValue = strCBID;
            }
            catch
            {
                //ignore
            }
        }

        protected void loadDDL_HDXX()
        {
            ddlTucachTGTT.Items.Clear();
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán chủ tọa phiên tòa", ENUM_NGUOITIENHANHTOTUNG.THAMPHAN));
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán thành viên hội đồng xét xử", ENUM_NGUOITIENHANHTOTUNG.THAMPHANHDXX));
            ddlTucachTGTT.Items.Add(new ListItem("Thẩm phán dự khuyết", ENUM_NGUOITIENHANHTOTUNG.THAMPHANDUKHUYET));
            ddlTucachTGTT.Items.Add(new ListItem("Hội thẩm nhân dân", ENUM_CHUCDANH.CHUCDANH_HTND));
            ddlTucachTGTT.Items.Add(new ListItem("Thư ký", ENUM_NGUOITIENHANHTOTUNG.THUKY));
            ddlTucachTGTT.Items.Add(new ListItem("Thư ký dự khuyết", ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET));
            ddlTucachTGTT.Items.Add(new ListItem("Kiểm sát viên", ENUM_CHUCDANH.CHUCDANH_KSV));
            //init = tham phan
            ddlTucachTGTT.SelectedValue = ENUM_NGUOITIENHANHTOTUNG.THAMPHAN;

            decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU]);

            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(DonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.Items.Clear();
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlNguoiphancong.Items.Clear();
            ddlNguoiphancong.DataSource = oCBDT;
            ddlNguoiphancong.DataTextField = "MA_TEN";
            ddlNguoiphancong.DataValueField = "ID";
            ddlNguoiphancong.DataBind();

            //
            ddlHTND_NguoiPC.DataSource = oCBDT;
            ddlHTND_NguoiPC.DataTextField = "MA_TEN";
            ddlHTND_NguoiPC.DataValueField = "ID";
            ddlHTND_NguoiPC.DataBind();

            ddlHTND_Thuky.Items.Insert(0, new ListItem("--Chọn--", "0"));
            ddlKSV_Nguoi.Items.Insert(0, new ListItem("--Chọn--", "0"));

            Cls_Comon.SetFocus(this, this.GetType(), ddlThamphan.ClientID);
        }

        private void reset_HDXX()
        {
            hddHdxxid.Value = "0";
            ddlTucachTGTT.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;
            ddlNguoiphancong.SelectedIndex = 0;
            ddlHTND_Thuky.SelectedIndex = 0;
            ddlHTND_NguoiPC.SelectedIndex = 0;
            ddlKSV_Nguoi.SelectedIndex = 0;

            txtNgayphancong.Text = "";
            txtNhanphancong.Text = "";
            txtNgayketthuc.Text = "";
            lbthongbaoTTNguoiTHToTung.Text = "";
        }

        //load thong tin nguoi tien hanh to tung
        public void LoadGrid_HDXX(decimal donId)
        {
            XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();
            DataTable oDT = oBL.HOANMIEN_SOTHAM_HDXX_GETLIST(donId, LOAIAN, getIdDonHoanMien());
            string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                    lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList_HDXX.DataSource = oDT;
                dgList_HDXX.DataBind();
                pndata.Visible = true;
                //foreach (DataRow item in oDT.Rows)
                //{
                //    if (item["TOA_GIAIQUYET_ID"] != null && item["TOA_GIAIQUYET_ID"].ToString() != donviID)
                //    {
                //        Cls_Comon.SetButton(cmdCapnhaHDXX, false);
                //        Cls_Comon.SetButton(cmdLammoiHDXX, false);
                //    }
                //}
            }
            else
            {
                pndata.Visible = false;
            }
        }

        private void SetNewSoThuLy()
        {
            Decimal donViId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            //Số thụ lý mới
            if (String.IsNullOrEmpty(txtNgaythuly.Text))
            {
                txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }

            DateTime ngayThuLy = DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime vFromDate = DateTime.Parse("01/01/" + ngayThuLy.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime vToDate = DateTime.Parse("31/12/" + ngayThuLy.Year, cul, DateTimeStyles.NoCurrentDateDefault);

            XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN_BL = new XLHC_DON_HOANMIEN_BL();
            DataTable dataTable = xLHC_DON_HOANMIEN_BL.GET_DONXINHOANMIEN_THULY_BY_SOTHULY_NGAYTHULY(LOAIAN, vFromDate, vToDate);

            decimal soThuLyMax = 0;
            if (dataTable != null && dataTable.Rows.Count > 0)
            {
                foreach (DataRow item in dataTable.Rows)
                {
                    if (item["TOAANID"].ToString() == item["TOA_GIAIQUYET_ID"].ToString() && item["TOAANID"].ToString() == donViId.ToString() && item["SOTHULY"] != null && Convert.ToDecimal(item["SOTHULY"]) > 0)
                    {
                        soThuLyMax = Convert.ToDecimal(item["SOTHULY"]);
                        break;
                    }
                }
            }

            txtSothuly.Text = (soThuLyMax + 1).ToString();
        }

        protected void loadThuly(decimal DONID)
        {
            try
            {
                DataTable dThuLyDataTable = getThuLy();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (dThuLyDataTable != null && dThuLyDataTable.Rows.Count > 0)
                {
                    hddThulyid.Value = dThuLyDataTable.Rows[0]["ID"].ToString();
                    if (dThuLyDataTable.Rows[0]["NGAYTHULY"] != null)
                        txtNgaythuly.Text = ((DateTime) dThuLyDataTable.Rows[0]["NGAYTHULY"]).ToString("dd/MM/yyyy", cul);

                    txtSothuly.Text = dThuLyDataTable.Rows[0]["SOTHULY"].ToString();
                    //ddlCanboThuly.SelectedValue = dThuLyDataTable.Rows[0]["NGUOITHULYID"] + "";

                    // Gán toà án giải quyết
                    hddToaanId.Value = dThuLyDataTable.Rows[0]["TOAANID"] + "";
                    hddToaAnGiaiQuyetId.Value = dThuLyDataTable.Rows[0]["TOA_GIAIQUYET_ID"] + "";
                    List<string> listChucDanhThuLy = new List<string>
                    {
                        "Thư ký",
                        "Thư ký Toà án",
                        "Các chức danh Thẩm phán",
                        "Các chức danh Thẩm tra viên",
                        "Chuyên viên",
                        "Chuyên viên chính",
                        "Nhân viên văn thư",
                        "Thư ký Toà án không có ĐHL"
                    };


                    var toaGiaiQuyetId = hddToaAnGiaiQuyetId.Value;
                    DM_CANBO_BL dmCBBL = new DM_CANBO_BL();
                    DataTable tbl1 = dmCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(toaGiaiQuyetId));
                    if (tbl1 != null && tbl1.Rows.Count > 0)
                    {
                        DataTable filteredTable = tbl1.Clone();

                        foreach (DataRow row in tbl1.Rows)
                        {
                            string ten = row["TENCHUCDANH"]?.ToString() ?? "";
                            if (listChucDanhThuLy.Any(prefix => ten.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)))
                            {
                                filteredTable.ImportRow(row);
                            }
                        }

                        ddlOldCanboThuly.DataSource = filteredTable;
                        ddlOldCanboThuly.DataTextField = "MA_TEN";
                        ddlOldCanboThuly.DataValueField = "ID";
                        ddlOldCanboThuly.DataBind();
                    }
                    ddlOldCanboThuly.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

                    if (ddlCanboThuly.Items.FindByValue(dThuLyDataTable.Rows[0]["NGUOITHULYID"] + "") != null)
                        ddlCanboThuly.SelectedValue = dThuLyDataTable.Rows[0]["NGUOITHULYID"] + "";
                    if (ddlOldCanboThuly.Items.FindByValue(dThuLyDataTable.Rows[0]["NGUOITHULYID"] + "") != null)
                    {
                        ddlOldCanboThuly.SelectedValue = dThuLyDataTable.Rows[0]["NGUOITHULYID"] + "";
                    }
                    if (dThuLyDataTable.Rows[0]["NGAYTAO"] != null)
                        txtNgayTao.Text = ((DateTime)dThuLyDataTable.Rows[0]["NGAYTAO"]).ToString("dd/MM/yyyy", cul); 
                    if (dThuLyDataTable.Rows[0]["TOA_GIAIQUYET_ID"] != null && dThuLyDataTable.Rows[0]["TOA_GIAIQUYET_ID"].ToString() != donviID)
                    {
                        Cls_Comon.SetButton(cmdXoaThuly, false);
                        Cls_Comon.SetButton(cmdCapnhatThuly, false);
                    }

                    // Nếu là sửa thì ẩn toà cũ đi
                    if (hddToaanId.Value == hddToaAnGiaiQuyetId.Value || string.IsNullOrEmpty(hddToaAnGiaiQuyetId.Value))
                    {
                        ddlOldCanboThuly.Visible = false;
                    }
                    else if (hddToaanId.Value != hddToaAnGiaiQuyetId.Value && !string.IsNullOrEmpty(hddToaAnGiaiQuyetId.Value))
                    {
                        ddlCanboThuly.Visible = false;
                    }
                }
                else
                {
                    ddlCanboThuly.SelectedIndex = 0;
                    lbthongBaoUpdateThuly.Text = "Bạn chưa nhập thụ lý!";
                    // Nếu là thêm thì ẩn toà cũ
                    ddlOldCanboThuly.Visible = false;
                }
            }
            catch (Exception ex)
            {
                lbthongBaoUpdateThuly.Text = ex.Message;
            }
        }

        protected void resetThuly()
        {
            hddThulyid.Value = "0";
            txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
            //reset so thu ly ve chuoi rong
            txtSothuly.Text = "";
            //day gia tri thu ly moi
            this.SetNewSoThuLy();
            ddlCanboThuly.SelectedIndex = 0;
            txtNgayTao.Text = "";
        }

        private bool CheckValid_HDXX()
        {
            string tucach = ddlTucachTGTT.SelectedValue;
            switch (tucach)
            {
                case ENUM_CHUCDANH.CHUCDANH_HTND:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbaoTTNguoiTHToTung.Text = "Chưa chọn Hội thẩm nhân dân !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_NGUOITIENHANHTOTUNG.THUKY:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbaoTTNguoiTHToTung.Text = "Chưa chọn Thư ký !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET:
                    if (ddlHTND_Thuky.SelectedIndex == 0)
                    {
                        lbthongbaoTTNguoiTHToTung.Text = "Chưa chọn Thư ký !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlHTND_Thuky.ClientID);
                        return false;
                    }
                    break;
                case ENUM_CHUCDANH.CHUCDANH_KSV:
                    if (ddlKSV_Nguoi.SelectedIndex == 0)
                    {
                        lbthongbaoTTNguoiTHToTung.Text = "Chưa chọn Kiểm sát viên !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlKSV_Nguoi.ClientID);
                        return false;
                    }
                    break;
                default:
                    if (ddlThamphan.SelectedIndex == 0)
                    {
                        lbthongbaoTTNguoiTHToTung.Text = "Chưa chọn Thẩm phán !";
                        Cls_Comon.SetFocus(this, this.GetType(), ddlThamphan.ClientID);
                        return false;
                    }
                    break;
            }

            return true;
        }

        protected void cmdCapnhaHDXX_Click(object sender, EventArgs e)
        {
            try
            {
                bool isCreate = false;
                decimal DONID = getDonId();
                decimal idDonXinHoanMien = getIdDonHoanMien();

                if (!CheckValid_HDXX()) return;

                string tucach = ddlTucachTGTT.SelectedValue, TenChucDanh = "", TenCanBo = "";
                decimal ID = 0;

                decimal N_DONID;
                string V_MAVAITRO = null;
                decimal N_CANBOID;
                decimal? N_NGUOIPHANCONGID = null;
                DateTime? D_NGAYPHANCONG = null;
                DateTime? D_NGAYNHANPHANCONG = null;
                DateTime? D_NGAYKETTHUC = null;
                string V_HOTEN = null;
                decimal N_LOAIAN;
                decimal N_DON_XIN_HOAN_MIEN_ID;
                decimal N_TOA_GIAIQUYET_ID;
                DateTime? D_NGAYTAO = null;
                string V_NGUOITAO = null;
                DateTime? D_NGAYSUA = null;
                string V_NGUOISUA = null;

                string StrMsg = "Không được sửa đổi thông tin.";
                string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                if (Result != "")
                {
                    lbthongbaoTTNguoiTHToTung.Text = Result;
                    return;
                }

                //them moi ban ghi => dam bao chi 1 nguoi chi dam bao 1 chuc vu va chi co 1 nguoi lam chu toa

                if (hddHdxxid.Value == "" || hddHdxxid.Value == "0")
                {
                    isCreate = true;
                }
                else
                {
                    if (daGiaiQuyet())
                    {
                        lbthongbaoTTNguoiTHToTung.Text = "Vụ án đã có kết quả giải quyết. Không được cập nhật thông tin!";
                        return;
                    }

                    ID = Convert.ToDecimal(hddHdxxid.Value);

                    XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN = new XLHC_DON_HOANMIEN_BL();
                    DataTable dataTableHoanMien = xLHC_DON_HOANMIEN.GET_HOANMIEN_SOTHAM_HDXX_BY_ID(ID);

                    if (dataTableHoanMien == null || dataTableHoanMien.Rows.Count == 0)
                    {
                        lbthongbaoTTNguoiTHToTung.Text = "Người tiến hành tố tụng không tồn tại!";
                        return;
                    }
                }

                if (tucach == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN)
                {
                    // Kiểm tra vụ án đã có thẩm phán chủ tọa phiên tòa chưa
                    // Nếu có thì không được phép thêm thẩm phán chủ tọa phiên tòa
                    XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN_BL = new XLHC_DON_HOANMIEN_BL();


                    DataTable countThamPhanChuToa = xLHC_DON_HOANMIEN_BL.GET_HOANMIEN_SOTHAM_HDXX_BY_DON_VAITRO(DONID, idDonXinHoanMien, ENUM_NGUOITIENHANHTOTUNG.THAMPHAN, LOAIAN, ID);

                    if (countThamPhanChuToa.Rows.Count > 0)
                    {
                        lbthongbaoTTNguoiTHToTung.Text = "Vụ án đã có thẩm phán chủ tọa phiên tòa. Không được thêm mới!";
                        ddlThamphan.Focus();
                        return;
                    }
                }

                N_DONID = DONID;
                V_MAVAITRO = ddlTucachTGTT.SelectedValue;

                if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET)
                {
                    if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND)
                        TenChucDanh = "Hội thẩm nhân dân";
                    else
                        TenChucDanh = "Thư ký";
                    TenCanBo = (ddlHTND_Thuky.SelectedItem.Text.Split('-'))[0].Trim().ToString();
                    N_CANBOID = Convert.ToDecimal(ddlHTND_Thuky.SelectedValue);
                    N_NGUOIPHANCONGID = Convert.ToDecimal(ddlHTND_NguoiPC.SelectedValue);
                    D_NGAYPHANCONG = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    D_NGAYNHANPHANCONG = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //oND.DUKHUYET = Convert.ToDecimal(rdbDuKhuyet.SelectedValue);
                }
                else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
                {
                    TenChucDanh = "Kiểm sát viên";
                    TenCanBo = (ddlKSV_Nguoi.SelectedItem.Text.Split('-'))[0].Trim().ToString();
                    N_CANBOID = Convert.ToDecimal(ddlKSV_Nguoi.SelectedValue);
                }
                else //THAMPHAN, THAMPHANHDXX và THAMPHANDUKHUYET
                {
                    TenChucDanh = "Thẩm phán";
                    TenCanBo = (ddlThamphan.SelectedItem.Text.Split('-'))[0].Trim().ToString();
                    N_CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                    N_NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
                    D_NGAYPHANCONG = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    D_NGAYNHANPHANCONG = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }

                D_NGAYKETTHUC = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                V_HOTEN = TenCanBo;
                N_LOAIAN = LOAIAN;
                N_DON_XIN_HOAN_MIEN_ID = idDonXinHoanMien;
                N_TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                // Kiểm tra nếu thẩm phán đã được phân công rồi thì không phân lại nữa. Chọn thẩm phán khác
                XLHC_DON_HOANMIEN_BL xlhcDonHoanmienBl = new XLHC_DON_HOANMIEN_BL();
                DataTable dataTable = xlhcDonHoanmienBl.GET_HOANMIEN_SOTHAM_HDXX_BY_CONDITION(DONID, idDonXinHoanMien, N_CANBOID, LOAIAN, ID);
                
                if (dataTable != null && dataTable.Rows.Count > 0)
                {
                    lbthongbaoTTNguoiTHToTung.Text = TenChucDanh + " " + TenCanBo + " đã được phân công. Hãy chọn lại!";
                    return;
                }

                if (isCreate)
                {
                    D_NGAYTAO = DateTime.Now;
                    V_NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                else
                {
                    D_NGAYSUA = DateTime.Now;
                    V_NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN1 = new XLHC_DON_HOANMIEN_BL();
                xLHC_DON_HOANMIEN1.UPSERT_HOANMIEN_SOTHAM_HDXX(ID, N_DONID, V_MAVAITRO, N_CANBOID, V_HOTEN, D_NGAYPHANCONG,
                    D_NGAYNHANPHANCONG, null, D_NGAYKETTHUC, N_NGUOIPHANCONGID, null, V_NGUOITAO, 
                    D_NGAYTAO, V_NGUOISUA, D_NGAYSUA, N_LOAIAN, N_DON_XIN_HOAN_MIEN_ID, N_TOA_GIAIQUYET_ID);

                loadInfo_HDXX(DONID);
                reset_HDXX();
                lbthongbaoTTNguoiTHToTung.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbaoTTNguoiTHToTung.Text = "Lỗi: " + ex.Message;
                lbthongbaoTTNguoiTHToTung.Text = "Lỗi: " + ex.ToString();
            }
        }

        protected void cmdLammoiHDXX_Click(object sender, EventArgs e)
        {
            reset_HDXX();
        }

        #region "Phân trang người tham gia tố tụng"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList_HDXX.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid_HDXX(Convert.ToDecimal(hddVuViecID.Value));
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList_HDXX.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid_HDXX(Convert.ToDecimal(hddVuViecID.Value));
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList_HDXX.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid_HDXX(Convert.ToDecimal(hddVuViecID.Value));
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList_HDXX.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid_HDXX(Convert.ToDecimal(hddVuViecID.Value));
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList_HDXX.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid_HDXX(Convert.ToDecimal(hddVuViecID.Value));
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion

        protected void ddlTucachTGTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            string tucach = ddlTucachTGTT.SelectedValue;
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            
            if (tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET)
            {
                pnThamphan.Visible = false;
                pnHTND.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;

                lblHTND.Text = "Thư ký phiên tòa";

                ddlHTND_Thuky.Items.Clear();
                tbl = objBL.DM_CANBO_GetAllThuKy_TTV(DonViID, ENUM_CHUCDANH.CHUCDANH_THUKY);
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
                lblHTND.Text = "Tên Hội thẩm nhân dân";
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
                if (tbl.Rows.Count > 1)
                    drop.Items.Insert(0, new ListItem("--Chọn--", "0"));
            }
            else
                drop.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }

        public void loadEdit_HDXX(decimal ID)
        {
            XLHC_DON_HOANMIEN_BL xlhcDonHoanmienBl = new XLHC_DON_HOANMIEN_BL();
            DataTable dataTable = xlhcDonHoanmienBl.GET_HOANMIEN_SOTHAM_HDXX_BY_ID(ID);
            DataRow row = dataTable.Rows[0];

            hddHdxxid.Value = row["ID"].ToString();

            ddlTucachTGTT.SelectedValue = row["MAVAITRO"].ToString();
            string tucach = row["MAVAITRO"].ToString();
            ddlTucachTGTT_SelectedIndexChanged(new object(), new EventArgs());

            if (tucach == ENUM_CHUCDANH.CHUCDANH_HTND || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKY || tucach == ENUM_NGUOITIENHANHTOTUNG.THUKYDUKHUYET)
            {
                if (row["CANBOID"] != null)
                    if (ddlHTND_Thuky.Items.FindByValue(row["CANBOID"].ToString()) != null)
                        ddlHTND_Thuky.SelectedValue = row["CANBOID"].ToString();
                if (row["NGUOIPHANCONGID"] != null)
                    if (ddlHTND_NguoiPC.Items.FindByValue(row["NGUOIPHANCONGID"].ToString()) != null)
                        ddlHTND_NguoiPC.SelectedValue = row["NGUOIPHANCONGID"].ToString();

                txtNgayphancong.Text = row["NGAYPHANCONG"] + "" == "" ? "" : ((DateTime)row["NGAYPHANCONG"]).ToString("dd/MM/yyyy", cul);
                txtNhanphancong.Text = row["NGAYNHANPHANCONG"] + "" == "" ? "" : ((DateTime)row["NGAYNHANPHANCONG"]).ToString("dd/MM/yyyy", cul);
                pnThamphan.Visible = false;
                pnHTND.Visible = true;// pnDuKhuyet.Visible = true;
                pnKSV.Visible = false;
                pnPhancong.Visible = true;
            }
            else if (tucach == ENUM_CHUCDANH.CHUCDANH_KSV)
            {
                if (row["CANBOID"] != null)
                    if (ddlKSV_Nguoi.Items.FindByValue(row["CANBOID"].ToString()) != null)
                        ddlKSV_Nguoi.SelectedValue = row["CANBOID"].ToString();
                pnThamphan.Visible = false;
                pnHTND.Visible = false; //pnDuKhuyet.Visible = false;
                pnKSV.Visible = true;
                pnPhancong.Visible = false;
            }
            else
            {
                if (row["CANBOID"] != null)
                    if (ddlThamphan.Items.FindByValue(row["CANBOID"].ToString()) != null)
                        ddlThamphan.SelectedValue = row["CANBOID"].ToString();
                if (row["NGUOIPHANCONGID"] != null)
                    if (ddlNguoiphancong.Items.FindByValue(row["NGUOIPHANCONGID"].ToString()) != null)
                        ddlNguoiphancong.SelectedValue = row["NGUOIPHANCONGID"].ToString();
                
                txtNgayphancong.Text = row["NGAYPHANCONG"] + "" == "" ? "" : ((DateTime)row["NGAYPHANCONG"]).ToString("dd/MM/yyyy", cul);
                txtNhanphancong.Text = row["NGAYNHANPHANCONG"] + "" == "" ? "" : ((DateTime)row["NGAYNHANPHANCONG"]).ToString("dd/MM/yyyy", cul);
                pnThamphan.Visible = true;
                pnHTND.Visible = pnKSV.Visible = false;// pnDuKhuyet.Visible = false;
                pnPhancong.Visible = true;
            }

            txtNgayketthuc.Text = row["NGAYKETTHUC"] + "" == "" ? "" : ((DateTime)row["NGAYKETTHUC"]).ToString("dd/MM/yyyy", cul);
        }

        public void xoa_HDXX(decimal id)
        {
            decimal DONID = getDonId();
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbaoTTNguoiTHToTung.Text = Result;
                return;
            }

            XLHC_DON_HOANMIEN_BL xLHC_DON_HOANMIEN_BL = new XLHC_DON_HOANMIEN_BL();
            DataTable dataTable = xLHC_DON_HOANMIEN_BL.GET_HOANMIEN_SOTHAM_HDXX_BY_ID(id);

            xLHC_DON_HOANMIEN_BL.DELETE_HOANMIEN_SOTHAM_HDXX_BY_ID(id);

            loadInfo_HDXX((decimal)(dataTable == null || dataTable.Rows.Count == 0 ? 0 : dataTable.Rows[0]["DONID"]));
            reset_HDXX();
            lbthongbaoTTNguoiTHToTung.Text = "Xóa thành công!";
        }

    }
}