using BL.GSTP;
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

namespace WEB.GSTP.QLAN.XLHC.Phuctham
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
                    LoadTGTTFromDonKK();
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdChonTGTT, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
                    //Kiểm tra thẩm phán giải quyết đơn             
                    decimal DONID = Convert.ToDecimal(current_id);
                    XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    List<XLHC_PHUCTHAM_THULY> lstCount = dt.XLHC_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
                    if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdChonTGTT, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    List<XLHC_DON_THAMPHAN> lstTP = dt.XLHC_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
                    if (lstTP.Count == 0)
                    {
                        lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdChonTGTT, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdChonTGTT, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdChonTGTT, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                     
                    decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                        .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                        .FirstOrDefault();
                    if (chuyenNhanAn != null)
                    {
                        // DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault<DM_TOAAN>();
                        // lstErr.Text = "Án đã chuyển đến " + oTA.TEN + ". Không thể cập nhật!";
                        lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }

                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                }
            }
            catch (Exception ex) { 
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
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
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                
                decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                XLHC_CHUYEN_NHAN_AN chuyenNhanAn = dt.XLHC_CHUYEN_NHAN_AN
                    .Where(x => x.VUANID == DONID && x.TOACHUYENID == TOAANID).OrderByDescending(x => x.ID)
                    .FirstOrDefault();
                if (chuyenNhanAn != null)
                {
                    // DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault<DM_TOAAN>();
                    // lstErr.Text = "Án đã chuyển đến " + oTA.TEN + ". Không thể cập nhật!";
                    lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                    // lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }

                string toagiaiquyetID = e.Item.Cells[8].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
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

        private void LoadTGTTFromDonKK()
        {
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            XLHC_DON_BL oBL = new XLHC_DON_BL();
            chkListTGTT.DataSource = oBL.XLHC_DON_TGTT_GETLIST(DONID);
            chkListTGTT.DataTextField = "arrTEN";
            chkListTGTT.DataValueField = "ID";
            chkListTGTT.DataBind();
        }
        private void ResetControls()
        {
            lbthongbao.Text = "";
            txtHoten.Text = "";
            txtNDD_Hoten.Text = "";
            txtND_Ngaysinh.Text = "";
            txtND_Namsinh.Text = "";
            txtND_HKTT_Chitiet.Text = "";
            txtND_TTChitiet.Text = "";
            txtNgaythamgia.Text = "";
            txtDienThoai.Text = txtFax.Text = txtEmail.Text = "";
            hddid.Value = "0";
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
                lbthongbao.Text = "Chưa nhập họ tên người tham gia tố tụng.";
                txtHoten.Focus();
                return false;
            }
            else if (txtHoten.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Họ tên người tham gia tố tụng không quá 250 ký tự.";
                txtHoten.Focus();
                return false;
            }
            if (txtNgaythamgia.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgaythamgia.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày tham gia theo định dạng (dd/MM/yyyy).";
                txtNgaythamgia.Focus();
                return false;
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
            if (txtND_Ngaysinh.Text.Trim() != "" && Cls_Comon.IsValidDate(txtND_Ngaysinh.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy).";
                txtND_Ngaysinh.Focus();
                return false;
            }
            

            if (txtNDD_Hoten.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Người đại diện không nhập quá 250 ký tự. Hãy nhập lại!";
                txtNDD_Hoten.Focus();
                return false;
            }
            return true;
        }
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            try
            {
                DateTime d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (d != DateTime.MinValue)
                {
                    txtND_Namsinh.Text = d.Year.ToString();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                XLHC_PHUCTHAM_THAMGIATOTUNG oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new XLHC_PHUCTHAM_THAMGIATOTUNG();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.XLHC_PHUCTHAM_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.HOTEN = txtHoten.Text;
                oND.TUCACHTGTTID = ddlTucachTGTT.SelectedValue;
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
                oND.NGAYSINH = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.NGUOIDAIDIEN = txtNDD_Hoten.Text;
                oND.DIENTHOAI = txtDienThoai.Text;
                oND.FAX = txtFax.Text;
                oND.EMAIL = txtEmail.Text;
                oND.NGAYTHAMGIA = (String.IsNullOrEmpty(txtNgaythamgia.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythamgia.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.XLHC_PHUCTHAM_THAMGIATOTUNG.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
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
            lbthongbao.Text = "";
            XLHC_PHUCTHAM_BL oBL = new XLHC_PHUCTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.XLHC_PHUCTHAM_TGTT_GETLIST(ID);

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
            XLHC_PHUCTHAM_THAMGIATOTUNG oND = dt.XLHC_PHUCTHAM_THAMGIATOTUNG.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                dt.XLHC_PHUCTHAM_THAMGIATOTUNG.Remove(oND);
                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Xóa thành công!";
            }
        }
        public void loadedit(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            XLHC_PHUCTHAM_THAMGIATOTUNG oND = dt.XLHC_PHUCTHAM_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                txtHoten.Text = oND.HOTEN;
                ddlTucachTGTT.SelectedValue = oND.TUCACHTGTTID.ToString();
                txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
                txtND_HKTT_Chitiet.Text = oND.HKTTCHITIET;
                if (oND.NGAYSINH != null) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
                txtDienThoai.Text = oND.DIENTHOAI + "";
                txtFax.Text = oND.FAX + "";
                txtEmail.Text = oND.EMAIL + "";
                txtNDD_Hoten.Text = oND.NGUOIDAIDIEN;
                if (oND.NGAYTHAMGIA != null) txtNgaythamgia.Text = ((DateTime)oND.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);
            }
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
                        pnNew.Visible = true;
                        pnChon.Visible = false;
                        rdbLoai.SelectedValue = "0";
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
        protected void rdbLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbLoai.SelectedValue == "0")
            {
                pnNew.Visible = true;
                pnChon.Visible = false;
            }
            else
            {
                pnNew.Visible = false;
                pnChon.Visible = true;
            }
        }
        protected void cmdChonTGTT_Click(object sender, EventArgs e)
        {
            bool flag = false;
            foreach (ListItem oItem in chkListTGTT.Items)
            {
                if (oItem.Selected)
                {
                    flag = true;
                    decimal NID = Convert.ToDecimal(oItem.Value);
                    if (dt.XLHC_PHUCTHAM_THAMGIATOTUNG.Where(x => x.NTGTT_DONKK_ID == NID).ToList().Count == 0)
                    {
                        XLHC_DON_THAMGIATOTUNG oD = dt.XLHC_DON_THAMGIATOTUNG.Where(x => x.ID == NID).FirstOrDefault();
                        XLHC_PHUCTHAM_THAMGIATOTUNG oS = new XLHC_PHUCTHAM_THAMGIATOTUNG();
                        oS.DONID = oD.DONID;
                        oS.HOTEN = oD.HOTEN;
                        oS.TUCACHTGTTID = oD.TUCACHTGTTID;
                        oS.TAMTRUCHITIET = oD.TAMTRUCHITIET;
                        oS.HKTTCHITIET = oD.HKTTCHITIET;
                        oS.NGAYSINH = oD.NGAYSINH;
                        oS.THANGSINH = oD.THANGSINH;
                        oS.NAMSINH = oD.NAMSINH;
                        oS.GIOITINH = oD.GIOITINH;
                        oS.NGUOIDAIDIEN = oD.NGUOIDAIDIEN;
                        oS.CHUCVU = oD.CHUCVU;
                        oS.EMAIL = oD.EMAIL;
                        oS.FAX = oD.FAX;
                        oS.DIENTHOAI = oD.DIENTHOAI;

                        oS.NGAYTHAMGIA = oD.NGAYTHAMGIA;
                        oS.NGAYKETTHUC = oD.NGAYKETTHUC;

                        oS.NGAYTAO = DateTime.Now;
                        oS.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oS.NTGTT_DONKK_ID = oD.ID;
                        oS.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.XLHC_PHUCTHAM_THAMGIATOTUNG.Add(oS);
                        dt.SaveChanges();
                    }
                }
            }
            if (flag)
            {
                lblMsgChon.Text = "Lưu thành công !";
                LoadGrid();
            }
            else
            {
                lblMsgChon.Text = "Chưa chọn người tham gia tố tụng !";
            }
        }
    }
}