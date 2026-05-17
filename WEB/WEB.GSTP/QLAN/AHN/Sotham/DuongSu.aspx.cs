using BL.GSTP;
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

namespace WEB.GSTP.QLAN.AHN.Sotham
{
    public partial class DuongSu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdChonDuongSu, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id);
                    AHN_DON oT = dt.AHN_DON.Where(x => x.ID == ID).FirstOrDefault();
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdChonDuongSu, false);
                        return;
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            //Load quốc tịch
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
            ddlND_Quoctich.DataSource = dtQuoctich;
            ddlND_Quoctich.DataTextField = "TEN";
            ddlND_Quoctich.DataValueField = "ID";
            ddlND_Quoctich.DataBind();

            ddlTucachTotung.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTOTUNG_DS);
            ddlTucachTotung.DataTextField = "TEN";
            ddlTucachTotung.DataValueField = "MA";
            ddlTucachTotung.DataBind();
        }
        private void ResetControls()
        {
            txtTennguyendon.Text = "";
            txtND_CMND.Text = "";
            txtND_Ngaysinh.Text = "";
            txtND_Thangsinh.Text = "";
            txtND_Namsinh.Text = "";
            txtND_HKTT.Text = txtND_HKTT_Chitiet.Text = "";
            txtND_TTMA.Text = txtND_TTChitiet.Text = "";
            txtND_NDD_Ten.Text = "";
            txtND_NDD_Diachi.Text = "";
            hddND_HKTTID.Value = hddND_NDD_DCID.Value = hdd_ND_TramtruID.Value = "0";
            hddid.Value = "0";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }
        private bool CheckValid()
        {
            if (txtTennguyendon.Text == "")
            {
                lbthongbao.Text = "Chưa nhập tên đương sự";
                return false;
            }
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                if (txtND_Namsinh.Text == "")
                {
                    lbthongbao.Text = "Chưa nhập năm sinh";
                    return false;
                }
                if (hddND_HKTTID.Value == "")
                {
                    lbthongbao.Text = "Chưa chọn nơi đăng ký HKTT";
                    return false;
                }
                if (hdd_ND_TramtruID.Value == "")
                {
                    lbthongbao.Text = "Chưa chọn nơi đăng ký tạm trú";
                    return false;
                }
            }
            return true;
        }
        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                txtND_Thangsinh.Text = d.Month.ToString();
                txtND_Namsinh.Text = d.Year.ToString();
                txtND_HKTT.Focus();
            }
        }
        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
        }
        protected void cmdChonDuongSu_Click(object sender, EventArgs e)
        {
            foreach (DataGridItem oItem in dgList.Items)
            {
                string strID = oItem.Cells[0].Text;
                decimal DSID = Convert.ToDecimal(strID);
                CheckBox chkSoTham = (CheckBox)oItem.FindControl("chkSoTham");
                AHN_DON_DUONGSU oT = dt.AHN_DON_DUONGSU.Where(x => x.ID == DSID).FirstOrDefault();
                oT.ISSOTHAM = chkSoTham.Checked == true ? 1 : 0;
                dt.SaveChanges();
            }
            lbthongbao.Text = "Hoàn thành lưu đương sự tham gia thụ lý Sơ thẩm !";
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                AHN_DON_DUONGSU oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new AHN_DON_DUONGSU();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AHN_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.TENDUONGSU = txtTennguyendon.Text;
                oND.ISDAIDIEN = 0;
                oND.TUCACHTOTUNG_MA = ddlTucachTotung.SelectedValue;
                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                oND.SOCMND = txtND_CMND.Text;
                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                oND.TAMTRUID = hdd_ND_TramtruID.Value == "" ? 0 : Convert.ToDecimal(hdd_ND_TramtruID.Value);
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.HKTTID = hddND_HKTTID.Value == "" ? 0 : Convert.ToDecimal(hddND_HKTTID.Value);
                oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;
                oND.THANGSINH = txtND_Thangsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Thangsinh.Text);
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.NGUOIDAIDIEN = txtND_NDD_Ten.Text;
                oND.CHUCVU = txtND_NDD_Chucvu.Text;
                if (txtND_NDD_Diachi.Text.Trim() == "")
                    oND.NDD_DIACHIID = 0;
                else
                    oND.NDD_DIACHIID = hddND_NDD_DCID.Value == "" ? 0 : Convert.ToDecimal(hddND_NDD_DCID.Value);
                oND.NDD_DIACHICHITIET = txtND_NDD_Diachichitiet.Text;
                oND.ISSOTHAM = 1;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    
                    // an hn
                    if (oND.TOA_GIAIQUYET_ID == null)
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    
                    dt.AHN_DON_DUONGSU.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    dt.SaveChanges();
                }
                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        public void LoadGrid()
        {
            AHN_DON_DUONGSU_BL oBL = new AHN_DON_DUONGSU_BL();
            string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.AHN_SOTHAM_DUONGSU_GETBY(ID, 0);

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
            AHN_DON_DUONGSU oND = dt.AHN_DON_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            if (oND.ISDAIDIEN == 1)
            {
                lbthongbao.Text = "Không được xóa đương sự đại diện.";
                return;
            }
            if (oND.ISDON == 1 || oND.ISPHUCTHAM == 1)
            {
                lbthongbao.Text = "Đương sự được lưu trong đơn khởi kiện hoặc đã được thụ lý phúc thẩm, không được phép xóa !.";
                return;
            }
            dt.AHN_DON_DUONGSU.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            AHN_DON_DUONGSU oND = dt.AHN_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            txtTennguyendon.Text = oND.TENDUONGSU;
            ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();
            txtND_CMND.Text = oND.SOCMND;
            ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
            ddlTucachTotung.SelectedValue = oND.TUCACHTOTUNG_MA;
            if (oND.TAMTRUID != null) txtND_TTMA.Text = oHCBL.GetTextByID((decimal)oND.TAMTRUID);
            hdd_ND_TramtruID.Value = oND.TAMTRUID.ToString();
            txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
            if (oND.HKTTID != null) txtND_HKTT.Text = oHCBL.GetTextByID((decimal)oND.HKTTID);
            hddND_HKTTID.Value = oND.HKTTID.ToString();
            txtND_HKTT_Chitiet.Text = oND.HKTTCHITIET;
            if (oND.NGAYSINH != DateTime.MinValue) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
            txtND_Thangsinh.Text = oND.THANGSINH == 0 ? "" : oND.THANGSINH.ToString();
            txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            txtND_NDD_Ten.Text = oND.NGUOIDAIDIEN;
            txtND_NDD_Chucvu.Text = oND.CHUCVU;
            if (oND.NDD_DIACHIID != null) txtND_NDD_Diachi.Text = oHCBL.GetTextByID((decimal)oND.NDD_DIACHIID);
            hddND_NDD_DCID.Value = oND.NDD_DIACHIID.ToString();
            txtND_NDD_Diachichitiet.Text = oND.NDD_DIACHICHITIET;
            if (ddlLoaiNguyendon.SelectedValue == "1")
            {
                pnNDCanhan.Visible = true;
                pnNDTochuc.Visible = false;
            }
            else
            {
                pnNDCanhan.Visible = false;
                pnNDTochuc.Visible = true;
            }
            if (oND.ISDAIDIEN == 1)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                lbthongbao.Text = "Bạn không được sửa nguyên đơn hoặc bị đơn đại diện!";
                return;
            }
            else
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            }
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
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
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

    }
}