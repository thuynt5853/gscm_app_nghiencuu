using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using BL.GSTP.THA;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.THA.HoSo
{
    public partial class DanhsachBiCan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 0;
        public static Decimal VuAnID = 0, CurrUserID = 0, BiCaoID = 0;
        public int CurrentYear = 0;
        public Decimal LoginTinhID = 0, LoginHuyenID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                CurrentYear = DateTime.Now.Year;
                LoginTinhID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_TINH_ID] + "");
                LoginHuyenID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_QUAN_ID] + "");
                QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
                if (!IsPostBack)
                {
                    LoadCombobox();
                    VuAnID = (Request["hsID"] != null) ? Convert.ToDecimal(Request["hsID"] + "") : 0;
                    BiCaoID = (Request["bID"] != null) ? Convert.ToDecimal(Request["bID"] + "") : 0;
                    hddID.Value = BiCaoID.ToString();

                    if (BiCaoID > 0)
                    {
                        LoadInfo(BiCaoID);
                    }
                    if (dropQuocTich.SelectedValue == QuocTichVN.ToString())
                        pnHoKhau.Visible = true;
                    else
                        pnHoKhau.Visible = false;
                    CheckQuyen();
                    LoadGridToiDanh();
                }
            }
            else
                Response.Redirect("/Login.aspx");
            //rdTreViThanhNien.Attributes.Add("onchange", "return validate_rd_vithanhnien();");
            //  chkGetToiDanhDauVu.Attributes.Add("onclick", "return validate_bican();");
        }

        void CheckQuyen()
        {
            CheckBiCanDauVu();
        }
        void CheckBiCanDauVu()
        {
            rdBiCanDauVu.Enabled = true;
            decimal BiCaoID = (Request["bID"] != null) ? Convert.ToDecimal(Request["bID"] + "") : 0;
            
            try
            {
                cmdGetToiDanhDauVu.Visible = false;
                THA_BIAN objBC = dt.THA_BIAN.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).Single();
                if (objBC != null)
                {
                    hddBiCanDauVuID.Value = objBC.ID.ToString();
                    if (BiCaoID != 0)
                    {
                        THA_BIAN objBCChiTiet = dt.THA_BIAN.Where(x => x.ID == BiCaoID).Single();
                        rdBiCanDauVu.SelectedValue = objBCChiTiet.BICANDAUVU.ToString();
                    }
                    else
                    {
                        rdBiCanDauVu.SelectedValue = "0";
                    }

                    //KT: Neu chua co toi danh --> cho hien nut "Gan toi danh cua bi can dau vu", da co toi danh --> an di
                    Decimal CurrBiCanID = Convert.ToDecimal(hddID.Value);
                    Decimal BiCanDauVuId = Convert.ToDecimal(hddBiCanDauVuID.Value);

                    THA_VUAN_BL objBL = new THA_VUAN_BL();
                    DataTable tbl = objBL.GetAllToiDanhByBiCan(BiCanDauVuId, VuAnID);
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        if (CurrBiCanID == 0)
                            cmdGetToiDanhDauVu.Visible = true;
                        else
                        {
                            if (CurrBiCanID == BiCanDauVuId)
                                cmdGetToiDanhDauVu.Visible = false;
                            else
                                cmdGetToiDanhDauVu.Visible = true;
                        }
                    }
                    else
                    {
                        cmdGetToiDanhDauVu.Visible = false;
                        //lbthongbao.Text = "Bị can đầu vụ chưa có tội danh";
                    }
                }
                else
                {
                    if (BiCaoID == 0)
                    {
                        rdBiCanDauVu.SelectedValue = "1";
                    }
                    cmdGetToiDanhDauVu.Visible = false;
                    hddBiCanDauVuID.Value = "0";
                }
            }
            catch (Exception ex)
            {
                if (BiCaoID == 0)
                {
                    rdBiCanDauVu.SelectedValue = "1";
                }
                cmdGetToiDanhDauVu.Visible = false;
                hddBiCanDauVuID.Value = "0";
            }
        }

        #region from bi cao
        private void LoadCombobox()
        {
            LoadDropTinh_Huyen();
            LoadDropByGroupName(dropDanToc, ENUM_DANHMUC.DANTOC, true);
            LoadDropByGroupName(dropNgheNghiep, ENUM_DANHMUC.NGHENGHIEP, true);

            LoadDropByGroupName(dropQuocTich, ENUM_DANHMUC.QUOCTICH, false);
            dropQuocTich.SelectedValue = QuocTichVN.ToString();

            LoadDropByGroupName(dropTrinhDoVH, ENUM_DANHMUC.TRINHDOVANHOA, false);
            LoadDropByGroupName(dropTinhTrangGiamGiu, ENUM_DANHMUC.TINHTRANGGIAMGIU, false);

            LoadDropByGroupName(dropTonGiao, ENUM_DANHMUC.TONGIAO, true);
            //--------------------------
            // LoadDrop_MoiQHNhanThan();
            //----------------------------------------Form bien phap ngan chan-

            //form toi danh-
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.HIEULUC == 1
                           && x.LOAI == ENUM_LOAIVUVIEC.AN_HINHSU.ToString()).ToList<DM_BOLUAT>();
            dropBoLuat.Items.Clear();
            // dropBoLuat.Items.Add(new ListItem("--Chọn--", "0"));
            if (lst != null && lst.Count > 0)
            {
                foreach (DM_BOLUAT obj in lst)
                    dropBoLuat.Items.Add(new ListItem(obj.TENBOLUAT, obj.ID.ToString()));
            }
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);

            drop.Items.Clear();
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("--Chọn--", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["Ten"] + "", row["ID"] + ""));
            }
        }
        //
        private const decimal ROOT = 0;
        private void LoadDropTinh_Huyen()
        {
            ddlHKTT_Tinh.Items.Clear();
            ddlTamTru_Tinh.Items.Clear();
            ddlHKTT_Tinh.Items.Add(new ListItem("Chọn Tỉnh/TP", "0"));
            ddlTamTru_Tinh.Items.Add(new ListItem("Chọn Tỉnh/TP", "0"));
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                foreach (DM_HANHCHINH objTinh in lstTinh)
                {
                    ListItem item = new ListItem(objTinh.TEN, objTinh.ID.ToString());
                    ddlHKTT_Tinh.Items.Add(item);
                }
                Cls_Comon.SetValueComboBox(ddlHKTT_Tinh, LoginTinhID);
                foreach (DM_HANHCHINH objTinh in lstTinh)
                {
                    ListItem item = new ListItem(objTinh.TEN, objTinh.ID.ToString());
                    ddlTamTru_Tinh.Items.Add(item);
                }
                Cls_Comon.SetValueComboBox(ddlTamTru_Tinh, LoginTinhID);
            }

            //----------------------------------------
            LoadDropHuyen();
        }
        void LoadDropHuyen()
        {
            ddlHKTT_Huyen.Items.Clear();
            ddlTamTru_Huyen.Items.Clear();

            ddlHKTT_Huyen.Items.Add(new ListItem("Chọn", "0"));
            ddlTamTru_Huyen.Items.Add(new ListItem("Chọn", "0"));
            Decimal TinhID = Convert.ToDecimal(ddlHKTT_Tinh.SelectedValue);
            if (TinhID > 0)
            {
                List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
                if (lstHuyen != null && lstHuyen.Count > 0)
                {
                    foreach (DM_HANHCHINH obj in lstHuyen)
                    {
                        ListItem item = new ListItem(obj.TEN, obj.ID.ToString());
                        ddlHKTT_Huyen.Items.Add(item);
                    }
                    Cls_Comon.SetValueComboBox(ddlHKTT_Huyen, LoginHuyenID);
                    foreach (DM_HANHCHINH obj in lstHuyen)
                    {
                        ListItem item = new ListItem(obj.TEN, obj.ID.ToString());
                        ddlTamTru_Huyen.Items.Add(item);
                    }
                    Cls_Comon.SetValueComboBox(ddlTamTru_Huyen, LoginHuyenID);
                }
            }
        }
        private void LoadDropHuyenByTinh(DropDownList drop, Decimal TinhID)
        {
            drop.Items.Clear();
            //DM_HANHCHINH_BL bl = new DM_HANHCHINH_BL();
            //DataTable tbl = bl.GetAllByParentID(TinhID);
            //if (tbl != null && tbl.Rows.Count>0)
            //{
            //    drop.DataSource = tbl;
            //    drop.DataTextField = "TEN";
            //    drop.DataValueField = "ID";
            //    drop.DataBind();
            //}
            //else
            //    drop.Items.Add(new ListItem("Chọn", "0"));
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                //drop.DataSource = lstHuyen;
                //drop.DataTextField = "TEN";
                //drop.DataValueField = "ID";
                //drop.DataBind();
                foreach (DM_HANHCHINH oHC in lstHuyen)
                    drop.Items.Add(new ListItem(oHC.TEN, oHC.ID.ToString()));
            }
            else
                drop.Items.Add(new ListItem("Chọn", "0"));
        }
        protected void ddlHKTT_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHuyenByTinh(ddlHKTT_Huyen, Convert.ToDecimal(ddlHKTT_Tinh.SelectedValue));
                Cls_Comon.SetFocus(this, this.GetType(), ddlHKTT_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void ddlTamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropHuyenByTinh(ddlTamTru_Huyen, Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue));
                Cls_Comon.SetFocus(this, this.GetType(), ddlTamTru_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        //-----------------------------------------
        private void LoadInfo(decimal BiCanID)
        {
            hddID.Value = BiCanID.ToString();
            THA_BIAN obj = null;
            try
            {
                obj = dt.THA_BIAN.Where(x => x.ID == BiCanID).SingleOrDefault();
            }
            catch (Exception ex) { obj = null; }

            if (obj != null)
            {
                //dropLoaiToiPham.SelectedValue = (String.IsNullOrEmpty(obj.LOAITOIPHAMHS_ID + "")) ? "0" : obj.LOAITOIPHAMHS_ID.ToString();
                txtTen.Text = obj.HOTEN;
                rdBiCanDauVu.SelectedValue = obj.BICANDAUVU.ToString();
                txtCMND.Text = obj.SOCMND;
                dropNgheNghiep.SelectedValue = (String.IsNullOrEmpty(obj.NGHENGHIEPID + "")) ? "0" : obj.NGHENGHIEPID.ToString();
                if (obj.LOAIDOITUONG != null) dropDoiTuongPhamToi.SelectedValue = obj.LOAIDOITUONG + "";
                //----------------------------------------
                dropQuocTich.SelectedValue = obj.QUOCTICHID.ToString();
                string Ma_quoctich = dt.DM_DATAITEM.Where(x => x.ID == obj.QUOCTICHID).Single<DM_DATAITEM>().MA;
                if (Ma_quoctich == ENUM_MAQUOCTICH.VIETNAM)
                    pnHoKhau.Visible = true;
                else
                    pnHoKhau.Visible = false;

                //----------------------------------------
                if (obj.HKTT != null)
                {
                    Cls_Comon.SetValueComboBox(ddlHKTT_Tinh, obj.HKTT);
                    LoadDropHuyenByTinh(ddlHKTT_Huyen, (decimal)obj.HKTT);
                }
                if (obj.HKTT_HUYEN != null)
                    Cls_Comon.SetValueComboBox(ddlHKTT_Huyen, obj.HKTT_HUYEN);
                txtHKTT_Chitiet.Text = obj.KHTTCHITIET;

                //----------------------------------------
                if (obj.TAMTRU != null)
                {
                    Cls_Comon.SetValueComboBox(ddlTamTru_Tinh, obj.TAMTRU);
                    LoadDropHuyenByTinh(ddlTamTru_Huyen, (decimal)obj.TAMTRU);
                }
                if (obj.TAMTRU_HUYEN != null)
                    Cls_Comon.SetValueComboBox(ddlTamTru_Huyen, obj.TAMTRU_HUYEN);
                txtTamtru_Chitiet.Text = obj.TAMTRUCHITIET;

                //----------------------------------------
                if (obj.NGAYSINH != DateTime.MinValue)
                    txtNgaysinh.Text = ((DateTime)obj.NGAYSINH).ToString("dd/MM/yyyy", cul);
                txtNamSinh.Text = obj.NAMSINH + "";
                ddlGioitinh.SelectedValue = obj.GIOITINH.ToString();

                //----------------------------------------
                txtTenKhac.Text = obj.TENKHAC + "";
                dropDanToc.SelectedValue = (string.IsNullOrEmpty(obj.DANTOCID + "")) ? "0" : obj.DANTOCID + "";
                dropTonGiao.SelectedValue = (string.IsNullOrEmpty(obj.TONGIAOID + "")) ? "0" : obj.TONGIAOID + "";
                rdChuvVuCQ.SelectedValue = (string.IsNullOrEmpty(obj.CHUCVUCHINHQUYENID + "")) ? "0" : obj.CHUCVUCHINHQUYENID.ToString();
                rdChucVuDang.SelectedValue = (string.IsNullOrEmpty(obj.CHUCVUDANGID + "")) ? "0" : obj.CHUCVUDANGID.ToString();

                txtNgayKhoiTo.Text = ((String.IsNullOrEmpty(obj.NGAYTHAMGIA + "")) || (((DateTime)obj.NGAYTHAMGIA) == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);

                try { dropTinhTrangGiamGiu.SelectedValue = obj.TINHTRANGGIAMGIUID.ToString(); } catch (Exception exx) { }
                //-----------------------------------------
                rdTreViThanhNien.SelectedValue = (String.IsNullOrEmpty(obj.ISTREVITHANHNIEN + "")) ? "0" : obj.ISTREVITHANHNIEN.ToString();
                if (rdTreViThanhNien.SelectedValue == "1")
                {
                    //pnTuoi.Enabled = true;
                    pnTreViThanhNien.Visible = true;

                    rdTreMoCoi.SelectedValue = obj.TREMOCOI + "";
                    rdTreBoHoc.SelectedValue = obj.TREBOHOC + "";
                    rdTreLangThang.SelectedValue = obj.TRELANGTHANG + "";

                    rdLyHon.SelectedValue = obj.BOMELYHON + "";
                    rdNguoiXuiGiuc.SelectedValue = obj.CONGUOIXUIGIUC + "";
                }
                else
                {
                    pnTreViThanhNien.Visible = false;
                    //pnTuoi.Enabled = false;
                }

                rdNGhienHut.SelectedValue = obj.NGHIENHUT + "";
                rdTinhTrangTaiPham.SelectedValue = obj.TAIPHAM + "";
                //-----------------------------------------
                txtTienAn.Text = (string.IsNullOrEmpty(obj.TIENAN + "")) ? "" : obj.TIENAN.ToString();
                txtTienAn.Text = (string.IsNullOrEmpty(obj.TIENSU + "")) ? "" : obj.TIENSU.ToString();
                if (obj.TUOI > 0)
                    txtTuoi.Text = obj.TUOI + "";
            }
        }

        protected void txtNgayKhoiTo_TextChanged(object sender, EventArgs e)
        {
            //if (Cls_Comon.IsValidDate(txtNgayKhoiTo.Text) == false)
            //{
            //    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn chưa nhập ngày bị khởi tố theo định dạng (ngày/tháng/năm). Hãy kiểm tra lại!");
            //    Cls_Comon.SetFocus(this, this.GetType(), txtNgayKhoiTo.ClientID);
            //    return;
            //}
            if (!String.IsNullOrEmpty(txtNgayKhoiTo.Text))
            {
                String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                DateTime Dnow = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime NgayKhoiTo = DateTime.Parse(txtNgayKhoiTo.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgayKhoiTo > Dnow)
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ngày bị khởi tố không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                    Cls_Comon.SetFocus(this, this.GetType(), txtNgayKhoiTo.ClientID);
                    return;
                }
                //if (txtNamSinh.Text != "")
                //{
                //    TinhTuoiBiCan();
                //}
            }
            Cls_Comon.SetFocus(this, this.GetType(), dropDanToc.ClientID);
        }
        protected void txtNgaysinh_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgaysinh.Text))
            {
                DateTime Ngaysinh = DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                DateTime now = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
                if (Ngaysinh != DateTime.MinValue)
                {
                    if (Ngaysinh > now)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ngày sinh không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtNgaysinh.ClientID);
                        return;
                    }
                    else
                        txtNamSinh.Text = Ngaysinh.Year.ToString();
                }
                if (!String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim()))
                {
                    DateTime NgayKhoiTo = DateTime.Parse(txtNgayKhoiTo.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (Ngaysinh > NgayKhoiTo)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Ngày sinh không thể lớn hơn ngày bị khởi tố. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtNgaysinh.ClientID);
                        return;
                    }
                    txtNamSinh.Text = Ngaysinh.Year.ToString();
                }

                //if (!String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim()))
                //    TinhTuoiBiCan();
            }
        }
        protected void txtNamSinh_TextChanged(object sender, EventArgs e)
        {
            int namsinh = 0;
            if (!String.IsNullOrEmpty(txtNgaysinh.Text))
            {
                if (!String.IsNullOrEmpty(txtNamSinh.Text))
                {
                    namsinh = Convert.ToInt32(txtNamSinh.Text);
                    DateTime date_temp;
                    date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (date_temp != DateTime.MinValue)
                    {
                        String ngaysinh = txtNgaysinh.Text.Trim();
                        String[] arr = ngaysinh.Split('/');

                        txtNgaysinh.Text = arr[0] + "/" + arr[1] + "/" + namsinh.ToString();
                    }
                }
            }
            if (!String.IsNullOrEmpty(txtNamSinh.Text))
            {
                namsinh = Convert.ToInt32(txtNamSinh.Text);
                if (!String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim()))
                {
                    DateTime NgayKhoiTo = DateTime.Parse(txtNgayKhoiTo.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (namsinh > NgayKhoiTo.Year)
                    {
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Năm sinh không thể lớn hơn năm khởi tố. Hãy kiểm tra lại!");
                        Cls_Comon.SetFocus(this, this.GetType(), txtNamSinh.ClientID);
                    }
                    //TinhTuoiBiCan();
                }
            }

            Cls_Comon.SetFocus(this, this.GetType(), txtTenKhac.ClientID);
        }

        void TinhTuoiBiCan()
        {
            DateTime ngaysinh, ngaykhoito;
            ngaysinh = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (String.IsNullOrEmpty(txtNgaysinh.Text.Trim()) && (!String.IsNullOrEmpty(txtNamSinh.Text)))
            {
                string temp_ngaysinh = "01/01" + "/" + txtNamSinh.Text.Trim(); // theo luat: neu ko co ngay sinh, chi co nam sinh --> default = 1/1/nam sinh
                ngaysinh = DateTime.Parse(temp_ngaysinh, cul, DateTimeStyles.NoCurrentDateDefault);
            }
            ngaykhoito = (String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKhoiTo.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            int nam = ngaykhoito.Year - ngaysinh.Year;
            int thang = ngaykhoito.Month - ngaysinh.Month;
            if (thang < 0)
                nam = nam - 1;
            else
            {
                if (thang == 0)
                {
                    int ngay = ngaykhoito.Day - ngaysinh.Day;
                    if (ngay <= 0)
                        nam = nam - 1;
                }
            }

            txtTuoi.Text = nam.ToString();

            if (nam >= 0)
            {
                if (nam > 18)
                {
                    rdTreViThanhNien.Enabled = pnTreViThanhNien.Visible = false;
                    rdTreViThanhNien.SelectedValue = "0";
                }
                else
                {
                    if (nam < 18)
                    {
                        rdTreViThanhNien.SelectedValue = "1";
                        rdTreViThanhNien.Enabled = false;
                        pnTreViThanhNien.Visible = true;
                    }
                    else if (nam == 18)
                    {
                        rdTreViThanhNien.SelectedValue = "0";
                        rdTreViThanhNien.Enabled = true;
                        pnTreViThanhNien.Visible = false;
                    }
                }
            }
            else
            {
                rdTreViThanhNien.SelectedValue = "1";
                rdTreViThanhNien.Enabled = false;
                pnTreViThanhNien.Visible = true;
                txtTuoi.Text = "0";
            }
        }

        protected void rdTreViThanhNien_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdTreViThanhNien.SelectedValue == "1")
            {
                if (string.IsNullOrEmpty(txtNamSinh.Text.Trim()))
                {
                    rdTreViThanhNien.SelectedIndex = -1;
                }
                else
                {
                    pnTreViThanhNien.Visible = true;
                }
            }
            else
            {
                pnTreViThanhNien.Visible = false;
            }
        }

        protected void dropQuocTich_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropQuocTich.SelectedValue == QuocTichVN.ToString())
                pnHoKhau.Visible = true;
            else
                pnHoKhau.Visible = false;
            Cls_Comon.SetFocus(this, this.GetType(), dropDanToc.ClientID);
        }

        #endregion
        private bool CheckValidate()
        {
            string msg = "";
            if (txtTen.Text.Trim() == "")
            {
                msg = "Bạn chưa nhập tên bị can. Hãy kiểm tra lại!";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                txtTen.Focus();
                return false;
            }
            String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
            DateTime Dnow = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime NgayKhoiTo = (String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKhoiTo.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (NgayKhoiTo != DateTime.MinValue)
            {
                if (NgayKhoiTo > Dnow)
                {
                    msg = "Ngày bị khởi tố không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    txtNgayKhoiTo.Focus();
                    return false;
                }
            }
            if (txtNamSinh.Text == "")
            {
                msg = "Bạn chưa nhập năm sinh. Hãy kiểm tra lại!";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                txtNamSinh.Focus();
                return false;
            }
            if (dropQuocTich.SelectedValue == QuocTichVN.ToString() && ddlHKTT_Tinh.SelectedValue == "0")
            {
                msg = "Bạn chưa chọn địa chỉ thường trú. Hãy kiểm tra lại!";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                ddlHKTT_Tinh.Focus();
                return false;
            }
            if (dropQuocTich.SelectedValue == QuocTichVN.ToString())
            {
                if (ddlTamTru_Tinh.SelectedValue == "0")
                {
                    msg = "Bạn chưa chọn nơi sinh sống. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    ddlTamTru_Tinh.Focus();
                    return false;
                }
            }
            if (rdChucVuDang.SelectedValue == "")
            {
                msg = "Mục 'Chức vụ đảng' bắt buộc phải chọn. Hãy kiểm tra lại!";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                return false;
            }
            if (rdChuvVuCQ.SelectedValue == "")
            {
                msg = "Mục 'Công chức, viên chức' bắt buộc phải chọn. Hãy kiểm tra lại!";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                return false;
            }
            if (rdNGhienHut.SelectedValue == "")
            {
                msg = "Mục 'Nghiện hút' bắt buộc phải chọn. Hãy kiểm tra lại!";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                return false;
            }
            if (rdTinhTrangTaiPham.SelectedValue == "")
            {
                msg = "Mục 'Tái phạm, tái phạm nguy hiểm' bắt buộc phải chọn. Hãy kiểm tra lại!";
                Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                return false;
            }
            if (rdTreViThanhNien.SelectedValue == "1")
            {
                if (rdTreMoCoi.SelectedValue == "")
                {
                    msg = "Mục 'Trẻ mồ côi cha hoặc mẹ' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdTreLangThang.SelectedValue == "")
                {
                    msg = "Mục 'Trẻ lang thang' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdTreBoHoc.SelectedValue == "")
                {
                    msg = "Mục 'Trẻ bỏ học' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdLyHon.SelectedValue == "")
                {
                    msg = "Mục 'Bố mẹ ly hôn' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
                if (rdNguoiXuiGiuc.SelectedValue == "")
                {
                    msg = "Mục 'Có người đủ 18 tuổi trở lên xúi giục' bắt buộc phải chọn. Hãy kiểm tra lại!";
                    Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", msg);
                    return false;
                }
            }

            return true;
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckValidate())
                return;

            //KT xem bi can da duoc gan toi chua
            if (!CheckGanToiChoBiCan())
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bị can chưa được gán tội danh. Hãy kiểm tra lại!");
                Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
                return;
            }
            Save_BiCan();
            Them_VuAn();

            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        protected void cmdUpdateAndNext_Click(object sender, EventArgs e)
        {
            if (!CheckValidate())
                return;

            //KT xem bi can da duoc gan toi chua
            if (!CheckGanToiChoBiCan())
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bị can chưa được gán tội danh. Hãy kiểm tra lại!");
                Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
                return;
            }

            Save_BiCan();
            Them_VuAn();
            lstMsgT.Text = lstMsgB.Text = "Lưu thông tin bị can thành công!";
            Resetcontrol();

        }
        void Resetcontrol()
        {
            txtTen.Text = txtTenKhac.Text = txtCMND.Text = "";
            txtTuoi.Text = "";

            rdBiCanDauVu.SelectedValue = "0";
            txtNgaysinh.Text = txtNamSinh.Text = "";


            txtNgayKhoiTo.Text = "";
            ddlGioitinh.SelectedIndex = dropQuocTich.SelectedIndex = dropDanToc.SelectedIndex = 0;

            //---------------------------
            txtHKTT_Chitiet.Text = txtTamtru_Chitiet.Text = "";
            LoadDropTinh_Huyen();

            //---------------------------
            dropTonGiao.SelectedValue = dropNgheNghiep.SelectedValue = "0";
            dropTrinhDoVH.SelectedIndex = dropTinhTrangGiamGiu.SelectedIndex = 0;
            //---------------------------
            hddID.Value = "0";
            hddPageIndex.Value = "1";

            //---------------------------
            rdChucVuDang.SelectedIndex = rdChuvVuCQ.SelectedIndex = -1;
            rdTinhTrangTaiPham.SelectedIndex = rdNGhienHut.SelectedIndex = -1;
            //---------------------------
            txtTienAn.Text = txtTienSu.Text = "";
            rdTreViThanhNien.SelectedIndex = -1;
            pnTreViThanhNien.Visible = false;
            //--------------------
            txtDiem.Text = txtKhoan.Text = txtDieu.Text = "";
            lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            pndata.Visible = false;
            cmdGetToiDanhDauVu.Visible = true;
        }
        void Save_BiCan()
        {
            lbthongbao.Text = lstMsgT.Text = lstMsgB.Text = "";
            Update_BiCao();

            hddIsReloadParent.Value = "1";
        }

        Boolean CheckGanToiChoBiCan()
        {
            try
            {
                Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
                Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
                List<THA_SOTHAM_CAOTRANG_DIEULUAT> lst = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID
                                                                                                && x.VUANID == VuAnID
                                                                                                && x.DIEULUATID == boluatid).ToList();
                if (lst != null && lst.Count > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex) { return false; }
        }
        
        void Update_BiCao()
        {
            decimal VuAnId = 0;
            if (Convert.ToDecimal(Session[ENUM_THA_VUAN.SESSION_IDVUANTHA]) == 0)
            {
                DateTime date_tempTHA;
                string SoBA = Session[ENUM_THA_VUAN.SESSION_BA_ST_SO].ToString();
                DateTime NgayBA = Convert.ToDateTime(Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN]);
                Decimal ToaAnRaBA = Convert.ToDecimal(Session[ENUM_THA_VUAN.SESSION_BA_ST_TOAANID].ToString());
                THA_VUAN oBAST = dt.THA_VUAN.Where(x => x.BA_ST_SO == SoBA && x.BA_ST_NGAYBANAN == NgayBA && x.BA_ST_TOAANID == ToaAnRaBA).FirstOrDefault();
                if (oBAST != null)
                {
                    VuAnID = VuAnId = oBAST.ID;
                }
                else
                {
                    THA_VUAN obj_THA_VuAN = new THA_VUAN();

                    if (Session[ENUM_THA_VUAN.SESSION_DDLGDXX].ToString() == "2")
                    {
                        obj_THA_VuAN.BA_ST_SO = Session[ENUM_THA_VUAN.SESSION_BA_ST_SO].ToString();
                        obj_THA_VuAN.BA_ST_NGAYBANAN = Convert.ToDateTime(Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN]);
                        obj_THA_VuAN.BA_ST_TOAANID = Convert.ToDecimal(Session[ENUM_THA_VUAN.SESSION_BA_ST_TOAANID]);

                        obj_THA_VuAN.BA_PT_SO = Session[ENUM_THA_VUAN.SESSION_BA_PT_SO].ToString();
                        obj_THA_VuAN.BA_PT_NGAYBANAN = Convert.ToDateTime(Session[ENUM_THA_VUAN.SESSION_BA_PT_NGAYBANAN]);
                        obj_THA_VuAN.BA_PT_TOAANID = Convert.ToDecimal(Session[ENUM_THA_VUAN.SESSION_BA_PT_TOAANID]);
                    }
                    else if (Session[ENUM_THA_VUAN.SESSION_DDLGDXX].ToString() == "1")
                    {
                        obj_THA_VuAN.BA_ST_SO = Session[ENUM_THA_VUAN.SESSION_BA_ST_SO].ToString();
                        obj_THA_VuAN.BA_ST_NGAYBANAN = Convert.ToDateTime(Session[ENUM_THA_VUAN.SESSION_BA_ST_NGAYBANAN]);
                        obj_THA_VuAN.BA_ST_TOAANID = Convert.ToDecimal(Session[ENUM_THA_VUAN.SESSION_BA_ST_TOAANID]);
                    }
                    //----------------------------------
                    obj_THA_VuAN.BA_TENVUAN = Session[ENUM_THA_VUAN.SESSION_BA_TENVUAN].ToString();
                    obj_THA_VuAN.BA_TINHCHAT = Convert.ToDecimal(Session[ENUM_THA_VUAN.SESSION_BA_TINHCHAT]);

                    obj_THA_VuAN.ISHETHONG = Convert.ToDecimal(Session[ENUM_THA_VUAN.SESSION_ISHETHONG]);
                    obj_THA_VuAN.IDVUANHETHONG = 0;
                    //--------------------------------
                    date_tempTHA = Convert.ToDateTime(Session[ENUM_THA_VUAN.SESSION_NGAYXAYRA]);
                    if (date_tempTHA != DateTime.MinValue)
                    {
                        obj_THA_VuAN.BA_NGAYVUAN = date_tempTHA;
                        obj_THA_VuAN.BA_THANG = Convert.ToDecimal(date_tempTHA.Month);
                        obj_THA_VuAN.BA_NAM = Convert.ToDecimal(date_tempTHA.Year);
                        //oT.GIOXAYRA = Convert.ToDecimal(dropGio.SelectedValue);
                    }
                    obj_THA_VuAN.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    THA_VUAN_BL dsBL = new THA_VUAN_BL();
                    obj_THA_VuAN.TT = dsBL.GETNEWTT((decimal)obj_THA_VuAN.TOAANID);
                    obj_THA_VuAN.BA_MAVUAN = ENUM_LOAIVUVIEC.AN_THA + Session[ENUM_SESSION.SESSION_MADONVI] + dsBL.GETNEWTT((decimal)obj_THA_VuAN.TOAANID).ToString();
                    obj_THA_VuAN.NGAYTAO = DateTime.Now;
                    obj_THA_VuAN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj_THA_VuAN.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.THA_VUAN.Add(obj_THA_VuAN);
                    dt.SaveChanges();
                    VuAnID = VuAnId = obj_THA_VuAN.ID;
                    Session[ENUM_THA_VUAN.SESSION_IDVUANTHA] = obj_THA_VuAN.ID;
                }
            }
            else
            {
                VuAnID = VuAnId = Convert.ToDecimal(Session[ENUM_THA_VUAN.SESSION_IDVUANTHA]);
            }


            Decimal BiCaoID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            #region Bi cao vu an
            THA_BIAN obj = new THA_BIAN();
            try
            {
                if (BiCaoID > 0)
                    obj = dt.THA_BIAN.Where(x => x.ID == BiCaoID).Single<THA_BIAN>();
                else
                {
                    obj = new THA_BIAN();
                    THA_BIAN_BL dsBL = new THA_BIAN_BL();
                    decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    obj.TT = Convert.ToDecimal(dsBL.GETNEWTT((decimal)TOAANID).ToString());
                    obj.MABICAN = ENUM_LOAIVUVIEC.AN_THA + Session[ENUM_SESSION.SESSION_MADONVI] + dsBL.GETNEWTT((decimal)TOAANID).ToString();
                }
            }
            catch (Exception ex) { obj = new THA_BIAN(); }
            obj.VUANID = VuAnId;
            
            obj.LOAIDOITUONG = Convert.ToDecimal(dropDoiTuongPhamToi.SelectedValue);

            obj.BICANDAUVU = Convert.ToDecimal(rdBiCanDauVu.SelectedValue);
            obj.HOTEN = Cls_Comon.FormatTenRieng(txtTen.Text.Trim());
            obj.TENKHAC = Cls_Comon.FormatTenRieng(txtTenKhac.Text.Trim());
            obj.SOCMND = txtCMND.Text;
            obj.QUOCTICHID = Convert.ToDecimal(dropQuocTich.SelectedValue);
            obj.DANTOCID = Convert.ToDecimal(dropDanToc.SelectedValue);

            obj.TONGIAOID = Convert.ToDecimal(dropTonGiao.SelectedValue);
            obj.GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);

            DateTime date_temp;
            date_temp = (String.IsNullOrEmpty(txtNgaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYSINH = date_temp;
            if (date_temp != DateTime.MinValue)
            {
                obj.THANGSINH = Convert.ToDecimal(date_temp.Month);
            }
            obj.NAMSINH = Convert.ToDecimal(txtNamSinh.Text);

            obj.CHUCVUCHINHQUYENID = Convert.ToDecimal(rdChuvVuCQ.SelectedValue);
            obj.CHUCVUDANGID = Convert.ToDecimal(rdChucVuDang.SelectedValue);

            date_temp = (String.IsNullOrEmpty(txtNgayKhoiTo.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayKhoiTo.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (date_temp != DateTime.MinValue)
                obj.NGAYTHAMGIA = date_temp;
            else
                obj.NGAYTHAMGIA = null;
            //-----------------------------------------
            obj.TAMTRU = Convert.ToDecimal(ddlTamTru_Tinh.SelectedValue);
            obj.TAMTRU_HUYEN = Convert.ToDecimal(ddlTamTru_Huyen.SelectedValue);
            obj.TAMTRUCHITIET = txtTamtru_Chitiet.Text;

            obj.HKTT = Convert.ToDecimal(ddlHKTT_Tinh.SelectedValue);
            obj.HKTT_HUYEN = Convert.ToDecimal(ddlHKTT_Huyen.SelectedValue);
            obj.KHTTCHITIET = txtHKTT_Chitiet.Text;

            //-----------------------------------------
            obj.TRINHDOVANHOAID = Convert.ToDecimal(dropTrinhDoVH.SelectedValue);
            obj.TINHTRANGGIAMGIUID = Convert.ToDecimal(dropTinhTrangGiamGiu.SelectedValue);

            //-----------------------------------------
            obj.ISTREVITHANHNIEN = Convert.ToDecimal(rdTreViThanhNien.SelectedValue);
            if (obj.ISTREVITHANHNIEN == 0)
            {
                obj.TREMOCOI = obj.TREBOHOC = obj.TRELANGTHANG = obj.BOMELYHON = obj.CONGUOIXUIGIUC = 0;
            }
            else
            {
                obj.TREMOCOI = Convert.ToDecimal(rdTreMoCoi.SelectedValue);
                obj.TREBOHOC = Convert.ToDecimal(rdTreBoHoc.SelectedValue);
                obj.TRELANGTHANG = Convert.ToDecimal(rdTreLangThang.SelectedValue);
                obj.BOMELYHON = Convert.ToDecimal(rdLyHon.SelectedValue);
                obj.CONGUOIXUIGIUC = Convert.ToDecimal(rdNguoiXuiGiuc.SelectedValue);
            }
            obj.TUOI = (string.IsNullOrEmpty(txtTuoi.Text)) ? 0 : Convert.ToDecimal(txtTuoi.Text);
            //-----------------------------------------
            obj.NGHIENHUT = Convert.ToDecimal(rdNGhienHut.SelectedValue);
            obj.TAIPHAM = Convert.ToDecimal(rdTinhTrangTaiPham.SelectedValue);
            //-----------------------------------------
            obj.TIENAN = (string.IsNullOrEmpty(txtTienAn.Text + "")) ? 0 : Convert.ToInt32(txtTienAn.Text + "");
            obj.TIENSU = (string.IsNullOrEmpty(txtTienSu.Text + "")) ? 0 : Convert.ToInt32(txtTienSu.Text + "");

            obj.NGHENGHIEPID = Convert.ToDecimal(dropNgheNghiep.SelectedValue);
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
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_BIAN.Add(obj);
                dt.SaveChanges();
            }

            //----------------------------------------
            BiCaoID = obj.ID;
            hddID.Value = BiCaoID.ToString();

            //----------------------------------------- 

            if (obj.BICANDAUVU == 1)
            {
                List<THA_BIAN> lstBC = dt.THA_BIAN.Where(x => x.VUANID == VuAnId && x.BICANDAUVU == 1
                                                                        && x.ID != BiCaoID
                                                                    ).ToList<THA_BIAN>();
                if (lstBC != null && lstBC.Count > 0)
                {
                    foreach (THA_BIAN objBC in lstBC)
                        objBC.BICANDAUVU = 0;
                    dt.SaveChanges();
                }
                //Update_TenVuAn(VuAnId, obj.HOTEN, BiCaoID);
            }
            Update_NewTenToiDanh();
            #endregion

            //----------------------------------------
            //GanToiDanhBiCanKhac_Tu_BCDauVu(BiCaoID);
        }
        void Update_NewTenToiDanh()
        {
            decimal BiCanDauVu = Convert.ToDecimal(rdBiCanDauVu.SelectedValue);
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

            Decimal currID = 0, currToiDanhID = 0;
            int count_tt = 0;
            String tentoidanh = "";
            THA_SOTHAM_CAOTRANG_DIEULUAT objTD = null;

            foreach (RepeaterItem item in rpt.Items)
            {
                currID = 0;
                count_tt++;

                HiddenField hddCurrID = (HiddenField)item.FindControl("hddCurrID");
                HiddenField hddToiDanhID = (HiddenField)item.FindControl("hddToiDanhID");
                TextBox txtTenToiDanh = (TextBox)item.FindControl("txtTenToiDanh");
                HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                HiddenField hddLoaiToiPham = (HiddenField)item.FindControl("hddLoaiToiPham");
                if (hddLoai.Value == "2")
                {
                    currToiDanhID = Convert.ToDecimal(hddToiDanhID.Value);
                    currID = Convert.ToDecimal(hddCurrID.Value);

                    if (String.IsNullOrEmpty(txtTenToiDanh.Text.Trim()))
                    {
                        //xoa trang txtTenToiDanh --> lay ten trong DM_BoLuat_toiDanh
                        DM_BOLUAT_TOIDANH objDM = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == currToiDanhID).Single<DM_BOLUAT_TOIDANH>();
                        tentoidanh = objDM.TENTOIDANH;
                    }
                    else
                        tentoidanh = txtTenToiDanh.Text.Trim();

                    if (BiCanDauVu == 1 && count_tt == 1)
                    {
                        //Update ten vu an
                        THA_VUAN objVA = dt.THA_VUAN.Where(x => x.ID == VuAnID).Single();
                        // objVA.TENVUAN = txtTen.Text.Trim() + " - " + tentoidanh;
                        //objVA.LOAITOIPHAMID = Convert.ToDecimal(hddLoaiToiPham.Value);
                        dt.SaveChanges();
                    }

                    //Update bang SoTham_CaoTrang_DieuLuat
                    objTD = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.ID == currID
                                                                    && x.VUANID == VuAnID
                                                                    && x.BICANID == BiCanID).FirstOrDefault();
                    if (objTD != null)
                    {
                        objTD.TENTOIDANH = tentoidanh;
                        objTD.ISMAIN = (count_tt == 1) ? 1 : 0;
                    }
                }
            }
            dt.SaveChanges();
        }



        #region from toi danh    
        void Them_VuAn()
        {
            //DateTime date_temp;
            //Boolean IsUpdate = false;
            Decimal BiAnID = Convert.ToDecimal(hddID.Value);
            Decimal IDAnHS = 0;
            THA_BIAN objbian = dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault();
            Decimal VuAnID = Convert.ToDecimal(objbian.VUANID);
            THA_VUAN objvuan = dt.THA_VUAN.Where(x => x.ID == objbian.VUANID).FirstOrDefault();
            AHS_SOTHAM_BANAN objSoTham_BanAn = dt.AHS_SOTHAM_BANAN.Where(x => (x.SOBANAN == objvuan.BA_ST_SO && x.NGAYBANAN == objvuan.BA_ST_NGAYBANAN && x.TOAANID == objvuan.BA_ST_TOAANID) || (x.SOBANAN == objvuan.BA_PT_SO && x.NGAYBANAN == objvuan.BA_PT_NGAYBANAN && x.TOAANID == objvuan.BA_PT_TOAANID)).FirstOrDefault();

            //AHS_SOTHAM_BANAN objSoTham_BanAn = dt.AHS_SOTHAM_BANAN.Where(x => (x.SOBANAN == objvuan.BA_ST_SO && x.NGAYBANAN == objvuan.BA_ST_NGAYBANAN && x.TOAANID == objvuan.BA_ST_TOAANID) || (x.SOBANAN == objvuan.BA_PT_SO && x.NGAYBANAN == objvuan.BA_PT_NGAYBANAN && x.TOAANID == objvuan.BA_PT_TOAANID)).FirstOrDefault();
            AHS_VUAN objAhsVuan = null;

            if (objvuan.IDVUANHETHONG == 0 || objvuan.IDVUANHETHONG == null)
            {
                objAhsVuan = new AHS_VUAN();
                objAhsVuan.TENVUAN = objvuan.BA_TENVUAN;
                objAhsVuan.TENKHAC = null;
                objAhsVuan.TRUONGHOPGIAONHAN = 1;
                objAhsVuan.NGAYBANCAOTRANG = null;
                objAhsVuan.SOBUTLUC = null;
                objAhsVuan.NGAYGIAO = null;
                objAhsVuan.QUYETDINHTRUYTO = null;
                objAhsVuan.SOBICAN = 1;
                objAhsVuan.SOBICANTAMGIAM = 0;
                objAhsVuan.LOAITOIPHAMID = null;
                objAhsVuan.NGAYXAYRA = objvuan.BA_NGAYVUAN;
                objAhsVuan.THANGXAYRA = objvuan.BA_THANG;
                objAhsVuan.NAMXAYRA = objvuan.BA_NAM;
                objAhsVuan.MAGIAIDOAN = 2;
                objAhsVuan.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                objAhsVuan.NGAYTAO = DateTime.Now;
                objAhsVuan.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                objAhsVuan.TOAANID = objvuan.BA_ST_TOAANID;
                objAhsVuan.GDTAOHS = 1;
                objAhsVuan.TOAANID_GDTAOHS = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                objAhsVuan.TOAPHUCTHAMID = objvuan.BA_PT_TOAANID;
                AHS_VUAN_BL dsBL = new AHS_VUAN_BL();
                objAhsVuan.TT = dsBL.GETNEWTT((decimal)objAhsVuan.TOAANID);
                objAhsVuan.MAVUAN = ENUM_LOAIVUVIEC.AN_HINHSU + Session[ENUM_SESSION.SESSION_MADONVI] + objAhsVuan.TT.ToString();

                dt.AHS_VUAN.Add(objAhsVuan);
                dt.SaveChanges();

                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE("1", objAhsVuan.ID, 2, Convert.ToDecimal(objAhsVuan.TOAANID), 0, 0, 0, 0);
                AHS_VUAN_GIAIDOAN objAhsVuAn_GiaiDoan = new AHS_VUAN_GIAIDOAN();

                if (objvuan.BA_PT_SO != null)
                {
                    AHS_PHUCTHAM_BANAN objAHSBAPT = null;
                    if (objSoTham_BanAn != null)
                    {
                        objAHSBAPT = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == objSoTham_BanAn.VUANID).FirstOrDefault();
                    }
                    else
                    {
                        objAHSBAPT = new AHS_PHUCTHAM_BANAN();
                    }

                    objAHSBAPT.VUANID = objAhsVuan.ID;
                    objAHSBAPT.TOAANID = objvuan.BA_PT_TOAANID;
                    objAHSBAPT.SOBANAN = objvuan.BA_PT_SO;
                    objAHSBAPT.NGAYBANAN = objvuan.BA_PT_NGAYBANAN;
                    if (objSoTham_BanAn != null)
                    {
                        objAHSBAPT.NGAYSUA = DateTime.Now;
                        objAHSBAPT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                    else
                    {
                        objAHSBAPT.NGAYTAO = DateTime.Now;
                        objAHSBAPT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.AHS_PHUCTHAM_BANAN.Add(objAHSBAPT);
                        dt.SaveChanges();
                    }
                }
                AHS_SOTHAM_BANAN objAHSBAST = null;
                if (objSoTham_BanAn != null)
                {
                    objAHSBAST = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == objSoTham_BanAn.VUANID).FirstOrDefault();
                }
                else
                {
                    objAHSBAST = new AHS_SOTHAM_BANAN();
                }

                objAHSBAST.VUANID = objAhsVuan.ID;
                objAHSBAST.TOAANID = objvuan.BA_ST_TOAANID;
                objAHSBAST.SOBANAN = objvuan.BA_ST_SO;
                objAHSBAST.NGAYBANAN = objvuan.BA_ST_NGAYBANAN;

                if (objSoTham_BanAn != null)
                {
                    objAHSBAST.NGAYSUA = DateTime.Now;
                    objAHSBAST.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                else
                {
                    objAHSBAST.NGAYTAO = DateTime.Now;
                    objAHSBAST.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.AHS_SOTHAM_BANAN.Add(objAHSBAST);
                    dt.SaveChanges();
                }
                IDAnHS = objAhsVuan.ID;
            }
            else
            {
                IDAnHS = Convert.ToDecimal(objvuan.IDVUANHETHONG);
            }
            AHS_BICANBICAO objAhsBiCan = new AHS_BICANBICAO();
            objAhsBiCan.VUANID = IDAnHS;
            objAhsBiCan.HOTEN = objbian.HOTEN;
            objAhsBiCan.TENKHAC = objbian.TENKHAC;
            objAhsBiCan.NGAYSINH = objbian.NGAYSINH;
            objAhsBiCan.THANGSINH = objbian.THANGSINH;
            objAhsBiCan.NAMSINH = objbian.NAMSINH;
            objAhsBiCan.SOCMND = objbian.SOCMND;
            objAhsBiCan.TAMTRU = objbian.TAMTRU;
            objAhsBiCan.TAMTRUCHITIET = objbian.TAMTRUCHITIET;
            objAhsBiCan.HKTT = objbian.HKTT;
            objAhsBiCan.KHTTCHITIET = objbian.KHTTCHITIET;
            objAhsBiCan.TRINHDOVANHOAID = objbian.TRINHDOVANHOAID;
            objAhsBiCan.NGHENGHIEPID = objbian.NGHENGHIEPID;
            objAhsBiCan.DANTOCID = objbian.DANTOCID;
            objAhsBiCan.QUOCTICHID = objbian.QUOCTICHID;
            objAhsBiCan.GIOITINH = objbian.GIOITINH;
            objAhsBiCan.TONGIAOID = objbian.TONGIAOID;
            objAhsBiCan.NGHIENHUT = objbian.NGHIENHUT;
            objAhsBiCan.TAIPHAM = objbian.TAIPHAM;
            objAhsBiCan.TIENAN = objbian.TIENAN;
            objAhsBiCan.TIENSU = objbian.TIENSU;
            objAhsBiCan.TREMOCOI = objbian.TREMOCOI;
            objAhsBiCan.BOMELYHON = objbian.BOMELYHON;
            objAhsBiCan.TREBOHOC = objbian.TREBOHOC;
            objAhsBiCan.TRELANGTHANG = objbian.TRELANGTHANG;
            objAhsBiCan.CONGUOIXUIGIUC = objbian.CONGUOIXUIGIUC;
            objAhsBiCan.CHUCVUDANGID = objbian.CHUCVUDANGID;
            objAhsBiCan.CHUCVUCHINHQUYENID = objbian.CHUCVUCHINHQUYENID;
            objAhsBiCan.ISTREVITHANHNIEN = objbian.ISTREVITHANHNIEN;
            objAhsBiCan.LOAIDOITUONG = objbian.LOAIDOITUONG;
            objAhsBiCan.HKTT_HUYEN = objbian.HKTT_HUYEN;
            objAhsBiCan.TAMTRU = objbian.TAMTRU;
            objAhsBiCan.TAIPHAMNGUYHIEM = null;
            objAhsBiCan.TUOI = (string.IsNullOrEmpty(txtTuoi.Text)) ? 0 : Convert.ToDecimal(txtTuoi.Text); ;
            objAhsBiCan.LOAITOIPHAMHS_ID = null;
            objAhsBiCan.BICANBICAOID_TACC = null;
            objAhsBiCan.BICANDAUVU = objbian.BICANDAUVU;
            objAhsBiCan.GDTAOHS = 1;
            objAhsBiCan.NGAYTAO = DateTime.Now;
            objAhsBiCan.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            objAhsBiCan.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            objvuan.NGAYSUA = DateTime.Now;
            objvuan.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            if (objbian.IDBICANHETHONG == 0 || objbian.IDBICANHETHONG == null)
            {
                objvuan.NGAYTAO = DateTime.Now;
                objvuan.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.AHS_BICANBICAO.Add(objAhsBiCan);
                dt.SaveChanges();
                objvuan.IDVUANHETHONG = IDAnHS;
                //objvuan.IDVUANHETHONG = 0;
                dt.SaveChanges();
            }

            objbian.IDVUANHETHONG = IDAnHS;
            objbian.IDBICANHETHONG = objAhsBiCan.ID;
            dt.SaveChanges();

            Update_CaoTrang_DieuLuat(objAhsBiCan.ID, IDAnHS, BiAnID , VuAnID);

        }
        void Update_CaoTrang_DieuLuat(Decimal IDBiAn, Decimal IDVuan , Decimal BiAnID , Decimal VuAnID)
        {
            DateTime date_temp;
            Boolean IsUpdate = false;

            AHS_SOTHAM_CAOTRANG_DIEULUAT AHS_DIEULUAT = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
            List<THA_SOTHAM_CAOTRANG_DIEULUAT> THA_DIEULUAT = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiAnID && x.VUANID == VuAnID).ToList();
            foreach (THA_SOTHAM_CAOTRANG_DIEULUAT dr in THA_DIEULUAT)
            {
                AHS_DIEULUAT.BICANID = IDBiAn;
                AHS_DIEULUAT.CAOTRANGID = dr.CAOTRANGID;
                AHS_DIEULUAT.DIEULUATID = dr.DIEULUATID;
                AHS_DIEULUAT.ISMAIN = dr.ISMAIN;
                AHS_DIEULUAT.NGAYTAO = DateTime.Now;
                AHS_DIEULUAT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                AHS_DIEULUAT.TENTOIDANH = dr.TENTOIDANH;
                AHS_DIEULUAT.TOIDANHID = dr.TOIDANHID;
                AHS_DIEULUAT.VUANID = IDVuan;

                dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(AHS_DIEULUAT);
                dt.SaveChanges();
            }
        }

        protected void cmdThemDieuLuat_Click(object sender, EventArgs e)
        {   
            lbthongbao.Text = "";
            Update_BiCao();
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            if (BiCanID > 0)
            {
                decimal luatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
                String Diem = txtDiem.Text.Trim();
                string Khoan = txtKhoan.Text.Trim();
                String Dieu = txtDieu.Text.Trim();

                DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
                int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
                DataTable tbl = objBL.SearchChinhXacTheoDK(luatid, Diem, Khoan, Dieu);
                if (tbl != null && tbl.Rows.Count == 1)
                {
                    foreach (DataRow row in tbl.Rows)
                        SaveToiDanh(row);
                    //-----------------------
                    hddPageIndex.Value = "1";
                    LoadGridToiDanh();
                    txtDiem.Text = txtKhoan.Text = txtDieu.Text = "";
                }
                else
                {
                    lbthongbao.Text = "Không có điều luật, tội danh này!";
                }
            }

            Cls_Comon.SetFocus(this, this.GetType(), cmdThemDieuLuat.ClientID);
        }

        void SaveToiDanh(DataRow rowToiDanh)
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);

            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            decimal toidanhid = Convert.ToDecimal(rowToiDanh["ID"] + "");

            //Lay ds cac cap cha cua toi danh duoc chon
            String ArrSapXep = "";
            String[] arrToiDanh = null;
            ArrSapXep = rowToiDanh["ArrSapXep"] + "";
            arrToiDanh = ArrSapXep.Split('/');
            if (arrToiDanh != null && arrToiDanh.Length > 0)
            {
                decimal ChuongID = Convert.ToDecimal(arrToiDanh[0] + "");
                foreach (String strToiDanhID in arrToiDanh)
                {
                    if (strToiDanhID.Length > 0 && strToiDanhID != ChuongID.ToString())
                    {
                        toidanhid = Convert.ToDecimal(strToiDanhID);
                        InsertToiDanh(BiCanID, VuAnID, toidanhid);
                    }
                }
                dt.SaveChanges();
            }

            lstMsgT.Text = lstMsgB.Text = "Lưu điều luật áp dụng cho bị can thành công!";
        }
        void InsertToiDanh(Decimal BiCanID, Decimal VuAnID, Decimal toidanhid)
        {
            bool isupdate = false;
            DM_BOLUAT_TOIDANH objTD = null;
            THA_SOTHAM_CAOTRANG_DIEULUAT obj = new THA_SOTHAM_CAOTRANG_DIEULUAT();
            try
            {
                obj = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID
                                                                && x.VUANID == VuAnID
                                                                && x.TOIDANHID == toidanhid
                                                            ).Single<THA_SOTHAM_CAOTRANG_DIEULUAT>();
                if (obj != null)
                    isupdate = true;
                else
                    obj = new THA_SOTHAM_CAOTRANG_DIEULUAT();
            }
            catch (Exception ex) { obj = new THA_SOTHAM_CAOTRANG_DIEULUAT(); }
            if (!isupdate)
            {
                obj.BICANID = BiCanID;
                obj.CAOTRANGID = 0;
                obj.VUANID = VuAnID;
                obj.DIEULUATID = Convert.ToDecimal(dropBoLuat.SelectedValue);
                obj.TOIDANHID = toidanhid;
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == toidanhid).Single();
                obj.TENTOIDANH = objTD.TENTOIDANH;
                obj.ISMAIN = 0;
                dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Add(obj);
                dt.SaveChanges();
            }
        }
        public void LoadGridToiDanh()
        {
            lbthongbao.Text = "";
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            Decimal BiCanID = Convert.ToDecimal(hddID.Value);

            if (BiCanID > 0)
            {
                //DateTime ngaybanhanh = DateTime.MinValue;
                //try
                //{
                //    ngaybanhanh = DateTime.MinValue;
                //}
                //catch (Exception ex) { }
                pnToiDanh.Visible = true;
                int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
                //GetNgayBH();

                THA_VUAN_BL objBL = new THA_VUAN_BL();

                DataTable tbl = objBL.GetAllPaging(BiCanID, VuAnID, luatid, 0, "", pageindex, pagesize);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                    #region "Xác định số lượng trang"
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                    lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    #endregion

                    rpt.DataSource = tbl;
                    rpt.DataBind();
                    pndata.Visible = true;
                }
                else
                {
                    pndata.Visible = false;
                    lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
                }
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                bool IsShowCommand = Convert.ToBoolean(hddShowCommand.Value);
                if (IsShowCommand)
                    lkXoa.Visible = true;
                else
                    lkXoa.Visible = false;
                if (hddShowCommand.Value == "False")
                {
                    lkXoa.Visible = false;
                }
            }
        }
        String LoadChiTietToiDanh(Decimal ToiDanhID, String ArrSapXep, int level)
        {
            DataRow[] arr = null;
            string[] temp = null;
            String RootId = "";
            String ToiDanhChinh = "", Temp_ToiDanh = "";
            temp = ArrSapXep.Split('/');

            RootId = temp[0] + "";
            string temp_sx = ArrSapXep.Replace("/", ",");
            //-------------------------

            /*select ID, LuatID, Chuong, Diem, Khoan, dieu, TenToiDanh, capChaID, Loai, ArrSapXep
             from DM_BoLuat_ToiDanh
             where Loai > 0 and LuatID in (select Id from DM_BoLuat where HieuLuc = 1 and Loai = '01');
             */
            int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            List<DM_BOLUAT_TOIDANH> lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == luatid
                                                                      && x.ARRSAPXEP.Contains(RootId + "/")
                                                                    ).OrderByDescending(y => y.LOAI).ToList();
            if (level > 1)
            {
                Decimal curr_id = 0;
                int loai = 0;
                foreach (string item in temp)
                {
                    if (item.Length > 0)
                    {
                        curr_id = Convert.ToDecimal(item);
                        foreach (DM_BOLUAT_TOIDANH itemTD in lst)
                        {
                            loai = (int)itemTD.LOAI;
                            if (curr_id == itemTD.ID)
                            {
                                if (Convert.ToDecimal(item) == ToiDanhID)
                                {
                                    switch (loai)
                                    {
                                        case 2:
                                            ToiDanhChinh += "<b>Điều: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 3:
                                            ToiDanhChinh += "<b>Khoản: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 4:
                                            ToiDanhChinh += "<b>Điểm: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                    }
                                }
                                else
                                {
                                    if (Temp_ToiDanh.Length > 0)
                                        Temp_ToiDanh += "<br/>";
                                    switch (loai)
                                    {
                                        case 2:
                                            Temp_ToiDanh += "<b>Điều: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 3:
                                            Temp_ToiDanh += "<b>Khoản: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 4:
                                            Temp_ToiDanh += "<b>Điểm: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                    }
                                }
                                //-------------------------
                                break;
                            }
                        }
                    }
                }
            }
            string strtoidanh = (Temp_ToiDanh.Length > 0) ? "<br/><i>(" + Temp_ToiDanh + ")</i>" : "";
            return (ToiDanhChinh + strtoidanh);
        }

        protected void cmdGetToiDanhDauVu_Click(object sender, EventArgs e)
        {
            
            THA_SOTHAM_CAOTRANG_DIEULUAT obj = null;
            Decimal BiCanDauVuID = 0;// (String.IsNullOrEmpty(hddBiCanDauVuID.Value)) ? 0 : Convert.ToDecimal(hddBiCanDauVuID.Value);

            try
            {
                THA_BIAN objBCDV = dt.THA_BIAN.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).Single();
                if (objBCDV != null)
                {
                    BiCanDauVuID = Convert.ToDecimal(objBCDV.ID);
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Không tìm thấy bị can đầu vụ!";
                //lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }

            Update_BiCao();
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            if (BiCanID > 0)
            {
                //lay ds toi danh ap dung cua bi can dau vu va them vao cho bị can dang nhap
                List<THA_SOTHAM_CAOTRANG_DIEULUAT> lst = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID && x.BICANID == BiCanDauVuID).ToList<THA_SOTHAM_CAOTRANG_DIEULUAT>();
                if (lst != null && lst.Count > 0)
                {
                    Boolean isupdate = false;
                    Decimal toidanhid = 0, boluatid = 0;
                    foreach (THA_SOTHAM_CAOTRANG_DIEULUAT item in lst)
                    {
                        isupdate = false;
                        obj = new THA_SOTHAM_CAOTRANG_DIEULUAT();
                        try
                        {
                            toidanhid = (Decimal)item.TOIDANHID;
                            boluatid = (Decimal)item.DIEULUATID;
                            obj = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID
                                                                            && x.VUANID == VuAnID
                                                                            && x.DIEULUATID == boluatid
                                                                            && x.TOIDANHID == toidanhid
                                                                        ).Single<THA_SOTHAM_CAOTRANG_DIEULUAT>();
                            if (obj != null)
                                isupdate = true;
                            else
                                obj = new THA_SOTHAM_CAOTRANG_DIEULUAT();
                        }
                        catch (Exception ex) { obj = new THA_SOTHAM_CAOTRANG_DIEULUAT(); }
                        if (!isupdate)
                        {
                            obj.BICANID = BiCanID;
                            obj.VUANID = VuAnID;
                            obj.DIEULUATID = boluatid;
                            obj.TOIDANHID = toidanhid;
                            obj.NGAYTAO = DateTime.Now;
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            obj.TENTOIDANH = item.TENTOIDANH + "";
                            obj.ISMAIN = String.IsNullOrEmpty(item.ISMAIN + "") ? 0 : item.ISMAIN;
                            dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Add(obj);
                        }
                    }
                    dt.SaveChanges();

                    //---------------------------
                    // cmdGetToiDanhDauVu.Visible = false;
                    hddPageIndex.Value = "1";
                    LoadGridToiDanh();
                    Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
                }
            }
        }
        protected void cmdLoadDsToiDanh_Click(object sender, EventArgs e)
        {
            LoadGridToiDanh();
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command = e.CommandName;
            decimal curr_id = Convert.ToDecimal(e.CommandArgument);
            if (command == "xoa")
            {
                try
                {
                    //string StrMsg = "Không được sửa đổi thông tin.";
                    //string Result = new THA_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg);
                    //if (Result != "")
                    //{
                    //    lstMsgT.Text = lstMsgB.Text = Result;
                    //    return;
                    //}
                    xoatoidanh(curr_id);
                }
                catch { }
            }
        }
        void xoatoidanh(decimal toidanhid)
        {
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value + "")) ? 0 : Convert.ToDecimal(hddID.Value);

            List<THA_SOTHAM_CAOTRANG_DIEULUAT> lst = null;
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByParentID(toidanhid);
            foreach (DataRow row in tbl.Rows)
            {
                toidanhid = Convert.ToDecimal(row["ID"] + "");
                try
                {
                    lst = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID
                                                               && x.BICANID == BiCanID
                                                               && x.TOIDANHID == toidanhid
                                                             ).ToList<THA_SOTHAM_CAOTRANG_DIEULUAT>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (THA_SOTHAM_CAOTRANG_DIEULUAT obj in lst)
                            dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Remove(obj);
                    }
                }
                catch (Exception ex) { }
            }
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadGridToiDanh();
            lbthongbao.Text = "Xóa thành công!";
            Cls_Comon.SetFocus(this, this.GetType(), txtDiem.ClientID);
        }
        protected void lkChoiceToiDanh_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValidate())
                    return;
                //string StrMsg = "Không được sửa đổi thông tin.";
                //string Result = new THA_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg);
                //if (Result != "")
                //{
                //    lstMsgT.Text = lstMsgB.Text = Result;
                //    lkChoiceToiDanh.Enabled = false;
                //    return;
                //}
                Save_BiCan();
                decimal BiCaoID = Convert.ToDecimal(hddID.Value);
                Cls_Comon.CallFunctionJS(this, this.GetType(), "popupChonToiDanh(" + VuAnID + "," + BiCaoID + ")");
            }
            catch (EntityDataSourceValidationException e1)
            {
                lbthongbao.ForeColor = System.Drawing.Color.Red;
                lbthongbao.Text = "Lỗi Entities: " + e1.Message;
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException ex)
            {
                string strErr = "";
                foreach (var eve in ex.EntityValidationErrors)
                {
                    foreach (var ve in eve.ValidationErrors)
                    {
                        strErr += ve.PropertyName + " : " + ve.ErrorMessage;
                    }
                }
                lbthongbao.ForeColor = System.Drawing.Color.Red;
                lbthongbao.Text = "Có lỗi, hãy thử lại: " + strErr;
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message + " | " + ex.InnerException.ToString(); }
        }
        void GetNgayBH()
        {
            //int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            //DM_BOLUAT_TOIDANH_BL obj = new DM_BOLUAT_TOIDANH_BL();
            //int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
            //DataTable tbl = obj.GetByDK(luatid, Loai_bo_luat, "", "", "", 1);
            //if (tbl != null && tbl.Rows.Count > 0)
            //{
            //    DataView view = new DataView(tbl);
            //    DataTable distinct_tbl = view.ToTable(true, "NgayBanHanh");
            //    dropNgayBH.Items.Clear();
            //   // dropNgayBH.Items.Add(new ListItem("-- Chọn -", ""));
            //    String NgayBH = "";
            //    foreach (DataRow row in distinct_tbl.Rows)
            //    {
            //        NgayBH = String.IsNullOrEmpty(row["NgayBanHanh"] + "") ? "" : Convert.ToDateTime(row["NgayBanHanh"]).ToString("dd/MM/yyyy", cul);
            //        if (NgayBH.Length > 0)
            //            dropNgayBH.Items.Add(new ListItem(NgayBH, NgayBH));
            //    }
            //}
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion

        protected void dropBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion

        #region Thong tin nhan than bi cao 
        protected void rptOtherNT_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        //Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn không có quyền xóa!");
                        return;
                    }
                    //string StrMsg = "Không được sửa đổi thông tin.";
                    //string Result = new THA_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg);
                    //if (Result != "")
                    //{
                    //    lstMsgT.Text = lstMsgB.Text = Result;
                    //    return;
                    //}

                    break;
            }
        }
        #endregion
        protected void lkThemCon_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = lstMsgT.Text = lstMsgB.Text = "";
            if (!CheckValidate())
                return;
            //string StrMsg = "Không được sửa đổi thông tin.";
            //string Result = new THA_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg);
            //if (Result != "")
            //{
            //    lstMsgT.Text = lstMsgB.Text = Result;
            //    return;
            //}
            Save_BiCan();
            //int soluong = Convert.ToDecimal(hddSoLuongCon.Value);
            //hddSoLuongCon.Value = (soluong + 1).ToString();
            Decimal BiCanID = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_nhanthan(" + VuAnID + "," + BiCanID + ")");
        }
    }
}


