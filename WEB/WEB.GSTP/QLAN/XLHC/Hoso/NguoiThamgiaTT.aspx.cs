using BL.GSTP;
using BL.GSTP.XLHC;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace WEB.GSTP.QLAN.XLHC.Hoso
{
    public partial class NguoiThamgiaTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    decimal ID = Convert.ToDecimal(current_id);
                    CheckQuyen(ID);
                    LoadGrid();
                    XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                    txtHoten.Text = oT.CQDN_TEN + "";
                    txtTenNguyenDon.Text = oT.CQDN_TEN;
                    txtHoten.Enabled = false;
                    XLHC_DUONGSU obj = null;
                    try
                    {
                        obj = dt.XLHC_DUONGSU.Where(x => x.DONID == oT.ID && x.BICANDAUVU == 1 && x.LOAIDOITUONG == 1).OrderBy(y => y.NGAYTAO)
                            .ToList<XLHC_DUONGSU>()[0];
                    }
                    catch (Exception ex)
                    {
                        obj = null;
                    }

                    if (obj != null)
                    {
                        txtTenBiCan.Text = obj.HOTEN;
                    }
                    //check vụ án đã kết thúc không cho sửa xóa
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);

                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
           
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            
            XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                hddNgayNhanDon.Value = oT.NGAYNHANDON + "" == "" ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy");
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            
            // string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg);
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(ID, StrMsg);

            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                .FirstOrDefault();
            if (chuyenNhanAn != null)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển xét xử phúc thẩm, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }
        }
        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlTucachTGTT.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTBPXLHC);
            ddlTucachTGTT.DataTextField = "TEN";
            ddlTucachTGTT.DataValueField = "MA";
            ddlTucachTGTT.DataBind();
        }
        private void ResetControls()
        {
            lbthongbao.Text = "";
            txtHoten.Text = txtTenNguyenDon.Text;
            txtNDD_Hoten.Text = "";
            txtND_Ngaysinh.Text = "";
            txtND_Namsinh.Text = "";
            txtND_HKTT_Chitiet.Text = "";
            txtND_TTChitiet.Text = "";
            txtNgaythamgia.Text = "";
            txtDienThoai.Text = txtFax.Text = txtEmail.Text = "";
            hddid.Value = "0";
            ddlTucachTGTT.SelectedIndex = 0;
        }
        private bool CheckValid()
        {
            if (ddlTucachTGTT.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn tư cách tham gia tố tụng. Hãy nhập lại!";
                ddlTucachTGTT.Focus();
                return false;
            }
            if (txtHoten.Text.Trim() == "")
            {
                lbthongbao.Text = "Chưa nhập họ tên người tham gia tố tụng!";
                txtHoten.Focus();
                return false;
            }
            else if (txtHoten.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Họ tên người tham gia tố tụng không quá 250 ký tự!";
                txtHoten.Focus();
                return false;
            }
            if (txtNgaythamgia.Text.Trim() != "")
            {
                if (Cls_Comon.IsValidDate(txtNgaythamgia.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập ngày tham gia theo định dạng (dd/MM/yyyy)!";
                    txtNgaythamgia.Focus();
                    return false;
                }
                DateTime NgayThamGia = DateTime.Parse(txtNgaythamgia.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (hddNgayNhanDon.Value != "")
                {
                    DateTime NgayNhanDon = DateTime.Parse(hddNgayNhanDon.Value, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (NgayThamGia < NgayNhanDon)
                    {
                        lbthongbao.Text = "Bạn phải nhập ngày tham gia lớn hơn ngày nhận đơn " + hddNgayNhanDon.Value + "!";
                        txtNgaythamgia.Focus();
                        return false;
                    }
                }
                if (NgayThamGia > DateTime.Now)
                {
                    lbthongbao.Text = "Bạn phải nhập ngày tham gia nhỏ hơn ngày hiện tại!";
                    txtNgaythamgia.Focus();
                    return false;
                }
            }
            if (txtND_TTChitiet.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Nơi tạm trú chi tiết không nhập quá 250 ký tự. Hãy nhập lại!";
                txtND_TTChitiet.Focus();
                return false;
            }
            if (txtND_HKTT_Chitiet.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Nơi ĐKHKTT chi tiết không nhập quá 250 ký tự. Hãy nhập lại!";
                txtND_HKTT_Chitiet.Focus();
                return false;
            }
            if (txtND_Ngaysinh.Text.Trim() != "")
            {
                if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy)!";
                    txtND_Ngaysinh.Focus();
                    return false;
                }
                DateTime NgaySinh = DateTime.Parse(txtND_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgaySinh > DateTime.Now)
                {
                    lbthongbao.Text = "Bạn phải nhập ngày sinh nhỏ hơn ngày hiện tại!";
                    txtND_Ngaysinh.Focus();
                    return false;
                }
            }
           
            if (txtDienThoai.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Điện thoại không nhập quá 250 ký tự. Hãy nhập lại!";
                txtDienThoai.Focus();
                return false;
            }
            if (txtFax.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Fax không nhập quá 250 ký tự. Hãy nhập lại!";
                txtFax.Focus();
                return false;
            }
            int lengthEmail = txtEmail.Text.Trim().Length;
            if (lengthEmail > 0)
            {
                if (lengthEmail > 250)
                {
                    lbthongbao.Text = "Email không nhập quá 250 ký tự. Hãy nhập lại!";
                    txtEmail.Focus();
                    return false;
                }
                string email = txtEmail.Text.Trim();
                int atpos = email.IndexOf("@");
                var dotpos = email.LastIndexOf(".");
                if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= lengthEmail)
                {
                    lbthongbao.Text = "Địa chỉ email chưa đúng!";
                    txtEmail.Focus();
                    return false;
                }
            }

            if (txtNDD_Hoten.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Đại diện cho không nhập quá 250 ký tự. Hãy nhập lại!";
                txtNDD_Hoten.Focus();
                return false;
            }
      

            return true;
        }
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                txtND_Namsinh.Text = d.Year.ToString();
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                XLHC_DON_THAMGIATOTUNG oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new XLHC_DON_THAMGIATOTUNG();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.XLHC_DON_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
                }

                oND.DONID = DONID;
                oND.HOTEN = txtHoten.Text;
                oND.TUCACHTGTTID = ddlTucachTGTT.SelectedValue;
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
                oND.NGAYSINH = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.DIENTHOAI = txtDienThoai.Text;
                oND.FAX = txtFax.Text;
                oND.EMAIL = txtEmail.Text;
                oND.NGUOIDAIDIEN = txtNDD_Hoten.Text;
                oND.NGAYTHAMGIA = (String.IsNullOrEmpty(txtNgaythamgia.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythamgia.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.XLHC_DON_THAMGIATOTUNG.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
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
            XLHC_DON_BL oBL = new XLHC_DON_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal ID = Convert.ToDecimal(current_id);
            
            //DataTable oDT = oBL.XLHC_DON_TGTT_GETLIST(ID);
            DataTable oDT = oBL.XLHC_DON_TGTT_GETLIST_V2(ID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
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
            XLHC_DON_THAMGIATOTUNG oND = dt.XLHC_DON_THAMGIATOTUNG.Where(x => x.ID == id).FirstOrDefault();
            dt.XLHC_DON_THAMGIATOTUNG.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            XLHC_DON_THAMGIATOTUNG oND = dt.XLHC_DON_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
         
            txtHoten.Text = oND.HOTEN;
            txtHoten.Enabled = true;
            ddlTucachTGTT.SelectedValue = oND.TUCACHTGTTID.ToString();
            txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
            txtND_HKTT_Chitiet.Text = oND.HKTTCHITIET;
            if (oND.NGAYSINH != null) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
            txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            txtDienThoai.Text = oND.DIENTHOAI;
            txtFax.Text = oND.FAX;
            txtEmail.Text = oND.EMAIL;
            txtNDD_Hoten.Text = oND.NGUOIDAIDIEN;
            if (oND.NGAYTHAMGIA != null) txtNgaythamgia.Text = ((DateTime)oND.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
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
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg);
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    xoa(ND_id);
                    ResetControls();

                    break;
            }

        }
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
        #endregion
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                string TCTGTT = rowView["TUCACHTGTTID"].ToString();
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                if (TCTGTT == ENUM_TCTT_BPXLHC.CQDN || TCTGTT == ENUM_TCTT_BPXLHC.NBDN)
                {
                    lblSua.Visible = false;
                }
                
                decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                    .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                    .FirstOrDefault();
                if (chuyenNhanAn != null)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển xét xử cấp phúc thẩm. không được sửa đổi !";
                    lbtXoa.Visible = false;
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
    }
}
