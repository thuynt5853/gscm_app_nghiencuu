using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using BL.GSTP.GDTTT;
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

namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class ThongtinvuanHS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";
        String SessionTTV = "GDTTT_TTV";
        public decimal VuAnID = 0;
        public int nguoikhieunai = 2;
        public int bicao = 0;
        public int bcdauvu = 1;
        public String type = "";
        public decimal CurrNhomNSDID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            VuAnID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
            // CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    chkModify_LanhDao.Visible = chkModify_TP.Visible = chkModify_TTV.Visible = false;
                    LoadComponent();
                    LoadDropToiDanh(dropDieuLuat);
                    if (Request["ID"] != null)
                    {
                        hddVuAnID.Value = Request["ID"] + "";
                        try
                        {
                            LoadInfoVuAn();

                            LoadDanhSachBiCao();
                            LoadDanhSachNguoiKN();

                            if (ddlLoaiBA.SelectedValue == "2")
                            {
                                LoadDropToaST_Full_ST();//anhvh 14/11/2019
                            }
                        }
                        catch (Exception ex) { }
                    }
                    if (Request["ID"] == null)
                    {
                        GetVuanID();

                    }
                    if (Request["type"] != null)
                    {
                        type = Request["type"] + "";
                        if (type == "renew")
                        {
                            lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
                            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công! Bạn có thể tiếp tục cập nhật vụ án mới";
                        }
                        else if (type == "new")
                        {
                            SetFormNewBiCao();
                        }
                    }
                    txtSoThuLy.Focus();
                    CheckCongbo();
                    //----------------
                }
            }
            else Response.Redirect("/Login.aspx");
        }

        private void LoadDropToiDanh(DropDownList dropDieuLuat)
        {
            string session_name = "HS_DropToiDanh";
            dropDieuLuat.Items.Clear();
            GDTTT_APP_BL oBL = new GDTTT_APP_BL();
            DataTable tbl = new DataTable();
            //-------------
            tbl = oBL.DieuLuat_ToiDanh_Thongke();
            if (Session[session_name] == null)
            {
                tbl = oBL.DieuLuat_ToiDanh_Thongke();
                Session[session_name] = tbl;
            }
            else
                tbl = (DataTable)(Session[session_name]);

            dropDieuLuat.DataSource = tbl;
            dropDieuLuat.DataTextField = "TENTOIDANH";
            dropDieuLuat.DataValueField = "ID";
            dropDieuLuat.DataBind();
            dropDieuLuat.Items.Insert(0, new ListItem("Chọn", "0"));
        }

        void SetFormNewBiCao()
        {
            pnThuLyDon.Visible = true;

        }
        //-------------------------------------------
        void LoadComponent()
        {
            LoadDropToaAnGDT(dropToaGDT);
            LoadDropToaAn(dropToaAn);
            LoadLoaiAnTheoVu();
            try
            {
                LoadDropLanhDao();
                LoadDropTTV();
                LoadThamPhan();
            }
            catch (Exception ex) { }
            hddGUID.Value = Guid.NewGuid().ToString();
        }
        void LoadDropNamSinh(DropDownList ddlNamsinh)
        {
            ddlNamsinh.Items.Clear();
            int year = DateTime.Now.Year;
            for (int i = year; i >= year - 100; i--)
            {
                ListItem li = new ListItem(i.ToString());
                ddlNamsinh.Items.Add(li);
            }
            ddlNamsinh.Items.Insert(0, new ListItem("Chọn", "0"));
            //ddlNamsinh.Items.FindByText(year.ToString()).Selected = true;

        }
        void LoadDropToaAn(DropDownList dropToaAn)
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAn.DataSource = dtTA;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        //-- lay danh muc tòa CC và Toi cao
        void LoadDropToaAnGDT(DropDownList dropToaGDT)
        {
            dropToaGDT.Items.Clear();
            List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.CAPCHAID < 2 && x.HANHCHINHID != 0).OrderBy(y => y.CAPCHAID).ToList();
            dropToaGDT.DataSource = lst;
            dropToaGDT.DataTextField = "TEN";
            dropToaGDT.DataValueField = "ID";
            dropToaGDT.DataBind();
            dropToaGDT.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropToaPT_TheoGDT(decimal ToaGDT_ID)
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            //Decimal CapChaID = Convert.ToDecimal(dropToaGDT.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(ToaGDT_ID);
            dropToaAn.DataSource = tbl;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropToaST_TheoPT(decimal ToaPT_ID)
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            //Decimal CapChaID = Convert.ToDecimal(dropToaAn.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(ToaPT_ID);
            dropToaAnST.DataSource = tbl;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadLoaiAnTheoVu()
        {
            int count_loaian = 0;
            dropLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
            if (obj.ISHINHSU == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                count_loaian++;
            }
            //if (obj.ISDANSU == 1)
            //{
            //    dropLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            //    count_loaian++;
            //}
            //if (obj.ISHANHCHINH == 1)
            //{
            //    dropLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            //    count_loaian++;
            //}
            //if (obj.ISHNGD == 1)
            //{
            //    dropLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            //    count_loaian++;
            //}
            //if (obj.ISKDTM == 1)
            //{
            //    dropLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            //    count_loaian++;
            //}
            //if (obj.ISLAODONG == 1)
            //{
            //    dropLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            //    count_loaian++;
            //}
            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            //if (count_loaian > 1)
            //    dropLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        //----------------------------------------
        protected void dropToaGDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnAnST.Visible = false;
            decimal toa_an_id = Convert.ToDecimal(dropToaGDT.SelectedValue);
            if (toa_an_id > 0)
            {
                DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                if (obj != null)
                {
                    pnPhucTham.Visible = true;
                    pnAnST.Visible = true;
                    Cls_Comon.SetFocus(this, this.GetType(), lttBB_SoPT.ClientID);
                    LoadDropToaPT_TheoGDT(Convert.ToDecimal(toa_an_id));
                }
                else { dropToaAn.Items.Clear(); }
                string banan_gdt = txtSoQĐGDT.Text.Trim();
                if (!string.IsNullOrEmpty(banan_gdt)) Cls_Comon.SetFocus(this, this.GetType(), txtSoQĐGDT.ClientID);
            }
            else
            {
                pnQDGDT.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaGDT.ClientID);
                dropToaGDT.Items.Clear();
                pnAnST.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaAn.ClientID);
                dropToaAnST.Items.Clear();
            }
        }
        //----------------------------------------
        protected void dropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnAnST.Visible = false;
            decimal toa_an_id = Convert.ToDecimal(dropToaAn.SelectedValue);
            if (toa_an_id > 0)
            {
                DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                if (obj != null)//&& (obj.LOAITOA == "CAPCAO" || obj.LOAITOA == "CAPTINH"))
                {
                    pnAnST.Visible = true;
                    Cls_Comon.SetFocus(this, this.GetType(), txtSoBA_ST.ClientID);
                    LoadDropToaST_TheoPT(toa_an_id);
                }
                else { dropToaAnST.Items.Clear(); }
                string banan_pt = txtSoBA.Text.Trim();
                if (!string.IsNullOrEmpty(banan_pt)) Cls_Comon.SetFocus(this, this.GetType(), txtSoBA.ClientID);

            }
            else
            {
                pnAnST.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaAn.ClientID);
                dropToaAnST.Items.Clear();
            }

        }
        //--------------------------------
        void LoadDropLanhDao()
        {
            dropLanhDao.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DataTable tblLanhDao = obj.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);
            if (tblLanhDao != null && tblLanhDao.Rows.Count > 0)
            {
                dropLanhDao.DataSource = tblLanhDao;
                dropLanhDao.DataValueField = "ID";
                dropLanhDao.DataTextField = "MA_TEN";
                dropLanhDao.DataBind();
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropTTV()
        {
            dropTTV.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTTV.DataSource = tbl;
                dropTTV.DataValueField = "CanBoID";
                dropTTV.DataTextField = "TenCanBo";
                dropTTV.DataBind();
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void GetAllLanhDaoNhanBCTheoTTV(Decimal ThamTraVienID)
        {
            LoadDropLanhDao();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            GDTTT_CACVU_CAUHINH_BL objBL = new GDTTT_CACVU_CAUHINH_BL();
            if (ThamTraVienID > 0)
            {
                DataTable tbl = objBL.GetLanhDaoNhanBCTheoTTV(PhongBanID, ThamTraVienID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string strLDVID = tbl.Rows[0]["ID"] + "";
                    dropLanhDao.SelectedValue = strLDVID;
                }
            }
        }
        //-------------------------------------------
        protected void dropTTV_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropTTV.SelectedValue != "0")
            {
                decimal thamtravien = Convert.ToDecimal(dropTTV.SelectedValue);
                GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            }
            else
                LoadDropLanhDao();
            Cls_Comon.SetFocus(this, this.GetType(), dropLanhDao.ClientID);
        }
        protected void LoadThamPhan()
        {
            dropThamPhan.Items.Clear();
            Boolean IsLoadAll = false;
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);

            GDTTT_DON_BL oBL = new GDTTT_DON_BL();

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                        dropThamPhan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    else
                        IsLoadAll = true;
                }
                else
                    IsLoadAll = true;
            }
            catch (Exception ex) { IsLoadAll = true; }
            if (IsLoadAll)
            {
                //DataTable tbl = oBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    dropThamPhan.DataSource = tbl;
                    dropThamPhan.DataValueField = "ID";
                    dropThamPhan.DataTextField = "Hoten";
                    dropThamPhan.DataBind();
                    dropThamPhan.Items.Insert(0, new ListItem("Chọn", "0"));
                }
            }
        }
        //-------------------------------------------
        void LoadInfoVuAn()
        {
            Decimal CurrDonID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrDonID).Single();
            if (obj != null)
            {

                //Kiem tra neu Ho so KN nhan tu HCTP (GDTTT_DON) thi khong được chuyen sang lại giai quyet khac
                List<GDTTT_DON> oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == CurrDonID && x.LOAIDON == 4).ToList();
                List<GDTTT_VUAN_KETQUA> lst = new List<GDTTT_VUAN_KETQUA>();
                lst = DataExtensions.GetAllByVuAnId<GDTTT_VUAN_KETQUA>(CurrDonID);
                if (oDon.Count() > 0 || lst.Count > 0)
                {
                    dropLoaiGDT.Enabled = false;
                    dropLoaiGDT.Items.Insert(1, new ListItem("Kháng nghị của VKS", "1"));
                }
                else
                {
                    dropLoaiGDT.Enabled = true;
                }


                ddl_LOAI_GDTTT.SelectedValue = Convert.ToString(obj.LOAI_GDTTTT);

                dropDieuLuat.SelectedValue = Convert.ToString(obj.QHPL_THONGKEID);
                //----truong hop thu ly GDTT-------------   
                try { Cls_Comon.SetValueComboBox(dropLoaiGDT, obj.TRUONGHOPTHULY); } catch (Exception ex) { }
                if (obj.ISVIENTRUONGKN == 1)
                {
                    pnThuLyDon.Visible = false;
                    pnHoSoVKS.Visible = pnThulyXXGDT.Visible = true;
                    //cmdUpdateAndNew.Visible = cmdUpdateAndNew2.Visible = false;

                    txtVKS_So.Text = obj.VIENTRUONGKN_SO + "";
                    txtVKS_Ngay.Text = (String.IsNullOrEmpty(obj.VIENTRUONGKN_NGAY + "") || (obj.VIENTRUONGKN_NGAY == DateTime.MinValue)) ? "" : ((DateTime)obj.VIENTRUONGKN_NGAY).ToString("dd/MM/yyyy", cul);
                    LoadDropNGuoiKy_VKS();
                    Cls_Comon.SetValueComboBox(dropVKS_NguoiKy, obj.VIENTRUONGKN_NGUOIKY);

                    //----Thong tin thu ly xet xu GDT----------
                    txtSOTHULYXXGDT.Text = obj.SOTHULYXXGDT + "";
                    txtNgayTHULYXXGDT.Text = (String.IsNullOrEmpty(obj.NGAYTHULYXXGDT + "") || (obj.NGAYTHULYXXGDT == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHULYXXGDT).ToString("dd/MM/yyyy", cul);
                    txtNgayVKSTraHS.Text = (String.IsNullOrEmpty(obj.XXGDTTT_NGAYVKSTRAHS + "") || (obj.XXGDTTT_NGAYVKSTRAHS == DateTime.MinValue)) ? "" : ((DateTime)obj.XXGDTTT_NGAYVKSTRAHS).ToString("dd/MM/yyyy", cul);

                }
                //----thong tin thu ly-----------------
                txtSoThuLy.Text = obj.SOTHULYDON + "";
                txtNgayThuLy.Text = (String.IsNullOrEmpty(obj.NGAYTHULYDON + "") || (obj.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                txtNgayTrongDon.Text = (String.IsNullOrEmpty(obj.NGAYTRONGDON + "") || (obj.NGAYTRONGDON == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTRONGDON).ToString("dd/MM/yyyy", cul);
                txtNgayNhanDon.Text = (String.IsNullOrEmpty(obj.NGAYNHANDONDENGHI + "") || (obj.NGAYNHANDONDENGHI == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYNHANDONDENGHI).ToString("dd/MM/yyyy", cul);

                //---------thong tin BA/QD----------------------
                try
                {
                    if (obj.LOAIAN < 10)
                        dropLoaiAn.SelectedValue = "0" + obj.LOAIAN + "";
                    else
                        dropLoaiAn.SelectedValue = obj.LOAIAN + "";
                }
                catch (Exception exx) { }
                //Loai BA GDT

                if (obj.BAQD_CAPXETXU == 4)
                {
                    hddIsAnPT.Value = "GDT";
                    pnQDGDT.Visible = pnPhucTham.Visible = pnAnST.Visible = true;
                    LoadDropToaAnGDT(dropToaGDT);
                    if (obj.TOAQDID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaGDT, obj.TOAQDID);
                        LoadDropToaPT_TheoGDT(Convert.ToDecimal(obj.TOAQDID));
                    }
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                        LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
                    }
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = false;
                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                }
                else if (obj.BAQD_CAPXETXU == 3)
                {
                    hddIsAnPT.Value = "PT";
                    pnPhucTham.Visible = pnAnST.Visible = true;
                    LoadDropToaAn(dropToaAn);
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                        LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
                    }
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                }
                else if (obj.BAQD_CAPXETXU == 2)
                {
                    hddIsAnPT.Value = "ST";
                    pnQDGDT.Visible = pnPhucTham.Visible = false;
                    pnAnST.Visible = true;
                    LoadDropToaST_Full();
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);

                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = true;
                }
                else
                {
                    hddIsAnPT.Value = "PT";
                    pnPhucTham.Visible = pnAnST.Visible = true;
                    LoadDropToaAn(dropToaAn);
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);
                        LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
                    }
                    if (obj.TOAANSOTHAM > 0)
                        Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM);
                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                    lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                }

                if (obj.BAQD_CAPXETXU != null)
                    Cls_Comon.SetValueComboBox(ddlLoaiBA, obj.BAQD_CAPXETXU);

                txtSoQĐGDT.Text = obj.SO_QDGDT;
                txtNgayGDT.Text = (String.IsNullOrEmpty(obj.NGAYQD + "") || (obj.NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYQD).ToString("dd/MM/yyyy", cul);

                txtSoBA.Text = obj.SOANPHUCTHAM + "";
                txtNgayBA.Text = (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);


                txtSoBA_ST.Text = obj.SOANSOTHAM;
                txtNgayBA_ST.Text = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);

                //----------thong tin TTV/LD---------------------
                LoadnInfo_TTV_LD_TP(obj);
            }
        }
        //thuongnx 09102019
        void LoadDropToaST_Full()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAnST.DataSource = dtTA;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        //anhvh 14/11/2019
        void LoadDropToaST_Full_ST()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR_ST();
            dropToaAnST.DataSource = dtTA;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        protected void ddlLoaiBA_SelectedIndexChanged(object sender, EventArgs e)
        {

            if (ddlLoaiBA.SelectedValue == "3")
            {
                pnPhucTham.Visible = true;
                pnAnST.Visible = true;
                pnQDGDT.Visible = false;
                hddIsAnPT.Value = "PT";
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
            }
            else if (ddlLoaiBA.SelectedValue == "2")//anhvh 14/11/2019
            {
                hddIsAnPT.Value = "ST";
                pnQDGDT.Visible = false;
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                LoadDropToaST_Full_ST();
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = true;

            }
            else if (ddlLoaiBA.SelectedValue == "4")
            {
                pnQDGDT.Visible = true;
                pnPhucTham.Visible = true;
                pnAnST.Visible = true;
                hddIsAnPT.Value = "GDT";
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = false;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
                LoadDropToaST_Full_ST();
            }
            else
            {
                hddIsAnPT.Value = "PT";
                pnQDGDT.Visible = false;
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                LoadDropToaST_Full();
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
            }
        }
        void LoadBanAnST(GDTTT_VUAN obj)
        {
            try
            {
                LoadDropToaST_TheoPT(Convert.ToDecimal(obj.TOAPHUCTHAMID));
            }
            catch (Exception ex) { LoadDropToaAn(dropToaAnST); }
            try { Cls_Comon.SetValueComboBox(dropToaAnST, obj.TOAANSOTHAM); } catch (Exception ex) { }
            txtSoBA_ST.Text = obj.SOANSOTHAM + "";
            txtNgayBA_ST.Text = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);
        }
        void LoadnInfo_TTV_LD_TP(GDTTT_VUAN obj)
        {
            int show_form = 0;
            decimal tempID = 0;
            decimal tempIDLD = 0;
            if (obj.ISVIENTRUONGKN == 1)
            {
                txtNgayphancong.Text = (String.IsNullOrEmpty(obj.XXGDT_NGAYPHANCONGTTV + "") || (obj.XXGDT_NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)obj.XXGDT_NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);
                tempID = (String.IsNullOrEmpty(obj.XXGDT_THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.XXGDT_THAMTRAVIENID);

                txtNgayPhanCong_LDV.Text = (String.IsNullOrEmpty(obj.XXGDT_NGAYPHANCONGLD + "") || (obj.XXGDT_NGAYPHANCONGLD == DateTime.MinValue)) ? "" : ((DateTime)obj.XXGDT_NGAYPHANCONGLD).ToString("dd/MM/yyyy", cul);
                tempIDLD = (String.IsNullOrEmpty(obj.XXGDT_LANHDAOVUID + "")) ? 0 : Convert.ToDecimal(obj.XXGDT_LANHDAOVUID);
            }
            else
            {
                txtNgayphancong.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGTTV + "") || (obj.NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);
                tempID = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);

                txtNgayPhanCong_LDV.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGLD + "") || (obj.NGAYPHANCONGLD == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGLD).ToString("dd/MM/yyyy", cul);
                tempIDLD = (String.IsNullOrEmpty(obj.LANHDAOVUID + "")) ? 0 : Convert.ToDecimal(obj.LANHDAOVUID);
            }


            txtNgayNhanTieuHS.Text = (String.IsNullOrEmpty(obj.NGAYTTVNHAN_THS + "") || (obj.NGAYTTVNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTTVNHAN_THS).ToString("dd/MM/yyyy", cul);

            if (!string.IsNullOrEmpty(txtNgayphancong.Text))
            {
                show_form++;
                txtNgayphancong.Enabled = false;
            }



            if (tempID > 0)
            {
                try
                {
                    Cls_Comon.SetValueComboBox(dropTTV, tempID);
                    dropTTV.Enabled = false;
                    //chkModify_TTV.Visible = true;
                }
                catch (Exception ex) { }
                show_form++;
                GetAllLanhDaoNhanBCTheoTTV(tempID);
            }
            //-------------------------------

            if (!string.IsNullOrEmpty(txtNgayPhanCong_LDV.Text))
            {
                show_form++;
                txtNgayPhanCong_LDV.Enabled = false;
            }
            try
            {
                if (tempIDLD > 0)
                {
                    show_form++;
                    Cls_Comon.SetValueComboBox(dropLanhDao, tempIDLD);
                    dropLanhDao.Enabled = false;
                    //chkModify_LanhDao.Visible = true;
                }
            }
            catch (Exception ex) { }
            //--------------
            txtNgayGDNhanHS.Text = (String.IsNullOrEmpty(obj.NGAYVUGDNHAN_THS + "") || (obj.NGAYVUGDNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYVUGDNHAN_THS).ToString("dd/MM/yyyy", cul);
            tempID = (String.IsNullOrEmpty(obj.HOSOID + "")) ? 0 : Convert.ToDecimal(obj.HOSOID);
            if (tempID > 0)
            {
                GDTTT_QUANLYHS objHS = dt.GDTTT_QUANLYHS.Where(x => x.ID == tempID).Single();
                if (objHS != null)
                {
                    txtNgayNhanHS.Text = (String.IsNullOrEmpty(objHS.NGAYTAO + "") || (objHS.NGAYTAO == DateTime.MinValue)) ? "" : ((DateTime)objHS.NGAYTAO).ToString("dd/MM/yyyy", cul);
                    //Neu da co ho so thi khong cho sua
                    txtNgayNhanHS.Enabled = false;
                }
            }
            //---Kiem tra xem vu an có Don khong, Neu co thi khong cho chọn TP----------------------------
            List<GDTTT_DON> objDon = null;
            objDon = dt.GDTTT_DON.Where(x => x.VUVIECID == obj.ID).ToList();
            //-------------------------------
            txtNgayPhanCong_TP.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGTP + "") || (obj.NGAYPHANCONGTP == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGTP).ToString("dd/MM/yyyy", cul);
            if (!string.IsNullOrEmpty(txtNgayPhanCong_TP.Text))
                show_form++;
            try
            {
                tempID = (String.IsNullOrEmpty(obj.THAMPHANID + "")) ? 0 : Convert.ToDecimal(obj.THAMPHANID);
                if (tempID > 0)
                {
                    show_form++;
                    Cls_Comon.SetValueComboBox(dropThamPhan, tempID);
                    chkModify_TP.Visible = false;
                    //manhnd chi ap dung cho TANDTC
                    if (CurrDonViID == 1)
                        txtNgayPhanCong_TP.Enabled = dropThamPhan.Enabled = false;
                }
                else
                {
                    if (objDon.Count > 0)
                    {
                        txtNgayPhanCong_TP.Enabled = dropThamPhan.Enabled = false;
                        //manhnd chi ap dung cho TAND Cap Cao
                        if (CurrDonViID != 1)
                            txtNgayPhanCong_TP.Enabled = dropThamPhan.Enabled = true;
                    }
                    else
                        txtNgayPhanCong_TP.Enabled = dropThamPhan.Enabled = true;
                }

            }
            catch (Exception ex) { dropThamPhan.Enabled = false; }

            //-------------------------------
            txtGhiChu.Text = obj.GHICHU;
            if (!string.IsNullOrEmpty(txtGhiChu.Text))
                show_form++;
            //-------------------------------
            if (show_form > 0)
            {
                lkTTV.Text = "[ Thu gọn ]";
                pnTTV.Visible = true;
                Session[SessionTTV] = "0";
            }
        }

        GDTTT_VUAN Update_VuAn()
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");

            if (CurrVuAnID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN(); }
            }
            else
                obj = new GDTTT_VUAN();

            obj.PHONGBANID = PhongBanID;//đơn vị sử dụng phần mềm
            if (IsUpdate == false)
                obj.PHONGBANGQ = PhongBanID;//đơn vị giải quyết
            obj.TOAANID = CurrDonViID;

            obj.LOAI_GDTTTT = Convert.ToDecimal(ddl_LOAI_GDTTT.SelectedValue);//anhvh add 26/04/2020
            //Them quan he phap luat thong ke
            obj.QHPL_THONGKEID = Convert.ToDecimal(dropDieuLuat.SelectedValue);
            //-----Truong hop thu ly--------------
            obj.TRUONGHOPTHULY = Convert.ToDecimal(dropLoaiGDT.SelectedValue);
           
            //-----Thong tin ThuLy-------------------
            if (Convert.ToDecimal(dropLoaiGDT.SelectedValue) == 0)
            {
                //Thụ lý theo đơn đề nghị GĐT
                obj.SOTHULYDON = txtSoThuLy.Text.Trim();
                if (!String.IsNullOrEmpty(txtNgayThuLy.Text.Trim()))
                    obj.NGAYTHULYDON = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYTHULYDON = null;

                if (!String.IsNullOrEmpty(txtNgayTrongDon.Text.Trim()))
                    obj.NGAYTRONGDON = DateTime.Parse(this.txtNgayTrongDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYTRONGDON = null;
                if (!String.IsNullOrEmpty(txtNgayNhanDon.Text.Trim()))
                    obj.NGAYNHANDONDENGHI = DateTime.Parse(this.txtNgayNhanDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYNHANDONDENGHI = null;
            }
            else
            {
                //Các trường hợp khác không theo đơn nên xóa thông tin này đi
                obj.SOTHULYDON = obj.NGUOIKHIEUNAI = obj.DIACHINGUOIDENGHI = null;
                obj.NGAYTHULYDON = obj.NGAYTRONGDON = obj.NGAYNHANDONDENGHI = null;
            }

            try
            {


                obj.LOAIAN = Convert.ToInt16(dropLoaiAn.SelectedValue);

                //------Thong tin QD GDT bị đề nghị------------------
                obj.BAQD_CAPXETXU = Convert.ToInt16(ddlLoaiBA.SelectedValue);
                if (pnQDGDT.Visible)
                {
                    if (dropToaGDT.SelectedValue != "0" && dropToaGDT.SelectedValue != "")
                        obj.TOAQDID = Convert.ToDecimal(dropToaGDT.SelectedValue);
                    obj.SO_QDGDT = txtSoQĐGDT.Text.Trim();
                    if (!String.IsNullOrEmpty(txtNgayGDT.Text.Trim()))
                        obj.NGAYQD = DateTime.Parse(this.txtNgayGDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else obj.NGAYQD = null;
                }
                else
                {
                    obj.SO_QDGDT = "";
                    obj.NGAYQD = DateTime.MinValue;
                    obj.TOAQDID = 0;
                }
                //THUONGNX 09102019
                if (pnPhucTham.Visible)
                {
                    if (dropToaAn.SelectedValue != "0" && dropToaAn.SelectedValue != "")
                        obj.TOAPHUCTHAMID = Convert.ToDecimal(dropToaAn.SelectedValue);
                    obj.SOANPHUCTHAM = txtSoBA.Text.Trim();
                    if (!String.IsNullOrEmpty(txtNgayBA.Text.Trim()))
                        obj.NGAYXUPHUCTHAM = DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else obj.NGAYXUPHUCTHAM = null;
                }
                else
                {
                    obj.SOANPHUCTHAM = "";
                    obj.NGAYXUPHUCTHAM = DateTime.MinValue;
                    obj.TOAPHUCTHAMID = 0;
                }

                if (pnAnST.Visible)
                {
                    obj.SOANSOTHAM = txtSoBA_ST.Text.Trim();
                    if (!String.IsNullOrEmpty(txtNgayBA_ST.Text.Trim()))
                        obj.NGAYXUSOTHAM = DateTime.Parse(this.txtNgayBA_ST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else obj.NGAYXUSOTHAM = null;
                    if (dropToaAnST.SelectedValue != "0" && dropToaAnST.SelectedValue != "")
                        obj.TOAANSOTHAM = Convert.ToDecimal(dropToaAnST.SelectedValue);


                }
                else
                {
                    obj.SOANSOTHAM = "";
                    obj.NGAYXUSOTHAM = DateTime.MinValue;
                    obj.TOAANSOTHAM = 0;
                }

                //-----Thong tin TTV/LD---------Manhnd bo---------------
                //if (chkModify_TTV.Checked)
                //    UpdateHistory_PCCanBo(1);

                if (!String.IsNullOrEmpty(txtNgayphancong.Text.Trim()))
                {
                    if (obj.ISVIENTRUONGKN == 1)
                        obj.XXGDT_NGAYPHANCONGTTV = DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else
                        obj.NGAYPHANCONGTTV = DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
                else
                {
                    if (obj.ISVIENTRUONGKN == 1)
                        obj.XXGDT_NGAYPHANCONGTTV = null;
                    else
                        obj.NGAYPHANCONGTTV = null;
                }
                if (obj.ISVIENTRUONGKN == 1)
                {
                    obj.XXGDT_THAMTRAVIENID = Convert.ToDecimal(dropTTV.SelectedValue);
                }
                else
                {
                    obj.THAMTRAVIENID = Convert.ToDecimal(dropTTV.SelectedValue);
                    obj.TENTHAMTRAVIEN = (dropTTV.SelectedValue == "0") ? "" : Cls_Comon.FormatTenRieng(dropTTV.SelectedItem.Text);
                }

                if (!String.IsNullOrEmpty(txtNgayNhanTieuHS.Text.Trim()))
                    obj.NGAYTTVNHAN_THS = DateTime.Parse(this.txtNgayNhanTieuHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.NGAYTTVNHAN_THS = null;

                //-----------Manh bo khong cho update----------------
                //if (chkModify_LanhDao.Checked)
                //    UpdateHistory_PCCanBo(2);
                if (obj.ISVIENTRUONGKN == 1)
                {
                    obj.XXGDT_LANHDAOVUID = Convert.ToDecimal(dropLanhDao.SelectedValue);
                    if (!String.IsNullOrEmpty(txtNgayPhanCong_LDV.Text.Trim()))
                        obj.XXGDT_NGAYPHANCONGLD = DateTime.Parse(this.txtNgayPhanCong_LDV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else obj.XXGDT_NGAYPHANCONGLD = null;
                }
                else
                {
                    obj.LANHDAOVUID = Convert.ToDecimal(dropLanhDao.SelectedValue);
                    if (!String.IsNullOrEmpty(txtNgayPhanCong_LDV.Text.Trim()))
                        obj.NGAYPHANCONGLD = DateTime.Parse(this.txtNgayPhanCong_LDV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    else obj.NGAYPHANCONGLD = null;

                }

                if (!String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
                    obj.NGAYVUGDNHAN_THS = DateTime.Parse(this.txtNgayGDNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.NGAYVUGDNHAN_THS = null;


                //---------Manh bo khong cho update------------------
                //if (chkModify_TP.Checked)
                //    UpdateHistory_PCCanBo(3);
                if (Convert.ToDecimal(dropThamPhan.SelectedValue) > 0)
                    obj.THAMPHANID = Convert.ToDecimal(dropThamPhan.SelectedValue);
                if (!String.IsNullOrEmpty(txtNgayPhanCong_TP.Text.Trim()))
                    obj.NGAYPHANCONGTP = DateTime.Parse(this.txtNgayPhanCong_TP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else obj.NGAYPHANCONGTP = null;

                //---------------------------------
                obj.GHICHU = txtGhiChu.Text.Trim();
                //---------------------------------
                //------Neu nguoi tao là hienvx.gdkt1 thì isxinangiam = 1-------------------------
                //anhvh phân quyên liên quan đến án tử hình
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
                decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
                if (_ISXINANGIAM == 1 && _GDT_ISXINANGIAM == 0 && Convert.ToInt16(dropLoaiAn.SelectedValue) == 1)
                    obj.ISXINANGIAM = 1;
                else if (_ISXINANGIAM == 1 && _GDT_ISXINANGIAM == 1 && Convert.ToInt16(dropLoaiAn.SelectedValue) == 1)
                    obj.ISXINANGIAM = 2;
                else
                    obj.ISXINANGIAM = 0;
                //-----------------------------


                if (!IsUpdate)
                {
                    //Thông tin trạng thái thụ lý
                    if (obj.THAMTRAVIENID > 0)
                        obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV;
                    else
                        obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
                    obj.NGAYTAO = DateTime.Now;
                    obj.NGUOITAO = UserName;

                    obj.ISTOTRINH = 0;
                    dt.GDTTT_VUAN.Add(obj);
                }
                else
                {
                    // kiem tra neu vu an co ket qua GQD roi thi khong cap nhat lai Trangthaiid nua
                    if (obj.GQD_LOAIKETQUA == null)
                    {
                        decimal count_tt = 0, vuan_trangthai = 0;
                        Decimal max_trangthai_tt = 0;
                        GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
                        DataTable tbl = oBL.VUAN_TOTRINH(CurrVuAnID);
                        if (tbl != null && tbl.Rows.Count > 0)
                        {
                            count_tt = tbl.Rows.Count;
                            max_trangthai_tt = Convert.ToDecimal(tbl.Rows[0]["TinhTrangID"] + "");
                            //-----------------------            
                            vuan_trangthai = (Decimal)obj.TRANGTHAIID;
                            GDTTT_DM_TINHTRANG obTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == vuan_trangthai).Single();
                            if (obTT != null)
                            {
                                if (obTT.GIAIDOAN < 3)
                                {
                                    obj.TRANGTHAIID = max_trangthai_tt;
                                }
                            }
                        }
                        else
                        {
                            count_tt = 0;
                            decimal TTV = (string.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : (Decimal)obj.THAMTRAVIENID;
                            if (TTV > 0)
                                obj.TRANGTHAIID = 2;
                            else obj.TRANGTHAIID = 1;
                        }
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = UserName;
                    }
                }
                //-----------------------

                dt.SaveChanges();
                hddVuAnID.Value = obj.ID.ToString();
                CheckToidanhChinhBicao(obj.ID);

            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                Exception raise = dbEx;
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string message = string.Format("{0}:{1}",
                            validationErrors.Entry.Entity.ToString(),
                            validationError.ErrorMessage);
                        // raise a new exception nesting  
                        // the current instance as InnerException  
                        raise = new InvalidOperationException(message, raise);
                    }
                }
                throw raise;
            }
            //-----------------------
            try
            {
                Decimal HosoID = UpdateHoSo(obj);
                if (HosoID > 0)
                {
                    obj.HOSOID = HosoID;
                    obj.ISHOSO = 1;
                }
                else
                    obj.HOSOID = obj.ISHOSO = 0;
                dt.SaveChanges();
            }
            catch (Exception ex) { }
            //--------------------
            return obj;
        }
        void UpdateHistory_PCCanBo(int type)
        {
            decimal CanBoID = 0;
            DateTime? date_temp = (DateTime?)null;
            GDTTT_VUAN_PHANCONGCB_HISTORY obj = new GDTTT_VUAN_PHANCONGCB_HISTORY();
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CurrVuAnID > 0)
            {
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
                switch (type)
                {
                    case 1:// TTV
                        CanBoID = (Decimal)oVA.THAMTRAVIENID;
                        date_temp = oVA.NGAYPHANCONGTTV;
                        break;
                    case 2://LD
                        CanBoID = (Decimal)oVA.LANHDAOVUID;
                        date_temp = oVA.NGAYPHANCONGLD;
                        break;
                    case 3://TP
                        CanBoID = (Decimal)oVA.THAMPHANID;
                        date_temp = oVA.NGAYPHANCONGTP;
                        break;
                }


                List<GDTTT_VUAN_PHANCONGCB_HISTORY> lst = null;
                lst = dt.GDTTT_VUAN_PHANCONGCB_HISTORY.Where(x => x.VUANID == CurrVuAnID
                                                               && x.CANBOID == CanBoID
                                                               && x.LOAI == type
                                                               && x.TUNGAY == date_temp).ToList();
                if (lst != null && lst.Count > 0)
                {
                    //GDTTT_VUAN_PHANCONGCB_HISTORY oTemp = lst[0];
                    //obj.TUNGAY = date_temp;
                    //obj.CANBOID = CanBoID;
                }
                else
                {
                    obj = new GDTTT_VUAN_PHANCONGCB_HISTORY();
                    obj.TUNGAY = date_temp;
                    obj.CANBOID = CanBoID;
                    obj.VUANID = CurrVuAnID;
                    obj.LOAI = (decimal)type;
                    if (obj.CANBOID > 0)
                    {
                        dt.GDTTT_VUAN_PHANCONGCB_HISTORY.Add(obj);
                        dt.SaveChanges();
                    }
                }
            }
        }
        Decimal UpdateHoSo(GDTTT_VUAN objVA)
        {
            DateTime date_temp;
            Decimal CurrHoSoID = 0;
            Decimal VuAn_HoSoID = String.IsNullOrEmpty(objVA.HOSOID + "") ? 0 : (decimal)objVA.HOSOID;
            GDTTT_QUANLYHS objHS = new GDTTT_QUANLYHS();
            decimal thamtravien_id = (decimal)objVA.THAMTRAVIENID;
            if (thamtravien_id > 0)
            {
                decimal vuan_id = (decimal)objVA.ID;
                string NhanHS = "3";
                Boolean IsUpdate = false;
                List<GDTTT_QUANLYHS> lstHS = null;
                try
                {
                    if (!String.IsNullOrEmpty(txtNgayNhanHS.Text.Trim()))
                    {
                        date_temp = DateTime.Parse(this.txtNgayNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        if (VuAn_HoSoID > 0)
                        {
                            try
                            {
                                objHS = dt.GDTTT_QUANLYHS.Where(x => x.ID == VuAn_HoSoID).Single();
                                CurrHoSoID = objHS.ID;
                                IsUpdate = true;
                            }
                            catch (Exception ex2)
                            {
                                IsUpdate = false;
                            }
                        }
                        else
                        {
                            lstHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == vuan_id
                                                                && x.CANBOID == thamtravien_id
                                                                && x.LOAI == NhanHS
                                                           ).OrderByDescending(x => x.NGAYTAO).ToList();
                            if (lstHS != null && lstHS.Count > 0)
                            {
                                foreach (GDTTT_QUANLYHS objTemp in lstHS)
                                {
                                    DateTime ngay_tao_hs = (DateTime)objTemp.NGAYTAO;
                                    if (ngay_tao_hs == date_temp)
                                    {
                                        IsUpdate = true;
                                        objHS = objTemp;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                catch (Exception ex) { }
                if (!IsUpdate)
                {

                    DateTime ngaytao = System.DateTime.Now;
                    if (objHS.NGAYTAO == null)
                        ngaytao = System.DateTime.Now;
                    else
                        ngaytao = (DateTime)objHS.NGAYTAO;
                    // them mới
                    objHS = new GDTTT_QUANLYHS();
                    objHS.TRANGTHAI = 0;
                    objHS.VUANID = vuan_id;
                    objHS.SOPHIEU = GetNewSoPhieuNhanHS(3, ngaytao);
                    objHS.GROUPID = Guid.NewGuid().ToString();
                    objHS.TENCANBO = dropTTV.SelectedItem.Text;
                    objHS.CANBOID = Convert.ToDecimal(dropTTV.SelectedValue);
                }
                if (!String.IsNullOrEmpty(txtNgayNhanHS.Text.Trim()))
                    objHS.NGAYTAO = DateTime.Parse(this.txtNgayNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else objHS.NGAYTAO = null;
                objHS.LOAI = NhanHS.ToString();
                //manhnd kiem tra nêu nhạp ngày Nhận hs thì mới tạo phieu nhận
                //if (!IsUpdate)
                if (!IsUpdate && !String.IsNullOrEmpty(txtNgayNhanHS.Text.Trim()))
                    dt.GDTTT_QUANLYHS.Add(objHS);
                dt.SaveChanges();
                CurrHoSoID = objHS.ID;
            }
            return CurrHoSoID;
        }
        Decimal GetNewSoPhieuNhanHS(decimal loaiphieu, DateTime NgayTao)
        {
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastSoPhieuHS(loaiphieu, NgayTao, CurrDonViID, PhongBanID);
            return SoCV;
        }
        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ClearForm(true);
        }
        void ClearForm(Boolean IsRefresh)
        {
            lttMsg.Text = lttMsgT.Text = "";
            txtSoThuLy.Text = "";
            txtNgayThuLy.Text = txtNgayTrongDon.Text = txtNgayNhanDon.Text = "";
            //txtNguoiDeNghi.Text = txtNguoiDeNghi_DiaChi.Text = "";
            //--------------------------------
            txtSoBA.Text = txtNgayBA.Text = "";
            dropToaAn.SelectedIndex = 0;
            dropLoaiAn.SelectedIndex = 0;
            //--------------------------------
            dropTTV.SelectedIndex = 0;
            if (dropTTV.SelectedValue != "0")
            {
                decimal thamtravien = Convert.ToDecimal(dropTTV.SelectedValue);
                GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            }
            else
                LoadDropLanhDao();
            dropThamPhan.SelectedIndex = 0;
            txtNgayNhanTieuHS.Text = "";
            txtNgayGDNhanHS.Text = "";
            txtGhiChu.Text = "";
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Session[SS_TK.ISHOME] = "1";
            Response.Redirect("Danhsach.aspx");
        }
        //---------------------------
        protected void lkTTV_Click(object sender, EventArgs e)
        {
            if (pnTTV.Visible == false)
            {
                lkTTV.Text = "[ Thu gọn ]";
                pnTTV.Visible = true;
                Session[SessionTTV] = "0";
            }
            else
            {
                lkTTV.Text = "[ Mở ]";
                pnTTV.Visible = false;
                Session[SessionTTV] = "1";
            }
        }
        void Update_TenVuAn(GDTTT_VUAN oVA)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            //GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            //oBL.AHS_UpdateListTenDS(CurrVuAnID);

            string bican_dauvu = "", bican_khieunai = "", nguoikhieunai = "", toidanh = "";
            int is_bicao = 0, is_dauvu = 0, is_nguoikn = 0;

            List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID).OrderBy(y => y.TUCACHTOTUNG).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU ds in lst)
                {
                    is_bicao = String.IsNullOrEmpty(ds.HS_ISBICAO + "") ? 0 : Convert.ToInt16(ds.HS_ISBICAO + "");
                    is_dauvu = String.IsNullOrEmpty(ds.HS_BICANDAUVU + "") ? 0 : Convert.ToInt16(ds.HS_BICANDAUVU + "");
                    is_nguoikn = String.IsNullOrEmpty(ds.HS_ISKHIEUNAI + "") ? 0 : Convert.ToInt16(ds.HS_ISKHIEUNAI + "");

                    if (is_dauvu == 1)
                    {
                        if (bican_dauvu != "")
                            bican_dauvu += (String.IsNullOrEmpty(bican_dauvu)) ? "" : ", ";
                        bican_dauvu += ds.TENDUONGSU;
                        toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + ds.HS_TENTOIDANH;
                    }
                    else
                    {
                        // kiem tra xem co bi cao dau vu chua Neu chua thi lay ten vu an theo Bi cao hoặc nguoi khiếu nại
                        List<GDTTT_VUAN_DUONGSU> countDV = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID && x.HS_BICANDAUVU == 1).OrderBy(y => y.TUCACHTOTUNG).ToList();
                        if (countDV.Count == 0)
                        {
                            if (is_bicao == 1)
                            {

                                if (ds.TENDUONGSU != "")
                                {
                                    List<GDTTT_VUAN_DS_KN> obj = dt.GDTTT_VUAN_DS_KN.Where(x => x.BICAOID == ds.ID).ToList();
                                    if (obj.Count > 0)
                                    {
                                        if (bican_khieunai != "")
                                            bican_khieunai += (String.IsNullOrEmpty(bican_khieunai)) ? "" : ", ";
                                        bican_khieunai += ds.TENDUONGSU;
                                    }
                                    else
                                    {
                                        if (bican_khieunai != "")
                                            bican_khieunai += (String.IsNullOrEmpty(bican_khieunai)) ? "" : ", ";
                                        bican_khieunai += ds.TENDUONGSU;
                                    }

                                }


                                toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + ds.HS_TENTOIDANH;
                            }
                            else if (is_nguoikn == 1)
                            {
                                nguoikhieunai = (String.IsNullOrEmpty(nguoikhieunai)) ? "" : ", ";
                                nguoikhieunai += ds.TENDUONGSU;
                            }
                        }
                    }
                }
            }
            //---------------------------
            if (oVA == null)
                oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();

            oVA.NGUYENDON = bican_dauvu;
            oVA.BIDON = bican_khieunai;
            oVA.NGUOIKHIEUNAI = nguoikhieunai;
            //------------------
            if (!String.IsNullOrEmpty(bican_dauvu))
            {
                oVA.TENVUAN = bican_dauvu
                    + (String.IsNullOrEmpty(bican_dauvu + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                    + toidanh;
            }
            else if (!String.IsNullOrEmpty(bican_khieunai))
            {
                oVA.TENVUAN = bican_khieunai
                    + (String.IsNullOrEmpty(bican_khieunai + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                    + toidanh;
            }
            dt.SaveChanges();
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            //Tạo vu an moi
            GDTTT_VUAN obj = Update_VuAn();
            Update_TenVuAn(obj);
            Session["VUVIECID_CC"] = obj.ID;
            //----Kiem tra xem nếu thêm Đương sự mới thì thêm ---------------------
            //if( dropBiCao.SelectedValue =="-1")
            //{

            //}
            //-----------------------
            //-----update thong tin : tongdon, isanqh, isanchidao, arrnguoikhieunai

            GDTTT_DON_BL objBL = new GDTTT_DON_BL();
            objBL.Update_Don_TH(obj.ID);

            lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công!";
            lttMsgBC.Text = "";
        }
        //protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        //{
        //    GDTTT_VUAN obj = Update_VuAn();
        //    Update_TenVuAn(obj);

        //    //-----update thong tin : tongdon, isanqh, isanchidao, arrnguoikhieunai
        //    GDTTT_DON_BL objBL = new GDTTT_DON_BL();
        //    objBL.Update_Don_TH(obj.ID);

        //    ClearForm(false);
        //    //Response.Redirect("thongtinvuan.aspx?type=renew");
        //    lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công! Bạn có thể tiếp tục cập nhật vụ án mới";
        //    lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
        //}
        //----Truong hop thu ly GĐT
        protected void dropLoaiGDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal truonghopGDT = Convert.ToDecimal(dropLoaiGDT.SelectedValue);
            //-- 1 là KN VKS
            if (truonghopGDT == 1)
            {
                pnThuLyDon.Visible = false;
                pnHoSoVKS.Visible = pnThulyXXGDT.Visible = true;
                //cmdUpdateAndNew.Visible = cmdUpdateAndNew2.Visible = false;

                LoadDropNGuoiKy_VKS();
            }
            else if (truonghopGDT == 2 || truonghopGDT == 3)
            {
                pnThuLyDon.Visible = pnHoSoVKS.Visible = pnThulyXXGDT.Visible = false;
                //cmdUpdateAndNew.Visible = cmdUpdateAndNew2.Visible = true;
            }
            else
            {
                //cmdUpdateAndNew.Visible = cmdUpdateAndNew2.Visible = true;
                pnThuLyDon.Visible = true;
                pnHoSoVKS.Visible = pnThulyXXGDT.Visible = false;
            }


        }
        //-----------------------
        void LoadDropNGuoiKy_VKS()
        {
            dropVKS_NguoiKy.Items.Clear();
            DM_VKS_BL objBL = new DM_VKS_BL();
            DataTable tbl = objBL.GetAll_VKS_ToiCao_CapCao();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropVKS_NguoiKy.DataSource = tbl;
                dropVKS_NguoiKy.DataTextField = "Ten";
                dropVKS_NguoiKy.DataValueField = "ID";
                dropVKS_NguoiKy.DataBind();
            }
            dropVKS_NguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        //--------------------------------------------------
        protected void cmdUpdateVKS_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();

            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CurrVuAnID == 0)
            {
                //obj = Update_VuAn();
                //CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
                lttMsgT.Text = "Bạn cần tạo thông tin vụ án trước!";
                txtSoBA_ST.Focus();
                return;

            }
            else if (CurrVuAnID > 0)
            {
                try
                {
                    //update thong tin vu an trươc
                    obj = Update_VuAn();
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { }
            }

            if (IsUpdate)
            {
                //-Thong tin KN của VKS---------
                obj.VIENTRUONGKN_SO = obj.GDQ_SO = txtVKS_So.Text;
                DateTime date_temp = (String.IsNullOrEmpty(txtVKS_Ngay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtVKS_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.VIENTRUONGKN_NGAY = obj.GDQ_NGAY = date_temp;
                obj.VIENTRUONGKN_NGUOIKY = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);
                obj.GQD_LOAIKETQUA = 1;//khang nghi
                obj.GQD_KETQUA = "Kháng nghị";
                obj.TRANGTHAIID = 14;
                //---------------------------------
                obj.ISVIENTRUONGKN = 1;
                //--Tham quyền xét xử
                if (dropVKS_NguoiKy.SelectedValue == "818"
                    || dropVKS_NguoiKy.SelectedValue == "819"
                    || dropVKS_NguoiKy.SelectedValue == "820"
                    || dropVKS_NguoiKy.SelectedValue == "821")
                    obj.THAMQUYENXXGDT = CurrDonViID;
                else
                    obj.THAMQUYENXXGDT = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);

                dt.SaveChanges();

                lttMsgHSKN_VKS.ForeColor = System.Drawing.Color.Blue;
                lttMsgHSKN_VKS.Text = "Cập nhật dữ liệu thành công!";
            }

        }
        protected void cmdXoa_VKS_Click(object sender, EventArgs e)
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
            if (obj != null)
            {
                obj.VIENTRUONGKN_SO = obj.GDQ_SO = "";
                obj.VIENTRUONGKN_NGAY = obj.GDQ_NGAY = null;
                obj.VIENTRUONGKN_NGUOIKY = 0;
                obj.GQD_LOAIKETQUA = null;
                obj.GQD_KETQUA = null;
                obj.TRANGTHAIID = 1;
                obj.ISVIENTRUONGKN = null;
                dt.SaveChanges();
                //---------------------
                txtVKS_So.Text = txtVKS_Ngay.Text = "";
                dropVKS_NguoiKy.SelectedValue = "0";
                //---------------------
                lttMsg.ForeColor = System.Drawing.Color.Blue;
                lttMsg.Text = "Xóa dữ liệu thành công!";
            }

        }
        //------------------------------
        protected void cmdUpdateTTXX_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CurrVuAnID == 0)
            {
                //obj = Update_VuAn();
                //CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
                lttMsgHSKN_VKS.ForeColor = System.Drawing.Color.Blue;
                lttMsgHSKN_VKS.Text = "Bạn cần tạo thông tin hồ sơ VKS trước khi thụ lý xét xử GĐT!";

                return;
            }
            else if (CurrVuAnID > 0)
            {
                try
                {
                    //update thong tin vu an trươc
                    obj = Update_VuAn();
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN();
                }
                catch (Exception ex) { }
            }
            else
                obj = new GDTTT_VUAN();
            if (IsUpdate)
            {
                obj.SOTHULYXXGDT = txtSOTHULYXXGDT.Text.Trim();
                DateTime date_temp = (String.IsNullOrEmpty(txtNgayTHULYXXGDT.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayTHULYXXGDT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYTHULYXXGDT = date_temp;
                date_temp = (String.IsNullOrEmpty(txtNgayVKSTraHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayVKSTraHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.XXGDTTT_NGAYVKSTRAHS = date_temp;

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
                obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT;

                //-----------------------
                dt.SaveChanges();
                lttMsgTLXX.ForeColor = System.Drawing.Color.Blue;
                lttMsgTLXX.Text = "Cập nhật dữ liệu thành công!";
            }
            else
                lttMsgTLXX.Text = "Vụ án không tồn tại. Bạn hãy kiểm tra lại!";

        }
        protected void cmdXoa_TTXX_Click(object sender, EventArgs e)
        {
            //xoa Thông tin thụ lý xét xử GĐT,TT
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
            if (obj != null)
            {
                obj.SOTHULYXXGDT = "";
                obj.NGAYTHULYXXGDT = null;
                obj.NGAYLICHGDT = null;
                obj.XXGDTTT_NGAYVKSTRAHS = null;

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
                obj.TRANGTHAIID = 14;

                dt.SaveChanges();
                //---------------------
                txtSOTHULYXXGDT.Text = txtNgayTHULYXXGDT.Text = txtNgayVKSTraHS.Text = "";
                //---------------------
                lttMsg.ForeColor = System.Drawing.Color.Blue;
                lttMsg.Text = "Xóa dữ liệu thành công!";
            }
        }
        //------Bị cáo, Người khiếu nại----------
        Decimal GetVuanID()
        {
            string current_id = Request["ID"] + "";
            if (current_id != "")
            {
                VuAnID = Convert.ToDecimal(current_id);
                Session["VUVIECID_CC"] = current_id;
                hddVuAnID.Value = Session["VUVIECID_CC"] + "";
            }
            else if (hddVuAnID.Value != "0")
            {
                VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            }
            else
            {
                VuAnID = 0;
                hddVuAnID.Value = "0";
            }

            return VuAnID;
        }
        protected void dropNguoiKhieuNai_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        protected void dropBiCao_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        protected void lkThemBiCao_Click(object sender, EventArgs e)
        {
            Decimal don_id = GetVuanID();
            try
            {
                if (don_id > 0)
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_sua_ds(" + don_id + ",'')");
                else
                    lttMsgBC.Text = "Bạn phải Lưu vụ án trước khi thêm bị cáo";
            }
            catch (Exception ex)
            {
            }

        }
        protected void lkThemNguoiKN_Click(object sender, EventArgs e)
        {
            Decimal don_id = GetVuanID();
            try
            {
                List<GDTTT_VUAN_DUONGSU> lds = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == don_id).Where(x => x.HS_BICANDAUVU == 1 || x.HS_ISBICAO == 1).ToList();
                if (lds != null && lds.Count > 0)
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_sua_nguoikn(" + don_id + ",'')");
                else
                    lttMsgBC.Text = "Bạn phải tạo bị cáo trước khi thêm thông tin khiếu nại";
            }
            catch (Exception ex)
            {
            }

        }

        public void LoadDanhSachBiCao()
        {
            Decimal don_id = 0;
            //----------------
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = new DataTable();
            don_id = GetVuanID();
            //tbl = objBL.AnHS_GetAllDuongSu(don_id, "", 2);
            tbl = objBL.AHS_GetAllByLoaiDS(don_id, 0); //Chi lay ra Bi cao
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows.Count);
                rptBiCao.DataSource = tbl;
                rptBiCao.DataBind();
                rptBiCao.Visible = true;
            }
            else
                rptBiCao.Visible = false;

        }

        public void LoadDanhSachNguoiKN()
        {
            Decimal don_id = 0;
            //----------------
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = new DataTable();
            don_id = GetVuanID();
            //tbl = objBL.AnHS_GetAllDuongSu(don_id, "", 2);
            tbl = objBL.AHS_GetAllByLoaiDS(don_id, 2); //Chi lay ra Nguoi khiêu nai
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows.Count);
                rptNguoiKN.DataSource = tbl;
                rptNguoiKN.DataBind();
                rptNguoiKN.Visible = true;
            }
            else rptNguoiKN.Visible = false;
        }
        void LoadDsNguoiDuocKN(Decimal NguoiKhieuNaiID, String NoidungKN, Repeater rptBCKN, Literal lttBiCao)
        {
            Decimal don_id = GetVuanID();
            //-------------------------
            String temp = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL oBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            try
            {
                DataTable tbl = oBL.AHS_GetBiCaoKN_ByNguoiKN(don_id, NguoiKhieuNaiID);

                if (tbl != null && tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        temp = (row["BiCao_TuCachTT"] + "").Replace(", Người khiếu nại", "");
                        row["BiCao_TuCachTT"] = temp;
                    }
                    rptBCKN.Visible = true;
                    lttBiCao.Text += "<div style='float:left; width:100%; margin-bottom:3px;font-weight:bold;'> Người được khiếu nại:</div>";

                    rptBCKN.DataSource = tbl;
                    rptBCKN.DataBind();
                    //td_sua_div.Visible = false;
                }
                else
                {
                    //td_sua_div.Visible = true;
                    lttBiCao.Text = "";
                    rptBCKN.Visible = false;
                    lttBiCao.Text += (String.IsNullOrEmpty(NoidungKN) ? "" : ("</br>Khiếu nại: " + NoidungKN.ToString()));
                }
            }
            catch (Exception ex)
            {
                lttBiCao.Text += (String.IsNullOrEmpty(NoidungKN) ? "" : ("</br>Khiếu nại: " + NoidungKN.ToString()));
            }
        }
        protected void RptBCKN_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "SuaKN":
                    //curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    String temp = e.CommandArgument.ToString();
                    String[] arr = temp.Split('$');
                    curr_id = Convert.ToDecimal(arr[0] + "");
                    Decimal NguoiKhieuNaiID = Convert.ToDecimal(arr[1] + "");
                    Decimal BiCaoID = Convert.ToDecimal(arr[2] + "");

                    break;
                case "XoaKN":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    XoaDuongSu_AnHS_BCKN(curr_id);
                    LoadDanhSachBiCao();
                    LoadDanhSachNguoiKN();
                    //lttMsgBC.Text = "Bạn đã xóa thành công người được khiếu nại";
                    break;
            }
        }
        protected void rptBiCao_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                String temp = ""; VuAnID = GetVuanID();
                DataRowView dv = (DataRowView)e.Item.DataItem;
                //Repeater rptBCKN = (Repeater)e.Item.FindControl("rptBCKN");

                Literal lttToidanh = (Literal)e.Item.FindControl("lttToidanh");
                Literal lttTenDS = (Literal)e.Item.FindControl("lttTenDS");
                //--------------------

                Literal ltt_them_td = (Literal)e.Item.FindControl("ltt_them_td");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                //--------------------

                ltt_them_td.Visible = true;
                Decimal vbicaoid = Convert.ToDecimal(dv["ID"].ToString());
                List<GDTTT_VUAN_DS_KN> loT = dt.GDTTT_VUAN_DS_KN.Where(x => x.BICAOID == vbicaoid || x.NGUOIKHIEUNAIID == vbicaoid).ToList();
                if (loT != null && loT.Count > 0)
                    lbtXoa.Visible = false;
                else
                    lbtXoa.Visible = true;
                /////----
                Control td_sua_div = e.Item.FindControl("td_sua_div");
                int is_nguoikn = Convert.ToInt16(dv["HS_IsKhieuNai"] + "");
                int is_bicao = Convert.ToInt16(dv["HS_IsBiCao"] + "");
                int is_dauvu = Convert.ToInt16(dv["HS_BiCanDauVu"] + "");
                int is_loaibc = Convert.ToInt16(dv["LOAI"] + "");
                string loaibc = "";
                if (is_loaibc == 0)
                {
                    loaibc = " - Cá nhân";
                }
                else if (is_loaibc == 4)
                {
                    loaibc = " - Pháp nhân TM";

                }
                else if (is_loaibc == 5)
                {
                    loaibc = " - Pháp nhân phi TM";
                }
                //----------------------
                ltt_them_td.Text = "<a href='javascript:;' style='color:#0E7EEE' onclick='popup_them_td_cc(" + dv["ID"].ToString() + ");'>Thêm tội danh</a>";

                if (is_bicao == 1 || is_dauvu == 1)
                {
                    lttTenDS.Text = dv["TenDuongSu"] + "";
                    if (is_dauvu == 1)
                        lttTenDS.Text += "<span class='loaibc'>(BC đầu vụ" + loaibc + ")</span>";
                    else if (is_bicao == 1 && is_nguoikn == 0)
                        lttTenDS.Text += "<span class='loaibc'>(Bị cáo" + loaibc + ")</span>";
                    else if (is_bicao == 1 && is_nguoikn == 1)
                        lttTenDS.Text += "<span class='loaibc'>(Người KN là BC)</span>";
                    String tentoidanh = String.IsNullOrEmpty(dv["HS_TenToiDanh"] + "") ? "" : "Tội danh:" + dv["HS_TenToiDanh"] + "";
                    String muc_an = String.IsNullOrEmpty(dv["HS_MucAn"] + "") ? "" : "Mức án: " + dv["HS_MucAn"] + "";
                    temp = muc_an + (String.IsNullOrEmpty(muc_an + "") ? "" : (string.IsNullOrEmpty(tentoidanh) ? "" : "</br>")) + tentoidanh;
                    lttToidanh.Text = temp;
                }

            }
        }
        protected void rptBiCao_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            VuAnID = GetVuanID();
            switch (e.CommandName)
            {
                case "them_td":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_td_cc(" + curr_id + ");");
                    break;
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    List<GDTTT_VUAN_DS_KN> loT = dt.GDTTT_VUAN_DS_KN.Where(x => x.BICAOID == curr_id).ToList();
                    if (loT != null && loT.Count > 0)
                    {
                        lttMsgBC.Text = "Bạn không được xóa Bị cáo khi Bi cao đang được khiếu nại.";
                    }
                    else
                    {
                        XoaDuongSu_AnHS(curr_id);
                        LoadDanhSachBiCao();
                        //lttMsgBC.Text = "Xóa bị cáo thành công";
                    }
                    break;

            }
        }


        protected void rptNguoiKN_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                String temp = ""; VuAnID = GetVuanID();
                DataRowView dv = (DataRowView)e.Item.DataItem;
                Repeater rptBCKN = (Repeater)e.Item.FindControl("rptBCKN");
                Literal lttNguoiKN = (Literal)e.Item.FindControl("lttNguoiKN");
                Literal lttTenDS = (Literal)e.Item.FindControl("lttTenDS");
                //--------------------

                LinkButton lbtXoaKN = (LinkButton)e.Item.FindControl("lbtXoaKN");
                //--------------------

                lbtXoaKN.Visible = true;
                /////----
                Control td_sua_div = e.Item.FindControl("td_sua_div");
                int is_nguoikn = Convert.ToInt16(dv["HS_IsKhieuNai"] + "");
                int is_bicao = Convert.ToInt16(dv["HS_IsBiCao"] + "");
                int is_dauvu = Convert.ToInt16(dv["HS_BiCanDauVu"] + "");


                //----------------------
                if (is_bicao == 1 || is_dauvu == 1)
                {
                    lttTenDS.Text = dv["TenDuongSu"] + "";
                    if (is_dauvu == 1)
                        lttTenDS.Text += "<span class='loaibc'>(BC đầu vụ)</span>";
                    else if (is_bicao == 1 && is_nguoikn == 0)
                        lttTenDS.Text += "<span class='loaibc'>(Bị cáo)</span>";
                    else if (is_bicao == 1 && is_nguoikn == 1)
                        lttTenDS.Text += "<span class='loaibc'>(Người KN là BC)</span>";
                    String tentoidanh = String.IsNullOrEmpty(dv["HS_TenToiDanh"] + "") ? "" : "Tội danh:" + dv["HS_TenToiDanh"] + "";
                    String muc_an = String.IsNullOrEmpty(dv["HS_MucAn"] + "") ? "" : "Mức án: " + dv["HS_MucAn"] + "";
                    temp = muc_an + (String.IsNullOrEmpty(muc_an + "") ? "" : (string.IsNullOrEmpty(tentoidanh) ? "" : "</br>")) + tentoidanh;
                    if (is_nguoikn == 1)
                    {
                        temp += string.IsNullOrEmpty(temp) ? "" : (String.IsNullOrEmpty(dv["HS_NoiDungKhieuNai"] + "") ? "" : ("</br>Khiếu nại: " + dv["HS_NoiDungKhieuNai"].ToString()));
                        temp = "";//vua la bị cao , vua la nguoi khieu nai --> ko hien thong tin toidanh, muc an cua bc
                        //----------
                        td_sua_div.Visible = false;
                        LoadDsNguoiDuocKN(Convert.ToDecimal(dv["ID"] + ""), dv["HS_NoiDungKhieuNai"] + "", rptBCKN, lttNguoiKN);
                    }
                    else
                    {
                        td_sua_div.Visible = true;
                        lttNguoiKN.Text = temp;

                        rptBCKN.Visible = false;
                        lttNguoiKN.Visible = true;
                    }

                }
                else
                {
                    //---------------
                    lttTenDS.Text = dv["TenDuongSu"] + "";
                    if (is_bicao == 0 && is_nguoikn == 1)
                        lttTenDS.Text += "<span class='loaibc'> (Người KN)</span>";
                    //la nguoi khieu nai --> hien ds cac bi cao duoc kn, toi danh, muc an
                    Decimal NguoiKhieuNaiID = (Convert.ToDecimal(dv["ID"] + ""));
                    VuAnID = GetVuanID();
                    GDTTT_VUANVUVIEC_DUONGSU_BL oBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
                    try
                    {
                        DataTable tbl = oBL.AHS_GetBiCaoKN_ByNguoiKN(VuAnID, NguoiKhieuNaiID);

                        if (tbl != null && tbl.Rows.Count > 0)
                        {
                            foreach (DataRow row in tbl.Rows)
                            {
                                temp = (row["BiCao_TuCachTT"] + "").Replace(", Người khiếu nại", "");
                                row["BiCao_TuCachTT"] = temp;
                            }
                            rptBCKN.Visible = true;
                            lttNguoiKN.Text = "<div style='float:left; width:100%; margin-bottom:3px;font-weight:bold;'>Người được khiếu nại:</div>";

                            rptBCKN.DataSource = tbl;
                            rptBCKN.DataBind();
                            td_sua_div.Visible = false;
                        }
                        else
                        {
                            td_sua_div.Visible = true;
                            lttNguoiKN.Text = "";
                            rptBCKN.Visible = false;
                            lttNguoiKN.Text = (String.IsNullOrEmpty(dv["HS_NoiDungKhieuNai"] + "") ? "" : ("</br>Khiếu nại: " + dv["HS_NoiDungKhieuNai"].ToString()));
                        }
                    }
                    catch (Exception ex)
                    {
                        lttNguoiKN.Text = (String.IsNullOrEmpty(dv["HS_NoiDungKhieuNai"] + "") ? "" : ("</br>Khiếu nại: " + dv["HS_NoiDungKhieuNai"].ToString()));
                    }
                }
            }
        }
        protected void rptNguoiKN_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            VuAnID = GetVuanID();
            switch (e.CommandName)
            {
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    XoaDuongSu_AnHS_BCKN(curr_id);
                    //XoaDuongSu_AnHS(curr_id);
                    LoadDanhSachBiCao();
                    //LoadDropBiCao();
                    lttMsgBC.Text = "Xóa bị cáo thành công người khiếu nại";

                    break;

            }
        }

        void XoaDuongSu_AnHS(decimal curr_duongsu_id)
        {
            Decimal CurrVuAnID = GetVuanID();
            if (curr_duongsu_id > 0)
            {
                GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == curr_duongsu_id).FirstOrDefault();
                if (oT != null)
                {
                    XoaAllToiDanh(curr_duongsu_id);
                    //------------------------------------
                    dt.GDTTT_VUAN_DUONGSU.Remove(oT);
                    dt.SaveChanges();
                }
            }
            lttMsgBC.Text = "Xóa thành công!";
        }
        void XoaDuongSu_AnHS_BCKN(decimal curr_KN_id)
        {
            Decimal vuan_id = GetVuanID();

            if (curr_KN_id > 0)
            {
                GDTTT_VUAN_DS_KN oT = dt.GDTTT_VUAN_DS_KN.Where(x => x.ID == curr_KN_id).FirstOrDefault();
                if (oT != null)
                {
                    //--Xoa thong tin khieu nai-------------------------
                    Xoa_KN(Convert.ToDecimal(curr_KN_id));

                    //------------------------------------------------------
                    List<GDTTT_VUAN_DS_KN> lst = dt.GDTTT_VUAN_DS_KN.Where(x => x.VUANID == vuan_id
                                                                            && x.NGUOIKHIEUNAIID == oT.NGUOIKHIEUNAIID
                                                                        ).ToList<GDTTT_VUAN_DS_KN>();
                    //Neu nguoi khieu nai nay van dang khieu nai thì khong làm gì
                    if (lst != null && lst.Count > 0)
                    {
                        lttMsgBC.Text = "Bạn đã xóa thành người được khiếu nại";
                    }
                    else
                    {
                        GDTTT_VUAN_DUONGSU oTs = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == oT.NGUOIKHIEUNAIID).FirstOrDefault();
                        if (oTs.HS_ISKHIEUNAI == 1)
                        {
                            if (oTs.HS_ISBICAO == 1 || oTs.HS_BICANDAUVU == 1)
                            {
                                //--Hoac Cap nhat lại truong khieu nai khi Bị cao khong con khieu nai
                                oTs.HS_ISKHIEUNAI = 0;
                            }
                            else
                            {
                                //--Xoa thong tin nguoi khieu nai khi khong phải la Bi cao
                                dt.GDTTT_VUAN_DUONGSU.Remove(oTs);
                            }
                        }
                        dt.SaveChanges();
                        lttMsgBC.Text = "Bạn đã xóa thành người được khiếu nại";
                    }
                }
                else
                {
                    //Xoa Người khiếu nại khi ho khong khieu nai cho ai
                    GDTTT_VUAN_DUONGSU oTs = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == curr_KN_id).FirstOrDefault();
                    if (oTs.HS_ISKHIEUNAI == 1)
                    {
                        if (oTs.HS_ISBICAO == 1 || oTs.HS_BICANDAUVU == 1)
                        {
                            //--Hoac Cap nhat lại truong khieu nai khi Bị cao khong con khieu nai
                            oTs.HS_ISKHIEUNAI = 0;
                        }
                        else
                        {
                            //--Xoa thong tin nguoi khieu nai khi khong phải la Bi cao
                            dt.GDTTT_VUAN_DUONGSU.Remove(oTs);
                        }
                    }
                    dt.SaveChanges();
                    lttMsgBC.Text = "Bạn đã xóa thành người được khiếu nại";

                }
                //------------------------------------
            }

        }
        void Xoa_KN(Decimal KN_id)
        {
            //--Xoa thong tin khieu nai-----------------------------------
            GDTTT_VUAN_DS_KN obj = dt.GDTTT_VUAN_DS_KN.Where(x => x.ID == KN_id).FirstOrDefault();
            if (obj != null)
                dt.GDTTT_VUAN_DS_KN.Remove(obj);
            dt.SaveChanges();
        }
        void XoaAllToiDanh(Decimal DuongsuID)
        {
            Decimal CurrVuAnID = GetVuanID();
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID && x.DUONGSUID == DuongsuID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU_TOIDANH item in lst)
                    dt.GDTTT_VUAN_DUONGSU_TOIDANH.Remove(item);
            }
            dt.SaveChanges();
        }
        protected void cmd_loadbc_Click(object sender, EventArgs e)
        {
            LoadDanhSachBiCao();
        }
        protected void cmd_loadkn_Click(object sender, EventArgs e)
        {
            LoadDanhSachNguoiKN();
        }
        //------Bị cáo, Người khiếu nại----end------
        bool CheckCongbo()
        {
            try
            {
                if (Request["type"].ToString() != null)
                {
                    return true;
                }
            }
            catch
            {

            }

            Decimal VuAnID = Convert.ToDecimal(Request["ID"] + "");
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            decimal v_CAPXETXU = 0;
            if (oT.LOAI_GDTTTT == 1)
            {
                v_CAPXETXU = 4;
            }
            else if (oT.LOAI_GDTTTT == 2)
            {
                v_CAPXETXU = 6;
            }

            var list = DataExtensions.GetAllWithClause<BAQD_CONGBO>(
                $"VUVIECID = {VuAnID} AND LOAIANID = {oT.LOAIAN} AND CAPXETXU = {v_CAPXETXU}  AND TRANGTHAI IN (2,3)"
            );

            BAQD_CONGBO lstCongbo = list?.FirstOrDefault();
            if (lstCongbo != null)
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLamMoi, false);

                Cls_Comon.SetButton(cmdUpdate2, false);
                Cls_Comon.SetButton(cmdLamMoi2, false);

                Cls_Comon.SetButton(cmdXoaTTXX, false);
                Cls_Comon.SetButton(cmdUpdateTTXX, false);

                Cls_Comon.SetButton(cmdXoa_VKS, false);
                Cls_Comon.SetButton(cmdUpdateVKS, false);
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Đã có thông tin về công bố! Không được cập nhật thông tin!')", true);
                return false;
            }

            return true;
        }
        bool CheckToidanhChinhBicao(decimal Vuanid)
        {
            var lst = dt.GDTTT_VUAN_DUONGSU_TOIDANH
                        .Where(x => x.VUANID == Vuanid)
                        .ToList();

            var oVa = dt.GDTTT_VUAN.FirstOrDefault(x => x.ID == Vuanid);

            if (oVa == null)
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Không tìm thấy vụ án!')", true);
                return false; // Không tìm thấy vụ án
            }

            // 1. Có bị cáo nào không có tội danh chính
            var bicaoKhongCoToidanhChinh = lst
                .GroupBy(x => x.DUONGSUID)
                .Any(g => !g.Any(x => x.ISMAIN == 1));

            if (bicaoKhongCoToidanhChinh)
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Bị cáo chưa có tội danh chính!')", true);
                return false;
            }


            // 2. Có tội danh chính trùng tội danh vụ án không
            bool coToiDanhChinhTrung = lst
                .Any(x => x.ISMAIN == 1 && x.TOIDANHID == oVa.QHPL_THONGKEID);

            if (!coToiDanhChinhTrung)
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Tội danh của vụ án phải là tội danh chính của bị cáo!')", true);
                return false;
            }


            return true;
        }
    }
}