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
    public partial class pVuAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";
        String SessionTTV = "pGDTTT_TTV";
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

                    if (Request["type"] == null)
                    {
                        hddSoND.Value = hddSoBD.Value = "1";
                        DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                        rptNguyenDon.DataSource = tbl;
                        rptNguyenDon.DataBind();

                        tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
                        rptBiDon.DataSource = tbl;
                        rptBiDon.DataBind();

                        hddSoDSKhac.Value = "0";
                        tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                        rptDsKhac.DataSource = tbl;
                        rptDsKhac.DataBind();
                    }
                    else hddThuLyLaiVuAnID.Value = Request["vID"] + "";

                    LoadThongTinDon();
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
                    //----thong tin thu ly-----------------
                    if (oDon.LOAIDON == 4)
                    {
                        hddLoaiDon.Value = oDon.LOAIDON.ToString();
                        LoadDropNGuoiKy_VKS();
                        pnThuLY.Visible = false;
                        pnHoSoVKS.Visible = true;
                        txtSoThuLy.Text = null;
                        txtNgayThuLy.Text = null;

                        txtVKS_So.Text = oDon.SO_HSKN + "";
                        txtVKS_So.Enabled = false;
                        if (oDon.NGAY_HSKN != null)
                        {
                            if (((DateTime)oDon.NGAY_HSKN).ToString("dd/MM/yyyy") != "01/01/0001")
                            {
                                txtVKS_Ngay.Text = ((DateTime)oDon.NGAY_HSKN).ToString("dd/MM/yyyy");
                                txtVKS_Ngay.Enabled = false;
                            }
                        }
                        dropVKS_NguoiKy.SelectedValue = oDon.DONVICHUYEN_HSKN + "";
                        dropVKS_NguoiKy.Enabled = false;
                    }
                    else
                    {
                        hddLoaiDon.Value = oDon.LOAIDON.ToString();
                        pnThuLY.Visible = true;
                        pnHoSoVKS.Visible = false;
                        //Nếu là CV kiến nghị kèm hồ so
                        if (oDon.LOAIDON == 9)
                        {
                            pnTTV.Visible = true;
                            txtNgayNhanHS.Text = System.DateTime.Today.ToString("dd/MM/yyyy");
                        }
                    }

                    if (oDon.ISTHULY == 1)
                    {
                        txtSoThuLy.Text = oDon.TL_SO + "";
                        txtNgayThuLy.Text = (String.IsNullOrEmpty(oDon.TL_NGAY + "") || (oDon.TL_NGAY == DateTime.MinValue)) ? "" : ((DateTime)oDon.TL_NGAY).ToString("dd/MM/yyyy", cul);
                    }
                    else
                    {
                        if (oDon.DONTRUNGID != null && oDon.DONTRUNGID > 0)
                        {
                            GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == oDon.DONTRUNGID).Single();
                            if (obj != null && obj.CD_TRANGTHAI == 2 && obj.ISTHULY == 1)
                            {
                                txtSoThuLy.Text = obj.TL_SO + "";
                                txtNgayThuLy.Text = (String.IsNullOrEmpty(obj.TL_NGAY + "") || (obj.TL_NGAY == DateTime.MinValue)) ? "" : ((DateTime)obj.TL_NGAY).ToString("dd/MM/yyyy", cul);
                            }
                        }
                    }


                    txtNguoiDeNghi.Text = oDon.NGUOIGUI_HOTEN + "";
                    txtNguoiDeNghi_DiaChi.Text = oDon.NGUOIGUI_DIACHI;

                    if (oDon.NGUOIGUI_HUYENID > 0)
                        txtNguoiDeNghi_DiaChi.Text += ", " + dt.DM_HANHCHINH.Where(x => x.ID == oDon.NGUOIGUI_HUYENID).FirstOrDefault().MA_TEN;
                    txtNgayTrongDon.Text = (String.IsNullOrEmpty(oDon.NGAYGHITRENDON + "") || (oDon.NGAYGHITRENDON == DateTime.MinValue)) ? "" : ((DateTime)oDon.NGAYGHITRENDON).ToString("dd/MM/yyyy", cul);
                    txtNgayNhanDon.Text = (String.IsNullOrEmpty(oDon.NGAYNHANDON + "") || (oDon.NGAYNHANDON == DateTime.MinValue)) ? "" : ((DateTime)oDon.NGAYNHANDON).ToString("dd/MM/yyyy", cul);

                    //---------thong tin BA/QD----------------------
                    try
                    {
                        if (oDon.BAQD_LOAIAN < 10)
                            dropLoaiAn.SelectedValue = "0" + oDon.BAQD_LOAIAN + "";
                        else
                            dropLoaiAn.SelectedValue = oDon.BAQD_LOAIAN + "";


                        LoadDMQuanHePL();
                    }
                    catch (Exception exx) { }

                    //-----------------------------
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
                    LoadLoaiAn(oDon.BAQD_CAPXETXU + "");


                    decimal thamphan_id = (String.IsNullOrEmpty(oDon.THAMPHANID + "")) ? 0 : Convert.ToDecimal(oDon.THAMPHANID);
                    try { Cls_Comon.SetValueComboBox(dropThamPhan, thamphan_id); } catch (Exception ex) { }

                    //---------------Thu ly lai -------------------------
                    if (Request["type"] != null && Request["type"].ToString() == "1")
                    {
                        decimal OldVuAnID = (string.IsNullOrEmpty(oDon.VUVIECID + "")) ? 0 : (decimal)oDon.VUVIECID;
                        hddVuAnID.Value = OldVuAnID + "";
                        LoadThongTinVuAn(OldVuAnID);
                    }
                    else
                    {
                        //load thong tin QHPL + Nguyên đơn + Bị đơn từ Đơn
                        LoadThongTinVuAn_By_DON(oDon.ID);
                    }

                }
            }
        }
        void LoadThongTinVuAn_By_DON(Decimal DON_ID)
        {
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == DON_ID).Single<GDTTT_DON>();
            if (oDon != null)
            {
                txtQHPL_TEXT.Text = oDon.QHPL_TEXT;
                //------------------------
                LoadDsDuongSu_DON(oDon.ID, rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                LoadDsDuongSu_DON(oDon.ID, rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                LoadDsDuongSu_DON(oDon.ID, rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);

            }
        }

        void LoadDsDuongSu_DON(Decimal DonID, Repeater rpt, String tucachtt)
        {
            int count_all = 0, IsInputAddress = 0;
            Decimal CurrDonID = DonID;// (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByDonID(CurrDonID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                count_all = tbl.Rows.Count;
                IsInputAddress = Convert.ToInt16(tbl.Rows[0]["IsInputAddress"] + "");
                //--------------------
                if (count_all > 0)
                {
                    switch (tucachtt)
                    {
                        case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                            hddSoND.Value = count_all.ToString();
                            chkND.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                            hddSoBD.Value = count_all.ToString();
                            chkBD.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                            hddSoDSKhac.Value = count_all.ToString();
                            chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                    }
                    rpt.DataSource = tbl;
                    rpt.DataBind();
                }
            }
            else
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        hddSoND.Value = "1";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        hddSoBD.Value = "1";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        hddSoDSKhac.Value = "0";
                        break;
                }
                tbl = CreateTableNhapDuongSu(tucachtt);
                rpt.DataSource = tbl;
                rpt.DataBind();
            }
        }
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

        void LoadThongTinVuAn(Decimal OldVuAnID)
        {
            GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == OldVuAnID).Single<GDTTT_VUAN>();
            if (objVA != null)
            {
                //try { Cls_Comon.SetValueComboBox(dropQHPL, objVA.QHPL_DINHNGHIAID); } catch (Exception ex) { }
                if (objVA.QHPL_DINHNGHIAID > 0 && string.IsNullOrEmpty(objVA.QHPL_TEXT + ""))
                {
                    GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == objVA.QHPL_DINHNGHIAID).FirstOrDefault();
                    if (oQHPL != null)
                    {
                        txtQHPL_TEXT.Text = oQHPL.TENQHPL;
                    }
                }
                else
                    txtQHPL_TEXT.Text = objVA.QHPL_TEXT;
                //------------------------
                LoadDsDuongSu(OldVuAnID, rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                LoadDsDuongSu(OldVuAnID, rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                LoadDsDuongSu(OldVuAnID, rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);

            }
        }


        //-------------------------------------------
        void LoadComponent()
        {
            LoadDropToaAnGDT(dropToaGDT);
            LoadDropToaAn();
            LoadLoaiAnTheoVu();
            LoadDMQuanHePL();
            try
            {
                LoadDropLanhDao();
                LoadDropTTV();
                LoadThamPhan();
            }
            catch (Exception ex) { }
            hddGUID.Value = Guid.NewGuid().ToString();

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
        //void LoadDropToaST_TheoPT()
        //{
        //    dropToaAnST.Items.Clear();
        //    DM_TOAAN_BL bl = new DM_TOAAN_BL();
        //    Decimal CapChaID = Convert.ToDecimal(dropToaAn.SelectedValue);
        //    DataTable tbl = bl.GetByCapChaID(CapChaID);
        //    dropToaAnST.DataSource = tbl;
        //    dropToaAnST.DataTextField = "MA_TEN";
        //    dropToaAnST.DataValueField = "ID";
        //    dropToaAnST.DataBind();
        //    dropToaAnST.Items.Insert(0, new ListItem("Chọn", "0"));
        //}
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
            string vLoaiAn = ddlLoaiBA.SelectedValue;
            LoadLoaiAn(vLoaiAn);
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
        //-----------------------
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

        protected void dropLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDMQuanHePL();
            SetControl_AnHinhSu();
            Cls_Comon.SetFocus(this, this.GetType(), dropQHPL.ClientID);
        }
        void LoadDMQuanHePL()
        {
            int LoaiAn = Convert.ToInt16(dropLoaiAn.SelectedValue);
            List<GDTTT_DM_QHPL> lst = dt.GDTTT_DM_QHPL.Where(x => x.LOAIAN == LoaiAn).ToList();
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
            String msg_check = CheckNhapDuongSu();
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }

            Decimal CurrDonID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            GDTTT_DON objDon = dt.GDTTT_DON.Where(x => x.ID == CurrDonID).FirstOrDefault();
            GDTTT_VUAN obj = Update_VuAn(objDon);
            //------------------------
            Update_DonGDTTT(objDon);

            //-----update thong tin : tongdon, isanqh, isanchidao, arrnguoikhieunai
            GDTTT_DON_BL objBL = new GDTTT_DON_BL();
            objBL.Update_Don_TH(obj.ID);

            //Update duong su
            if (dropLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
                Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);

            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);


            //lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công!";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        void SetControl_AnHinhSu()
        {
            if (dropLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                pnNguyenDon.Visible = false;
            }
        }
        string CheckNhapDuongSu()
        {
            String StrNguyenDon = "", StrBiDon = "";
            int count_item = 0;

            if (dropLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                foreach (RepeaterItem item in rptNguyenDon.Items)
                {
                    count_item++;
                    TextBox txtTen = (TextBox)item.FindControl("txtTen");
                    if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                        StrNguyenDon += (String.IsNullOrEmpty(StrNguyenDon) ? "" : ", ") + count_item.ToString();
                }
                if (!String.IsNullOrEmpty(StrNguyenDon))
                    StrNguyenDon = " Nguyên đơn thứ " + StrNguyenDon;
            }
            //------------------------

            count_item = 0;
            foreach (RepeaterItem item in rptBiDon.Items)
            {
                count_item++;
                TextBox txtTen = (TextBox)item.FindControl("txtTen");
                if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                    StrBiDon += (String.IsNullOrEmpty(StrBiDon) ? "" : ", ") + count_item.ToString();
            }
            if (!String.IsNullOrEmpty(StrBiDon))
                StrBiDon = " Bị đơn  thứ " + StrBiDon;
            //------------------------------
            String msg = "";
            if ((!String.IsNullOrEmpty(StrNguyenDon)) || (!String.IsNullOrEmpty(StrBiDon)))
            {
                msg = "Lưu ý: " + StrNguyenDon
                    + (string.IsNullOrEmpty(StrNguyenDon) ? "" : ";")
                    + StrBiDon + " chưa được nhập. Hãy kiểm tra lại!";
            }
            return msg;
        }

        GDTTT_VUAN Update_VuAn(GDTTT_DON objDon)
        {
            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            if (hddVuAnID.Value != "" && hddVuAnID.Value != "0")
            {
                IsUpdate = true;
                decimal vuan_id = Convert.ToDecimal(hddVuAnID.Value);
                obj = dt.GDTTT_VUAN.Where(x => x.ID == vuan_id).FirstOrDefault();
            }
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrDonID = (String.IsNullOrEmpty(hddDonID.Value)) ? 0 : Convert.ToDecimal(hddDonID.Value + "");

            obj.PHONGBANID = PhongBanID;
            obj.TOAANID = CurrDonViID;
            obj.DONTHULYID = CurrDonID;



            //Ho so khang nghị VKS
            if (objDon.LOAIDON == 8 || objDon.LOAIDON == 10)
            {
                obj.TRUONGHOPTHULY = objDon.LOAIDON;
                obj.SOTHULYDON = txtSoThuLy.Text.Trim();
                if (!String.IsNullOrEmpty(txtNgayThuLy.Text.Trim()))
                    obj.NGAYTHULYDON = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYTHULYDON = null;
            }
            else if (objDon.LOAIDON == 4)
            {
                obj.TRUONGHOPTHULY = 1;
                obj.SOTHULYXXGDT = txtSoThuLy.Text.Trim();
                if (!String.IsNullOrEmpty(txtNgayThuLy.Text.Trim()))
                    obj.NGAYTHULYXXGDT = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYTHULYXXGDT = null;
            }
            else
            {
                //-----Thong tin ThuLy-------------------
                obj.TRUONGHOPTHULY = 0;
                obj.SOTHULYDON = txtSoThuLy.Text.Trim();
                if (!String.IsNullOrEmpty(txtNgayThuLy.Text.Trim()))
                    obj.NGAYTHULYDON = DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                else
                    obj.NGAYTHULYDON = null;
            }


            obj.DIACHINGUOIDENGHI = txtNguoiDeNghi_DiaChi.Text.Trim();
            obj.NGUOIKHIEUNAI = Cls_Comon.FormatTenRieng(txtNguoiDeNghi.Text.Trim());

            if (!String.IsNullOrEmpty(txtNgayTrongDon.Text.Trim()))
                obj.NGAYTRONGDON = DateTime.Parse(this.txtNgayTrongDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                obj.NGAYTRONGDON = null;
            if (!String.IsNullOrEmpty(txtNgayNhanDon.Text.Trim()))
                obj.NGAYNHANDONDENGHI = DateTime.Parse(this.txtNgayNhanDon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                obj.NGAYNHANDONDENGHI = null;

            //------Thong tin BA/QD------------------
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

            obj.QHPL_TEXT = txtQHPL_TEXT.Text.Trim();
            obj.QHPL_DINHNGHIAID = null;
            //obj.QHPL_DINHNGHIAID = Convert.ToDecimal(dropQHPL.SelectedValue);

            obj.QHPL_THONGKEID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);

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
            if (Request["type"] != null)
            {
                obj.THULYLAI_VUANID = (String.IsNullOrEmpty(objDon.VUVIECID + "")) ? 0 : objDon.VUVIECID;
                hddThuLyLaiVuAnID.Value = objDon.VUVIECID + "";
            }


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

            //-Thong tin KN của VKS---------
            if (objDon.LOAIDON == 4)
            {
                obj.TRUONGHOPTHULY = 1;
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
                obj.THAMQUYENXXGDT = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);

                dt.SaveChanges();
            }
            //---Update trang thai Ho so---------------------------
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

            return obj;
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
                    objHS.SOPHIEU = GetNewSoPhieuNhanHS(3, (DateTime)objHS.NGAYTAO, CurrDonViID, PhongBanID);
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
        Decimal GetNewSoPhieuNhanHS(decimal loaiphieu, DateTime NgayTao, decimal donviid, decimal phongbanid)
        {
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastSoPhieuHS(loaiphieu, NgayTao, donviid, phongbanid);
            return SoCV;
        }
        void Update_DuongSu(GDTTT_VUAN objVA, string tucachtt, Repeater rpt)
        {
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            bool IsUpdate = false;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            Decimal CurrDS = 0;
            String StrEditID = ",", StrUpdate = "";
            int soluongdong = 0, count_item = 0;
            Boolean IsNhapDiaChi = false;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    soluongdong = Convert.ToInt16(hddSoND.Value);
                    if (chkND.Checked)
                        IsNhapDiaChi = true;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    soluongdong = Convert.ToInt16(hddSoBD.Value);
                    if (chkBD.Checked)
                        IsNhapDiaChi = true;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    soluongdong = Convert.ToInt16(hddSoDSKhac.Value);
                    if (chkDSKhac.Checked)
                        IsNhapDiaChi = true;
                    break;
            }
            //-------------------------
            foreach (RepeaterItem item in rpt.Items)
            {
                IsUpdate = false;
                if (count_item <= soluongdong)
                {
                    count_item++;
                    #region Update duong su
                    TextBox txtTen = (TextBox)item.FindControl("txtTen");
                    TextBox txtDiachi = (TextBox)item.FindControl("txtDiachi");
                    if (!String.IsNullOrEmpty(txtTen.Text.Trim()))
                    {
                        HiddenField hddDuongSuID = (HiddenField)item.FindControl("hddDuongSuID");
                        CurrDS = String.IsNullOrEmpty(hddDuongSuID.Value + "") ? 0 : Convert.ToDecimal(hddDuongSuID.Value);
                        if (CurrDS > 0)
                        {
                            try
                            {
                                obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == CurrDS && x.VUANID == CurrVuAnID).Single<GDTTT_VUAN_DUONGSU>();
                                if (obj != null)
                                    IsUpdate = true;
                                else obj = new GDTTT_VUAN_DUONGSU();
                            }
                            catch (Exception ex) { obj = new GDTTT_VUAN_DUONGSU(); }
                        }
                        else obj = new GDTTT_VUAN_DUONGSU();
                        obj.VUANID = CurrVuAnID;
                        obj.LOAI = 2;// Convert.ToInt16(dropDSLoai.SelectedValue);
                        obj.TUCACHTOTUNG = tucachtt; //dropDuongSu.SelectedValue;
                        obj.TENDUONGSU = Cls_Comon.FormatTenRieng(txtTen.Text.Trim());
                        obj.GIOITINH = 2;
                        obj.ISINPUTADDRESS = (IsNhapDiaChi) ? 1 : 0;
                        if (IsNhapDiaChi)
                        {
                            obj.DIACHI = txtDiachi.Text.Trim();
                            DropDownList ddlTinhHuyen = (DropDownList)item.FindControl("ddlTinhHuyen");
                            obj.HUYENID = Convert.ToDecimal(ddlTinhHuyen.SelectedValue);
                            obj.DIACHI = txtDiachi.Text.Trim();
                        }
                        else
                        {
                            obj.DIACHI = "";
                            obj.HUYENID = 0;
                            obj.TINHID = 0;
                            obj.DIACHI = "";
                        }

                        if (!IsUpdate)
                        {
                            obj.NGAYTAO = DateTime.Now;
                            obj.NGUOITAO = UserName;
                            dt.GDTTT_VUAN_DUONGSU.Add(obj);
                            dt.SaveChanges();
                        }
                        else
                        {
                            obj.NGAYSUA = DateTime.Now;
                            obj.NGUOISUA = UserName;
                            dt.SaveChanges();
                        }
                    }
                    #endregion

                    //-------------------------
                    if (obj.ID > 0)
                    {
                        StrEditID += obj.ID.ToString() + ",";
                        StrUpdate += ((string.IsNullOrEmpty(StrUpdate + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(obj.TENDUONGSU);
                    }
                }
            }
            //-------------------------
            #region Update GDTTT_VUAN
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    objVA.NGUYENDON = StrUpdate;
                    hddSoND.Value = count_item.ToString();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    objVA.BIDON = StrUpdate;
                    hddSoBD.Value = count_item.ToString();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    hddSoDSKhac.Value = count_item.ToString();
                    break;
            }

            if (tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
            {
                objVA.TENVUAN = objVA.NGUYENDON + " - " + objVA.BIDON + " - " + dropQHPL.SelectedItem.Text;
                dt.SaveChanges();
            }
            #endregion
        }
        void Update_DonGDTTT(GDTTT_DON objDon)
        {
            List<GDTTT_DON> list = null;
            Decimal VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            if (objDon != null)
            {
                objDon.VUVIECID = VuAnID;
                if (objDon.DONTRUNGID != null && objDon.DONTRUNGID > 0)
                {
                    //don goc
                    GDTTT_DON isDonGoc = dt.GDTTT_DON.Where(x => x.ID == objDon.DONTRUNGID).Single();
                    if (isDonGoc != null && isDonGoc.CD_TRANGTHAI == 2)
                    {
                        isDonGoc.VUVIECID = VuAnID;
                    }
                    //List cac don trùng theo don goc
                    try
                    {
                        list = dt.GDTTT_DON.Where(x => x.DONTRUNGID == objDon.DONTRUNGID && x.CD_TRANGTHAI == 2).ToList();
                        if (list.Count > 0)
                        {
                            foreach (GDTTT_DON item in list)
                            {
                                item.VUVIECID = VuAnID;
                            }
                        }
                    }
                    catch (Exception ex) { }
                }

                //if (Request["type"] != null)
                //    objDon.THULYLAI_VUANID = Convert.ToDecimal(hddThuLyLaiVuAnID.Value+"");
                dt.SaveChanges();
            }
        }


        //--------------------------------------------------
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
        void LoadDsDuongSu(Decimal OldVuAnID, Repeater rpt, String tucachtt)
        {
            int count_all = 0, IsInputAddress = 0;
            Decimal CurrVuAnID = OldVuAnID;// (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(CurrVuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                count_all = tbl.Rows.Count;
                IsInputAddress = Convert.ToInt16(tbl.Rows[0]["IsInputAddress"] + "");
                //--------------------
                if (count_all > 0)
                {
                    switch (tucachtt)
                    {
                        case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                            hddSoND.Value = count_all.ToString();
                            chkND.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                            hddSoBD.Value = count_all.ToString();
                            chkBD.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                            hddSoDSKhac.Value = count_all.ToString();
                            chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                    }
                    rpt.DataSource = tbl;
                    rpt.DataBind();
                }
            }
            else
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        hddSoND.Value = "1";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        hddSoBD.Value = "1";
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        hddSoDSKhac.Value = "0";
                        break;
                }
                tbl = CreateTableNhapDuongSu(tucachtt);
                rpt.DataSource = tbl;
                rpt.DataBind();
            }
        }

        DataTable CreateTableNhapDuongSu(string tucachtt)
        {
            DataTable tbl = new DataTable();
            tbl.Columns.Add("ID");
            tbl.Columns.Add("Loai", typeof(int));
            tbl.Columns.Add("TenDuongSu", typeof(string));
            tbl.Columns.Add("DiaChi", typeof(string));
            tbl.Columns.Add("HUYENID", typeof(string));
            tbl.Columns.Add("IsDelete", typeof(int));
            tbl.Columns.Add("IsInputAddress", typeof(int));
            int soluongdong = 0;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    soluongdong = Convert.ToInt16(hddSoND.Value);
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    soluongdong = Convert.ToInt16(hddSoBD.Value);
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    soluongdong = Convert.ToInt16(hddSoDSKhac.Value);
                    break;
            }
            //-----------------------
            DataRow newrow = null;
            int count_item = 1;
            int IsInputAddress = 0;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CurrVuAnID > 0)
            {
                GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
                DataTable tblData = objBL.GetByVuAnID(CurrVuAnID, tucachtt);
                if (tblData != null && tblData.Rows.Count > 0)
                {
                    IsInputAddress = (string.IsNullOrEmpty(tblData.Rows[0]["IsInputAddress"] + "")) ? 0 : Convert.ToInt16(tblData.Rows[0]["IsInputAddress"] + "");
                    switch (tucachtt)
                    {
                        case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                            chkND.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                            chkBD.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                            chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                    }

                    int count_data = tblData.Rows.Count;
                    foreach (DataRow row in tblData.Rows)
                    {
                        if (count_item <= soluongdong)
                        {
                            newrow = tbl.NewRow();
                            newrow["ID"] = row["ID"];
                            newrow["Loai"] = row["Loai"]; //ca nhan
                            newrow["TenDuongSu"] = row["TenDuongSu"];
                            newrow["DiaChi"] = row["DiaChi"];
                            newrow["HUYENID"] = row["HUYENID"] + "";
                            newrow["IsDelete"] = 1;
                            newrow["IsInputAddress"] = IsInputAddress;
                            tbl.Rows.Add(newrow);
                            count_item++;
                        }
                    }
                }
            }
            if ((count_item - 1) < soluongdong)
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        IsInputAddress = (!chkND.Checked) ? 0 : 1;
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        IsInputAddress = (!chkBD.Checked) ? 0 : 1;
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        IsInputAddress = (!chkDSKhac.Checked) ? 0 : 1;
                        break;
                }

                for (int i = count_item; i <= soluongdong; i++)
                {
                    newrow = tbl.NewRow();
                    newrow["ID"] = 0;
                    newrow["Loai"] = "0"; //ca nhan
                    newrow["TenDuongSu"] = "";
                    newrow["DiaChi"] = "";
                    newrow["HUYENID"] = 0;
                    newrow["IsDelete"] = 0;
                    newrow["IsInputAddress"] = IsInputAddress;
                    tbl.Rows.Add(newrow);
                }
            }
            return tbl;
        }
        //---------------------------

        protected void rptDuongSu_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);

                if (Convert.ToInt16(rowView["IsDelete"] + "") == 0)
                    lkXoa.Visible = false;
                try
                {
                    Panel pn = (Panel)e.Item.FindControl("pn");

                    pn.Visible = (string.IsNullOrEmpty(rowView["IsInputAddress"] + "") || Convert.ToInt16(rowView["IsInputAddress"] + "") == 0) ? false : true;

                    List<DM_HANHCHINH> lstTinhHuyen;
                    if (Session["DMTINHHUYEN"] == null)
                        lstTinhHuyen = dt.DM_HANHCHINH.OrderBy(x => x.ARRTHUTU).ToList();
                    else
                        lstTinhHuyen = (List<DM_HANHCHINH>)(Session["DMTINHHUYEN"]);
                    DropDownList ddlTinhHuyen = (DropDownList)e.Item.FindControl("ddlTinhHuyen");
                    ddlTinhHuyen.DataSource = lstTinhHuyen;
                    ddlTinhHuyen.DataTextField = "MA_TEN";
                    ddlTinhHuyen.DataValueField = "ID";
                    ddlTinhHuyen.DataBind();
                    ddlTinhHuyen.Items.Insert(0, new ListItem("Tỉnh/Huyện", "0"));
                    if (pn.Visible)
                    {
                        HiddenField hddHuyenID = (HiddenField)e.Item.FindControl("hddHuyenID");
                        string strHID = hddHuyenID.Value + "";
                        if (strHID != "")
                            ddlTinhHuyen.SelectedValue = strHID;
                    }
                }
                catch (Exception ex) { }
            }
        }
        protected void rptNguyenDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_id, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    break;
            }
        }

        protected void rptBiDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_id, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    break;
            }
        }

        protected void rptDsKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_id, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    break;
            }
        }

        void Xoa_DS(decimal currrid, string tucachtt)
        {
            int count_ds = 0;
            string temp = "";
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (currrid > 0)
            {
                GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == currrid).FirstOrDefault();
                dt.GDTTT_VUAN_DUONGSU.Remove(oT);
                dt.SaveChanges();

                //-------------------------------
                List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID
                                                                            && x.TUCACHTOTUNG == tucachtt).ToList();
                if (lst != null && lst.Count > 0)
                {
                    count_ds = lst.Count;
                    foreach (GDTTT_VUAN_DUONGSU ds in lst)
                        temp += ((string.IsNullOrEmpty(temp + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(ds.TENDUONGSU);
                }
                //-------------------------------
                DataTable tbl = null;
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        hddSoND.Value = count_ds > 0 ? count_ds.ToString() : "1";
                        tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                        rptNguyenDon.DataSource = tbl;
                        rptNguyenDon.DataBind();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        hddSoBD.Value = count_ds > 0 ? count_ds.ToString() : "1";
                        tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
                        rptBiDon.DataSource = tbl;
                        rptBiDon.DataBind();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        hddSoDSKhac.Value = count_ds.ToString();
                        tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                        rptDsKhac.DataSource = tbl;
                        rptDsKhac.DataBind();
                        break;
                }
                lttMsg.Text = lttMsgT.Text = "Xóa thành công!";
            }
            else
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        count_ds = (string.IsNullOrEmpty(hddSoND.Value + "")) ? 1 : Convert.ToInt16(hddSoND.Value) - 1;
                        hddSoND.Value = count_ds.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        count_ds = (string.IsNullOrEmpty(hddSoBD.Value + "")) ? 1 : Convert.ToInt16(hddSoBD.Value) - 1;
                        hddSoBD.Value = count_ds.ToString();
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        count_ds = (string.IsNullOrEmpty(hddSoDSKhac.Value + "")) ? 0 : Convert.ToInt16(hddSoDSKhac.Value) - 1;
                        hddSoDSKhac.Value = count_ds.ToString();
                        break;
                }
            }
        }


        protected void chkND_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptNguyenDon.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkND.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemND_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //--------------------------------
            Decimal CurrDonID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            GDTTT_DON objDon = dt.GDTTT_DON.Where(x => x.ID == CurrDonID).FirstOrDefault();
            GDTTT_VUAN obj = Update_VuAn(objDon);

            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);

            int old = Convert.ToInt32(hddSoND.Value);
            hddSoND.Value = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            rptNguyenDon.DataSource = tbl;
            rptNguyenDon.DataBind();
        }
        //--------------------------

        protected void chkBD_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptBiDon.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkBD.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemBD_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //--------------------------------
            Decimal CurrDonID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            GDTTT_DON objDon = dt.GDTTT_DON.Where(x => x.ID == CurrDonID).FirstOrDefault();
            GDTTT_VUAN obj = Update_VuAn(objDon);
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);

            int old = Convert.ToInt32(hddSoBD.Value);
            hddSoBD.Value = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            rptBiDon.DataSource = tbl;
            rptBiDon.DataBind();
        }
        //---------------------------

        protected void chkDSKhac_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptDsKhac.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkDSKhac.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemDSKhac_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //--------------------------------
            Decimal CurrDonID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            GDTTT_DON objDon = dt.GDTTT_DON.Where(x => x.ID == CurrDonID).FirstOrDefault();
            GDTTT_VUAN obj = Update_VuAn(objDon);
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);

            int old = Convert.ToInt32(hddSoDSKhac.Value);
            hddSoDSKhac.Value = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            rptDsKhac.DataSource = tbl;
            rptDsKhac.DataBind();
        }
        //------------------------------
        string CheckNhapDuongSu_TheoLoai(string loai_ds)
        {
            String StrNguyenDon = "", StrBiDon = "";
            int count_item = 0;
            switch (loai_ds)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    foreach (RepeaterItem item in rptNguyenDon.Items)
                    {
                        count_item++;
                        TextBox txtTen = (TextBox)item.FindControl("txtTen");
                        if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                            StrNguyenDon += (String.IsNullOrEmpty(StrNguyenDon) ? "" : ", ") + count_item.ToString();
                    }
                    if (!String.IsNullOrEmpty(StrNguyenDon))
                        StrNguyenDon = "nguyên đơn thứ " + StrNguyenDon;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    foreach (RepeaterItem item in rptBiDon.Items)
                    {
                        count_item++;
                        TextBox txtTen = (TextBox)item.FindControl("txtTen");
                        if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                            StrBiDon += (String.IsNullOrEmpty(StrBiDon) ? "" : ", ") + count_item.ToString();
                    }
                    if (!String.IsNullOrEmpty(StrBiDon))
                        StrBiDon = "bị đơn  thứ " + StrBiDon;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    break;
            }
            //------------------------------
            String msg = "";
            if ((!String.IsNullOrEmpty(StrNguyenDon)) || (!String.IsNullOrEmpty(StrBiDon)))
            {
                msg = "Lưu ý: " + StrNguyenDon
                    + (string.IsNullOrEmpty(StrNguyenDon) ? "" : ";")
                    + StrBiDon + " chưa được nhập. Hãy kiểm tra lại!";
            }
            return msg;
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
        void LoadLoaiAn(string vddlLoaiBA)
        {
            if (vddlLoaiBA == "3")
            {
                pnPhucTham.Visible = true;
                pnAnST.Visible = true;
                pnQDGDT.Visible = false;
                hddIsAnPT.Value = "PT";
                lttBB_SoPT.Visible = lttBB_NgayPT.Visible = lttBB_ToaPT.Visible = true;
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = false;
            }
            else if (vddlLoaiBA == "2")//anhvh 14/11/2019
            {
                hddIsAnPT.Value = "ST";
                pnQDGDT.Visible = false;
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                LoadDropToaST_Full_ST();
                lttBB_SoST.Visible = lttBB_ToaST.Visible = lttBB_NgayST.Visible = true;

            }
            else if (vddlLoaiBA == "4")
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

    }
}