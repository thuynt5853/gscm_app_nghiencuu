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

namespace WEB.GSTP.Danhmuc.CanBoToaAn
{
    public partial class Capnhat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");    
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropToaAn();
                    LoadDropChucDanh();
                    LoadDropChucVu();
                    btnBietPhai.Visible = false;
                    if (Request["cb"] != null)
                    {
                        decimal cbID = Convert.ToDecimal(Request["cb"].ToString());
                        btnBietPhai.Visible = true;
                        hddCbID.Value = cbID.ToString();
                        LoadCanBoInfo(cbID);
                    }
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Load_Data();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void Load_Data()
        {
            decimal cbID = 0;
            if(Request["cb"]!=null)
            {
                cbID = Convert.ToDecimal(Request["cb"].ToString());
            }
            DM_CANBO_BL CanBoBL = new DM_CANBO_BL();
            DataTable oDT = CanBoBL.DM_CANBO_BIETPHAI_SEARCH(cbID);
            if (oDT != null)
            {
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }

        private void LoadCanBoInfo(decimal cbID)
        {
            try
            {
                DM_CANBO dmCanBo = dt.DM_CANBO.Where(x => x.ID == cbID).FirstOrDefault<DM_CANBO>();
                if (dmCanBo != null)
                {
                    DropToaAn.SelectedValue = dmCanBo.TOAANID.ToString();
                    txtMaCanBo.Text = dmCanBo.MACANBO;
                    txtHoten.Text = dmCanBo.HOTEN;
                    txtDiaChi.Text = dmCanBo.DIACHI;
                    txtCMND.Text = dmCanBo.SOCMND;
                    txtNgaySinh.Text = dmCanBo.NGAYSINH == null ? "" : Convert.ToDateTime(dmCanBo.NGAYSINH).ToString("dd/MM/yyyy");
                    if (dmCanBo.GIOITINH + "" != "")
                    {
                        ddlGioiTinh.SelectedValue = dmCanBo.GIOITINH.ToString();
                    }
                    txtDienThoai.Text = dmCanBo.SODIENTHOAI;
                    DropChucDanh.SelectedValue = dmCanBo.CHUCDANHID.ToString();
                    DropChucVu.SelectedValue = dmCanBo.CHUCVUID.ToString();
                    txtNgayNhanCT.Text = dmCanBo.NGAYNHANCONGTAC == null ? "" : Convert.ToDateTime(dmCanBo.NGAYNHANCONGTAC).ToString("dd/MM/yyyy");
                    chkHoiDong.Checked = string.IsNullOrEmpty(dmCanBo.ISHOIDONG + "") ? false : Convert.ToBoolean(dmCanBo.ISHOIDONG);
                    ddlTinhtrang.SelectedValue = string.IsNullOrEmpty(dmCanBo.HIEULUC + "") ? "0" : dmCanBo.HIEULUC.ToString();

                    if (dmCanBo.NGAYBONHIEM != null) txtBonhiemTungay.Text = ((DateTime)dmCanBo.NGAYBONHIEM).ToString("dd/MM/yyyy", cul);
                    if (dmCanBo.NGAYKETTHUC != null) txtBonhiemDenngay.Text = ((DateTime)dmCanBo.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);

                    chkDansu.Checked = dmCanBo.ISDANSU == 1 ? true : false;
                    chkHinhsu.Checked = dmCanBo.ISHINHSU == 1 ? true : false;
                    chkHNGD.Checked = dmCanBo.ISHNGD == 1 ? true : false;
                    chkKDTM.Checked = dmCanBo.ISKDTM == 1 ? true : false;
                    chkLaodong.Checked = dmCanBo.ISLAODONG == 1 ? true : false;
                    chkHanhchinh.Checked = dmCanBo.ISHANHCHINH == 1 ? true : false;
                    txt_GQD_ThamPhan.Text= dmCanBo.NGAY_GQD == null ? "" : Convert.ToDateTime(dmCanBo.NGAY_GQD).ToString("dd/MM/yyyy");
                    chkPhasan.Checked = dmCanBo.ISPHASAN == 1 ? true : false;
                    chkXLHC.Checked = dmCanBo.ISBPXLHC == 1 ? true : false;
                    ddlGQD.SelectedValue=Convert.ToString(dmCanBo.TRANGTHAI_XETXU);
                    LoadPhongban();
                    if (dmCanBo.PHONGBANID != null)
                        ddlPhongban.SelectedValue = dmCanBo.PHONGBANID.ToString();
                    LoadPhongban_sub();
                    if (dmCanBo.PHONGBANID_SUB != null)
                        ddlPhongban_sub.SelectedValue = dmCanBo.PHONGBANID_SUB.ToString();

                }
            }catch(Exception ex) { }
        }
        private void LoadDropToaAn()
        {
            DropToaAn.Items.Clear();
            decimal DonViLogin = 0;
            if (Session[ENUM_SESSION.SESSION_DONVIID] != null)
            {
                DonViLogin = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            }
            if (DonViLogin != 1)
            {
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViLogin).FirstOrDefault();
                DropToaAn.Items.Add(new ListItem(oT.MA_TEN, oT.ID.ToString()));
            }
            else
            {
                DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                DropToaAn.DataSource = oBL.DM_TOAAN_GETBY(DonViLogin);
                DropToaAn.DataTextField = "arrTEN";
                DropToaAn.DataValueField = "ID";
                DropToaAn.DataBind();
            }
            LoadPhongban();
            LoadPhongban_sub();
        }
       
