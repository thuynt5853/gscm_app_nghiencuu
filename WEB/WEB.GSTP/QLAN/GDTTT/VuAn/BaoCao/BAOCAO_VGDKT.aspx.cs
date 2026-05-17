using Aspose.Cells;
using Aspose.Words;
using BL.GSTP;
using BL.GSTP.BANGSETGET.GDTTT;
using BL.GSTP.BANGSETGET.THONGKE;
using BL.GSTP.GDTTT;
using DAL.GSTP;
using FlexCel.Report;
using FlexCel.XlsAdapter;
using Module.Common;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using System.Configuration;
using System.Collections.Generic;
using Aspose.Words.Drawing;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao
{
    public partial class BAOCAO_VGĐKT : System.Web.UI.Page
    {
        //--------------------------------
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        string pathTemplateWord = ConfigurationManager.AppSettings["TemplateWord"];
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            if (!IsPostBack)
            {
                DateTime start_date = DateTime.Today.AddMonths(0);//0 lấy tháng hiện tại;-1 lấy 1 tháng trở về trước tính từ ngày hiện tại
                string strDate = "01" + start_date.ToString("/MM/yyyy");
                txtThuly_Tu.Text = strDate;
                txtThuly_Den.Text = DateTime.Now.ToString("dd/MM/yyyy");
                Bao_Cao_permi();
                LoadDropLoaiAn();
                Load_AllLanhDao();
                Load_drop_cbtk();
                Load_Drop_ld_phong();
            }
        }
        protected void Load_drop_cbtk()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;

            tbl = objBL.DM_CANBO_GETALL(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            drop_cbtk.DataSource = tbl;
            drop_cbtk.DataTextField = "MA_TEN";
            drop_cbtk.DataValueField = "ID";
            drop_cbtk.DataBind();
            drop_cbtk.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }
        protected void Load_Drop_ld_phong()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;

            tbl = objBL.DM_CANBO_GETALL(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            Drop_ld_phong.DataSource = tbl;
            Drop_ld_phong.DataTextField = "MA_TEN";
            Drop_ld_phong.DataValueField = "ID";
            Drop_ld_phong.DataBind();
            Drop_ld_phong.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }
        protected void ddl_menu_bc_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Decimal id_menu = 0;
            //id_menu = Convert.ToDecimal(ddl_menu_bc.SelectedValue);
            //QT_MENU oP = dt.QT_MENU.Where(x => x.ID == id_menu).FirstOrDefault();
            switch (ddl_menu_bc.SelectedValue)
            {
                case "BC_VGDKT_4":
                    txtThuly_Tu.Enabled = true;
                    div_ddlPhoVuTruong.Style.Add("Display", "none");
                    div_nhom_all.Style.Add("Display", "none");
                    div_ddlLoaiAn.Style.Add("Display", "none");
                    break;
                case "BC_VGDKT_5":
                    txtThuly_Tu.Enabled = true;
                    div_ddlPhoVuTruong.Style.Add("Display", "none");
                    div_nhom_all.Style.Add("Display", "none");
                    div_ddlLoaiAn.Style.Add("Display", "none");
                    break;
                case "BC_VGDKT_6":
                    txtThuly_Tu.Enabled = false;
                    div_ddlPhoVuTruong.Style.Add("Display", "none");
                    div_nhom_all.Style.Add("Display", "none");
                    div_ddlLoaiAn.Style.Add("Display", "none");
                    break;
                case "BC_VGDKT_7":
                    txtThuly_Tu.Enabled = false;
                    div_ddlPhoVuTruong.Style.Add("Display", "none");
                    div_nhom_all.Style.Add("Display", "none");
                    div_ddlLoaiAn.Style.Add("Display", "none");
                    break;
                case "BC_VGDKT_12":
                    txtThuly_Tu.Enabled = true;
                    div_ddlPhoVuTruong.Style.Add("Display", "block");
                    div_nhom_all.Style.Add("Display", "none");
                    div_ddlLoaiAn.Style.Add("Display", "none");
                    break;
                case "BC_VGDKT_8":

                    txtThuly_Tu.Enabled = false;
                    div_nhom_all.Style.Add("Display", "block");
                    div_ddlPhoVuTruong.Style.Add("Display", "block");
                    div_ddlLoaiAn.Style.Add("Display", "none");
                    break;
                case "BC_VGDKT_10":
                    txtThuly_Tu.Enabled = true;
                    div_ddlLoaiAn.Style.Add("Display", "block");
                    div_ddlPhoVuTruong.Style.Add("Display", "none");
                    div_nhom_all.Style.Add("Display", "none");
                    break;
                case "BC_VGDKT_11":
                    txtThuly_Tu.Enabled = true;
                    div_ddlLoaiAn.Style.Add("Display", "none");
                    div_ddlPhoVuTruong.Style.Add("Display", "none");
                    div_nhom_all.Style.Add("Display", "none");
                    break;
                case "BC_VGDKT_1":
                    txtThuly_Tu.Enabled = true;
                    div_ddlLoaiAn.Style.Add("Display", "block");
                    break;
                default:
                    txtThuly_Tu.Enabled = true;
                    div_ddlPhoVuTruong.Style.Add("Display", "none");
                    div_nhom_all.Style.Add("Display", "none");
                    div_ddlLoaiAn.Style.Add("Display", "none");
                    break;

            }
        }
        void LoadDropLoaiAn()
        {
            //Decimal ChucVuPCA = 0;
            //try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }

            Boolean IsLoadAll = false;
            ddlLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                Decimal CurrChucVuID = string.IsNullOrEmpty(oCB.CHUCVUID + "") ? 0 : (decimal)oCB.CHUCVUID;

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCD.MA == "TPTATC")
                {
                    oCD = dt.DM_DATAITEM.Where(x => x.ID == CurrChucVuID).FirstOrDefault();
                    if (oCD != null)
                    {
                        if (oCD.MA == "CA")
                            IsLoadAll = true;
                        else if (oCD.MA == "PCA")
                            LoadLoaiAnPhuTrach(oCB);
                    }
                    else
                        IsLoadAll = true;
                    if (IsLoadAll) LoadAllLoaiAn();
                }
                else
                {
                    if (obj.ISHINHSU == 1)
                    {
                        ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                    }
                    LoadLoaiAnPhuTrach_TheoPB(obj);
                }
            }

            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            if (ddlLoaiAn.Items.Count > 1)
                ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
        }
        void LoadLoaiAnPhuTrach_TheoPB(DM_PHONGBAN obj)
        {
            if (obj.ISDANSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            }
            if (obj.ISHANHCHINH == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            }
            if (obj.ISHNGD == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            }
            if (obj.ISKDTM == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            }
            if (obj.ISLAODONG == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            }
        }
        void LoadLoaiAnPhuTrach(DM_CANBO obj)
        {
            if (obj.ISDANSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            }
            if (obj.ISHANHCHINH == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            }
            if (obj.ISHNGD == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            }
            if (obj.ISKDTM == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            }
            if (obj.ISLAODONG == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            }
            if (obj.ISHINHSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            }
        }
        void Bao_Cao_permi()
        {
            GDTTT_APP_BL obj_M = new GDTTT_APP_BL();
            DataTable objs = obj_M.Permi_Add_BC(Request.FilePath.ToString(), Convert.ToDecimal(Session["UserID"]));
            ddl_menu_bc.DataSource = objs;
            ddl_menu_bc.DataTextField = "TENMENU";
            ddl_menu_bc.DataValueField = "MAACTION";
            ddl_menu_bc.DataBind();
        }
        void Load_AllLanhDao()
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            //---------------------
            Decimal ChucDanh_TPTATC = 0;
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            //-----------------------
            DataTable tbl = new DataTable();
            if (oCB.CHUCDANHID == ChucDanh_TPTATC)
            {
                tbl = oGDTBL.DM_CANBO_PB_CHUCDANH_THEOTP(LoginDonViID, oCB.ID);
            }
            else
            {
                tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, "LDV");
            }
            ddlPhoVuTruong.DataSource = tbl;
            ddlPhoVuTruong.DataTextField = "HOTEN";
            ddlPhoVuTruong.DataValueField = "ID";
            ddlPhoVuTruong.DataBind();
            ddlPhoVuTruong.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        protected void btn_NhapMoi_Click(object sender, EventArgs e)
        {
            txtThuly_Tu.Text = string.Empty;
            txtThuly_Den.Text = string.Empty;
            drop_cbtk.SelectedValue = string.Empty;
            Drop_ld_phong.SelectedValue = string.Empty;
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            try
            {
                switch (ddl_menu_bc.SelectedValue)
                {
                    case "BC_VGDKT_4":
                    case "BC_VGDKT_5":
                    case "BC_VGDKT_12":
                    case "BC_VGDKT_10":
                    case "BC_VGDKT_11":
                    case "BC_VGDKT_1":
                        if (txtThuly_Tu.Text == "")
                        {
                            lblmsg.Text = "Bạn phải nhập từ ngày.";
                            return;
                        }
                        if (txtThuly_Den.Text == "")
                        {
                            lblmsg.Text = "Bạn phải nhập đến ngày.";
                            return;
                        }
                        break;
                    case "BC_VGDKT_6":
                    case "BC_VGDKT_7":
                    case "BC_VGDKT_8":
                        txtThuly_Tu.Text = "";
                        if (txtThuly_Den.Text == "")
                        {
                            lblmsg.Text = "Bạn phải nhập đến ngày.";
                            return;
                        }
                        break;
                }
                //////////////////////////////
                switch (ddl_menu_bc.SelectedValue)
                {
                    case "BC_VGDKT_1":
                        //Chưa có KQGQ
                        LoadReport_BC_VGDKT_1();
                        break;
                    case "BC_VGDKT_2":
                        LoadReport_BC_VGDKT_2();
                        break;
                    case "BC_VGDKT_3":
                        LoadReport_BC_VGDKT_3();
                        break;
                    case "BC_VGDKT_4":
                        LoadReport_BC_VGDKT_4();
                        break;
                    case "BC_VGDKT_5":
                        LoadReport_BC_VGDKT_5();
                        break;
                    case "BC_VGDKT_6":
                        LoadReport_BC_VGDKT_6();
                        break;
                    case "BC_VGDKT_7":
                        LoadReport_BC_VGDKT_7();
                        break;
                    case "BC_VGDKT_8":
                        if (rdbNhom.SelectedValue == "1")
                        {
                            LoadReport_BC_VGDKT_8_Group();
                        }
                        else
                        {
                            LoadReport_BC_VGDKT_8_All();
                        }
                        break;
                    case "BC_VGDKT_9":
                        LoadReport_BC_VGDKT_9();
                        break;
                    case "BC_VGDKT_10":
                        //4. Danh sách các vụ án dân sự đăng ký báo cáo tổ thẩm phán dân sự
                        LoadReport_BC_VGDKT_10();
                        break;
                    case "BC_VGDKT_11":
                        LoadReport_BC_VGDKT_11();
                        break;
                    case "BC_VGDKT_12":
                        LoadReport_BC_VGDKT_12();
                        break;
                    case "BC_VGDKT_13":
                        LoadReport_BC_VGDKT_13();
                        break;
                    case "BC_VGDKT_14":
                        //1. Thống kê thụ lý và giải quyết đơn đề nghị GĐTTT
                        LoadReport_BC_VGDKT_14();
                        break;
                    case "BC_VGDKT_15":
                        //14. Thống kê thụ lý, xét xử GĐT,TT của hội đồng Thẩm phán
                        LoadReport_BC_VGDKT_15();
                        break;
                    case "BC_VGDKT_16":
                        //19. Thống kê tinh hinh thu ly, giai quyet an quoc hoi
                        LoadReport_BC_VGDKT_16();
                        break;
                    case "BC_VGDKT_17":
                        //1.1 Thống kê tình hình thụ lý, giải quyết, xét xử GĐT, TT các loại vụ việc 6 tháng đầu năm
                        LoadReport_BC_VGDKT_17();
                        break;
                    case "BC_VGDKT_18":
                        //1.2  Về công tác thụ lý, giải quyết đơn GĐT, TT
                        LoadReport_BC_VGDKT_18();
                        break;
                    case "BC_VGDKT_19":
                        //1.3  Về công tác thụ lý, xét xử GĐT, TT
                        LoadReport_BC_VGDKT_19();
                        break;
                    case "BC_VGDKT_20":
                        //1.4 Báo cáo kết quả giải quyết của TTV
                        LoadReport_BC_VGDKT_20();
                        break;
                    case "BC_VGDKT_21":
                        //1.5 Báo cáo số liệu án XXGDT,TT của Thẩm phán
                        LoadReport_BC_VGDKT_21();
                        break;
                    //default:
                    //    break;

                    case "BC_VGDKT_22":
                        LoadReport_BC_VGDKT_22();
                        break;
                    case "BC_VGDKT_23":
                        //1.5 Báo cáo số liệu án XXGDT,TT của Thẩm phán
                        LoadReport_BC_VGDKT_23();
                        break;
                    case "BC_VGDKT_24":
                        //1.5 Báo cáo số liệu án XXGDT,TT của Thẩm phán
                        LoadReport_BC_VGDKT_24();
                        break;
                    case "BC_VGDKT_25":
                        //1.5 Báo cáo chánh án kết quả thực hiện nhiệm vụ chuyên môn của đơn vị
                        LoadReport_BC_VGDKT_25();
                        break;
                    //default:
                    //    break;
                    case "BC_TUAN_VGDKT_3":
                        // Báo cáo Giao ban vụ gdkt
                        LoadReport_TUAN_VGDKT_3();
                        break;
                    case "BC_TUAN_VGDKT_2":
                        LoadReport_TUAN_VGDKT_2();
                        break;

                    case "BC_THANG_VGDKT_2":
                        // Báo cáo Giao ban vụ gdkt
                        LoadReport_THANG_VGDKT_2();
                        break;

                }
            }
            catch (Exception ex) { lblmsg.Text = ex.Message; }
        }
        private bool CheckData()
        {
            string TuNgay = txtThuly_Tu.Text, DenNgay = txtThuly_Den.Text;
            if (TuNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập từ ngày.";
                Cls_Comon.SetFocus(this.txtThuly_Tu, this.GetType(), txtThuly_Tu.ClientID);
                return false;
            }
            if (TuNgay != "")
            {
                DateTime Day_TuNgay = DateTime.Now;
                if (DateTime.TryParse(TuNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_TuNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập từ ngày chưa đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtThuly_Tu, this.GetType(), txtThuly_Tu.ClientID);
                    return false;
                }
            }
            if (DenNgay == "")
            {
                lblmsg.Text = "Bạn chưa nhập đến ngày.";
                Cls_Comon.SetFocus(this.txtThuly_Den, this.GetType(), txtThuly_Den.ClientID);
                return false;
            }
            if (DenNgay != "")
            {
                DateTime Day_DenNgay = DateTime.Now;
                if (DateTime.TryParse(DenNgay, new System.Globalization.CultureInfo("vi-VN"), System.Globalization.DateTimeStyles.NoCurrentDateDefault, out Day_DenNgay) == false)
                {
                    lblmsg.Text = "Bạn nhập đến ngày đúng theo định dạng (Ngày / Tháng / Năm).";
                    Cls_Comon.SetFocus(this.txtThuly_Den, this.GetType(), txtThuly_Den.ClientID);
                    return false;
                }
            }
            if (TuNgay != "" && DenNgay != "")
            {
                if (DateTime.Parse(txtThuly_Tu.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault) > DateTime.Parse(txtThuly_Den.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault))
                {
                    lblmsg.Text = "Từ ngày phải nhỏ hơn hoặc bằng đến ngày.";
                    return false;
                }
            }
            return true;
        }
        private void LoadReport_BC_VGDKT_1()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
                //, string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
                //, string vNguyendon, string vBidon
                //, decimal vLoaiAn, decimal vThamtravien
                //, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
                //, decimal vTraloidon, decimal vLoaiCVID
                //, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                //, string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_1_PRINT(
                   "0", "NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, 0, ""
                   , "", "", ""
                   , "", ""
                   , vLoaiAn, 0
                   , 0, 0, 0, 0,
                   2, 0
                  , vNgayThulyTu, vNgayThulyDen
                  , "", 0, 4, 0
                  , 2, 2, 2, 0, 0, "", 2
                  , 0, 2, 0, 0, 0, 0
                  , 0, 0
              );
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_1.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_2()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
                //, string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
                //, string vNguyendon, string vBidon
                //, decimal vLoaiAn, decimal vThamtravien
                //, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
                //, decimal vTraloidon, decimal vLoaiCVID
                //, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                //, string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_2_PRINT(
                   "0", "NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, 0, ""
                   , "", "", ""
                   , "", ""
                   , vLoaiAn, 0
                   , 0, 0, 0, 0,
                   2, 0
                  , vNgayThulyTu, vNgayThulyDen
                  , "", 0, 4, 0
                  , 2, 2, 2, 0, 0, "55", 2
                  , 0, 2, 0, 0, 0, 0
                  , 0, 0
              );
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_2.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_3()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
                //, string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
                //, string vNguyendon, string vBidon
                //, decimal vLoaiAn, decimal vThamtravien
                //, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
                //, decimal vTraloidon, decimal vLoaiCVID
                //, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                //, string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_2_PRINT(
                   "0", "NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, 0, ""
                   , "", "", ""
                   , "", ""
                   , vLoaiAn, 0
                   , 0, 0, 0, 0,
                   2, 0
                  , vNgayThulyTu, vNgayThulyDen
                  , "", 0, 4, 0
                  , 2, 2, 2, 0, 0, "35", 2
                  , 0, 2, 0, 0, 0, 0
                  , 0, 0
              );
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_3.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_4()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(decimal vToaAnID, decimal vPhongBanID
                //, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
                //, string vNguyendon, string vBidon, decimal vLoaiAn
                //, decimal vThamtravien, decimal vLanhdao, decimal vThamphan

                //, DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
                //, decimal vTrangthai, int captrinhtiep_id, int isdangkybc
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
                //, int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_4_PRINT(vToaAnID, vPhongbanID
                   , 0, "", ""
                   , "", "", vLoaiAn
                   , 0, Convert.ToDecimal(ddlPhoVuTruong.SelectedValue), 0
                   , vNgayThulyTu, vNgayThulyDen, ""
                   , 0, 0, 2
                   , 2, 2, 12, 0
                   , 4, 0, "", 2
                   , 0, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Totrinh_da_duyet_Khang_Nghi.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_5()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(decimal vToaAnID, decimal vPhongBanID
                //, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
                //, string vNguyendon, string vBidon, decimal vLoaiAn
                //, decimal vThamtravien, decimal vLanhdao, decimal vThamphan

                //, DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
                //, decimal vTrangthai, int captrinhtiep_id, int isdangkybc
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
                //, int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_4_PRINT(vToaAnID, vPhongbanID
                   , 0, "", ""
                   , "", "", vLoaiAn
                   , 0, Convert.ToDecimal(ddlPhoVuTruong.SelectedValue), 0
                   , vNgayThulyTu, vNgayThulyDen, ""
                   , 0, 0, 2
                   , 2, 2, 11, 0
                   , 4, 0, "", 2
                   , 0, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Totrinh_Da_duyet_TLD.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_6()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
                //, string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
                //, string vNguyendon, string vBidon
                //, decimal vLoaiAn, decimal vThamtravien
                //, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
                //, decimal vTraloidon, decimal vLoaiCVID
                //, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                //, string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_6_PRINT(
                   "0", "NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, 0, ""
                   , "", "", ""
                   , "", ""
                   , vLoaiAn, 0
                   , Convert.ToDecimal(ddlPhoVuTruong.SelectedValue), 0, 0, 0
                   , 2, 0
                  , vNgayThulyTu, vNgayThulyDen
                  , "", 0, 7, 0
                  , 2, 2, 2, 0, 1, "", 2
                  , 1, 2, 0, 0, 0, 0
                  , 0, 0
              );
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DS_AnQH_chuaTraLoiTinhThe.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_7()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
                //, string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
                //, string vNguyendon, string vBidon
                //, decimal vLoaiAn, decimal vThamtravien
                //, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
                //, decimal vTraloidon, decimal vLoaiCVID
                //, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                //, string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_6_PRINT(
                   "0", "NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, 0, ""
                   , "", "", ""
                   , "", ""
                   , vLoaiAn, 0
                   , Convert.ToDecimal(ddlPhoVuTruong.SelectedValue), 0, 0, 0
                   , 2, 0
                  , vNgayThulyTu, vNgayThulyDen
                  , "", 0, 7, 0
                  , 2, 2, 2, 0, 1, "", 2
                  , 3, 2, 0, 0, 0, 0
                  , 0, 0
              );
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=DS_AnQH_chua_TBKQ.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_8_Group()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
                //, string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
                //, string vNguyendon, string vBidon
                //, decimal vLoaiAn, decimal vThamtravien
                //, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
                //, decimal vTraloidon, decimal vLoaiCVID
                //, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                //, string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_8_PRINT_GROUP(
                   "0", "NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, 0, ""
                   , "", "", ""
                   , "", ""
                   , vLoaiAn, 0
                   , Convert.ToDecimal(ddlPhoVuTruong.SelectedValue), 0, 0, 0
                   , 2, 0
                  , vNgayThulyTu, vNgayThulyDen
                  , "", 0, 4, 0
                  , 2, 2, 2, 0, 1, "", 2
                  , 0, 2, 0, 0, 0, 0
                  , 0, 0
              );
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_8_Group.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_8_All()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
                //, string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
                //, string vNguyendon, string vBidon
                //, decimal vLoaiAn, decimal vThamtravien
                //, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
                //, decimal vTraloidon, decimal vLoaiCVID
                //, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                //, string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_8_PRINT_ALL(
                   "0", "NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, 0, ""
                   , "", "", ""
                   , "", ""
                   , vLoaiAn, 0
                   , Convert.ToDecimal(ddlPhoVuTruong.SelectedValue), 0, 0, 0
                   , 2, 0
                  , vNgayThulyTu, vNgayThulyDen
                  , "", 0, 4, 0
                  , 2, 2, 2, 0, 1, "", 2
                  , 0, 2, 0, 0, 0, 0
                  , 0, 0
              );
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_8_All.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_9()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;
                //(string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
                //, string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
                //, string vNguyendon, string vBidon
                //, decimal vLoaiAn, decimal vThamtravien
                //, decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
                //, decimal vTraloidon, decimal vLoaiCVID
                //, DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
                //, string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_9_PRINT(
                   "0", "NGAYTHULYDON", "DESC", vToaAnID, vPhongbanID, 0, ""
                   , "", "", ""
                   , "", ""
                   , vLoaiAn, 0
                   , 0, 0, 0, 0,
                   2, 0
                  , vNgayThulyTu, vNgayThulyDen
                  , "", 0, 5, 0
                  , 2, 2, 2, 0, 1, "", 2
                  , 0, 2, 0, 0, 0, 0
                  , 0, 0
              );
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_9.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_10()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                //(decimal vToaAnID, decimal vPhongBanID
                //, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
                //, string vNguyendon, string vBidon, decimal vLoaiAn
                //, decimal vThamtravien, decimal vLanhdao, decimal vThamphan

                //, DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
                //, decimal vTrangthai, int captrinhtiep_id, int isdangkybc
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
                //, int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_10_PRINT(vToaAnID, vPhongbanID
                   , 0, "", ""
                   , "", "", vLoaiAn
                   , 0, 0, 0
                   , vNgayThulyTu, vNgayThulyDen, ""
                   , 9, 0, 1
                   , 2, 2, 2, 0
                   , 3, 0, "", 2
                   , 0, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_10.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_11()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                //(decimal vToaAnID, decimal vPhongBanID
                //, decimal vToaRaBAQD, string vSoBAQD, string vNgayBAQD
                //, string vNguyendon, string vBidon, decimal vLoaiAn
                //, decimal vThamtravien, decimal vLanhdao, decimal vThamphan

                //, DateTime? vTuNgay, DateTime? vDenNgay, string vSoThuly
                //, decimal vTrangthai, int captrinhtiep_id, int isdangkybc
                //, int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT
                //, int ketquathuly, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
                //, decimal PageIndex, decimal PageSize)
                tbl = oBL.BC_VGDKT_11_PRINT(vToaAnID, vPhongbanID
                   , 0, "", ""
                   , "", "", vLoaiAn
                   , 0, 0, 0
                   , vNgayThulyTu, vNgayThulyDen, ""
                   , 8, 0, 1
                   , 2, 2, 2, 0
                   , 3, 0, "", 2
                   , 0, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_11.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_12()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;

                tbl = oBL.BC_VGDKT_12_PRINT(vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, vLanhdaoID);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_12.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_13()
        {
            try
            {
                lblmsg.Text = "";
                //----
                if (CheckData() == false)
                {
                    return;
                }
                String vToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "";
                string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                object Result = new object();
                //DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
                DateTime? vNgayTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                Literal Table_Str_Totals = new Literal();
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                //-------------
                tbl = oBL.BC_VGDKT_13_PRINT(vToaAnID, strPBID, "", vNgayTu, vNgayDen);
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_DONDN_GDTTT_THULY_VU_GDKT_13.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_14()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;
                Decimal vLoaiAn = 0;
                if (vPhongbanID == 2)
                    vLoaiAn = 1;

                tbl = oBL.BC_VGDKT_14_PRINT(vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------Thống kê thụ lý và giải quyết đơn đề nghị GĐTTT
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Thong_Ke_Thu_Ly_Va_GiaiQuyet_Don_De_Nghi_GĐTTT.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_15()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_VGDKT_15_PRINT(vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //----Thống kê thụ lý, xét xử GĐT,TT của hội đồng Thẩm phán----------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Thong_ke_Thuly_xetxu_GDTTT_của_HDTP.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_16()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_VGDKT_16_PRINT(vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Thongke_thuly_giaiquyet_an_Quochoi.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_17()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_VGDKT_17_PRINT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------Thống kê thụ lý và giải quyết đơn đề nghị GĐTTT
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_17.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_18()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_VGDKT_18_PRINT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------Thống kê thụ lý và giải quyết đơn đề nghị GĐTTT
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_18.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_19()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_VGDKT_19_PRINT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------Thống kê thụ lý và giải quyết đơn đề nghị GĐTTT

                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_19.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_20()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_VGDKT_20_PRINT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------Thống kê TTV giải quyết đơn đề nghị GĐTTT
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_20.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                //Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");   // add the style props to get the page orientation
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();

            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_21()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_VGDKT_21_PRINT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                }
                //--------------------------Thống kê thụ lý và giải quyết đơn đề nghị GĐTTT
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VGDKT_21.doc");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/msword";
                HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                Response.Write("<html");
                Response.Write("<head>");
                Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
                Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
                Response.Write("<meta name=ProgId content=Word.Document>");
                Response.Write("<meta name=Generator content=Microsoft Word 9>");
                Response.Write("<meta name=Originator content=Microsoft Word 9>");
                Response.Write("<style>");
                Response.Write("<!-- /* Style Definitions */" +
                                              "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                              "{margin:0in;" +
                                              "margin-bottom:.0001pt;" +
                                              "mso-pagination:widow-orphan;" +
                                              "tab-stops:center 3.0in right 6.0in;" +
                                              "font-size:12.0pt;}");

                Response.Write("@page Section1 {size:595.45pt 841.7pt;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section1 {page:Section1;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                Response.Write("div.Section2 {page:Section2;}");
                Response.Write("<style>");
                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");//chỉ định khổ giấy
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_23()
        {
            //DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.ParseExact(txtThuly_Tu.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            //DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.ParseExact(txtThuly_Den.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);

            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);//1
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);//401
            decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);

            var tbl = GDTTT_BAOCAO_BL.BC_VGDKT_23_READING<BC_VGDKT_23_Cls>(txtThuly_Tu.Text, txtThuly_Den.Text, "473", "424", vPhongbanID.ToString());
            //--------HÀM GEN RA FILE-----------------------------
            XlsFile xls = new XlsFile(true);
            //var link = Server.MapPath("~/Reports/BC_VGDKT_23.xlsx");
            xls.Open(Server.MapPath("~/TempUpload/BaoCaoVuTruongSoLieuToTrinh.xlsx"));

            FlexCelReport report = new FlexCelReport();

            // Gán bảng dữ liệu
            report.AddTable("BC", tbl);

            // Gán tham số ngày
            report.SetValue("NgayLoc", "(Tính từ ngày " + txtThuly_Tu.Text + " đến ngày " + txtThuly_Den.Text + ")");
            //report.SetValue("NgayDen", vNgayThulyDen);

            // Chạy report
            report.Run(xls);

            using (MemoryStream ms = new MemoryStream())
            {
                xls.Save(ms);
                ms.Position = 0;

                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("Content-Disposition", "attachment; filename=BC_VGDKT_23.xlsx");
                Response.BinaryWrite(ms.ToArray());
                Response.Flush();
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }
        private void LoadReport_BC_VGDKT_24()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_VGDKT_24_PRINT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
                ExcelPackage pack = new ExcelPackage();

                if (tbl != null && tbl.Rows.Count > 0)
                {
                    ExcelWorksheet worksheet = pack.Workbook.Worksheets.Add("TongTLGQ");
                    //tiêu đề báo cáo
                    worksheet.TabColor = System.Drawing.Color.Black;
                    // Set default Height cho tất cả column
                    //worksheet.DefaultRowHeight = 20;                
                    //Số dòng trong báo cáo
                    int cRows = tbl.Rows.Count + 6;
                    //Viet tieu de bao cao             
                    worksheet.Cells[3, 1].Value = "SỐ LIỆU THỤ LÝ, GIẢI QUYẾT CÁC VỤ ÁN ĐÃ PHÂN CÔNG";
                    worksheet.Row(3).Height = 35;
                    worksheet.Cells[4, 1].Value = "(Tính từ " + txtThuly_Tu.Text + " đến " + txtThuly_Den.Text + ")";
                    worksheet.Row(4).Height = 20;

                    worksheet.Cells["A3:F3"].Merge = true;
                    worksheet.Cells["A4:F4"].Merge = true;
                    // Lấy range vào tạo format cho range đó ở đây là từ A1 tới b3
                    using (var range = worksheet.Cells["A3:F6"])
                    {
                        // Canh giữa cho các text
                        range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        // Set Font cho text  trong Range hiện tại
                        range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 13));
                        // Set chu Bold
                        range.Style.Font.Bold = true;
                        //Set mau chu
                        range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                        // Tự động xuống hàng khi text quá dài
                        range.Style.WrapText = true;
                    }
                    var skyscrapers = new object[1, 6]
                   {
                        { "STT","THẨM PHÁN","Tổng thụ lý"
                        ,"Đã giải quyết dứt điểm"
                        ,"Chưa giải quyết"
                        ,"Tỷ lệ (%)"
                       }
                   };
                    worksheet.Column(1).Width = 8;  // STT
                    worksheet.Column(2).Width = 30; // 
                    worksheet.Column(3).Width = 10; // 
                    worksheet.Column(4).Width = 10; // 
                    worksheet.Column(5).Width = 8; // 
                    worksheet.Column(6).Width = 8; // 

                    int i, j;
                    // Write header data to Excel cells.
                    for (j = 0; j <= 5; j++)
                    {
                        worksheet.Cells[6, j + 1].Value = skyscrapers[0, j];
                    }
                    worksheet.Row(6).Height = 72;
                    //------------

                    //Viet Noi dung Bao cao
                    //-----------
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        i = 0;
                        foreach (DataRow row in tbl.Rows)
                        {
                            for (j = 0; j <= 5; j++)
                            {
                                worksheet.Cells[i + 7, j + 1].Value = row[j].ToString();
                                //row[j].ToString(): dữ liệu của bảng tbl lấy từ db
                                //worksheet.Cells[i + 7, j + 1].Value - tọa độ của file excel
                            }
                            i = i + 1;
                        }
                    }

                    // Lấy range vào tạo format cho range
                    using (var range = worksheet.Cells["A6:F" + tbl.Rows.Count + 7])
                    {
                        // Canh giữa cho các text
                        range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        // Set Font cho text  trong Range hiện tại
                        range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 13));

                        //Set mau chu
                        range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                        // Tự động xuống hàng khi text quá dài
                        range.Style.WrapText = true;
                    }
                    using (var range = worksheet.Cells["B7:B" + tbl.Rows.Count + 7])
                    {
                        range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    }

                    // Lấy range vào tạo Border bang
                    using (var range = worksheet.Cells["A6:F" + cRows])
                    {
                        //Set border
                        range.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        range.Style.Border.Top.Color.SetColor(System.Drawing.Color.Black);
                        range.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        range.Style.Border.Left.Color.SetColor(System.Drawing.Color.Black);
                        range.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        range.Style.Border.Right.Color.SetColor(System.Drawing.Color.Black);
                        range.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        range.Style.Border.Bottom.Color.SetColor(System.Drawing.Color.Black);
                    }
                    using (var range = worksheet.Cells["A6:F6"])
                    {
                        // Canh giữa cho các text
                        range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        // Set Font cho text  trong Range hiện tại
                        range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 13));
                        // Set chu Bold
                        range.Style.Font.Bold = true;
                        //Set mau chu
                        range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                        // Tự động xuống hàng khi text quá dài
                        range.Style.WrapText = true;
                    }
                    using (var range = worksheet.Cells["C7:F" + (tbl.Rows.Count + 7)])//cRows
                    {

                        foreach (var cell in range)
                        {
                            if (cell.Value != null)
                            {
                                double val; // Khai báo biến trước để tránh lỗi "Invalid expression term"
                                if (double.TryParse(cell.Value.ToString(), out val))
                                {
                                    cell.Value = val;
                                }
                            }
                        }
                        range.Style.Numberformat.Format = "#,##0";
                    }
                    // Print options:
                    worksheet.PrinterSettings.PaperSize = ePaperSize.A4;
                    worksheet.PrinterSettings.Orientation = eOrientation.Landscape;
                    worksheet.PrinterSettings.HorizontalCentered = true;
                    worksheet.PrinterSettings.FitToPage = true;
                    worksheet.PrinterSettings.FitToWidth = 1;
                    worksheet.PrinterSettings.FitToHeight = 0;
                }

                if (pack != null)
                {
                    // Tên file mà người dùng sẽ thấy khi tải xuống
                    string fileName = String.Format("Tong_TLGQ_{0}.xlsx", DateTime.Now.ToString("ddMMyyyy_HHmmss"));
                    // Đặt các header cho phản hồi HTTP để trình duyệt tải xuống file
                    Response.Clear();
                    Response.BufferOutput = true; // Thường nên để true khi gửi toàn bộ nội dung trong MemoryStream
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment; filename=" + fileName);
                    // Ghi nội dung của ExcelPackage vào MemoryStream
                    using (MemoryStream ms = new MemoryStream())
                    {
                        pack.SaveAs(ms); // Lưu ExcelPackage vào MemoryStream
                        ms.Position = 0; // Đặt con trỏ về đầu MemoryStream
                        // Gửi nội dung MemoryStream về client
                        ms.CopyTo(Response.OutputStream);
                    }
                    pack.Dispose(); // Giải phóng tài nguyên của ExcelPackage sau khi đã lưu
                    Response.End(); // Kết thúc phản hồi HTTP
                }

            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_BC_VGDKT_25()
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);//1
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);//401
            decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            BC_VGDKT_25_Cls BcVGDKT = new BC_VGDKT_25_Cls();
            if (string.IsNullOrEmpty(txtThuly_Den.Text))
            {
                txtThuly_Den.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }
            DateTime ngay_hs = Convert.ToDateTime(txtThuly_Den.Text + "");
            String StrThoiGian_DiaDiem = "Hà Nội, ngày " + ngay_hs.Day.ToString("D2") + " tháng " + ngay_hs.Month.ToString("D2") + " năm " + ngay_hs.Year.ToString();
            BcVGDKT.ThoiGian = StrThoiGian_DiaDiem;

            var tbl = new List<BC_VGDKT_25_Cls>();
            if (string.IsNullOrEmpty(txtThuly_Tu.Text))
            {
                tbl = GDTTT_BAOCAO_BL.BC_VGDKT_25_COUNT<BC_VGDKT_25_Cls>(GetDauNamCongTac(txtThuly_Den.Text), txtThuly_Den.Text, "473", "424", vPhongbanID.ToString(), vToaAnID.ToString());
            }
            else
            {
                tbl = GDTTT_BAOCAO_BL.BC_VGDKT_25_COUNT<BC_VGDKT_25_Cls>(GetDauNamCongTac(txtThuly_Tu.Text), txtThuly_Den.Text, "473", "424", vPhongbanID.ToString(), vToaAnID.ToString());
            }
            if (tbl.Count() > 0)
            {
                foreach (var item in tbl)
                {
                    BcVGDKT.SoVuAnKhangNghiCATC = item.SoVuAnKhangNghiCATC == "0" ? "0" : item.SoVuAnKhangNghiCATC.PadLeft(2, '0');
                    BcVGDKT.SoVuAnKhangNghiCC = item.SoVuAnKhangNghiCC == "0" ? "0" : item.SoVuAnKhangNghiCC.PadLeft(2, '0');
                    BcVGDKT.SoVuAnKhangNghiVksTC = item.SoVuAnKhangNghiVksTC == "0" ? "0" : item.SoVuAnKhangNghiVksTC.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDaXetXu = item.SoVuAnDaXetXu == "0" ? "0" : item.SoVuAnDaXetXu.PadLeft(2, '0');
                    BcVGDKT.TongSoVuAnDaThuLy = item.TongSoVuAnDaThuLy == "0" ? "0" : item.TongSoVuAnDaThuLy.PadLeft(2, '0');
                    BcVGDKT.VuPhanTPTC = item.VuPhanTPTC == "0" ? "0" : item.VuPhanTPTC.PadLeft(2, '0');
                    BcVGDKT.VuPhanTPB3 = item.VuPhanTPB3 == "0" ? "0" : item.VuPhanTPB3.PadLeft(2, '0');
                    BcVGDKT.TongSoVuAnDaThuLyDaGiaiQuyet = item.TongSoVuAnDaThuLyDaGiaiQuyet == "0" ? "0" : item.TongSoVuAnDaThuLyDaGiaiQuyet.PadLeft(2, '0');
                    BcVGDKT.TongTraLoiDon = item.TongTraLoiDon == "0" ? "0" : item.TongTraLoiDon.PadLeft(2, '0');
                    BcVGDKT.TongKhangNghi = item.TongKhangNghi == "0" ? "0" : item.TongKhangNghi.PadLeft(2, '0');
                    BcVGDKT.TongXuLyKhac = item.TongXuLyKhac == "0" ? "0" : item.TongXuLyKhac.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinh = item.SoVuAnDangTrinh == "0" ? "0" : item.SoVuAnDangTrinh.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinhLDV = item.SoVuAnDangTrinhLDV == "0" ? "0" : item.SoVuAnDangTrinhLDV.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinhTPB3 = item.SoVuAnDangTrinhTPB3 == "0" ? "0" : item.SoVuAnDangTrinhTPB3.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinhTPTC = item.SoVuAnDangTrinhTPTC == "0" ? "0" : item.SoVuAnDangTrinhTPTC.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinhToTP = item.SoVuAnDangTrinhToTP == "0" ? "0" : item.SoVuAnDangTrinhToTP.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinhCA = item.SoVuAnDangTrinhCA == "0" ? "0" : item.SoVuAnDangTrinhCA.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinhPCA = item.SoVuAnDangTrinhPCA == "0" ? "0" : item.SoVuAnDangTrinhPCA.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinhDuThaoTLD = item.SoVuAnDangTrinhDuThaoTLD == "0" ? "0" : item.SoVuAnDangTrinhDuThaoTLD.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinhDuThaoKN = item.SoVuAnDangTrinhDuThaoKN == "0" ? "0" : item.SoVuAnDangTrinhDuThaoKN.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangTrinhNghienCuuLai = item.SoVuAnDangTrinhNghienCuuLai == "0" ? "0" : item.SoVuAnDangTrinhNghienCuuLai.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangHoanThienToTrinh = item.SoVuAnDangHoanThienToTrinh == "0" ? "0" : item.SoVuAnDangHoanThienToTrinh.PadLeft(2, '0');
                    BcVGDKT.SoVuAnDangNghienCuu = item.SoVuAnDangNghienCuu == "0" ? "0" : item.SoVuAnDangNghienCuu.PadLeft(2, '0');
                }
            }
            BcVGDKT.TongSoVuAnDaThuLy = (int.Parse(BcVGDKT.VuPhanTPTC) + int.Parse(BcVGDKT.VuPhanTPB3)).ToString();
            BcVGDKT.TongSoVuAnDaThuLy = BcVGDKT.TongSoVuAnDaThuLy == "0" ? "0" : BcVGDKT.TongSoVuAnDaThuLy.PadLeft(2, '0');

            BcVGDKT.TongVuXxGDT = (int.Parse(BcVGDKT.SoVuAnKhangNghiCATC) + int.Parse(BcVGDKT.SoVuAnKhangNghiCC) + int.Parse(BcVGDKT.SoVuAnKhangNghiVksTC)).ToString();
            BcVGDKT.TongVuXxGDT = BcVGDKT.TongVuXxGDT == "0" ? "0" : BcVGDKT.TongVuXxGDT.PadLeft(2, '0');
            BcVGDKT.ConLai = (int.Parse(BcVGDKT.TongVuXxGDT) - int.Parse(BcVGDKT.SoVuAnDaXetXu)).ToString();
            BcVGDKT.ConLai = BcVGDKT.ConLai == "0" ? "0" : BcVGDKT.ConLai.PadLeft(2, '0');
            BcVGDKT.SoVuAnDangTrinhLDV = (int.Parse(BcVGDKT.SoVuAnDangTrinhLDV) + int.Parse(BcVGDKT.SoVuAnDangTrinhTPB3)).ToString();
            BcVGDKT.SoVuAnDangTrinhLDV = BcVGDKT.SoVuAnDangTrinhLDV == "0" ? "0" : BcVGDKT.SoVuAnDangTrinhLDV.PadLeft(2, '0');

            BcVGDKT.SoVuAnDangTrinh = (int.Parse(BcVGDKT.SoVuAnDangTrinhToTP) 
                                    + int.Parse(BcVGDKT.SoVuAnDangTrinhLDV) 
                                    + int.Parse(BcVGDKT.SoVuAnDangTrinhTPTC)
                                    + int.Parse(BcVGDKT.SoVuAnDangTrinhCA)
                                    + int.Parse(BcVGDKT.SoVuAnDangTrinhPCA)
                                    + int.Parse(BcVGDKT.SoVuAnDangTrinhDuThaoTLD)
                                    + int.Parse(BcVGDKT.SoVuAnDangTrinhDuThaoKN)
                                    + int.Parse(BcVGDKT.SoVuAnDangTrinhNghienCuuLai)
                                    + int.Parse(BcVGDKT.SoVuAnDangHoanThienToTrinh)
                                    ).ToString() ;
            BcVGDKT.SoVuAnDangTrinh = BcVGDKT.SoVuAnDangTrinh == "0" ? "0" : BcVGDKT.SoVuAnDangTrinh.PadLeft(2, '0');

            BcVGDKT.SoHoSoConLai = (int.Parse(BcVGDKT.SoVuAnDangTrinh) + int.Parse(BcVGDKT.SoVuAnDangNghienCuu)).ToString();
            BcVGDKT.SoHoSoConLai = BcVGDKT.SoHoSoConLai == "0" ? "0" : BcVGDKT.SoHoSoConLai.PadLeft(2, '0');

            var objCBs = dt.DM_CANBO.Where(x => x.PHONGBANID == vPhongbanID).ToArray();
            if (objCBs.Length > 0)
            {
                DM_CANBO objCB = objCBs.Where(x => x.CHUCVUID == 432).FirstOrDefault();
                if (objCB != null)
                {
                    BcVGDKT.NguoiKy = objCB.HOTEN;
                }
            }
            //--------HÀM GEN RA FILE DOCX-----------------------------
            string XmlFile = Server.MapPath("~/TempUpload/BaoCaoKetQuaThucHienNhiemVuChuyenMonV2.docx");
            Document reportDocument = new Document(XmlFile);

            foreach (var fieldname in reportDocument.MailMerge.GetFieldNames())
            {
                var valIndex = fieldname.IndexOf(':');
                if (valIndex > 0)
                    reportDocument.MailMerge.MappedDataFields.Add(fieldname, fieldname.Substring(valIndex + 1));
            }

            var data = new Dictionary<string, object>
            {
                { "ThoiGian", BcVGDKT.ThoiGian },
                { "TongVuXxGDT", BcVGDKT.TongVuXxGDT },
                { "ConLai", BcVGDKT.ConLai },
                { "SoVuAnKhangNghiCATC", BcVGDKT.SoVuAnKhangNghiCATC },
                { "SoVuAnKhangNghiCC", BcVGDKT.SoVuAnKhangNghiCC },
                { "SoVuAnKhangNghiVksTC", BcVGDKT.SoVuAnKhangNghiVksTC },
                { "SoVuAnDaXetXu", BcVGDKT.SoVuAnDaXetXu },
                { "TongSoVuAnDaThuLy", BcVGDKT.TongSoVuAnDaThuLy },
                { "VuPhanTPTC", BcVGDKT.VuPhanTPTC },
                { "VuPhanTPB3", BcVGDKT.VuPhanTPB3 },
                { "TongSoVuAnDaThuLyDaGiaiQuyet", BcVGDKT.TongSoVuAnDaThuLyDaGiaiQuyet },
                { "TongTraLoiDon", BcVGDKT.TongTraLoiDon },
                { "TongKhangNghi", BcVGDKT.TongKhangNghi },
                { "TongXuLyKhac", BcVGDKT.TongXuLyKhac },
                { "SoHoSoConLai", BcVGDKT.SoHoSoConLai },
                { "SoVuAnDangTrinh", BcVGDKT.SoVuAnDangTrinh },
                { "SoVuAnDangTrinhLDV", BcVGDKT.SoVuAnDangTrinhLDV },
                { "SoVuAnDangTrinhTPB3", BcVGDKT.SoVuAnDangTrinhTPB3 },
                { "SoVuAnDangTrinhTPTC", BcVGDKT.SoVuAnDangTrinhTPTC },
                { "SoVuAnDangTrinhToTP", BcVGDKT.SoVuAnDangTrinhToTP },
                { "SoVuAnDangTrinhCA", BcVGDKT.SoVuAnDangTrinhCA },
                { "SoVuAnDangTrinhPCA", BcVGDKT.SoVuAnDangTrinhPCA },
                { "SoVuAnDangTrinhDuThaoTLD", BcVGDKT.SoVuAnDangTrinhDuThaoTLD },
                { "SoVuAnDangTrinhDuThaoKN", BcVGDKT.SoVuAnDangTrinhDuThaoKN },
                { "SoVuAnDangTrinhNghienCuuLai", BcVGDKT.SoVuAnDangTrinhNghienCuuLai },
                { "SoVuAnDangHoanThienToTrinh", BcVGDKT.SoVuAnDangHoanThienToTrinh },
                { "SoVuAnDangNghienCuu", BcVGDKT.SoVuAnDangNghienCuu },
                { "DenNgay", txtThuly_Den.Text },
                { "NguoiKy", BcVGDKT.NguoiKy }
            };

            reportDocument.MailMerge.Execute(
                data.Keys.ToArray(),
                data.Values.ToArray()
            );

            Document doc = new Document(XmlFile);

            foreach (Node node in doc.GetChildNodes(NodeType.Any, true))
            {
                if (node.NodeType == NodeType.Shape ||
                    node.NodeType == NodeType.GroupShape ||
                    node.NodeType == NodeType.DrawingML)
                {
                    Console.WriteLine("DRAW OBJECT FOUND");
                    Console.WriteLine("NodeType: " + node.NodeType);
                    Console.WriteLine("Parent: " + node.ParentNode.NodeType);

                    Paragraph para = node.GetAncestor(NodeType.Paragraph) as Paragraph;
                    if (para != null)
                    {
                        var a = ("Near text: " + para.ToString(Aspose.Words.SaveFormat.Text));
                    }

                    Console.WriteLine("--------------------");
                }
            }

            using (MemoryStream ms = new MemoryStream())
            {
                reportDocument.Save(ms, Aspose.Words.SaveFormat.Docx);
                ms.Position = 0;
                byte[] bytes = ms.ToArray();

                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.Buffer = true;
                Response.ContentType =
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader(
                    "Content-Disposition", "attachment; filename=BaoCaoKetQuaThucHienNhiemVuChuyenMonV2.docx");
                Response.BinaryWrite(bytes);
                Response.Flush();
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }

        private void LoadReport_TUAN_VGDKT_3()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_TUAN_VGDKT_3_PRINT(vToaAnID, vPhongbanID, txtThuly_Tu.Text, txtThuly_Den.Text);
                //-----------------------------------------

                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string fileName = "";
                    string saveAs = pathTemplateWord + "rptBaoCaoTuan_" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";


                    string fileNameSave = "rptBaoCaoTuan_" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";

                    Document doc = new Document();
                    fileName = pathTemplateWord + "rptBaocaotuan_vugdkt3.doc";

                    foreach (DataRow item in tbl.Rows)
                    {
                        string strNgay = "", strThang = "", strNam = "";

                        Document baoCao = new Document(fileName);

                        DateTime dNgayCV = (String.IsNullOrEmpty(txtThuly_Den.Text)) ? DateTime.MinValue : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = String.Format("{0:00}", dNgayCV.Day);
                            strThang = String.Format("{0:00}", dNgayCV.Month);
                            strNam = dNgayCV.Year.ToString();
                        }

                        baoCao.MailMerge.Execute(new[] { "NGAY" }, new[] { strNgay });
                        baoCao.MailMerge.Execute(new[] { "THANG" }, new[] { strThang });
                        baoCao.MailMerge.Execute(new[] { "NAM" }, new[] { strNam });


                        baoCao.MailMerge.Execute(new[] { "TUNGAY" }, new[] { txtThuly_Tu.Text });
                        baoCao.MailMerge.Execute(new[] { "DENNGAY" }, new[] { txtThuly_Den.Text });


                        baoCao.MailMerge.Execute(new[] { "7KETQUAGQ" }, new[] { item["v7KETQUAGQ"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "7TONGSOVUTRINH" }, new[] { item["v7TONGSOVUTRINH"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "7XETXU" }, new[] { item["v7XETXU"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "TONGPHAIGQ" }, new[] { item["vTONGPHAIGQ"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "TONGGIAIQUYET" }, new[] { item["vTONGGIAIQUYET"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "TONGTT" }, new[] { item["vTONGTT"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "TONGTLXX" }, new[] { item["vTONGTLXX"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "NAMXETXU" }, new[] { item["vNAMXETXU"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "LICHXXGDT" }, new[] { item["vLICHXXGDT"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "LICHXXGDT_CT" }, new[] { item["vLICHXXGDT_CT"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "TONGTRAODOI" }, new[] { item["vTONGTRAODOI"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "TRAODOI_VB" }, new[] { item["vTRAODOI_VB"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "TRAODOI_TOTRINH" }, new[] { item["vTRAODOI_TOTRINH"].ToString() });

                        doc.AppendDocument(baoCao, ImportFormatMode.KeepSourceFormatting);

                    }

                    doc.Sections[0].Range.Delete();
                    doc.Save(saveAs);
                    ExportData(fileNameSave, (string)saveAs);

                }
                tbl = null;


            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        protected void ExportData(string fileName, string path)
        {
            try
            {
                //copy to MemoryStream
                MemoryStream ms = new MemoryStream();
                using (FileStream fs = File.OpenRead(Path.Combine(path)))
                {
                    fs.CopyTo(ms);
                }

                //Delete file
                if (File.Exists(Path.Combine(path)))
                    File.Delete(Path.Combine(path));

                //Download file
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
                Response.BinaryWrite(ms.ToArray());
            }
            catch { }

            Response.End();
        }
        private void LoadReport_BC_VGDKT_22()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_VGDKT_22_PRINT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
                ExcelPackage pack = new ExcelPackage();

                if (tbl != null && tbl.Rows.Count > 0)
                {
                    ExcelWorksheet worksheet = pack.Workbook.Worksheets.Add("TongTLGQ");
                    //tiêu đề báo cáo
                    worksheet.TabColor = System.Drawing.Color.Black;
                    // Set default Height cho tất cả column
                    //worksheet.DefaultRowHeight = 20;                
                    //Số dòng trong báo cáo
                    int cRows = tbl.Rows.Count + 6;
                    //Viet tieu de bao cao
                    worksheet.Cells[2, 1].Value = "BÁO CÁO VỤ TRƯỞNG";
                    worksheet.Row(2).Height = 20;
                    worksheet.Cells[3, 1].Value = "SỐ LIỆU THỤ LÝ, GIẢI QUYẾT CÁC VỤ ÁN ĐÃ PHÂN CÔNG THẨM PHÁN";
                    worksheet.Row(3).Height = 20;
                    worksheet.Cells[4, 1].Value = "(Tính từ " + txtThuly_Tu.Text + " đến " + txtThuly_Den.Text + ")";
                    worksheet.Row(4).Height = 20;
                    worksheet.Cells["A2:R2"].Merge = true;
                    worksheet.Cells["A3:R3"].Merge = true;
                    worksheet.Cells["A4:R4"].Merge = true;

                    // Lấy range vào tạo format cho range đó ở đây là từ A1 tới b3
                    using (var range = worksheet.Cells["A2:R6"])
                    {
                        // Canh giữa cho các text
                        range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        // Set Font cho text  trong Range hiện tại
                        range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 13));
                        // Set chu Bold
                        range.Style.Font.Bold = true;
                        //Set mau chu
                        range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                        // Tự động xuống hàng khi text quá dài
                        range.Style.WrapText = true;
                    }

                    worksheet.Cells[6, 1].Value = "STT";
                    worksheet.Cells["A6:A8"].Merge = true;
                    worksheet.Cells[6, 2].Value = "THẨM PHÁN";
                    worksheet.Cells["B6:B8"].Merge = true;
                    worksheet.Cells[6, 3].Value = "Thụ lý";
                    worksheet.Cells["C6:E6"].Merge = true;
                    worksheet.Row(6).Height = 22;
                    worksheet.Row(7).Height = 27;
                    worksheet.Row(8).Height = 123;

                    worksheet.Cells[7, 3].Value = "Tồn từ năm trước";
                    worksheet.Cells["C7:C8"].Merge = true;
                    worksheet.Cells[7, 4].Value = "Thụ lý mới";
                    worksheet.Cells["D7:D8"].Merge = true;
                    worksheet.Cells[7, 5].Value = "Cộng";
                    worksheet.Cells["E7:E8"].Merge = true;
                    worksheet.Cells[6, 6].Value = "Đã giải quyết dứt điểm";
                    worksheet.Cells["F6:F8"].Merge = true;
                    worksheet.Cells[6, 7].Value = "Chưa giải quyết";
                    worksheet.Cells["G6:R6"].Merge = true;

                    worksheet.Cells[7, 7].Value = "Đã có hồ sơ";
                    worksheet.Cells["G7:G8"].Merge = true;
                    worksheet.Cells[7, 8].Value = "Chưa có hồ sơ";
                    worksheet.Cells["H7:H8"].Merge = true;
                    worksheet.Cells[7, 9].Value = "TTV đang nghiên cứu";
                    worksheet.Cells["I7:I8"].Merge = true;
                    worksheet.Cells[7, 10].Value = "Đang trình Lãnh đạo Vụ";
                    worksheet.Cells["J7:J8"].Merge = true;

                    worksheet.Cells[7, 11].Value = "Đã trình";
                    worksheet.Cells["K7:Q7"].Merge = true;

                    worksheet.Cells[8, 11].Value = "Đang trình Thẩm phán";
                    worksheet.Cells[8, 12].Value = "Yêu cầu xác minh/ báo cáo lại";
                    worksheet.Cells[8, 13].Value = "Dự thảo TLĐ";
                    worksheet.Cells[8, 14].Value = "Dự thảo KN";
                    worksheet.Cells[8, 15].Value = "Đang trình PCA/ Báo cáo Tổ TP/ Báo cáo CA";
                    worksheet.Cells[8, 16].Value = "Chờ lịch báo cáo HĐTP";
                    worksheet.Cells[8, 17].Value = "Cộng";

                    worksheet.Cells[7, 18].Value = "Tổng";
                    worksheet.Cells["R7:R8"].Merge = true;


                    worksheet.Column(1).Width = 8;  // STT
                    worksheet.Column(2).Width = 30; // 
                    worksheet.Column(3).Width = 8; // 
                    worksheet.Column(4).Width = 8; // 
                    worksheet.Column(5).Width = 8; // 
                    worksheet.Column(6).Width = 8; // 

                    int i, j;
                    //Viet Noi dung Bao cao
                    //-----------
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        i = 0;
                        foreach (DataRow row in tbl.Rows)
                        {
                            for (j = 0; j <= 17; j++)
                            {
                                worksheet.Cells[i + 9, j + 1].Value = row[j].ToString();
                                //row[j].ToString(): dữ liệu của bảng tbl lấy từ db
                                //worksheet.Cells[i + 7, j + 1].Value - tọa độ của file excel
                            }
                            i = i + 1;
                        }
                    }

                    // Lấy range vào tạo format cho range
                    using (var range = worksheet.Cells["A6:R" + tbl.Rows.Count + 7])
                    {
                        // Canh giữa cho các text
                        range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        // Set Font cho text  trong Range hiện tại
                        range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 12));

                        //Set mau chu
                        range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                        // Tự động xuống hàng khi text quá dài
                        range.Style.WrapText = true;
                    }
                    using (var range = worksheet.Cells["B7:B" + (tbl.Rows.Count + 8)])
                    {
                        range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                    }

                    // Lấy range vào tạo Border bang
                    using (var range = worksheet.Cells["A6:R" + (tbl.Rows.Count + 8)])//cRows
                    {
                        //Set border
                        range.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                        range.Style.Border.Top.Color.SetColor(System.Drawing.Color.Black);
                        range.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                        range.Style.Border.Left.Color.SetColor(System.Drawing.Color.Black);
                        range.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                        range.Style.Border.Right.Color.SetColor(System.Drawing.Color.Black);
                        range.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        range.Style.Border.Bottom.Color.SetColor(System.Drawing.Color.Black);
                    }
                    using (var range = worksheet.Cells["A6:R6"])
                    {
                        // Canh giữa cho các text
                        range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                        range.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                        // Set Font cho text  trong Range hiện tại
                        range.Style.Font.SetFromFont(new System.Drawing.Font("Times New Roman", 12));
                        // Set chu Bold
                        range.Style.Font.Bold = true;
                        //Set mau chu
                        range.Style.Font.Color.SetColor(System.Drawing.Color.Black);
                        // Tự động xuống hàng khi text quá dài
                        range.Style.WrapText = true;
                    }
                    using (var range = worksheet.Cells["C9:R" + (tbl.Rows.Count + 8)])//cRows
                    {

                        foreach (var cell in range)
                        {
                            if (cell.Value != null)
                            {
                                double val; // Khai báo biến trước để tránh lỗi "Invalid expression term"
                                if (double.TryParse(cell.Value.ToString(), out val))
                                {
                                    cell.Value = val;
                                }
                            }
                        }
                        range.Style.Numberformat.Format = "#,##0";
                    }
                    //----------
                    worksheet.Cells["A4:R4"].Style.Font.Italic = true;
                    worksheet.Cells["A7:R7"].Style.Font.Bold = true;
                    // Print options:
                    worksheet.PrinterSettings.PaperSize = ePaperSize.A4;
                    worksheet.PrinterSettings.Orientation = eOrientation.Landscape;
                    worksheet.PrinterSettings.HorizontalCentered = true;
                    worksheet.PrinterSettings.FitToPage = true;
                    worksheet.PrinterSettings.FitToWidth = 1;
                    worksheet.PrinterSettings.FitToHeight = 0;
                }

                if (pack != null)
                {
                    // Tên file mà người dùng sẽ thấy khi tải xuống
                    string fileName = String.Format("Tong_TLGQ_{0}.xlsx", DateTime.Now.ToString("ddMMyyyy_HHmmss"));
                    // Đặt các header cho phản hồi HTTP để trình duyệt tải xuống file
                    Response.Clear();
                    Response.BufferOutput = true; // Thường nên để true khi gửi toàn bộ nội dung trong MemoryStream
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment; filename=" + fileName);
                    // Ghi nội dung của ExcelPackage vào MemoryStream
                    using (MemoryStream ms = new MemoryStream())
                    {
                        pack.SaveAs(ms); // Lưu ExcelPackage vào MemoryStream
                        ms.Position = 0; // Đặt con trỏ về đầu MemoryStream
                        // Gửi nội dung MemoryStream về client
                        ms.CopyTo(Response.OutputStream);
                    }
                    pack.Dispose(); // Giải phóng tài nguyên của ExcelPackage sau khi đã lưu
                    Response.End(); // Kết thúc phản hồi HTTP
                }

            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_TUAN_VGDKT_2()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_TUAN_VGDKT_2_PRINT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);
                //-----------------------------------------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string fileName = "";
                    string saveAs = pathTemplateWord + "rptBaoCaoTuan_" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";


                    string fileNameSave = "rptBaoCaoTuan_" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";

                    Document doc = new Document();
                    fileName = pathTemplateWord + "rptBaocaotuan_vugdkt2.doc";

                    foreach (DataRow item in tbl.Rows)
                    {
                        string strNgay = "", strThang = "", strNam = "";

                        Document baoCao = new Document(fileName);

                        DateTime dNgayCV = (String.IsNullOrEmpty(txtThuly_Den.Text)) ? DateTime.MinValue : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = String.Format("{0:00}", dNgayCV.Day);
                            strThang = String.Format("{0:00}", dNgayCV.Month);
                            strNam = dNgayCV.Year.ToString();
                        }

                        baoCao.MailMerge.Execute(new[] { "NGAY" }, new[] { strNgay });
                        baoCao.MailMerge.Execute(new[] { "THANG" }, new[] { strThang });
                        baoCao.MailMerge.Execute(new[] { "NAM" }, new[] { strNam });


                        baoCao.MailMerge.Execute(new[] { "TUNGAY" }, new[] { txtThuly_Tu.Text });
                        baoCao.MailMerge.Execute(new[] { "DENNGAY" }, new[] { txtThuly_Den.Text });


                        baoCao.MailMerge.Execute(new[] { "V1_PHAI_XX" }, new[] { item["V1_PHAI_XX"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_KN_TANDTC" }, new[] { item["V1_KN_TANDTC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_KN_TANDCC" }, new[] { item["V1_KN_TANDCC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_KN_VKSNDTC" }, new[] { item["V1_KN_VKSNDTC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_TM_HDTP" }, new[] { item["V1_TM_HDTP"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_CONLAI" }, new[] { item["V1_CONLAI"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_CONLAI_CA" }, new[] { item["V1_CONLAI_CA"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_CONLAI_VKS" }, new[] { item["V1_CONLAI_VKS"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "V2_PHAIGQ" }, new[] { item["V2_PHAIGQ"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_DA_GQ" }, new[] { item["V2_DA_GQ"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_GQ_TLD" }, new[] { item["V2_GQ_TLD"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_GQ_KN" }, new[] { item["V2_GQ_KN"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_GQ_KHAC" }, new[] { item["V2_GQ_KHAC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_CONLAI" }, new[] { item["V2_CONLAI"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_DANG_TRINH" }, new[] { item["V2_DANG_TRINH"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_CHUACO_TT" }, new[] { item["V2_CHUACO_TT"].ToString() });                     
                        baoCao.MailMerge.Execute(new[] { "V2_DT_EXT" }, new[] { item["V2_DT_EXT"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "V4_TT_PCA_NVTIEN" }, new[] { item["V4_TT_PCA_NVTIEN"].ToString() });
                      
                        baoCao.MailMerge.Execute(new[] { "V4_NVTIEN_DANG_TRINH" }, new[] { item["V4_NVTIEN_DANG_TRINH"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V4_NVTIEN_DA_DUYET" }, new[] { item["V4_NVTIEN_DA_DUYET"].ToString() });
                        
                        baoCao.MailMerge.Execute(new[] { "V4_T_TOTP" }, new[] { item["V4_T_TOTP"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "V42_TT_TP_TATC" }, new[] { item["V42_TT_TP_TATC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V42_TT_TP_TATC_EXT" }, new[] { item["V42_TT_TP_TATC_EXT"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "V43_T_VT" }, new[] { item["V43_T_VT"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V43_T_PVT" }, new[] { item["V43_T_PVT"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V43_T_TPB3" }, new[] { item["V43_T_TPB3"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V43_YK_TPTC" }, new[] { item["V43_YK_TPTC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V43_TTPB3_DOHAIYEN" }, new[] { item["V43_TTPB3_DOHAIYEN"].ToString() });


                        baoCao.MailMerge.Execute(new[] { "V43_T_VT_EXT" }, new[] { item["V43_T_VT_EXT"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V43_T_PVT_EXT" }, new[] { item["V43_T_PVT_EXT"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V43_T_TPB3_EXT" }, new[] { item["V43_T_TPB3_EXT"].ToString() });
                       
                        baoCao.MailMerge.Execute(new[] { "V43_YK_TPTC_EXT" }, new[] { item["V43_YK_TPTC_EXT"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V43_TTPB3_DOHAIYEN_EXT" }, new[] { item["V43_TTPB3_DOHAIYEN_EXT"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "V44_DA_GQ_TUAN" }, new[] { item["V44_DA_GQ_TUAN"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V44_DA_GQ_TUAN_EXT" }, new[] { item["V44_DA_GQ_TUAN_EXT"].ToString() });

                        doc.AppendDocument(baoCao, ImportFormatMode.KeepSourceFormatting);

                    }

                    doc.Sections[0].Range.Delete();
                    doc.Save(saveAs);
                    ExportData(fileNameSave, (string)saveAs);

                }
                tbl = null;


            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        private void LoadReport_THANG_VGDKT_2()
        {
            try
            {
                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                decimal vLanhdaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
                GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
                DataTable tbl = null;

                tbl = oBL.BC_THANG_VGDKT_2_PRINT(drop_cbtk.SelectedValue, Drop_ld_phong.SelectedValue, vToaAnID, vPhongbanID, vNgayThulyTu, vNgayThulyDen, 0);

                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string fileName = "";
                    string saveAs = pathTemplateWord + "rptBaoCaoThang_" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";


                    string fileNameSave = "rptBaoCaoThang_" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";

                    Document doc = new Document();
                    fileName = pathTemplateWord + "rptBaocaoThang_vugdkt2.doc";

                    foreach (DataRow item in tbl.Rows)
                    {
                        string strNgay = "", strThang = "", strNam = "";

                        Document baoCao = new Document(fileName);

                        DateTime dNgayCV = (String.IsNullOrEmpty(txtThuly_Den.Text)) ? DateTime.MinValue : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = String.Format("{0:00}", dNgayCV.Day);
                            strThang = String.Format("{0:00}", dNgayCV.Month);
                            strNam = dNgayCV.Year.ToString();
                        }

                        baoCao.MailMerge.Execute(new[] { "NGAY" }, new[] { strNgay });
                        baoCao.MailMerge.Execute(new[] { "THANG" }, new[] { strThang });
                        baoCao.MailMerge.Execute(new[] { "NAM" }, new[] { strNam });


                        baoCao.MailMerge.Execute(new[] { "TUNGAY" }, new[] { txtThuly_Tu.Text });
                        baoCao.MailMerge.Execute(new[] { "DENNGAY" }, new[] { txtThuly_Den.Text });


                        baoCao.MailMerge.Execute(new[] { "V1_TM_HDTP_THANGHIENTAI" }, new[] { item["V1_TM_HDTP_THANGHIENTAI"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_THANGHIENTAI" }, new[] { strThang + "/" + strNam });
                        baoCao.MailMerge.Execute(new[] { "V1_PHAI_XX" }, new[] { item["V1_PHAI_XX"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_KN_TANDTC" }, new[] { item["V1_KN_TANDTC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_KN_TANDCC" }, new[] { item["V1_KN_TANDCC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_KN_VKSNDTC" }, new[] { item["V1_KN_VKSNDTC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_TM_HDTP" }, new[] { item["V1_TM_HDTP"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_CONLAI" }, new[] { item["V1_CONLAI"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_CONLAI_CA" }, new[] { item["V1_CONLAI_CA"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V1_CONLAI_VKS" }, new[] { item["V1_CONLAI_VKS"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "V2_PHAIGQ" }, new[] { item["V2_PHAIGQ"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_DA_GQ" }, new[] { item["V2_DA_GQ"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_GQ_TLD" }, new[] { item["V2_GQ_TLD"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_GQ_KN" }, new[] { item["V2_GQ_KN"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_GQ_KHAC" }, new[] { item["V2_GQ_KHAC"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_CONLAI" }, new[] { item["V2_CONLAI"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_DANG_TRINH" }, new[] { item["V2_DANG_TRINH"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_CHUACO_TT" }, new[] { item["V2_CHUACO_TT"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V2_DT_EXT" }, new[] { item["V2_DT_EXT"].ToString() });

                        double daGQ = Convert.ToDouble(item["V2_DA_GQ"]);
                        double dangTrinh = Convert.ToDouble(item["V2_DANG_TRINH"]);
                        double phaiGQ = Convert.ToDouble(item["V2_PHAIGQ"]);

                        double tyLe = phaiGQ == 0 ? 0 : (daGQ + dangTrinh) / phaiGQ * 100;

                        string V2_TYLE_GQ = tyLe.ToString("0.##") + "%";
                        baoCao.MailMerge.Execute(new[] { "V2_TYLE_GQ" }, new[] { V2_TYLE_GQ });

                        baoCao.MailMerge.Execute(new[] { "V41_TP_TATC_EXT_TONG" }, new[] { item["V41_TP_TATC_EXT_TONG"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V41_TT_TP_TATC_EXT" }, new[] { item["V41_TT_TP_TATC_EXT"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V41_TT_TP_TATC_EXT_DANHSACH" }, new[] { item["V41_TT_TP_TATC_EXT_DANHSACH"].ToString() });

                        baoCao.MailMerge.Execute(new[] { "V42_TT_PCA_NVTIEN" }, new[] { item["V42_TT_PCA_NVTIEN"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V42_NVTIEN_DANG_TRINH" }, new[] { item["V42_NVTIEN_DANG_TRINH"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V42_NVTIEN_DA_DUYET" }, new[] { item["V42_NVTIEN_DA_DUYET"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V42_T_TOTP" }, new[] { item["V42_T_TOTP"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V42_TOTHAMPHAN_DALENLICH" }, new[] { item["V42_TOTHAMPHAN_DALENLICH"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V42_TOTHAMPHAN_DALENLICH_NGAY" }, new[] { item["V42_TOTHAMPHAN_DALENLICH_NGAY"].ToString() });
                        
                        baoCao.MailMerge.Execute(new[] { "V43_DA_GQ_TUAN" }, new[] { item["V43_DA_GQ_TUAN"].ToString() });
                        baoCao.MailMerge.Execute(new[] { "V43_DA_GQ_TUAN_EXT" }, new[] { item["V43_DA_GQ_TUAN_EXT"].ToString() });
                        doc.AppendDocument(baoCao, ImportFormatMode.KeepSourceFormatting);

                    }

                    doc.Sections[0].Range.Delete();
                    doc.Save(saveAs);
                    ExportData(fileNameSave, (string)saveAs);

                }
                tbl = null;


            }
            catch (Exception ex)
            {
                lblmsg.Text = ex.Message;
            }
        }
        public static string GetDauNamCongTac(string StrTuNgay)
        {
            var vTuNgay = DateTime.ParseExact(StrTuNgay, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            int thang = vTuNgay.Month;
            int nam = vTuNgay.Year;

            DateTime dauNamCongTac;
            if (thang < 10)
            {
                dauNamCongTac = new DateTime(nam - 1, 10, 1);
            }
            else
            {
                dauNamCongTac = new DateTime(nam, 10, 1);
            }
            var value = dauNamCongTac.ToString("dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture);
            return value;
        }
    }
}