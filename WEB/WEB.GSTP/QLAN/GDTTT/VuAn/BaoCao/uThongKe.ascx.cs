using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using System.Globalization;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using System.Data;
using BL.GSTP.GDTTT;
namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao
{
    public partial class uThongKe : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
        GDTTT_VUAN_BL oVABL = new GDTTT_VUAN_BL();
        public string strMaCT = "";
        public string CurrFullName = "";
        public int ShowCell = 1, ColSpan = 18;
        public Decimal ChucVuPCA = 0;
        public Decimal ChucDanh_TPTATC = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            string strMaCT = Session["MaChuongTrinh"] + "";//anhvh add 14/10/2020 chỉ cho hiện form login ghi nhấn vào trang chủ
            if (strMaCT != "0" && strMaCT != "")
            {
                return;
            }
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btnXemBC_TP);
            scriptManager.RegisterPostBackControl(this.btnXemBC_Vu);
            try
            {
                CurrFullName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
                string strMaHT = Session["MaHeThong"] + "";

                try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }
                try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }

                if (strMaHT == "21")//GĐT,TT
                {
                    if (!IsPostBack)
                    {
                        string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                        decimal LanhdaoVuID = 0;
                        decimal ThamtravienID = 0;
                        if (strCanBoID != "" && strCanBoID != "0")
                        {
                            decimal CanboID = Convert.ToDecimal(strCanBoID);
                            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
                            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                            {
                                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                                if (oCD.MA == "TPTATC" || oCD.MA == "TPCC")
                                {
                                    Load_Data_Years();
                                    LoadDropThamphan();
                                    //------------
                                    pn.Visible = true;
                                    pnVuGDKT.Visible = false;
                                    pnThamphan.Visible = true;

                                    LoadTKThamphan(CanboID);
                                    //------------------------
                                    Set_title_thamphan();
                                    //----
                                    pnQuocHoi_ThoiHieu.Visible = false; pnQuocHoi_ThoiHieu_TP.Visible = true;
                                    //Manh tam dong để kiem tra hieu xuat phan mem
                                    //LoadThongkeQuocHoi_ThoiHieu_ByThamPhan(CanboID);
                                    hi_ThamPhan_ID.Value = Convert.ToString(CanboID);
                                    //----------------------------------
                                }
                            }

                            DM_CANBO_BL objCB = new DM_CANBO_BL();
                            bool isLanhdao = false;
                            if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                            {
                                DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                                if (oCV.MA == ENUM_CHUCVU.CHUCVU_VT)//Vụ trưởng
                                {
                                    isLanhdao = true;
                                    LanhdaoVuID = 0;
                                    ThamtravienID = 0;
                                }
                                else if (oCV.MA == ENUM_CHUCVU.CHUCVU_PVT)//Phó Vụ trưởng
                                {
                                    isLanhdao = true;
                                    LanhdaoVuID = oCB.ID;
                                    ThamtravienID = 0;
                                }
                                else if (oCV.MA == "041") //truong phong manhnd 4/9/2021
                                {
                                    isLanhdao = true;
                                    LanhdaoVuID = 0;
                                    ThamtravienID = 0;
                                }
                            }
                            if (isLanhdao == false)
                            {
                                ThamtravienID = CanboID;
                                ShowCell = 0;
                                ColSpan = 17;
                                cellChung_NoPCTTV.Visible = cellQH_NoPCTTV.Visible = cellTH_NoPCTTV.Visible = false;
                                cellChung_NoPCTTV_Column.Visible = cellChung_NoPCTTV_Column_QH.Visible= cellChung_NoPCTTV_Column_TH.Visible= false;
                                lttTKChung_PCTTV.Text = lttTKQH_PCTTV.Text = lttTKTH_PCTTV.Text = "Tổng số vụ việc được phân công";
                            }
                        }
                        // rptLanhdaoVu.Visible = false;
                        string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                        decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
                        DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                        if (obj.ISGIAIQUYETDON == 1)//Các Vụ Giám đốc
                        {
                            //--------------
                            decimal IDNhom = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
                            decimal ID_CHUONGTRINH = 101;//truyền mã menu chương trình Vụ Giám đốc, kiểm tra
                            QT_MENU_BL qtBL = new QT_MENU_BL();
                            DataTable lst_home = qtBL.Qt_Nhom_Home_Get_List(ID_CHUONGTRINH, IDNhom);
                            if (lst_home != null && lst_home.Rows.Count > 0)
                            {
                                if (lst_home.Rows[0]["XEM"] + "" == "1")
                                {
                                    pn.Visible = true;
                                    //duoc quyen xem thi load các thong tin thong ke

                                    LoadThongke(obj, LanhdaoVuID, ThamtravienID);
                                    LoadThongkeQuocHoi(obj, LanhdaoVuID, ThamtravienID);
                                    LoadThongkeThoiHieu(obj, LanhdaoVuID, ThamtravienID);
                                }
                                else if (lst_home.Rows[0]["XEM"] + "" == "0")
                                {
                                    pn.Visible = false;
                                }
                            }
                           
                            //----anhvh add
                            hi_LanhdaoVuID.Value = Convert.ToString(LanhdaoVuID);
                            hi_ThamtravienID.Value = Convert.ToString(ThamtravienID);
                            //------------
                           
                        }
                    }
                }
                else
                { pn.Visible = false; }
            }
            catch (Exception ex) { }
        }
        public void Set_title_thamphan()
        {
            String chucdanh = "Thẩm phán ";
            Decimal ChucVuID = 0;
            string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
            decimal CanboID = Convert.ToDecimal(strCanBoID);
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            ChucVuID = String.IsNullOrEmpty(oCB.CHUCVUID + "") ? 0 : (Decimal)oCB.CHUCVUID;
            DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
            oCD = dt.DM_DATAITEM.Where(x => x.ID == ChucVuID).FirstOrDefault();
            if (ChucVuID > 0)
            {
                if (oCD.MA == "PCA")
                {
                    //CanboID = LoadAll = 0;
                    chucdanh = "Phó Chánh án ";
                }
                else if (oCD.MA == "CA")
                {
                    //CanboID = 0;
                    //LoadAll = 1;
                    chucdanh = "Chánh án ";
                }
            }
            lstTenThamphan.Text = chucdanh.ToUpper() + oCB.HOTEN.ToUpper() + "";
        }
        protected void btnXemBC_TP_Click(object sender, EventArgs e)
        {
            string strCanBoID = hi_ThamPhan_ID.Value;//Session[ENUM_SESSION.SESSION_CANBOID] + "";
            decimal vThamphanID = 0;
            if (strCanBoID != "" && strCanBoID != "0")
            {
                vThamphanID = Convert.ToDecimal(strCanBoID);
            }
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            //-------------------------------------
            Literal Table_Str_Totals = new Literal();
            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = oBL.BAOCAO_TK_TP(Session[ENUM_SESSION.SESSION_CANBOID] + "",vToaAnID, vThamphanID, null, DateTime.Now,ddl_Load_year.SelectedValue);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Thong_Ke_BC.doc"); Response.Cache.SetCacheability(HttpCacheability.NoCache);
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
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
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
        protected void btnXemBC_Vu_Click(object sender, EventArgs e)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            //------------
            Literal Table_Str_Totals = new Literal();
            GDTTT_BAOCAO_BL oBL = new GDTTT_BAOCAO_BL();
            DataTable tbl = oBL.BAOCAO_TK_VU(vToaAnID, PBID, Convert.ToInt32(hi_LanhdaoVuID.Value), Convert.ToInt32(hi_ThamtravienID.Value));
            DataRow row = tbl.NewRow();
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //-------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Thong_Ke_BC.doc");
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
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:.75in .5in .75in .5in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.7in 0.5in 0.5in 0.5in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");
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
        void LoadDropThamphan()
        {
            Decimal ChucVuPCA = 0;
            Decimal ChucVuCA = 0;
            Decimal ChucDanh_TPTATC = 0;
            Decimal ChucDanh_TPCC = 0;
            try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucVuCA = dt.DM_DATAITEM.Where(x => x.MA == "CA").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucDanh_TPCC = dt.DM_DATAITEM.Where(x => x.MA == "TPCC").FirstOrDefault().ID; } catch (Exception ex) { }

            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            //Load Thẩm phán
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Boolean IsLoadAll = false;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCVUID != null && oCB.CHUCVUID == ChucVuPCA || oCB.CHUCVUID == ChucVuCA)
            {
                if (oCB.CHUCDANHID == ChucDanh_TPTATC || oCB.CHUCDANHID == ChucDanh_TPCC)
                {
                    //ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
                    //----------anhvh add 30/10/2019
                    DataTable tbl = oGDTBL.GDTTT_Tp_Duoc_Phutrach(Session[ENUM_SESSION.SESSION_DONVIID]+"",Convert.ToInt32(oCB.ID));
                    ddlThamphan.DataSource = tbl;
                    ddlThamphan.DataTextField = "HOTEN";
                    ddlThamphan.DataValueField = "ID";
                    ddlThamphan.DataBind();
                }
                else
                    IsLoadAll = true;
            }
            else if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                if (oCB.CHUCDANHID == ChucDanh_TPTATC)
                {
                    ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
                }
                else
                    IsLoadAll = true;
            }
            else
                IsLoadAll = true;
            if (IsLoadAll)
            {
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
            }
            ddlThamphan.SelectedValue = oCB.ID.ToString();
            hi_ThamPhan_ID.Value = ddlThamphan.SelectedValue;
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            hi_ThamPhan_ID.Value = ddlThamphan.SelectedValue;
            Decimal CanboID = Convert.ToDecimal(hi_ThamPhan_ID.Value);
            LoadTKThamphan(CanboID);
            LoadThongkeQuocHoi_ThoiHieu_ByThamPhan(CanboID);
            Set_title_thamphan();
        }
        private void LoadTKThamphan(decimal vThamphanID)
        {
            GDTTT_APP_BL oVABL = new GDTTT_APP_BL();
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //DataTable tbl = oVABL.THONGKE_THEO_THAMPHAN(vToaAnID, vThamphanID, null, DateTime.Now,0,ddl_Load_year.SelectedValue);
            DataTable tbl = oVABL.THONGKE_THEO_THAMPHAN_GET(Session[ENUM_SESSION.SESSION_CANBOID] + "", vToaAnID, vThamphanID, null, DateTime.Now, 0, ddl_Load_year.SelectedValue);
            rptThamPhan.DataSource = tbl;
            rptThamPhan.DataBind();
        }
        private void LoadThongke(DM_PHONGBAN objPB, decimal LanhdaoVuID, decimal ThamtravienID)
        {
            GDTTT_APP_BL oVABL = new GDTTT_APP_BL();
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable tbl = oVABL.THONGKE_TONGHOP_S(vToaAnID, objPB.ID, LanhdaoVuID, ThamtravienID,0);
            rptThongke.DataSource = tbl;
            rptThongke.DataBind();
            LoadTKChung(vToaAnID, objPB.ID, 0, LanhdaoVuID, ThamtravienID);
        }
        private void LoadThongkeQuocHoi(DM_PHONGBAN objPB, decimal LanhdaoVuID, decimal ThamtravienID)
        {
            GDTTT_APP_BL oVABL = new GDTTT_APP_BL();
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable tbl = oVABL.THONGKE_TONGHOP_S(vToaAnID, objPB.ID, LanhdaoVuID, ThamtravienID, 1);
            rptAnQuocHoi.DataSource = tbl;
            rptAnQuocHoi.DataBind();
        }
        private void LoadThongkeThoiHieu(DM_PHONGBAN objPB, decimal LanhdaoVuID, decimal ThamtravienID)
        {
            GDTTT_APP_BL oVABL = new GDTTT_APP_BL();
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable tbl = oVABL.THONGKE_TONGHOP_S(vToaAnID, objPB.ID, LanhdaoVuID, ThamtravienID, 3);
            rptAnThoiHieu.DataSource = tbl;
            rptAnThoiHieu.DataBind();
        }
        private void LoadTKChung(decimal ToaAnID, decimal PBID, decimal LoaiAn, decimal LanhdaoVuID, decimal ThamtravienID)
        {
            GDTTT_APP_BL oVABL = new GDTTT_APP_BL();
            DataTable objsl = oVABL.THONGKE_CHUNG_S(ToaAnID, PBID, LanhdaoVuID, ThamtravienID, 0);
            lbtTongSo.Text = objsl.Rows[0]["TONG_ALL"] + "";
        }
        void ClearSession_TKThamPhan()
        {
            Session[SS_TK.ISHOME] = "1";
            Session[SS_TK.ANQUOCHOI_THOIHIEU] = "0";
            Session[SS_TK.ANTHOIHIEU] = null;
            Session[SS_TK.THAMTRAVIEN] = 0;
            Session[SS_TK.LANHDAOPHUTRACH] = 0;
            Session[SS_TK.TOAANXX] = "0";
            Session[SS_TK.SOBAQD] = "";
            Session[SS_TK.NGAYBAQD] = "";
            Session[SS_TK.NGUYENDON] = "";
            Session[SS_TK.BIDON] = "";
            Session[SS_TK.LOAIAN] = 0;
            Session[SS_TK.THAMPHAN] = 0;
            Session[SS_TK.QHPKLT] = "0";
            Session[SS_TK.QHPLDN] = "0";
            Session[SS_TK.TRALOIDON] = "2";
            Session[SS_TK.NGUOIGUI] = "";
            Session[SS_TK.COQUANCHUYENDON] = "";
            Session[SS_TK.LOAICV] = "0";
            Session[SS_TK.THULY_TU] = "";
            Session[SS_TK.THULY_DEN] = "";
            Session[SS_TK.SOTHULY] = "";

            Session[SS_TK.TRANGTHAITHULY] = "0";
            Session[SS_TK.MUONHOSO] = "2";

            Session[SS_TK.KETQUATHULY] = "3";
            Session[SS_TK.KETQUAXETXU] = "3";
            Session[SS_TK.ARRSELECTID] = "";

            Session[SS_TK.TRANGTHAITOTRINH] = "2";
            Session[SS_TK.XXGDT_HDTP] = "0";
        }
        private void LoadThongkeQuocHoi_ThoiHieu_ByThamPhan(decimal ThamPhanID)
        {
            GDTTT_APP_BL oVABL = new GDTTT_APP_BL();
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable tbl = new DataTable();
            //-----------
            //tbl = oVABL.THONGKE_THEO_THAMPHAN(vToaAnID, ThamPhanID, null, DateTime.Now, 1,ddl_Load_year.SelectedValue);
             tbl = oVABL.THONGKE_THEO_THAMPHAN_GET(Session[ENUM_SESSION.SESSION_CANBOID] + "",vToaAnID, ThamPhanID, null, DateTime.Now, 1, ddl_Load_year.SelectedValue);
            rptAnQuocHoi_tp.DataSource = tbl;
            rptAnQuocHoi_tp.DataBind();
            /////////////////
            //tbl = oVABL.THONGKE_THEO_THAMPHAN(vToaAnID, ThamPhanID, null, DateTime.Now, 3, ddl_Load_year.SelectedValue);
            tbl = oVABL.THONGKE_THEO_THAMPHAN_GET(Session[ENUM_SESSION.SESSION_CANBOID] + "",vToaAnID, ThamPhanID, null, DateTime.Now, 3, ddl_Load_year.SelectedValue);
            rptAnThoiHieu_tp.DataSource = tbl;
            rptAnThoiHieu_tp.DataBind();
        }
        //---------------------------------
        protected void rptThongke_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";

            decimal LanhdaoVuID = 0;
            decimal ThamtravienID = 0;
            if (strCanBoID != "" && strCanBoID != "0")
            {
                decimal CanboID = Convert.ToDecimal(strCanBoID);
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
                DM_CANBO_BL objCB = new DM_CANBO_BL();
                bool isLanhdao = false;
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCV.MA == ENUM_CHUCVU.CHUCVU_VT || oCV.MA=="041")//Vụ trưởng
                    {
                        isLanhdao = true;
                        LanhdaoVuID = 0;
                        ThamtravienID = 0;
                    }
                    else if (oCV.MA == ENUM_CHUCVU.CHUCVU_PVT || oCV.MA == "042")//Phó Vụ trưởng
                    {
                        isLanhdao = true;
                        LanhdaoVuID = oCB.ID;
                        ThamtravienID = 0;
                    }
                }
                if (isLanhdao == false)
                {
                    ThamtravienID = CanboID;
                }
            }
            string strLoaiAn = e.CommandArgument.ToString();
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;
            string strTrangThai = e.CommandName;
            Session[SS_TK.ANQUOCHOI_THOIHIEU] = "0";
            Session[SS_TK.ANTHOIHIEU] = null;
            Session[SS_TK.ISHOME] = "1";
            Session[SS_TK.THAMTRAVIEN] = ThamtravienID;
            Session[SS_TK.LANHDAOPHUTRACH] = LanhdaoVuID;

            Session[SS_TK.TOAANXX] = "0";
            Session[SS_TK.SOBAQD] = "";
            Session[SS_TK.NGAYBAQD] = "";
            Session[SS_TK.NGUYENDON] = "";
            Session[SS_TK.BIDON] = "";
            Session[SS_TK.LOAIAN] = strLoaiAn;

            Session[SS_TK.THAMPHAN] = "0";
            Session[SS_TK.QHPKLT] = "0";
            Session[SS_TK.QHPLDN] = "0";
            Session[SS_TK.TRALOIDON] = "2";
            Session[SS_TK.NGUOIGUI] = "";
            Session[SS_TK.COQUANCHUYENDON] = "";
            Session[SS_TK.LOAICV] = "0";
            Session[SS_TK.THULY_TU] = "";
            Session[SS_TK.THULY_DEN] = "";
            Session[SS_TK.SOTHULY] = "";
            Session[SS_TK.MUONHOSO] = "-1";
            Session[SS_TK.TRANGTHAITHULY] = "0";
            //-----------------///////////////////
            Session[SS_TK.BUOCTT] = "0";
            Session[SS_TK.HOAN_THIHAHAN] = "2";
            Session[SS_TK.TRANGTHAITOTRINH] = "2";
            //---------------------
            Session[SS_TK.KETQUATHULY] = "4";
            Session[SS_TK.KETQUAXETXU] = "0";
            //-----------------
            Session[SS_TK.ARRSELECTID] = "";
            Session[SS_TK.XXGDT_HDTP] = "0";
            Session[SS_TK.TRANGTHAIYKIENTT] = 2;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    Session[SS_TK.TRANGTHAITHULY] = "1";
                    Session[SS_TK.KETQUATHULY] = "4";
                    break;
                case "COLUMN_2":
                    Session[SS_TK.TRANGTHAITHULY] = "2";
                    Session[SS_TK.KETQUATHULY] = "4";
                    break;
                case "COLUMN_3":
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    break;
                case "COLUMN_4":
                    Session[SS_TK.MUONHOSO] = "0";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    break;
                case "COLUMN_5":
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "3";
                    Session[SS_TK.TRANGTHAITOTRINH] = "0";
                    break;
                case "COLUMN_6":
                    Session[SS_TK.TRANGTHAITHULY] = "4";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_7":
                    Session[SS_TK.TRANGTHAITHULY] = "5";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_8":
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.TRANGTHAIYKIENTT] = 0;
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_9":
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.TRANGTHAIYKIENTT] = 1;
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_10":
                    Session[SS_TK.TRANGTHAITHULY] = "10";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_11":
                    Session[SS_TK.TRANGTHAITHULY] = "7";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_12":
                    Session[SS_TK.TRANGTHAITHULY] = "9";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_13":
                    Session[SS_TK.TRANGTHAITHULY] = "8";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_14":
                    Session[SS_TK.TRANGTHAITHULY] = "17";
                    break;
                case "COLUMN_15":
                    Session[SS_TK.TRANGTHAITHULY] = "11";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_16":
                    Session[SS_TK.TRANGTHAITHULY] = "12";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_17":
                    Session[SS_TK.HOAN_THIHAHAN] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    break;
                default:
                   // Session[SS_TK.TRANGTHAITHULY] = strTrangThai;
                    Session[SS_TK.TRANGTHAIYKIENTT] = 2;
                    break;
            }
            //---------------------------------------
            Response.Redirect("QLAN/GDTTT/VuAn/Danhsach.aspx");
        }
        protected void rptAnQuocHoi_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";

            decimal LanhdaoVuID = 0;
            decimal ThamtravienID = 0;
            if (strCanBoID != "" && strCanBoID != "0")
            {
                decimal CanboID = Convert.ToDecimal(strCanBoID);
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
                DM_CANBO_BL objCB = new DM_CANBO_BL();
                bool isLanhdao = false;
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCV.MA == ENUM_CHUCVU.CHUCVU_VT)//Vụ trưởng
                    {
                        isLanhdao = true;
                        LanhdaoVuID = 0;
                        ThamtravienID = 0;
                    }
                    else if (oCV.MA == ENUM_CHUCVU.CHUCVU_PVT)//Phó Vụ trưởng
                    {
                        isLanhdao = true;
                        LanhdaoVuID = oCB.ID;
                        ThamtravienID = 0;
                    }
                }
                if (isLanhdao == false)
                {
                    ThamtravienID = CanboID;
                }
            }
            string strLoaiAn = e.CommandArgument.ToString();
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;
            string strTrangThai = e.CommandName;
            Session[SS_TK.ISHOME] = "1";
            Session[SS_TK.ANQUOCHOI_THOIHIEU] = "1";
            Session[SS_TK.ANTHOIHIEU] = null;
            Session[SS_TK.THAMTRAVIEN] = ThamtravienID;
            Session[SS_TK.LANHDAOPHUTRACH] = LanhdaoVuID;

            Session[SS_TK.TOAANXX] = "0";
            Session[SS_TK.SOBAQD] = "";
            Session[SS_TK.NGAYBAQD] = "";
            Session[SS_TK.NGUYENDON] = "";
            Session[SS_TK.BIDON] = "";
            Session[SS_TK.LOAIAN] = strLoaiAn;

            Session[SS_TK.THAMPHAN] = "0";
            Session[SS_TK.QHPKLT] = "0";
            Session[SS_TK.QHPLDN] = "0";
            Session[SS_TK.TRALOIDON] = "2";
            Session[SS_TK.NGUOIGUI] = "";
            Session[SS_TK.COQUANCHUYENDON] = "";
            Session[SS_TK.LOAICV] = "0";
            Session[SS_TK.THULY_TU] = "";
            Session[SS_TK.THULY_DEN] = "";
            Session[SS_TK.SOTHULY] = "";
            Session[SS_TK.MUONHOSO] = "-1";
            Session[SS_TK.TRANGTHAITHULY] = "0";
            //-----------------///////////////////
            Session[SS_TK.BUOCTT] = "0";
            Session[SS_TK.HOAN_THIHAHAN] = "2";
            Session[SS_TK.TRANGTHAITOTRINH] = "2";
            //---------------------
            Session[SS_TK.KETQUATHULY] = "4";
            Session[SS_TK.KETQUAXETXU] = "0";
            //-----------------
            Session[SS_TK.ARRSELECTID] = "";
            Session[SS_TK.XXGDT_HDTP] = "0";
            Session[SS_TK.TRANGTHAIYKIENTT] = 2;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    Session[SS_TK.TRANGTHAITHULY] = "1";
                    Session[SS_TK.KETQUATHULY] = "4";
                    break;
                case "COLUMN_2":
                    Session[SS_TK.TRANGTHAITHULY] = "2";
                    Session[SS_TK.KETQUATHULY] = "4";
                    break;
                case "COLUMN_3":
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    break;
                case "COLUMN_4":
                    Session[SS_TK.MUONHOSO] = "0";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    break;
                case "COLUMN_5":
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "3";
                    Session[SS_TK.TRANGTHAITOTRINH] = "0";
                    break;
                case "COLUMN_6":
                    Session[SS_TK.TRANGTHAITHULY] = "4";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_7":
                    Session[SS_TK.TRANGTHAITHULY] = "5";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_8":
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.TRANGTHAIYKIENTT] = 0;
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_9":
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.TRANGTHAIYKIENTT] = 1;
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_10":
                    Session[SS_TK.TRANGTHAITHULY] = "10";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_11":
                    Session[SS_TK.TRANGTHAITHULY] = "7";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_12":
                    Session[SS_TK.TRANGTHAITHULY] = "9";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_13":
                    Session[SS_TK.TRANGTHAITHULY] = "8";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_14":
                    Session[SS_TK.TRANGTHAITHULY] = "17";
                    break;
                case "COLUMN_15":
                    Session[SS_TK.TRANGTHAITHULY] = "11";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_16":
                    Session[SS_TK.TRANGTHAITHULY] = "12";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_17":
                    Session[SS_TK.HOAN_THIHAHAN] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    break;
                default:
                    // Session[SS_TK.TRANGTHAITHULY] = strTrangThai;
                    Session[SS_TK.TRANGTHAIYKIENTT] = 2;
                    break;
            }
            Response.Redirect("QLAN/GDTTT/VuAn/Danhsach.aspx");
        }
        protected void rptAnThoiHieu_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";

            decimal LanhdaoVuID = 0;
            decimal ThamtravienID = 0;
            if (strCanBoID != "" && strCanBoID != "0")
            {
                decimal CanboID = Convert.ToDecimal(strCanBoID);
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
                DM_CANBO_BL objCB = new DM_CANBO_BL();
                bool isLanhdao = false;
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCV.MA == ENUM_CHUCVU.CHUCVU_VT)//Vụ trưởng
                    {
                        isLanhdao = true;
                        LanhdaoVuID = 0;
                        ThamtravienID = 0;
                    }
                    else if (oCV.MA == ENUM_CHUCVU.CHUCVU_PVT)//Phó Vụ trưởng
                    {
                        isLanhdao = true;
                        LanhdaoVuID = oCB.ID;
                        ThamtravienID = 0;
                    }
                }
                if (isLanhdao == false)
                {
                    ThamtravienID = CanboID;
                }
            }
            string strLoaiAn = e.CommandArgument.ToString();
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;
            string strTrangThai = e.CommandName;
            Session[SS_TK.ISHOME] = "1";
            Session[SS_TK.ANQUOCHOI_THOIHIEU] = "0";
            Session[SS_TK.ANTHOIHIEU] = "3";
            Session[SS_TK.THAMTRAVIEN] = ThamtravienID;
            Session[SS_TK.LANHDAOPHUTRACH] = LanhdaoVuID;

            Session[SS_TK.TOAANXX] = "0";
            Session[SS_TK.SOBAQD] = "";
            Session[SS_TK.NGAYBAQD] = "";
            Session[SS_TK.NGUYENDON] = "";
            Session[SS_TK.BIDON] = "";
            Session[SS_TK.LOAIAN] = strLoaiAn;

            Session[SS_TK.THAMPHAN] = "0";
            Session[SS_TK.QHPKLT] = "0";
            Session[SS_TK.QHPLDN] = "0";
            Session[SS_TK.TRALOIDON] = "2";
            Session[SS_TK.NGUOIGUI] = "";
            Session[SS_TK.COQUANCHUYENDON] = "";
            Session[SS_TK.LOAICV] = "0";
            Session[SS_TK.THULY_TU] = "";
            Session[SS_TK.THULY_DEN] = "";
            Session[SS_TK.SOTHULY] = "";
            Session[SS_TK.MUONHOSO] = "-1";
            Session[SS_TK.TRANGTHAITHULY] = "0";
            //-----------------///////////////////
            Session[SS_TK.BUOCTT] = "0";
            Session[SS_TK.HOAN_THIHAHAN] = "2";
            Session[SS_TK.TRANGTHAITOTRINH] = "2";
            //---------------------
            Session[SS_TK.KETQUATHULY] = "4";
            Session[SS_TK.KETQUAXETXU] = "0";
            //-----------------
            Session[SS_TK.ARRSELECTID] = "";
            Session[SS_TK.XXGDT_HDTP] = "0";
            Session[SS_TK.TRANGTHAIYKIENTT] = 2;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    Session[SS_TK.TRANGTHAITHULY] = "1";
                    Session[SS_TK.KETQUATHULY] = "4";
                    break;
                case "COLUMN_2":
                    Session[SS_TK.TRANGTHAITHULY] = "2";
                    Session[SS_TK.KETQUATHULY] = "4";
                    break;
                case "COLUMN_3":
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    break;
                case "COLUMN_4":
                    Session[SS_TK.MUONHOSO] = "0";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    break;
                case "COLUMN_5":
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "3";
                    Session[SS_TK.TRANGTHAITOTRINH] = "0";
                    break;
                case "COLUMN_6":
                    Session[SS_TK.TRANGTHAITHULY] = "4";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_7":
                    Session[SS_TK.TRANGTHAITHULY] = "5";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_8":
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.TRANGTHAIYKIENTT] = 0;
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_9":
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.TRANGTHAIYKIENTT] = 1;
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_10":
                    Session[SS_TK.TRANGTHAITHULY] = "10";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_11":
                    Session[SS_TK.TRANGTHAITHULY] = "7";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_12":
                    Session[SS_TK.TRANGTHAITHULY] = "9";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_13":
                    Session[SS_TK.TRANGTHAITHULY] = "8";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_14":
                    Session[SS_TK.TRANGTHAITHULY] = "17";
                    break;
                case "COLUMN_15":
                    Session[SS_TK.TRANGTHAITHULY] = "11";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_16":
                    Session[SS_TK.TRANGTHAITHULY] = "12";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_17":
                    Session[SS_TK.HOAN_THIHAHAN] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    break;
                default:
                    // Session[SS_TK.TRANGTHAITHULY] = strTrangThai;
                    Session[SS_TK.TRANGTHAIYKIENTT] = 2;
                    break;
            }
            Response.Redirect("QLAN/GDTTT/VuAn/Danhsach.aspx");
        }
       //-----------------------------------
        protected void rptThamPhan_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                if(dv["LOAIAN"]+""=="")
                {
                    LinkButton LinkButton31 = (LinkButton)e.Item.FindControl("LinkButton31");
                    LinkButton31.Style.Remove("color");
                    LinkButton31.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton34 = (LinkButton)e.Item.FindControl("LinkButton34");
                    LinkButton34.Style.Remove("color");
                    LinkButton34.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton27 = (LinkButton)e.Item.FindControl("LinkButton27");
                    LinkButton27.Style.Remove("color");
                    LinkButton27.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton28 = (LinkButton)e.Item.FindControl("LinkButton28");
                    LinkButton28.Style.Remove("color");
                    LinkButton28.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton35 = (LinkButton)e.Item.FindControl("LinkButton35");
                    LinkButton35.Style.Remove("color");
                    LinkButton35.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton36 = (LinkButton)e.Item.FindControl("LinkButton36");
                    LinkButton36.Style.Remove("color");
                    LinkButton36.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton37 = (LinkButton)e.Item.FindControl("LinkButton37");
                    LinkButton37.Style.Remove("color");
                    LinkButton37.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton39 = (LinkButton)e.Item.FindControl("LinkButton39");
                    LinkButton39.Style.Remove("color");
                    LinkButton39.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton40 = (LinkButton)e.Item.FindControl("LinkButton40");
                    LinkButton40.Style.Remove("color");
                    LinkButton40.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton15 = (LinkButton)e.Item.FindControl("LinkButton15");
                    LinkButton15.Style.Remove("color");
                    LinkButton15.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton32 = (LinkButton)e.Item.FindControl("LinkButton32");
                    LinkButton32.Style.Remove("color");
                    LinkButton32.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton16 = (LinkButton)e.Item.FindControl("LinkButton16");
                    LinkButton16.Style.Remove("color");
                    LinkButton16.Style.Add("color", "#EE0E0E");
                    LinkButton LinkButton17 = (LinkButton)e.Item.FindControl("LinkButton17");
                    LinkButton17.Style.Remove("color");
                    LinkButton17.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton18 = (LinkButton)e.Item.FindControl("LinkButton18");
                    LinkButton18.Style.Remove("color");
                    LinkButton18.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton19 = (LinkButton)e.Item.FindControl("LinkButton19");
                    LinkButton19.Style.Remove("color");
                    LinkButton19.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton38 = (LinkButton)e.Item.FindControl("LinkButton38");
                    LinkButton38.Style.Remove("color");
                    LinkButton38.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton33 = (LinkButton)e.Item.FindControl("LinkButton33");
                    LinkButton33.Style.Remove("color");
                    LinkButton33.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton20 = (LinkButton)e.Item.FindControl("LinkButton20");
                    LinkButton20.Style.Remove("color");
                    LinkButton20.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton21 = (LinkButton)e.Item.FindControl("LinkButton21");
                    LinkButton21.Style.Remove("color");
                    LinkButton21.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton22 = (LinkButton)e.Item.FindControl("LinkButton22");
                    LinkButton22.Style.Remove("color");
                    LinkButton22.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton23 = (LinkButton)e.Item.FindControl("LinkButton23");
                    LinkButton23.Style.Remove("color");
                    LinkButton23.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton41 = (LinkButton)e.Item.FindControl("LinkButton41");
                    LinkButton41.Style.Remove("color");
                    LinkButton41.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton25 = (LinkButton)e.Item.FindControl("LinkButton25");
                    LinkButton25.Style.Remove("color");
                    LinkButton25.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton26 = (LinkButton)e.Item.FindControl("LinkButton26");
                    LinkButton26.Style.Remove("color");
                    LinkButton26.Style.Add("color", "#EE0E0E");
                }
            }
        }
        protected void rptAnQuocHoi_tp_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                if (dv["LOAIAN"] + "" == "")
                {
                    LinkButton LinkButton31 = (LinkButton)e.Item.FindControl("LinkButton31");
                    LinkButton31.Style.Remove("color");
                    LinkButton31.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton34 = (LinkButton)e.Item.FindControl("LinkButton34");
                    LinkButton34.Style.Remove("color");
                    LinkButton34.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton27 = (LinkButton)e.Item.FindControl("LinkButton27");
                    LinkButton27.Style.Remove("color");
                    LinkButton27.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton28 = (LinkButton)e.Item.FindControl("LinkButton28");
                    LinkButton28.Style.Remove("color");
                    LinkButton28.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton35 = (LinkButton)e.Item.FindControl("LinkButton35");
                    LinkButton35.Style.Remove("color");
                    LinkButton35.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton36 = (LinkButton)e.Item.FindControl("LinkButton36");
                    LinkButton36.Style.Remove("color");
                    LinkButton36.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton37 = (LinkButton)e.Item.FindControl("LinkButton37");
                    LinkButton37.Style.Remove("color");
                    LinkButton37.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton39 = (LinkButton)e.Item.FindControl("LinkButton39");
                    LinkButton39.Style.Remove("color");
                    LinkButton39.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton40 = (LinkButton)e.Item.FindControl("LinkButton40");
                    LinkButton40.Style.Remove("color");
                    LinkButton40.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton15 = (LinkButton)e.Item.FindControl("LinkButton15");
                    LinkButton15.Style.Remove("color");
                    LinkButton15.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton32 = (LinkButton)e.Item.FindControl("LinkButton32");
                    LinkButton32.Style.Remove("color");
                    LinkButton32.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton16 = (LinkButton)e.Item.FindControl("LinkButton16");
                    LinkButton16.Style.Remove("color");
                    LinkButton16.Style.Add("color", "#EE0E0E");
                    LinkButton LinkButton17 = (LinkButton)e.Item.FindControl("LinkButton17");
                    LinkButton17.Style.Remove("color");
                    LinkButton17.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton18 = (LinkButton)e.Item.FindControl("LinkButton18");
                    LinkButton18.Style.Remove("color");
                    LinkButton18.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton19 = (LinkButton)e.Item.FindControl("LinkButton19");
                    LinkButton19.Style.Remove("color");
                    LinkButton19.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton38 = (LinkButton)e.Item.FindControl("LinkButton38");
                    LinkButton38.Style.Remove("color");
                    LinkButton38.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton33 = (LinkButton)e.Item.FindControl("LinkButton33");
                    LinkButton33.Style.Remove("color");
                    LinkButton33.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton20 = (LinkButton)e.Item.FindControl("LinkButton20");
                    LinkButton20.Style.Remove("color");
                    LinkButton20.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton21 = (LinkButton)e.Item.FindControl("LinkButton21");
                    LinkButton21.Style.Remove("color");
                    LinkButton21.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton22 = (LinkButton)e.Item.FindControl("LinkButton22");
                    LinkButton22.Style.Remove("color");
                    LinkButton22.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton23 = (LinkButton)e.Item.FindControl("LinkButton23");
                    LinkButton23.Style.Remove("color");
                    LinkButton23.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton41 = (LinkButton)e.Item.FindControl("LinkButton41");
                    LinkButton41.Style.Remove("color");
                    LinkButton41.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton25 = (LinkButton)e.Item.FindControl("LinkButton25");
                    LinkButton25.Style.Remove("color");
                    LinkButton25.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton26 = (LinkButton)e.Item.FindControl("LinkButton26");
                    LinkButton26.Style.Remove("color");
                    LinkButton26.Style.Add("color", "#EE0E0E");
                }
            }
        }
        protected void rptAnThoiHieu_tp_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                if (dv["LOAIAN"] + "" == "")
                {
                    LinkButton LinkButton31 = (LinkButton)e.Item.FindControl("LinkButton31");
                    LinkButton31.Style.Remove("color");
                    LinkButton31.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton34 = (LinkButton)e.Item.FindControl("LinkButton34");
                    LinkButton34.Style.Remove("color");
                    LinkButton34.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton27 = (LinkButton)e.Item.FindControl("LinkButton27");
                    LinkButton27.Style.Remove("color");
                    LinkButton27.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton28 = (LinkButton)e.Item.FindControl("LinkButton28");
                    LinkButton28.Style.Remove("color");
                    LinkButton28.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton35 = (LinkButton)e.Item.FindControl("LinkButton35");
                    LinkButton35.Style.Remove("color");
                    LinkButton35.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton36 = (LinkButton)e.Item.FindControl("LinkButton36");
                    LinkButton36.Style.Remove("color");
                    LinkButton36.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton37 = (LinkButton)e.Item.FindControl("LinkButton37");
                    LinkButton37.Style.Remove("color");
                    LinkButton37.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton39 = (LinkButton)e.Item.FindControl("LinkButton39");
                    LinkButton39.Style.Remove("color");
                    LinkButton39.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton40 = (LinkButton)e.Item.FindControl("LinkButton40");
                    LinkButton40.Style.Remove("color");
                    LinkButton40.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton15 = (LinkButton)e.Item.FindControl("LinkButton15");
                    LinkButton15.Style.Remove("color");
                    LinkButton15.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton32 = (LinkButton)e.Item.FindControl("LinkButton32");
                    LinkButton32.Style.Remove("color");
                    LinkButton32.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton16 = (LinkButton)e.Item.FindControl("LinkButton16");
                    LinkButton16.Style.Remove("color");
                    LinkButton16.Style.Add("color", "#EE0E0E");
                    LinkButton LinkButton17 = (LinkButton)e.Item.FindControl("LinkButton17");
                    LinkButton17.Style.Remove("color");
                    LinkButton17.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton18 = (LinkButton)e.Item.FindControl("LinkButton18");
                    LinkButton18.Style.Remove("color");
                    LinkButton18.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton19 = (LinkButton)e.Item.FindControl("LinkButton19");
                    LinkButton19.Style.Remove("color");
                    LinkButton19.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton38 = (LinkButton)e.Item.FindControl("LinkButton38");
                    LinkButton38.Style.Remove("color");
                    LinkButton38.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton33 = (LinkButton)e.Item.FindControl("LinkButton33");
                    LinkButton33.Style.Remove("color");
                    LinkButton33.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton20 = (LinkButton)e.Item.FindControl("LinkButton20");
                    LinkButton20.Style.Remove("color");
                    LinkButton20.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton21 = (LinkButton)e.Item.FindControl("LinkButton21");
                    LinkButton21.Style.Remove("color");
                    LinkButton21.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton22 = (LinkButton)e.Item.FindControl("LinkButton22");
                    LinkButton22.Style.Remove("color");
                    LinkButton22.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton23 = (LinkButton)e.Item.FindControl("LinkButton23");
                    LinkButton23.Style.Remove("color");
                    LinkButton23.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton41 = (LinkButton)e.Item.FindControl("LinkButton41");
                    LinkButton41.Style.Remove("color");
                    LinkButton41.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton25 = (LinkButton)e.Item.FindControl("LinkButton25");
                    LinkButton25.Style.Remove("color");
                    LinkButton25.Style.Add("color", "#EE0E0E");

                    LinkButton LinkButton26 = (LinkButton)e.Item.FindControl("LinkButton26");
                    LinkButton26.Style.Remove("color");
                    LinkButton26.Style.Add("color", "#EE0E0E");
                }
            }
        }
        protected void rptThamPhan_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = hi_ThamPhan_ID.Value;//Session[ENUM_SESSION.SESSION_CANBOID] + "";
            decimal CanboID = Convert.ToDecimal(strCanBoID);
            string strLoaiAn = e.CommandArgument.ToString();
            //if (strLoaiAn == "1")
            //    Session[ENUM_SESSION.SESSION_PHONGBANID] = "2";
            //else if (strLoaiAn == "2" || strLoaiAn == "4")
            //    Session[ENUM_SESSION.SESSION_PHONGBANID] = "3";
            //else
            //    Session[ENUM_SESSION.SESSION_PHONGBANID] = "4";
            if (strLoaiAn == "0") return;
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;

            ClearSession_TKThamPhan();
            Session[SS_TK.LOAIAN] = strLoaiAn;
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCVUID != null && oCB.CHUCVUID == ChucVuPCA)
            {
                if (oCB.CHUCDANHID == ChucDanh_TPTATC)
                    Session[SS_TK.THAMPHAN] = 0;
            }
            else Session[SS_TK.THAMPHAN] = strCanBoID;
            Session[SS_TK.ANQUOCHOI_THOIHIEU] = "0";
            Session[SS_TK.ANTHOIHIEU] = null;
            Session[SS_TK.ISDANGKYBAOCAO] = "2";
            Session[SS_TK.CHK_CONLAI_S] = "true";
            //---------
            //Session[ENUM_SESSION.SESSION_YEARS_TK] = ddl_Load_year.SelectedValue;
            Session[SS_TK.THULY_TU] = "01/01/" + ddl_Load_year.SelectedValue;
            Session[SS_TK.THULY_DEN] = "31/12/" + ddl_Load_year.SelectedValue;
            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    Session[SS_TK.TRANGTHAITOTRINH] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.BUOCTT] = "0";
                    Session[SS_TK.THULY_TU] = "";
                    Session[SS_TK.THULY_DEN] = "01/01/" + ddl_Load_year.SelectedValue;
                    break;
                case "COLUMN_2":
                    Session[SS_TK.TRANGTHAITOTRINH] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_3":
                    //da phan cong TTV
                    Session[SS_TK.TRANGTHAITHULY] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_4":
                    //chua phan cong ttv
                    Session[SS_TK.TRANGTHAITHULY] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    break;

                case "COLUMN_5":
                    //da co ho so
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_6":
                    //chua co ho so
                    Session[SS_TK.MUONHOSO] = "0";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;

                case "COLUMN_7":
                    //ttv dang nghien cuu ho so--> co ho so , ko co to trinh
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_8":
                    //to trinh chua giai quyet
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITOTRINH] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "0";
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_9":
                    //to trinh co y kien giai quyet + chua xx GDTTT
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITOTRINH] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_10":
                    //dang ky ngay bao cao tham phan 
                    Session[SS_TK.ISDANGKYBAOCAO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_11":
                    ////-------đăng ký trình tp-----
                    Session[SS_TK.TRANGTHAITHULY] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_12":
                    Session[SS_TK.KETQUATHULY] = "5";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_13":
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    Session[SS_TK.THULY_TU] = "";
                    break;
                case "COLUMN_14":
                    Session[SS_TK.KETQUATHULY] = "0";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_15":
                    Session[SS_TK.KETQUATHULY] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_16":
                    Session[SS_TK.KETQUATHULY] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_17":
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITHULY] = "11";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    //Session[SS_TK.THULY_TU] = "";
                    //Session[SS_TK.THULY_DEN] = "01/01/" + ddl_Load_year.SelectedValue;
                    break;
                case "COLUMN_18":
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITHULY] = "12";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    //Session[SS_TK.THULY_TU] = "";
                    //Session[SS_TK.THULY_DEN] = "01/01/" + ddl_Load_year.SelectedValue;
                    break;
                case "COLUMN_19":
                    Session[SS_TK.KETQUATHULY] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_20":
                    Session[SS_TK.BUOCTT] = "0";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    break;
                case "COLUMN_21":
                    //chua xx GDTTT
                    Session[SS_TK.KETQUAXETXU] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_22":
                    //da xx GDTTT
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_23":
                    //Tham phan la chu toa
                    Session[SS_TK.XXGDT_HDTP] = "3";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_24":
                    //TP thuoc HDTT
                    Session[SS_TK.XXGDT_HDTP] = "1";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_25":
                    //TP thuoc HD5
                    Session[SS_TK.XXGDT_HDTP] = "2";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
            }
            Response.Redirect("QLAN/GDTTT/VuAn/Danhsach.aspx");
        }
        protected void rptAnQuocHoi_tp_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = hi_ThamPhan_ID.Value;//Session[ENUM_SESSION.SESSION_CANBOID] + "";
            decimal CanboID = Convert.ToDecimal(strCanBoID);
            string strLoaiAn = e.CommandArgument.ToString();
            //if (strLoaiAn == "1")
            //    Session[ENUM_SESSION.SESSION_PHONGBANID] = "2";
            //else if (strLoaiAn == "2" || strLoaiAn == "4")
            //    Session[ENUM_SESSION.SESSION_PHONGBANID] = "3";
            //else
            //    Session[ENUM_SESSION.SESSION_PHONGBANID] = "4";

            if (strLoaiAn == "0") return;
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;

            ClearSession_TKThamPhan();
            Session[SS_TK.LOAIAN] = strLoaiAn;
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCVUID != null && oCB.CHUCVUID == ChucVuPCA)
            {
                if (oCB.CHUCDANHID == ChucDanh_TPTATC)
                    Session[SS_TK.THAMPHAN] = 0;
            }
            else Session[SS_TK.THAMPHAN] = strCanBoID;
            Session[SS_TK.ANQUOCHOI_THOIHIEU] = "1";
            Session[SS_TK.ISDANGKYBAOCAO] = "2";
            Session[SS_TK.CHK_CONLAI_S] = "true";
            //---------
            Session[SS_TK.THULY_TU] = "01/01/" + ddl_Load_year.SelectedValue;
            Session[SS_TK.THULY_DEN] = "31/12/" + ddl_Load_year.SelectedValue;
            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    Session[SS_TK.TRANGTHAITOTRINH] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.BUOCTT] = "0";
                    Session[SS_TK.THULY_TU] = "";
                    Session[SS_TK.THULY_DEN] = "01/01/" + ddl_Load_year.SelectedValue;
                    break;
                case "COLUMN_2":
                    Session[SS_TK.TRANGTHAITOTRINH] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_3":
                    //da phan cong TTV
                    Session[SS_TK.TRANGTHAITHULY] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_4":
                    //chua phan cong ttv
                    Session[SS_TK.TRANGTHAITHULY] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    break;

                case "COLUMN_5":
                    //da co ho so
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_6":
                    //chua co ho so
                    Session[SS_TK.MUONHOSO] = "0";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;

                case "COLUMN_7":
                    //ttv dang nghien cuu ho so--> co ho so , ko co to trinh
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_8":
                    //to trinh chua giai quyet
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITOTRINH] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "0";
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_9":
                    //to trinh co y kien giai quyet + chua xx GDTTT
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITOTRINH] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_10":
                    //dang ky ngay bao cao tham phan 
                    Session[SS_TK.ISDANGKYBAOCAO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_11":
                    ////-------đăng ký trình tp-----
                    Session[SS_TK.TRANGTHAITHULY] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_12":
                    Session[SS_TK.KETQUATHULY] = "5";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_13":
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    Session[SS_TK.THULY_TU] = "";
                    break;
                case "COLUMN_14":
                    Session[SS_TK.KETQUATHULY] = "0";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_15":
                    Session[SS_TK.KETQUATHULY] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_16":
                    Session[SS_TK.KETQUATHULY] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_17":
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITHULY] = "11";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    //Session[SS_TK.THULY_TU] = "";
                    //Session[SS_TK.THULY_DEN] = "01/01/" + ddl_Load_year.SelectedValue;
                    break;
                case "COLUMN_18":
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITHULY] = "12";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    //Session[SS_TK.THULY_TU] = "";
                    //Session[SS_TK.THULY_DEN] = "01/01/" + ddl_Load_year.SelectedValue;
                    break;
                case "COLUMN_19":
                    Session[SS_TK.KETQUATHULY] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_20":
                    Session[SS_TK.BUOCTT] = "0";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    break;
                case "COLUMN_21":
                    //chua xx GDTTT
                    Session[SS_TK.KETQUAXETXU] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_22":
                    //da xx GDTTT
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_23":
                    //Tham phan la chu toa
                    Session[SS_TK.XXGDT_HDTP] = "3";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_24":
                    //TP thuoc HDTT
                    Session[SS_TK.XXGDT_HDTP] = "1";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_25":
                    //TP thuoc HD5
                    Session[SS_TK.XXGDT_HDTP] = "2";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
            }
            Response.Redirect("QLAN/GDTTT/VuAn/Danhsach.aspx");
        }
        protected void rptAnThoiHieu_tp_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = hi_ThamPhan_ID.Value;//Session[ENUM_SESSION.SESSION_CANBOID] + "";
            decimal CanboID = Convert.ToDecimal(strCanBoID);
            string strLoaiAn = e.CommandArgument.ToString();
            //if (strLoaiAn == "1")
            //    Session[ENUM_SESSION.SESSION_PHONGBANID] = "2";
            //else if (strLoaiAn == "2" || strLoaiAn == "4")
            //    Session[ENUM_SESSION.SESSION_PHONGBANID] = "3";
            //else
            //    Session[ENUM_SESSION.SESSION_PHONGBANID] = "4";

            if (strLoaiAn == "0") return;
            if (strLoaiAn.Length == 1) strLoaiAn = "0" + strLoaiAn;

            ClearSession_TKThamPhan();
            Session[SS_TK.LOAIAN] = strLoaiAn;
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCVUID != null && oCB.CHUCVUID == ChucVuPCA)
            {
                if (oCB.CHUCDANHID == ChucDanh_TPTATC)
                    Session[SS_TK.THAMPHAN] = 0;
            }
            else Session[SS_TK.THAMPHAN] = strCanBoID;
            Session[SS_TK.ANQUOCHOI_THOIHIEU] = "0";
             Session[SS_TK.ANTHOIHIEU] = "3";
            Session[SS_TK.ISDANGKYBAOCAO] = "2";
            Session[SS_TK.CHK_CONLAI_S] = "true";
            //---------
            Session[SS_TK.THULY_TU] = "01/01/" + ddl_Load_year.SelectedValue;
            Session[SS_TK.THULY_DEN] = "31/12/" + ddl_Load_year.SelectedValue;
            string strTrangThai = e.CommandName;
            switch (strTrangThai)
            {
                case "COLUMN_1":
                    Session[SS_TK.TRANGTHAITOTRINH] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.BUOCTT] = "0";
                    Session[SS_TK.THULY_TU] = "";
                    Session[SS_TK.THULY_DEN] = "01/01/" + ddl_Load_year.SelectedValue;
                    break;
                case "COLUMN_2":
                    Session[SS_TK.TRANGTHAITOTRINH] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_3":
                    //da phan cong TTV
                    Session[SS_TK.TRANGTHAITHULY] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_4":
                    //chua phan cong ttv
                    Session[SS_TK.TRANGTHAITHULY] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    break;

                case "COLUMN_5":
                    //da co ho so
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_6":
                    //chua co ho so
                    Session[SS_TK.MUONHOSO] = "0";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;

                case "COLUMN_7":
                    //ttv dang nghien cuu ho so--> co ho so , ko co to trinh
                    Session[SS_TK.MUONHOSO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_8":
                    //to trinh chua giai quyet
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITOTRINH] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "0";
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_9":
                    //to trinh co y kien giai quyet + chua xx GDTTT
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITOTRINH] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_10":
                    //dang ky ngay bao cao tham phan 
                    Session[SS_TK.ISDANGKYBAOCAO] = "1";
                    Session[SS_TK.TRANGTHAITHULY] = "6";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_11":
                    ////-------đăng ký trình tp-----
                    Session[SS_TK.TRANGTHAITHULY] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "1";
                    break;
                case "COLUMN_12":
                    Session[SS_TK.KETQUATHULY] = "5";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_13":
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    Session[SS_TK.THULY_TU] = "";
                    break;
                case "COLUMN_14":
                    Session[SS_TK.KETQUATHULY] = "0";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_15":
                    Session[SS_TK.KETQUATHULY] = "1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_16":
                    Session[SS_TK.KETQUATHULY] = "2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_17":
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITHULY] = "11";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    //Session[SS_TK.THULY_TU] = "";
                    //Session[SS_TK.THULY_DEN] = "01/01/" + ddl_Load_year.SelectedValue;
                    break;
                case "COLUMN_18":
                    Session[SS_TK.KETQUATHULY] = "4";
                    Session[SS_TK.TRANGTHAITHULY] = "12";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.BUOCTT] = "0";
                    //Session[SS_TK.THULY_TU] = "";
                    //Session[SS_TK.THULY_DEN] = "01/01/" + ddl_Load_year.SelectedValue;
                    break;
                case "COLUMN_19":
                    Session[SS_TK.KETQUATHULY] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "0";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_20":
                    Session[SS_TK.BUOCTT] = "0";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    break;
                case "COLUMN_21":
                    //chua xx GDTTT
                    Session[SS_TK.KETQUAXETXU] = "-1";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_22":
                    //da xx GDTTT
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_23":
                    //Tham phan la chu toa
                    Session[SS_TK.XXGDT_HDTP] = "3";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_24":
                    //TP thuoc HDTT
                    Session[SS_TK.XXGDT_HDTP] = "1";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
                case "COLUMN_25":
                    //TP thuoc HD5
                    Session[SS_TK.XXGDT_HDTP] = "2";
                    Session[SS_TK.KETQUATHULY] = "3";
                    Session[SS_TK.KETQUAXETXU] = "-2";
                    Session[SS_TK.TRANGTHAIYKIENTT] = "2";
                    Session[SS_TK.TRANGTHAITHULY] = "15";
                    Session[SS_TK.BUOCTT] = "0";
                    break;
            }
            Response.Redirect("QLAN/GDTTT/VuAn/Danhsach.aspx");
        }
        private void Load_Data_Years()
        {
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //---------------------
            Decimal ChucDanh_TPTATC = 0;
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            //-----------------------
            ddl_Load_year.Items.Clear();
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            DataTable tbl = oGDTBL.Get_Year_Theo_TP(LoginDonViID, oCB.ID);
            ddl_Load_year.DataSource = tbl;
            ddl_Load_year.DataTextField = "YEAR_TEN";
            ddl_Load_year.DataValueField = "YEAR_ID";
            ddl_Load_year.DataBind();
        }
        protected void ddl_Load_year_SelectedIndexChanged(object sender, EventArgs e)
        {
            Decimal CanboID=Convert.ToDecimal(hi_ThamPhan_ID.Value);
            LoadTKThamphan(CanboID);
            LoadThongkeQuocHoi_ThoiHieu_ByThamPhan(CanboID);
        }
    }
}