using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.AHS;
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

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class NguoiThamgiaTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public string NgayHoSo;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    LoadTGTTFromHoSoVuAn();
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id);
                    AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        return;
                    }
                    NgayHoSo = ((DateTime)oT.NGAYGIAO).ToString("dd/MM/yyyy", cul);
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        Cls_Comon.SetButton(cmdUpdate, false);
                        return;
                    }
                }
            }
            catch (Exception ex) { 
                lbthongbao.Text = ex.Message;
                logger.Error("loi xay ra: " + ex);
            }
        }
        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlNgheNghiep.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NGHENGHIEP);
            ddlNgheNghiep.DataTextField = "TEN";
            ddlNgheNghiep.DataValueField = "ID";
            ddlNgheNghiep.DataBind();
            ddlNgheNghiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTHS);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    chkTuCach.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }
        private void LoadTGTTFromHoSoVuAn()
        {
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
            AHS_SOTHAM_BL bl = new AHS_SOTHAM_BL();
            chkListTGTT.DataSource = bl.AHS_NTGTT_GetCheckList(VuAnID, "HOSO");
            chkListTGTT.DataTextField = "arrTEN";
            chkListTGTT.DataValueField = "ID";
            chkListTGTT.DataBind();
        }
        private void ResetControls()
        {
            txtHoten.Text = txtDiaChi.Text = txtDiaChiChitiet.Text = lbthongbao.Text = "";
            txtNgaysinh.Text = txtThangsinh.Text = txtNamsinh.Text = "";
            ddlGioitinh.SelectedIndex = ddlNgheNghiep.SelectedIndex = 0;
            txtChucvu.Text = txtNgaythamgia.Text = txtNgayketthuc.Text = "";
            hddid.Value = "0";
            foreach (ListItem item in chkTuCach.Items)
            {
                item.Selected = false;
            }
        }
        private bool CheckValid()
        {
            if (txtHoten.Text == "")
            {
                lbthongbao.Text = "Bạn chưa nhập tên người tham gia tố tụng!";
                txtHoten.Focus();
                return false;
            }
            if (txtHoten.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Tên người tham gia tố tụng không nhập quá 250 ký tự. Hãy nhập lại!";
                txtHoten.Focus();
                return false;
            }
            if (txtDiaChi.Text == "")
            {
                lbthongbao.Text = "Bạn chưa nhập địa chỉ!";
                txtDiaChi.Focus();
                return false;
            }
            if (txtDiaChiChitiet.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Địa chỉ chi tiết không quá 250 ký tự. Hãy nhập lại!";
                txtDiaChiChitiet.Focus();
                return false;
            }

            if (txtNgaysinh.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgaysinh.Text) == false)
            {
                lbthongbao.Text = "Ngày sinh không hợp lệ!";
                txtNgaysinh.Focus();
                return false;
            }
            if (txtThangsinh.Text.Trim() != "" && Cls_Comon.IntValid(txtThangsinh.Text) == 0)
            {
                lbthongbao.Text = "Tháng sinh phải là kiểu số nguyên dương!";
                txtThangsinh.Focus();
                return false;
            }
            if (txtNamsinh.Text.Trim() != "" && Cls_Comon.IntValid(txtNamsinh.Text) == 0)
            {
                lbthongbao.Text = "Năm sinh phải là kiểu số nguyên dương!";
                txtNamsinh.Focus();
                return false;
            }
            if (txtChucvu.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Chức vụ không quá 250 ký tự. Hãy nhập lại!";
                txtChucvu.Focus();
                return false;
            }
            if (txtNgaythamgia.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgaythamgia.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày tham gia theo định dạng (dd/MM/yyyy).";
                txtNgaythamgia.Focus();
                return false;
            }
            if (txtNgayketthuc.Text.Trim() != "" && Cls_Comon.IsValidDate(txtNgayketthuc.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày kết thúc theo định dạng (dd/MM/yyyy).";
                txtNgayketthuc.Focus();
                return false;
            }


            int countSelect = 0;
            foreach (ListItem item in chkTuCach.Items)
            {
                if (item.Selected)
                {
                    countSelect++;
                }
            }
            if (countSelect == 0)
            {
                lbthongbao.Text = "Bạn chưa chọn tư cách tham gia tố tụng. Hãy nhập lại!";
                return false;
            }
            return true;
        }
        protected void txtNgaysinh_TextChanged(object sender, EventArgs e)
        {
            try
            {
                DateTime d = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (d != DateTime.MinValue)
                {
                    txtThangsinh.Text = d.Month.ToString();
                    txtNamsinh.Text = d.Year.ToString();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + ""), ID = string.IsNullOrEmpty(hddid.Value) ? 0 : Convert.ToDecimal(hddid.Value);
                bool isNew = false;
                AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
                if (oND == null)
                {
                    isNew = true;
                    oND = new AHS_NGUOITHAMGIATOTUNG();
                }
                oND.VUANID = VuAnID;
                oND.HOTEN = txtHoten.Text.Trim();
                oND.DIACHIID = string.IsNullOrEmpty(hddDiaChiID.Value + "") ? 0 : Convert.ToDecimal(hddDiaChiID.Value);
                oND.DIACHICHITIET = txtDiaChiChitiet.Text.Trim();
                oND.NGAYSINH = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.THANGSINH = txtThangsinh.Text == "" ? 0 : Convert.ToDecimal(txtThangsinh.Text);
                oND.NAMSINH = txtNamsinh.Text == "" ? 0 : Convert.ToDecimal(txtNamsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);
                oND.NGHENGHIEPID = Convert.ToDecimal(ddlNgheNghiep.SelectedValue);
                oND.CHUCVU = txtChucvu.Text;
                oND.NGAYTHAMGIA = (String.IsNullOrEmpty(txtNgaythamgia.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythamgia.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKETTHUC = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);


                // Đây là giai đoạn sơ thẩm nên ISSOTHAM= 1
                oND.ISSOTHAM = 1;
                if (isNew)
                {
                    // insert toa_gq_id
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_NGUOITHAMGIATOTUNG.Add(oND);
                }
                dt.SaveChanges();
                // update AHS_NGUOITHAMGIATOTUNG_TUCACH
                UpdateTuCach(oND.ID);
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
        private void UpdateTuCach(Decimal NguoiThamGiaID)
        {
            AHS_NGUOITHAMGIATOTUNG_TUCACH obj = null;
            // lấy ra tất cả các tư cách cũ
            string StrTuCachNguoiThamGia = "|";
            if (NguoiThamGiaID > 0)
            {
                List<AHS_NGUOITHAMGIATOTUNG_TUCACH> lst = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == NguoiThamGiaID).ToList<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                if (lst != null && lst.Count > 0)
                {
                    foreach (AHS_NGUOITHAMGIATOTUNG_TUCACH item in lst)
                        StrTuCachNguoiThamGia += item.TUCACHID + "|";
                }
            }
            // Phát hiện tư cách mới thì thêm, trùng với tư cách cũ thì loại khỏi danh sách
            Boolean IsNew = false;
            foreach (ListItem item in chkTuCach.Items)
            {
                IsNew = false;
                if (item.Selected)
                {
                    if (StrTuCachNguoiThamGia == "|")
                        IsNew = true;
                    else
                    {
                        if (StrTuCachNguoiThamGia.Contains("|" + item.Value + "|"))
                        {
                            StrTuCachNguoiThamGia = StrTuCachNguoiThamGia.Replace("|" + item.Value + "|", "|");
                            IsNew = false;
                        }
                        else
                            IsNew = true;
                    }
                    if (IsNew)
                    {
                        obj = new AHS_NGUOITHAMGIATOTUNG_TUCACH();
                        obj.NGUOIID = NguoiThamGiaID;
                        obj.TUCACHID = Convert.ToDecimal(item.Value);
                        dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Add(obj);
                        dt.SaveChanges();
                    }
                }
            }
            // Tư cách còn lại cần phải xóa
            if (StrTuCachNguoiThamGia != "|")
            {
                String[] arr = StrTuCachNguoiThamGia.Split('|');
                foreach (String item in arr)
                {
                    if (item.Length > 0)
                    {
                        AHS_NGUOITHAMGIATOTUNG_TUCACH oT = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.ID == Convert.ToDecimal(item)).FirstOrDefault();
                        dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Remove(oT);
                        dt.SaveChanges();
                    }
                }
            }
        }
        public void LoadGrid()
        {
            lbthongbao.Text = "";
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_SOTHAM_BL objBL = new AHS_SOTHAM_BL();
            int pageindex = Convert.ToInt32(hddPageIndex.Value), page_size = Convert.ToInt32(hddPageSize.Value);
            DataTable tbl = objBL.AHS_NTGTT_GetByVuAnID(VuAnID, "SOTHAM", pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(tbl.Rows[0]["CountAll"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgList.PageSize = page_size;
                dgList.DataSource = tbl;
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
            AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                dt.AHS_NGUOITHAMGIATOTUNG.Remove(oND);
                List<AHS_NGUOITHAMGIATOTUNG_TUCACH> lst = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == id).ToList<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
                if (lst != null && lst.Count > 0)
                { dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.RemoveRange(lst); }
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
            AHS_NGUOITHAMGIATOTUNG oND = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                txtHoten.Text = oND.HOTEN;
                txtDiaChi.Text = string.IsNullOrEmpty(oND.DIACHIID + "") ? "" : oHCBL.GetTextByID((decimal)oND.DIACHIID);
                txtDiaChiChitiet.Text = oND.DIACHICHITIET;
                ddlGioitinh.SelectedValue = oND.GIOITINH.ToString();
                txtNgaysinh.Text = string.IsNullOrEmpty(oND.NGAYSINH + "") ? "" : ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtThangsinh.Text = oND.THANGSINH == 0 ? "" : oND.THANGSINH.ToString();
                txtNamsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
                ddlNgheNghiep.SelectedValue = oND.NGHENGHIEPID.ToString();
                txtChucvu.Text = oND.CHUCVU;
                txtNgaythamgia.Text = string.IsNullOrEmpty(oND.NGAYTHAMGIA + "") ? "" : ((DateTime)oND.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);
                txtNgayketthuc.Text = string.IsNullOrEmpty(oND.NGAYKETTHUC + "") ? "" : ((DateTime)oND.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);


                LoadTuCach(oND.ID);
            }
        }
        private void LoadTuCach(Decimal NguoiThamGiaID)
        {
            List<AHS_NGUOITHAMGIATOTUNG_TUCACH> lst = dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Where(x => x.NGUOIID == NguoiThamGiaID).ToList<AHS_NGUOITHAMGIATOTUNG_TUCACH>();
            if (lst != null && lst.Count > 0)
            {
                foreach (ListItem item in chkTuCach.Items)
                {
                    item.Selected = false;
                    foreach (AHS_NGUOITHAMGIATOTUNG_TUCACH obj in lst)
                    {
                        if (Convert.ToDecimal(item.Value) == obj.TUCACHID)
                            item.Selected = true;
                    }
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
                        if (oPer.XOA == false)
                        {
                            lbthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        decimal VuAnID = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
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
        protected void rdbLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            lbthongbao.Text = lblMsgChon.Text = "";
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
                    AHS_NGUOITHAMGIATOTUNG oD = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.ID == NID).FirstOrDefault();
                    if (oD != null)
                    {
                        oD.ISSOTHAM = 1;
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