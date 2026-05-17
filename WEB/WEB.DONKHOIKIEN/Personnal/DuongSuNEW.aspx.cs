using BL.DonKK;
using BL.DonKK.Model;
using BL.GSTP;
using DAL.DKK;
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

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class DuongSuNEW : System.Web.UI.Page
    {
        GSTPContext gsdt = new GSTPContext();
        DKKContextContainer dt = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        public int CurrYear = 0;
        public decimal CurrDonKK = 0, CurrVuViecID = 0;
        String temp = "";
        Decimal QuocTichVN = 0, UserID = 0;
        public String LoaiVuViec = "";
        public String TypeDuongSu = "";
        public string WidthCellNamSinh = "";

        String Value_NG = "NG";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                btnRemoveNguoiUyQuyen.Visible = false;

                string idEdit = Request["idEdit"];
                //thêm 1 người ủy quyền
                DONKK_DON_DUONGSU_TEMP Thongtinnguoiuyquyen = new DONKK_DON_DUONGSU_TEMP();
                if (idEdit != "0")
                {

                    btnAddNguoiUyQuyen.Visible = false;
                }
                else
                {
                    SetDataStoreSessionADDNEW(null);
                    lstData = GetDataStoreSessionADDNEW();
                    btnAddNguoiUyQuyen.Visible = true;
                }
                QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
                CurrYear = DateTime.Now.Year;
                LoaiVuViec = (string.IsNullOrEmpty(Request["loaivv"] + "")) ? "" : Request["loaivv"].ToString();
                CurrDonKK = (string.IsNullOrEmpty(Request["dkkID"] + "")) ? 0 : Convert.ToDecimal(Request["dkkID"] + "");
                UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                TypeDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();

                if (UserID > 0)
                {

                    Thongtinnguoiuyquyen.MALOAIVUVIEC = LoaiVuViec;
                    try
                    {
                        if (Request["loaids"] != null)
                        {
                            Thongtinnguoiuyquyen.TUCACHTOTUNG = TypeDuongSu;

                            WidthCellNamSinh = "margin-left:18px;";
                            switch (TypeDuongSu)
                            {
                                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                                    switch (LoaiVuViec)
                                    {
                                        case ENUM_LOAIAN.AN_DANSU:
                                            temp = "Thông tin người bị kiện khác";
                                            break;
                                        case ENUM_LOAIAN.AN_HANHCHINH:
                                            temp = "Thông tin người bị kiện khác";
                                            break;
                                        default:
                                            temp = "Thông tin người bị kiện khác";
                                            break;
                                    }
                                    break;
                                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                                    switch (LoaiVuViec)
                                    {
                                        case ENUM_LOAIAN.AN_DANSU:
                                            temp = "Thông tin người khởi kiện khác";
                                            break;
                                        case ENUM_LOAIAN.AN_HANHCHINH:
                                            temp = "Thông tin người khởi kiện khác";
                                            break;
                                        default:
                                            temp = "Thông tin người khởi kiện khác";
                                            break;
                                    }
                                    WidthCellNamSinh = "margin-left:9px;";
                                    Thongtinnguoiuyquyen.VALIDATENAMSINH = "<span class='batbuoc'>*</span>";
                                    Thongtinnguoiuyquyen.CHECKCMND = "<span class='batbuoc' id='span_CMND'>*</span>";
                                    break;
                                case ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN:
                                    temp = "Thông tin người ủy quyền";
                                    WidthCellNamSinh = "margin-left:9px;";
                                    Thongtinnguoiuyquyen.VALIDATENAMSINH = "<span class='batbuoc'>*</span>";
                                    Thongtinnguoiuyquyen.CHECKCMND = "<span class='batbuoc' id='span_CMND'>*</span>";

                                    break;
                                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                                    temp = "Thông tin đương sự có nghĩa vụ liên quan";
                                    Thongtinnguoiuyquyen.CHECKCMND = "";
                                    break;
                                case ENUM_DANSU_TUCACHTOTUNG.KHAC:
                                    temp = "Thông tin người tham gia tố tụng khác";
                                    break;
                            }
                            Thongtinnguoiuyquyen.TIEUDE = temp;
                        }

                    }
                    catch (Exception ex) { }

                    //----------------------
                    try
                    {
                        if (CurrDonKK > 0)
                            hddVuAn.Value = dt.DONKK_DON.Where(x => x.ID == CurrDonKK).Single<DONKK_DON>().VUANID.ToString();

                    }
                    catch (Exception ex) { }

                    //-----------------------------    

                    LoadGrid();




                    if (idEdit != "0")
                    {
                        //là sửa

                        rpt.DataSource = GetDataStoreSession().Where(s => s.ID_TEMP == idEdit);
                        rpt.DataBind();
                    }
                    else
                    {
                        lstData.Add(Thongtinnguoiuyquyen);
                        SetDataStoreSessionADDNEW(lstData);
                        rpt.DataSource = GetDataStoreSessionADDNEW();
                        rpt.DataBind();
                    }


                }
                else Response.Redirect("/Trangchu.aspx");


            }


        }
        protected void rptNguyenDonKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    xoa(ND_id);
                    LoadDsNguyenDonKhac();

                    break;
            }
        }
        void LoadDsNguyenDonKhac()
        {
            DataTable tbl = LoadDsDuongSuTheoMaTuCachTT(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptNguyenDonKhac.DataSource = tbl;
                rptNguyenDonKhac.DataBind();
            }
        }
        void Update_DonKK_DuongSu(Decimal DonKKID, String MaLoaiVuViec)
        {
            string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();
            string CurrUser = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            Decimal CurrUserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");

            //nếu không có ủy quyền
            try
            {
                //--------update cac loai duong su nhap bang popup-----
                List<DONKK_DON_DUONGSU> lstDS = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == 0
                                                                            && x.MALOAIVUVIEC == MaLoaiVuViec
                                                                            && x.NGUOITAOID == CurrUserID
                                                                          ).ToList<DONKK_DON_DUONGSU>();
                if (lstDS != null && lstDS.Count > 0)
                {
                    foreach (DONKK_DON_DUONGSU objDS in lstDS)
                    {
                        objDS.DONKKID = DonKKID;
                        dt.SaveChanges();
                    }
                }
            }
            catch (Exception ex) { }
        }

        public DataTable LoadDsDuongSuTheoMaTuCachTT(string ma_tucach_tt)
        {
            DataTable tbl = null;
            Decimal DonKKID = (string.IsNullOrEmpty(hddDKK.Value + "")) ? 0 : Convert.ToDecimal(hddDKK.Value);
            string MaLoaiVuViec = Request["loaivv"] + "";
            string CurrUserEmail = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            string temp = "";
            DONKK_DON_DUONGSU_BL oBL = new DONKK_DON_DUONGSU_BL();
            tbl = oBL.GetDuongSuByUser(UserID, DonKKID, MaLoaiVuViec, ma_tucach_tt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                temp = "";
                foreach (DataRow row in tbl.Rows)
                {
                    temp = (string.IsNullOrEmpty(row["TamTruChiTiet"] + "")) ? "" : row["TamTruChiTiet"].ToString();
                    temp += (string.IsNullOrEmpty(row["TamTru_Huyen"] + "")) ? "" : ((temp.Length > 0) ? ", " + row["TamTru_Huyen"].ToString() : row["TamTru_Huyen"].ToString());
                    temp += (string.IsNullOrEmpty(row["TamTru_Tinh"] + "")) ? "" : ((temp.Length > 0) ? ", " + row["TamTru_Tinh"].ToString() : row["TamTru_Tinh"].ToString());
                    row["TamTruChiTiet"] = temp;
                }
            }
            return tbl;
        }
        protected void rptCapNhat_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DropDownList dropCaNhan_TamTru_Tinh = (DropDownList)e.Item.FindControl("dropCaNhan_TamTru_Tinh");
                //if (dropCaNhan_TamTru_Tinh != null)
                //    dropCaNhan_TamTru_Tinh.Attributes.Add("onclick", "return false");

                DONKK_DON_DUONGSU_TEMP dataCurrent = new DONKK_DON_DUONGSU_TEMP();
                if (Request["idEdit"] != "0")
                {
                    //sửa
                    dataCurrent = GetDataStoreSession().FirstOrDefault(s => s.ID_TEMP == Request["idEdit"]);
                }
                else
                {
                    //thêm mới
                    lstData = GetDataStoreSessionADDNEW();
                    int index = e.Item.ItemIndex;
                    dataCurrent = lstData[index];
                }

                //load data drop loại don
                DropDownList dropLoaiDon = (DropDownList)e.Item.FindControl("dropLoaiDon");

                //load quốc tịch
                DropDownList ddlND_Quoctich = (DropDownList)e.Item.FindControl("ddlND_Quoctich");

                //load tư cách tố tụng  
                DropDownList ddlTucachTotung = (DropDownList)e.Item.FindControl("ddlTucachTotung");

                DropDownList dropToChuc_Tinh = (DropDownList)e.Item.FindControl("dropToChuc_Tinh");
                DropDownList ddlND_Gioitinh = (DropDownList)e.Item.FindControl("ddlND_Gioitinh");

                DropDownList dropToChuc_QuanHuyen = (DropDownList)e.Item.FindControl("dropToChuc_QuanHuyen");
                DropDownList dropCaNhan_TamTru_QuanHuyen = (DropDownList)e.Item.FindControl("dropCaNhan_TamTru_QuanHuyen");
                DropDownList ddlLoaiNguyendon = (DropDownList)e.Item.FindControl("ddlLoaiNguyendon");

                TextBox txtTenDuongSu = (TextBox)e.Item.FindControl("txtTenDuongSu");
                TextBox txtND_CMND = (TextBox)e.Item.FindControl("txtND_CMND");
                TextBox txtND_Ngaysinh = (TextBox)e.Item.FindControl("txtND_Ngaysinh");
                TextBox txtND_Namsinh = (TextBox)e.Item.FindControl("txtND_Namsinh");
                TextBox txtCaNhan_TamTru_DiaChiCT = (TextBox)e.Item.FindControl("txtCaNhan_TamTru_DiaChiCT");
                TextBox txtCaNhan_DiaChiCoQuan = (TextBox)e.Item.FindControl("txtCaNhan_DiaChiCoQuan");
                TextBox txtToChuc_DiaChiCT = (TextBox)e.Item.FindControl("txtToChuc_DiaChiCT");
                TextBox txtToChuc_NguoiDD = (TextBox)e.Item.FindControl("txtToChuc_NguoiDD");
                TextBox txtToChuc_NguoiDD_ChucVu = (TextBox)e.Item.FindControl("txtToChuc_NguoiDD_ChucVu");
                TextBox txtDienthoai = (TextBox)e.Item.FindControl("txtDienthoai");
                TextBox txtEmail = (TextBox)e.Item.FindControl("txtEmail");
                TextBox txtFax = (TextBox)e.Item.FindControl("txtFax");
                CheckBox chkONuocNgoai = (CheckBox)e.Item.FindControl("chkONuocNgoai");
                Panel pnNDCanhan = (Panel)e.Item.FindControl("pnNDCanhan");
                Panel pnNDTochuc = (Panel)e.Item.FindControl("pnNDTochuc");

                Literal lttValidateNamSinh = (Literal)e.Item.FindControl("lttValidateNamSinh");
                Literal lttTieuDe = (Literal)e.Item.FindControl("lttTieuDe");
                Literal lttCheckCMND = (Literal)e.Item.FindControl("lttCheckCMND");
                Label lblHoTen = (Label)e.Item.FindControl("lblHoTen");
                LoadCombobox(dropLoaiDon, ddlND_Quoctich, ddlTucachTotung, dropToChuc_Tinh, dropCaNhan_TamTru_Tinh, dropToChuc_QuanHuyen, dropCaNhan_TamTru_QuanHuyen);
                //gán data
                lttTieuDe.Text = "Thông tin người ủy quyền";
                dropLoaiDon.SelectedValue = dataCurrent.MALOAIVUVIEC;
                ddlTucachTotung.SelectedValue = dataCurrent.TUCACHTOTUNG;
                if (TypeDuongSu == ENUM_DANSU_TUCACHTOTUNG.KHAC)
                    ddlTucachTotung.Enabled = true;
                else
                    ddlTucachTotung.Enabled = false;
                lttValidateNamSinh.Text = dataCurrent.VALIDATENAMSINH;
                lttCheckCMND.Text = dataCurrent.CHECKCMND;
                ddlLoaiNguyendon.SelectedValue = dataCurrent.LOAIDUONGSU.HasValue ? dataCurrent.LOAIDUONGSU.Value.ToString() : "1";

                switch (ddlLoaiNguyendon.SelectedValue)
                {
                    case "1":
                        lblHoTen.Text = "Họ tên";
                        break;
                    case "2":
                        lblHoTen.Text = "Tên cơ quan";
                        break;
                    case "3":
                        lblHoTen.Text = "Tên tổ chức";
                        break;
                }
                lttCheckCMND.Text = "";
                if (ddlLoaiNguyendon.SelectedValue == "1")
                {
                    pnNDCanhan.Visible = true;
                    pnNDTochuc.Visible = false;
                    if (TypeDuongSu == "NGUYENDON" || TypeDuongSu == "UYQUYEN" || TypeDuongSu == "NGUOIUYQUYEN")
                    {
                        lttCheckCMND.Text = "<span class='batbuoc' id='span_CMND'>*</span>";
                        lttValidateNamSinh.Text = "<span class='batbuoc'>*</span>";
                    }

                }
                else
                {
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;

                }

                txtToChuc_DiaChiCT.Text = dataCurrent.NDD_DIACHICHITIET;
                txtTenDuongSu.Text = dataCurrent.TENDUONGSU;
                txtND_CMND.Text = dataCurrent.SOCMND;
                ddlND_Gioitinh.SelectedValue = dataCurrent.GIOITINH.HasValue ? dataCurrent.GIOITINH.Value.ToString() : "0";
                ddlND_Quoctich.SelectedValue = dataCurrent.QUOCTICHID.HasValue ? dataCurrent.QUOCTICHID.Value.ToString() : "0";

                txtCaNhan_TamTru_DiaChiCT.Text = dataCurrent.TAMTRUCHITIET;
                txtToChuc_NguoiDD.Text = dataCurrent.NGUOIDAIDIEN;
                txtToChuc_NguoiDD_ChucVu.Text = dataCurrent.CHUCVU;
                txtEmail.Text = dataCurrent.EMAIL;
                txtDienthoai.Text = dataCurrent.DIENTHOAI;
                txtFax.Text = dataCurrent.FAX;
                txtCaNhan_DiaChiCoQuan.Text = dataCurrent.DIACHICOQUAN;
                txtND_Ngaysinh.Text = (dataCurrent.NGAYSINH.HasValue) ? (dataCurrent.NGAYSINH.Value != DateTime.MinValue ? dataCurrent.NGAYSINH.Value.ToString("dd/MM/yyyy") : "") : "";
                txtND_Namsinh.Text = dataCurrent.NAMSINH.HasValue ? dataCurrent.NAMSINH.Value.ToString() : "";
                dropCaNhan_TamTru_Tinh.SelectedValue = dataCurrent.TAMTRUTINHID.HasValue ? dataCurrent.TAMTRUTINHID.Value.ToString() : "0";
                LoadDMHanhChinhByParentID(Convert.ToDecimal(dropCaNhan_TamTru_Tinh.SelectedValue), dropCaNhan_TamTru_QuanHuyen, true);
                dropCaNhan_TamTru_QuanHuyen.SelectedValue = dataCurrent.TAMTRUID.HasValue ? dataCurrent.TAMTRUID.Value.ToString() : "0";
                try
                {
                    var dm = gsdt.DM_HANHCHINH.Where(x => x.ID == dataCurrent.NDD_DIACHIID).FirstOrDefault<DM_HANHCHINH>();
                    if (dm != null)
                    {
                        dropToChuc_Tinh.SelectedValue = dm.CAPCHAID.ToString();
                        LoadDMHanhChinhByParentID(Convert.ToDecimal(dropToChuc_Tinh.SelectedValue), dropToChuc_QuanHuyen, true);
                        dropToChuc_QuanHuyen.SelectedValue = dataCurrent.NDD_DIACHIID + "";
                    }
                }

                catch (Exception ex) { }
                //if (dataCurrent.TUCACHTOTUNG== ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
                //{
                //    //dropToChuc_Tinh, dropToChuc_QuanHuyen, txtToChuc_DiaChiCT, txtToChuc_NguoiDD, txtToChuc_NguoiDD_ChucVu, txtEmail, txtDienthoai, txtFax, pnNDCanhan, pnNDTochuc
                //    LoadThongTinNguoiUyQuyen(dropLoaiDon, txtTenDuongSu, ddlLoaiNguyendon, txtND_CMND, ddlND_Quoctich, ddlTucachTotung, ddlND_Gioitinh, txtND_Ngaysinh, txtND_Namsinh, chkONuocNgoai, dropCaNhan_TamTru_Tinh, dropCaNhan_TamTru_QuanHuyen, txtCaNhan_TamTru_DiaChiCT, txtCaNhan_DiaChiCoQuan, dropToChuc_Tinh, dropToChuc_QuanHuyen, txtToChuc_DiaChiCT, txtToChuc_NguoiDD, txtToChuc_NguoiDD_ChucVu, txtEmail, txtDienthoai, txtFax, pnNDCanhan, pnNDTochuc);
                //}
            }
        }
        //----------------------------------------
        private void LoadCombobox(DropDownList dropLoaiDon, DropDownList ddlND_Quoctich, DropDownList ddlTucachTotung, DropDownList dropToChuc_Tinh, DropDownList dropCaNhan_TamTru_Tinh, DropDownList dropToChuc_QuanHuyen, DropDownList dropCaNhan_TamTru_QuanHuyen)
        {
            //load drop loai an 
            dropLoaiDon.Items.Clear();
            dropLoaiDon.Items.Add(new ListItem("Dân sự", ENUM_LOAIAN.AN_DANSU));
            dropLoaiDon.Items.Add(new ListItem("Hành chính", ENUM_LOAIAN.AN_HANHCHINH));
            dropLoaiDon.Items.Add(new ListItem("Hôn nhân - Gia đình", ENUM_LOAIAN.AN_HONNHAN_GIADINH));
            dropLoaiDon.Items.Add(new ListItem("Kinh doanh - Thương mại", ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI));
            dropLoaiDon.Items.Add(new ListItem("Lao động", ENUM_LOAIAN.AN_LAODONG));
            dropLoaiDon.Items.Add(new ListItem("Phá sản", ENUM_LOAIAN.AN_PHASAN));

            //---------------------------------
            LoadDropByGroupName(ddlND_Quoctich, ENUM_DANHMUC.QUOCTICH, false);

            //--------------------
            ddlTucachTotung.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            string tucachtt = "";
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTOTUNG_DS);
            if (Request["loaids"] != null)
                tucachtt = Request["loaids"].ToString();
            foreach (DataRow row in tbl.Rows)
            {

                if (tucachtt == ENUM_DANSU_TUCACHTOTUNG.KHAC)
                {
                    if (temp != ENUM_DANSU_TUCACHTOTUNG.BIDON
                        && temp != ENUM_DANSU_TUCACHTOTUNG.NGUYENDON
                        && temp != ENUM_DANSU_TUCACHTOTUNG.UYQUYEN)
                        ddlTucachTotung.Items.Add(new ListItem(row["TEN"] + "", row["MA"] + ""));
                }
                else
                    ddlTucachTotung.Items.Add(new ListItem(row["TEN"] + "", row["MA"] + ""));
            }

            //----------------------
            LoadDMHanhChinh(dropToChuc_Tinh, dropCaNhan_TamTru_Tinh, dropToChuc_QuanHuyen, dropCaNhan_TamTru_QuanHuyen);
        }
        void LoadDMHanhChinh(DropDownList dropToChuc_Tinh, DropDownList dropCaNhan_TamTru_Tinh, DropDownList dropToChuc_QuanHuyen, DropDownList dropCaNhan_TamTru_QuanHuyen)
        {
            //----------DM hanh chinh : tinh, Quan/huyen------------
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            Decimal ParentID = 0;
            DataTable tbl = obj.GetAllByParentID(ParentID);
            //----------------
            dropToChuc_Tinh.Items.Clear();
            dropToChuc_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropToChuc_Tinh, tbl);

            dropCaNhan_TamTru_Tinh.Items.Clear();
            dropCaNhan_TamTru_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
            LoadDMHanhChinh(dropCaNhan_TamTru_Tinh, tbl);
            try
            {
                ParentID = Convert.ToDecimal(dropToChuc_Tinh.SelectedValue);
                tbl = obj.GetAllByParentID(ParentID);

                dropToChuc_QuanHuyen.Items.Clear();
                dropToChuc_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                LoadDMHanhChinh(dropToChuc_QuanHuyen, tbl);

                dropCaNhan_TamTru_QuanHuyen.Items.Clear();
                dropCaNhan_TamTru_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện---", "0"));
                LoadDMHanhChinh(dropCaNhan_TamTru_QuanHuyen, tbl);
            }
            catch (Exception ex) { }
        }
        void LoadDMHanhChinh(DropDownList drop, DataTable tbl)
        {
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
            }
        }
        void LoadDMHanhChinhByParentID(Decimal ParentID, DropDownList drop, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
            DataTable tbl = obj.GetAllByParentID(ParentID);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("---Quận/Huyện---", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    drop.Items.Add(new ListItem(row["TEN"].ToString(), row["ID"].ToString()));
            }
            else
                drop.Items.Add(new ListItem("----Quận/Huyện---", "0"));
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("---Chọn---", "0"));
            foreach (DataRow row in tbl.Rows)
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
        }

        //----------------------------
        protected void dropToChuc_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList dropToChuc_Tinh_sender = (DropDownList)sender;
            foreach (RepeaterItem item in rpt.Items)
            {
                DropDownList dropToChuc_Tinh = (DropDownList)item.FindControl("dropToChuc_Tinh");
                DropDownList dropToChuc_QuanHuyen = (DropDownList)item.FindControl("dropToChuc_QuanHuyen");
                if (dropToChuc_Tinh_sender == dropToChuc_Tinh)
                {
                    try
                    {
                        LoadDMHanhChinhByParentID(Convert.ToDecimal(dropToChuc_Tinh.SelectedValue), dropToChuc_QuanHuyen, true);
                    }
                    catch (Exception ex) { }
                    Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_QuanHuyen.ClientID);
                    break;
                }

            }


        }

        protected void ddlND_Quoctich_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlND_Quoctich_sender = (DropDownList)sender;
            foreach (RepeaterItem item in rpt.Items)
            {
                DropDownList ddlND_Quoctich = (DropDownList)item.FindControl("ddlND_Quoctich");
                if (ddlND_Quoctich_sender == ddlND_Quoctich)
                {
                    Label lblQuanHuyen = (Label)item.FindControl("lblQuanHuyen");
                    DropDownList dropCaNhan_TamTru_QuanHuyen = (DropDownList)item.FindControl("dropCaNhan_TamTru_QuanHuyen");
                    DropDownList dropCaNhan_TamTru_Tinh = (DropDownList)item.FindControl("dropCaNhan_TamTru_Tinh");
                    CheckBox chkONuocNgoai = (CheckBox)item.FindControl("chkONuocNgoai");
                    TextBox txtND_Ngaysinh = (TextBox)item.FindControl("txtND_Ngaysinh");
                    lblQuanHuyen.Visible = true;
                    dropCaNhan_TamTru_QuanHuyen.Visible = true;

                    DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
                    Decimal ParentID = 0;
                    DataTable tbl = obj.GetAllByParentID(ParentID);
                    dropCaNhan_TamTru_Tinh.Items.Clear();
                    dropCaNhan_TamTru_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
                    LoadDMHanhChinh(dropCaNhan_TamTru_Tinh, tbl);
                    dropCaNhan_TamTru_QuanHuyen.Items.Clear();
                    dropCaNhan_TamTru_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện--", "0"));
                    chkONuocNgoai.Checked = false;
                    if (ddlND_Quoctich.SelectedValue == QuocTichVN.ToString())
                    {
                        chkONuocNgoai.Visible = true;
                        if (chkONuocNgoai.Checked)
                        {
                            lblQuanHuyen.Visible = false;
                            Add_ValueNG(dropCaNhan_TamTru_Tinh);
                        }
                        else
                            dropCaNhan_TamTru_Tinh.SelectedIndex = dropCaNhan_TamTru_QuanHuyen.SelectedIndex = 0;

                    }
                    else
                    {
                        chkONuocNgoai.Visible = false;
                        Add_ValueNG(dropCaNhan_TamTru_Tinh);
                        lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = false;
                    }
                    Cls_Comon.SetFocus(this, this.GetType(), txtND_Ngaysinh.ClientID);
                }

                break;
            }

        }


        protected void dropCaNhan_TamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList dropCaNhan_TamTru_Tinh_sender = (DropDownList)sender;
            foreach (RepeaterItem item in rpt.Items)
            {
                DropDownList dropCaNhan_TamTru_Tinh = (DropDownList)item.FindControl("dropCaNhan_TamTru_Tinh");
                if (dropCaNhan_TamTru_Tinh_sender == dropCaNhan_TamTru_Tinh)
                {
                    Label lblQuanHuyen = (Label)item.FindControl("lblQuanHuyen");
                    DropDownList dropCaNhan_TamTru_QuanHuyen = (DropDownList)item.FindControl("dropCaNhan_TamTru_QuanHuyen");
                    TextBox txtCaNhan_TamTru_DiaChiCT = (TextBox)item.FindControl("txtCaNhan_TamTru_DiaChiCT");
                    try
                    {
                        lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = true;
                        if (dropCaNhan_TamTru_Tinh.SelectedValue != Value_NG.ToString())
                        {
                            //chkONuocNgoai.Checked = false;
                            //if (chkONuocNgoai.Checked)
                            //{
                            //    Add_ValueNG(dropCaNhan_TamTru_Tinh);
                            //    lblQuanHuyen.Visible = false;
                            //    dropCaNhan_TamTru_QuanHuyen.Visible = false;
                            //    Cls_Comon.SetFocus(this, this.GetType(), txtCaNhan_TamTru_DiaChiCT.ClientID);
                            //}
                            //else
                            //{
                            lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = true;
                            LoadDMHanhChinhByParentID(Convert.ToDecimal(dropCaNhan_TamTru_Tinh.SelectedValue), dropCaNhan_TamTru_QuanHuyen, true);


                            Cls_Comon.SetFocus(this, this.GetType(), dropCaNhan_TamTru_QuanHuyen.ClientID);
                            //}
                        }
                        else
                        {
                            //chkONuocNgoai.Checked = false;
                            lblQuanHuyen.Visible = false;
                            dropCaNhan_TamTru_QuanHuyen.Visible = false;

                            Cls_Comon.SetFocus(this, this.GetType(), txtCaNhan_TamTru_DiaChiCT.ClientID);
                            lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = false;
                        }
                    }
                    catch (Exception ex) { }
                    break;
                }
            }

        }
        void Add_ValueNG(DropDownList drop)
        {
            if (drop.Items.FindByValue(Value_NG) != null)
                drop.SelectedValue = Value_NG;
            else
            {
                drop.Items.Add(new ListItem("Nước ngoài", Value_NG));
                drop.SelectedValue = Value_NG;
            }
        }
        protected void chkONuocNgoai_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chkONuocNgoai_sender = (CheckBox)sender;
            foreach (RepeaterItem item in rpt.Items)
            {
                CheckBox chkONuocNgoai = (CheckBox)item.FindControl("chkONuocNgoai");
                if (chkONuocNgoai_sender == chkONuocNgoai)
                {
                    DropDownList ddlND_Quoctich = (DropDownList)item.FindControl("ddlND_Quoctich");
                    DropDownList dropCaNhan_TamTru_Tinh = (DropDownList)item.FindControl("dropCaNhan_TamTru_Tinh");
                    DropDownList dropCaNhan_TamTru_QuanHuyen = (DropDownList)item.FindControl("dropCaNhan_TamTru_QuanHuyen");
                    Label lblQuanHuyen = (Label)item.FindControl("lblQuanHuyen");
                    Label lblNoiCutru = (Label)item.FindControl("lblNoiCutru");

                    if (ddlND_Quoctich.SelectedValue == QuocTichVN.ToString())
                    {
                        DM_HANHCHINH_BL obj = new DM_HANHCHINH_BL();
                        Decimal ParentID = 0;
                        DataTable tbl = obj.GetAllByParentID(ParentID);
                        dropCaNhan_TamTru_Tinh.Items.Clear();
                        dropCaNhan_TamTru_Tinh.Items.Add(new ListItem("---Tỉnh/Thành phố--", "0"));
                        LoadDMHanhChinh(dropCaNhan_TamTru_Tinh, tbl);

                        dropCaNhan_TamTru_QuanHuyen.Items.Clear();
                        dropCaNhan_TamTru_QuanHuyen.Items.Add(new ListItem("---Quận/Huyện--", "0"));
                        if (chkONuocNgoai.Checked)
                        {
                            Add_ValueNG(dropCaNhan_TamTru_Tinh);
                            lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = false;
                        }
                        else
                            lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = true;
                    }
                    else
                    {
                        dropCaNhan_TamTru_QuanHuyen.SelectedIndex = 0;
                        Add_ValueNG(dropCaNhan_TamTru_Tinh);
                        lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = false;
                    }
                    if (chkONuocNgoai.Checked)
                    {
                        lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = false;
                        lblNoiCutru.Visible = dropCaNhan_TamTru_Tinh.Visible = false;
                    }
                    else
                    {
                        lblQuanHuyen.Visible = dropCaNhan_TamTru_QuanHuyen.Visible = true;
                        lblNoiCutru.Visible = dropCaNhan_TamTru_Tinh.Visible = true;
                    }

                    Cls_Comon.SetFocus(this, this.GetType(), dropCaNhan_TamTru_Tinh.ClientID);
                    break;
                }
            }

        }

        //---------------------------------------
        protected void cmdClose_Click(object sender, EventArgs e)
        {
            //int IsReloadParent = (string.IsNullOrEmpty(hddReloadParent.Value)) ? 0 : Convert.ToInt16(hddReloadParent.Value);
            //if(IsReloadParent==1)
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
            //else
            //    Cls_Comon.CallFunctionJS(this, this.GetType(), "window.close();");
        }
        private List<DONKK_DON_DUONGSU_TEMP> GetDataStoreSession()
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP" + IdUser;
            if (Session[Key] == null)
            {
                return new List<DONKK_DON_DUONGSU_TEMP>();
            }
            else
            {
                return (List<DONKK_DON_DUONGSU_TEMP>)Session[Key];
            }
        }
        private void SetDataStoreSession(List<DONKK_DON_DUONGSU_TEMP> data)
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP" + IdUser;
            Session[Key] = data;
        }

        private List<DONKK_DON_DUONGSU_TEMP> GetDataStoreSessionADDNEW()
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP_ADDNEW" + IdUser;
            if (Session[Key] == null)
            {
                return new List<DONKK_DON_DUONGSU_TEMP>();
            }
            else
            {
                return (List<DONKK_DON_DUONGSU_TEMP>)Session[Key];
            }
        }
        private void SetDataStoreSessionADDNEW(List<DONKK_DON_DUONGSU_TEMP> data)
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            string Key = "DONKK_DON_DUONGSU_TEMP_ADDNEW" + IdUser;
            Session[Key] = data;
        }

        List<DONKK_DON_DUONGSU_TEMP> lstData;
        protected void btnAddNguoiUyQuyen_Click(object sender, EventArgs e)
        {
            SetDataStoreSessionADDNEW(null);
            foreach (RepeaterItem item in rpt.Items)
            {
                TextBox txtTenDuongSu = (TextBox)item.FindControl("txtTenDuongSu");
                TextBox txtND_CMND = (TextBox)item.FindControl("txtND_CMND");
                TextBox txtND_Ngaysinh = (TextBox)item.FindControl("txtND_Ngaysinh");
                TextBox txtFax = (TextBox)item.FindControl("txtFax");
                TextBox txtND_Namsinh = (TextBox)item.FindControl("txtND_Namsinh");
                TextBox txtToChuc_NguoiDD = (TextBox)item.FindControl("txtToChuc_NguoiDD");
                TextBox txtToChuc_NguoiDD_ChucVu = (TextBox)item.FindControl("txtToChuc_NguoiDD_ChucVu");
                TextBox txtEmail = (TextBox)item.FindControl("txtEmail");
                TextBox txtDienthoai = (TextBox)item.FindControl("txtDienthoai");
                TextBox txtCaNhan_TamTru_DiaChiCT = (TextBox)item.FindControl("txtCaNhan_TamTru_DiaChiCT");
                TextBox txtCaNhan_DiaChiCoQuan = (TextBox)item.FindControl("txtCaNhan_DiaChiCoQuan");
                TextBox txtToChuc_DiaChiCT = (TextBox)item.FindControl("txtToChuc_DiaChiCT");
                DropDownList ddlTucachTotung = (DropDownList)item.FindControl("ddlTucachTotung");
                DropDownList ddlND_Gioitinh = (DropDownList)item.FindControl("ddlND_Gioitinh");
                DropDownList ddlLoaiNguyendon = (DropDownList)item.FindControl("ddlLoaiNguyendon");
                DropDownList ddlND_Quoctich = (DropDownList)item.FindControl("ddlND_Quoctich");
                DropDownList dropCaNhan_TamTru_Tinh = (DropDownList)item.FindControl("dropCaNhan_TamTru_Tinh");
                DropDownList dropToChuc_QuanHuyen = (DropDownList)item.FindControl("dropToChuc_QuanHuyen");
                DropDownList dropCaNhan_TamTru_QuanHuyen = (DropDownList)item.FindControl("dropCaNhan_TamTru_QuanHuyen");
                Literal lttTieuDe = (Literal)item.FindControl("lttTieuDe");
                CheckBox chkONuocNgoai = (CheckBox)item.FindControl("chkONuocNgoai");
                HiddenField hddDuongSuID = (HiddenField)item.FindControl("hddDuongSuID");
                string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();
                Literal lttCheckCMND = (Literal)item.FindControl("lttCheckCMND");
                Label lblHoTen = (Label)item.FindControl("lblHoTen");
                Panel pnNDCanhan = (Panel)item.FindControl("pnNDCanhan");
                Panel pnNDTochuc = (Panel)item.FindControl("pnNDTochuc");
                DropDownList dropToChuc_Tinh = (DropDownList)item.FindControl("dropToChuc_Tinh");
                Literal lttValidateNamSinh = (Literal)item.FindControl("lttValidateNamSinh");

                lttCheckCMND.Text = "";
                if (ddlLoaiNguyendon.SelectedValue == "1")
                {
                    pnNDCanhan.Visible = true;
                    pnNDTochuc.Visible = false;
                    TypeDuongSu = ddlTucachTotung.SelectedValue;
                    if (TypeDuongSu == "NGUYENDON" || TypeDuongSu == "UYQUYEN" || TypeDuongSu == "NGUOIUYQUYEN")
                    {

                        lttCheckCMND.Text = "<span class='batbuoc' id='span_CMND'>*</span>";
                    }
                    if (String.IsNullOrEmpty(txtTenDuongSu.Text.Trim()))
                        Cls_Comon.SetFocus(this, this.GetType(), txtTenDuongSu.ClientID);
                    else
                        Cls_Comon.SetFocus(this, this.GetType(), txtND_CMND.ClientID);
                }
                else
                {
                    pnNDCanhan.Visible = false;
                    pnNDTochuc.Visible = true;
                    if (String.IsNullOrEmpty(txtTenDuongSu.Text.Trim()))
                        Cls_Comon.SetFocus(this, this.GetType(), txtTenDuongSu.ClientID);
                    else
                        Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_Tinh.ClientID);
                }


                DONKK_DON_DUONGSU_TEMP oND = new DONKK_DON_DUONGSU_TEMP();
                oND.VALIDATENAMSINH = lttValidateNamSinh.Text;
                //else
                //oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
                oND.ID_TEMP = Guid.NewGuid().ToString();
                oND.DONKKID = 0;
                oND.ISDON = 1;
                oND.DUONGSUID = 0;
                oND.STOPVB = 0;

                oND.TIEUDE = lttTieuDe.Text;
                oND.TENDUONGSU = Cls_Comon.FormatTenRieng(txtTenDuongSu.Text.Trim());
                oND.ISDAIDIEN = 0;
                oND.TUCACHTOTUNG_MA = ddlTucachTotung.SelectedValue;
                if (LoaiDuongSu == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
                {
                    oND.ISDAIDIEN = 1;
                    oND.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                }

                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                oND.SOCMND = txtND_CMND.Text;
                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                oND.QUOCTICHNAME = ddlND_Quoctich.SelectedItem.Text;
                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;
                oND.THANGSINH = 0;
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.NGUOIDAIDIEN = txtToChuc_NguoiDD.Text;
                oND.CHUCVU = txtToChuc_NguoiDD_ChucVu.Text;
                oND.EMAIL = txtEmail.Text;
                oND.DIENTHOAI = txtDienthoai.Text;
                oND.SINHSONG_NUOCNGOAI = chkONuocNgoai.Checked == true ? 1 : 0;
                oND.FAX = txtFax.Text;
                //----------------------
                if (oND.LOAIDUONGSU == 1)
                {
                    try
                    {
                        if (dropCaNhan_TamTru_Tinh.SelectedValue != Value_NG)
                        {
                            oND.TAMTRUTINHID = oND.HKTTTINHID = Convert.ToDecimal(dropCaNhan_TamTru_Tinh.SelectedValue);
                            oND.TAMTRUID = oND.HKTTID = Convert.ToDecimal(dropCaNhan_TamTru_QuanHuyen.SelectedValue);
                        }
                        else
                        {
                            oND.TAMTRUTINHID = oND.HKTTTINHID = oND.TAMTRUID = oND.HKTTID = 0;
                        }
                    }
                    catch (Exception exx) { oND.TAMTRUID = 0; }
                    oND.TAMTRUCHITIET = oND.HKTTCHITIET = txtCaNhan_TamTru_DiaChiCT.Text;

                    oND.DIACHICOQUAN = txtCaNhan_DiaChiCoQuan.Text.Trim() + "";
                }

                //----------------------
                try
                {
                    oND.NDD_DIACHIID = Convert.ToDecimal(dropToChuc_QuanHuyen.SelectedValue);
                }
                catch (Exception exx) { oND.NDD_DIACHIID = 0; }
                oND.NDD_DIACHICHITIET = txtToChuc_DiaChiCT.Text;

                //----------------------             
                oND.TUCACHTOTUNG = ddlTucachTotung.SelectedItem.Text;
                oND.MALOAIVUVIEC = Request["loaivv"] + "";
                oND.NGAYTAO = DateTime.Now;
                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oND.NGUOITAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                lstData = GetDataStoreSessionADDNEW();
                lstData.Add(oND);
                SetDataStoreSessionADDNEW(lstData);

            }
            btnRemoveNguoiUyQuyen.Visible = true;
            DONKK_DON_DUONGSU_TEMP donkk_ds = new DONKK_DON_DUONGSU_TEMP();
            donkk_ds.TIEUDE = "Thông tin người ủy quyền";
            lstData = GetDataStoreSessionADDNEW();
            lstData.Add(donkk_ds);
            SetDataStoreSessionADDNEW(lstData);
            rpt.DataSource = GetDataStoreSessionADDNEW();
            rpt.DataBind();
        }
        //btnRemoveNguoiUyQuyen_Click
        protected void btnRemoveNguoiUyQuyen_Click(object sender, EventArgs e)
        {
            SetDataStoreSessionADDNEW(null);
            foreach (RepeaterItem item in rpt.Items)
            {
                TextBox txtTenDuongSu = (TextBox)item.FindControl("txtTenDuongSu");
                TextBox txtND_CMND = (TextBox)item.FindControl("txtND_CMND");
                TextBox txtND_Ngaysinh = (TextBox)item.FindControl("txtND_Ngaysinh");
                TextBox txtFax = (TextBox)item.FindControl("txtFax");
                TextBox txtND_Namsinh = (TextBox)item.FindControl("txtND_Namsinh");
                TextBox txtToChuc_NguoiDD = (TextBox)item.FindControl("txtToChuc_NguoiDD");
                TextBox txtToChuc_NguoiDD_ChucVu = (TextBox)item.FindControl("txtToChuc_NguoiDD_ChucVu");
                TextBox txtEmail = (TextBox)item.FindControl("txtEmail");
                TextBox txtDienthoai = (TextBox)item.FindControl("txtDienthoai");
                TextBox txtCaNhan_TamTru_DiaChiCT = (TextBox)item.FindControl("txtCaNhan_TamTru_DiaChiCT");
                TextBox txtCaNhan_DiaChiCoQuan = (TextBox)item.FindControl("txtCaNhan_DiaChiCoQuan");
                TextBox txtToChuc_DiaChiCT = (TextBox)item.FindControl("txtToChuc_DiaChiCT");
                DropDownList ddlTucachTotung = (DropDownList)item.FindControl("ddlTucachTotung");
                DropDownList ddlND_Gioitinh = (DropDownList)item.FindControl("ddlND_Gioitinh");
                DropDownList ddlLoaiNguyendon = (DropDownList)item.FindControl("ddlLoaiNguyendon");
                DropDownList ddlND_Quoctich = (DropDownList)item.FindControl("ddlND_Quoctich");
                DropDownList dropCaNhan_TamTru_Tinh = (DropDownList)item.FindControl("dropCaNhan_TamTru_Tinh");
                DropDownList dropToChuc_QuanHuyen = (DropDownList)item.FindControl("dropToChuc_QuanHuyen");
                DropDownList dropCaNhan_TamTru_QuanHuyen = (DropDownList)item.FindControl("dropCaNhan_TamTru_QuanHuyen");
                Literal lttTieuDe = (Literal)item.FindControl("lttTieuDe");
                CheckBox chkONuocNgoai = (CheckBox)item.FindControl("chkONuocNgoai");
                HiddenField hddDuongSuID = (HiddenField)item.FindControl("hddDuongSuID");
                string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();
                Literal lttValidateNamSinh = (Literal)item.FindControl("lttValidateNamSinh");
                DONKK_DON_DUONGSU_TEMP oND = new DONKK_DON_DUONGSU_TEMP();

                //else
                //oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
                oND.ID_TEMP = Guid.NewGuid().ToString();
                oND.DONKKID = 0;
                oND.ISDON = 1;
                oND.DUONGSUID = 0;
                oND.STOPVB = 0;
                oND.VALIDATENAMSINH = lttValidateNamSinh.Text;
                oND.TIEUDE = lttTieuDe.Text;
                oND.TENDUONGSU = Cls_Comon.FormatTenRieng(txtTenDuongSu.Text.Trim());
                oND.ISDAIDIEN = 0;
                oND.TUCACHTOTUNG_MA = ddlTucachTotung.SelectedValue;
                if (LoaiDuongSu == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
                {
                    oND.ISDAIDIEN = 1;
                    oND.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                }

                oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                oND.SOCMND = txtND_CMND.Text;
                oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                oND.QUOCTICHNAME = ddlND_Quoctich.SelectedItem.Text;
                DateTime dNDNgaysinh;
                dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYSINH = dNDNgaysinh;
                oND.THANGSINH = 0;
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.NGUOIDAIDIEN = txtToChuc_NguoiDD.Text;
                oND.CHUCVU = txtToChuc_NguoiDD_ChucVu.Text;
                oND.EMAIL = txtEmail.Text;
                oND.DIENTHOAI = txtDienthoai.Text;
                oND.SINHSONG_NUOCNGOAI = chkONuocNgoai.Checked == true ? 1 : 0;
                oND.FAX = txtFax.Text;
                //----------------------
                if (oND.LOAIDUONGSU == 1)
                {
                    try
                    {
                        if (dropCaNhan_TamTru_Tinh.SelectedValue != Value_NG)
                        {
                            oND.TAMTRUTINHID = oND.HKTTTINHID = Convert.ToDecimal(dropCaNhan_TamTru_Tinh.SelectedValue);
                            oND.TAMTRUID = oND.HKTTID = Convert.ToDecimal(dropCaNhan_TamTru_QuanHuyen.SelectedValue);
                        }
                        else
                        {
                            oND.TAMTRUTINHID = oND.HKTTTINHID = oND.TAMTRUID = oND.HKTTID = 0;
                        }
                    }
                    catch (Exception exx) { oND.TAMTRUID = 0; }
                    oND.TAMTRUCHITIET = oND.HKTTCHITIET = txtCaNhan_TamTru_DiaChiCT.Text;

                    oND.DIACHICOQUAN = txtCaNhan_DiaChiCoQuan.Text.Trim() + "";
                }

                //----------------------
                try
                {
                    oND.NDD_DIACHIID = Convert.ToDecimal(dropToChuc_QuanHuyen.SelectedValue);
                }
                catch (Exception exx) { oND.NDD_DIACHIID = 0; }
                oND.NDD_DIACHICHITIET = txtToChuc_DiaChiCT.Text;

                //----------------------             
                oND.TUCACHTOTUNG = ddlTucachTotung.SelectedItem.Text;
                oND.MALOAIVUVIEC = Request["loaivv"] + "";
                oND.NGAYTAO = DateTime.Now;
                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oND.NGUOITAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                lstData = GetDataStoreSessionADDNEW();
                lstData.Add(oND);
                SetDataStoreSessionADDNEW(lstData);

            }
            if (lstData.Count <= 2)
            {
                btnRemoveNguoiUyQuyen.Visible = false;
            }
            else
            {
                btnRemoveNguoiUyQuyen.Visible = true;
            }
            var dataRemove = lstData[lstData.Count - 1];
            var lstDataStoreSession = GetDataStoreSession();
            var dataRemoveStoreSession = lstDataStoreSession.FirstOrDefault(s => s.ID_TEMP == dataRemove.ID_TEMP);

            lstData.Remove(dataRemove);
            SetDataStoreSessionADDNEW(lstData);

            if (dataRemoveStoreSession != null)
            {
                lstDataStoreSession.Remove(dataRemoveStoreSession);
            }
            SetDataStoreSession(lstDataStoreSession);
            rpt.DataSource = GetDataStoreSessionADDNEW();
            rpt.DataBind();
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {

            lbthongbao.Text = "";
            try
            {
                if (!CheckValid())
                    return;
                foreach (RepeaterItem item in rpt.Items)
                {
                    TextBox txtTenDuongSu = (TextBox)item.FindControl("txtTenDuongSu");
                    TextBox txtND_CMND = (TextBox)item.FindControl("txtND_CMND");
                    TextBox txtND_Ngaysinh = (TextBox)item.FindControl("txtND_Ngaysinh");
                    TextBox txtFax = (TextBox)item.FindControl("txtFax");
                    TextBox txtND_Namsinh = (TextBox)item.FindControl("txtND_Namsinh");
                    TextBox txtToChuc_NguoiDD = (TextBox)item.FindControl("txtToChuc_NguoiDD");
                    TextBox txtToChuc_NguoiDD_ChucVu = (TextBox)item.FindControl("txtToChuc_NguoiDD_ChucVu");
                    TextBox txtEmail = (TextBox)item.FindControl("txtEmail");
                    TextBox txtDienthoai = (TextBox)item.FindControl("txtDienthoai");
                    TextBox txtCaNhan_TamTru_DiaChiCT = (TextBox)item.FindControl("txtCaNhan_TamTru_DiaChiCT");
                    TextBox txtCaNhan_DiaChiCoQuan = (TextBox)item.FindControl("txtCaNhan_DiaChiCoQuan");
                    TextBox txtToChuc_DiaChiCT = (TextBox)item.FindControl("txtToChuc_DiaChiCT");
                    DropDownList ddlTucachTotung = (DropDownList)item.FindControl("ddlTucachTotung");
                    DropDownList ddlND_Gioitinh = (DropDownList)item.FindControl("ddlND_Gioitinh");
                    DropDownList ddlLoaiNguyendon = (DropDownList)item.FindControl("ddlLoaiNguyendon");
                    DropDownList ddlND_Quoctich = (DropDownList)item.FindControl("ddlND_Quoctich");
                    DropDownList dropCaNhan_TamTru_Tinh = (DropDownList)item.FindControl("dropCaNhan_TamTru_Tinh");
                    DropDownList dropToChuc_QuanHuyen = (DropDownList)item.FindControl("dropToChuc_QuanHuyen");
                    DropDownList dropCaNhan_TamTru_QuanHuyen = (DropDownList)item.FindControl("dropCaNhan_TamTru_QuanHuyen");

                    CheckBox chkONuocNgoai = (CheckBox)item.FindControl("chkONuocNgoai");
                    HiddenField hddDuongSuID = (HiddenField)item.FindControl("hddDuongSuID");
                    string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();
                    Literal lttCheckCMND = (Literal)item.FindControl("lttCheckCMND");
                    Label lblHoTen = (Label)item.FindControl("lblHoTen");
                    Panel pnNDCanhan = (Panel)item.FindControl("pnNDCanhan");
                    Panel pnNDTochuc = (Panel)item.FindControl("pnNDTochuc");
                    DropDownList dropToChuc_Tinh = (DropDownList)item.FindControl("dropToChuc_Tinh");
                    Literal lttValidateNamSinh = (Literal)item.FindControl("lttValidateNamSinh");
                    lttCheckCMND.Text = "";
                    if (ddlLoaiNguyendon.SelectedValue == "1")
                    {
                        pnNDCanhan.Visible = true;
                        pnNDTochuc.Visible = false;
                        TypeDuongSu = ddlTucachTotung.SelectedValue;
                        if (TypeDuongSu == "NGUYENDON" || TypeDuongSu == "UYQUYEN" || TypeDuongSu == "NGUOIUYQUYEN")
                        {
                            lttCheckCMND.Text = "<span class='batbuoc' id='span_CMND'>*</span>";
                        }
                        if (String.IsNullOrEmpty(txtTenDuongSu.Text.Trim()))
                            Cls_Comon.SetFocus(this, this.GetType(), txtTenDuongSu.ClientID);
                        else
                            Cls_Comon.SetFocus(this, this.GetType(), txtND_CMND.ClientID);
                    }
                    else
                    {
                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        if (String.IsNullOrEmpty(txtTenDuongSu.Text.Trim()))
                            Cls_Comon.SetFocus(this, this.GetType(), txtTenDuongSu.ClientID);
                        else
                            Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_Tinh.ClientID);
                    }

                    decimal ID = (string.IsNullOrEmpty(hddDuongSuID.Value + "")) ? 0 : Convert.ToDecimal(hddDuongSuID.Value);
                    DONKK_DON_DUONGSU oND = new DONKK_DON_DUONGSU();
                    if (ID == 0)
                    {

                    }
                    //oND.VALIDATENAMSINH = lttValidateNamSinh.Text;
                    //else
                    //oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
                    //oND.ID_TEMP = Guid.NewGuid().ToString();
                    oND.DONKKID = 0;
                    oND.ISDON = 1;
                    oND.DUONGSUID = 0;
                    oND.STOPVB = 0;


                    oND.TENDUONGSU = Cls_Comon.FormatTenRieng(txtTenDuongSu.Text.Trim());
                    oND.ISDAIDIEN = 0;
                    oND.TUCACHTOTUNG_MA = ddlTucachTotung.SelectedValue;
                    if (LoaiDuongSu == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
                    {
                        oND.ISDAIDIEN = 1;
                        oND.TUCACHTOTUNG_MA = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
                    }

                    oND.LOAIDUONGSU = Convert.ToDecimal(ddlLoaiNguyendon.SelectedValue);
                    oND.SOCMND = txtND_CMND.Text;
                    oND.QUOCTICHID = Convert.ToDecimal(ddlND_Quoctich.SelectedValue);
                    //oND.QUOCTICHNAME = ddlND_Quoctich.SelectedItem.Text;
                    DateTime dNDNgaysinh;
                    dNDNgaysinh = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oND.NGAYSINH = dNDNgaysinh;
                    oND.THANGSINH = 0;
                    oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                    oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                    oND.NGUOIDAIDIEN = txtToChuc_NguoiDD.Text;
                    oND.CHUCVU = txtToChuc_NguoiDD_ChucVu.Text;
                    oND.EMAIL = txtEmail.Text;
                    oND.DIENTHOAI = txtDienthoai.Text;
                    oND.SINHSONG_NUOCNGOAI = chkONuocNgoai.Checked == true ? 1 : 0;
                    oND.FAX = txtFax.Text;
                    //----------------------
                    if (oND.LOAIDUONGSU == 1)
                    {
                        try
                        {
                            if (dropCaNhan_TamTru_Tinh.SelectedValue != Value_NG)
                            {
                                oND.TAMTRUTINHID = oND.HKTTTINHID = Convert.ToDecimal(dropCaNhan_TamTru_Tinh.SelectedValue);
                                oND.TAMTRUID = oND.HKTTID = Convert.ToDecimal(dropCaNhan_TamTru_QuanHuyen.SelectedValue);
                            }
                            else
                            {
                                oND.TAMTRUTINHID = oND.HKTTTINHID = oND.TAMTRUID = oND.HKTTID = 0;
                            }
                        }
                        catch (Exception exx) { oND.TAMTRUID = 0; }
                        oND.TAMTRUCHITIET = oND.HKTTCHITIET = txtCaNhan_TamTru_DiaChiCT.Text;

                        oND.DIACHICOQUAN = txtCaNhan_DiaChiCoQuan.Text.Trim() + "";
                    }

                    //----------------------
                    try
                    {
                        oND.NDD_DIACHIID = Convert.ToDecimal(dropToChuc_QuanHuyen.SelectedValue);
                    }
                    catch (Exception exx) { oND.NDD_DIACHIID = 0; }
                    oND.NDD_DIACHICHITIET = txtToChuc_DiaChiCT.Text;

                    //----------------------             
                    oND.TUCACHTOTUNG = ddlTucachTotung.SelectedItem.Text;
                    oND.MALOAIVUVIEC = Request["loaivv"] + "";
                    if (Request["idEdit"] == "0")
                    {
                        oND.NGAYTAO = DateTime.Now;
                        oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oND.NGUOITAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                        //dt.DONKK_DON_DUONGSU.Add(oND);
                        //dt.SaveChanges();

                        //if (CurrDonKK > 0)
                        //    GhiLog("THEM", oND.TENDUONGSU,ddlTucachTotung);
                        lstData = GetDataStoreSessionADDNEW();
                        //lstData[item.ItemIndex] = oND;
                        SetDataStoreSessionADDNEW(lstData);
                    }
                    else
                    {
                        oND.NGAYSUA = DateTime.Now;
                        oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oND.NGUOITAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                        int index = GetDataStoreSession().IndexOf(GetDataStoreSession().FirstOrDefault(s => s.ID_TEMP == Request["idEdit"]));
                        lstData = GetDataStoreSession();
                        //lstData[index] = oND;
                        SetDataStoreSession(lstData);

                        //dt.SaveChanges();
                        //if (CurrDonKK > 0)
                        //    GhiLog("SUA", oND.TENDUONGSU, ddlTucachTotung);
                    }
                    dt.DONKK_DON_DUONGSU.Add(oND);
                    dt.SaveChanges();
                    LoadGrid();
                    //---------------------------
                    try
                    {
                        //DONKK_DON_DUONGSU_BL oDonBL = new DONKK_DON_DUONGSU_BL();
                        //oDonBL.Update_YeuToNuocNgoai(CurrDonKK, QuocTichVN);
                    }
                    catch (Exception ex) { }
                }


                //-------------------
                //ResetControls();
                lbthongbao.Text = "Lưu thành công!";
                if (Request["idEdit"] == "0")
                {
                    lstData = GetDataStoreSessionADDNEW();
                    var lstDATAstore = GetDataStoreSession();
                    lstDATAstore.AddRange(lstData);
                    SetDataStoreSession(lstDATAstore);

                    //với trường hợp thêm mới thì reset
                    SetDataStoreSessionADDNEW(null);
                    DONKK_DON_DUONGSU_TEMP donkk_ds = new DONKK_DON_DUONGSU_TEMP();
                    donkk_ds.TIEUDE = "Thông tin người ủy quyền";
                    lstData = GetDataStoreSessionADDNEW();
                    lstData.Add(donkk_ds);
                    SetDataStoreSessionADDNEW(lstData);
                    if (lstData.Count <= 2)
                    {
                        btnRemoveNguoiUyQuyen.Visible = false;
                    }
                    else
                    {
                        btnRemoveNguoiUyQuyen.Visible = true;
                    }
                    rpt.DataSource = GetDataStoreSessionADDNEW();
                    rpt.DataBind();
                }
                hddReloadParent.Value = "1";
                //Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
                return;
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
        }
        //private void ResetControls()
        //{
        //    txtTenDuongSu.Text = "";
        //    txtND_CMND.Text = "";
        //    txtND_Ngaysinh.Text = "";
        //    chkONuocNgoai.Checked = false;
        //    txtND_Namsinh.Text = "";
        //    txtCaNhan_TamTru_DiaChiCT.Text = "";
        //    txtCaNhan_DiaChiCoQuan.Text = "";
        //    txtToChuc_NguoiDD.Text = "";
        //    txtEmail.Text = txtDienthoai.Text = txtFax.Text = "";
        //    hddDuongSuID.Value = "0";
        //}

        private bool CheckValid()
        {
            foreach (RepeaterItem item in rpt.Items)
            {
                TextBox txtTenDuongSu = (TextBox)item.FindControl("txtTenDuongSu");
                TextBox txtND_Namsinh = (TextBox)item.FindControl("txtND_Namsinh");
                TextBox txtND_CMND = (TextBox)item.FindControl("txtND_CMND");
                DropDownList ddlLoaiNguyendon = (DropDownList)item.FindControl("ddlLoaiNguyendon");
                DONKK_DON_DUONGSU oDS = dt.DONKK_DON_DUONGSU.Where(x => x.SOCMND == txtND_CMND.Text).FirstOrDefault();
                if (oDS != null) { lbthongbao.Text = "Trùng số CMND với người ủy quyền"; return false; }
                //if (txtTenDuongSu.Text == "")
                //{
                //    lbthongbao.Text = "Chưa nhập tên đương sự";
                //    txtTenDuongSu.Focus();
                //    return false;
                //}
                //if (ddlLoaiNguyendon.SelectedValue == "1")
                //{
                //    string tucachtt = Request["loaids"].ToString();

                //    if (tucachtt == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON || tucachtt == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
                //    {
                //        if (txtND_Namsinh.Text == "")
                //        {
                //            lbthongbao.Text = "Chưa nhập năm sinh";
                //            txtND_Namsinh.Focus();
                //            return false;
                //        }

                //    }

                //    //if (lblBatbuoc1.Text != "")
                //    //{
                //    //    if (hddND_HKTTID.Value == "")
                //    //    {
                //    //        lbthongbao.Text = "Chưa chọn nơi đăng ký HKTT";
                //    //        return false;
                //    //    }
                //    //    if (hdd_ND_TramtruID.Value == "")
                //    //    {
                //    //        lbthongbao.Text = "Chưa chọn nơi đăng ký tạm trú";
                //    //        return false;
                //    //    }
                //    //}
                //}
            }

            return true;
        }

        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            TextBox txtND_Ngaysinh_sender = (TextBox)sender;
            foreach (RepeaterItem item in rpt.Items)
            {
                TextBox txtND_Ngaysinh = (TextBox)item.FindControl("txtND_Ngaysinh");
                if (txtND_Ngaysinh_sender == txtND_Ngaysinh)
                {
                    TextBox txtND_Namsinh = (TextBox)item.FindControl("txtND_Namsinh");
                    CheckBox chkONuocNgoai = (CheckBox)item.FindControl("chkONuocNgoai");

                    String str_now = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    DateTime now = DateTime.Parse(str_now, cul, DateTimeStyles.NoCurrentDateDefault);

                    DateTime d;
                    d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (d != DateTime.MinValue)
                    {
                        if (d > now)
                        {
                            Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", "Ngày sinh không thể lớn hơn ngày hiện tại. Hãy kiểm tra lại!");
                            Cls_Comon.SetFocus(this, this.GetType(), txtND_Ngaysinh.ClientID);
                        }
                        else
                        {
                            txtND_Namsinh.Text = d.Year.ToString();
                            // chkONuocNgoai.Focus();
                            Cls_Comon.SetFocus(this, this.GetType(), chkONuocNgoai.ClientID);
                        }
                    }
                    break;
                }
            }

        }
        protected void txtND_Namsinh_TextChanged(object sender, EventArgs e)
        {
            TextBox txtND_Namsinh_sender = (TextBox)sender;
            foreach (RepeaterItem item in rpt.Items)
            {
                TextBox txtND_Namsinh = (TextBox)item.FindControl("txtND_Namsinh");
                if (txtND_Namsinh_sender == txtND_Namsinh)
                {
                    TextBox txtND_Ngaysinh = (TextBox)item.FindControl("txtND_Ngaysinh");
                    CheckBox chkONuocNgoai = (CheckBox)item.FindControl("chkONuocNgoai");
                    int namsinh = 0;
                    if (!String.IsNullOrEmpty(txtND_Ngaysinh.Text))
                    {
                        if (!String.IsNullOrEmpty(txtND_Namsinh.Text))
                        {
                            namsinh = Convert.ToInt32(txtND_Namsinh.Text);
                            DateTime date_temp;
                            date_temp = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            if (date_temp != DateTime.MinValue)
                            {
                                String ngaysinh = txtND_Ngaysinh.Text.Trim();
                                String[] arr = ngaysinh.Split('/');

                                txtND_Ngaysinh.Text = arr[0] + "/" + arr[1] + "/" + namsinh.ToString();
                            }
                        }
                    }
                    if (!String.IsNullOrEmpty(txtND_Namsinh.Text))
                    {
                        namsinh = Convert.ToInt32(txtND_Namsinh.Text);
                        if (namsinh > DateTime.Now.Year)
                        {
                            Cls_Comon.ShowMessageZone(this, this.GetType(), "zone_message", "Năm sinh không thể lớn hơn Năm hiện tại. Hãy kiểm tra lại!");
                            Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
                        }
                    }
                    Cls_Comon.SetFocus(this, this.GetType(), chkONuocNgoai.ClientID);
                    break;
                }
            }

        }

        protected void ddlLoaiNguyendon_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlLoaiNguyendon_sender = (DropDownList)sender;
            foreach (RepeaterItem item in rpt.Items)
            {
                DropDownList ddlLoaiNguyendon = (DropDownList)item.FindControl("ddlLoaiNguyendon");
                if (ddlLoaiNguyendon_sender == ddlLoaiNguyendon)
                {
                    Literal lttCheckCMND = (Literal)item.FindControl("lttCheckCMND");
                    Label lblHoTen = (Label)item.FindControl("lblHoTen");
                    Panel pnNDCanhan = (Panel)item.FindControl("pnNDCanhan");
                    Panel pnNDTochuc = (Panel)item.FindControl("pnNDTochuc");
                    TextBox txtTenDuongSu = (TextBox)item.FindControl("txtTenDuongSu");
                    TextBox txtND_CMND = (TextBox)item.FindControl("txtND_CMND");
                    DropDownList dropToChuc_Tinh = (DropDownList)item.FindControl("dropToChuc_Tinh");
                    switch (ddlLoaiNguyendon.SelectedValue)
                    {
                        case "1":
                            lblHoTen.Text = "Họ tên";
                            break;
                        case "2":
                            lblHoTen.Text = "Tên cơ quan";
                            break;
                        case "3":
                            lblHoTen.Text = "Tên tổ chức";
                            break;
                    }
                    lttCheckCMND.Text = "";
                    if (ddlLoaiNguyendon.SelectedValue == "1")
                    {
                        pnNDCanhan.Visible = true;
                        pnNDTochuc.Visible = false;
                        if (TypeDuongSu == "NGUYENDON" || TypeDuongSu == "UYQUYEN" || TypeDuongSu == "NGUOIUYQUYEN")
                        {
                            lttCheckCMND.Text = "<span class='batbuoc' id='span_CMND'>*</span>";
                        }
                        if (String.IsNullOrEmpty(txtTenDuongSu.Text.Trim()))
                            Cls_Comon.SetFocus(this, this.GetType(), txtTenDuongSu.ClientID);
                        else
                            Cls_Comon.SetFocus(this, this.GetType(), txtND_CMND.ClientID);
                    }
                    else
                    {
                        pnNDCanhan.Visible = false;
                        pnNDTochuc.Visible = true;
                        if (String.IsNullOrEmpty(txtTenDuongSu.Text.Trim()))
                            Cls_Comon.SetFocus(this, this.GetType(), txtTenDuongSu.ClientID);
                        else
                            Cls_Comon.SetFocus(this, this.GetType(), dropToChuc_Tinh.ClientID);
                    }
                    break;
                }
            }

        }

        //------------------------------
        void LoadThongTinNguoiUyQuyen(DropDownList dropLoaiDon, TextBox txtTenDuongSu, DropDownList ddlLoaiNguyendon, TextBox txtND_CMND, DropDownList ddlND_Quoctich, DropDownList ddlTucachTotung, DropDownList ddlND_Gioitinh, TextBox txtND_Ngaysinh, TextBox txtND_Namsinh, CheckBox chkONuocNgoai, DropDownList dropCaNhan_TamTru_Tinh, DropDownList dropCaNhan_TamTru_QuanHuyen, TextBox txtCaNhan_TamTru_DiaChiCT, TextBox txtCaNhan_DiaChiCoQuan, DropDownList dropToChuc_Tinh, DropDownList dropToChuc_QuanHuyen, TextBox txtToChuc_DiaChiCT, TextBox txtToChuc_NguoiDD, TextBox txtToChuc_NguoiDD_ChucVu, TextBox txtEmail, TextBox txtDienthoai, TextBox txtFax, Panel pnNDCanhan, Panel pnNDTochuc)
        {
            string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();
            CurrDonKK = (string.IsNullOrEmpty(Request["dkkID"] + "")) ? 0 : Convert.ToDecimal(Request["dkkID"] + "");
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            string CurrUser = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            String MaLoaiVV = Request["loaivv"] + "";
            if (LoaiDuongSu == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
            {
                try
                {
                    //DONKK_DON_DUONGSU oND = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == CurrDonKK
                    //                                                     && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON
                    //                                                     && x.ISDAIDIEN == 1
                    //                                                     && x.MALOAIVUVIEC == MaLoaiVV
                    //                                                     && x.NGUOITAO == CurrUser
                    //                                                  ).FirstOrDefault();
                    lstData = GetDataStoreSession();
                    if (lstData.Count == 0)
                    {
                        //chưa có dữ liệu

                    }
                    if (lstData.Count > 0)
                    {

                        Load_ThongTinDS(lstData, dropLoaiDon, txtTenDuongSu, ddlLoaiNguyendon, txtND_CMND, ddlND_Quoctich, ddlTucachTotung, ddlND_Gioitinh, txtND_Ngaysinh, txtND_Namsinh, chkONuocNgoai, dropCaNhan_TamTru_Tinh, dropCaNhan_TamTru_QuanHuyen, txtCaNhan_TamTru_DiaChiCT, txtCaNhan_DiaChiCoQuan, dropToChuc_Tinh, dropToChuc_QuanHuyen, txtToChuc_DiaChiCT, txtToChuc_NguoiDD, txtToChuc_NguoiDD_ChucVu, txtEmail, txtDienthoai, txtFax, pnNDCanhan, pnNDTochuc);
                    }
                }
                catch (Exception ex) { }
            }
        }

        void loadedit(decimal ID)
        {
            //DONKK_DON_DUONGSU oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == ID).FirstOrDefault();
            //if (oND != null)
            //{
            //    //hddDuongSuID.Value = oND.ID.ToString();
            //    //Load_ThongTinDS(oND);
            //}
        }
        void Load_ThongTinDS(List<DONKK_DON_DUONGSU_TEMP> lstData, DropDownList dropLoaiDon, TextBox txtTenDuongSu, DropDownList ddlLoaiNguyendon, TextBox txtND_CMND, DropDownList ddlND_Quoctich, DropDownList ddlTucachTotung, DropDownList ddlND_Gioitinh, TextBox txtND_Ngaysinh, TextBox txtND_Namsinh, CheckBox chkONuocNgoai, DropDownList dropCaNhan_TamTru_Tinh, DropDownList dropCaNhan_TamTru_QuanHuyen, TextBox txtCaNhan_TamTru_DiaChiCT, TextBox txtCaNhan_DiaChiCoQuan, DropDownList dropToChuc_Tinh, DropDownList dropToChuc_QuanHuyen, TextBox txtToChuc_DiaChiCT, TextBox txtToChuc_NguoiDD, TextBox txtToChuc_NguoiDD_ChucVu, TextBox txtEmail, TextBox txtDienthoai, TextBox txtFax, Panel pnNDCanhan, Panel pnNDTochuc)
        {
            //string LoaiDuongSu = (string.IsNullOrEmpty(Request["loaids"] + "")) ? "" : Request["loaids"].ToString();

            //DM_HANHCHINH dm = null;
            //DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();

            //dropLoaiDon.SelectedValue = oND.MALOAIVUVIEC;

            //txtTenDuongSu.Text = oND.TENDUONGSU;
            //ddlLoaiNguyendon.SelectedValue = oND.LOAIDUONGSU.ToString();
            //txtND_CMND.Text = oND.SOCMND;
            //ddlND_Quoctich.SelectedValue = oND.QUOCTICHID.ToString();
            //if (LoaiDuongSu == ENUM_DANSU_TUCACHTOTUNG.NGUOIUYQUYEN)
            //    ddlTucachTotung.SelectedValue = ENUM_DANSU_TUCACHTOTUNG.NGUYENDON;
            //else
            //    ddlTucachTotung.SelectedValue = oND.TUCACHTOTUNG_MA;

            //#region Thong tin ca nhan
            ////-------------------------------
            //ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            //if (oND.NGAYSINH != DateTime.MinValue)
            //    txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
            //txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            //if (oND.SINHSONG_NUOCNGOAI != null)
            //    chkONuocNgoai.Checked = oND.SINHSONG_NUOCNGOAI == 1 ? true : false;
            //if (ddlND_Quoctich.SelectedIndex > 0)
            //    chkONuocNgoai.Visible = false;
            //else
            //    chkONuocNgoai.Visible = true;

            //try
            //{
            //    dropCaNhan_TamTru_Tinh.SelectedValue = oND.TAMTRUTINHID.ToString();
            //    dropCaNhan_TamTru_Tinh_SelectedIndexChanged(null, null);
            //    LoadDMHanhChinhByParentID(Convert.ToDecimal(dropCaNhan_TamTru_Tinh.SelectedValue), dropCaNhan_TamTru_QuanHuyen, true);
            //    dropCaNhan_TamTru_QuanHuyen.SelectedValue = oND.TAMTRUID + "";
            //}
            //catch (Exception ex) { }
            //txtCaNhan_TamTru_DiaChiCT.Text = oND.TAMTRUCHITIET;
            //txtCaNhan_DiaChiCoQuan.Text = oND.DIACHICOQUAN;

            //#endregion

            ////------------------------------------
            //#region  Nguoi dai dien cho to chuc-----------------
            //try
            //{
            //    dm = gsdt.DM_HANHCHINH.Where(x => x.ID == oND.NDD_DIACHIID).Single<DM_HANHCHINH>();
            //    if (dm != null)
            //    {
            //        dropToChuc_Tinh.SelectedValue = dm.CAPCHAID.ToString();
            //        LoadDMHanhChinhByParentID(Convert.ToDecimal(dropToChuc_Tinh.SelectedValue), dropToChuc_QuanHuyen, true);
            //        dropToChuc_QuanHuyen.SelectedValue = oND.NDD_DIACHIID + "";
            //    }
            //}

            //catch (Exception ex) { }
            //txtToChuc_DiaChiCT.Text = oND.NDD_DIACHICHITIET;
            //txtToChuc_NguoiDD.Text = oND.NGUOIDAIDIEN;
            //txtToChuc_NguoiDD_ChucVu.Text = oND.CHUCVU;
            //#endregion

            ////--------------------------------
            //txtEmail.Text = oND.EMAIL + "";
            //txtDienthoai.Text = oND.DIENTHOAI + "";
            //txtFax.Text = oND.FAX;

            //if (ddlLoaiNguyendon.SelectedValue == "1")
            //{
            //    pnNDCanhan.Visible = true;
            //    pnNDTochuc.Visible = false;
            //}
            //else
            //{
            //    pnNDCanhan.Visible = false;
            //    pnNDTochuc.Visible = true;
            //}
        }

        //------------------------
        //#region Load DS
        public void LoadGrid()
        {
            decimal CurrDonKK = (string.IsNullOrEmpty(Request["dkkID"] + "")) ? 0 : Convert.ToDecimal(Request["dkkID"] + "");
            decimal VuAnID = Convert.ToDecimal(hddVuAn.Value);
            string tucachtt = Request["loaids"].ToString();
            String MaLoaiVuViec = Request["loaivv"] + "";
            string CurrUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            List<DONKK_DON_DUONGSU> lst = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == CurrDonKK
                                                                       && x.MALOAIVUVIEC == MaLoaiVuViec
                                                                       && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON
                                                                       && x.ISDAIDIEN == 1
                                                                     ).ToList();

            //DONKK_DON_DUONGSU_BL oBL = new DONKK_DON_DUONGSU_BL();
            //DataTable tbl = oBL.GetDuongSuByUser(UserID, CurrDonKK, tucachtt, MaLoaiVuViec);
            if (lst != null && lst.Count > 0)
            {
                rptNguyenDonKhac.Visible = true;
                rptNguyenDonKhac.DataSource = lst;
                rptNguyenDonKhac.DataBind();
            }
            else rptNguyenDonKhac.Visible = false;
        }
        public void xoa(decimal id)
        {
            //KT: Neu da co GSTP.DonID --> xoa trong phan GSTP 
            //ko co --> xoa trong DOnKK
            DONKK_DON_DUONGSU oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            dt.DONKK_DON_DUONGSU.Remove(oND);
            dt.SaveChanges();
            LoadGrid();
            //ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }

    }
}