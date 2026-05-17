using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using System.Globalization;
using BL.DonKK;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Web.UI.HtmlControls;
using BL.GSTP.GDTTT;
namespace WEB.GSTP.UserControl.TP
{
    public partial class ThongKe : System.Web.UI.UserControl
    {
        GSTPContext gsdt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DM_CANBO_BL bl = new DM_CANBO_BL();
        GSTPContext dt = new GSTPContext();
        public string strMaCT = "", CurrFullName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            { //--Phân quyền màn hình thống ke sau login 

                decimal canboid = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");

                DM_CANBO CA_TANDTC = dt.DM_CANBO.Where(x => x.ID == canboid && x.TOAANID == 1 && x.CHUCVUID == 45).FirstOrDefault();
                if (CA_TANDTC == null)
                {
                    decimal IDNhom = 0;
                    if (Session[ENUM_SESSION.SESSION_NHOMNSDID] != null && Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" != "")
                    {
                        IDNhom = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
                    }
                    QT_MENU_BL qtBL = new QT_MENU_BL();
                    DataTable lst_home = qtBL.Qt_Nhom_ISHome_Get_List(IDNhom);
                    if (lst_home != null && lst_home.Rows.Count > 0 && lst_home.Rows[0]["VIEW_TK"] + "" == "1")
                    {
                        LoadCapXetXu();
                        load_check_capxx();
                    }
                    try
                    {
                        CurrFullName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
                        strMaCT = Session["MaChuongTrinh"] + "";
                        if (strMaCT == "" || strMaCT == "0")
                        {
                            decimal UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]),
                                    DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString()); ;
                            if (!IsPostBack)
                            {
                                txtTuNgay.Text = "01/01" + DateTime.Now.ToString("/yyyy");
                                txtDenNgay.Text = "31/12" + DateTime.Now.ToString("/yyyy");

                                if (lst_home != null && lst_home.Rows.Count > 0 && lst_home.Rows[0]["VIEW_TK"] + "" == "1")
                                {
                                    // Show_To_phanquyen_tk.Style.Add("Display","block");
                                    Pn_Show_To_Container.Visible = true;

                                    //------Thẩm phán--------------
                                    DataTable tbl = bl.DM_CANBO_GETCA_PCA_BY_USERID(UserID);
                                    if (tbl.Rows.Count > 0)
                                    {
                                        //Pn_Show_To_Container.Visible = true;
                                        //pnChanhAn.Visible = true;
                                        //pnThamPhan.Visible = true;
                                        tk_boder_contents.Style.Remove("Display");
                                        LtrTenCA_PCA.Text = tbl.Rows[0]["TenChucVu"].ToString() + " " + tbl.Rows[0]["hoten"].ToString();

                                        //decimal LanhdaoVuID = 0;
                                        string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                                        decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
                                        DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                                        // decimal ThamtravienID = 0;
                                        
                                        LoadThongke_stpt_ca();
                                    }
                                    DataTable tblTP = bl.DM_CANBO_GETTP_BYDONVI(DonViLoginID, 1, 1);
                                    if (tblTP != null && tblTP.Rows.Count > 0)
                                    {
                                        LtrSoLuongTP.Text = "DANH SÁCH SỐ LƯỢNG ÁN CỦA CÁC THẨM PHÁN (" + tblTP.Rows[0]["Total"].ToString() + " THẨM PHÁN)";
                                    }

                                    //LoadData_PnChanhAn();
                                    // LoadDsThamPhan();
                                    //--------------------
                                }
                                else
                                {
                                    // Show_To_phanquyen_tk.Style.Add("Display", "none");
                                    //  Pn_Show_To_Container.Visible = false;
                                    Pn_Show_To_Container.Visible = false;
                                }
                            }
                        }
                        else
                        {
                            //anhvh add 14/10/2020 chỉ cho hiện form login ghi nhấn vào trang chủ
                            if (strMaCT != "0" && strMaCT != "")
                            {
                                Pn_Show_To_Container.Visible = false;
                            }
                            //Show_To_phanquyen_tk.Style.Add("Display", "none");
                            //Pn_Show_To_Container.Visible = false;
                        }
                    }
                    catch (Exception ex) { LblthongBao.Text = ex.Message; }
                }
            }
        }

        protected void rptThongke_stpt_ItemCommand(object source, RepeaterCommandEventArgs e)
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
        private void LoadThongke_stpt_ca()
        {
            CANH_BAO_STPT oBLST = new CANH_BAO_STPT();
            DataTable oDTst = null;
            DataTable oDTpt = null;
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {  
                oDTst= oBLST.GET_STPT_LOGIN_CA_SOTHAM(dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "");
                rptThongke_st.DataSource = oDTst;
                rptThongke_st.DataBind();
                Li_sotham.Text = "<tr runat='server' id='sotham_td' style=''><td rowspan='"+ (oDTst.Rows.Count+1) + "'>Sơ thẩm</td></tr>";
                //--------------
                rptThongke_pt.DataSource = null;
                rptThongke_pt.DataBind();
                li_phuctham.Text = "";
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                oDTst = oBLST.GET_STPT_LOGIN_CA_SOTHAM(dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "");
                rptThongke_st.DataSource = oDTst;
                rptThongke_st.DataBind();
                Li_sotham.Text = "<tr runat='server' id='sotham_td' style=''><td rowspan='" + (oDTst.Rows.Count + 1) + "'>Sơ thẩm</td></tr>";
                ///
                oDTpt =oBLST.GET_STPT_LOGIN_CA_PHUCTHAM(dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "");
                rptThongke_pt.DataSource = oDTpt;
                rptThongke_pt.DataBind();
                li_phuctham.Text = "<tr runat='server' id='phuctham_td' style=''><td rowspan='" + (oDTpt.Rows.Count + 1) + "'>Phúc thẩm</td></tr>";
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                oDTpt = oBLST.GET_STPT_LOGIN_CA_PHUCTHAM(dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "");
                rptThongke_pt.DataSource = oDTpt;
                rptThongke_pt.DataBind();
                li_phuctham.Text = "<tr runat='server' id='phuctham_td' style=''><td rowspan='" + (oDTpt.Rows.Count + 1) + "'>Phúc thẩm</td></tr>";
                //
                rptThongke_st.DataSource = null;
                rptThongke_st.DataBind();
                Li_sotham.Text = "";
            }
            else
            {
                oDTst = oBLST.GET_STPT_LOGIN_CA_SOTHAM(dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "");
                rptThongke_st.DataSource = oDTst;
                rptThongke_st.DataBind();
                Li_sotham.Text = "<tr runat='server' id='sotham_td' style=''><td rowspan='" + (oDTst.Rows.Count + 1) + "'>Sơ thẩm</td></tr>";
                ///
                oDTpt = oBLST.GET_STPT_LOGIN_CA_PHUCTHAM(dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "");
                rptThongke_pt.DataSource = oDTpt;
                rptThongke_pt.DataBind();
                li_phuctham.Text = "<tr runat='server' id='phuctham_td' style=''><td rowspan='" + (oDTpt.Rows.Count + 1) + "'>Phúc thẩm</td></tr>";
            }
        }
        private void load_check_capxx()
        {
            //Cần thống nhất lại hiển thị cho những chức vụ, chức danh nào 24.01.26
            if (Session["CAP_XET_XU"] + "" == "TOICAO")
            {
                tk_nopdonkhoikien.Visible = false;
                tk_tamgiam.Visible = false;

                /*Chánh án tối cao có màn hình riêng*/
                tk_thongtin_tlgq_danhchochanhan.Visible = false; 
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                tk_nopdonkhoikien.Visible = false;
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                tk_nopdonkhoikien.Visible = true;
            }
            else if(Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                tk_nopdonkhoikien.Visible = true;
            }
            else
            {
                tk_nopdonkhoikien.Visible = true;
            } 
            
            if(tk_nopdonkhoikien.Visible == true)
            {
                Load_soluong_dkk();
                Load_soluong_dkk_toakhac();
            }

            if (tk_tamgiam.Visible == true)
            {
                Load_TongBC();
                Load_TongBC_VKS();
            }
            
            if (tk_thongtin_tlgq_danhchochanhan.Visible == true)
            {
                LoadTKT_Canhbao();
            }    
        }
        
        private void Load_TongBC()
        {
            CANH_BAO_STPT oBLST = new CANH_BAO_STPT();
            DataTable oDT = null;
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            lit_view_tongbc.Text = "";
            oDT = oBLST.GET_CANHBAO_TRAIGIAM(Session["CAP_XET_XU"] + "", Session[ENUM_SESSION.SESSION_DONVIID] + "", pageindex, page_size);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                lit_view_tongbc.Text += oDT.Rows[0]["CountAll"] + "";
            }
            else
            {
                lit_view_tongbc.Text +=  "0";
            }
        }
        private void Load_TongBC_VKS()
        {
            CANH_BAO_STPT oBLST = new CANH_BAO_STPT();
            DataTable oDT = null;
            lit_sohoso.Text = "";
            oDT = oBLST.GET_CANHBAO_HOSO_VKS(Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
            if (oDT != null && oDT.Rows.Count > 0)
            {
                lit_sohoso.Text += oDT.Rows[0]["CountAll"] + "";
            }
            else
            {
                lit_sohoso.Text += "0";
            }
        }
        private void Load_soluong_dkk()
        {
            DataTable oDT = null;
            DONKK_DON_BL oBL = new DONKK_DON_BL();
            li_soluong_dkk.Text = "";
            oDT = oBL.GET_DONKK_CHUA_PHANLOAI(0, Session[ENUM_SESSION.SESSION_DONVIID] + "");
            if (oDT != null && oDT.Rows.Count > 0)
            {
                li_soluong_dkk.Text += oDT.Rows[0]["CountAll"] + "";
            }
            else
            {
                li_soluong_dkk.Text += "0";
            }
        }
        private void Load_soluong_dkk_toakhac()
        {
            DataTable oDT = null;
            CANH_BAO_STPT oBL = new CANH_BAO_STPT();
            li_soluong_dkk_toakhac.Text = "";
            oDT = oBL.GET_DONKK_TOAKHAC_CHUYENDEN(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            if (oDT != null && oDT.Rows.Count > 0)
            {
                li_soluong_dkk_toakhac.Text += oDT.Rows[0]["CountAll"] + "";
            }
            else
            {
                li_soluong_dkk_toakhac.Text += "0";
            }
        }
        private void LoadTKT_Canhbao()
        {
           
            CANH_BAO_STPT oBLST = new CANH_BAO_STPT();
            rpt_canhbao.DataSource = oBLST.GET_CANHBAO_VUAN_TAMDINHCHI(dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "");
            rpt_canhbao.DataBind();
        }
        protected void rpt_canhbao_ItemCreated(Object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Header)
            {
                Label lbl_donvi = (Label)e.Item.FindControl("lbl_donvi");
                lbl_donvi.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            }
        }
        protected void rpt_canhbao_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                
                HtmlTableCell TEN_BC = (HtmlTableCell)e.Item.FindControl("TEN_BC");
                HtmlTableCell TONG_CONG = (HtmlTableCell)e.Item.FindControl("TONG_CONG");
                HtmlTableCell td1 = (HtmlTableCell)e.Item.FindControl("COLUMN_1");
                HtmlTableCell td2 = (HtmlTableCell)e.Item.FindControl("COLUMN_2");
                HtmlTableCell td3 = (HtmlTableCell)e.Item.FindControl("COLUMN_3");
                HtmlTableCell td4 = (HtmlTableCell)e.Item.FindControl("COLUMN_4");
                HtmlTableCell td5 = (HtmlTableCell)e.Item.FindControl("COLUMN_5");
                HtmlTableCell td6 = (HtmlTableCell)e.Item.FindControl("COLUMN_6");
                HtmlTableCell td7 = (HtmlTableCell)e.Item.FindControl("COLUMN_7");
                HtmlTableCell td8 = (HtmlTableCell)e.Item.FindControl("COLUMN_8");
                HtmlTableCell td9 = (HtmlTableCell)e.Item.FindControl("COLUMN_9");
                if (dv["LOAI_BC"] + "" == "2" || dv["LOAI_BC"] + "" == "3" || dv["LOAI_BC"] + "" == "10")
                {
                    TEN_BC.Attributes.Add("style", "background-color:#fff798;");
                    TONG_CONG.Attributes.Add("style", "background-color:#fff798;");
                    td1.Attributes.Add("style", "background-color:#fff798;");
                    td2.Attributes.Add("style", "background-color:#fff798;");
                    td3.Attributes.Add("style", "background-color:#fff798;");
                    td4.Attributes.Add("style", "background-color:#fff798;");
                    td5.Attributes.Add("style", "background-color:#fff798;");
                    td6.Attributes.Add("style", "background-color:#fff798;");
                    td7.Attributes.Add("style", "background-color:#fff798;");
                    td8.Attributes.Add("style", "background-color:#fff798;");
                    td9.Attributes.Add("style", "background-color:#fff798;");
                }
            }
        }
        protected void rpt_canhbao_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string strCanBoID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
            decimal CanboID = Convert.ToDecimal(strCanBoID);
            string strLoaiBC = e.CommandArgument.ToString();
            string loai_an = e.CommandName;
            //----------------
            ClearSession_TK();
            
            Session[TK_CANHBAO.TK_SET_DEFAULT_VALUE] = "1";
            Session[TK_CANHBAO.CAPXX] = dropCapxx.SelectedValue;
            if (strLoaiBC == "1")
            {
                Session[TK_CANHBAO.TINHTRANG_THULY] = "1";
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "1";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "";
            }
            else if (strLoaiBC == "2")
            {
                Session[TK_CANHBAO.TINHTRANG_THULY] = "1";
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "1";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "1";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "";
            }
            else if (strLoaiBC == "3")
            {
                Session[TK_CANHBAO.TINHTRANG_THULY] = "1";
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "3";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "";
            }
            else if (strLoaiBC == "4") // Tạm đình chỉ
            {
                Session[TK_CANHBAO.TINHTRANG_THULY] = "1";
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "6";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "";
            }
            else if (strLoaiBC == "5") // Án chờ thụ lý
            {
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
                Session[TK_CANHBAO.TINHTRANG_THULY] = "2";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "";
            }
            else if (strLoaiBC == "6") // Án đã thụ lý chưa phân công Thẩm phán
            {
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "2";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
                Session[TK_CANHBAO.TINHTRANG_THULY] = "1";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "";
            }
            else if (strLoaiBC == "7")
            {
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
                Session[TK_CANHBAO.TINHTRANG_THULY] = "";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "";
            }
            else if (strLoaiBC == "8")
            {
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "7";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
                Session[TK_CANHBAO.TINHTRANG_THULY] = "";
                Session[TK_CANHBAO.TUNGAY] = "01/"+ DateTime.Now.ToString("MM/yyyy");
                Session[TK_CANHBAO.GQDON] = "";
            }
            else if (strLoaiBC == "9") // Đơn chưa giải quyết
            {
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "1";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
                Session[TK_CANHBAO.TINHTRANG_THULY] = "";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "6";
            }
            else if (strLoaiBC == "10")
            {
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "1";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
                Session[TK_CANHBAO.TINHTRANG_THULY] = "";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "7";
            }
            else if (strLoaiBC == "11")
            {
                Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
                Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
                Session[TK_CANHBAO.TINHTRANG_THULY] = "";
                Session[TK_CANHBAO.TUNGAY] = "";
                Session[TK_CANHBAO.GQDON] = "8";
            }
            switch (loai_an)
            {
                case "COLUMN_1":
                    Session["MaChuongTrinh"] = "AN_HINHSU";
                    Response.Redirect("/QLAN/AHS/Hoso/Danhsach.aspx");
                    break;
                case "COLUMN_2":
                    Session["MaChuongTrinh"] = "AN_DANSU";
                    Response.Redirect("/QLAN/ADS/Hoso/Danhsach.aspx");
                    break;
                case "COLUMN_3":
                    Session["MaChuongTrinh"] = "AN_HNGD";
                    Response.Redirect("/QLAN/AHN/Hoso/Danhsach.aspx");
                    break;
                case "COLUMN_4":
                    Session["MaChuongTrinh"] = "AN_KDTM";
                    Response.Redirect("/QLAN/AKT/Hoso/Danhsach.aspx");
                    break;
                case "COLUMN_5":
                    Session["MaChuongTrinh"] = "AN_LAODONG";
                    Response.Redirect("/QLAN/ALD/Hoso/Danhsach.aspx");
                    break;
                case "COLUMN_6":
                    Session["MaChuongTrinh"] = "AN_HANHCHINH";
                    Response.Redirect("/QLAN/AHC/Hoso/Danhsach.aspx");                  
                    break;
            }
        }
        void ClearSession_TK()
        {
            Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
           
        }
        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTKT_Canhbao();
        }
        private void LoadCapXetXu()
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
                //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            //--------------------
        }
        void LoadDsThamPhan()
        {
            Decimal ToaAnID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            //Thống kê
            DateTime TuNgay = DateTime.Parse(txtTuNgay.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime DenNgay = DateTime.Parse(txtDenNgay.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            if (Session["TrangChu_ChanhAn_Page"] + "" != "")
            {
                hddPageIndex.Value = Session["TrangChu_ChanhAn_Page"] + "";
            }
            int pageindex = Convert.ToInt32(hddPageIndex.Value), page_size = Convert.ToInt32(dgTKThamphan.PageSize);
            OracleParameter[] parameters = new OracleParameter[]
                    {
                        new OracleParameter("vToaAnID",ToaAnID),
                        new OracleParameter("vTungay",TuNgay),
                        new OracleParameter("vDenngay",DenNgay),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.QLA_CHANH_AN_TRANG_CHU_TP", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                // trong procedure đã thêm 1 dòng tính tổng
                int Total = tbl.Rows.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, page_size).ToString();
                lstSobanghiB.Text = "Có <b>" + (Total - 1).ToString() + " </b> thẩm phán / <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgTKThamphan.CurrentPageIndex = pageindex - 1;
                dgTKThamphan.DataSource = tbl;
                dgTKThamphan.DataBind();
            }
            else
            {
                dgTKThamphan.CurrentPageIndex = 0;
                dgTKThamphan.DataSource = null;
                dgTKThamphan.DataBind();
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                Session["TrangChu_ChanhAn_Page"] = "";
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDsThamPhan();
            }
            catch (Exception ex) { LblthongBao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                Session["TrangChu_ChanhAn_Page"] = "";
                hddPageIndex.Value = "1";
                LoadDsThamPhan();
            }
            catch (Exception ex) { LblthongBao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                Session["TrangChu_ChanhAn_Page"] = "";
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDsThamPhan();
            }
            catch (Exception ex) { LblthongBao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                Session["TrangChu_ChanhAn_Page"] = "";
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDsThamPhan();
            }
            catch (Exception ex) { LblthongBao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                Session["TrangChu_ChanhAn_Page"] = "";
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDsThamPhan();
            }
            catch (Exception ex) { LblthongBao.Text = ex.Message; }
        }
        #endregion
        private void LoadData_PnChanhAn()
        {
            DateTime TuNgay = DateTime.Parse(txtTuNgay.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime DenNgay = DateTime.Parse(txtDenNgay.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            decimal YearNow = DateTime.Now.Year;
            decimal ToaAnID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            OracleParameter[] parameters = new OracleParameter[]
                    {
                        new OracleParameter("vToaAnID",ToaAnID),
                        new OracleParameter("vTungay",TuNgay),
                        new OracleParameter("vDenngay",DenNgay),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                    };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QLA_TH.QLA_CHANH_AN_TRANG_CHU", parameters);
            if (tbl.Rows.Count > 0)
            {
                decimal Sum_NHAPVUAN = 0, Sum_CHUYENVUAN = 0, Sum_AN_TON = 0, Sum_AN_CHO_THU_LY = 0, Sum_AN_THU_LY_CHUA_PC = 0, Sum_AN_THU_LY_DA_PC = 0,
                        Sum_DA_LEN_LICH_XET_XU = 0, Sum_DA_GIAI_QUYET = 0, Sum_CON_LAI = 0, Sum_AN_TDC = 0, Sum_AN_SUA_HUY = 0, Sum_AN_QH_DANG_GQ = 0, Sum_AN_QH_DA_GQ = 0;
                string link = Cls_Comon.GetRootURL() + "/UserControl/TP/DanhSachAn.aspx";
                #region Load sơ thẩm
                // Load sơ thẩm án hình sự
                #region row lẻ
                DataRow[] rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AHS'");
                DataRow row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text = "<tr class='le'>";
                ltrContent.Text += "<td rowspan='9' style='text-align: center;'>Sơ thẩm</td>";
                ltrContent.Text += "<td>Hình sự</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load sơ thẩm Án hình sự chưa thành niên
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AHS_CHUA_THANH_NIEN'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='chan'>";
                ltrContent.Text += "<td>Án hình sự chưa thành niên</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHS_CHUA_THANH_NIEN&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load sơ thẩm Dân sự
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'ADS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='le'>";
                ltrContent.Text += "<td>Dân sự</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ADS&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load sơ thẩm KDTM
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AKT'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='chan'>";
                ltrContent.Text += "<td>KDTM</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AKT&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load sơ thẩm Hành chính
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AHC'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='le'>";
                ltrContent.Text += "<td>Hành chính</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHC&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load sơ thẩm HNGĐ
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'AHN'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='chan'>";
                ltrContent.Text += "<td>HNGĐ</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=AHN&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load sơ thẩm Lao động
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'ALD'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='le'>";
                ltrContent.Text += "<td>Lao động</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=ALD&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load sơ thẩm Phá sản
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'APS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='chan'>";
                ltrContent.Text += "<td>Phá sản</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=APS&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load sơ thẩm BPXLHC
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'ST' and v_LOAIAN = 'XLHC'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='le'>";
                ltrContent.Text += "<td>BPXLHC</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=ST&loa=XLHC&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                #endregion
                #region Load phúc thẩm
                // Load phúc thẩm án hình sự
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AHS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='chan'>";
                ltrContent.Text += "<td rowspan='9' style='text-align: center;'>Phúc thẩm</td>";
                ltrContent.Text += "<td>Hình sự</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load phúc thẩm Án hình sự chưa thành niên
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AHS_CHUA_THANH_NIEN'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='le'>";
                ltrContent.Text += "<td>Án hình sự chưa thành niên</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHS_CHUA_THANH_NIEN&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load phúc thẩm Dân sự
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'ADS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='chan'>";
                ltrContent.Text += "<td>Dân sự</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ADS&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load phúc thẩm KDTM
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AKT'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='le'>";
                ltrContent.Text += "<td>KDTM</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AKT&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load phúc thẩm Hành chính
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AHC'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='chan'>";
                ltrContent.Text += "<td>Hành chính</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHC&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load phúc thẩm HNGĐ
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'AHN'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='le'>";
                ltrContent.Text += "<td>HNGĐ</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=AHN&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load phúc thẩm Lao động
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'ALD'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='chan'>";
                ltrContent.Text += "<td>Lao động</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=ALD&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load phúc thẩm Phá sản
                #region row lẻ
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'APS'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='le'>";
                ltrContent.Text += "<td>Phá sản</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=APS&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                // Load phúc thẩm BPXLHC
                #region row chẵn
                rows = tbl.Select("v_CAP_XET_XU = 'PT' and v_LOAIAN = 'XLHC'");
                row = rows[0];
                Sum_NHAPVUAN += Convert.ToDecimal(row["v_NHAPVUAN"]);
                Sum_CHUYENVUAN += Convert.ToDecimal(row["v_CHUYENVUAN"]);
                Sum_AN_TON += Convert.ToDecimal(row["v_AN_TON"]);
                Sum_AN_CHO_THU_LY += Convert.ToDecimal(row["v_AN_CHO_THU_LY"]);
                Sum_AN_THU_LY_CHUA_PC += Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]);
                Sum_AN_THU_LY_DA_PC += Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]);
                Sum_DA_LEN_LICH_XET_XU += Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]);
                Sum_DA_GIAI_QUYET += Convert.ToDecimal(row["v_DA_GIAI_QUYET"]);
                Sum_CON_LAI += Convert.ToDecimal(row["v_CON_LAI"]);
                Sum_AN_TDC += Convert.ToDecimal(row["v_AN_TDC"]);
                Sum_AN_SUA_HUY += Convert.ToDecimal(row["v_AN_SUA_HUY"]);
                Sum_AN_QH_DANG_GQ += Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]);
                Sum_AN_QH_DA_GQ += Convert.ToDecimal(row["v_AN_QH_DA_GQ"]);
                ltrContent.Text += "<tr class='chan'>";
                ltrContent.Text += "<td>BPXLHC</td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=NHAPVUAN" + "'>" + Convert.ToDecimal(row["v_NHAPVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=CHUYENVUAN" + "'>" + Convert.ToDecimal(row["v_CHUYENVUAN"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=AN_TON" + "'>" + Convert.ToDecimal(row["v_AN_TON"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=AN_CHO_THU_LY" + "'>" + Convert.ToDecimal(row["v_AN_CHO_THU_LY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=AN_THU_LY_CHUA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_CHUA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=AN_THU_LY_DA_PC" + "'>" + Convert.ToDecimal(row["v_AN_THU_LY_DA_PC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=DA_LEN_LICH_XET_XU" + "'>" + Convert.ToDecimal(row["v_DA_LEN_LICH_XET_XU"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=DA_GIAI_QUYET" + "'>" + Convert.ToDecimal(row["v_DA_GIAI_QUYET"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=CON_LAI" + "'>" + Convert.ToDecimal(row["v_CON_LAI"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=AN_TDC" + "'>" + Convert.ToDecimal(row["v_AN_TDC"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=AN_SUA_HUY" + "'>" + Convert.ToDecimal(row["v_AN_SUA_HUY"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=AN_QH_DANG_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DANG_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "<td style='text-align: right;'><a href='" + link + "?cxx=PT&loa=XLHC&ttk=AN_QH_DA_GQ" + "'>" + Convert.ToDecimal(row["v_AN_QH_DA_GQ"]).ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</a></td>";
                ltrContent.Text += "</tr>";
                #endregion
                #endregion
                #region row Tổng (row lẻ)
                ltrContent.Text += "<tr class='le'>";
                ltrContent.Text += "<td colspan='2' style='text-align: center; font-weight: bold;'>TỔNG</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_NHAPVUAN.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_CHUYENVUAN.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_TON.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_CHO_THU_LY.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_THU_LY_CHUA_PC.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_THU_LY_DA_PC.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_DA_LEN_LICH_XET_XU.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_DA_GIAI_QUYET.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_CON_LAI.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_TDC.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_SUA_HUY.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_QH_DANG_GQ.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "<td style='text-align: right; font-weight: bold;'>" + Sum_AN_QH_DA_GQ.ToString("#,0.###", new System.Globalization.CultureInfo("vi-VN")) + "</td>";
                ltrContent.Text += "</tr>";
                #endregion
            }
            Session["Data_ChanhAn_Home"] = tbl;
        }

        protected void dgTKThamphan_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            if (e.CommandName == "ChiTiet")
            {
                if (e.CommandArgument.ToString() + "" != "")
                {
                    Session["TrangChu_ChanhAn_TPID"] = e.CommandArgument.ToString();
                    Session["TrangChu_ChanhAn_Page"] = hddPageIndex.Value;
                    DateTime TuNgay = DateTime.Parse(txtTuNgay.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
                    DateTime DenNgay = DateTime.Parse(txtDenNgay.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
                    Session["TrangChu_ChanhAn_TuNgay"] = TuNgay;
                    Session["TrangChu_ChanhAn_DenNgay"] = DenNgay;
                    string link = Cls_Comon.GetRootURL() + "/UserControl/TP/ChiTietTP.aspx";
                    Response.Redirect(link);
                }
            }
        }

        protected void cmdInBaoCao_Click(object sender, EventArgs e)
        {
            Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_inbaocao_home()");
        }
    }
}