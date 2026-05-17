using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Globalization;
using Module.Common;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;

namespace WEB.GSTP.QLAN.GDTTT.Giaiquyet.Popup
{
    public partial class pVuAnHS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";
        String SessionTTV = "pGDTTT_TTV";
        public int nguoikhieunai = 2;
        public int bicao = 0;
        public int bcdauvu = 1;
        public decimal VuAnID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadComponent();
                    LoadThongTinDon();
                    if (Request["vID"] != null)
                    {
                        Ins_Update_vuan();
                        GetVuanID();
                        //Update_VuAn(); //anhvh diable thay vào nghiệp vụ tạo vụ án giống nhận vụ án.
                        LoadDropNguoiKhieuNai();
                        LoadDropBiCao();
                        LoadDanhSachBiCao();
                        tr_nguoikn.Style.Add("Display", "remove");
                        tr_noidungkn.Style.Add("Display", "remove");
                        tr_btn_kn.Style.Add("Display", "remove");
                    }
                }
            }
            else Response.Redirect("/Login.aspx");
        }
        void LoadThongTinDon()
        {
            Decimal CurrDonID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            if (CurrDonID > 0)
            {
                hddDonID.Value = CurrDonID.ToString();
                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == CurrDonID).FirstOrDefault();
                if (oDon != null)
                {
                    hddVuAnID.Value = (string.IsNullOrEmpty(oDon.VUVIECID + "")) ? "0" : oDon.VUVIECID.ToString();

                    //----thong tin thu ly-----------------
                    txtSoThuLy.Text = oDon.TL_SO + "";
                    txtNgayThuLy.Text = (String.IsNullOrEmpty(oDon.TL_NGAY + "") || (oDon.TL_NGAY == DateTime.MinValue)) ? "" : ((DateTime)oDon.TL_NGAY).ToString("dd/MM/yyyy", cul);
                    
                    txtNgayTrongDon.Text = (String.IsNullOrEmpty(oDon.NGAYGHITRENDON + "") || (oDon.NGAYGHITRENDON == DateTime.MinValue)) ? "" : ((DateTime)oDon.NGAYGHITRENDON).ToString("dd/MM/yyyy", cul);
                    txtNgayNhanDon.Text = (String.IsNullOrEmpty(oDon.NGAYNHANDON + "") || (oDon.NGAYNHANDON == DateTime.MinValue)) ? "" : ((DateTime)oDon.NGAYNHANDON).ToString("dd/MM/yyyy", cul);

                    //---------thong tin BA/QD----------------------
                    try
                    {
                        if (oDon.BAQD_LOAIAN < 10)
                            dropLoaiAn.SelectedValue = "0" + oDon.BAQD_LOAIAN + "";
                        else
                            dropLoaiAn.SelectedValue = oDon.BAQD_LOAIAN + "";
                    }
                    catch (Exception exx) { }


                    pnAnST.Visible = false;
                    if (oDon.BAQD_CAPXETXU > 0)
                    {
                        Cls_Comon.SetValueComboBox(ddlLoaiBA, oDon.BAQD_CAPXETXU);
                    }
                    else
                        Cls_Comon.SetValueComboBox(ddlLoaiBA, 3);

                    if (oDon.BAQD_CAPXETXU == 4)
                    {
                        pnQDGDT.Visible = pnPhucTham.Visible = pnAnST.Visible = true;
                        hddInputAnST.Value = "4";

                        txtSoQĐGDT.Text = oDon.BAQD_SO + "";
                        txtNgayGDT.Text = (String.IsNullOrEmpty(oDon.BAQD_NGAYBA + "") || (oDon.BAQD_NGAYBA == DateTime.MinValue)) ? "" : ((DateTime)oDon.BAQD_NGAYBA).ToString("dd/MM/yyyy", cul);
                        if (oDon.BAQD_TOAANID > 0)
                        {
                            Cls_Comon.SetValueComboBox(dropToaGDT, oDon.BAQD_TOAANID);
                            LoadDropToaPT_TheoGDT(Convert.ToDecimal(oDon.BAQD_TOAANID));
                        }

                        //-------BA PT nếu có------
                        txtSoBA.Text = oDon.BAQD_SO_PT + "";
                        txtNgayBA.Text = (String.IsNullOrEmpty(oDon.BAQD_NGAYBA_PT + "") || (oDon.BAQD_NGAYBA_PT == DateTime.MinValue)) ? "" : ((DateTime)oDon.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy", cul);
                        if (oDon.BAQD_TOAANID_PT > 0)
                        {
                            Cls_Comon.SetValueComboBox(dropToaAn, oDon.BAQD_TOAANID_PT);
                            LoadDropToaST_TheoPT(Convert.ToDecimal(oDon.BAQD_TOAANID_PT));
                        }
                        //------BA ST neu co--------------
                        txtSoBA_ST.Text = oDon.BAQD_SO_ST;
                        txtNgayBA_ST.Text = oDon.BAQD_NGAYBA_ST + "" == "" ? "" : ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");

                        if (oDon.BAQD_TOAANID_ST > 0)
                            Cls_Comon.SetValueComboBox(dropToaAnST, oDon.BAQD_TOAANID_ST);
                    }
                    else if (oDon.BAQD_CAPXETXU == 3)
                    {
                        pnPhucTham.Visible = pnAnST.Visible = true;
                        hddInputAnST.Value = "3";

                        txtSoBA.Text = oDon.BAQD_SO_PT + "";
                        txtNgayBA.Text = (String.IsNullOrEmpty(oDon.BAQD_NGAYBA_PT + "") || (oDon.BAQD_NGAYBA_PT == DateTime.MinValue)) ? "" : ((DateTime)oDon.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy", cul);
                        if (oDon.BAQD_TOAANID_PT > 0)
                        {
                            Cls_Comon.SetValueComboBox(dropToaAn, oDon.BAQD_TOAANID_PT);
                            LoadDropToaST_TheoPT(Convert.ToDecimal(oDon.BAQD_TOAANID_PT));
                        }
                        //------BA ST neu co--------------
                        txtSoBA_ST.Text = oDon.BAQD_SO_ST;
                        txtNgayBA_ST.Text = oDon.BAQD_NGAYBA_ST + "" == "" ? "" : ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");

                        if (oDon.BAQD_TOAANID_ST > 0)
                            Cls_Comon.SetValueComboBox(dropToaAnST, oDon.BAQD_TOAANID_ST);

                    }
                    else if (oDon.BAQD_CAPXETXU == 2)
                    {
                        LoadDropToaST_Full_ST();
                        pnAnST.Visible = true;
                        hddInputAnST.Value = "2";

                        txtSoBA_ST.Text = oDon.BAQD_SO_ST + "";
                        txtNgayBA_ST.Text = (String.IsNullOrEmpty(oDon.BAQD_NGAYBA_ST + "") || (oDon.BAQD_NGAYBA_ST == DateTime.MinValue)) ? "" : ((DateTime)oDon.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy", cul);
                        try { Cls_Comon.SetValueComboBox(dropToaAnST, oDon.BAQD_TOAANID_ST); } catch (Exception ex) { }
                    }
                    //-------set nguoi khieu nai theo don-----------
                    //Decimal CurrDS = String.IsNullOrEmpty(hddBiCaoID.Value + "") ? 0 : Convert.ToDecimal(hddBiCaoID.Value);
                    //try { Cls_Comon.SetValueComboBox(dropNguoiKhieuNai, CurrDS); } catch (Exception ex) { }
                    

                    decimal thamphan_id = (String.IsNullOrEmpty(oDon.THAMPHANID + "")) ? 0 : Convert.ToDecimal(oDon.THAMPHANID);
                    try { Cls_Comon.SetValueComboBox(dropThamPhan, thamphan_id); } catch (Exception ex) { }

                    //---------------Thu ly lai -------------------------
                    if (Request["type"] != null && Request["type"].ToString() == "1")
                    {
                        decimal OldVuAnID = (string.IsNullOrEmpty(oDon.VUVIECID + "")) ? 0 : (decimal)oDon.VUVIECID;
                        hddVuAnID.Value = OldVuAnID + "";
                        //LoadThongTinVuAn(OldVuAnID);
                    }
                }
            }
        }
        //-------------------------------------------
        void LoadComponent()
        {
            LoadDropToaAnGDT(dropToaGDT);
            LoadDropToaAn();
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
        //thoing nx 09102019
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
        void LoadDropToaAn()
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAn.DataSource = dtTA;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
            //---------------------------------
            //LoadDropToaST_TheoPT();
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
        void LoadDropToaST_TheoPT()
        {
            dropToaAnST.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            Decimal CapChaID = Convert.ToDecimal(dropToaAn.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(CapChaID);
            dropToaAnST.DataSource = tbl;
            dropToaAnST.DataTextField = "MA_TEN";
            dropToaAnST.DataValueField = "ID";
            dropToaAnST.DataBind();
            dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        }
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
        void LoadLoaiAnTheoVu()
        {
            dropLoaiAn.Items.Clear();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).FirstOrDefault();
            if (obj.ISHINHSU == 1) dropLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            if (obj.ISDANSU == 1) dropLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            if (obj.ISHANHCHINH == 1) dropLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            if (obj.ISHNGD == 1) dropLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            if (obj.ISKDTM == 1) dropLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            if (obj.ISLAODONG == 1) dropLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            if (obj.ISPHASAN == 1) dropLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            //if (dropLoaiAn.Items.Count == 1)
            dropLoaiAn.SelectedIndex = 0;
        }
        //-----------------------      
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
                DataTable tbl = oBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
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
        //----------------------------------------
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            Update_VuAn();
            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công!";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        Decimal GetNewSoPhieuNhanHS(decimal loaiphieu, DateTime NgayTao, decimal DonviID, decimal phongbanID)
        {
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastSoPhieuHS(loaiphieu, NgayTao, DonviID, phongbanID);
            return SoCV;
        }
        //--------------------------------------------------
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
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
        protected void dropToaGDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnAnST.Visible = false;
            decimal toa_an_id = Convert.ToDecimal(dropToaGDT.SelectedValue);
            if (toa_an_id > 0)
            {
                DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                if (obj != null)//&& (obj.LOAITOA == "CAPCAO" || obj.LOAITOA == "CAPTINH"))
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
        //---------------------------------
        GDTTT_VUAN Update_VuAn()
        {
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

            Decimal CurrDonID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            bool IsUpdate = false;
            GDTTT_VUAN obj = new GDTTT_VUAN();
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

            obj.PHONGBANID = PhongBanID;
            obj.TOAANID = CurrDonViID;
            obj.DONTHULYID = CurrDonID;
            //-----Thong tin ThuLy-------------------
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
                obj.NGAYXUPHUCTHAM = null;
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
                obj.NGAYXUSOTHAM = null;
                obj.TOAANSOTHAM = 0;
            }
            //-----Thong tin TTV/LD------------------------

            obj.THAMTRAVIENID = Convert.ToDecimal(dropTTV.SelectedValue);
            obj.TENTHAMTRAVIEN = (dropTTV.SelectedValue == "0") ? "" : Cls_Comon.FormatTenRieng(dropTTV.SelectedItem.Text);
            if (!String.IsNullOrEmpty(txtNgayphancong.Text.Trim()))
                obj.NGAYPHANCONGTTV = DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYPHANCONGTTV = null;
            if (!String.IsNullOrEmpty(txtNgayNhanTieuHS.Text.Trim()))
                obj.NGAYTTVNHAN_THS = DateTime.Parse(this.txtNgayNhanTieuHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYTTVNHAN_THS = null;
            //---------------------------
            obj.LANHDAOVUID = Convert.ToDecimal(dropLanhDao.SelectedValue);
            if (!String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
                obj.NGAYVUGDNHAN_THS = DateTime.Parse(this.txtNgayGDNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYVUGDNHAN_THS = null;
            if (!String.IsNullOrEmpty(txtNgayPhanCong_LDV.Text.Trim()))
                obj.NGAYPHANCONGLD = DateTime.Parse(this.txtNgayPhanCong_LDV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYPHANCONGLD = null;
            //-------------------
            obj.THAMPHANID = Convert.ToDecimal(dropThamPhan.SelectedValue);
            if (!String.IsNullOrEmpty(txtNgayPhanCong_TP.Text.Trim()))
                obj.NGAYPHANCONGTP = DateTime.Parse(this.txtNgayPhanCong_TP.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYPHANCONGTP = null;
            //-------------------------------------------
            obj.GHICHU = txtGhiChu.Text.Trim();
            //---------------------------------
            //if (Request["type"] != null)
            //{
            //    obj.THULYLAI_VUANID = (String.IsNullOrEmpty(objDon.VUVIECID + "")) ? 0 : objDon.VUVIECID;
            //    hddThuLyLaiVuAnID.Value = objDon.VUVIECID + "";
            //}

            //---------------------------------
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
                decimal trangthai = (Decimal)obj.TRANGTHAIID;
                if (trangthai > 0)
                {
                    GDTTT_DM_TINHTRANG objTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == trangthai).Single();
                    if (objTT != null && objTT.GIAIDOAN == 0)
                    {
                        //Thông tin trạng thái thụ lý
                        if (obj.THAMTRAVIENID > 0)
                            obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV;
                        else
                            obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
                    }
                }
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
            }
            //-----------------------
            dt.SaveChanges();
            hddVuAnID.Value = obj.ID.ToString();
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
            //Update Lại đơn
            //THUONGNX 19/09/2019
            try
            {
                GDTTT_DON objDon = dt.GDTTT_DON.Where(x => x.ID == CurrDonID).FirstOrDefault();
                objDon.CD_TRANGTHAI = 2;
                objDon.VUVIECID = obj.ID;
                dt.SaveChanges();
                GDTTT_DON_BL objDVBL = new GDTTT_DON_BL();
                objDVBL.Update_Don_TH(obj.ID);
            }
            catch (Exception ex) { }
            return obj;
        }
        decimal EditNguoiKN(Decimal CurrVuAnID, int IsKN, String TenDS, String DiaChi, String MucAn)
        {
            Decimal CurrDonID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");

            Boolean IsUpdate = false;
            GDTTT_VUAN_DUONGSU obj = null;
            try
            {
                string temp = TenDS.Trim().ToLower();
                obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID
                                                     && x.HS_ISKHIEUNAI == IsKN
                                                     && x.TENDUONGSU.Trim().ToLower() == temp).Single<GDTTT_VUAN_DUONGSU>();
                if (obj != null)
                {
                    IsUpdate = true;
                    //BiCanDauVu = (String.IsNullOrEmpty(obj.HS_BICANDAUVU + "")) ? 0 : Convert.ToInt16(obj.HS_BICANDAUVU);
                }
                else { obj = new GDTTT_VUAN_DUONGSU(); }
            }
            catch (Exception ex) { obj = new GDTTT_VUAN_DUONGSU(); }

            obj.VUANID = CurrVuAnID;
            obj.LOAI = 0;
            obj.GIOITINH = 2;

            obj.BICAOID = 0;
            obj.HS_TUCACHTOTUNG = "";
            //----------------------
            obj.HS_ISKHIEUNAI = IsKN;
            obj.HS_BICANDAUVU = 0;
            obj.HS_ISBICAO = 0;
            //----------------------
            obj.TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.KHAC;
            obj.TENDUONGSU = Cls_Comon.FormatTenRieng(TenDS);
            obj.DIACHI = DiaChi;

            //---------------------
            if (!IsUpdate)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = UserName;
                dt.GDTTT_VUAN_DUONGSU.Add(obj);
            }
            dt.SaveChanges();

            //-------------------------
            return obj.ID;
        }
        Decimal UpdateHoSo(GDTTT_VUAN objVA)
        {
            Decimal CurrHoSoID = 0;
            decimal NhanHS = 3;
            GDTTT_QUANLYHS objHS = new GDTTT_QUANLYHS();
            GDTTT_QUANLYHS old_objHS = null;
            List<GDTTT_QUANLYHS> lstHS = null;
            decimal thamtravien_id = (decimal)objVA.THAMTRAVIENID;
            decimal vuan_id = (decimal)objVA.ID;
            if (Request["type"] != null)
                vuan_id = Convert.ToDecimal(hddThuLyLaiVuAnID.Value);

            if (thamtravien_id > 0)
            {
                DateTime date_temp = (String.IsNullOrEmpty(txtNgayNhanHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                try
                {
                    if (date_temp != DateTime.MinValue)
                    {
                        lstHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == vuan_id
                                                          && x.CANBOID == thamtravien_id
                                                          && x.LOAI == NhanHS.ToString()
                                                          && x.NGAYTRA == null
                                                        ).OrderByDescending(x => x.NGAYTAO).ToList();
                        if (lstHS != null && lstHS.Count > 0)
                            old_objHS = lstHS[0];
                    }
                }
                catch (Exception ex) { old_objHS = null; }
                if (date_temp != DateTime.MinValue && old_objHS != null)
                {
                    //TTV chua tra ho so vu an
                    objHS = new GDTTT_QUANLYHS();
                    objHS.VUANID = objVA.ID;
                    objHS.OLDVUANID = (old_objHS != null) ? 0 : old_objHS.VUANID;
                    objHS.TRANGTHAI = 0;
                    objHS.NGAYTAO = (date_temp == DateTime.MinValue) ? objVA.NGAYTHULYDON : date_temp;
                    objHS.LOAI = NhanHS.ToString();
                    objHS.SOPHIEU = GetNewSoPhieuNhanHS(3, (DateTime)objHS.NGAYTAO,CurrDonViID, PhongBanID);
                    objHS.TENCANBO = dropTTV.SelectedItem.Text;
                    objHS.CANBOID = Convert.ToDecimal(dropTTV.SelectedValue);
                    objHS.GROUPID = Guid.NewGuid().ToString();
                    dt.GDTTT_QUANLYHS.Add(objHS);
                    dt.SaveChanges();

                    CurrHoSoID = objHS.ID;
                }
            }
            return CurrHoSoID;
        }
        void Update_DonGDTTT(GDTTT_DON objDon)
        {
            Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            if (objDon != null)
            {
                objDon.VUVIECID = VuAnID;
                dt.SaveChanges();
            }
        }
        //anhvhadd get bicao người khiếu nại từ HCTPCC 31/05/2021
        Decimal TaoVuAn_ThuLyMoi(Decimal DonID, GDTTT_DON oDon, Decimal OldVuAnID)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            Decimal VuAnID = 0;
            GDTTT_VUAN objVA = new GDTTT_VUAN();
            if (oDon == null && DonID > 0)
                oDon = dt.GDTTT_DON.Where(x => x.ID == DonID).Single();

            if (oDon != null)
            {
                //---------TRUONGHOPTHULY----------------
                if (oDon.LOAIDON == 1 || oDon.LOAIDON == 2 || oDon.LOAIDON == 3 || oDon.LOAIDON == 6 || oDon.LOAIDON == 9)
                {
                    objVA.TRUONGHOPTHULY = 0;
                    //-------------------------------
                    objVA.TRANGTHAIID = 1; // chua phan cong TTV
                    objVA.SOTHULYDON = oDon.TL_SO;
                    objVA.NGAYTHULYDON = oDon.TL_NGAY;
                }
                else if (oDon.LOAIDON == 4)
                {
                    objVA.TRUONGHOPTHULY = 1;
                    objVA.GQD_LOAIKETQUA = 1;//khang nghi
                    objVA.GQD_KETQUA = "Kháng nghị";
                    objVA.TRANGTHAIID = 14;
                    objVA.ISVIENTRUONGKN = 1;
                    objVA.VIENTRUONGKN_SO = oDon.SO_HSKN;
                    if (!String.IsNullOrEmpty(oDon.NGAY_HSKN + ""))
                        objVA.VIENTRUONGKN_NGAY = objVA.GDQ_NGAY = oDon.NGAY_HSKN;
                    objVA.VIENTRUONGKN_NGUOIKY = objVA.THAMQUYENXXGDT = oDon.DONVICHUYEN_HSKN;

                    objVA.SOTHULYXXGDT = oDon.TL_SO;
                    objVA.NGAYTHULYXXGDT = oDon.TL_NGAY;

                }
                else if (oDon.LOAIDON == 8 || oDon.LOAIDON == 10)
                {
                    objVA.TRUONGHOPTHULY = oDon.LOAIDON;
                    objVA.SOTHULYDON = oDon.TL_SO;
                    objVA.NGAYTHULYDON = oDon.TL_NGAY;
                }
                else
                {
                    objVA.TRUONGHOPTHULY = 0;
                    objVA.SOTHULYDON = oDon.TL_SO;
                    objVA.NGAYTHULYDON = oDon.TL_NGAY;
                }

                objVA.TENVUAN = "Thụ lý mới ";
                //-----------------
                objVA.TOAANID = ToaAnID;
                objVA.PHONGBANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                //phân biệt Đơn đề nghị GDT hay TT
                objVA.LOAI_GDTTTT = oDon.LOAI_GDTTTT;
                objVA.NGUOIKHIEUNAI = oDon.NGUOIGUI_HOTEN + "";
                objVA.DIACHINGUOIDENGHI = oDon.NGUOIGUI_DIACHI;
                decimal huyenid = (string.IsNullOrEmpty(oDon.NGUOIGUI_HUYENID + "")) ? 0 : (decimal)oDon.NGUOIGUI_HUYENID;
                if (huyenid > 0)
                {
                    objVA.DIACHINGUOIDENGHI += ((string.IsNullOrEmpty(objVA.DIACHINGUOIDENGHI + "")) ? "" : ", ")
                                                + dt.DM_HANHCHINH.Where(x => x.ID == oDon.NGUOIGUI_HUYENID).FirstOrDefault().MA_TEN;
                }
                objVA.NGAYTRONGDON = oDon.NGAYGHITRENDON;
                objVA.NGAYNHANDONDENGHI = oDon.NGAYNHANDON;

                //------------------------------
                objVA.LOAIAN = String.IsNullOrEmpty(oDon.BAQD_LOAIAN + "") ? 0 : (Decimal)oDon.BAQD_LOAIAN;
                //--Manh kiem tra đổ đúng bản án  BAQD_LOAIQDBA BAQD_CAPXETXU
                objVA.BAQD_LOAIQDBA = oDon.BAQD_LOAIQDBA;
                objVA.BAQD_CAPXETXU = oDon.BAQD_CAPXETXU;

                objVA.SO_QDGDT = oDon.BAQD_SO;
                objVA.NGAYQD = oDon.BAQD_NGAYBA;
                objVA.TOAQDID = String.IsNullOrEmpty(oDon.BAQD_TOAANID + "") ? 0 : (decimal)oDon.BAQD_TOAANID;

                objVA.SOANPHUCTHAM = oDon.BAQD_SO_PT;
                objVA.NGAYXUPHUCTHAM = oDon.BAQD_NGAYBA_PT;
                objVA.TOAPHUCTHAMID = String.IsNullOrEmpty(oDon.BAQD_TOAANID_PT + "") ? 0 : (decimal)oDon.BAQD_TOAANID_PT;

                objVA.SOANSOTHAM = oDon.BAQD_SO_ST;
                objVA.NGAYXUSOTHAM = oDon.BAQD_NGAYBA_ST;
                objVA.TOAANSOTHAM = String.IsNullOrEmpty(oDon.BAQD_TOAANID_ST + "") ? 0 : (decimal)oDon.BAQD_TOAANID_ST;

                //--------------------------------------------------------------
                objVA.QHPL_TEXT = oDon.QHPL_TEXT;
                //--------------------------------------------------------------

                decimal thamphan_id = (String.IsNullOrEmpty(oDon.THAMPHANID + "")) ? 0 : Convert.ToDecimal(oDon.THAMPHANID);
                objVA.THAMPHANID = thamphan_id;
                if (thamphan_id > 0)
                {
                    try
                    {
                        GDTTT_PCTP_CHITIET oKQCT = dt.GDTTT_PCTP_CHITIET.Where(x => x.DONID == DonID).SingleOrDefault();
                        //Lay ra ngay thực hiện Phân công TP 
                        if (oKQCT.NGAYPHANCONGTP == null)
                        {
                            GDTTT_PCTP_KETQUA oKQPC = dt.GDTTT_PCTP_KETQUA.Where(x => x.ID == oKQCT.KETQUAID).Single();
                            objVA.NGAYPHANCONGTP = oKQPC.NGAYPHANCONG;
                        }//nếu không có thì lấy ngày tờ trình
                        else
                            objVA.NGAYPHANCONGTP = oKQCT.NGAYPHANCONGTP;
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error: {ex.Message}");
                        if (ex.InnerException != null)
                        {
                            Console.WriteLine($"Inner Exception: {ex.InnerException.Message}");
                        }
                    }
                }
                objVA.THULYLAI_VUANID = OldVuAnID;
                objVA.ISTOTRINH = objVA.ISHOSO = objVA.HOSOID = 0;
                objVA.NGAYTAO = DateTime.Now;
                objVA.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                //-manhnd kiem tra an tu hinh-------------------------------
                Decimal Loaian = Convert.ToDecimal(Session[SS_TK.LOAIAN]);
                if (Loaian == 1)
                {
                    if (oDon.ISTH_ANGIAM == 1 && oDon.ISTH_KEUOAN == 1)
                    {
                        objVA.ISXINANGIAM = 2;
                    }
                    else if (oDon.ISTH_ANGIAM == 1 && oDon.ISTH_KEUOAN == 0)
                    {
                        objVA.ISXINANGIAM = 1;
                    }
                    else if (oDon.ISANTUHINH == 1)
                    {
                        objVA.ISXINANGIAM = 2;
                    }
                    else
                        objVA.ISXINANGIAM = 0;
                }
                //-------------------------

                //decimal loaicv = (int)oDon.LOAICONGVAN;
                //if (loaicv > 0)
                //{
                //    DM_DATAITEM oDA = dt.DM_DATAITEM.Where(x => x.ID == loaicv).Single();
                //    string[] ArrSapXep = oDA.ARRSAPXEP.Split('/');
                //    if (ArrSapXep[0] == "1023" || ArrSapXep[0] == "1033")
                //        objVA.ISANQUOCHOI = 1;
                //}
                dt.GDTTT_VUAN.Add(objVA);
                //------------------------------
                dt.SaveChanges();
                VuAnID = objVA.ID;

                //Nếu loại đơn là CV kiến nghị kèm Hồ sơ thì Vụ án đã có hồ sơ
                if (oDon.LOAIDON == 9)
                {
                    //Tạo phiếu mượn hồ sơ
                    GDTTT_QUANLYHS oHS = new GDTTT_QUANLYHS();
                    oHS.LOAI = "3";
                    oHS.VUANID = objVA.ID;
                    // ngày nhận hồ sơ
                    oHS.NGAYTAO = oDon.NGAYNHANDON;
                    oHS.TENCANBO = oDon.NGUOITAO;
                    oHS.TRANGTHAI = Convert.ToInt16(oHS.LOAI);
                    oHS.GROUPID = Guid.Empty.ToString(); //Guid.NewGuid().ToString();               
                    dt.GDTTT_QUANLYHS.Add(oHS);
                    dt.SaveChanges();
                    //update lại trạng thái hồ sơ vào bảng Vụ án
                    GDTTT_VUAN objVA_HS = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
                    objVA_HS.ISHOSO = 1;
                    objVA_HS.HOSOID = oHS.ID;
                    dt.SaveChanges();
                }
            }
            return VuAnID;
        }
        protected void ADD_BICAO_DON(Decimal donid, Decimal new_vuanid)
        {
            //de lay ra Nguyen don và Bi don tu Don
            string bican_dauvu = "", toidanh = "";
            List<GDTTT_DON_DUONGSU_CC> lsDS = null;
            lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == donid).ToList();
            if (lsDS.Count > 0)
            {
                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_VUAN_DUONGSU objBC = new GDTTT_VUAN_DUONGSU();
                    objBC.VUANID = new_vuanid;
                    objBC.DONID = donid;
                    objBC.TENDUONGSU = lsDS[i].TENDUONGSU;
                    objBC.LOAI = lsDS[i].LOAI;
                    objBC.TUCACHTOTUNG = lsDS[i].TUCACHTOTUNG;
                    objBC.GIOITINH = lsDS[i].GIOITINH;
                    objBC.TINHID = lsDS[i].TINHID;
                    objBC.HUYENID = lsDS[i].HUYENID;
                    objBC.DIACHI = lsDS[i].DIACHI;
                    objBC.NGAYTAO = DateTime.Now;
                    objBC.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                    objBC.ISINPUTADDRESS = lsDS[i].ISINPUTADDRESS;
                    objBC.HS_BICANDAUVU = lsDS[i].HS_BICANDAUVU;
                    objBC.BICAOID = lsDS[i].BICAOID;
                    objBC.HS_ISBICAO = lsDS[i].HS_ISBICAO;
                    objBC.HS_TOIDANHID = lsDS[i].HS_TOIDANHID;
                    objBC.HS_TENTOIDANH = lsDS[i].HS_TENTOIDANH;
                    objBC.HS_MUCAN = lsDS[i].HS_MUCAN;
                    objBC.HS_TUCACHTOTUNG = lsDS[i].HS_TUCACHTOTUNG;

                    objBC.HS_ISKHIEUNAI = lsDS[i].HS_ISKHIEUNAI;
                    objBC.HS_LOAIBAKHIEUNAI = lsDS[i].HS_LOAIBAKHIEUNAI;
                    objBC.HS_NGAYBAKHIEUNAI = lsDS[i].HS_NGAYBAKHIEUNAI;
                    objBC.HS_NOIDUNGKHIEUNAI = lsDS[i].HS_NOIDUNGKHIEUNAI;
                    objBC.NAMSINH = lsDS[i].NAMSINH;
                    //Thêm bản Bị cáo lấy từ Đơn
                    dt.GDTTT_VUAN_DUONGSU.Add(objBC);
                    dt.SaveChanges();
                    //Danh sach ten bi cao dau vu
                    if (lsDS[i].HS_BICANDAUVU == 1)
                    {
                        if (bican_dauvu != "")
                            bican_dauvu += (String.IsNullOrEmpty(bican_dauvu)) ? "" : ", ";
                        bican_dauvu += lsDS[i].TENDUONGSU;
                        toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + lsDS[i].HS_TENTOIDANH;
                    }
                    List<GDTTT_DON_DUONGSU_TOIDANH_CC> loTD_DON = null;
                    decimal vDuongsuid_old = Convert.ToDecimal(lsDS[i].ID);

                    loTD_DON = dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.DUONGSUID == vDuongsuid_old).ToList();

                    for (int j = 0; j < loTD_DON.Count; j++)
                    {
                        GDTTT_VUAN_DUONGSU_TOIDANH oDSva = new GDTTT_VUAN_DUONGSU_TOIDANH();
                        oDSva.VUANID = new_vuanid;//id vu an moi
                        oDSva.DUONGSUID = objBC.ID;// id Duong su moi
                        oDSva.TOIDANHID = lsDS[j].HS_TOIDANHID;
                        oDSva.TENTOIDANH = lsDS[j].HS_TENTOIDANH;
                        dt.GDTTT_VUAN_DUONGSU_TOIDANH.Add(oDSva);
                        dt.SaveChanges();
                    }
                    //Update nguoi Khieu Nai mơi sinh ra vao bang DS-KN
                    if (lsDS[i].HS_ISKHIEUNAI == 1)
                    {
                        //Kiem tra Nguoi khieu nai nay co Khieu nai cho bi cao nao khong
                        List<GDTTT_DON_DS_KN_CC> oNKNCC = dt.GDTTT_DON_DS_KN_CC.Where(x => x.NGUOIKHIEUNAIID == vDuongsuid_old).ToList();
                        foreach (GDTTT_DON_DS_KN_CC ist in oNKNCC)
                        {
                            ist.VUAN_NGUOIKHIEUNAI_NEW = objBC.ID;
                            dt.SaveChanges();
                        }
                    }

                    //Update Bi cao được khiếu nại mới Sinh ra ở Vu an vào Bảng  GDTTT_DON_DS_KN_CC để xác định Bị Cáo được khiếu nại
                    GDTTT_DON_DS_KN_CC odKNCC = dt.GDTTT_DON_DS_KN_CC.Where(x => x.BICAOID == vDuongsuid_old).FirstOrDefault();
                    if (odKNCC != null)
                    {
                        odKNCC.VUAN_BICAO_NEW = objBC.ID;
                        dt.SaveChanges();
                    }


                }
                //Them duong su khieu nai vào bang GDTTT_VUAN_DS_KN
                GDTTT_DON_DUONGSU_CC oDSKN_DON = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == donid && x.HS_ISKHIEUNAI == 1).FirstOrDefault() ?? new GDTTT_DON_DUONGSU_CC();
                if (oDSKN_DON != null)
                {
                    List<GDTTT_DON_DS_KN_CC> lsDSKN = dt.GDTTT_DON_DS_KN_CC.Where(x => x.NGUOIKHIEUNAIID == oDSKN_DON.ID).ToList();
                    for (int k = 0; k < lsDSKN.Count; k++)
                    {
                        GDTTT_VUAN_DS_KN obDSKN = new GDTTT_VUAN_DS_KN();
                        obDSKN.VUANID = new_vuanid;
                        //ID người khiếu nại đang sai cần lấy ID mới của người khiếu lại
                        obDSKN.NGUOIKHIEUNAIID = lsDSKN[k].VUAN_NGUOIKHIEUNAI_NEW;
                        obDSKN.BICAOID = lsDSKN[k].VUAN_BICAO_NEW;
                        obDSKN.NOIDUNGKHIEUNAI = lsDSKN[k].NOIDUNGKHIEUNAI;
                        dt.GDTTT_VUAN_DS_KN.Add(obDSKN);
                        dt.SaveChanges();
                    }
                }

                //Update về bảng vụ án Tên vụ án
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == new_vuanid).Single();
                objVA.NGUYENDON = bican_dauvu;
                if (!String.IsNullOrEmpty(bican_dauvu))
                {
                    objVA.TENVUAN = bican_dauvu
                        + (String.IsNullOrEmpty(bican_dauvu + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                        + toidanh;
                }
                dt.SaveChanges();

                //--- Xoa Bi cao và Toi danh của don tu bang GDTTT_DON_DUONGSU_CC 
                //for (int i = 0; i < lsDS.Count; i++)
                //{
                //    GDTTT_DON_DUONGSU_CC objDSdon = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == donid).Single();
                //    dt.GDTTT_DON_DUONGSU_CC.Remove(objDSdon);
                //    dt.SaveChanges();

                //    GDTTT_DON_DUONGSU_TOIDANH_CC objDS_TD= dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.DONID == donid).Single();
                //    dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Remove(objDS_TD);
                //    dt.SaveChanges();


                //    GDTTT_DON_DS_KN_CC objDS_KN = dt.GDTTT_DON_DS_KN_CC.Where(x => x.DONID == donid).Single();
                //    dt.GDTTT_DON_DS_KN_CC.Remove(objDS_KN);
                //    dt.SaveChanges();
                //}
            }
        }
        protected void ADD_BiCaoDauVu(Decimal donid, Decimal vuanid)
        {
            //Kiem tra da co vu an (theo so an, ngayxu, toa xu) chua
            //de lay ra Bi cao dau vu của Vu an trươc loai bo vu an vua tao xong
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == donid).FirstOrDefault();
            List<GDTTT_VUAN> lst = null;
            if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                             && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                                             && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                                             && x.ID != vuanid
                                                            )
                                    .OrderByDescending(x => x.NGAYTAO).ToList();
            }
            else if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.PHUCTHAM)
            {
                lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_PT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                         && x.NGAYXUPHUCTHAM == oDon.BAQD_NGAYBA_PT
                                                         && x.TOAPHUCTHAMID == oDon.BAQD_TOAANID_PT
                                                         && x.ID != vuanid
                                                        )
                                    .OrderByDescending(x => x.NGAYTAO).ToList();
                //Nếu cấp PT không có thì KT cấp  ST
                if (donid > 0 && (lst == null || lst.Count == 0))
                {

                    lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                               && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                               && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                               && x.ID != vuanid
                                              )
                                    .OrderByDescending(x => x.NGAYTAO).ToList();
                }
            }
            else if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lst = dt.GDTTT_VUAN.Where(x => x.SO_QDGDT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                        && x.NGAYQD == oDon.BAQD_NGAYBA
                                                        && x.TOAQDID == oDon.BAQD_TOAANID
                                                        && x.ID != vuanid
                                                       )
                                    .OrderByDescending(x => x.NGAYTAO).ToList();
                //Nếu cấp GDT không có thì KT cấp PT và ST
                if (donid > 0 && (lst == null || lst.Count == 0))
                {

                    //Kt BA PT neu có
                    if (oDon.BAQD_NGAYBA_PT != null)
                    {
                        lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_PT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                        && x.NGAYXUPHUCTHAM == oDon.BAQD_NGAYBA_PT
                                                        && x.TOAPHUCTHAMID == oDon.BAQD_TOAANID_PT
                                                        && x.ID != vuanid
                                                       )
                                    .OrderByDescending(x => x.NGAYTAO).ToList();
                        //Kiem tra BA ST nếu BA PT ko đúng
                        if (lst == null || lst.Count == 0)
                        {
                            if (oDon.BAQD_NGAYBA_ST != null)
                            {
                                lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                      && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                                      && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                                      && x.ID != vuanid
                                                     )
                                                    .OrderByDescending(x => x.NGAYTAO).ToList();
                            }
                        }
                    }//Kiem tra BA ST nếu không có BA PT
                    else if (oDon.BAQD_NGAYBA_ST != null)
                    {
                        lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                  && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                                  && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                                 && x.ID != vuanid
                                                 )
                                            .OrderByDescending(x => x.NGAYTAO).ToList();
                    }

                }
            }
            string bican_dauvu = "", toidanh = "";
            if (lst != null && lst.Count > 0)
            {

                GDTTT_VUAN objVA = lst[0];
                List<GDTTT_VUAN_DUONGSU> lsDS = null;
                lsDS = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == objVA.ID
                                                        && x.HS_BICANDAUVU == 1).ToList();

                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_VUAN_DUONGSU objBC = new GDTTT_VUAN_DUONGSU();
                    objBC.VUANID = vuanid;
                    objBC.TENDUONGSU = lsDS[i].TENDUONGSU;
                    objBC.LOAI = lsDS[i].LOAI;
                    objBC.TUCACHTOTUNG = lsDS[i].TUCACHTOTUNG;
                    objBC.GIOITINH = lsDS[i].GIOITINH;
                    objBC.TINHID = lsDS[i].TINHID;
                    objBC.HUYENID = lsDS[i].HUYENID;
                    objBC.DIACHI = lsDS[i].DIACHI;
                    objBC.NGAYTAO = DateTime.Now;
                    objBC.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                    objBC.ISINPUTADDRESS = lsDS[i].ISINPUTADDRESS;
                    objBC.HS_BICANDAUVU = 1;
                    objBC.HS_ISBICAO = lsDS[i].HS_ISBICAO;
                    objBC.HS_TOIDANHID = lsDS[i].HS_TOIDANHID;
                    objBC.HS_TENTOIDANH = lsDS[i].HS_TENTOIDANH;
                    objBC.HS_MUCAN = lsDS[i].HS_MUCAN;
                    objBC.HS_TUCACHTOTUNG = lsDS[i].HS_TUCACHTOTUNG;
                    objBC.HS_ISKHIEUNAI = 0;
                    objBC.NAMSINH = lsDS[i].NAMSINH;
                    //Thêm bản Bị cáo đầu vụ lấy từ Vụ án trước
                    dt.GDTTT_VUAN_DUONGSU.Add(objBC);
                    dt.SaveChanges();
                    //Danh sach ten bi cao dau vu
                    if (bican_dauvu != "")
                        bican_dauvu += (String.IsNullOrEmpty(bican_dauvu)) ? "" : ", ";
                    bican_dauvu += lsDS[i].TENDUONGSU;
                    toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + lsDS[i].HS_TENTOIDANH;
                }
                //Update về bảng vụ án danh sách bị cáo đầu vụ và tội danh
                objVA = dt.GDTTT_VUAN.Where(x => x.ID == vuanid).Single();
                objVA.NGUYENDON = bican_dauvu;
                if (!String.IsNullOrEmpty(bican_dauvu))
                {
                    objVA.TENVUAN = bican_dauvu
                        + (String.IsNullOrEmpty(bican_dauvu + "") ? "" : (string.IsNullOrEmpty(toidanh + "") ? "" : " - "))
                        + toidanh;
                }
                dt.SaveChanges();
            }
        }
        protected void ADD_DUONGSU_DON(Decimal donid, Decimal new_vuanid)
        {
            //de lay ra Nguyen don và Bi don tu Don
            string vNguyenDon = "", vBiDON = "";
            List<GDTTT_DON_DUONGSU_CC> lsDS = null;
            lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == donid).ToList();
            if (lsDS.Count > 0)
            {
                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_VUAN_DUONGSU objBC = new GDTTT_VUAN_DUONGSU();
                    objBC.VUANID = new_vuanid;
                    objBC.DONID = donid;
                    objBC.TENDUONGSU = lsDS[i].TENDUONGSU;
                    objBC.LOAI = lsDS[i].LOAI;
                    objBC.TUCACHTOTUNG = lsDS[i].TUCACHTOTUNG;
                    objBC.GIOITINH = lsDS[i].GIOITINH;
                    objBC.TINHID = lsDS[i].TINHID;
                    objBC.HUYENID = lsDS[i].HUYENID;
                    objBC.DIACHI = lsDS[i].DIACHI;
                    objBC.NGAYTAO = DateTime.Now;
                    objBC.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                    objBC.ISINPUTADDRESS = lsDS[i].ISINPUTADDRESS;

                    //Thêm bản Duong su tu don
                    dt.GDTTT_VUAN_DUONGSU.Add(objBC);
                    dt.SaveChanges();

                    if (lsDS[i].TUCACHTOTUNG == "NGUYENDON")
                    {
                        if (vNguyenDon != "")
                            vNguyenDon += (String.IsNullOrEmpty(vNguyenDon)) ? "" : ", ";
                        vNguyenDon = lsDS[i].TENDUONGSU;
                    }
                    if (lsDS[i].TUCACHTOTUNG == "BIDON")
                    {
                        if (vBiDON != "")
                            vBiDON += (String.IsNullOrEmpty(vBiDON)) ? "" : ", ";
                        vBiDON = lsDS[i].TENDUONGSU;
                    }
                }
                //Update về bảng vụ án Tên vụ án
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == new_vuanid).Single();
                objVA.NGUYENDON = vNguyenDon;
                objVA.BIDON = vBiDON;
                if (!String.IsNullOrEmpty(vNguyenDon) || !String.IsNullOrEmpty(vBiDON))
                {
                    objVA.TENVUAN = vNguyenDon + (String.IsNullOrEmpty(vNguyenDon + "") ? "" : (string.IsNullOrEmpty(vNguyenDon + "") ? "" : " - "))
                        + vBiDON + (String.IsNullOrEmpty(vBiDON + "") ? "" : (string.IsNullOrEmpty(vBiDON + "") ? "" : " - "))
                        + objVA.QHPL_TEXT;
                }
                dt.SaveChanges();
                //--- Xoa nguyen don, bi don của don tu bang GDTTT_DON_DUONGSU_CC
                //for (int j = 0; j < lsDS.Count; j++)
                //{
                //    decimal vDuongSu_don = Convert.ToDecimal(lsDS[j].ID);
                //    GDTTT_DON_DUONGSU_CC objDSdon = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.ID == vDuongSu_don).Single();
                //    if (objDSdon != null)
                //    {
                //        dt.GDTTT_DON_DUONGSU_CC.Remove(objDSdon);
                //        dt.SaveChanges();
                //    }

                //}
            }
        }
        Boolean CheckKQGQ(Decimal VuAnID)
        {
            GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
            if (objVA != null)
            {
                int LoaiKQ = String.IsNullOrEmpty(objVA.GQD_LOAIKETQUA + "") ? 5 : Convert.ToInt16(objVA.GQD_LOAIKETQUA + "");
                if (LoaiKQ < 5)
                {
                    return true;
                }
                else
                    return false;
            }
            else return false;
        }
        Decimal CheckMapVuAn(Decimal donid, Decimal Donvid)
        {
            //Kiem tra da co vu an (theo so an, ngayxu, toa xu) chua
            //neu vuan chua co kq giai quyet don --> cho ghep vu an--> currVuAnID>0
            //da co--> cho them mới --> CurrVuAnid=0
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == donid).FirstOrDefault();
            Decimal CurrVuAnID = 0;

            List<GDTTT_VUAN> lst = null;
            //Loại đơn là 4 = Hồ sơ kháng nghị VKS thi luôn tạo Vụ án mới
            if (oDon.LOAIDON != 4)
            {
                if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                                 && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                                                 && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                                                 //&& x.GQD_LOAIKETQUA == null
                                                                 && x.TOAANID == Donvid
                                                                )
                                        .OrderByDescending(x => x.NGAYTAO).ToList();
                }
                else if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {
                    lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_PT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                             && x.NGAYXUPHUCTHAM == oDon.BAQD_NGAYBA_PT
                                                             && x.TOAPHUCTHAMID == oDon.BAQD_TOAANID_PT
                                                            //&& x.GQD_LOAIKETQUA == null
                                                            && x.TOAANID == Donvid
                                                            )
                                        .OrderByDescending(x => x.NGAYTAO).ToList();
                    //Nếu cấp PT không có thì KT cấp  ST
                    if (donid > 0 && (lst == null || lst.Count == 0))
                    {
                        if (oDon.BAQD_NGAYBA_ST != null)
                        {
                            lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                       && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                                       && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                                      //&& x.GQD_LOAIKETQUA == null
                                                      && x.TOAANID == Donvid
                                                      )
                                        .OrderByDescending(x => x.NGAYTAO).ToList();
                        }
                    }
                }
                else if (oDon.BAQD_CAPXETXU == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lst = dt.GDTTT_VUAN.Where(x => x.SO_QDGDT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                            && x.NGAYQD == oDon.BAQD_NGAYBA
                                                            && x.TOAQDID == oDon.BAQD_TOAANID
                                                           //&& x.GQD_LOAIKETQUA == null
                                                           && x.TOAANID == Donvid
                                                           )
                                        .OrderByDescending(x => x.NGAYTAO).ToList();
                    //Nếu cấp GDT không có thì KT cấp PT và ST
                    if (donid > 0 && (lst == null || lst.Count == 0))
                    {

                        //Kt BA PT neu có
                        if (oDon.BAQD_NGAYBA_PT != null)
                        {
                            lst = dt.GDTTT_VUAN.Where(x => x.SOANPHUCTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_PT.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                            && x.NGAYXUPHUCTHAM == oDon.BAQD_NGAYBA_PT
                                                            && x.TOAPHUCTHAMID == oDon.BAQD_TOAANID_PT
                                                           //&& x.GQD_LOAIKETQUA == null
                                                           && x.TOAANID == Donvid
                                                           )
                                                 .OrderByDescending(x => x.NGAYTAO).ToList();
                            //Kiem tra BA ST nếu BA PT ko đúng
                            if (lst == null || lst.Count == 0)
                            {
                                if (oDon.BAQD_NGAYBA_ST != null)
                                {
                                    lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                          && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                                          && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                                          && x.TOAANID == Donvid
                                                         //&& x.GQD_LOAIKETQUA == null
                                                         )
                                                     .OrderByDescending(x => x.NGAYTAO).ToList();
                                }
                            }
                        }//Kiem tra BA ST nếu không có BA PT
                        else if (oDon.BAQD_NGAYBA_ST != null)
                        {
                            lst = dt.GDTTT_VUAN.Where(x => x.SOANSOTHAM.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "") == oDon.BAQD_SO_ST.Trim().ToLower().Replace("-", "").Replace("_", "").Replace(" ", "")
                                                      && x.NGAYXUSOTHAM == oDon.BAQD_NGAYBA_ST
                                                      && x.TOAANSOTHAM == oDon.BAQD_TOAANID_ST
                                                      && x.TOAANID == Donvid
                                                     //&& x.GQD_LOAIKETQUA == null
                                                     )
                                                .OrderByDescending(x => x.NGAYTAO).ToList();
                        }

                    }
                }
            }
            if (lst != null && lst.Count > 0)
            {
                for (int i = 0; i < lst.Count; i++)
                {
                    GDTTT_VUAN objVA = lst[0];
                    int LoaiKQ = String.IsNullOrEmpty(objVA.GQD_LOAIKETQUA + "") ? 5 : Convert.ToInt16(objVA.GQD_LOAIKETQUA + "");
                    if (LoaiKQ == 5)
                        CurrVuAnID = objVA.ID;
                    else
                        CurrVuAnID = 0;
                }

            }

            return CurrVuAnID;
        }
        decimal ThemNguoiKhieuNai(Decimal CurrVuAnID, String TenDS)
        {
            String TenNguoiKhieuNai = TenDS.Trim().ToLower();
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID
                                                                         && x.HS_ISKHIEUNAI == 1
                                                                         && x.TENDUONGSU.Trim().ToLower() == TenNguoiKhieuNai).ToList();
            if (lst == null || lst.Count == 0)
            {
                obj = new GDTTT_VUAN_DUONGSU();
                obj.VUANID = CurrVuAnID;
                obj.LOAI = 0;
                obj.GIOITINH = 2;
                obj.BICAOID = 0;
                obj.HS_TUCACHTOTUNG = "";
                //----------------------
                obj.HS_ISKHIEUNAI = 1;
                obj.HS_BICANDAUVU = 0;
                obj.HS_ISBICAO = 0;
                //----------------------
                obj.TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.KHAC;
                obj.TENDUONGSU = Cls_Comon.FormatTenRieng(TenDS.Trim());
                obj.HS_MUCAN = "";
                obj.DIACHI = "";
                //----------------------
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                dt.GDTTT_VUAN_DUONGSU.Add(obj);
                dt.SaveChanges();
            }
            //-------------------------
            return obj.ID;
        }
        void Update_TenVuAn(Decimal vuanid)
        {
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == vuanid).Single();
            Decimal CurrVuAnID = vuanid;
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
        protected void Ins_Update_vuan()
        {
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            Decimal CurrThamPhanID = 0;
            Decimal DonID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            Decimal VuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");

            Decimal ismap_vuan = (String.IsNullOrEmpty(Request["ismap_vuan"] + "")) ? 0 : Convert.ToDecimal(Request["ismap_vuan"] + "");
            Decimal isthuly = (String.IsNullOrEmpty(Request["isthuly"] + "")) ? 0 : Convert.ToDecimal(Request["isthuly"] + "");
            string ARRDONTRUNG = Request["ARRDONTRUNG"] + "";
            Decimal PhongbanID = (String.IsNullOrEmpty(Request["PhongbanID"] + "")) ? 0 : Convert.ToDecimal(Request["PhongbanID"] + "");
            DateTime? vNgayNhan = Request["vNgayNhan"] + "" == "" ? (DateTime?)null : DateTime.Parse(Request["vNgayNhan"] + "", cul, DateTimeStyles.NoCurrentDateDefault);
            int iCount = 0;
            //----------------------------
            Boolean IsKQ = true;
            //Kiem tra xem vu an da co KQ chua
            if (VuAnID > 0)
                IsKQ = CheckKQGQ(VuAnID);
            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (oT.LOAIDON == 4)
            {
                //Đơn là Hồ sơ của VKS thì mặc định tạo vụ án nếu đơn đó chưa có VỤ án
                //Tao vu an khi đơn chưa có Vụ án
                if (VuAnID == 0)
                {
                    VuAnID = TaoVuAn_ThuLyMoi(DonID, null, ismap_vuan);
                    Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                    if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                    {
                        List<GDTTT_DON_DUONGSU_CC> lsDS = null;
                        lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DonID).ToList();
                        if (lsDS.Count > 0)
                        {
                            ADD_BICAO_DON(DonID, VuAnID);
                        }
                        else
                        {
                            //Them bi cao dau vu neu cua vu an da ton toi Neu Don khong co bi cao
                            ADD_BiCaoDauVu(DonID, VuAnID);
                        }
                    }
                    else
                    {
                        //Them nguyen don, bi don
                        ADD_DUONGSU_DON(DonID, VuAnID);
                    }

                }
            }
            else
            {
                //Đơn; Đơn + Công văn; Công Văn; Công Văn + Hồ sơ
                if (isthuly == 1)
                {
                    CurrThamPhanID = String.IsNullOrEmpty(oT.THAMPHANID + "") ? 0 : (Decimal)oT.THAMPHANID;
                    try
                    {   // khi don.vuviecid >0 thì ismap_vuan >0
                        if (ismap_vuan > 0)
                        {
                            //KT : vu an da co ket qua giai quyet (IsKQ == true)--> Them moi
                            //Chua co kqgq--> ghep vu an                               
                            if (IsKQ)
                            {
                                //Tao vu an
                                if (VuAnID == 0)
                                {
                                    VuAnID = TaoVuAn_ThuLyMoi(DonID, null, ismap_vuan);

                                    Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                                    if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                                    {
                                        List<GDTTT_DON_DUONGSU_CC> lsDS = null;
                                        lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DonID).ToList();
                                        if (lsDS.Count > 0)
                                        {
                                            ADD_BICAO_DON(DonID, VuAnID);
                                        }
                                        else
                                        {
                                            //Them bi cao dau vu neu cua vu an da ton toi Neu Don khong co bi cao
                                            ADD_BiCaoDauVu(DonID, VuAnID);
                                        }
                                    }
                                    else
                                    {
                                        //Them nguyen don, bi don
                                        ADD_DUONGSU_DON(DonID, VuAnID);
                                    }

                                }
                            }
                        }
                        else
                        {
                            //chua map vu an--> can kiem tra xem co thong tin vuan tuong ung chua
                            VuAnID = CheckMapVuAn(DonID, ToaAnID);
                            //Tao vu an
                            if (VuAnID == 0)
                            {
                                VuAnID = TaoVuAn_ThuLyMoi(DonID, null, ismap_vuan);
                                //Them duong su tu DOn
                                Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                                if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                                {
                                    List<GDTTT_DON_DUONGSU_CC> lsDS = null;
                                    lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DonID).ToList();
                                    if (lsDS.Count > 0)
                                    {
                                        ADD_BICAO_DON(DonID, VuAnID);
                                    }
                                    else
                                    {
                                        //Them bi cao dau vu neu cua vu an da ton toi Neu Don khong co bi cao
                                        ADD_BiCaoDauVu(DonID, VuAnID);
                                    }
                                }
                                else
                                {
                                    //Them nguyen don, bi don
                                    ADD_DUONGSU_DON(DonID, VuAnID);
                                }
                            }

                        }

                    }
                    catch (Exception ex) { }
                }
                else
                {
                    if (ismap_vuan == 0)
                    {
                        // don ko phai la thu ly moi, ko map vu an
                        //--> KT trong cac don chuyen cung
                        //--> neu co don la ThuLyMoi 
                        //--> Tao vu an truoc roi moi ghep don dang nhan vao vụ an
                        try
                        {
                            string ArrDonID = String.IsNullOrEmpty(ARRDONTRUNG) ? "" : ("," + ARRDONTRUNG + ",");
                            List<GDTTT_DON> lst = dt.GDTTT_DON.Where(x => x.ISTHULY == 1
                                                                        && ArrDonID.Contains("," + x.ID + ",")).ToList();
                            if (lst != null && lst.Count > 0)
                            {
                                //Tao vu an moi tu Don co trang thai = thu ly moi
                                GDTTT_DON oDon = lst[0];
                                CurrThamPhanID = String.IsNullOrEmpty(oDon.THAMPHANID + "") ? 0 : (Decimal)oDon.THAMPHANID;
                                VuAnID = CheckMapVuAn(oDon.ID, ToaAnID);
                                if (VuAnID == 0)
                                {
                                    VuAnID = TaoVuAn_ThuLyMoi(oDon.ID, oDon, 0);
                                    //Them duong su tu DOn
                                    Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                                    if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                                    {
                                        List<GDTTT_DON_DUONGSU_CC> lsDS = null;
                                        lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DonID).ToList();
                                        if (lsDS.Count > 0)
                                        {
                                            ADD_BICAO_DON(DonID, VuAnID);
                                        }
                                        else
                                        {
                                            //Them bi cao dau vu neu cua vu an da ton toi Neu Don khong co bi cao
                                            ADD_BiCaoDauVu(DonID, VuAnID);
                                        }
                                    }
                                    else
                                    {
                                        //Them nguyen don, bi don
                                        ADD_DUONGSU_DON(DonID, VuAnID);
                                    }
                                }
                            }
                        }
                        catch (Exception ex) { }
                    }
                }
            }
            //-----------------------------
            if (oT != null)
            {
                if ( oT.CD_LOAI == 0)//oT.CD_TRANGTHAI == 1 &&
                {
                    #region Update trang thai don
                    iCount += 1;
                    oT.CD_TRANGTHAI = 2;
                    //lưu ngày nhận theo người dùng nhập
                    oT.CD_NGAYXULY = vNgayNhan;
                    oT.VUVIECID = VuAnID;
                    dt.SaveChanges();
                    #endregion

                    #region update don chuyen
                    //Update danh sách lịch sử chuyển đơn;
                    List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID
                                                                            && x.DONVINHANID == ToaAnID
                                                                            && x.PHONGBANNHANID == PhongbanID
                                                                          ).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                    if (lstC.Count > 0)
                    {

                        GDTTT_DON_CHUYEN oC = lstC[0];
                        //lưu ngày nhận thực tế
                        oC.NGAYNHAN = DateTime.Now;
                        oC.TRANGTHAI = 2;
                        oC.NGUOINHAN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oC.GHICHU = Session[SS_TK.HCTP_GHICHU] + ""; ;
                        dt.SaveChanges();
                    }

                    //Update danh sách các đơn chuyển cùng
                    string strArrDon = ARRDONTRUNG;
                    string[] strarr = strArrDon.Split(',');
                    if (strarr.Length > 1)
                    {
                        GDTTT_DON oDT = null;
                        Decimal currr_id = 0;
                        foreach (String item in strarr)
                        {
                            if (item.Length > 0)
                            {
                                currr_id = Convert.ToDecimal(item);
                                if (currr_id != oT.ID)
                                {
                                    oDT = dt.GDTTT_DON.Where(x => x.ID == currr_id).Single();
                                    oDT.CD_TRANGTHAI = 2;
                                    oDT.VUVIECID = VuAnID;
                                }
                            }
                        }

                        //List<GDTTT_DON> lstTrung = dt.GDTTT_DON.Where(x => x.ID != oT.ID && strArrDon.Contains("," + x.ID.ToString() + ",")).ToList();
                        //foreach (GDTTT_DON oDT in lstTrung)
                        //{
                        //    oDT.CD_TRANGTHAI = 2;
                        //    oDT.VUVIECID = VuAnID;
                        //}
                        dt.SaveChanges();
                    }
                    #endregion
                }
            }
            if (VuAnID > 0)
            {
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
                if (CurrThamPhanID > 0)
                    oVA.THAMPHANID = CurrThamPhanID;
                dt.SaveChanges();

                Decimal LoaiAn = String.IsNullOrEmpty(oT.BAQD_LOAIAN + "") ? 0 : (Decimal)oT.BAQD_LOAIAN;
                //Update Lại đơn
                GDTTT_DON objDon = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                objDon.VUVIECID = VuAnID;
                dt.SaveChanges();
                hddVuAnID.Value = Convert.ToString(VuAnID);
                //Them các nguoi khieu nai moi tu các don ghep vao vu an
                if (LoaiAn == Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU))
                {
                    List<GDTTT_DON> lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == VuAnID && x.ISTHULY == 1).ToList();
                    if (lstDon != null && lstDon.Count > 0)
                    {
                        foreach (GDTTT_DON oD in lstDon)
                            ThemNguoiKhieuNai(VuAnID, oD.NGUOIGUI_HOTEN);
                    }
                }
                //-----update thong tin : tongdon, isanqh, isanchidao, arrnguoikhieunai
                GDTTT_DON_BL objBL = new GDTTT_DON_BL();
                objBL.Update_Don_TH(VuAnID);
            }
            //--------------
            Update_TenVuAn(VuAnID);
        }
        //anhvh add 31/05/2021 END-----------
        /// /
        //------Bị cáo, Người khiếu nại----------
        Decimal GetVuanID()
        {
            string current_id = hddVuAnID.Value;
            if (current_id != "")
            {
                VuAnID = Convert.ToDecimal(current_id);
                Session["VUVIECID_CC"] = current_id;
            }
            return VuAnID;
        }
        protected void dropNguoiKhieuNai_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        void LoadDropNguoiKhieuNai()
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();

            dropNguoiKhieuNai.Items.Clear();
            dropNguoiKhieuNai.Items.Add(new ListItem("-----Chọn-----", "0"));
            DataTable tbl = objBL.AHS_GetAllByLoaiDS(CurrVuAnID, nguoikhieunai);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                string temp = "", tucachtt_khac = "";
                foreach (DataRow item in tbl.Rows)
                {
                    temp = item["TenDuongSu"] + "";
                    tucachtt_khac = (string.IsNullOrEmpty(item["HS_TuCachToTung"] + "") ? "" : (" (" + item["HS_TuCachToTung"] + ")"));
                    if (!temp.Contains(tucachtt_khac))
                        temp += tucachtt_khac;
                    dropNguoiKhieuNai.Items.Add(new ListItem(temp, item["ID"].ToString()));
                }
            }
        }
        protected void dropBiCao_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        protected void lkThemBiCao_Click(object sender, EventArgs e)
        {
            Decimal don_id = GetVuanID();
            try
            {
                Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_sua_ds(" + don_id + ",'')");
            }
            catch (Exception ex)
            {
                lttMsgBC.Text = ex.Message;
            }
        }
        void LoadDropBiCao()
        {
            Decimal vuan_id = 0;
            //----------------
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = new DataTable();
            vuan_id = GetVuanID();
            tbl = objBL.AHS_GetAllByLoaiDS(vuan_id, bicao);
            //--------------------
            dropBiCao.Items.Clear();
            dropBiCao.Items.Add(new ListItem("-----Chọn bị cáo-----", "0"));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                string temp = "", tucachtt_khac = "";
                foreach (DataRow item in tbl.Rows)
                {
                    temp = item["TenDuongSu"] + "";
                    tucachtt_khac = (string.IsNullOrEmpty(item["HS_TuCachToTung"] + "") ? "" : (" (" + item["HS_TuCachToTung"] + ")"));
                    if (!temp.Contains(tucachtt_khac))
                        temp += tucachtt_khac;
                    dropBiCao.Items.Add(new ListItem(temp, item["ID"].ToString()));
                }
            }
        }
        protected void cmdSaveDSHinhSu_Click(object sender, EventArgs e)
        {
            try
            {
                Decimal DuongSuID = 0;
                if (dropNguoiKhieuNai.SelectedValue == "0")
                {
                    lttMsgBC.Text = "Bạn phải chọn người khiếu nại";
                    return;
                }
                if (dropBiCao.SelectedValue == "0")
                {
                    lttMsgBC.Text = "Bạn phải chọn BC được khiếu nại";
                    return;
                }
                if (dropNguoiKhieuNai.SelectedValue != "")
                {
                    DuongSuID = Convert.ToDecimal(dropBiCao.SelectedValue);
                    Update_DuongSuKN(DuongSuID);
                }
                LoadDropBiCao();
                LoadDanhSachBiCao();
            }
            catch (Exception ex)
            {
                // lttMsgBC.Text = ex.Message;
            }
        }
        void Update_DuongSuKN(Decimal BiCaoID)
        {
            Decimal don_id = GetVuanID();
            //-------------
            Boolean IsUpdate = false;
            GDTTT_VUAN_DS_KN oKN = new GDTTT_VUAN_DS_KN();
            Decimal NguoiKhieuNaiId = Convert.ToDecimal(dropNguoiKhieuNai.SelectedValue);
            GDTTT_VUAN_DS_KN objDSKN = new GDTTT_VUAN_DS_KN();
            try
            {
                List<GDTTT_VUAN_DS_KN> lst = dt.GDTTT_VUAN_DS_KN.Where(x => x.VUANID == don_id
                                                                     && x.BICAOID == BiCaoID
                                                                     && x.NGUOIKHIEUNAIID == NguoiKhieuNaiId).ToList();
                if (lst != null && lst.Count > 0)
                {
                    oKN = lst[0];
                    IsUpdate = true;
                }
                else
                    oKN = new GDTTT_VUAN_DS_KN();
            }
            catch (Exception ex)
            {
                oKN = new GDTTT_VUAN_DS_KN();
            }
            oKN.BICAOID = BiCaoID;
            oKN.NGUOIKHIEUNAIID = NguoiKhieuNaiId;
            oKN.VUANID = don_id;
            oKN.NOIDUNGKHIEUNAI = txtNguoiKN_NoiDung.Text.Trim();
            if (!IsUpdate)
            {
                dt.GDTTT_VUAN_DS_KN.Add(oKN);
            }
            dt.SaveChanges();
        }
        protected void cmdRefresh_Click(object sender, EventArgs e)
        {
            LoadDanhSachBiCao();
            LoadDropNguoiKhieuNai();
            LoadDropBiCao();
            lttMsgBC.Text = string.Empty;
            txtNguoiKN_NoiDung.Text = string.Empty;
        }
        protected void cmd_load_dstd_cc_Click(object sender, EventArgs e)
        {
            LoadDanhSachBiCao();
        }
        public void LoadDanhSachBiCao()
        {
            Decimal don_id = 0;
            //----------------
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = new DataTable();
            don_id = GetVuanID();
            tbl = objBL.AnHS_GetAllDuongSu(don_id, "", 2);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows.Count);
                rptBiCao.DataSource = tbl;
                rptBiCao.DataBind();
                rptBiCao.Visible = true;
            }
            else rptBiCao.Visible = false;
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
                    txtNguoiKN_NoiDung.Text = arr[3] + "";
                    Cls_Comon.SetValueComboBox(dropNguoiKhieuNai, NguoiKhieuNaiID);
                    Cls_Comon.SetValueComboBox(dropBiCao, BiCaoID);
                    break;
                case "XoaKN":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    XoaDuongSu_AnHS_BCKN(curr_id);
                    LoadDanhSachBiCao();
                    LoadDropBiCao();
                    lttMsgBC.Text = "Bạn đã xóa thành công người được khiếu nại";
                    break;
            }
        }
        protected void rptBiCao_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                String temp = ""; VuAnID = GetVuanID();
                DataRowView dv = (DataRowView)e.Item.DataItem;
                Repeater rptBCKN = (Repeater)e.Item.FindControl("rptBCKN");
                Literal lttBiCao = (Literal)e.Item.FindControl("lttBiCao");
                Literal lttTenDS = (Literal)e.Item.FindControl("lttTenDS");
                //--------------------
                Literal lttSua = (Literal)e.Item.FindControl("lttSua");
                Literal ltt_them_td = (Literal)e.Item.FindControl("ltt_them_td");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                //--------------------
                lttSua.Visible = true;
                ltt_them_td.Visible = true;
                lbtXoa.Visible = true;
                /////----
                Control td_sua_div = e.Item.FindControl("td_sua_div");
                int is_nguoikn = Convert.ToInt16(dv["HS_IsKhieuNai"] + "");
                int is_bicao = Convert.ToInt16(dv["HS_IsBiCao"] + "");
                int is_dauvu = Convert.ToInt16(dv["HS_BiCanDauVu"] + "");

                lttSua.Text = "<a href='javascript:;' style='color:#0E7EEE' onclick='popup_them_sua_ds(" + VuAnID + "," + dv["ID"].ToString() + ");'>Sửa</a>";
                //----------------------
                ltt_them_td.Text = "<a href='javascript:;' style='color:#0E7EEE' onclick='popup_them_td_cc(" + dv["ID"].ToString() + ");'>Thêm tội danh</a>";

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
                        LoadDsNguoiDuocKN(Convert.ToDecimal(dv["ID"] + ""), dv["HS_NoiDungKhieuNai"] + "", rptBCKN, lttBiCao);
                    }
                    else
                    {
                        td_sua_div.Visible = true;
                        lttBiCao.Text = temp;

                        rptBCKN.Visible = false;
                        lttBiCao.Visible = true;
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
                            lttBiCao.Text = "<div style='float:left; width:100%; margin-bottom:3px;font-weight:bold;'>Người được khiếu nại:</div>";

                            rptBCKN.DataSource = tbl;
                            rptBCKN.DataBind();
                            td_sua_div.Visible = false;
                        }
                        else
                        {
                            td_sua_div.Visible = true;
                            lttBiCao.Text = "";
                            rptBCKN.Visible = false;
                            lttBiCao.Text = (String.IsNullOrEmpty(dv["HS_NoiDungKhieuNai"] + "") ? "" : ("</br>Khiếu nại: " + dv["HS_NoiDungKhieuNai"].ToString()));
                        }
                    }
                    catch (Exception ex)
                    {
                        lttBiCao.Text = (String.IsNullOrEmpty(dv["HS_NoiDungKhieuNai"] + "") ? "" : ("</br>Khiếu nại: " + dv["HS_NoiDungKhieuNai"].ToString()));
                    }
                }
            }
        }
        protected void rptBiCao_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0; VuAnID = GetVuanID();
            VuAnID = GetVuanID();
            switch (e.CommandName)
            {
                case "Sua":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_sua_ds(" + VuAnID + ", " + curr_id + ");");
                    break;
                case "them_td":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_td_cc(" + curr_id + ");");
                    break;
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == curr_id).FirstOrDefault();
                    if (oT.HS_ISKHIEUNAI == 1)
                    {
                        lttMsgBC.Text = "Bạn không thể xóa được người khiếu nại.";
                    }
                    else
                    {
                        XoaDuongSu_AnHS(curr_id);
                        LoadDanhSachBiCao();
                        LoadDropBiCao();
                        lttMsgBC.Text = "Xóa bị cáo thành công";
                    }
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
        void XoaDuongSu_AnHS_BCKN(decimal curr_duongsu_id)
        {
            if (curr_duongsu_id > 0)
            {
                GDTTT_VUAN_DS_KN oT = dt.GDTTT_VUAN_DS_KN.Where(x => x.ID == curr_duongsu_id).FirstOrDefault();
                if (oT != null)
                {
                    //XoaAllToiDanh(Convert.ToDecimal(oT.BICAOID));
                    Xoa_KN(Convert.ToDecimal(oT.BICAOID));
                    //------------------------------------
                    GDTTT_VUAN_DUONGSU oTs = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == oT.BICAOID).FirstOrDefault();
                    if (oTs.HS_ISKHIEUNAI == 1)
                    {
                        XoaAllToiDanh(Convert.ToDecimal(oT.BICAOID));
                        oTs.HS_ISBICAO = 0;
                        oTs.HS_BICANDAUVU = 0;
                        oTs.NAMSINH = null;
                        oTs.HS_MUCAN = null;
                    }
                    dt.SaveChanges();
                }
                //------------------------------------
                // Update_TenVuAn(null);
            }
            lttMsgBC.Text = "Bạn đã xóa thành người được khiếu nại";
        }
        void Xoa_KN(Decimal BiCaoID)
        {
            Decimal vuan_id = GetVuanID();
            //-------------------------------------
            List<GDTTT_VUAN_DS_KN> lst = dt.GDTTT_VUAN_DS_KN.Where(x => x.VUANID == vuan_id
                                                                    && x.BICAOID == BiCaoID
                                                                ).ToList<GDTTT_VUAN_DS_KN>();
            foreach (GDTTT_VUAN_DS_KN item in lst)
            {
                dt.GDTTT_VUAN_DS_KN.Remove(item);
            }
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
            LoadDropBiCao();
            LoadDanhSachBiCao();
        }
        //------Bị cáo, Người khiếu nại----end------
    }
}