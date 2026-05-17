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
namespace WEB.GSTP.QLAN.GDTTT.VuAn.DonKNTP
{
    public partial class ThongtinKNTP : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";
        String SessionTTV = "GDTTT_TTV";
        public decimal VuAnID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            VuAnID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    chkModify_TP.Visible = chkModify_TTV.Visible = false;
                    LoadComponent();
                    if (Request["ID"] != null)
                    {
                        hddID.Value = Request["ID"] + "";
                        try
                        {
                            LoadInfoVuAn();
                        }
                        catch (Exception ex) { }

                    }

                    if (Request["type"] != null)
                    {
                        if (Request["type"].ToString() == "renew")
                        {
                            lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
                            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công! Bạn có thể tiếp tục cập nhật vụ án mới";
                        }
                    }
                    txtSoThuLy.Focus();
                }
            }
            else Response.Redirect("/Login.aspx");
        }

        //-------------------------------------------
        void LoadComponent()
        {

            LoadDropToaAn();
            LoadLoaiAnTheoVu();
            LoadDMQuanHePL();
            try
            {
                LoadDropTTV();
                LoadPCA();
            }
            catch (Exception ex) { }
            LoadQHPLTK();
            hddGUID.Value = Guid.NewGuid().ToString();

        }
        private void LoadQHPLTK()
        {
            dropQHPLThongKe.Items.Clear();
            string strLoaiAn = dropLoaiAn.SelectedValue;

            if (strLoaiAn == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                dropQHPLThongKe.DataSource = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == 5 && x.LOAI == 2).OrderBy(x => x.TENTOIDANH).ToList();
                dropQHPLThongKe.DataTextField = "TENTOIDANH";
                dropQHPLThongKe.DataValueField = "ID";
                dropQHPLThongKe.DataBind();
                dropQHPLThongKe.Items.Insert(0, new ListItem("Chọn", "0"));
                return;
            }
            List<DM_QHPL_TK> lstDM = null;
            switch (strLoaiAn)
            {
                case ENUM_LOAIVUVIEC.AN_DANSU:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.DANSU && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_HANHCHINH:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HONNHAN_GIADINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.KINHDOANH_THUONGMAI && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_LAODONG:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.LAODONG && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
                case ENUM_LOAIVUVIEC.AN_PHASAN:
                    lstDM = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
                    break;
            }
            dropQHPLThongKe.DataSource = lstDM;
            dropQHPLThongKe.DataTextField = "CASE_NAME";
            dropQHPLThongKe.DataValueField = "ID";
            dropQHPLThongKe.DataBind();
            dropQHPLThongKe.Items.Insert(0, new ListItem("Chọn", "0"));
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



        //thoing nx 09102019

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
            if (obj.ISDANSU == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                count_loaian++;
            }
            if (obj.ISHANHCHINH == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                count_loaian++;
            }
            if (obj.ISHNGD == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                count_loaian++;
            }
            if (obj.ISKDTM == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                count_loaian++;
            }
            if (obj.ISLAODONG == 1)
            {
                dropLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                count_loaian++;
            }
            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            if (count_loaian > 1)
                dropLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        //---------------------------
        protected void dropLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDMQuanHePL();
            LoadQHPLTK();
            Cls_Comon.SetFocus(this, this.GetType(), dropQHPL.ClientID);
        }


        void LoadDMQuanHePL()
        {
            try
            {
                int LoaiAn = Convert.ToInt16(dropLoaiAn.SelectedValue);
                List<GDTTT_DM_QHPL> lst = dt.GDTTT_DM_QHPL.Where(x => x.LOAIAN == LoaiAn).OrderBy(y => y.TENQHPL).ToList();
                if (lst != null && lst.Count > 0)
                {
                    dropQHPL.Items.Clear();
                    dropQHPL.DataSource = lst;
                    dropQHPL.DataTextField = "TenQHPL";
                    dropQHPL.DataValueField = "ID";
                    dropQHPL.DataBind();
                    dropQHPL.Items.Insert(0, new ListItem("Chọn", "0"));
                }
            }
            catch (Exception ex) { }
        }

        //-----------------------
        protected void dropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal toa_an_id = Convert.ToDecimal(dropToaAn.SelectedValue);
            if (toa_an_id > 0)
            {
                DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                string banan_pt = txtSoBA.Text.Trim();
                if (!string.IsNullOrEmpty(banan_pt)) Cls_Comon.SetFocus(this, this.GetType(), txtSoBA.ClientID);
            }
            else
            {
                Cls_Comon.SetFocus(this, this.GetType(), dropToaAn.ClientID);
            }
        }

        //--------------------------------

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

        protected void dropTTV_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (dropTTV.SelectedValue != "0")
            //{
            //    decimal thamtravien = Convert.ToDecimal(dropTTV.SelectedValue);
            //    GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            //}
            //else
            //    LoadDropLanhDao();
            //Cls_Comon.SetFocus(this, this.GetType(), dropLanhDao.ClientID);
        }

        protected void LoadPCA()
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
            Decimal CurrDonID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrDonID).Single();
            if (obj != null)
            {
                //----truong hop thu ly Mac dinh la Khieu nai tu phap------------   
                Cls_Comon.SetValueComboBox(dropLoaiGDT, 8);
                //Kết quả Khiếu nại tư pháp
                pnKetQua.Visible = true;

                //----thong tin thu ly-----------------
                txtSoThuLy.Text = obj.SOTHULYDON + "";
                txtNgayThuLy.Text = (String.IsNullOrEmpty(obj.NGAYTHULYDON + "") || (obj.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);
                txtNguoiDeNghi.Text = obj.NGUOIKHIEUNAI + "";
                txtNgayTrongDon.Text = (String.IsNullOrEmpty(obj.NGAYTRONGDON + "") || (obj.NGAYTRONGDON == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTRONGDON).ToString("dd/MM/yyyy", cul);
                txtNgayNhanDon.Text = (String.IsNullOrEmpty(obj.NGAYNHANDONDENGHI + "") || (obj.NGAYNHANDONDENGHI == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYNHANDONDENGHI).ToString("dd/MM/yyyy", cul);
                txtNguoiDeNghi_DiaChi.Text = obj.DIACHINGUOIDENGHI;

                //---------thong tin BA/QD----------------------
                try
                {
                    if (obj.LOAIAN < 10)
                        dropLoaiAn.SelectedValue = "0" + obj.LOAIAN + "";
                    else
                        dropLoaiAn.SelectedValue = obj.LOAIAN + "";
                    LoadDMQuanHePL();
                    LoadQHPLTK();
                }
                catch (Exception exx) { }
                if (obj.BAQD_CAPXETXU == 4)
                {
                    hddIsAnPT.Value = "GDT";
                    if (obj.TOAQDID > 0)
                    {
                        LoadDropToaPT_TheoGDT(Convert.ToDecimal(obj.TOAQDID));
                    }
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);

                    }

                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = false;

                }
                else if (obj.BAQD_CAPXETXU == 3)
                {
                    hddIsAnPT.Value = "PT";
                    LoadDropToaAn();
                    if (obj.TOAPHUCTHAMID > 0)
                    {
                        Cls_Comon.SetValueComboBox(dropToaAn, obj.TOAPHUCTHAMID);

                    }
                    lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;

                }

                if (obj.BAQD_CAPXETXU != null)
                    Cls_Comon.SetValueComboBox(ddlLoaiBA, obj.BAQD_CAPXETXU);
                txtSoBA.Text = obj.SOANPHUCTHAM + "";
                txtNgayBA.Text = (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);



                //-------------------------------
                txtQHPL_TEXT.Text = obj.QHPL_TEXT;
                //----------thong tin TTV/LD---------------------
                LoadnInfo_TTV_LD_TP(obj);

                if (obj.GQD_LOAIKETQUA != null)
                {
                    rdbLoai.SelectedValue = obj.GQD_LOAIKETQUA.ToString();
                    lbl_GQD_NgayCV.Text = "Ngày phát hành";
                    txtGQD_NgayCV.Text = (String.IsNullOrEmpty(obj.GQD_NGAYPHATHANHCV + "") || (obj.GQD_NGAYPHATHANHCV == DateTime.MinValue)) ? "" : ((DateTime)obj.GQD_NGAYPHATHANHCV).ToString("dd/MM/yyyy", cul);
                    txtTLD_So.Text = obj.GDQ_SO + "";
                    txtTLD_NguoiKy.Text = obj.GDQ_NGUOIKY + "";
                    if (obj.GDQ_NGAY != null) txtTLD_Ngay.Text = ((DateTime)obj.GDQ_NGAY).ToString("dd/MM/yyyy", cul);
                    rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = rdbLoai.Items[4].Enabled = false;
                    txtTLD_Ghichu.Text = obj.GQD_GHICHU + "";
                }

            }
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
            }
            else
            {
                txtNgayphancong.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGTTV + "") || (obj.NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);
                tempID = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);
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

            }
            //-------------------------------

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
                        dropThamPhan.Enabled = false;
                }
                else
                {
                    if (objDon.Count > 0)
                    {
                        dropThamPhan.Enabled = false;
                        //manhnd chi ap dung cho TAND Cap Cao
                        if (CurrDonViID != 1)
                            dropThamPhan.Enabled = true;
                    }
                    else
                        dropThamPhan.Enabled = true;
                }

            }
            catch (Exception ex) { dropThamPhan.Enabled = false; }

            //-------------------------------
            txtGhiChu.Text = obj.GHICHU;


        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {

            GDTTT_VUAN obj = Update_VuAn();


            ClearForm(false);
            //Response.Redirect("ThongtinKNTP.aspx?type=renew");
            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công! Bạn có thể tiếp tục cập nhật vụ án mới";
            lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {

            GDTTT_VUAN obj = Update_VuAn();
            //-----update thong tin : tongdon, isanqh, isanchidao, arrnguoikhieunai
            GDTTT_DON_BL objBL = new GDTTT_DON_BL();
            objBL.Update_Don_TH(obj.ID);
            lttMsgT.ForeColor = lttMsg.ForeColor = System.Drawing.Color.Blue;
            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công!";
        }

        GDTTT_VUAN Update_VuAn()
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");

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

            obj.LOAI_GDTTTT = Convert.ToInt16(dropLoaiGDT.SelectedValue); //măc dinh la Khieu nai tu phap
            //-----Truong hop thu ly--------------
            obj.TRUONGHOPTHULY = 8;

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

            obj.NGUOIKHIEUNAI = Cls_Comon.FormatTenRieng(txtNguoiDeNghi.Text.Trim());
            obj.DIACHINGUOIDENGHI = txtNguoiDeNghi_DiaChi.Text.Trim();


            obj.LOAIAN = Convert.ToInt16(dropLoaiAn.SelectedValue);

            //------Thong tin QD GDT bị đề nghị------------------
            obj.BAQD_CAPXETXU = Convert.ToInt16(ddlLoaiBA.SelectedValue);

            if (dropToaAn.SelectedValue != "0" && dropToaAn.SelectedValue != null)
                obj.TOAPHUCTHAMID = Convert.ToDecimal(dropToaAn.SelectedValue);
            obj.SOANPHUCTHAM = txtSoBA.Text.Trim();
            if (!String.IsNullOrEmpty(txtNgayBA.Text.Trim()))
                obj.NGAYXUPHUCTHAM = DateTime.Parse(this.txtNgayBA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYXUPHUCTHAM = null;
            // Nội dung khiếu lại
            obj.QHPL_TEXT = txtQHPL_TEXT.Text.Trim();


            if (!String.IsNullOrEmpty(txtNgayphancong.Text.Trim()))
            {
                obj.NGAYPHANCONGTTV = DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            obj.THAMTRAVIENID = Convert.ToDecimal(dropTTV.SelectedValue);
            obj.TENTHAMTRAVIEN = (dropTTV.SelectedValue == "0") ? "" : Cls_Comon.FormatTenRieng(dropTTV.SelectedItem.Text);


            if (!String.IsNullOrEmpty(txtNgayNhanTieuHS.Text.Trim()))
                obj.NGAYTTVNHAN_THS = DateTime.Parse(this.txtNgayNhanTieuHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYTTVNHAN_THS = null;


            if (!String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim()))
                obj.NGAYVUGDNHAN_THS = DateTime.Parse(this.txtNgayGDNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else obj.NGAYVUGDNHAN_THS = null;

            //---------Manh bo khong cho update------------------

            if (Convert.ToDecimal(dropThamPhan.SelectedValue) > 0)
                obj.THAMPHANID = Convert.ToDecimal(dropThamPhan.SelectedValue);
            //---------------------------------
            obj.GHICHU = txtGhiChu.Text.Trim();
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
                // kiem tra neu vu an co ket qua GQD roi thi khong cap nhat lai Trangthaiid nua
                if (obj.GQD_LOAIKETQUA == null)
                {
                    decimal TTV = (string.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : (Decimal)obj.THAMTRAVIENID;
                    if (TTV > 0)
                        obj.TRANGTHAIID = 2;
                    else obj.TRANGTHAIID = 1;

                }

                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
            }
            //-----------------------
            dt.SaveChanges();
            hddID.Value = obj.ID.ToString();

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
                    //manhnd them
                    DateTime ngaytao = System.DateTime.Now;
                    if (objHS.NGAYTAO == null)
                        ngaytao = System.DateTime.Now;
                    else
                        ngaytao = (DateTime)objHS.NGAYTAO;
                    // them mới
                    objHS = new GDTTT_QUANLYHS();
                    objHS.TRANGTHAI = 0;
                    objHS.VUANID = vuan_id;
                    objHS.SOPHIEU = GetNewSoPhieuNhanHS(3, ngaytao, CurrDonViID, PhongBanID);
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
        Decimal GetNewSoPhieuNhanHS(decimal loaiphieu, DateTime NgayTao, decimal DonviID, decimal PhongbanID)
        {
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastSoPhieuHS(loaiphieu, NgayTao, DonviID, PhongbanID);
            return SoCV;
        }


        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ClearForm(true);
        }
        void ClearForm(Boolean IsRefresh)
        {
            txtSoThuLy.Text = txtNguoiDeNghi.Text = "";
            txtNgayThuLy.Text = txtNgayTrongDon.Text = txtNgayNhanDon.Text = "";
            txtNguoiDeNghi_DiaChi.Text = "";
            //--------------------------------
            dropLoaiAn.SelectedIndex = 0;
            LoadDMQuanHePL();
            txtSoBA.Text = txtNgayBA.Text = "";
            dropToaAn.SelectedIndex = 0;
            dropLoaiAn.SelectedIndex = 0;
            dropQHPL.SelectedIndex = 0;
            dropQHPLThongKe.SelectedIndex = 0;

            //--------------------------------
            dropTTV.SelectedIndex = 0;
            dropThamPhan.SelectedIndex = 0;
            txtNgayNhanTieuHS.Text = "";
            txtNgayGDNhanHS.Text = "";
            txtGhiChu.Text = "";

            //--------------------------------
            if (IsRefresh == true && Request["ID"] != null)
                LoadInfoVuAn();

        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("KNTP.aspx");
        }
        //---------------------------


        //----Truong hop thu ly GĐT
        protected void dropLoaiGDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal truonghopGDT = Convert.ToDecimal(dropLoaiGDT.SelectedValue);
            //-- 1 là KN VKS
            if (truonghopGDT == 1)
            {
                pnThuLyDon.Visible = false;
                pnKetQua.Visible = true;

            }
            else if (truonghopGDT == 2 || truonghopGDT == 3)
            {
                pnThuLyDon.Visible = pnKetQua.Visible = false;
            }
            else
            {
                pnThuLyDon.Visible = pnKetQua.Visible = false;
            }


        }
        //-----------------------

        //--------------------------------------------------
        protected void cmdUpdateKNTP_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN oVA = new GDTTT_VUAN();

            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            if (CurrVuAnID == 0)
            {
                //obj = Update_VuAn();
                //CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
                lttMsgT.Text = "Bạn cần tạo thông tin vụ án trước!";

                return;

            }
            else if (CurrVuAnID > 0)
            {
                try
                {
                    //update thong tin vu an trươc
                    oVA = Update_VuAn();
                    oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                    if (oVA != null)
                        IsUpdate = true;
                    else
                        oVA = new GDTTT_VUAN();
                }
                catch (Exception ex) { oVA = new GDTTT_VUAN(); }
            }

            if (IsUpdate)
            {
                //-Thong tin KN của VKS---------
                oVA.GQD_NGAYPHATHANHCV = (String.IsNullOrEmpty(txtGQD_NgayCV.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtGQD_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                //-----------------------------                
                oVA.NGUOIKHANGNGHI = 0;
                oVA.THAMQUYENXXGDT = 0;
                oVA.GQD_GHICHU = txtTLD_Ghichu.Text;

                //-----------------------------------
                string loai = rdbLoai.SelectedValue;
                oVA.GQD_LOAIKETQUA = Convert.ToDecimal(loai);

                oVA.GDQ_SO = txtTLD_So.Text;
                string ngay_temp = "";
                ngay_temp = txtTLD_Ngay.Text.Trim();
                oVA.GDQ_NGAY = (String.IsNullOrEmpty(txtTLD_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oVA.GDQ_NGUOIKY = txtTLD_NguoiKy.Text.Trim();
                oVA.GQD_KETQUA = rdbLoai.SelectedItem.Text + ": số " + oVA.GDQ_SO + " ngày " + ngay_temp;
                //-----------------------------------
                oVA.QUATRINH_GHICHU = txtTLD_Ghichu.Text;
                if (loai != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT.ToString())
                {
                    switch (loai)
                    {
                        case "0":
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.TRALOIDON; //Chap nhan KN
                            break;
                        case "1":
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.KHANGNGHI; //KHong chap nhan KN
                            break;
                        case "2":
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XEPDON;
                            break;
                        case "3":
                            oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.XUlY_KHAC;
                            break;

                    }
                }

                dt.SaveChanges();

                lttMsgKNTP.ForeColor = System.Drawing.Color.Blue;
                lttMsgKNTP.Text = "Cập nhật dữ liệu thành công!";

                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");

            }

        }
        protected void cmdXoa_GQKN_Click(object sender, EventArgs e)
        {
            decimal VuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            decimal trangthai_id = 0;

            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVA != null)
            {
                trangthai_id = (decimal)oVA.TRANGTHAIID;
                oVA.GQD_LOAIKETQUA = null;
                oVA.GQD_KETQUA = "";
                oVA.GDQ_SO = oVA.GDQ_NGUOIKY = oVA.GQD_GHICHU = "";
                oVA.GDQ_NGAY = oVA.GQD_NGAYPHATHANHCV = null;
                //-------------------
                SetTrangThai(oVA);
                //------------------------------
                dt.SaveChanges();

                //------------------------------
                ClearForm();
                lttMsgKNTP.ForeColor = System.Drawing.Color.Blue;
                lttMsgKNTP.Text = "Xóa kết quả giải quyết đơn thành công!";

                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
        }
        GDTTT_VUAN SetTrangThai(GDTTT_VUAN oVA)
        {
            oVA.ISTOTRINH = 0;
            decimal THAMTRAVIENID = (string.IsNullOrEmpty(oVA.THAMTRAVIENID + "")) ? 0 : (decimal)oVA.THAMTRAVIENID;
            if (THAMTRAVIENID > 0)
                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV;
            else
                oVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
            return oVA;
        }
        void ClearForm()
        {
            rdbLoai.SelectedValue = "0";

            rdbLoai.Items[0].Enabled = rdbLoai.Items[1].Enabled = rdbLoai.Items[2].Enabled = rdbLoai.Items[3].Enabled = true;

            txtTLD_So.Text = txtTLD_Ngay.Text = txtTLD_NguoiKy.Text = "";

            txtGQD_NgayCV.Text = txtTLD_Ghichu.Text = "";
        }

        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {

        }
        protected void txtTLD_Ngay_TextChanged(object sender, EventArgs e)
        {
            decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            decimal CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (CurrDonViID != 1)
            {
                Decimal CurrDonID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
                GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrDonID).Single();
                //string loaiso = rdbLoai.SelectedValue;

                if (oVA.LOAIAN != null)
                {

                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    decimal so_ = 0;
                    //string loai = rdbLoai.SelectedValue;
                    so_ = oBL.ThongTinKhieuNai_GETMAXTT(CurrDonViID, DateTime.Parse(this.txtTLD_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).Year, oVA.LOAIAN.Value.ToString());
                    txtTLD_So.Text = Convert.ToString(so_);
                }
            }
        }
        //------------------------------

    }
}