        private void LoadPhongban()
        {
             ddlPhongban.Items.Clear();
            decimal VTOAANID = Convert.ToDecimal(DropToaAn.SelectedValue);
            DM_TOAAN obta = dt.DM_TOAAN.Where(x => x.ID == VTOAANID).FirstOrDefault<DM_TOAAN>();
            if (obta.LOAITOA == "CAPTINH")
            {
                ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == null && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
                //List<DM_PHONGBAN> ilspb=dt.DM_PHONGBAN.Where(x => x.TOAANID == null && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
            }
            else
            {
                ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == VTOAANID && x.CAPCHAID == 0 && x.HIEULUC == 1).ToList();
            }
            ddlPhongban.DataTextField = "TENPHONGBAN";
            ddlPhongban.DataValueField = "ID";
            ddlPhongban.DataBind();
            ddlPhongban.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            //decimal IDToaAn = Convert.ToDecimal(DropToaAn.SelectedValue);
            //ddlPhongban.Items.Clear();
            //ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == IDToaAn).OrderBy(x=>x.TENPHONGBAN).ToList();
            //ddlPhongban.DataTextField = "TENPHONGBAN";
            //ddlPhongban.DataValueField = "ID";
            //ddlPhongban.DataBind();
            //ddlPhongban.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        private void LoadPhongban_sub()
        {
            decimal V_CAPCHAID = 0;
            decimal VTOAANID = Convert.ToDecimal(DropToaAn.SelectedValue);
            ddlPhongban_sub.Items.Clear();
            if (ddlPhongban.SelectedValue != "0")
            {
                V_CAPCHAID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                ddlPhongban_sub.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == VTOAANID && x.CAPCHAID == V_CAPCHAID).ToList();
                ddlPhongban_sub.DataTextField = "TENPHONGBAN";
                ddlPhongban_sub.DataValueField = "ID";
                ddlPhongban_sub.DataBind();
                ddlPhongban_sub.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
            {
                ddlPhongban_sub.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }

        public void LoadDropChucDanh()
        {
            DropChucDanh.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dmChucDanh = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.CHUCDANH);
            if (dmChucDanh != null && dmChucDanh.Rows.Count > 0)
            {
                DropChucDanh.DataSource = dmChucDanh;
                DropChucDanh.DataTextField = "TEN";
                DropChucDanh.DataValueField = "ID";
                DropChucDanh.DataBind();
            }
            DropChucDanh.Items.Insert(0, new ListItem("--", "0"));
        }
        public void LoadDropChucVu()
        {
            DropChucVu.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dmChucVu = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.CHUCVU);
            if (dmChucVu != null && dmChucVu.Rows.Count > 0)
            {
                DropChucVu.DataSource = dmChucVu;
                DropChucVu.DataTextField = "TEN";
                DropChucVu.DataValueField = "ID";
                DropChucVu.DataBind();
            }
            DropChucVu.Items.Insert(0, new ListItem("--", "0"));
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            decimal cbID = Convert.ToDecimal(hddCbID.Value);
            string MaCanBo = txtMaCanBo.Text.Trim();
            if (!ValidateData(MaCanBo, cbID))
            {
                return;
            }
            bool isNew = false;
            DM_CANBO dmCanBo = dt.DM_CANBO.Where(x => x.ID == cbID).FirstOrDefault<DM_CANBO>();
            if (dmCanBo == null)
            {
                isNew = true;
                dmCanBo = new DM_CANBO();
                dmCanBo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                dmCanBo.NGAYTAO = DateTime.Now;
            }
            else
            {
                dmCanBo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                dmCanBo.NGAYSUA = DateTime.Now;
            }
            dmCanBo.TOAANID = Convert.ToDecimal(DropToaAn.SelectedValue);
            dmCanBo.PHONGBANID= Convert.ToDecimal(ddlPhongban.SelectedValue);
            dmCanBo.PHONGBANID_SUB = Convert.ToDecimal(ddlPhongban_sub.SelectedValue);
            dmCanBo.MACANBO = MaCanBo;
            dmCanBo.HOTEN = txtHoten.Text.Trim();
            dmCanBo.SOCMND = txtCMND.Text.Trim();
            dmCanBo.ISHOIDONG = chkHoiDong.Checked ? 1 : 0;
            dmCanBo.HIEULUC = Convert.ToDecimal(ddlTinhtrang.SelectedValue);
            dmCanBo.CHUCDANHID = Convert.ToDecimal(DropChucDanh.SelectedValue);
            dmCanBo.CHUCVUID = Convert.ToDecimal(DropChucVu.SelectedValue);
            dmCanBo.DIACHI = txtDiaChi.Text.Trim();
            dmCanBo.NGAYNHANCONGTAC = (String.IsNullOrEmpty(txtNgayNhanCT.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhanCT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dmCanBo.NGAYSINH = (String.IsNullOrEmpty(txtNgaySinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dmCanBo.GIOITINH = Convert.ToDecimal(ddlGioiTinh.SelectedValue);
            dmCanBo.NGAYBONHIEM = (String.IsNullOrEmpty(txtBonhiemTungay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtBonhiemTungay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dmCanBo.NGAYKETTHUC = (String.IsNullOrEmpty(txtBonhiemDenngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtBonhiemDenngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            dmCanBo.ISDANSU = chkDansu.Checked ? 1 : 0;
            dmCanBo.ISHINHSU = chkHinhsu.Checked ? 1 : 0;
            dmCanBo.ISHNGD = chkHNGD.Checked ? 1 : 0;
            dmCanBo.ISKDTM = chkKDTM.Checked ? 1 : 0;
            dmCanBo.ISLAODONG = chkLaodong.Checked ? 1 : 0;
            dmCanBo.ISHANHCHINH = chkHanhchinh.Checked ? 1 : 0;

            dmCanBo.ISPHASAN = chkPhasan.Checked ? 1 : 0;
            dmCanBo.ISBPXLHC = chkXLHC.Checked ? 1 : 0;
            dmCanBo.NGAY_GQD= (String.IsNullOrEmpty(txt_GQD_ThamPhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txt_GQD_ThamPhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dmCanBo.SODIENTHOAI = txtDienThoai.Text.Trim();
            dmCanBo.TRANGTHAI_XETXU=Convert.ToInt32(ddlGQD.SelectedValue);
            if (isNew)
            {
                dt.DM_CANBO.Add(dmCanBo);
            }
            dt.SaveChanges();
            Response.Redirect("Danhsach.aspx");
        }
        private bool ValidateData(string MaCanBo, decimal CbID)
        {
            int lengthmaCB = MaCanBo.Length;
            if (lengthmaCB == 0 || lengthmaCB > 50)
            {
                lbthongbao.Text = "Mã cán bộ không được trống hoặc quá 50 ký tự. Hãy nhập lại!";
                txtMaCanBo.Focus();
                return false;
            }
            // kiểm tra trùng mã
            DM_CANBO cb = dt.DM_CANBO.Where(x => x.MACANBO.ToLower() == MaCanBo.ToLower()).FirstOrDefault<DM_CANBO>();
            if (cb != null)
            {
                if (CbID != cb.ID)
                {
                    lbthongbao.Text = "Mã cán bộ này đã tồn tại. Hãy nhập lại!";
                    txtMaCanBo.Focus();
                    return false;
                }
            }
            //
            int lengthTenCB = txtHoten.Text.Trim().Length;
            if (lengthTenCB == 0 || lengthTenCB > 250)
            {
                lbthongbao.Text = "Tên cán bộ không được trống hoặc quá 250 ký tự. Hãy nhập lại!";
                txtHoten.Focus();
                return false;
            }
            if (txtDiaChi.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Địa chỉ không được quá 250 ký tự. Hãy nhập lại!";
                txtDiaChi.Focus();
                return false;
            }
            if (txtCMND.Text.Trim().Length > 50)
            {
                lbthongbao.Text = "Số CMND không được quá 50 ký tự. Hãy nhập lại!";
                txtCMND.Focus();
                return false;
            }
            if (txtNgaySinh.Text.Trim() != "" && !Cls_Comon.IsValidDate(txtNgaySinh.Text.Trim()))
            {
                lbthongbao.Text = "Ngày sinh phải là kiểu ngày tháng (dd/MM/yyyy). Hãy nhập lại!";
                txtNgaySinh.Focus();
                return false;
            }
            if (txtDienThoai.Text.Trim().Length > 50)
            {
                lbthongbao.Text = "Số điện thoại không được quá 50 ký tự. Hãy nhập lại!";
                txtDienThoai.Focus();
                return false;
            }
            if (txtNgayNhanCT.Text.Trim() != "" && !Cls_Comon.IsValidDate(txtNgayNhanCT.Text.Trim()))
            {
                lbthongbao.Text = "Ngày nhận công tác phải là kiểu ngày tháng (dd/MM/yyyy). Hãy nhập lại!";
                txtNgayNhanCT.Focus();
                return false;
            }
            if (txtBonhiemTungay.Text.Trim() == "" && !Cls_Comon.IsValidDate(txtBonhiemTungay.Text.Trim()))
            {
                lbthongbao.Text = "Ngày bắt đầu bổ nhiệm chưa nhập hoặc không hợp lệ !";
                txtBonhiemTungay.Focus();
                return false;
            }
            if (txtBonhiemDenngay.Text.Trim() == "" && !Cls_Comon.IsValidDate(txtBonhiemDenngay.Text.Trim()))
            {
                lbthongbao.Text = "Ngày kết thúc bổ nhiệm chưa nhập hoặc không hợp lệ !";
                txtBonhiemDenngay.Focus();
                return false;
            }
            return true;
        }
        protected void lblquaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
        protected void ddlPhongban_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPhongban_sub();
        }
        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPhongban();
            LoadPhongban_sub();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ID = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    DM_CANBO_BIETPHAI bietPhai = dt.DM_CANBO_BIETPHAI.Where(x => x.ID == ID).FirstOrDefault();
                    hddBietPhaiID.Value = ID.ToString();

                    break;
                case "Xoa":
                    DM_CANBO_BIETPHAI bp = dt.DM_CANBO_BIETPHAI.Where(x => x.ID == ID).FirstOrDefault();
                    if (bp != null)
                    {
                        dt.DM_CANBO_BIETPHAI.Remove(bp);
                        dt.SaveChanges();

                    }
                    Load_Data();
                    lbThongbaoBP.Text = "Xóa thành công!";
                    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                }
            }
            catch (Exception ex) { lbThongbaoBP.Text = ex.Message; }
        }
    }
}