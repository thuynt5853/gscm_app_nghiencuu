using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.BANGSETGET.NHAPTACH_AN;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.AHC.Hoso.Popup
{
    public partial class pNhapAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        decimal DonGocID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            DonGocID = Convert.ToDecimal(Request.QueryString["DonID"].ToString());
            if (!IsPostBack)
            {
                string strSearch = Session["textsearch"] + "";
                if (strSearch != "")
                {
                    txtTENDUONGSU.Text = strSearch;
                    Session["textsearch"] = "";
                }
                LoadDropToaAn();
                LoadCombobox();
                SetGetSessionTK(false);
                Load_VuAnGoc();
                Load_Data();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            }
        }

        private void Load_VuAnGoc()
        {
            AHC_DON_BL oBL = new AHC_DON_BL();

            AHC_DON donGoc = dt.AHC_DON.Where(x => x.ID == DonGocID).FirstOrDefault();

            DataTable oDT = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donGoc.MAVUVIEC, "", "", donGoc.TOAANID.ToString(),
                                            "", "", "", "", "", "", "", "", "", "",
                                            "", "", "", "", "", "", "", 0, 0,0,"", 1, 1, 0, 1, 1);
            dgVuAnGoc.PageSize = 1;
            dgVuAnGoc.DataSource = oDT;
            dgVuAnGoc.DataBind();
        }

        private void SetGetSessionTK(bool isSet)
        {
            if (!isSet)
            {
                DropTINHTRANG_GIAIQUYET.SelectedValue = Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] + "";
                DropTHOIHAN_GQ.SelectedValue = Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] + "";
                dropCapxx.SelectedValue = Session[TK_CANHBAO.CAPXX] + "";
                DropTINHTRANG_THULY.SelectedValue = Session[TK_CANHBAO.TINHTRANG_THULY] + "";
                txtTuNgay.Text = Session[TK_CANHBAO.TUNGAY] + "";
                drop_BIENPHAPGQ.SelectedValue = Session[TK_CANHBAO.GQDON] + "";
            }
        }

        void ClearSession_TK()
        {
            Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
            Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
            Session[TK_CANHBAO.CAPXX] = "";
            Session[TK_CANHBAO.TINHTRANG_THULY] = "";
            Session[TK_CANHBAO.TUNGAY] = "";
            Session[TK_CANHBAO.GQDON] = "";
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }

        protected void clear_form_search()
        {
            ClearSession_TK();
            txtTenVuViec.Text = string.Empty;
            txt_QHPL.Text = string.Empty;
            txtMaVuViec.Text = string.Empty;
            txtTENDUONGSU.Text = string.Empty;
            dropCapxx.SelectedValue = string.Empty;
            DropTINHTRANG_THULY.SelectedValue = string.Empty;
            txt_NGAYTHULY_TU.Text = string.Empty;
            txt_NGAYTHULY_DEN.Text = string.Empty;
            txtSOTHULY.Text = string.Empty;
            DropTINHTRANG_GIAIQUYET.SelectedValue = string.Empty;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            Drop_KETQUA.SelectedValue = string.Empty;
            txtSoQD.Text = string.Empty;
            txt_NgayQD.Text = string.Empty;
            ddlHTND_Thuky.SelectedValue = string.Empty;
            DropTHOIHAN_GQ.SelectedValue = string.Empty;
            drop_BIENPHAPGQ.SelectedValue = string.Empty;
            dropUTTP.SelectedValue = string.Empty;
            Drop_PT_RKINHNGHIEM.SelectedValue = string.Empty;
            Drop_Loaidon.SelectedValue = string.Empty;
        }

        private void LoadDropToaAn()
        {
            DropToaAn.Items.Clear();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            DropToaAn.DataSource = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
            DropToaAn.DataTextField = "arrTEN";
            DropToaAn.DataValueField = "ID";
            DropToaAn.DataBind();
            if (Session[ENUM_SESSION.SESSION_DONVIID] + "" != "")
            {
                DropToaAn.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            }

        }

        private void LoadCombobox()
        {
            //--------------------
            dropCapxx.Items.Clear();
            //edit by anhvh 21/02/2020
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            //--------------------
            LoadDropThamphan();
            LoadDrop_TTV_TK();
        }

        void LoadDropThamphan()
        {
            Boolean IsLoadAll = true;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            // Kiểm tra nếu user login là thẩm phán thì chỉ load 1 user
            // nếu là chánh án, phó chánh án hoặc khác thẩm phán thì load all
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault<DM_CANBO>();
            if (oCB != null)
            {
                // Kiểm tra chức danh có là thẩm phán hay không
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA.Contains("TP"))
                    {
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        IsLoadAll = false;
                    }
                }
                // Kiểm tra chức vụ có là Chánh án hoặc phó chánh án hay không
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCD.MA.Contains("CA"))
                    {
                        IsLoadAll = true;
                    }
                }
            }
            if (IsLoadAll)
            {
                DM_CANBO_BL objBL = new DM_CANBO_BL();
                //decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal LoginDonViID = 0;
                if (DropToaAn.SelectedValue != "")
                {
                    LoginDonViID = Convert.ToDecimal(DropToaAn.SelectedValue);
                }
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
        }

        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropToaAn();
            LoadDropThamphan();
            LoadDrop_TTV_TK();
            // Load_Data();
        }

        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
            LoadDrop_TTV_TK();
            Load_Data();
        }

        protected void LoadDrop_TTV_TK()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            if (DropToaAn.SelectedValue != "")
                tbl = objBL.GET_ThuKy_TTVS(DropToaAn.SelectedValue, null);
            ddlHTND_Thuky.DataSource = tbl;
            ddlHTND_Thuky.DataTextField = "MA_TEN";
            ddlHTND_Thuky.DataValueField = "ID";
            ddlHTND_Thuky.DataBind();
            ddlHTND_Thuky.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }

        private void Load_Data()
        {
            decimal vchecktk = 0;
            AHC_DON_BL oBL = new AHC_DON_BL();
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0,
                trangThaiVuAn = 0;
            DataTable oDT = oBL.DON_CON_SEARCH(DonGocID, Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_QHPL.Text.Trim(), txtMaVuViec.Text.Trim(), txtTENDUONGSU.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                            DropTINHTRANG_THULY.SelectedValue, txtSOTHULY.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, ddlThamphan.SelectedValue, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Drop_KETQUA.SelectedValue, txtSoQD.Text.Trim(),
                                            txt_NgayQD.Text.Trim(), ddlHTND_Thuky.SelectedValue, DropTHOIHAN_GQ.SelectedValue, Drop_Loaidon.SelectedValue, Drop_PT_RKINHNGHIEM.SelectedValue, drop_BIENPHAPGQ.SelectedValue, dropUTTP.SelectedValue, vchecktk, trangThaiVuAn, pageindex, page_size);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = page_size;
            dgList.DataSource = oDT;
            dgList.DataBind();
        }

        void PhanLoaiLai_DonKK(MenuPermission oPer, decimal IDVuViec)
        {
            String MaLoaiVuAn = ENUM_LOAIAN.AN_DANSU;
            DAL.DKK.DKKContextContainer dt = new DAL.DKK.DKKContextContainer();
            DAL.DKK.DONKK_DON obj = dt.DONKK_DON.Where(x => x.VUANID == IDVuViec
                                                         && x.MALOAIVUAN == MaLoaiVuAn).Single<DAL.DKK.DONKK_DON>();
            if (obj != null)
            {
                obj.VUANID = 0;
                obj.TRANGTHAI = 0;//da gui don nhung chua phan loai
                obj.MALOAIVUAN = MaLoaiVuAn;
                obj.NGAYSUA = DateTime.Now;
            }
            dt.SaveChanges();
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion

        private void createHoso_xetxulaiPhuctham(decimal vDonID)
        {
            //Toa Phuc Tham ID
            decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //Tao Ho so và Thụ ly Phuc Tham khi GDT huy xet xu lai Phuc Tham
            ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == vDonID).FirstOrDefault();
            if (oDon != null)
            {
                ADS_DON oDON_new = new ADS_DON();
                oDON_new.TOAANID = oDon.TOAANID;
                oDON_new.MAVUVIEC = oDon.MAVUVIEC;
                oDON_new.TENVUVIEC = oDon.TENVUVIEC;
                oDON_new.SOTHUTU = oDon.SOTHUTU;
                oDON_new.HINHTHUCNHANDON = 998;//an do GDT huy xet xu lai Phuc Tham
                oDON_new.NGAYVIETDON = oDon.NGAYVIETDON;
                oDON_new.NGAYNHANDON = oDon.NGAYNHANDON;
                oDON_new.LOAIQUANHE = oDon.LOAIQUANHE;
                oDON_new.QUANHEPHAPLUATID = oDon.QUANHEPHAPLUATID;
                oDON_new.CANBONHANDONID = oDon.CANBONHANDONID;
                oDON_new.THAMPHANKYNHANDON = oDon.THAMPHANKYNHANDON;
                oDON_new.YEUTONUOCNGOAI = oDon.YEUTONUOCNGOAI;
                oDON_new.DONKIENCUANGUOIKHAC = oDon.DONKIENCUANGUOIKHAC;
                oDON_new.LOAIDON = oDon.LOAIDON;
                oDON_new.TRANGTHAI = oDon.TRANGTHAI;
                oDON_new.USERTT_EMAIL = oDon.USERTT_EMAIL;
                oDON_new.USERTT_ID = oDon.USERTT_ID;
                oDON_new.USERTT_NGAYTAO = oDon.USERTT_NGAYTAO;
                oDON_new.USERTT_NGAYGUI = oDon.USERTT_NGAYGUI;
                oDON_new.USERTT_NGAYBOSUNG = oDon.USERTT_NGAYBOSUNG;
                oDON_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                oDON_new.NGAYTAO = DateTime.Now;
                ADS_DON_BL dsBL = new ADS_DON_BL();
                oDON_new.TT = dsBL.GETNEWTT((decimal)oDON_new.TOAANID);

                oDON_new.MAGIAIDOAN = ENUM_GIAIDOANVUAN.PHUCTHAM;
                oDON_new.NOIDUNGKHOIKIEN = oDon.NOIDUNGKHOIKIEN;
                oDON_new.MABAOMAT = oDon.MABAOMAT;
                oDON_new.TOAPHUCTHAMID = oDon.TOAPHUCTHAMID;
                oDON_new.QHPLTKID = oDon.QHPLTKID;
                oDON_new.THONGTINTHEM = oDon.THONGTINTHEM;
                oDON_new.ID_HO_SO_FROM_TOA_CAP_CAO = oDon.ID_HO_SO_FROM_TOA_CAP_CAO;
                oDON_new.QUANHEPHAPLUAT_NAME = oDon.QUANHEPHAPLUAT_NAME;
                //oDON_new.TENVUVIEC_PT = oDon.TENVUVIEC_PT;
                oDON_new.DONID_TOACU = oDon.DONID_TOACU;

                dt.ADS_DON.Add(oDON_new);
                dt.SaveChanges();
                //Session[ENUM_SESSION.SESSION_DONVIID] = oDON_new.TOAANID;
                Session[ENUM_LOAIAN.AN_DANSU] = oDON_new.ID;

                //them ma giai doan cap Phuc tham 
                GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                GD.GAIDOAN_INSERT_UPDATE("2", oDON_new.ID, 3, (decimal)oDON_new.TOAANID, LoginDonViID, 0, 0, 0);

                //Câp dương su vụ án
                List<ADS_DON_DUONGSU> lst = dt.ADS_DON_DUONGSU.Where(x => x.DONID == vDonID).ToList<ADS_DON_DUONGSU>();
                foreach (ADS_DON_DUONGSU vDuongsu_old in lst)
                {
                    ADS_DON_DUONGSU vDuongsu_new = new ADS_DON_DUONGSU();
                    vDuongsu_new.DONID = oDON_new.ID;
                    vDuongsu_new.MADUONGSU = vDuongsu_old.MADUONGSU;
                    vDuongsu_new.TENDUONGSU = vDuongsu_old.TENDUONGSU;
                    vDuongsu_new.ISDAIDIEN = vDuongsu_old.ISDAIDIEN;
                    vDuongsu_new.TUCACHTOTUNG_MA = vDuongsu_old.TUCACHTOTUNG_MA;
                    vDuongsu_new.LOAIDUONGSU = vDuongsu_old.LOAIDUONGSU;
                    vDuongsu_new.SOCMND = vDuongsu_old.SOCMND;
                    vDuongsu_new.QUOCTICHID = vDuongsu_old.QUOCTICHID;
                    vDuongsu_new.TAMTRUID = vDuongsu_old.TAMTRUID;
                    vDuongsu_new.TAMTRUCHITIET = vDuongsu_old.TAMTRUCHITIET;
                    vDuongsu_new.HKTTID = vDuongsu_old.HKTTID;
                    vDuongsu_new.HKTTCHITIET = vDuongsu_old.HKTTCHITIET;
                    vDuongsu_new.NGAYSINH = vDuongsu_old.NGAYSINH;
                    vDuongsu_new.THANGSINH = vDuongsu_old.THANGSINH;
                    vDuongsu_new.NAMSINH = vDuongsu_old.NAMSINH;
                    vDuongsu_new.GIOITINH = vDuongsu_old.GIOITINH;
                    vDuongsu_new.NGUOIDAIDIEN = vDuongsu_old.NGUOIDAIDIEN;
                    vDuongsu_new.CHUCVU = vDuongsu_old.CHUCVU;
                    vDuongsu_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vDuongsu_new.NGAYTAO = DateTime.Now;
                    vDuongsu_new.NDD_DIACHIID = vDuongsu_old.NDD_DIACHIID;
                    vDuongsu_new.NDD_DIACHICHITIET = vDuongsu_old.NDD_DIACHICHITIET;
                    vDuongsu_new.ISSOTHAM = vDuongsu_old.ISSOTHAM;
                    vDuongsu_new.ISPHUCTHAM = vDuongsu_old.ISPHUCTHAM;
                    vDuongsu_new.ISGDT = vDuongsu_old.ISGDT;
                    vDuongsu_new.ISDON = vDuongsu_old.ISDON;
                    vDuongsu_new.EMAIL = vDuongsu_old.EMAIL;
                    vDuongsu_new.DIENTHOAI = vDuongsu_old.DIENTHOAI;
                    vDuongsu_new.FAX = vDuongsu_old.FAX;
                    vDuongsu_new.SINHSONG_NUOCNGOAI = vDuongsu_old.SINHSONG_NUOCNGOAI;
                    vDuongsu_new.HKTTTINHID = vDuongsu_old.HKTTTINHID;
                    vDuongsu_new.TAMTRUTINHID = vDuongsu_old.TAMTRUTINHID;
                    vDuongsu_new.ISBVQLNGUOIKHAC = vDuongsu_old.ISBVQLNGUOIKHAC;
                    vDuongsu_new.TUOI = vDuongsu_old.TUOI;
                    vDuongsu_new.DIACHICOQUAN = vDuongsu_old.DIACHICOQUAN;
                    vDuongsu_new.ID_DUONGSU_TACC = vDuongsu_old.ID_DUONGSU_TACC;
                    dt.ADS_DON_DUONGSU.Add(vDuongsu_new);
                    dt.SaveChanges();

                    //Ban giao tai lieu
                    List<ADS_DON_TAILIEU> lstTaiLieu = dt.ADS_DON_TAILIEU.Where(x => x.DONID == vDonID && x.NGUOIBANGIAO == vDuongsu_old.ID).ToList<ADS_DON_TAILIEU>();
                    foreach (ADS_DON_TAILIEU vdonFile_old in lstTaiLieu)
                    {
                        ADS_DON_TAILIEU donFile_new = new ADS_DON_TAILIEU();
                        donFile_new.DONID = oDON_new.ID;
                        donFile_new.TENTAILIEU = vdonFile_old.TENTAILIEU;
                        donFile_new.TENFILE = vdonFile_old.TENFILE;
                        donFile_new.LOAIFILE = vdonFile_old.LOAIFILE;
                        donFile_new.NOIDUNG = vdonFile_old.NOIDUNG;
                        donFile_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        donFile_new.NGAYTAO = DateTime.Now;
                        donFile_new.BANGIAOID = vdonFile_old.BANGIAOID;
                        donFile_new.NGAYBANGIAO = vdonFile_old.NGAYBANGIAO;
                        donFile_new.NGUOIBANGIAO = vDuongsu_new.ID; //Luu duong su moi
                        donFile_new.LOAIDOITUONG = vdonFile_old.LOAIDOITUONG;
                        donFile_new.NGUOINHANID = vdonFile_old.NGUOINHANID;
                        // update 130825
                        donFile_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.ADS_DON_TAILIEU.Add(donFile_new);
                        dt.SaveChanges();
                    }

                }
                // Phan cong Tham phan
                List<ADS_DON_THAMPHAN> lstThamPhan = dt.ADS_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == "VTTP_GIAIQUYETDON").ToList<ADS_DON_THAMPHAN>();
                foreach (ADS_DON_THAMPHAN vThamphan_old in lstThamPhan)
                {
                    ADS_DON_THAMPHAN vThamphan_new = new ADS_DON_THAMPHAN();
                    vThamphan_new.DONID = oDON_new.ID;
                    vThamphan_new.CANBOID = vThamphan_old.CANBOID;
                    vThamphan_new.MAVAITRO = vThamphan_old.MAVAITRO;
                    vThamphan_new.NGAYPHANCONG = vThamphan_old.NGAYPHANCONG;
                    vThamphan_new.NGAYNHANPHANCONG = vThamphan_old.NGAYNHANPHANCONG;
                    vThamphan_new.NGAYTHAMGIA = vThamphan_old.NGAYTHAMGIA;
                    vThamphan_new.NGAYKETTHUC = vThamphan_old.NGAYKETTHUC;
                    vThamphan_new.NGUOIPHANCONGID = vThamphan_old.NGUOIPHANCONGID;
                    vThamphan_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vThamphan_new.NGAYTAO = DateTime.Now;
                    vThamphan_new.ID_PHAN_CONG_AN = vThamphan_old.ID_PHAN_CONG_AN;
                    vThamphan_new.THUKYID = vThamphan_old.THUKYID;
                    // update 130825
                    vThamphan_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_DON_THAMPHAN.Add(vThamphan_new);
                    dt.SaveChanges();
                }
                //Xu ly don
                List<ADS_DON_XULY> lstXulyDon = dt.ADS_DON_XULY.Where(x => x.DONID == vDonID && x.TOAANID == oDon.TOAANID).ToList<ADS_DON_XULY>();
                foreach (ADS_DON_XULY vXulyDon_old in lstXulyDon)
                {
                    ADS_DON_XULY vXulyDon_new = new ADS_DON_XULY();
                    vXulyDon_new.DONID = oDON_new.ID;
                    vXulyDon_new.LOAIGIAIQUYET = vXulyDon_old.LOAIGIAIQUYET;
                    vXulyDon_new.NGAYGQ_YC = vXulyDon_old.NGAYGQ_YC;
                    vXulyDon_new.LYDO = vXulyDon_old.LYDO;
                    vXulyDon_new.CDTN_TOAANID = vXulyDon_old.CDTN_TOAANID;
                    vXulyDon_new.CDTN_NGAYNHAN = vXulyDon_old.CDTN_NGAYNHAN;
                    vXulyDon_new.CDNN_TENCQ = vXulyDon_old.CDNN_TENCQ;
                    vXulyDon_new.TRADON_CANCUID = vXulyDon_old.TRADON_CANCUID;
                    vXulyDon_new.NGAYTAO = DateTime.Now;
                    vXulyDon_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vXulyDon_new.CDNN_NGAYCHUYEN = vXulyDon_old.CDNN_NGAYCHUYEN;
                    vXulyDon_new.TRADON_LYDOID = vXulyDon_old.TRADON_LYDOID;
                    vXulyDon_new.TRADON_NGAYTRA = vXulyDon_old.TRADON_NGAYTRA;
                    vXulyDon_new.YCBS_NGAYYEUCAU = vXulyDon_old.YCBS_NGAYYEUCAU;
                    vXulyDon_new.YCBS_NOIDUNG = vXulyDon_old.YCBS_NOIDUNG;
                    vXulyDon_new.CDTN_NGAYCHUYEN = vXulyDon_old.CDTN_NGAYCHUYEN;
                    vXulyDon_new.SOTHONGBAO = vXulyDon_old.SOTHONGBAO;
                    vXulyDon_new.FILEID = vXulyDon_old.FILEID;
                    vXulyDon_new.YCBS_THOIHAN = vXulyDon_old.YCBS_THOIHAN;
                    vXulyDon_new.TOAANID = vXulyDon_old.TOAANID;
                    vXulyDon_new.NGAYTHONGBAO = vXulyDon_old.NGAYTHONGBAO;
                    vXulyDon_new.DON_CHITIETID = vXulyDon_old.DON_CHITIETID;
                    vXulyDon_new.DON_XULYID = vXulyDon_old.DON_XULYID;
                    dt.ADS_DON_XULY.Add(vXulyDon_new);
                    dt.SaveChanges();
                }
                //Tam ung an phi
                List<ADS_ANPHI> lstAP = dt.ADS_ANPHI.Where(x => x.DONID == vDonID).ToList();
                foreach (ADS_ANPHI vAP_old in lstAP)
                {
                    ADS_ANPHI vAP_new = new ADS_ANPHI();
                    vAP_new.DONID = oDON_new.ID;
                    vAP_new.GIATRITRANHCHAP = vAP_old.GIATRITRANHCHAP;
                    vAP_new.MUCGIAMANPHI = vAP_old.MUCGIAMANPHI;
                    vAP_new.TAMUNGANPHI = vAP_old.TAMUNGANPHI;
                    vAP_new.ANPHI = vAP_old.ANPHI;
                    vAP_new.HANNOP = vAP_old.HANNOP;
                    vAP_new.SONGAYGIAHAN = vAP_old.SONGAYGIAHAN;
                    vAP_new.TINHTRANG = vAP_old.TINHTRANG;
                    vAP_new.NGAYNOPANPHI = vAP_old.NGAYNOPANPHI;
                    vAP_new.NGAYNOPBIENLAI = vAP_old.NGAYNOPBIENLAI;
                    vAP_new.SOBIENLAI = vAP_old.SOBIENLAI;
                    vAP_new.NGUOINHANID = vAP_old.NGUOINHANID;
                    vAP_new.GHICHU = vAP_old.GHICHU;
                    vAP_new.NGAYTAO = DateTime.Now;
                    vAP_new.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    vAP_new.DONVITHA_ID = vAP_old.DONVITHA_ID;
                    vAP_new.HANNOP_SONGAY = vAP_old.HANNOP_SONGAY;
                    vAP_new.SOTHONGBAO = vAP_old.SOTHONGBAO;
                    vAP_new.NGAYTHONGBAO = vAP_old.NGAYTHONGBAO;
                    vAP_new.MAGIAIDOAN = vAP_old.MAGIAIDOAN;
                    vAP_new.TOA_GIAIQUYET_ID = vAP_old.TOA_GIAIQUYET_ID;
                    dt.ADS_ANPHI.Add(vAP_new);
                    dt.SaveChanges();
                }
                //Thong tin ban an, QD kêt thuc So tham
                ADS_SOTHAM_BANAN vBA_old = dt.ADS_SOTHAM_BANAN.Where(x => x.DONID == vDonID).FirstOrDefault();
                if (vBA_old != null)
                {
                    ADS_SOTHAM_BANAN vBA_new = new ADS_SOTHAM_BANAN();
                    vBA_new.DONID = oDON_new.ID;
                    vBA_new.LOAIQUANHE = vBA_old.LOAIQUANHE;
                    vBA_new.QUANHEPHAPLUATID = vBA_old.QUANHEPHAPLUATID;
                    vBA_new.SOBANAN = vBA_old.SOBANAN;
                    vBA_new.NGAYMOPHIENTOA = vBA_old.NGAYMOPHIENTOA;
                    vBA_new.NGAYTUYENAN = vBA_old.NGAYTUYENAN;
                    vBA_new.NGAYHIEULUC = vBA_old.NGAYHIEULUC;
                    vBA_new.XETXUCONGKHAI = vBA_old.XETXUCONGKHAI;
                    vBA_new.XETXULUUDONG = vBA_old.XETXULUUDONG;
                    vBA_new.APDUNGANLE = vBA_old.APDUNGANLE;
                    vBA_new.XETXURUTGON = vBA_old.XETXURUTGON;
                    vBA_new.RUTGON_SO = vBA_old.RUTGON_SO;
                    vBA_new.RUTGON_NGAY = vBA_old.RUTGON_NGAY;
                    vBA_new.YEUTONUOCNGOAI = vBA_old.YEUTONUOCNGOAI;
                    vBA_new.TUYENXU = vBA_old.TUYENXU;
                    vBA_new.GHICHU = vBA_old.GHICHU;
                    vBA_new.NGAYTAO = vBA_old.NGAYTAO;
                    vBA_new.NGUOITAO = vBA_old.NGUOITAO;
                    vBA_new.NGAYSUA = vBA_old.NGAYSUA;
                    vBA_new.NGUOISUA = vBA_old.NGUOISUA;
                    vBA_new.NGAYVKSNHAN = vBA_old.NGAYVKSNHAN;
                    vBA_new.ISVKSTHAMGIA = vBA_old.ISVKSTHAMGIA;
                    vBA_new.TOAANID = vBA_old.TOAANID;
                    vBA_new.QHPLTKID = vBA_old.QHPLTKID;
                    vBA_new.TK_ISQUAHAN = vBA_old.TK_ISQUAHAN;
                    vBA_new.TK_QUAHAN_KHACHQUAN = vBA_old.TK_QUAHAN_KHACHQUAN;
                    vBA_new.TK_QUAHAN_CHUQUAN = vBA_old.TK_QUAHAN_CHUQUAN;
                    vBA_new.TK_ISKIENNGHIBOSUNGVB = vBA_old.TK_ISKIENNGHIBOSUNGVB;
                    vBA_new.TK_SOQDTRAIPLBIHUY = vBA_old.TK_SOQDTRAIPLBIHUY;
                    vBA_new.QUANHEPHAPLUAT_NAME = vBA_old.QUANHEPHAPLUAT_NAME;
                    // update 130825
                    vBA_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_SOTHAM_BANAN.Add(vBA_new);
                    dt.SaveChanges();
                }
                List<ADS_SOTHAM_QUYETDINH> LstQD = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID).ToList();
                if (LstQD.Count > 0)
                {
                    foreach (ADS_SOTHAM_QUYETDINH vQD_old in LstQD)
                    {
                        ADS_SOTHAM_QUYETDINH vQD_new = new ADS_SOTHAM_QUYETDINH();
                        vQD_new.DONID = oDON_new.ID;
                        vQD_new.SOQD = vQD_old.SOQD;
                        vQD_new.NGAYQD = vQD_old.NGAYQD;
                        vQD_new.LOAIQDID = vQD_old.LOAIQDID;
                        vQD_new.QUYETDINHID = vQD_old.QUYETDINHID;
                        vQD_new.LYDOID = vQD_old.LYDOID;
                        vQD_new.HIEULUCTU = vQD_old.HIEULUCTU;
                        vQD_new.HIEULUCDEN = vQD_old.HIEULUCDEN;
                        vQD_new.THOIHANTHANG = vQD_old.THOIHANTHANG;
                        vQD_new.THOIHANNGAY = vQD_old.THOIHANNGAY;
                        vQD_new.NGAYKETTHUCTHEOLUAT = vQD_old.NGAYKETTHUCTHEOLUAT;
                        vQD_new.NGUOIKYID = vQD_old.NGUOIKYID;
                        vQD_new.CHUCVU = vQD_old.CHUCVU;
                        vQD_new.GHICHU = vQD_old.GHICHU;
                        vQD_new.NGAYTAO = vQD_old.NGAYTAO;
                        vQD_new.NGUOITAO = vQD_old.NGUOITAO;
                        vQD_new.NGAYSUA = vQD_old.NGAYSUA;
                        vQD_new.NGUOISUA = vQD_old.NGUOISUA;
                        vQD_new.TENFILE = vQD_old.TENFILE;
                        vQD_new.KIEUFILE = vQD_old.KIEUFILE;
                        vQD_new.NOIDUNGFILE = vQD_old.NOIDUNGFILE;
                        vQD_new.TOAANID = vQD_old.TOAANID;
                        vQD_new.QHPLTKID = vQD_old.QHPLTKID;
                        vQD_new.NGUOIYEUCAUID = vQD_old.NGUOIYEUCAUID;
                        vQD_new.NGUOIBIYEUCAUID = vQD_old.NGUOIBIYEUCAUID;
                        vQD_new.FILEID = vQD_old.FILEID;
                        vQD_new.NGAYMOPT = vQD_old.NGAYMOPT;
                        vQD_new.DIADIEMMOPT = vQD_old.DIADIEMMOPT;
                        vQD_new.LYDO_NAME = vQD_old.LYDO_NAME;
                        // update 130825
                        vQD_new.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.ADS_SOTHAM_QUYETDINH.Add(vQD_new);
                        dt.SaveChanges();
                    }
                }
                //Chuyen nhan an
                List<ADS_CHUYEN_NHAN_AN> LstCN = dt.ADS_CHUYEN_NHAN_AN.Where(x => x.VUANID == vDonID).ToList();
                foreach (ADS_CHUYEN_NHAN_AN voND_old in LstCN)
                {
                    ADS_CHUYEN_NHAN_AN oND = new ADS_CHUYEN_NHAN_AN();
                    oND.VUANID = oDON_new.ID;
                    oND.TOACHUYENID = oDon.TOAANID;
                    oND.TOANHANID = LoginDonViID;
                    oND.NGAYGIAO = DateTime.Now;
                    oND.TRUONGHOPGIAONHANID = 998;
                    oND.NGUOIGIAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    oND.GHICHU_GIAO = null;
                    oND.TRANGTHAI = 1;// 0: Chuyển chờ nhận, 1: Nhận
                    oND.NGAYTAO = DateTime.Now;
                    dt.ADS_CHUYEN_NHAN_AN.Add(oND);
                    dt.SaveChanges();
                }
                //ket thuc manhnd test 01
            }

        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        private bool CheckValidQĐ()
        {

            if (Cls_Comon.IsValidDate(txtNgayquyetdinh.Text) == false)
            {
                lbthongbao.Text = "Chưa nhập ngày quyết định hoặc theo định dạng (dd/MM/yyyy)!";
                txtNgayquyetdinh.Focus();
                return false;
            }

            int lengthSQD = txtSoquyetdinh.Text.Trim().Length;
            if (lengthSQD == 0)
            {
                lbthongbao.Text = "Bạn chưa nhập số quyết định!";
                txtSoquyetdinh.Focus();
                return false;
            }
            return true;
        }
        protected void cmdNhapan_Click(object sender, EventArgs e)
        {
            decimal vuAnConID = 0;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    vuAnConID = Convert.ToDecimal(Item.Cells[0].Text);
                }
            }
            if (vuAnConID == 0)
            {
                lbtthongbao.Text = "Bạn chưa chọn vụ án!";
                return;
            }
            else
            {
                txtNgayquyetdinh.Text = DateTime.Now.ToString("dd/MM/yyyy");
                txtSoquyetdinh.Text = "";
                txtNguoiKy.Text = "";
                lbthongbao.Text = "";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "hienPopup();", true);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValidQĐ())
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "hienPopup();", true);
                    return;
                }
                else
                {
                    //Tạo quyết định nhập án
                    DON_NHAPTACH_QUYETDINH QDNA = new DON_NHAPTACH_QUYETDINH();
                    QDNA.NGAYQD = DateTime.Parse(this.txtNgayquyetdinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    QDNA.SOQD = txtSoquyetdinh.Text.Trim();
                    QDNA.NGUOIKY = txtNguoiKy.Text.Trim();
                    QDNA.NGAYTAO = new DateTime();
                    QDNA.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Insert(QDNA);

                    List<decimal> ds_vuAnConID = new List<decimal>();
                    foreach (DataGridItem Item in dgList.Items)
                    {

                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            ds_vuAnConID.Add(Convert.ToDecimal(Item.Cells[0].Text));
                        }
                    }
                    if (ds_vuAnConID.Count > 0)
                    {
                        foreach (decimal vuAnConID in ds_vuAnConID)
                        {
                            AHC_SOTHAM_THULY oNSD = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
                            try
                            {
                                AHC_DON donCon = dt.AHC_DON.Where(x => x.ID == vuAnConID).FirstOrDefault();

                                //Tạo bản ghi DON_NHAPTACH
                                DON_NHAPTACH donNhap = new DON_NHAPTACH();
                                donNhap.DONID = donCon.ID;
                                donNhap.LOAIANID = 6; //AHC
                                donNhap.MAVUVIEC = donCon.MAVUVIEC;
                                donNhap.NGUOITAO = donCon.NGUOITAO;
                                donNhap.NGAYTAO = donCon.NGAYTAO;
                                donNhap.VUANGOCID = DonGocID;
                                donNhap.IS_TACHAN = 0;
                                donNhap.QUYETDINHID = QDNA.ID;
                                //Lấy chuỗi danh sách đương sự
                                List<AHC_DON_DUONGSU> dsDuongSu = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vuAnConID).ToList();
                                string jsonDuongSu = ",";
                                foreach (var item in dsDuongSu)
                                {
                                    jsonDuongSu += item.TENDUONGSU + ",";
                                }
                                //Lấy thông tin donNhap.THONGTIN_VUVIEC
                                AHC_DON_BL oBL = new AHC_DON_BL();
                                DataTable objVuViec = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donCon.MAVUVIEC, "", "", donCon.TOAANID.ToString(),
                                                                "", "", "", "", "", "", "", "", "", "",
                                                                "", "", "", "", "", "", "", 0, 0, 0, "", 1, 1, 0, 1, 1);
                                objVuViec.Columns.Remove("STT");
                                objVuViec.Columns.Remove("COUNTALL");
                                //Thay đổi dữ liệu cột HOTENBICAN
                                objVuViec.Rows[0]["HOTENBICAN"] = jsonDuongSu;
                                //Chuyển dữ liệu obj sang json
                                string jsonVuViec = JsonConvert.SerializeObject(objVuViec);
                                donNhap.THONGTIN_VUVIEC = jsonVuViec;
                                //Lấy ds thẩm phán
                                List<AHC_DON_THAMPHAN> dsThamPhan = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == vuAnConID).ToList();
                                string jsonThamPhan = ",";
                                foreach (var item in dsThamPhan)
                                {
                                    jsonThamPhan += item.CANBOID + ",";
                                }
                                //Lấy ds thư kí
                                List<AHC_SOTHAM_HDXX> dsSoThamHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
                                List<AHC_PHUCTHAM_HDXX> dsPhucThamHDXX = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
                                string jsonThuKy = ",";
                                foreach (var item in dsSoThamHDXX)
                                {
                                    jsonThuKy += item.CANBOID + ",";
                                }
                                foreach (var item in dsPhucThamHDXX)
                                {
                                    jsonThuKy += item.CANBOID + ",";
                                }
                                //Lấy thông tin thụ lý
                                AHC_SOTHAM_THULY thuLy = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
                                int ttTL = 0;
                                string ngayTL = "", soTL = "";
                                if (thuLy != null)
                                {
                                    ttTL = 1;
                                    ngayTL = String.Format("{0:dd/MM/yyyy}", thuLy.NGAYTHULY);
                                    soTL = thuLy.SOTHULY;
                                }
                                else
                                {
                                    ttTL = 2;
                                }
                                //Lấy thông tin donNhap.THONGTIN_TIMKIEM
                                Object ttTimKiem = new
                                {
                                    TENVUVIEC = donCon.TENVUVIEC,
                                    QHPL = donCon.QUANHEPHAPLUAT_NAME,
                                    MAVUVIEC = donCon.MAVUVIEC,
                                    DUONGSU = jsonDuongSu,
                                    CAPXETXU = donCon.MAGIAIDOAN,
                                    TOAANID = donCon.TOAANID,
                                    TINHTRANGTHULY = ttTL,
                                    NGAYTHULY = ngayTL,
                                    SOTHULY = soTL,
                                    THAMPHANID = jsonThamPhan,
                                    THUKYID = jsonThuKy,
                                    LOAIDON = donCon.LOAIDON
                                };
                                //Chuyển dữ liệu obj sang json
                                string jsonTimKiem = JsonConvert.SerializeObject(ttTimKiem);
                                donNhap.THONGTIN_TIMKIEM = jsonTimKiem;

                                dt.DON_NHAPTACH.Add(donNhap);
                                dt.SaveChanges();

                                //Add thông tin bảng HISTORY_DELETE_HOSO_AN_SOTHAM
                                AHC_DON donGoc = dt.AHC_DON.Where(x => x.ID == DonGocID).FirstOrDefault();

                    string taiKhoanXoa = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    string nguoiXoa = Session[ENUM_SESSION.SESSION_USERID].ToString();
                    //Án hành chính
                    string tenChucNang = "Nhập án Hành chính từ " + donCon.MAVUVIEC + " đến " + donGoc.MAVUVIEC;
                    string hanhDong = "Nhập án";
                    //Lấy thông tin nội dung (json)
                    DataTable objNoiDung = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donCon.MAVUVIEC, "", "", donCon.TOAANID.ToString(),
                                                    "", "", "", "", "", "", "", "", "", "",
                                                    "", "", "", "", "", "", "", 0, 0, 0, "", 1, 1, 0, 1, 1);
                    objNoiDung.Columns.Remove("STT");
                    objNoiDung.Columns.Remove("COUNTALL");
                    string jsonString = JsonConvert.SerializeObject(objNoiDung);

                                //Dùng chung ADS_DON_BL thay loại án
                                ADS_DON_BL adsBL = new ADS_DON_BL();
                                adsBL.HISTORY_ALLDATA_BY_VUANID(vuAnConID, 6, nguoiXoa, taiKhoanXoa, tenChucNang, hanhDong, jsonString);

                                //Cập nhật DONID của các bảng liên quan:
                                AHC_DON_BL update = new AHC_DON_BL();
                                update.CAPNHAT_DON_GOC_ID(DonGocID, vuAnConID);

                                //Tạo bản ghi DON_CHITIET & DON_DUONGSU_CHITIET từ vụ việc con
                                DON_CHITIET donCT = new DON_CHITIET();
                                donCT.DONID = DonGocID;
                                donCT.LOAIANID = 6; //AHC
                                donCT.TOAANID = donCon.TOAANID;
                                donCT.HINHTHUCNHANDON = donCon.HINHTHUCNHANDON;
                                donCT.NGAYVIETDON = donCon.NGAYVIETDON;
                                donCT.NGAYNHANDON = donCon.NGAYNHANDON;
                                donCT.CANBONHANDONID = donCon.CANBONHANDONID;
                                donCT.THAMPHANKYNHANDON = donCon.THAMPHANKYNHANDON;
                                donCT.YEUTONUOCNGOAI = donCon.YEUTONUOCNGOAI;
                                donCT.LOAIDON = donCon.LOAIDON;
                                donCT.USERTT_EMAIL = donCon.USERTT_EMAIL;
                                donCT.USERTT_ID = donCon.USERTT_ID;
                                donCT.USERTT_NGAYGUI = donCon.USERTT_NGAYGUI;
                                donCT.USERTT_NGAYTAO = donCon.USERTT_NGAYTAO;
                                donCT.USERTT_NGAYBOSUNG = donCon.USERTT_NGAYBOSUNG;
                                donCT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                                donCT.NGAYTAO = DateTime.Now;
                                donCT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                                donCT.NGAYSUA = DateTime.Now;
                                donCT.NOIDUNGKHOIKIEN = donCon.NOIDUNGKHOIKIEN;
                                donCT.DONKKID = null;
                                donCT.GHICHU = "";
                                donCT.TTGQ = null;
                                donCT.NOIDUNGTTGQ = "";
                                donCT.DONGUINHANID = null;

                                dt.DON_CHITIET.Add(donCT);
                                dt.SaveChanges();

                                //UPDATE ADS_DON_XULY SET DON_XULYID = v_DonGocID, DONID = NULL, DONCHITIETID = (id đơn chi tiết vừa mới tạo bên trên) WHERE DONID = v_DonConID;
                                AHC_DON_XULY donXL = dt.AHC_DON_XULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
                                if (donXL != null)
                                {
                                    donXL.DONID = null;
                                    donXL.DON_CHITIETID = donCT.ID;
                                    donXL.DON_XULYID = DonGocID;
                                }

                                //Danh sách đương sự của vụ việc con được nhập
                                foreach (var item in dsDuongSu)
                                {
                                    if ((item.ISDONCHITIET == null || item.ISDONCHITIET == 0) || (item.ISDAIDIEN == 1))
                                    {
                                        //Cập nhật thông tin của đương sự đại diện cho đơn con được nhập ADS_DON_DUONGSU
                                        item.DONID = DonGocID;
                                        item.ISDAIDIEN_DONCHITIET = item.ISDAIDIEN;
                                        item.ISDONCHITIET = 1;
                                        item.ISDAIDIEN = 0;

                            //Thêm đương sự chi tiết DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET dsCT = new DON_DUONGSU_CHITIET();
                            dsCT.DUONGSUID = item.ID;
                            dsCT.DONID = DonGocID;
                            dsCT.LOAIAN = 6; //AHC
                            dsCT.DONCHITIETID = donCT.ID;
                            dsCT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                            dsCT.NGAYTAO = DateTime.Now;
                            dsCT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                            dsCT.NGAYSUA = DateTime.Now;
                            // update 130825
                            dsCT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.DON_DUONGSU_CHITIET.Add(dsCT);
                            dt.SaveChanges();
                        }
                        else
                        {
                            //Cập nhật thông tin của đương sự đại diện cho đơn chi tiết của đơn con con được nhập ADS_DON_DUONGSU
                            item.DONID = DonGocID;
                            item.ISDAIDIEN = 0;
                        }
                    }

                                //Xoá bản ghi vụ việc con ADS_DON
                                dt.AHC_DON.Remove(donCon);
                                dt.SaveChanges();

                                Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");
                            }
                            catch (Exception ex)
                            {
                                DataExtensions.Delete(QDNA);
                                lbtthongbao.Text = "Có lỗi khi nhập án: " + ex.Message;
                            }
                        }
                    }

                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        //protected void cmdNhapan_Click(object sender, EventArgs e)
        //{
        //    decimal vuAnConID = 0, count = 0;
        //    AHC_SOTHAM_THULY oNSD = new AHC_SOTHAM_THULY();
        //    foreach (DataGridItem Item in dgList.Items)
        //    {
        //        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
        //        if (chkChon.Checked)
        //        {
        //            count++;
        //            vuAnConID = Convert.ToDecimal(Item.Cells[0].Text);
        //            oNSD = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
        //        }
        //    }
        //    if (vuAnConID == 0)
        //    {
        //        lbtthongbao.Text = "Bạn chưa chọn vụ án!";
        //        return;
        //    }
        //    else if (count > 1)
        //    {
        //        lbtthongbao.Text = "Bạn chỉ chọn một vụ án!";
        //        return;
        //    }
        //    else
        //    {
        //        try
        //        {
        //            AHC_DON donCon = dt.AHC_DON.Where(x => x.ID == vuAnConID).FirstOrDefault();

        //            //Tạo bản ghi DON_NHAPTACH
        //            DON_NHAPTACH donNhap = new DON_NHAPTACH();
        //            donNhap.DONID = donCon.ID;
        //            donNhap.LOAIANID = 6; //AHC
        //            donNhap.MAVUVIEC = donCon.MAVUVIEC;
        //            donNhap.NGUOITAO = donCon.NGUOITAO;
        //            donNhap.NGAYTAO = donCon.NGAYTAO;
        //            donNhap.VUANGOCID = DonGocID;
        //            donNhap.IS_TACHAN = 0;
        //            //Lấy chuỗi danh sách đương sự
        //            List<AHC_DON_DUONGSU> dsDuongSu = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vuAnConID).ToList();
        //            string jsonDuongSu = ",";
        //            foreach (var item in dsDuongSu)
        //            {
        //                jsonDuongSu += item.TENDUONGSU + ",";
        //            }
        //            //Lấy thông tin donNhap.THONGTIN_VUVIEC
        //            AHC_DON_BL oBL = new AHC_DON_BL();
        //            DataTable objVuViec = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donCon.MAVUVIEC, "", "", donCon.TOAANID.ToString(),
        //                                            "", "", "", "", "", "", "", "", "", "",
        //                                            "", "", "", "", "", "", "", 0, 0, 0, "", 1, 1, 1, 1);
        //            objVuViec.Columns.Remove("STT");
        //            objVuViec.Columns.Remove("COUNTALL");
        //            //Thay đổi dữ liệu cột HOTENBICAN
        //            objVuViec.Rows[0]["HOTENBICAN"] = jsonDuongSu;
        //            //Chuyển dữ liệu obj sang json
        //            string jsonVuViec = JsonConvert.SerializeObject(objVuViec);
        //            donNhap.THONGTIN_VUVIEC = jsonVuViec;
        //            //Lấy ds thẩm phán
        //            List<AHC_DON_THAMPHAN> dsThamPhan = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == vuAnConID).ToList();
        //            string jsonThamPhan = ",";
        //            foreach (var item in dsThamPhan)
        //            {
        //                jsonThamPhan += item.CANBOID + ",";
        //            }
        //            //Lấy ds thư kí
        //            List<AHC_SOTHAM_HDXX> dsSoThamHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
        //            List<AHC_PHUCTHAM_HDXX> dsPhucThamHDXX = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
        //            string jsonThuKy = ",";
        //            foreach (var item in dsSoThamHDXX)
        //            {
        //                jsonThuKy += item.CANBOID + ",";
        //            }
        //            foreach (var item in dsPhucThamHDXX)
        //            {
        //                jsonThuKy += item.CANBOID + ",";
        //            }
        //            //Lấy thông tin thụ lý
        //            AHC_SOTHAM_THULY thuLy = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
        //            int ttTL = 0;
        //            string ngayTL = "", soTL = "";
        //            if (thuLy != null)
        //            {
        //                ttTL = 1;
        //                ngayTL = String.Format("{0:dd/MM/yyyy}", thuLy.NGAYTHULY);
        //                soTL = thuLy.SOTHULY;
        //            }
        //            else
        //            {
        //                ttTL = 2;
        //            }
        //            //Lấy thông tin donNhap.THONGTIN_TIMKIEM
        //            Object ttTimKiem = new
        //            {
        //                TENVUVIEC = donCon.TENVUVIEC,
        //                QHPL = donCon.QUANHEPHAPLUAT_NAME,
        //                MAVUVIEC = donCon.MAVUVIEC,
        //                DUONGSU = jsonDuongSu,
        //                CAPXETXU = donCon.MAGIAIDOAN,
        //                TOAANID = donCon.TOAANID,
        //                TINHTRANGTHULY = ttTL,
        //                NGAYTHULY = ngayTL,
        //                SOTHULY = soTL,
        //                THAMPHANID = jsonThamPhan,
        //                THUKYID = jsonThuKy,
        //                LOAIDON = donCon.LOAIDON
        //            };
        //            //Chuyển dữ liệu obj sang json
        //            string jsonTimKiem = JsonConvert.SerializeObject(ttTimKiem);
        //            donNhap.THONGTIN_TIMKIEM = jsonTimKiem;

        //            dt.DON_NHAPTACH.Add(donNhap);
        //            dt.SaveChanges();

        //            //Add thông tin bảng HISTORY_DELETE_HOSO_AN_SOTHAM
        //            AHC_DON donGoc = dt.AHC_DON.Where(x => x.ID == DonGocID).FirstOrDefault();

        //            string taiKhoanXoa = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //            string nguoiXoa = Session[ENUM_SESSION.SESSION_USERID].ToString();
        //            //Án hành chính
        //            string tenChucNang = "Nhập án Hành chính từ " + donCon.MAVUVIEC + " đến " + donGoc.MAVUVIEC;
        //            string hanhDong = "Nhập án";
        //            //Lấy thông tin nội dung (json)
        //            DataTable objNoiDung = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donCon.MAVUVIEC, "", "", donCon.TOAANID.ToString(),
        //                                            "", "", "", "", "", "", "", "", "", "",
        //                                            "", "", "", "", "", "", "", 0, 0, 0, "", 1, 1, 1, 1);
        //            objNoiDung.Columns.Remove("STT");
        //            objNoiDung.Columns.Remove("COUNTALL");
        //            string jsonString = JsonConvert.SerializeObject(objNoiDung);

        //            //Dùng chung ADS_DON_BL thay loại án
        //            ADS_DON_BL adsBL = new ADS_DON_BL();
        //            adsBL.HISTORY_ALLDATA_BY_VUANID(vuAnConID, 6, nguoiXoa, taiKhoanXoa, tenChucNang, hanhDong, jsonString);

        //            //Cập nhật DONID của các bảng liên quan:
        //            AHC_DON_BL update = new AHC_DON_BL();
        //            update.CAPNHAT_DON_GOC_ID(DonGocID, vuAnConID);

        //            //Tạo bản ghi DON_CHITIET & DON_DUONGSU_CHITIET từ vụ việc con
        //            DON_CHITIET donCT = new DON_CHITIET();
        //            donCT.DONID = DonGocID;
        //            donCT.LOAIANID = 6; //AHC
        //            donCT.TOAANID = donCon.TOAANID;
        //            donCT.HINHTHUCNHANDON = donCon.HINHTHUCNHANDON;
        //            donCT.NGAYVIETDON = donCon.NGAYVIETDON;
        //            donCT.NGAYNHANDON = donCon.NGAYNHANDON;
        //            donCT.CANBONHANDONID = donCon.CANBONHANDONID;
        //            donCT.THAMPHANKYNHANDON = donCon.THAMPHANKYNHANDON;
        //            donCT.YEUTONUOCNGOAI = donCon.YEUTONUOCNGOAI;
        //            donCT.LOAIDON = donCon.LOAIDON;
        //            donCT.USERTT_EMAIL = donCon.USERTT_EMAIL;
        //            donCT.USERTT_ID = donCon.USERTT_ID;
        //            donCT.USERTT_NGAYGUI = donCon.USERTT_NGAYGUI;
        //            donCT.USERTT_NGAYTAO = donCon.USERTT_NGAYTAO;
        //            donCT.USERTT_NGAYBOSUNG = donCon.USERTT_NGAYBOSUNG;
        //            donCT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //            donCT.NGAYTAO = DateTime.Now;
        //            donCT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //            donCT.NGAYSUA = DateTime.Now;
        //            donCT.NOIDUNGKHOIKIEN = donCon.NOIDUNGKHOIKIEN;
        //            donCT.DONKKID = null;
        //            donCT.GHICHU = "";
        //            donCT.TTGQ = null;
        //            donCT.NOIDUNGTTGQ = "";
        //            donCT.DONGUINHANID = null;

        //            dt.DON_CHITIET.Add(donCT);
        //            dt.SaveChanges();

        //            //UPDATE ADS_DON_XULY SET DON_XULYID = v_DonGocID, DONID = NULL, DONCHITIETID = (id đơn chi tiết vừa mới tạo bên trên) WHERE DONID = v_DonConID;
        //            AHC_DON_XULY donXL = dt.AHC_DON_XULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
        //            if (donXL != null)
        //            {
        //                donXL.DONID = null;
        //                donXL.DON_CHITIETID = donCT.ID;
        //                donXL.DON_XULYID = DonGocID;
        //            }

        //            //Danh sách đương sự của vụ việc con được nhập
        //            foreach (var item in dsDuongSu)
        //            {
        //                if ((item.ISDONCHITIET == null || item.ISDONCHITIET == 0) || (item.ISDAIDIEN == 1))
        //                {
        //                    //Cập nhật thông tin của đương sự đại diện cho đơn con được nhập ADS_DON_DUONGSU
        //                    item.DONID = DonGocID;
        //                    item.ISDAIDIEN_DONCHITIET = item.ISDAIDIEN;
        //                    item.ISDONCHITIET = 1;
        //                    item.ISDAIDIEN = 0;

        //                    //Thêm đương sự chi tiết DON_DUONGSU_CHITIET
        //                    DON_DUONGSU_CHITIET dsCT = new DON_DUONGSU_CHITIET();
        //                    dsCT.DUONGSUID = item.ID;
        //                    dsCT.DONID = DonGocID;
        //                    dsCT.LOAIAN = 6; //AHC
        //                    dsCT.DONCHITIETID = donCT.ID;
        //                    dsCT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //                    dsCT.NGAYTAO = DateTime.Now;
        //                    dsCT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //                    dsCT.NGAYSUA = DateTime.Now;

        //                    dt.DON_DUONGSU_CHITIET.Add(dsCT);
        //                    dt.SaveChanges();
        //                }
        //                else
        //                {
        //                    //Cập nhật thông tin của đương sự đại diện cho đơn chi tiết của đơn con con được nhập ADS_DON_DUONGSU
        //                    item.DONID = DonGocID;
        //                    item.ISDAIDIEN = 0;
        //                }
        //            }

        //            //Xoá bản ghi vụ việc con ADS_DON
        //            dt.AHC_DON.Remove(donCon);
        //            dt.SaveChanges();

        //            Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");
        //        }
        //        catch (Exception ex)
        //        {
        //            Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");//lbtthongbao.Text = "Có lỗi khi nhập án: " + ex.Message;
        //        }
        //    }
        //}
    }
}