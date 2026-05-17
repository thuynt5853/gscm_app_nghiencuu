using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.Hoso.Popup
{
    public partial class pDuongSu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 0,VuAnID = 0;
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
            if (!IsPostBack)
            {
                if (VuAnID>0)
                {
                    LoadCombobox(); 
                    if (Request["bID"] != null)
                        LoadInfo(Convert.ToDecimal(Request["bID"] + ""));
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    //Cls_Comon.SetButton(cmdThemMoi, oPer.TAOMOI);
                    //Cls_Comon.SetButton(cmdUpdate2, oPer.CAPNHAT);
                    //Cls_Comon.SetButton(cmdThemMoi2, oPer.TAOMOI);
                    XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == VuAnID).FirstOrDefault();
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        return;
                    }
                }
                else
                    Response.Redirect("/Login.aspx");
            }
        }

        #region from bi cao
        private void LoadInfo(decimal BiCanID)
        {
            hddID.Value = BiCanID.ToString();
            XLHC_DUONGSU obj = null;
            try
            {
                obj = dt.XLHC_DUONGSU.Where(x => x.ID == BiCanID).SingleOrDefault();
            }
            catch (Exception ex) { obj = null; }

            if (obj != null)
            {

                txtTenBiCan.Text = obj.HOTEN;
                txtCMND.Text = obj.SOCMND;
                if (obj.NGHENGHIEPID > 0)
                    dropNgheNghiep.SelectedValue = obj.NGHENGHIEPID.ToString();

                //-------------------------------------
                if (obj.QUOCTICHID > 0)
                    dropQuocTich.SelectedValue = obj.QUOCTICHID.ToString();
                if (obj.HKTTTINHID != null)
                {
                    ddlThuongTruTinh.SelectedValue = obj.HKTTTINHID.ToString();
                    LoadDropThuongTruHuyen();
                    if (obj.HKTT != null) ddlThuongTruHuyen.SelectedValue = obj.HKTT.ToString();
                }
                if (obj.TAMTRUTINHID != null)
                {
                    ddlNoiSongTinh.SelectedValue = obj.TAMTRUTINHID.ToString();
                    LoadDropNoiSongHuyen();
                    if (obj.TAMTRU != null) ddlNoiSongHuyen.SelectedValue = obj.TAMTRU.ToString();
                }
                txtTamtru_Chitiet.Text = obj.TAMTRUCHITIET;
                txtHKTT_Chitiet.Text = obj.KHTTCHITIET;
                if (obj.NGAYSINH != DateTime.MinValue)
                    txtNgaysinh.Text = ((DateTime)obj.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtNamSinh.Text = obj.NAMSINH + "";

                ddlGioitinh.SelectedValue = obj.GIOITINH.ToString();
                //-------------------------------------
                txtTenKhac.Text = obj.TENKHAC + "";

                if (obj.DANTOCID > 0)
                    dropDanToc.SelectedValue = obj.DANTOCID + "";
                if (obj.TONGIAOID > 0)
                    dropTonGiao.SelectedValue = obj.TONGIAOID + "";

                if (obj.QUOCTICHID > 0)
                    dropQuocTich.SelectedValue = obj.QUOCTICHID + "";
                if (obj.TRINHDOVANHOAID > 0)
                    dropTrinhDoVH.SelectedValue = obj.TRINHDOVANHOAID + "";

                if (obj.NGHENGHIEPID > 0)
                    dropNgheNghiep.SelectedValue = obj.NGHENGHIEPID + "";

                if (obj.TINHTRANGGIAMGIUID > 0)
                    dropTinhTrangGiamGiu.SelectedValue = obj.TINHTRANGGIAMGIUID + "";


                txtHoTenBo.Text = obj.HOTENBO + "";
                if (obj.NAMSINHBO != null) txtNamSinhBo.Text = obj.NAMSINHBO.ToString();
                txtHotenMe.Text = obj.HOTENME;
                if (obj.NAMSINHME != null) txtNamSinhMe.Text = obj.NAMSINHME.ToString();

                rdTreViThanhNien.SelectedValue = (String.IsNullOrEmpty(obj.ISTREVITHANHNIEN + "")) ? "0" : obj.ISTREVITHANHNIEN.ToString();
                if (rdTreViThanhNien.SelectedValue == "1")
                {
                    pnTreViThanhNien.Visible = true;
                    rdTreMoCoi.SelectedValue = obj.TREMOCOI + "";
                    rdTreBoHoc.SelectedValue = obj.TREBOHOC + "";
                    rdTreLangThang.SelectedValue = obj.TRELANGTHANG + "";

                    rdLyHon.SelectedValue = obj.BOMELYHON + "";
                    rdNguoiXuiGiuc.SelectedValue = obj.CONGUOIXUIGIUC + "";
                }
                else
                    pnTreViThanhNien.Visible = false;

                rdNGhienHut.SelectedValue = obj.NGHIENHUT + "";
                rdTinhTrangTaiPham.SelectedValue = obj.TAIPHAM + "";
                //--------------------------------------
                txtTienAn.Text = (string.IsNullOrEmpty(obj.TIENAN + "")) ? "" : obj.TIENAN.ToString();
                txtTienSu.Text = (string.IsNullOrEmpty(obj.TIENSU + "")) ? "" : obj.TIENSU.ToString();
            }
        }
        private void LoadCombobox()
        {
            //-----------Load drop thong tin bi cao----------------------
            LoadDropByGroupName(dropDanToc, ENUM_DANHMUC.DANTOC, true);
            LoadDropByGroupName(dropNgheNghiep, ENUM_DANHMUC.NGHENGHIEP, true);

            LoadDropByGroupName(dropQuocTich, ENUM_DANHMUC.QUOCTICH, false);
            dropQuocTich.SelectedValue = QuocTichVN.ToString();

            LoadDropByGroupName(dropTrinhDoVH, ENUM_DANHMUC.TRINHDOVANHOA, false);
            LoadDropByGroupName(dropTinhTrangGiamGiu, ENUM_DANHMUC.TINHTRANGGIAMGIU, false);
            LoadDropByGroupName(dropTonGiao, ENUM_DANHMUC.TONGIAO, false);

            LoadDropTinh();
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);

            drop.Items.Clear();
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }
        protected void txtNgaysinh_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgaysinh.Text))
            {
                DateTime date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (date_temp != DateTime.MinValue)
                {
                    txtNamSinh.Text = date_temp.Year + "";
                }
            }
        }
        protected void rdTreViThanhNien_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdTreViThanhNien.SelectedValue == "1")
                pnTreViThanhNien.Visible = true;
            else
                pnTreViThanhNien.Visible = false;
        }
        protected void dropQuocTich_SelectedIndexChanged(object sender, EventArgs e)
        {
            
        }
        #endregion
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            Save();
        }
        void Save()
        {
            Decimal VuAnId = (String.IsNullOrEmpty(Request["hsID"]+"")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            Decimal BiCaoID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            #region Bi cao vu an
            XLHC_DUONGSU obj = new XLHC_DUONGSU();
            try
            {
                if (BiCaoID > 0)
                    obj = dt.XLHC_DUONGSU.Where(x => x.ID == BiCaoID).Single<XLHC_DUONGSU>();
                else
                    obj = new XLHC_DUONGSU();
            }
            catch (Exception ex) { obj = new XLHC_DUONGSU(); }

            obj.DONID = VuAnId;
            obj.MABICAN = "";
            obj.BICANDAUVU = 0;
            obj.HOTEN = Cls_Comon.FormatTenRieng(txtTenBiCan.Text.Trim());
            obj.TENKHAC = Cls_Comon.FormatTenRieng(txtTenKhac.Text.Trim());
            obj.SOCMND = txtCMND.Text;


            obj.GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);

            DateTime date_temp;
            date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYSINH = date_temp;

            obj.NAMSINH = Convert.ToDecimal(txtNamSinh.Text);

            obj.HKTTTINHID = Convert.ToDecimal(ddlThuongTruTinh.SelectedValue);
            obj.HKTT = Convert.ToDecimal(ddlThuongTruHuyen.SelectedValue);
            obj.KHTTCHITIET = txtHKTT_Chitiet.Text;
            obj.TAMTRUTINHID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
            obj.TAMTRU = Convert.ToDecimal(ddlNoiSongHuyen.SelectedValue);
            obj.TAMTRUCHITIET = txtTamtru_Chitiet.Text;

            obj.QUOCTICHID = Convert.ToDecimal(dropQuocTich.SelectedValue);
            obj.DANTOCID = Convert.ToDecimal(dropDanToc.SelectedValue);
            obj.TONGIAOID = Convert.ToDecimal(dropTonGiao.SelectedValue);
            obj.TRINHDOVANHOAID = Convert.ToDecimal(dropTrinhDoVH.SelectedValue);
            obj.TINHTRANGGIAMGIUID = Convert.ToDecimal(dropTinhTrangGiamGiu.SelectedValue);
            obj.NGHENGHIEPID = Convert.ToInt32(dropNgheNghiep.SelectedValue);
            obj.HOTENBO = Cls_Comon.FormatTenRieng(txtHoTenBo.Text.Trim());
            obj.NAMSINHBO = (String.IsNullOrEmpty(txtNamSinhBo.Text + "")) ? 0 : Convert.ToDecimal(txtNamSinhBo.Text.Trim());
            obj.HOTENME = Cls_Comon.FormatTenRieng(txtHotenMe.Text.Trim());
            obj.NAMSINHME = (String.IsNullOrEmpty(txtNamSinhMe.Text + "")) ? 0 : Convert.ToDecimal(txtNamSinhMe.Text.Trim());

            //--------------------------------
            obj.ISTREVITHANHNIEN = Convert.ToInt16(rdTreViThanhNien.SelectedValue);
            obj.TREMOCOI = Convert.ToInt16(rdTreMoCoi.SelectedValue);
            obj.TREBOHOC = Convert.ToInt16(rdTreBoHoc.SelectedValue);
            obj.TRELANGTHANG = Convert.ToInt16(rdTreLangThang.SelectedValue);
            obj.BOMELYHON = Convert.ToInt16(rdLyHon.SelectedValue);
            obj.CONGUOIXUIGIUC = Convert.ToInt16(rdNguoiXuiGiuc.SelectedValue);

            //--------------------------------
            obj.NGHIENHUT = Convert.ToInt16(rdNGhienHut.SelectedValue);
            obj.TAIPHAM = Convert.ToInt16(rdTinhTrangTaiPham.SelectedValue);
            //--------------------------------
            obj.TIENAN = (string.IsNullOrEmpty(txtTienAn.Text + "")) ? 0 : Convert.ToInt32(txtTienAn.Text);
            obj.TIENSU = (string.IsNullOrEmpty(txtTienSu.Text + "")) ? 0 : Convert.ToInt32(txtTienSu.Text);

            if (BiCaoID > 0)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.XLHC_DUONGSU.Add(obj);
                dt.SaveChanges();
            }
            #endregion

            lstMsgT.Text = lstMsgB.Text = "Lưu dữ liệu thành công!";

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "UpdateRefesh", " window.opener.location.reload();window.close();", true);

        }
        private void LoadDropTinh()
        {
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                ddlThuongTruTinh.DataSource = lstTinh;
                ddlThuongTruTinh.DataTextField = "TEN";
                ddlThuongTruTinh.DataValueField = "ID";
                ddlThuongTruTinh.DataBind();

                ddlNoiSongTinh.DataSource = lstTinh;
                ddlNoiSongTinh.DataTextField = "TEN";
                ddlNoiSongTinh.DataValueField = "ID";
                ddlNoiSongTinh.DataBind();

            }
            else
            {
                ddlThuongTruTinh.Items.Add(new ListItem("---Chọn---", "0"));
                ddlNoiSongTinh.Items.Add(new ListItem("---Chọn---", "0"));
            }
            LoadDropThuongTruHuyen();
            LoadDropNoiSongHuyen();
        }
        private void LoadDropThuongTruHuyen()
        {
            ddlThuongTruHuyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlThuongTruTinh.SelectedValue);
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlThuongTruHuyen.DataSource = lstHuyen;
                ddlThuongTruHuyen.DataTextField = "TEN";
                ddlThuongTruHuyen.DataValueField = "ID";
                ddlThuongTruHuyen.DataBind();
            }
            else
            {
                ddlThuongTruHuyen.Items.Add(new ListItem("---Chọn---", "0"));
            }
        }
        private void LoadDropNoiSongHuyen()
        {
            ddlNoiSongHuyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlNoiSongTinh.SelectedValue);
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlNoiSongHuyen.DataSource = lstHuyen;
                ddlNoiSongHuyen.DataTextField = "TEN";
                ddlNoiSongHuyen.DataValueField = "ID";
                ddlNoiSongHuyen.DataBind();
            }
            else
            {
                ddlNoiSongHuyen.Items.Add(new ListItem("---Chọn---", "0"));
            }
        }
        protected void ddlThuongTruTinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropThuongTruHuyen();
            }
            catch (Exception ex) { lstMsgB.Text = lstMsgT.Text = ex.Message; }
        }
        protected void ddlNoiSongTinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNoiSongHuyen();
            }
            catch (Exception ex) { lstMsgB.Text = lstMsgT.Text = ex.Message; }
        }
    }
}

