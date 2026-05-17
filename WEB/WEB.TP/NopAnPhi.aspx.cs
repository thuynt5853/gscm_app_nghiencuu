using BL.GSTP;
using BL.GSTP.ALD;
using BL.GSTP.AHC;
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
using System.IO;
using System.Configuration;
using WEB.TP.In;
using BL.GSTP.TP_THADS;
using BL.GSTP.BANGSETGET;
using Aspose.Words.Reporting;
using Aspose.Words;
using System.Text;
namespace WEB.TP
{
    public partial class NopAnPhi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DonID = 0, DuongSuID = 0; String DuongSuIDS = ""; String _hddPageIndex = "";
        string pathAnphiTempUpload = ConfigurationManager.AppSettings["AnphiTempUpload"];
        string hidTempUpload = ConfigurationManager.AppSettings["HidTempUpload"];
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hddURLKS.Value = Cls_Comon.GetRootURL() + "/FileUploadHandler.aspx";
                Decimal CurrUser = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                #region  Đoạn này để chạy không load balancing
                hddFileKySo.Value = Cls_Comon.GetRootURL() + "/TempUpload";
                #endregion

                #region Đoạn này để chạy load balancing
                //hddFileKySo.Value = hidTempUpload;
                #endregion
                if (CurrUser == 0)
                {
                    Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                }
                hdd_matb.Value = (String.IsNullOrEmpty(Request.QueryString["ma_tb"] + "")) ? "" : Convert.ToString(Request.QueryString["ma_tb"] + "");
                hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
                bmID.Value = (String.IsNullOrEmpty(Request["bmID"] + "")) ? "" : Convert.ToString(Request["bmID"] + "");
                DonID = (String.IsNullOrEmpty(Request["donID"] + "")) ? 0 : Convert.ToDecimal(Request["donID"] + "");
                DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
                DuongSuIDS = Request["dsIDS"] + "";

                hdd_tp_id.Value = (String.IsNullOrEmpty(Request.QueryString["tp_id"] + "")) ? "" : Convert.ToString(Request.QueryString["tp_id"] + "");

                _hddPageIndex = Request["hddPageIndex"] + "";

                Session["hddPageIndex"] = _hddPageIndex;
                //---------------------
                LoadDropDuongSu();
                LoadDropNopCho_DuongSu();
                LoadDropNhanCho_DuongSu();
                //---------------------
                //String[] arrst = ddlDuongSu.SelectedValue.Split(',');
                //if(arrst.Length==1)
                loadedit(DonID, Convert.ToString(DuongSuID), DuongSuIDS);
                hddid.Value = DonID.ToString();
                MenuPermission oPer = QT_TUPHAP_BL.GetMenuPer_THADS(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdSave, oPer.CAPNHAT);
                Check_TrangThaiGui();
               


            }
            //-----------them doan dk cho su kien upload file ------------------
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdSaveFileKyso);
            scriptManager.RegisterPostBackControl(this.cmdCloseFileKyso);
            scriptManager.RegisterPostBackControl(this.btnInBL);
            scriptManager.RegisterPostBackControl(this.lbtDownload);
        }
        void LoadDropDuongSu()
        {
            ////mai làm tiếp để xử lý load đương sự
            //String _style_panel = (String.IsNullOrEmpty(Request["style_panel"] + "")) ? "" : Convert.ToString(Request["style_panel"] + "");
            //hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            //DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            //DuongSuIDS = Request["dsIDS"] + "";
            //Decimal DONID = (String.IsNullOrEmpty(Request["donID"] + "")) ? 0 : Convert.ToDecimal(Request["donID"] + "");
            //ddlDuongSu.Items.Clear();

            //DataTable obj = new DataTable();

            //if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)
            //{

            //    AHN_DON don = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //    AHN_DON_DUONGSU_BL oDSBL = new AHN_DON_DUONGSU_BL();
            //    if (don.QHPLTKID == 1062)//2. Yêu cầu công nhận thuận tình ly hôn, thỏa thuận nuôi con, chia tài sản khi ly hôn
            //    {
            //        obj = oDSBL.AHN_DON_DUONGSU_GETLIST(DONID);
            //        ddlDuongSu.DataSource = obj;
            //        ddlDuongSu.DataTextField = "DUONGSU";
            //        ddlDuongSu.DataValueField = "ID";
            //        ddlDuongSu.DataBind();
            //        string ids = "";
            //        foreach (DataRow row in obj.Rows)
            //        {
            //            ids += row["ID"].ToString() + ",";
            //        }
            //        ddlDuongSu.Items.Insert(ddlDuongSu.Items.Count, new ListItem("Cả nguyên đơn và bị đơn", ids.Remove(ids.Length - 1)));
            //        ddlDuongSu.SelectedValue = Convert.ToString(DuongSuIDS);
            //    }
            //    else
            //    {
            //        obj = oDSBL.AHN_DON_DUONGSU_ANPHI(DONID);
            //        ddlDuongSu.DataSource = obj;
            //        ddlDuongSu.DataTextField = "TENDUONGSU";
            //        ddlDuongSu.DataValueField = "ID";
            //        ddlDuongSu.DataBind();
            //        ddlDuongSu.SelectedValue = Convert.ToString(DuongSuIDS);
            //        //   ddlDuongSu.SelectedIndex = 0;
            //    }
            //}
            //if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
            //{
            //    ADS_DON don = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //    ADS_DON_DUONGSU_BL oDSBL = new ADS_DON_DUONGSU_BL();

            //    obj = oDSBL.ADS_DON_DUONGSU_ANPHI(DONID);
            //    ddlDuongSu.DataSource = obj;
            //    ddlDuongSu.DataTextField = "TENDUONGSU";
            //    ddlDuongSu.DataValueField = "ID";
            //    ddlDuongSu.DataBind();
            //    // ddlDuongSu.SelectedIndex = 0;
            //    ddlDuongSu.SelectedValue = Convert.ToString(DuongSuID);
            //}
            //if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
            //{
            //    AKT_DON don = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //    AKT_DON_DUONGSU_BL oDSBL = new AKT_DON_DUONGSU_BL();

            //    obj = oDSBL.AKT_DON_DUONGSU_ANPHI(DONID);
            //    ddlDuongSu.DataSource = obj;
            //    ddlDuongSu.DataTextField = "TENDUONGSU";
            //    ddlDuongSu.DataValueField = "ID";
            //    ddlDuongSu.DataBind();
            //    ddlDuongSu.SelectedValue = Convert.ToString(DuongSuID);
            //    // ddlDuongSu.SelectedIndex = 0;
            //}
            //if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
            //{
            //    ALD_DON don = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //    ALD_DON_DUONGSU_BL oDSBL = new ALD_DON_DUONGSU_BL();

            //    obj = oDSBL.ALD_DON_DUONGSU_ANPHI(DONID);
            //    ddlDuongSu.DataSource = obj;
            //    ddlDuongSu.DataTextField = "TENDUONGSU";
            //    ddlDuongSu.DataValueField = "ID";
            //    ddlDuongSu.DataBind();
            //    ddlDuongSu.SelectedValue = Convert.ToString(DuongSuID);
            //    //ddlDuongSu.SelectedIndex = 0;
            //}
            //if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
            //{
            //    AHC_DON don = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
            //    AHC_DON_DUONGSU_BL oDSBL = new AHC_DON_DUONGSU_BL();

            //    obj = oDSBL.AHC_DON_DUONGSU_ANPHI(DONID);
            //    ddlDuongSu.DataSource = obj;
            //    ddlDuongSu.DataTextField = "TENDUONGSU";
            //    ddlDuongSu.DataValueField = "ID";
            //    ddlDuongSu.DataBind();
            //     ddlDuongSu.SelectedIndex = 0;
            //}

        }
        protected void ddlDuongSu_SelectedIndexChanged(object sender, EventArgs e)
        {
            //DonID = (String.IsNullOrEmpty(Request["donID"] + "")) ? 0 : Convert.ToDecimal(Request["donID"] + "");
            //String[] arrst = ddlDuongSu.SelectedValue.Split(',');
            //if (arrst.Length == 1)
            //    loadedit(DonID, Convert.ToString(arrst[0]));
            //else
            //{
            //    txtNguoiNop_HoTen.Text = txtNguoiNhan_Hoten.Text =ddlDuongSu.SelectedItem.Text;
            //    txtNguoiNop_CMND.Text = "";
            //    txtNguoiNop_NamSinh.Text = txtNguoiNop_Diachi.Text = "";
            //    txtNguoiNop_DienThoai.Text = "";
            //    txtNguoiNop_CMND.Enabled = txtNguoiNop_HoTen.Enabled = true;
            //    txtNguoiNop_NamSinh.Enabled = txtNguoiNop_Diachi.Enabled = true;
            //    txtNguoiNop_DienThoai.Enabled = true;
            //    dropNguoiNop_GioiTinh.Enabled = true;
            //    //---------------
            //    txtNguoiNhan_Namsinh.Text = "";
            //    txtNguoiNhan_CMND.Text = txtNguoiNhan_CMND.Text = "";
            //    txtNguoiNhan_DiaChiChitiet.Text = txtNguoiNhan_Dienthoai.Text = "";
            //    txtNguoiNhan_Hoten.Enabled = true;
            //    txtNguoiNhan_DiaChiChitiet.Enabled = true;
            //}
        }
        protected String Create_Sobienlai_app()
        {
            TAM_UNG_AN_PHI_BL oBLs = new TAM_UNG_AN_PHI_BL();
            String Sbl = "";
            DataTable tbl = oBLs.Create_Sobienlai_app(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Sbl = tbl.Rows[0]["SOBIENLAI"] + "";
            }
            return Sbl;
        }
        public void loadedit(decimal _DonID, String _DuongSuID, String _DuongSuIDs)
        {
            String _style_panel = (String.IsNullOrEmpty(Request["style_panel"] + "")) ? "" : Convert.ToString(Request["style_panel"] + "");
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");

            Decimal _TUPHAP_ANPHI_ID = (String.IsNullOrEmpty(Request["tp_id"] + "")) ? 0 : Convert.ToDecimal(Request["tp_id"] + "");
            TUPHAP_ANPHI_CN_BL M_Object = new TUPHAP_ANPHI_CN_BL();
            DataTable oDT = M_Object.TUPHAP_ANPHI_CN_GET_ID(_TUPHAP_ANPHI_ID);
            String V_TRANG_THAI = "";
            if (oDT.Rows.Count != 0)
            {
                V_TRANG_THAI = oDT.Rows[0]["TRANG_THAI"] + "";//V_TRANG_THAI 0  đang lưu,1 đã gửi,2 thu hồi
            }

            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            //String[] arrst = ddlDuongSu.SelectedValue.Split(',');
            //  if (arrst.Length == 1)
            //if(hdd_case.Value=="6")
            tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value, hdd_case.Value, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), DonID, _DuongSuID, _DuongSuIDs);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                hddDuongsu.Value = Cls_Comon.mf_sConvertVietnameseToEn(row["TENDUONGSU"].ToString());
            }
            //else
            //    tbl = oBL.Get_DONID_AnPhis(hdd_matb.Value, hdd_case.Value, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), DonID, _DuongSuID, _DuongSuIDs);
            //tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value,hdd_case.Value,Session[ENUM_SESSION.SESSION_USERNAME].ToString(),_DonID, _DuongSuID);
            //-----------
            if (_style_panel == "2")
            {
                // ddlDuongSu.Enabled = false;
                div_NopAnPhi.Style.Add("Display", "none");
                div_ANPHIHOANTRA.Style.Remove("Display");
                div_hoantraAnphi.Style.Remove("Display");
                must_input_NguoiNhan_Hoten.Style.Remove("Display");
                lbl_title_anphi.Text = "Thông tin hoàn trả án phí";
                cmdSave.Text = "Lưu";
                div_file_attach.Style.Add("Display", "none");
            }
            else
            {
                //if (_style_panel == "0")
                //{
                //    ddlDuongSu.Enabled = false;//true
                //}
                //else
                //    ddlDuongSu.Enabled = false;
                lbl_title_anphi.Text = "Thông tin nộp án phí";
                div_NopAnPhi.Style.Remove("Display");
                div_ANPHIHOANTRA.Style.Add("Display", "none");
                must_input_NguoiNhan_Hoten.Style.Add("Display", "none");
                cmdSave.Text = "Lưu và ký số";
                div_file_attach.Style.Remove("Display");
                div_hoantraAnphi.Style.Add("Display", "none");

            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                //---------------------
                if (row["TT_TRUCTUYEN"].ToString() == "0")//truc tiep
                {
                    cmdSave.Style.Remove("Display");
                }
                lbtDownload.Visible = false;
                lbtXoa.Visible = false;
                if (row["ANPHI_FILE_NAME"].ToString() != "")//truc tiep
                {
                    lbtDownload.Text = row["ANPHI_FILE_NAME"].ToString();
                    lbtDownload.Visible = true;
                    lbtXoa.Visible = true;

                }
                //if (row["TT_TRUCTUYEN"].ToString() == "1")//truc tuyen
                //{
                //    cmdSave.Style.Add("Display", "none");
                //}
                if (row["LOAIDUONGSU"].ToString() == "1")//ca nhan
                {
                   // txtNguoiNop_CMND_must_input.Style.Remove("Display");
                    //if (_style_panel == "2")
                    //{
                    //    txtNguoiNhan_CMND_must_input.Style.Remove("Display");
                    //}
                    //else
                    //{
                    //    txtNguoiNhan_CMND_must_input.Style.Add("Display", "none");
                    //}
                    div_gioitinh_namsinh.Style.Remove("Display");
                    div_gioitinh_namsinh_nhan.Style.Remove("Display");
                    lbl_gioitinh.Visible = true;
                    lbl_gioitinh_nhan.Visible = true;

                    txtNguoiNop_HoTen.Width = 219;
                    txtNguoiNhan_Hoten.Width = 219;
                    txtNguoiNhan_DiaChiChitiet.Width = 543;
                    txtNguoiNop_Diachi.Width = 543;
                    txtNguoiNhan_Email.Width = 543;
                }
                else if (row["LOAIDUONGSU"].ToString() != "1")//to chuc
                {
                    //txtNguoiNop_CMND_must_input.Style.Add("Display", "none");
                   //txtNguoiNhan_CMND_must_input.Style.Add("Display", "none");
                    div_gioitinh_namsinh.Style.Add("Display", "none");
                    div_gioitinh_namsinh_nhan.Style.Add("Display", "none");
                    lbl_gioitinh.Visible = false;
                    lbl_gioitinh_nhan.Visible = false;

                    txtNguoiNop_HoTen.Width = 543;
                    txtNguoiNhan_Hoten.Width = 543;
                    txtNguoiNhan_DiaChiChitiet.Width = 543;
                    txtNguoiNop_Diachi.Width = 543;
                    txtNguoiNhan_Email.Width = 543;
                }
                // if (row["SOBIENLAI"].ToString() == "")
                ////V_TRANG_THAI 0  đang lưu,1 đã gửi,2 thu hồi
                if (V_TRANG_THAI!="1")
                {
                    if (rdLoaiNguoiNop.SelectedValue == "0")
                    {
                        txtNguoiNop_CMND.Text = txtNguoiNop_HoTen.Text = "";
                        txtNOP_SO_CCCD.Text = txtNOP_SO_HO_CHIEU.Text = "";
                        txtNguoiNop_NamSinh.Text = txtNguoiNop_Diachi.Text = "";
                        txtNguoiNop_DienThoai.Text = "";

                        txtNguoiNop_CMND.Enabled = txtNguoiNop_HoTen.Enabled = true;                       
                        txtNguoiNop_CMND.CssClass = "textbox remove_bg_Disable";

                        txtNOP_SO_CCCD.Enabled = true;
                        txtNOP_SO_CCCD.CssClass = "textbox remove_bg_Disable";

                        txtNOP_SO_HO_CHIEU.Enabled = true;
                        txtNOP_SO_HO_CHIEU.CssClass = "textbox remove_bg_Disable";

                        txtNguoiNop_HoTen.CssClass = "textbox remove_bg_Disable";

                        txtNguoiNop_NamSinh.Enabled = txtNguoiNop_Diachi.Enabled = true;
                        txtNguoiNop_NamSinh.CssClass = "textbox remove_bg_Disable";
                        txtNguoiNop_Diachi.CssClass = "textbox remove_bg_Disable";

                        txtNguoiNop_DienThoai.Enabled = true;
                        txtNguoiNop_DienThoai.CssClass = "textbox remove_bg_Disable";
                        dropNguoiNop_GioiTinh.Enabled = true;
                        dropNguoiNop_GioiTinh.CssClass = "textbox remove_bg_Disable";
                        ddl_NopCho_DuongSu.SelectedValue = row["NOPCHO_DUONGSUID"].ToString();
                    }
                    else if (rdLoaiNguoiNop.SelectedValue == "1")
                    {
                        txtNguoiNop_HoTen.Enabled = false;
                        txtNguoiNop_HoTen.CssClass = "textbox bg_Disable";
                        //---------------
                        if (row["SOCMND"].ToString() == "")
                        {
                            txtNguoiNop_CMND.Enabled = true;
                            txtNguoiNop_CMND.CssClass = "textbox remove_bg_Disable";
                        }
                        if (row["SOCMND"].ToString() != "")
                        {
                            txtNguoiNop_CMND.Enabled = false;
                            txtNguoiNop_CMND.CssClass = "textbox bg_Disable";
                        }
                        //---------------
                        if (row["NOP_SO_CCCD"].ToString() == "")
                        {
                            txtNOP_SO_CCCD.Enabled = true;
                            txtNOP_SO_CCCD.CssClass = "textbox remove_bg_Disable";
                        }
                        if (row["NOP_SO_CCCD"].ToString() != "")
                        {
                            txtNOP_SO_CCCD.Enabled = false;
                            txtNOP_SO_CCCD.CssClass = "textbox bg_Disable";
                        }
                        //---------------
                        if (row["NOP_SO_HO_CHIEU"].ToString() == "")
                        {
                            txtNOP_SO_CCCD.Enabled = true;
                            txtNOP_SO_CCCD.CssClass = "textbox remove_bg_Disable";
                        }
                        if (row["NOP_SO_HO_CHIEU"].ToString() != "")
                        {
                            txtNOP_SO_CCCD.Enabled = false;
                            txtNOP_SO_CCCD.CssClass = "textbox bg_Disable";
                        }
                        //---------------
                        txtNguoiNop_NamSinh.Enabled = false;
                        txtNguoiNop_NamSinh.CssClass = "textbox bg_Disable";

                        txtNguoiNop_Diachi.Enabled = true;                        
                        txtNguoiNop_Diachi.CssClass = "textbox remove_bg_Disable";

                        txtNguoiNop_DienThoai.Enabled = true;
                        txtNguoiNop_DienThoai.CssClass = "textbox remove_bg_Disable";

                        dropNguoiNop_GioiTinh.Enabled = false;
                        dropNguoiNop_GioiTinh.CssClass = "textbox bg_Disable";

                        txtNguoiNop_HoTen.Text = row["TENDUONGSU"].ToString();

                        txtNguoiNop_CMND.Text = row["SOCMND"].ToString();
                        txtNOP_SO_CCCD.Text = row["NOP_SO_CCCD"].ToString();
                        txtNOP_SO_HO_CHIEU.Text = row["NOP_SO_HO_CHIEU"].ToString();

                        txtNguoiNop_NamSinh.Text = row["NAMSINH"].ToString();
                        txtNguoiNop_Diachi.Text = row["DIACHI"].ToString();
                        txtNguoiNop_DienThoai.Text = row["DIENTHOAI"].ToString();
                        dropNguoiNop_GioiTinh.SelectedValue = row["GIOITINH"].ToString();
                        txtTamUngAP.Text = ((decimal)row["TAMUNGANPHI"]).ToString("#,0.###", cul);
                    }
                    if (rdLoaiNguoiNhan.SelectedValue == "0")
                    {
                        txtNguoiNhan_Hoten.Text = txtNguoiNhan_Namsinh.Text = "";
                        txtNguoiNhan_CMND.Text =""; txtHOANTRAAP_SO_CCCD.Text = ""; txtHOANTRAAP_SO_HO_CHIEU.Text = "";

                        txtNguoiNhan_DiaChiChitiet.Text = txtNguoiNhan_Dienthoai.Text = "";
                        txtNguoiNhan_Hoten.Enabled = true;
                        txtNguoiNhan_DiaChiChitiet.Enabled = true;

                        txtNguoiNhan_CMND.Enabled = true;
                        txtNguoiNhan_CMND.CssClass = "textbox remove_bg_Disable";

                        txtHOANTRAAP_SO_CCCD.Enabled = true;
                        txtHOANTRAAP_SO_CCCD.CssClass = "textbox remove_bg_Disable";

                        txtHOANTRAAP_SO_HO_CHIEU.Enabled = true;
                        txtHOANTRAAP_SO_HO_CHIEU.CssClass = "textbox remove_bg_Disable";

                        div_ddl_NhanCho_DuongSu.Style.Remove("Display");
                        ddl_NhanCho_DuongSu.SelectedValue = row["NHANCHO_DUONGSUID"].ToString();
                    }
                    else if (rdLoaiNguoiNhan.SelectedValue == "1")
                    {
                        txtNguoiNhan_Hoten.Text = row["TENDUONGSU"].ToString();

                        txtNguoiNhan_CMND.Text = row["SOCMND"].ToString();
                        txtHOANTRAAP_SO_CCCD.Text = row["HOANTRAAP_SO_CCCD"].ToString();
                        txtHOANTRAAP_SO_HO_CHIEU.Text = row["HOANTRAAP_SO_HO_CHIEU"].ToString();

                        txtNguoiNhan_Namsinh.Text = row["NAMSINH"].ToString();
                        txtNguoiNhan_DiaChiChitiet.Text = row["DIACHI"].ToString();
                        txtNguoiNhan_Dienthoai.Text = row["DIENTHOAI"].ToString();
                        dropNguoiNhan_GioiTinh.SelectedValue = row["GIOITINH"].ToString();
                        txtTamUngAP.Text = ((decimal)row["TAMUNGANPHI"]).ToString("#,0.###", cul);

                        txtNguoiNhan_Hoten.Enabled = false;
                        txtNguoiNhan_Hoten.CssClass = "textbox bg_Disable";

                        txtNguoiNhan_DiaChiChitiet.Enabled = false;
                        txtNguoiNhan_DiaChiChitiet.CssClass = "textbox bg_Disable";

                        txtNguoiNhan_CMND.Enabled = false;
                        txtNguoiNhan_CMND.CssClass = "textbox bg_Disable";

                        txtHOANTRAAP_SO_CCCD.Enabled = false;
                        txtHOANTRAAP_SO_CCCD.CssClass = "textbox bg_Disable";

                        txtHOANTRAAP_SO_HO_CHIEU.Enabled = false;
                        txtHOANTRAAP_SO_HO_CHIEU.CssClass = "textbox bg_Disable";

                        txtNguoiNhan_Email.Text = row["EMAIL"].ToString();
                    }
                 
                    txtSoBienLai.Text = Create_Sobienlai_app();
                    //txtNGAYBIENLAI.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    txtSoBienLai.Enabled = true; txtNGAYBIENLAI.Enabled = true;
                    //btnNBInBL.Visible = false;
                    btnInBL.Visible = false;
                    // btnKyso.Visible = false;
                    if (row["SOBIENLAI"].ToString() != "")
                    {
                        txtSoBienLai.Text = row["SOBIENLAI"].ToString();
                    }
                    if (row["NGAYBIENLAI"].ToString() != "")
                    {
                        txtNGAYBIENLAI.Text = ((String.IsNullOrEmpty(row["NGAYBIENLAI"] + "")) || (((DateTime)row["NGAYBIENLAI"]) == DateTime.MinValue)) ? "" : ((DateTime)row["NGAYBIENLAI"]).ToString("dd/MM/yyyy", cul);
                    }
                }
                else
                {
                    rdLoaiNguoiNop.SelectedValue = row["NOP_ISNGUYENDON"].ToString();
                    txtNguoiNop_HoTen.Text = row["NOP_HOTEN"].ToString();
                    dropNguoiNop_GioiTinh.SelectedValue = row["NOP_GIOITINH"].ToString();
                    txtNguoiNop_NamSinh.Text = row["NOP_NAMSINH"].ToString();

                    txtNguoiNop_CMND.Text = row["NOP_CMND"].ToString();
                    txtNOP_SO_CCCD.Text = row["NOP_SO_CCCD"].ToString();
                    txtNOP_SO_HO_CHIEU.Text = row["NOP_SO_HO_CHIEU"].ToString();

                    txtNguoiNop_DienThoai.Text = row["NOP_TEL"].ToString();
                    txtNguoiNop_Diachi.Text = row["NOP_DIACHI"].ToString();
                    //---------------
                    rdLoaiNguoiNhan.SelectedValue = row["HOANTRAAP_ISNGUYENDON"].ToString();
                    txtNguoiNhan_Hoten.Text = row["HOANTRAAP_HOTEN"].ToString();
                    dropNguoiNhan_GioiTinh.SelectedValue = row["HOANTRAAP_GIOITINH"].ToString();
                    txtNguoiNhan_Namsinh.Text = row["HOANTRAAP_NAMSINH"].ToString();

                    txtNguoiNhan_CMND.Text = row["HOANTRAAP_CMND"].ToString();
                    txtHOANTRAAP_SO_CCCD.Text = row["HOANTRAAP_SO_CCCD"].ToString();
                    txtHOANTRAAP_SO_HO_CHIEU.Text = row["HOANTRAAP_SO_HO_CHIEU"].ToString();

                    txtNguoiNhan_Dienthoai.Text = row["HOANTRAAP_TEL"].ToString();
                    txtNguoiNhan_Email.Text = row["HOANTRAAP_EMAIL"].ToString();
                    txtNguoiNhan_DiaChiChitiet.Text = row["HOANTRAAP_DIACHI"].ToString();
                    //----------------
                    txtSoBienLai.Text = row["SOBIENLAI"].ToString();
                    txtTamUngAP.Text = ((decimal)row["TAMUNGANPHI"]).ToString("#,0.###", cul);
                    txtNGAYBIENLAI.Text = ((String.IsNullOrEmpty(row["NGAYBIENLAI"] + "")) || (((DateTime)row["NGAYBIENLAI"]) == DateTime.MinValue)) ? "" : ((DateTime)row["NGAYBIENLAI"]).ToString("dd/MM/yyyy", cul);
                    //--------------
                    if (_style_panel == "2")
                    {
                        //btnNBInBL.Visible = false;
                        // btnKyso.Visible = false;
                        btnInBL.Visible = false;
                    }
                    else
                    {
                        //btnNBInBL.Visible = true;
                        // btnKyso.Visible = true;
                        if (txtNGAYBIENLAI.Text.Trim() == "")
                        {
                            btnInBL.Visible = false;
                        }
                        else
                        {
                            btnInBL.Visible = true;
                        }
                    }
                    if (row["NOP_ISNGUYENDON"].ToString() == "1")
                    {
                        txtNguoiNop_HoTen.Enabled = false;                      
                        txtNguoiNop_HoTen.CssClass = "textbox bg_Disable";
                        //txtNguoiNop_Diachi.Enabled = false;
                        //txtNguoiNop_Diachi.CssClass = "textbox bg_Disable";

                        div_ddl_NopCho_DuongSu.Style.Add("Display", "none");

                        if (row["NOP_CMND"].ToString() == "")
                        {
                            txtNguoiNop_CMND.Enabled = true;
                            txtNguoiNop_CMND.CssClass = "textbox remove_bg_Disable";
                        }
                        if (row["NOP_CMND"].ToString() != "")
                        {
                            txtNguoiNop_CMND.Enabled = false;
                            txtNguoiNop_CMND.CssClass = "textbox bg_Disable";
                        }
                        //---------------
                        if (row["NOP_SO_CCCD"].ToString() == "")
                        {
                            txtNOP_SO_CCCD.Enabled = true;
                            txtNOP_SO_CCCD.CssClass = "textbox remove_bg_Disable";
                        }
                        if (row["NOP_SO_CCCD"].ToString() != "")
                        {
                            txtNOP_SO_CCCD.Enabled = false;
                            txtNOP_SO_CCCD.CssClass = "textbox bg_Disable";
                        }
                        //---------------
                        if (row["NOP_SO_HO_CHIEU"].ToString() == "")
                        {
                            txtNOP_SO_CCCD.Enabled = true;
                            txtNOP_SO_CCCD.CssClass = "textbox remove_bg_Disable";
                        }
                        if (row["NOP_SO_HO_CHIEU"].ToString() != "")
                        {
                            txtNOP_SO_CCCD.Enabled = false;
                            txtNOP_SO_CCCD.CssClass = "textbox bg_Disable";
                        }
                    }
                    else if (row["NOP_ISNGUYENDON"].ToString() == "0")
                    {
                        txtNguoiNop_HoTen.Enabled = true;
                        txtNguoiNop_HoTen.CssClass = "textbox remove_bg_Disable";
                        txtNguoiNop_Diachi.Enabled = true;
                        txtNguoiNop_Diachi.CssClass = "textbox remove_bg_Disable";
                        div_ddl_NopCho_DuongSu.Style.Remove("Display");
                        ddl_NopCho_DuongSu.SelectedValue = row["NOPCHO_DUONGSUID"].ToString();

                        txtNguoiNop_CMND.Enabled = true;
                        txtNguoiNop_CMND.CssClass = "textbox remove_bg_Disable";                     

                        txtNOP_SO_CCCD.Enabled = true;
                        txtNOP_SO_CCCD.CssClass = "textbox remove_bg_Disable";
                      
                        txtNOP_SO_HO_CHIEU.Enabled = true;
                        txtNOP_SO_HO_CHIEU.CssClass = "textbox remove_bg_Disable";
                    }
                    if (row["HOANTRAAP_ISNGUYENDON"].ToString() == "1")
                    {
                        txtNguoiNhan_Hoten.Enabled = false;
                        txtNguoiNhan_Hoten.CssClass = "textbox bg_Disable";
                        txtNguoiNhan_DiaChiChitiet.Enabled = false;
                        txtNguoiNhan_DiaChiChitiet.CssClass = "textbox bg_Disable";

                        txtNguoiNhan_CMND.Enabled = false;
                        txtNguoiNhan_CMND.CssClass = "textbox bg_Disable";

                        txtHOANTRAAP_SO_CCCD.Enabled = false;
                        txtHOANTRAAP_SO_CCCD.CssClass = "textbox bg_Disable";

                        txtNOP_SO_HO_CHIEU.Enabled = false;
                        txtNOP_SO_HO_CHIEU.CssClass = "textbox bg_Disable";

                    }
                    else if (row["HOANTRAAP_ISNGUYENDON"].ToString() == "0")
                    {
                        txtNguoiNhan_Hoten.Enabled = true;
                        txtNguoiNhan_Hoten.CssClass = "textbox remove_bg_Disable";
                        txtNguoiNhan_DiaChiChitiet.Enabled = true;
                        txtNguoiNhan_DiaChiChitiet.CssClass = "textbox remove_bg_Disable";

                        div_ddl_NhanCho_DuongSu.Style.Remove("Display");
                        ddl_NhanCho_DuongSu.SelectedValue = row["NHANCHO_DUONGSUID"].ToString();

                        txtNguoiNhan_CMND.Enabled = true;
                        txtNguoiNhan_CMND.CssClass = "textbox remove_bg_Disable";

                        txtNOP_SO_CCCD.Enabled = true;
                        txtNOP_SO_CCCD.CssClass = "textbox remove_bg_Disable";

                        txtNOP_SO_HO_CHIEU.Enabled = true;
                        txtNOP_SO_HO_CHIEU.CssClass = "textbox remove_bg_Disable";
                    }
                   
                    txtNguoiNop_NamSinh.Enabled = true;
                    txtNguoiNop_NamSinh.CssClass = "textbox remove_bg_Disable";

                    txtNguoiNop_DienThoai.Enabled = true;
                    txtNguoiNop_DienThoai.CssClass = "textbox remove_bg_Disable";
                    dropNguoiNop_GioiTinh.Enabled = true;
                    dropNguoiNop_GioiTinh.CssClass = "textbox remove_bg_Disable";
                    //27/11/2024
                    hdd_SOTL.Value = row["SOTHULY"].ToString();
                    if (row["SOTHULY"].ToString() != "")
                    {
                        txtSoBienLai.Enabled = false;
                        txtNGAYBIENLAI.Enabled = false;
                    }
                    Decimal _ANPHI_ID = (String.IsNullOrEmpty(Request["ANPHI_ID"] + "")) ? 0 : Convert.ToDecimal(Request["ANPHI_ID"] + "");
                    hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
                    String V_LOAI_AN = hdd_case.Value;
                    TUPHAP_QLA_BL oBLs = new TUPHAP_QLA_BL();
                    var tblAP = oBLs.GET_ENABLE_ANPHI(_ANPHI_ID, V_LOAI_AN);
                    if (tblAP != null && tblAP.Rows.Count > 0)
                    {
                        var rowAP = tblAP.Rows[0];
                        if (_style_panel != "2")
                        {
                            if (rowAP["ENABLE"].ToString() != "1")
                            {
                                txtSoBienLai.Enabled = true;
                                txtNGAYBIENLAI.Enabled = true;
                            }
                        }
                    }
                    if (row["ANPHIHOANTRA"].ToString() != "0")
                    {
                        txt_ANPHIHOANTRA.Text = ((decimal)row["ANPHIHOANTRA"]).ToString("#,0.###", cul);
                        txt_NGAYHOANTRA.Text = row["NGAYHOANTRA"].ToString();
                    }
                    else if (row["ANPHIHOANTRA"].ToString() == "0")
                    {
                        if (_style_panel == "2")
                        {
                            txt_ANPHIHOANTRA.Text = txtTamUngAP.Text;
                            txt_NGAYHOANTRA.Text = DateTime.Now.ToString("dd/MM/yyyy");
                        }
                        else
                        {
                            txt_ANPHIHOANTRA.Text = "0";
                            txt_NGAYHOANTRA.Text = DateTime.Now.ToString("dd/MM/yyyy");
                        }
                    }

                }
                txtNGUOITHUTIEN.Text = row["NGUOITHUTIEN"].ToString();
                txt_GHICHU_HOANTRA.Text = row["GHICHU_HOANTRA"].ToString();
            }
        }
        protected void btnNBInBL_Click(object sender, EventArgs e)
        {
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            decimal _DonID = Convert.ToDecimal(hddid.Value);
            TUPHAP_ANPHI oT = dt.TUPHAP_ANPHI.Where(x => x.VUVIECID == _DonID).FirstOrDefault();
            if (oT != null)
            {
                TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value, hdd_case.Value, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), _DonID, Convert.ToString(DuongSuID), DuongSuIDS);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                }
                //-------------
                TP_ANPHI objds = new TP_ANPHI();//data set
                TP_ANPHI.TUPHAP_ANPHIRow r = objds.TUPHAP_ANPHI.NewTUPHAP_ANPHIRow();
                r.NGAY_BIENLAI = row["NGAY_BIENLAI"].ToString();
                r.THANG_BIENLAI = row["THANG_BIENLAI"].ToString();
                r.NAM_BIENLAI = row["NAM_BIENLAI"].ToString();
                r.SOBIENLAI = row["SOBIENLAI"].ToString();
                r.NGUOINOPTIEN = row["TENDUONGSU"].ToString();
                r.DIACHI = row["NOP_DIACHI"].ToString();
                r.SO_THONGBAO = row["SOTHONGBAO"].ToString();
                r.NGAY_THONGBAO = row["NGAY_THONGBAO"].ToString();
                r.THANG_THONGBAO = row["THANG_THONGBAO"].ToString();
                r.NAM_THONG_BAO = row["NAM_THONGBAO"].ToString();
                r.DONVI_THA = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                r.TEN_TOAAN = row["MA_TEN"].ToString();
                r.TAMUNG_ANPHI = row["TAMUNGANPHI_01"].ToString();
                r.TAMUNGBANGCHU = Cls_Comon.NumberToTextVN(Convert.ToDecimal(row["TAMUNGANPHI"].ToString()));
                r.NGUOI_THU_TIEN = row["NGUOITHUTIEN"].ToString();
                r.NOP_CMND = row["NOP_CMND"].ToString();
                //-----------------------------
                objds.TUPHAP_ANPHI.AddTUPHAP_ANPHIRow(r);
                objds.AcceptChanges();
                //-----------------------
                Session["BIENLAI_DATASET"] = objds;
                Session["CHON_DATASET"] = "BIENLAI_DATASET";
                string StrMsg = "PopupReport('In/ViewReport.aspx','Biên lai án phí',800,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(Ajax_Manager_Updata, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
            else
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(Ajax_Manager_Updata, this.GetType(), "Alert", "alert(' Bạn phải lưu thông tin án phí trước.' )", true);
            }
        }
        #region Report
        protected void btnInBL_Click(object sender, EventArgs e)
        {
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            decimal _DonID = Convert.ToDecimal(hddid.Value);
            TUPHAP_ANPHI oT = dt.TUPHAP_ANPHI.Where(x => x.VUVIECID == _DonID).FirstOrDefault();
            if (oT != null)
            {
                TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value, hdd_case.Value, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), _DonID, Convert.ToString(DuongSuID), DuongSuIDS);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                }
                //-------------
                TP_ANPHI objds = new TP_ANPHI();//data set
                TP_ANPHI.TUPHAP_ANPHIRow r = objds.TUPHAP_ANPHI.NewTUPHAP_ANPHIRow();
                r.NGAY_BIENLAI = row["NGAY_BIENLAI"].ToString();
                r.THANG_BIENLAI = row["THANG_BIENLAI"].ToString();
                r.NAM_BIENLAI = row["NAM_BIENLAI"].ToString();
                r.SOBIENLAI = row["SOBIENLAI"].ToString();
                r.NGUOINOPTIEN = row["TENDUONGSU"].ToString();
                r.DIACHI = row["NOP_DIACHI"].ToString();
                r.SO_THONGBAO = row["SOTHONGBAO"].ToString();
                r.NGAY_THONGBAO = row["NGAY_THONGBAO"].ToString();
                r.THANG_THONGBAO = row["THANG_THONGBAO"].ToString();
                r.NAM_THONG_BAO = row["NAM_THONGBAO"].ToString();
                //r.DONVI_THA = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                r.DONVI_THA = Session["CAP_CUC"] + "";
                r.TEN_TOAAN = row["DONVI"].ToString();
                r.TAMUNG_ANPHI = row["TAMUNGANPHI_01"].ToString();
                r.TAMUNGBANGCHU = Cls_Comon.NumberToTextVN(Convert.ToDecimal(row["TAMUNGANPHI"].ToString()));
                //r.NGUOI_THU_TIEN = row["NGUOITHUTIEN"].ToString();
                r.NGUOI_THU_TIEN = row["DONVI_THUTIEN_TEN"].ToString();
                r.NOP_CMND = row["NOP_CMND"].ToString();
                r.MA_THONGBAO = row["MA_THONGBAO"].ToString();
                r.NAM_BLTU = row["KH_BIENLAI"].ToString();
                if (r.DONVI_THA == r.NGUOI_THU_TIEN)
                {
                    r.CAP_CHICUC = "";
                }
                else
                {
                    r.CAP_CHICUC = r.NGUOI_THU_TIEN;
                }
                //-----------------------------
                objds.TUPHAP_ANPHI.AddTUPHAP_ANPHIRow(r);
                objds.AcceptChanges();
                
                string path = "~/ReportTemplates/BienLaiAnPhi.doc";
                //string file = "BienLaiAnPhi_" + row["MA_THONGBAO"].ToString() + ".doc";
                try
                {
                    Aspose.Words.Document doc = new Aspose.Words.Document(Server.MapPath(path));
                    
                    doc.MailMerge.Execute(objds.Tables[0]);
                    
                    // Đường dẫn lưu file PDF trên server 
                    // Chuyển đường dẫn lưu file PDF đã được chỉ định sẵn
                    //string folder_upload = "/TempUpload/";
                    string fileName = row["MA_THONGBAO"].ToString() + "_" + Cls_Comon.mf_sConvertVietnameseToEn(row["TENDUONGSU"].ToString()) + ".pdf";
                    //string pdfFilePath = Path.Combine(Server.MapPath(folder_upload), fileName);
                    // Lưu tài liệu dưới dạng PDF 
                    //doc.Save(pdfFilePath, Aspose.Words.SaveFormat.Pdf);

                    //doc.Save(Response, file, Aspose.Words.ContentDisposition.Attachment, Aspose.Words.Saving.SaveOptions.CreateSaveOptions(Aspose.Words.SaveFormat.Doc));
                    // Lưu tài liệu vào MemoryStream dưới dạng PDF 
                    using (MemoryStream pdfStream = new MemoryStream())
                    {
                        doc.Save(pdfStream, Aspose.Words.SaveFormat.Pdf);
                        pdfStream.Position = 0;
                        // Gửi file PDF tới trình duyệt 
                        Response.ContentType = "application/pdf";
                        Response.AppendHeader("Content-Disposition", $"attachment; filename={fileName}");
                        Response.BinaryWrite(pdfStream.ToArray());
                        HttpContext.Current.ApplicationInstance.CompleteRequest();
                    }
                }
                catch (Exception ex)
                {
                    // Ghi nhật ký lỗi 
                    Response.Write($"Error: {ex.Message}");
                }
            }
            else
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(Ajax_Manager_Updata, this.GetType(), "Alert", "alert(' Bạn phải lưu thông tin án phí trước.' )", true);
            }
        }
        #endregion
        protected void btnKyso_Click(object sender, EventArgs e)
        {
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            decimal _DonID = Convert.ToDecimal(hddid.Value);
            TUPHAP_ANPHI oT = dt.TUPHAP_ANPHI.Where(x => x.VUVIECID == _DonID).FirstOrDefault();
            if (oT != null)
            {
                TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value, hdd_case.Value, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), _DonID, Convert.ToString(DuongSuID), DuongSuIDS);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                }
                //-------------
                TP_ANPHI objds = new TP_ANPHI();//data set
                TP_ANPHI.TUPHAP_ANPHIRow r = objds.TUPHAP_ANPHI.NewTUPHAP_ANPHIRow();
                r.NGAY_BIENLAI = row["NGAY_BIENLAI"].ToString();
                r.THANG_BIENLAI = row["THANG_BIENLAI"].ToString();
                r.NAM_BIENLAI = row["NAM_BIENLAI"].ToString();
                r.SOBIENLAI = row["SOBIENLAI"].ToString();
                r.NGUOINOPTIEN = row["TENDUONGSU"].ToString();
                r.DIACHI = row["NOP_DIACHI"].ToString();
                r.SO_THONGBAO = row["SOTHONGBAO"].ToString();
                r.NGAY_THONGBAO = row["NGAY_THONGBAO"].ToString();
                r.THANG_THONGBAO = row["THANG_THONGBAO"].ToString();
                r.NAM_THONG_BAO = row["NAM_THONGBAO"].ToString();
                //r.DONVI_THA = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                r.DONVI_THA = Session["CAP_CUC"] + "";
                r.TEN_TOAAN = row["DONVI"].ToString();
                r.TAMUNG_ANPHI = row["TAMUNGANPHI_01"].ToString();
                r.TAMUNGBANGCHU = Cls_Comon.NumberToTextVN(Convert.ToDecimal(row["TAMUNGANPHI"].ToString()));
                //r.NGUOI_THU_TIEN = row["NGUOITHUTIEN"].ToString();
                r.NGUOI_THU_TIEN = row["DONVI_THUTIEN_TEN"].ToString();
                r.NOP_CMND = row["NOP_CMND"].ToString();
                r.MA_THONGBAO = row["MA_THONGBAO"].ToString();
                r.NAM_BLTU = row["KH_BIENLAI"].ToString();
                if (r.DONVI_THA == r.NGUOI_THU_TIEN)
                {
                    r.CAP_CHICUC = "";
                }
                else
                {
                    r.CAP_CHICUC = r.NGUOI_THU_TIEN;
                }
                //-----------------------------
                objds.TUPHAP_ANPHI.AddTUPHAP_ANPHIRow(r);
                objds.AcceptChanges();

                //KhanhPQ_Begin-----------------------

                //string path = Server.MapPath("~/ReportTemplates/BienLaiAnPhi.docx");
                //string file = "BienLaiAnPhi_" + row["MA_THONGBAO"].ToString() + ".docx";
                //Aspose.Words.Document doc = new Aspose.Words.Document(path);

                //doc.MailMerge.FieldMergingCallback = new HandleMergeImageFieldFromBlob();
                //doc.MailMerge.Execute(tbl);

                //doc.Save(Response, file, Aspose.Words.ContentDisposition.Attachment, Aspose.Words.Saving.SaveOptions.CreateSaveOptions(Aspose.Words.SaveFormat.Doc));

                //KhanhPQ_End-------------------------
                //--------
                //Session["BIENLAIKYSO_DATASET"] = objds;
                //Session["CHON_DATASET"] = "BIENLAIKYSO_DATASET";
                //string StrMsg = "PopupReportSign('In/ViewReport.aspx','Biên lai án phí',800,800);";
                //System.Web.UI.ScriptManager.RegisterStartupScript(Ajax_Manager_Updata, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                //---Ký số
                string path = "~/ReportTemplates/BienLaiAnPhi.doc";
                //string file = "BienLaiAnPhi_" + row["MA_THONGBAO"].ToString() + ".doc";
                try
                {
                    Aspose.Words.Document doc = new Aspose.Words.Document(Server.MapPath(path));

                    doc.MailMerge.Execute(objds.Tables[0]);

                    try
                    {
                        #region Đoạn này để chạy không load balancing
                        // Đường dẫn lưu file PDF trên server 
                        // Chuyển đường dẫn lưu file PDF đã được chỉ định sẵn
                        string folder_upload = "/TempUpload/";
                        string file_path = Server.MapPath(folder_upload);
                        if (!Directory.Exists(file_path))
                            Directory.CreateDirectory(file_path);
                        string fileName = row["MA_THONGBAO"].ToString() + "_" + Cls_Comon.mf_sConvertVietnameseToEn(row["TENDUONGSU"].ToString()) + ".pdf";
                        string pdfFilePath = Path.Combine(Server.MapPath(folder_upload), fileName);
                        // Lưu tài liệu dưới dạng PDF
                        doc.Save(pdfFilePath, Aspose.Words.SaveFormat.Pdf);
                        #endregion

                        #region Đoạn này để chạy load balancing
                        //--Đường dẫn lưu file
                        //string fileName = row["MA_THONGBAO"].ToString() + "_" + Cls_Comon.mf_sConvertVietnameseToEn(row["TENDUONGSU"].ToString()) + ".pdf";
                        //if (!Directory.Exists(pathAnphiTempUpload))
                        //    Directory.CreateDirectory(pathAnphiTempUpload);
                        //string saveAs = Path.Combine(pathAnphiTempUpload, fileName); //file_path + fileName;
                        //Lưu tài liệu dưới dạng PDF
                        //doc.Save(saveAs, Aspose.Words.SaveFormat.Pdf);
                        #endregion

                    }
                    catch (UnauthorizedAccessException ex)
                    {
                        // Ghi log lỗi quyền truy cập 
                        if (!Directory.Exists(@"C:\Logs"))
                            Directory.CreateDirectory(@"C:\Logs");
                        File.WriteAllText(@"C:\Logs\unauthorized_access_log.txt", ex.ToString());
                        throw;
                    }
                    catch (Exception ex)
                    {
                        // Ghi log lỗi chung 
                        if (!Directory.Exists(@"C:\Logs"))
                            Directory.CreateDirectory(@"C:\Logs");
                        File.WriteAllText(@"C:\Logs\error_log.txt", ex.ToString());
                        throw;
                    }

                    //string strKyso = "exc_sign_approved();";
                    string strKyso = "checkUrlAndExecute();";
                    System.Web.UI.ScriptManager.RegisterStartupScript(Ajax_Manager_Updata, this.GetType(), Guid.NewGuid().ToString(), strKyso, true);
                }
                catch (Exception ex)
                {
                    // Ghi nhật ký lỗi 
                    Response.Write($"Error: {ex.Message}");
                }
                //---End ký số
                //--------
                //string _ma_tb = hdd_matb.Value.ToString();
                //string path = Server.MapPath("~/TempUpload/");
                ////string strSignFile = "exc_sign_approved('{path}','{_ma_tb}.pdf');";
                //string strSignFile = $"exc_sign_approved('{path.Replace("\\", "\\\\")}', '{_ma_tb}.pdf');";
                //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), strSignFile, true);
            }
            else
            {
                System.Web.UI.ScriptManager.RegisterStartupScript(Ajax_Manager_Updata, this.GetType(), "Alert", "alert(' Bạn phải lưu thông tin án phí trước.' )", true);
            }
        }
        //-----Begin_KhanhPQ_Check nếu đóng không kí số thì xóa file tạm trên server----------
        private bool CheckFile_KySo()
        {
            
            if (String.IsNullOrEmpty(hddFileKySo.Value))
            {
                #region Đoạn này để chạy không load balancing
                string folder_upload = "/TempUpload/";
                string file_path = Server.MapPath(folder_upload);
                if (!Directory.Exists(file_path))
                    Directory.CreateDirectory(file_path);
                string[] files = Directory.GetFiles(file_path, "*.pdf");
                foreach (string file in files)
                {
                    FileInfo fi = new FileInfo(file);
                    fi.Delete();
                }
                hddFileKySo.Value = Cls_Comon.GetRootURL() + "/TempUpload";
                return false;
                #endregion

                #region Đoạn này để chạy load balancing
                //string[] files = Directory.GetFiles(pathAnphiTempUpload, "*.pdf");
                //foreach (string file in files)
                //{
                //    FileInfo fi = new FileInfo(file);
                //    fi.Delete();
                //}
                //hddFileKySo.Value = hidTempUpload;
                //return false;
                #endregion

            }
            return true;
        }
        protected void cmdCloseFileKyso_Click(object sender, EventArgs e)
        {
            #region Đoạn này để chạy không load balancing
            string folder_upload = "/TempUpload/";
            string file_path = Server.MapPath(folder_upload);
            if (!Directory.Exists(file_path))
                Directory.CreateDirectory(file_path);
            string[] files = Directory.GetFiles(file_path, "*.pdf");
            foreach (string file in files)
            {
                FileInfo fi = new FileInfo(file);
                fi.Delete();
                hddFileKySo.Value = Cls_Comon.GetRootURL() + "/TempUpload";
            }
            #endregion


            #region Đoạn này để chạy load balancing
            //string[] files = Directory.GetFiles(pathAnphiTempUpload, "*.pdf");
            //foreach (string file in files)
            //{
            //    FileInfo fi = new FileInfo(file);
            //    fi.Delete();
            //hddFileKySo.Value = hidTempUpload;
            //}
            #endregion
        }
        //-----End_KhanhPQ_Check nếu đóng không kí số thì xóa file tạm trên server----------
        protected void cmdSaveFileKyso_Click(object sender, EventArgs e)
        {
            if (CheckFile_KySo()== true)
            {
                Decimal _ANPHI_ID = (String.IsNullOrEmpty(Request["ANPHI_ID"] + "")) ? 0 : Convert.ToDecimal(Request["ANPHI_ID"] + "");
                String loaian = hdd_case.Value;
                SaveFile_KySo(_ANPHI_ID, loaian);
                hi_check_kyso.Value = "1";
                lstMsgB.Text = "Bạn đã cập nhật thành công";
            }
        }
        protected void Check_TrangThaiGui()
        {
            String _style_panel = (String.IsNullOrEmpty(Request["style_panel"] + "")) ? "" : Convert.ToString(Request["style_panel"] + "");
            Decimal _TUPHAP_ANPHI_ID = (String.IsNullOrEmpty(Request["tp_id"] + "")) ? 0 : Convert.ToDecimal(Request["tp_id"] + "");
            TUPHAP_ANPHI_CN_BL M_Object = new TUPHAP_ANPHI_CN_BL();
            DataTable oDT = M_Object.TUPHAP_ANPHI_CN_GET_ID(_TUPHAP_ANPHI_ID);
            String V_TRANG_THAI = "";
            Decimal V_TRANGTHAITHANHTOAN = 0;
            if (_style_panel == "2")
            {
                cmdSave.Visible = true;
                btn_thuhoi.Visible = false;
                btn_Gui.Visible = false;
            }
            else
            {
                if (oDT.Rows.Count != 0)
                {
                    V_TRANG_THAI = oDT.Rows[0]["TRANG_THAI"] + "";//V_TRANG_THAI 0  đang lưu,1 đã gửi,2 thu hồi
                    V_TRANGTHAITHANHTOAN = Convert.ToDecimal(oDT.Rows[0]["TRANGTHAITHANHTOAN"]);//TRANGTHAITHANHTOAN 0 chưa thanh toán, 1 đã thanh toán
                    if (V_TRANGTHAITHANHTOAN == 0)
                    {
                        cmdSave.Visible = true;
                        btn_thuhoi.Visible = false;
                        btn_Gui.Visible = false;
                    }
                    if (V_TRANGTHAITHANHTOAN == 1)
                    {
                        if (V_TRANG_THAI == "0")
                        {
                            btn_Gui.Visible = true;
                            btn_thuhoi.Visible = false;
                            cmdSave.Visible = true;
                        }
                        if (V_TRANG_THAI == "1")
                        {
                            btn_Gui.Visible = false;
                            btn_thuhoi.Visible = true;
                            cmdSave.Visible = false;
                        }
                        if (V_TRANG_THAI == "2")
                        {
                            btn_Gui.Visible = false;
                            btn_thuhoi.Visible = false;
                            cmdSave.Visible = true;
                        }
                    }
                }
                else
                {
                    cmdSave.Visible = true;
                    btn_thuhoi.Visible = false;
                    btn_Gui.Visible = false;
                }
            }
        }
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            String _style_panel = (String.IsNullOrEmpty(Request["style_panel"] + "")) ? "" : Convert.ToString(Request["style_panel"] + "");
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            Decimal _ANPHI_ID = (String.IsNullOrEmpty(Request["ANPHI_ID"] + "")) ? 0 : Convert.ToDecimal(Request["ANPHI_ID"] + "");
            Decimal _DVCQG_TT_ID = (String.IsNullOrEmpty(Request["DVCQG_TT_ID"] + "")) ? 0 : Convert.ToDecimal(Request["DVCQG_TT_ID"] + "");

           //hdd_tp_id.Value = (String.IsNullOrEmpty(Request.QueryString["tp_id"] + "")) ? "" : Convert.ToString(Request.QueryString["tp_id"] + "");

            Decimal _TUPHAP_ANPHI_ID = (String.IsNullOrEmpty(Request["tp_id"] + "")) ? 0 : Convert.ToDecimal(Request["tp_id"] + "");

            TUPHAP_ANPHI_CN_BL M_Object = new TUPHAP_ANPHI_CN_BL();
            //DuongSuIDS = ddlDuongSu.SelectedValue;
            if (CheckValid("0") == true)
            {
                try
                {
                    decimal DONID = Convert.ToDecimal(hddid.Value);
                    String loaian = hdd_case.Value;

                    TUPHAP_ANPHI oT = new TUPHAP_ANPHI();
                    // oT = dt.TUPHAP_ANPHI.Where(x => x.VUVIECID == DONID && x.ANPHI_ID == _ANPHI_ID && x.MALOAIVUVIEC == loaian).FirstOrDefault();
                    oT = dt.TUPHAP_ANPHI.Where(x => x.ID == _TUPHAP_ANPHI_ID).FirstOrDefault();
                    if (oT == null)
                    {
                        oT = new TUPHAP_ANPHI();
                        oT.MALOAIVUVIEC = hdd_case.Value;
                        oT.VUVIECID = DONID;
                        oT.SOBIENLAI = txtSoBienLai.Text;
                        oT.ANPHI = (String.IsNullOrEmpty(txtTamUngAP.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAP.Text.Trim().Replace(".", ""));
                        oT.VBTONGDATID = Convert.ToDecimal(bmID.Value);
                        oT.NGAYTAO = DateTime.Now;
                        oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oT.NGUOITAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                        oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oT.NGAYSUA = DateTime.Now;
                        DateTime _NGAYBIENLAI;
                        _NGAYBIENLAI = (String.IsNullOrEmpty(txtNGAYBIENLAI.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNGAYBIENLAI.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oT.NGAYBIENLAI = _NGAYBIENLAI;
                        oT.NGUOITHUTIEN = txtNGUOITHUTIEN.Text;
                        oT.GHICHU_HOANTRA = txt_GHICHU_HOANTRA.Text;
                        //----------------
                        oT.NOP_ISNGUYENDON = Convert.ToDecimal(rdLoaiNguoiNop.SelectedValue);
                        oT.NOP_HOTEN = txtNguoiNop_HoTen.Text;
                        oT.NOP_GIOITINH = Convert.ToDecimal(dropNguoiNop_GioiTinh.SelectedValue);
                        oT.NOP_NAMSINH = txtNguoiNop_NamSinh.Text == "" ? 0 : Convert.ToDecimal(txtNguoiNop_NamSinh.Text);

                        oT.NOP_CMND = txtNguoiNop_CMND.Text;
                        oT.NOP_SO_CCCD = txtNOP_SO_CCCD.Text;
                        oT.NOP_SO_HO_CHIEU = txtNOP_SO_HO_CHIEU.Text;

                        oT.NOP_TEL = txtNguoiNop_DienThoai.Text;
                        oT.NOP_EMAIL = txtNguoiNhan_Email.Text;
                        oT.NOP_DIACHI = txtNguoiNop_Diachi.Text;
                        if (ddl_NopCho_DuongSu.SelectedValue != "")
                        {
                            oT.NOPCHO_DUONGSUID = Convert.ToDecimal(ddl_NopCho_DuongSu.SelectedValue);
                        }
                        //-----------------------
                        oT.HOANTRAAP_ISNGUYENDON = Convert.ToDecimal(rdLoaiNguoiNhan.SelectedValue);
                        oT.HOANTRAAP_HOTEN = txtNguoiNhan_Hoten.Text;
                        oT.HOANTRAAP_GIOITINH = Convert.ToDecimal(dropNguoiNhan_GioiTinh.SelectedValue);
                        oT.HOANTRAAP_NAMSINH = txtNguoiNhan_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtNguoiNhan_Namsinh.Text);

                        oT.HOANTRAAP_CMND = txtNguoiNhan_CMND.Text;
                        oT.HOANTRAAP_SO_CCCD = txtNOP_SO_CCCD.Text;
                        oT.HOANTRAAP_SO_HO_CHIEU = txtNOP_SO_HO_CHIEU.Text;

                        oT.HOANTRAAP_TEL = txtNguoiNhan_Dienthoai.Text;
                        oT.HOANTRAAP_EMAIL = txtNguoiNhan_Email.Text;
                        oT.HOANTRAAP_DIACHI = txtNguoiNhan_DiaChiChitiet.Text;
                        oT.ANPHIHOANTRA = (String.IsNullOrEmpty(txt_ANPHIHOANTRA.Text.Trim())) ? 0 : Convert.ToDecimal(txt_ANPHIHOANTRA.Text.Trim().Replace(".", ""));
                        DateTime _NGAYHOANTRA;
                        _NGAYHOANTRA = (String.IsNullOrEmpty(txt_NGAYHOANTRA.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txt_NGAYHOANTRA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oT.NGAYHOANTRA = _NGAYHOANTRA;
                        if (ddl_NhanCho_DuongSu.SelectedValue != "")
                        {
                            oT.NHANCHO_DUONGSUID = Convert.ToDecimal(ddl_NhanCho_DuongSu.SelectedValue);
                        }
                        oT.DUONGSU_ID = DuongSuID;
                        oT.DUONGSU_IDS = DuongSuIDS;
                        oT.DVCQG_TT_ID = _DVCQG_TT_ID;
                        //-----------------
                        dt.TUPHAP_ANPHI.Add(oT);
                        dt.SaveChanges();
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "2");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "3");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "4");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "5");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "6");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "7");
                        }
                        if (_style_panel != "2")
                        {
                            //------lưu vào hệ thống chuyển nhận-----
                            TUPHAP_ANPHI_CN o_Object = new TUPHAP_ANPHI_CN();
                            o_Object.TUPHAP_ANPHI_ID = oT.ID;
                            o_Object.NGUOI_TAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            o_Object.TRANG_THAI = "0";
                            M_Object.TUPHAP_ANPHI_CN_INS_UP(o_Object);
                        }
                        //----------------
                        lstMsgB.Text = "Bạn đã lưu thành công";
                        hddIsReloadParent.Value = "1";
                    }
                    else
                    {
                        oT.NOP_ISNGUYENDON = Convert.ToDecimal(rdLoaiNguoiNop.SelectedValue);
                        oT.NOP_HOTEN = txtNguoiNop_HoTen.Text;
                        oT.NOP_GIOITINH = Convert.ToDecimal(dropNguoiNop_GioiTinh.SelectedValue);
                        oT.NOP_NAMSINH = txtNguoiNop_NamSinh.Text == "" ? 0 : Convert.ToDecimal(txtNguoiNop_NamSinh.Text);

                        oT.NOP_CMND = txtNguoiNop_CMND.Text;
                        oT.NOP_SO_CCCD = txtNOP_SO_CCCD.Text;
                        oT.NOP_SO_HO_CHIEU = txtNOP_SO_HO_CHIEU.Text;

                        oT.NOP_TEL = txtNguoiNop_DienThoai.Text;
                        oT.NOP_EMAIL = txtNguoiNhan_Email.Text;
                        oT.NOP_DIACHI = txtNguoiNop_Diachi.Text;
                        if (ddl_NopCho_DuongSu.SelectedValue != "")
                        {
                            oT.NOPCHO_DUONGSUID = Convert.ToDecimal(ddl_NopCho_DuongSu.SelectedValue);
                        }
                        //---------------
                        oT.HOANTRAAP_ISNGUYENDON = Convert.ToDecimal(rdLoaiNguoiNhan.SelectedValue);
                        oT.HOANTRAAP_HOTEN = txtNguoiNhan_Hoten.Text;
                        oT.HOANTRAAP_GIOITINH = Convert.ToDecimal(dropNguoiNhan_GioiTinh.SelectedValue);
                        oT.HOANTRAAP_NAMSINH = txtNguoiNhan_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtNguoiNhan_Namsinh.Text);
                        oT.HOANTRAAP_CMND = txtNguoiNhan_CMND.Text;
                        oT.HOANTRAAP_SO_CCCD = txtNOP_SO_CCCD.Text;
                        oT.HOANTRAAP_SO_HO_CHIEU = txtNOP_SO_HO_CHIEU.Text;
                        oT.HOANTRAAP_TEL = txtNguoiNhan_Dienthoai.Text;
                        oT.HOANTRAAP_EMAIL = txtNguoiNhan_Email.Text;
                        oT.HOANTRAAP_DIACHI = txtNguoiNhan_DiaChiChitiet.Text;
                        if (ddl_NhanCho_DuongSu.SelectedValue != "")
                        {
                            oT.NHANCHO_DUONGSUID = Convert.ToDecimal(ddl_NhanCho_DuongSu.SelectedValue);
                        }
                        //----------------
                        oT.SOBIENLAI = txtSoBienLai.Text;
                        oT.ANPHI = (String.IsNullOrEmpty(txtTamUngAP.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAP.Text.Trim().Replace(".", ""));
                        DateTime _NGAYBIENLAI;
                        _NGAYBIENLAI = (String.IsNullOrEmpty(txtNGAYBIENLAI.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNGAYBIENLAI.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oT.NGAYBIENLAI = _NGAYBIENLAI;
                        oT.NGUOITHUTIEN = txtNGUOITHUTIEN.Text;
                        oT.GHICHU_HOANTRA = txt_GHICHU_HOANTRA.Text;
                        oT.ANPHIHOANTRA = (String.IsNullOrEmpty(txt_ANPHIHOANTRA.Text.Trim())) ? 0 : Convert.ToDecimal(txt_ANPHIHOANTRA.Text.Trim().Replace(".", ""));
                        DateTime _NGAYHOANTRA;
                        _NGAYHOANTRA = (String.IsNullOrEmpty(txt_NGAYHOANTRA.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txt_NGAYHOANTRA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        oT.NGAYHOANTRA = _NGAYHOANTRA;
                        oT.DUONGSU_ID = DuongSuID;
                        oT.DUONGSU_IDS = DuongSuIDS;
                        oT.DVCQG_TT_ID = _DVCQG_TT_ID;
                        oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oT.NGAYSUA = DateTime.Now;
                        dt.SaveChanges();
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "2");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "3");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "4");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "5");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "6");
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)
                        {
                            DVCQG_THANH_TOAN_BL obj = new DVCQG_THANH_TOAN_BL();
                            obj.DVCQG_THANH_TOAN_UP_FROM_THADS(_ANPHI_ID, "7");
                        }
                        lstMsgB.Text = "Bạn đã cập nhật thành công";
                        hddIsReloadParent.Value = "1";
                        if (_style_panel != "2")
                        {
                            //------lưu vào hệ thống chuyển nhận-----
                            TUPHAP_ANPHI_CN o_Object = new TUPHAP_ANPHI_CN();
                            o_Object.TUPHAP_ANPHI_ID = _TUPHAP_ANPHI_ID;
                            o_Object.NGUOI_TAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            o_Object.TRANG_THAI = "0";
                            M_Object.TUPHAP_ANPHI_CN_INS_UP(o_Object);
                            //----------------
                        }
                    }
                    Check_TrangThaiGui();
                    if (_style_panel == "2")
                    {
                        btnInBL.Visible = false;
                    }
                    else
                    {
                        btnInBL.Visible = true;
                        btnKyso_Click(new object(), new EventArgs());
                        if (hi_check_kyso.Value == "0")
                        {
                            lstMsgB.Text = "File ký số chưa được lưu vào hệ thống";

                        }
                    }
                    //-------------------
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");

                }
                //catch (Exception ex)
                //{
                //    lstMsgB.Text = "Lỗi: " + ex.Message;
                //}
                catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
                {
                    foreach (var validationErrors in dbEx.EntityValidationErrors)
                    {
                        foreach (var validationError in validationErrors.ValidationErrors)
                        {
                            String Text_ = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                        }
                    }
                }
            }
        }
        protected void btn_Gui_Click(object sender, EventArgs e)
        {
            String _style_panel = (String.IsNullOrEmpty(Request["style_panel"] + "")) ? "" : Convert.ToString(Request["style_panel"] + "");
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            Decimal _ANPHI_ID = (String.IsNullOrEmpty(Request["ANPHI_ID"] + "")) ? 0 : Convert.ToDecimal(Request["ANPHI_ID"] + "");
            Decimal _DVCQG_TT_ID = (String.IsNullOrEmpty(Request["DVCQG_TT_ID"] + "")) ? 0 : Convert.ToDecimal(Request["DVCQG_TT_ID"] + "");

            Decimal _TUPHAP_ANPHI_ID = (String.IsNullOrEmpty(Request["tp_id"] + "")) ? 0 : Convert.ToDecimal(Request["tp_id"] + "");

            TUPHAP_ANPHI_CN_BL M_Object = new TUPHAP_ANPHI_CN_BL();
            //DuongSuIDS = ddlDuongSu.SelectedValue;
            if (CheckValid("1") == true)
            {
                try
                {
                    decimal DONID = Convert.ToDecimal(hddid.Value);
                    String loaian = hdd_case.Value;

                    TUPHAP_ANPHI oT = new TUPHAP_ANPHI();
                    //  oT = dt.TUPHAP_ANPHI.Where(x => x.VUVIECID == DONID && x.ANPHI_ID == _ANPHI_ID && x.MALOAIVUVIEC == loaian).FirstOrDefault();
                    oT = dt.TUPHAP_ANPHI.Where(x => x.ID == _TUPHAP_ANPHI_ID).FirstOrDefault();
                    if (oT != null)
                    {
                        DateTime _NGAYBIENLAI;
                        _NGAYBIENLAI = (String.IsNullOrEmpty(txtNGAYBIENLAI.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNGAYBIENLAI.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        DateTime _NGAYHOANTRA;
                        _NGAYHOANTRA = (String.IsNullOrEmpty(txt_NGAYHOANTRA.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txt_NGAYHOANTRA.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                       
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
                        {
                            ADS_ANPHI oAP = dt.ADS_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                            oAP.SOBIENLAI = txtSoBienLai.Text;
                            oAP.TAMUNGANPHI = (String.IsNullOrEmpty(txtTamUngAP.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAP.Text.Trim().Replace(".", ""));
                            oAP.NGAYNOPANPHI = _NGAYBIENLAI;
                            oAP.NGAYNOPBIENLAI = _NGAYBIENLAI;
                            oAP.NGUOINOP = txtNguoiNop_HoTen.Text;
                            dt.SaveChanges();
                            ADS_DON_DUONGSU oDs = dt.ADS_DON_DUONGSU.Where(x => x.ID == DuongSuID).FirstOrDefault();
                           // oDs.SOCMND = txtNguoiNop_CMND.Text;
                            oT.ANPHI_ID = oAP.ID;
                            dt.SaveChanges();
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)
                        {
                            AHN_ANPHI oAP = dt.AHN_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                            oAP.SOBIENLAI = txtSoBienLai.Text;
                            oAP.TAMUNGANPHI = (String.IsNullOrEmpty(txtTamUngAP.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAP.Text.Trim().Replace(".", ""));
                            oAP.NGAYNOPANPHI = _NGAYBIENLAI;
                            oAP.NGAYNOPBIENLAI = _NGAYBIENLAI;
                            oAP.NGUOINOP = txtNguoiNop_HoTen.Text;
                            dt.SaveChanges();
                            String[] arrst = DuongSuIDS.Split(',');
                            if (arrst.Length == 1)
                            {
                                Decimal DUONGSU_IDS_ = Convert.ToDecimal(DuongSuIDS);
                                AHN_DON_DUONGSU oDs = dt.AHN_DON_DUONGSU.Where(x => x.ID == DUONGSU_IDS_).FirstOrDefault();
                             //   oDs.SOCMND = txtNguoiNop_CMND.Text;
                            }
                            oT.ANPHI_ID = oAP.ID;
                            dt.SaveChanges();
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
                        {
                            AKT_ANPHI oAP = dt.AKT_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                            oAP.SOBIENLAI = txtSoBienLai.Text;
                            oAP.TAMUNGANPHI = (String.IsNullOrEmpty(txtTamUngAP.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAP.Text.Trim().Replace(".", ""));
                            oAP.NGAYNOPANPHI = _NGAYBIENLAI;
                            oAP.NGAYNOPBIENLAI = _NGAYBIENLAI;
                            oAP.NGUOINOP = txtNguoiNop_HoTen.Text;
                            dt.SaveChanges();
                            AKT_DON_DUONGSU oDs = dt.AKT_DON_DUONGSU.Where(x => x.ID == DuongSuID).FirstOrDefault();
                           // oDs.SOCMND = txtNguoiNop_CMND.Text;
                            oT.ANPHI_ID = oAP.ID;
                            dt.SaveChanges();
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
                        {
                            ALD_ANPHI oAP = dt.ALD_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                            oAP.SOBIENLAI = txtSoBienLai.Text;
                            oAP.TAMUNGANPHI = (String.IsNullOrEmpty(txtTamUngAP.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAP.Text.Trim().Replace(".", ""));
                            oAP.NGAYNOPANPHI = _NGAYBIENLAI;
                            oAP.NGAYNOPBIENLAI = _NGAYBIENLAI;
                            oAP.NGUOINOP = txtNguoiNop_HoTen.Text;
                            dt.SaveChanges();
                            ALD_DON_DUONGSU oDs = dt.ALD_DON_DUONGSU.Where(x => x.ID == DuongSuID).FirstOrDefault();
                          //  oDs.SOCMND = txtNguoiNop_CMND.Text;
                            oT.ANPHI_ID = oAP.ID;
                            dt.SaveChanges();
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
                        {
                            AHC_ANPHI oAP = dt.AHC_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                            oAP.SOBIENLAI = txtSoBienLai.Text;
                            oAP.TAMUNGANPHI = (String.IsNullOrEmpty(txtTamUngAP.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAP.Text.Trim().Replace(".", ""));
                            oAP.NGAYNOPANPHI = _NGAYBIENLAI;
                            oAP.NGAYNOPBIENLAI = _NGAYBIENLAI;
                            oAP.NGUOINOP = txtNguoiNop_HoTen.Text;
                            dt.SaveChanges();
                            String[] arrst = DuongSuIDS.Split(',');
                            if (arrst.Length == 1)
                            {
                                Decimal DUONGSU_IDS_ = Convert.ToDecimal(DuongSuIDS);
                                AHC_DON_DUONGSU oDs = dt.AHC_DON_DUONGSU.Where(x => x.ID == DUONGSU_IDS_).FirstOrDefault();
                               // oDs.SOCMND = txtNguoiNop_CMND.Text;
                            }
                            oT.ANPHI_ID = oAP.ID;
                            dt.SaveChanges();
                        }
                        if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)
                        {
                            APS_ANPHI oAP = dt.APS_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                            oAP.SOBIENLAI = txtSoBienLai.Text;
                            oAP.TAMUNGANPHI = (String.IsNullOrEmpty(txtTamUngAP.Text.Trim())) ? 0 : Convert.ToDecimal(txtTamUngAP.Text.Trim().Replace(".", ""));
                            oAP.NGAYNOPANPHI = _NGAYBIENLAI;
                            oAP.NGAYNOPBIENLAI = _NGAYBIENLAI;
                            oAP.NGUOINOP = txtNguoiNop_HoTen.Text;
                            dt.SaveChanges();
                            APS_DON_DUONGSU oDs = dt.APS_DON_DUONGSU.Where(x => x.ID == DuongSuID).FirstOrDefault();
                           // oDs.SOCMND = txtNguoiNop_CMND.Text;
                            oT.ANPHI_ID = oAP.ID;
                            dt.SaveChanges();
                        }
                        //------lưu vào hệ thống chuyển nhận-----
                        TUPHAP_ANPHI_CN o_Object = new TUPHAP_ANPHI_CN();
                        o_Object.TUPHAP_ANPHI_ID = _TUPHAP_ANPHI_ID;
                        o_Object.NGUOI_TAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        o_Object.TRANG_THAI = "1";
                        M_Object.TUPHAP_ANPHI_CN_INS_UP(o_Object);
                        //----------------
                        lstMsgB.Text = "Bạn đã gửi thành công";
                        hddIsReloadParent.Value = "1";
                    }
                    Check_TrangThaiGui();
                    if (_style_panel == "2")
                    {
                        btnInBL.Visible = false;
                    }
                    else
                    {
                        btnInBL.Visible = true;
                    }
                    //-------------------
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                }
                catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
                {
                    foreach (var validationErrors in dbEx.EntityValidationErrors)
                    {
                        foreach (var validationError in validationErrors.ValidationErrors)
                        {
                            String Text_ = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                        }
                    }
                }
            }
        }
        protected void btn_thuhoi_Click(object sender, EventArgs e)
        {
            String _style_panel = (String.IsNullOrEmpty(Request["style_panel"] + "")) ? "" : Convert.ToString(Request["style_panel"] + "");
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            Decimal _ANPHI_ID = (String.IsNullOrEmpty(Request["ANPHI_ID"] + "")) ? 0 : Convert.ToDecimal(Request["ANPHI_ID"] + "");
            Decimal _DVCQG_TT_ID = (String.IsNullOrEmpty(Request["DVCQG_TT_ID"] + "")) ? 0 : Convert.ToDecimal(Request["DVCQG_TT_ID"] + "");

            Decimal _TUPHAP_ANPHI_ID = (String.IsNullOrEmpty(Request["tp_id"] + "")) ? 0 : Convert.ToDecimal(Request["tp_id"] + "");


            TUPHAP_ANPHI_CN_BL M_Object = new TUPHAP_ANPHI_CN_BL();
            DataTable oDT = M_Object.TUPHAP_ANPHI_CN_GET_ID(_TUPHAP_ANPHI_ID);
            String V_TRANG_THAI = "";
            if (oDT != null)
            {
                V_TRANG_THAI = oDT.Rows[0]["TRANG_THAI"] + "";
            }

            if (V_TRANG_THAI == "1")//đã gửi
            {
                if (CheckValid("2") == true)
                {
                    try
                    {
                        decimal DONID = Convert.ToDecimal(hddid.Value);
                        String loaian = hdd_case.Value;
                        TUPHAP_ANPHI oT = new TUPHAP_ANPHI();
                        oT = dt.TUPHAP_ANPHI.Where(x => x.ID == _TUPHAP_ANPHI_ID).FirstOrDefault();
                        if (oT != null)
                        {
                            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
                            {
                                ADS_ANPHI oAP = dt.ADS_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                                oAP.SOBIENLAI = "";
                                oAP.NGAYNOPANPHI = (DateTime?)null; 
                                oAP.NGAYNOPBIENLAI = (DateTime?)null; 
                                oAP.NGUOINOP = "";
                                dt.SaveChanges();
                                ADS_DON_DUONGSU oDs = dt.ADS_DON_DUONGSU.Where(x => x.ID == DuongSuID).FirstOrDefault();
                                oT.ANPHI_ID = oAP.ID;
                                dt.SaveChanges();

                            }
                            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)
                            {
                                AHN_ANPHI oAP = dt.AHN_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                                oAP.SOBIENLAI = "";
                                oAP.NGAYNOPANPHI = (DateTime?)null;
                                oAP.NGAYNOPBIENLAI = (DateTime?)null;
                                oAP.NGUOINOP = "";
                                dt.SaveChanges();
                                String[] arrst = DuongSuIDS.Split(',');
                                if (arrst.Length == 1)
                                {
                                    Decimal DUONGSU_IDS_ = Convert.ToDecimal(DuongSuIDS);
                                    AHN_DON_DUONGSU oDs = dt.AHN_DON_DUONGSU.Where(x => x.ID == DUONGSU_IDS_).FirstOrDefault();
                                }
                                oT.ANPHI_ID = oAP.ID;
                                dt.SaveChanges();
                            }
                            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
                            {
                                AKT_ANPHI oAP = dt.AKT_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                                oAP.SOBIENLAI = "";
                                oAP.NGAYNOPANPHI = (DateTime?)null;
                                oAP.NGAYNOPBIENLAI = (DateTime?)null;
                                oAP.NGUOINOP = "";
                                dt.SaveChanges();
                                AKT_DON_DUONGSU oDs = dt.AKT_DON_DUONGSU.Where(x => x.ID == DuongSuID).FirstOrDefault();
                                oT.ANPHI_ID = oAP.ID;
                                dt.SaveChanges();
                            }
                            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
                            {
                                ALD_ANPHI oAP = dt.ALD_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                                oAP.SOBIENLAI = "";
                                oAP.NGAYNOPANPHI = (DateTime?)null;
                                oAP.NGAYNOPBIENLAI = (DateTime?)null;
                                oAP.NGUOINOP = "";
                                dt.SaveChanges();
                                ALD_DON_DUONGSU oDs = dt.ALD_DON_DUONGSU.Where(x => x.ID == DuongSuID).FirstOrDefault();
                               // oDs.SOCMND = txtNguoiNop_CMND.Text;
                                oT.ANPHI_ID = oAP.ID;
                                dt.SaveChanges();
                            }
                            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
                            {
                                AHC_ANPHI oAP = dt.AHC_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                                oAP.SOBIENLAI = "";
                                oAP.NGAYNOPANPHI = (DateTime?)null;
                                oAP.NGAYNOPBIENLAI = (DateTime?)null;
                                oAP.NGUOINOP = "";
                                dt.SaveChanges();
                                String[] arrst = DuongSuIDS.Split(',');
                                //if (arrst.Length == 1)
                                //{
                                //    Decimal DUONGSU_IDS_ = Convert.ToDecimal(DuongSuIDS);
                                //    AHC_DON_DUONGSU oDs = dt.AHC_DON_DUONGSU.Where(x => x.ID == DUONGSU_IDS_).FirstOrDefault();
                                //    oDs.SOCMND = txtNguoiNop_CMND.Text;
                                //}
                                oT.ANPHI_ID = oAP.ID;
                                dt.SaveChanges();
                            }
                            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN)
                            {
                                APS_ANPHI oAP = dt.APS_ANPHI.Where(x => x.DONID == DONID && x.ID == _ANPHI_ID).FirstOrDefault();
                                oAP.SOBIENLAI = "";
                                oAP.NGAYNOPANPHI = (DateTime?)null;
                                oAP.NGAYNOPBIENLAI = (DateTime?)null;
                                oAP.NGUOINOP = "";
                                dt.SaveChanges();
                                APS_DON_DUONGSU oDs = dt.APS_DON_DUONGSU.Where(x => x.ID == DuongSuID).FirstOrDefault();
                               // oDs.SOCMND = txtNguoiNop_CMND.Text;
                                oT.ANPHI_ID = oAP.ID;
                                dt.SaveChanges();
                            }
                            //------lưu vào hệ thống chuyển nhận-----
                            TUPHAP_ANPHI_CN o_Object = new TUPHAP_ANPHI_CN();
                            o_Object.TUPHAP_ANPHI_ID = _TUPHAP_ANPHI_ID;
                            o_Object.NGUOI_TAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            o_Object.TRANG_THAI = "2";
                            M_Object.TUPHAP_ANPHI_CN_INS_UP(o_Object);
                            //----------------
                            lstMsgB.Text = "Bạn đã thu hồi thành công";
                            hddIsReloadParent.Value = "1";
                        }
                        Check_TrangThaiGui();
                        if (_style_panel == "2")
                        {
                            btnInBL.Visible = false;
                        }
                        else
                        {
                            btnInBL.Visible = true;
                        }
                        //-------------------
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                    }
                    catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
                    {
                        foreach (var validationErrors in dbEx.EntityValidationErrors)
                        {
                            foreach (var validationError in validationErrors.ValidationErrors)
                            {
                                String Text_ = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                            }
                        }
                    }
                }
            }
        }
        private bool CheckValid(String trang_thai)
        {
            String _style_panel = (String.IsNullOrEmpty(Request["style_panel"] + "")) ? "" : Convert.ToString(Request["style_panel"] + "");
            String styleCase = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DonID = (String.IsNullOrEmpty(Request["donID"] + "")) ? 0 : Convert.ToDecimal(Request["donID"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            Decimal _ANPHI_ID = (String.IsNullOrEmpty(Request["ANPHI_ID"] + "")) ? 0 : Convert.ToDecimal(Request["ANPHI_ID"] + "");
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            String V_LOAI_AN = hdd_case.Value;

            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //--------------
            tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value, styleCase, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), DonID,Convert.ToString(DuongSuID), DuongSuIDS);
            TUPHAP_QLA_BL oBLs = new TUPHAP_QLA_BL();
            DataTable tblAP = new DataTable();
            DataRow rowAP = tblAP.NewRow();
            String Name_trang_thai = "";
            if (trang_thai == "0")
            {
                Name_trang_thai = " lưu";
            }
            if (trang_thai == "1")
            {
                Name_trang_thai = " gửi";
            }
            if (trang_thai == "2")
            {
                Name_trang_thai = " thu hồi";
            }

            tblAP = oBLs.GET_ENABLE_ANPHI(_ANPHI_ID, V_LOAI_AN);
            if (tblAP != null && tblAP.Rows.Count > 0)
            {
                rowAP = tblAP.Rows[0];
                if (_style_panel != "2")
                {
                    if (rowAP["ENABLE"].ToString() == "1")
                    {
                         lstMsgB.Text = "Tòa án đã thụ lý vụ việc, bạn không thể "+ Name_trang_thai;
                        return false;
                    }
                }
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                if (_style_panel == "2")
                {
                    if (rdLoaiNguoiNhan.SelectedValue == "0")
                    {
                        if (ddl_NhanCho_DuongSu.SelectedValue == "")
                        {
                            lstMsgB.Text = "Bạn chưa chọn Nhận cho đương sự";
                            rdLoaiNguoiNhan.Focus();
                            return false;
                        }
                    }
                    if (txt_ANPHIHOANTRA.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập số tiền hoàn trả";
                        txt_ANPHIHOANTRA.Focus();
                        return false;
                    }
                    if (txt_NGAYHOANTRA.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập ngày nhận hoàn trả";
                        txt_NGAYHOANTRA.Focus();
                        return false;
                    }
                    if (txtNguoiNhan_Hoten.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập họ tên người nhận hoàn trả tiền tạm ứng án phí";
                        txtNguoiNhan_Hoten.Focus();
                        return false;
                    }
                    //if (row["LOAIDUONGSU"].ToString() == "1")
                    //{
                    if (txtNguoiNhan_CMND.Text == "" && txtHOANTRAAP_SO_CCCD.Text == "" && txtHOANTRAAP_SO_HO_CHIEU.Text == "")
                    {
                        lstMsgB.Text = "Bạn phải nhập ít nhất 1 thông tin (Thẻ căn cước hoặc Số CMND hoặc Hộ chiếu)";
                        txtNguoiNhan_CMND.Focus();
                        return false;
                    }
                    //}
                }
                else
                {
                    if (rdLoaiNguoiNop.SelectedValue == "0")
                    {
                        if (ddl_NopCho_DuongSu.SelectedValue == "")
                        {
                            lstMsgB.Text = "Bạn chưa chọn Nộp cho đương sự";
                            ddl_NopCho_DuongSu.Focus();
                            return false;
                        }
                    }
                    if (txtNguoiNop_HoTen.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập họ tên người nộp án phí";
                        txtNguoiNop_HoTen.Focus();
                        return false;
                    }
                    //if (row["LOAIDUONGSU"].ToString() == "1")
                    //{
                        if (txtNguoiNop_CMND.Text == "" && txtNOP_SO_CCCD.Text=="" && txtNOP_SO_HO_CHIEU.Text == "")
                        {
                            lstMsgB.Text = "Bạn phải nhập ít nhất 1 thông tin (Thẻ căn cước hoặc Số CMND hoặc Hộ chiếu)";
                            txtNguoiNop_CMND.Focus();
                            return false;
                        }
                    //}

                    if (txtSoBienLai.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập số biên lai";
                        txtSoBienLai.Focus();
                        return false;
                    }
                    if (txtNGAYBIENLAI.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập ngày biên lai";
                        txtNGAYBIENLAI.Focus();
                        return false;
                    }
                    if (txtTamUngAP.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa nhập Tạm ứng án phí";
                        txtTamUngAP.Focus();
                        return false;
                    }
                    if (txtNGUOITHUTIEN.Text == "")
                    {
                        lstMsgB.Text = "Bạn chưa chọn người thu tiền";
                        txtNGUOITHUTIEN.Focus();
                        return false;
                    }
                    if (trang_thai == "1")//nhấn vào nút gửi
                    {
                        String V_FILE_NAME = "";
                        TUPHAP_ANPHI_BL oBLss = new TUPHAP_ANPHI_BL();
                        //--------------------
                        byte[] V_FILE_DATA = oBLss.File_Attach_Anphi_Return(hdd_case.Value, _ANPHI_ID, ref V_FILE_NAME);
                        if (V_FILE_NAME == "")
                        {
                            lstMsgB.Text = "Gửi không thành công, bạn phải đính kèm file biên lai ký số";
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        protected void rdLoaiNguoiNop_SelectedIndexChanged(object sender, EventArgs e)
        {
            String styleCase = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DonID = (String.IsNullOrEmpty(Request["donID"] + "")) ? 0 : Convert.ToDecimal(Request["donID"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            TUPHAP_ANPHI oT = dt.TUPHAP_ANPHI.Where(x => x.VUVIECID == DonID).FirstOrDefault();
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //String _DuongSuID = "";
            //if (hdd_case.Value == "3" || hdd_case.Value == "6")
            //{
            //    _DuongSuID=DuongSuIDS;
            //}
            //else
            //{
            //    _DuongSuID=Convert.ToString(DuongSuID);
            //}
            //-------------
            //String[] arrst = ddlDuongSu.SelectedValue.Split(',');
            //if (arrst.Length == 1)
            tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value, hdd_case.Value, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), DonID,Convert.ToString(DuongSuID), DuongSuIDS);
            //tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value, styleCase, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), DonID);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
            }
            //--------------
            if (rdLoaiNguoiNop.SelectedValue == "0")//người khác
            {
                txtNguoiNop_CMND.Text = txtNguoiNop_HoTen.Text = "";
                txtNOP_SO_CCCD.Text = txtNOP_SO_HO_CHIEU.Text = "";
                txtNguoiNop_NamSinh.Text = txtNguoiNop_Diachi.Text = "";
                txtNguoiNop_DienThoai.Text = "";
                if (row["NOP_ISNGUYENDON"].ToString() == "0")
                {
                    txtNguoiNop_HoTen.Text = oT.NOP_HOTEN;
                    dropNguoiNop_GioiTinh.SelectedValue = Convert.ToString(oT.NOP_GIOITINH);
                    txtNguoiNop_NamSinh.Text = Convert.ToString(oT.NOP_NAMSINH);

                    txtNguoiNop_CMND.Text = oT.NOP_CMND;
                    txtNOP_SO_CCCD.Text = oT.NOP_SO_CCCD;
                    txtNOP_SO_HO_CHIEU.Text = oT.NOP_SO_HO_CHIEU;

                    txtNguoiNop_DienThoai.Text = oT.NOP_TEL;
                    txtNguoiNhan_Email.Text = oT.NOP_EMAIL;
                    txtNguoiNop_Diachi.Text = oT.NOP_DIACHI;
                }
                txtNguoiNop_HoTen.Enabled = true;
                txtNguoiNop_HoTen.CssClass = "textbox remove_bg_Disable";
                txtNguoiNop_Diachi.Enabled = true;
                txtNguoiNop_Diachi.CssClass = "textbox remove_bg_Disable";
                txtNguoiNop_Diachi.Style.Remove("Display");

                txtNguoiNop_CMND.Enabled = true;
                txtNguoiNop_CMND.CssClass = "textbox remove_bg_Disable";

                txtNOP_SO_CCCD.Enabled = true;
                txtNOP_SO_CCCD.CssClass = "textbox remove_bg_Disable";

                txtNOP_SO_HO_CHIEU.Enabled = true;
                txtNOP_SO_HO_CHIEU.CssClass = "textbox remove_bg_Disable";

                txtNguoiNop_NamSinh.Enabled = true;
                txtNguoiNop_NamSinh.CssClass = "textbox remove_bg_Disable";
                txtNguoiNop_DienThoai.Enabled = true;
                txtNguoiNop_DienThoai.CssClass = "textbox remove_bg_Disable";
                dropNguoiNop_GioiTinh.Enabled = true;
                dropNguoiNop_GioiTinh.CssClass = "textbox remove_bg_Disable";
                div_ddl_NopCho_DuongSu.Style.Remove("Display");
            }
            if (rdLoaiNguoiNop.SelectedValue == "1")//nguyên đơn
            {
                txtNguoiNop_HoTen.Enabled = false;
                txtNguoiNop_HoTen.CssClass = "textbox bg_Disable";

                if (row["SOCMND"].ToString() == "")
                {
                    txtNguoiNop_CMND.Enabled = true;
                    txtNguoiNop_CMND.CssClass = "textbox remove_bg_Disable";
                }
                if (row["SOCMND"].ToString() != "")
                {
                    txtNguoiNop_CMND.Enabled = false;
                    txtNguoiNop_CMND.CssClass = "textbox bg_Disable";
                }
                if (row["NOP_SO_CCCD"].ToString() == "")
                {
                    txtNOP_SO_CCCD.Enabled = true;
                    txtNOP_SO_CCCD.CssClass = "textbox remove_bg_Disable";
                }
                if (row["NOP_SO_CCCD"].ToString() != "")
                {
                    txtNOP_SO_CCCD.Enabled = false;
                    txtNOP_SO_CCCD.CssClass = "textbox bg_Disable";
                }
                if (row["NOP_SO_HO_CHIEU"].ToString() == "")
                {
                    txtNOP_SO_HO_CHIEU.Enabled = true;
                    txtNOP_SO_HO_CHIEU.CssClass = "textbox remove_bg_Disable";
                }
                if (row["NOP_SO_HO_CHIEU"].ToString() != "")
                {
                    txtNOP_SO_HO_CHIEU.Enabled = false;
                    txtNOP_SO_HO_CHIEU.CssClass = "textbox bg_Disable";
                }

                txtNguoiNop_Diachi.Enabled = false;
                txtNguoiNop_Diachi.CssClass = "textbox bg_Disable";

                txtNguoiNop_NamSinh.Enabled = true;
                txtNguoiNop_NamSinh.CssClass = "textbox remove_bg_Disable";
                
                txtNguoiNop_DienThoai.Enabled = true;
                txtNguoiNop_DienThoai.CssClass = "textbox remove_bg_Disable";
                dropNguoiNop_GioiTinh.Enabled = true;
                dropNguoiNop_GioiTinh.CssClass = "textbox remove_bg_Disable";

                txtNguoiNop_HoTen.Text = row["TENDUONGSU"].ToString();

                txtNguoiNop_CMND.Text = row["SOCMND"].ToString();
                txtNOP_SO_CCCD.Text = row["NOP_SO_CCCD"].ToString();
                txtNOP_SO_HO_CHIEU.Text = row["NOP_SO_HO_CHIEU"].ToString();

                txtNguoiNop_NamSinh.Text = row["NAMSINH"].ToString();
                txtNguoiNop_Diachi.Text = row["DIACHI"].ToString();
                txtNguoiNop_DienThoai.Text = row["DIENTHOAI"].ToString();
                if (row["GIOITINH"].ToString() != "")
                dropNguoiNop_GioiTinh.SelectedValue = row["GIOITINH"].ToString();
                div_ddl_NopCho_DuongSu.Style.Add("Display", "none");
            }
        }
        protected void rdLoaiNguoiNhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            String styleCase = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DonID = (String.IsNullOrEmpty(Request["donID"] + "")) ? 0 : Convert.ToDecimal(Request["donID"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            TUPHAP_ANPHI oT = dt.TUPHAP_ANPHI.Where(x => x.VUVIECID == DonID).FirstOrDefault();
            TAM_UNG_AN_PHI_BL oBL = new TAM_UNG_AN_PHI_BL();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            // tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value, styleCase, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), DonID);
            tbl = oBL.Get_DONID_AnPhi(hdd_matb.Value, hdd_case.Value, Session[ENUM_SESSION.SESSION_USERNAME].ToString(), DonID, Convert.ToString(DuongSuID), DuongSuIDS);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
            }
            //--------------
            if (rdLoaiNguoiNhan.SelectedValue == "0")
            {
                txtNguoiNhan_Hoten.Text = "";
                txtNguoiNhan_CMND.Text = "";
                txtHOANTRAAP_SO_CCCD.Text = "";
                txtHOANTRAAP_SO_HO_CHIEU.Text = "";
                txtNguoiNhan_Namsinh.Text = "";
                txtNguoiNhan_DiaChiChitiet.Text = "";
                txtNguoiNhan_Dienthoai.Text = "";
                txtNguoiNhan_Email.Text = "";
                txt_GHICHU_HOANTRA.Text = "";
                if (row["HOANTRAAP_ISNGUYENDON"].ToString() == "0")
                {
                    txtNguoiNhan_Hoten.Text = oT.HOANTRAAP_HOTEN.ToString();
                    dropNguoiNhan_GioiTinh.SelectedValue = oT.HOANTRAAP_GIOITINH.ToString();
                    txtNguoiNhan_Namsinh.Text = oT.HOANTRAAP_NAMSINH.ToString();
                    txtNguoiNhan_CMND.Text = oT.HOANTRAAP_CMND;
                    txtHOANTRAAP_SO_CCCD.Text = oT.HOANTRAAP_SO_CCCD;
                    txtHOANTRAAP_SO_HO_CHIEU.Text = oT.HOANTRAAP_SO_HO_CHIEU;

                    txtNguoiNhan_Dienthoai.Text = oT.HOANTRAAP_TEL;
                    txtNguoiNhan_Email.Text = oT.HOANTRAAP_EMAIL;
                    txtNguoiNhan_DiaChiChitiet.Text = oT.HOANTRAAP_DIACHI;
                    txt_GHICHU_HOANTRA.Text = oT.GHICHU_HOANTRA;
                }
                txtNguoiNhan_CMND.Enabled = true;
                txtNguoiNhan_CMND.CssClass = "textbox remove_bg_Disable";

                txtHOANTRAAP_SO_CCCD.Enabled = true;
                txtHOANTRAAP_SO_CCCD.CssClass = "textbox remove_bg_Disable";

                txtHOANTRAAP_SO_HO_CHIEU.Enabled = true;
                txtHOANTRAAP_SO_HO_CHIEU.CssClass = "textbox remove_bg_Disable";


                txtNguoiNhan_Hoten.Enabled = true;
                txtNguoiNhan_Hoten.CssClass = "textbox remove_bg_Disable";
                txtNguoiNhan_DiaChiChitiet.Enabled = true;
                txtNguoiNhan_DiaChiChitiet.CssClass = "textbox remove_bg_Disable";
                div_ddl_NhanCho_DuongSu.Style.Remove("Display");
            }
            else if (rdLoaiNguoiNhan.SelectedValue == "1")
            {
                
                txtNguoiNhan_Hoten.Text = row["TENDUONGSU"].ToString();
                txtNguoiNhan_Hoten.Text = row["TENDUONGSU"].ToString();

                txtNguoiNhan_CMND.Text = row["SOCMND"].ToString();
                txtHOANTRAAP_SO_CCCD.Text = row["HOANTRAAP_SO_CCCD"].ToString();
                txtHOANTRAAP_SO_HO_CHIEU.Text = row["HOANTRAAP_SO_HO_CHIEU"].ToString();

                txtNguoiNhan_Namsinh.Text = row["NAMSINH"].ToString();
                txtNguoiNhan_DiaChiChitiet.Text = row["DIACHI"].ToString();
                txtNguoiNhan_Dienthoai.Text = row["DIENTHOAI"].ToString();
                txtNguoiNhan_Email.Text = row["HOANTRAAP_EMAIL"].ToString();
                dropNguoiNhan_GioiTinh.SelectedValue = row["GIOITINH"].ToString();
                txtTamUngAP.Text = ((decimal)row["TAMUNGANPHI"]).ToString("#,0.###", cul);
                txt_GHICHU_HOANTRA.Text = row["GHICHU_HOANTRA"].ToString();
                div_ddl_NhanCho_DuongSu.Style.Add("Display", "none");
                //---------------
                txtNguoiNhan_Hoten.Enabled = false;
                txtNguoiNhan_Hoten.CssClass = "textbox bg_Disable";
                txtNguoiNhan_DiaChiChitiet.Enabled = false;
                txtNguoiNhan_DiaChiChitiet.CssClass = "textbox bg_Disable";

                txtNguoiNhan_CMND.Enabled = false;
                txtNguoiNhan_CMND.CssClass = "textbox bg_Disable";

                txtHOANTRAAP_SO_CCCD.Enabled = false;
                txtHOANTRAAP_SO_CCCD.CssClass = "textbox bg_Disable";

                txtHOANTRAAP_SO_HO_CHIEU.Enabled = false;
                txtHOANTRAAP_SO_HO_CHIEU.CssClass = "textbox bg_Disable";
            }
            
        }
        //protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        //{
        //    if (AsyncFileUpLoad.HasFile)
        //    {
        //        string strFileName = AsyncFileUpLoad.FileName;
        //        string path = Server.MapPath("~/TempUpload/") + strFileName;
        //        AsyncFileUpLoad.SaveAs(path);
        //        path = path.Replace("\\", "/");
        //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
        //    }
        //}
        protected void lbtDownload_Click(object sender, EventArgs e)
        {
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            Decimal _ANPHI_ID = (String.IsNullOrEmpty(Request["ANPHI_ID"] + "")) ? 0 : Convert.ToDecimal(Request["ANPHI_ID"] + "");
            String V_FILE_NAME = "";
            TUPHAP_ANPHI_BL oBL = new TUPHAP_ANPHI_BL();
            //--------------------
            byte[] V_FILE_DATA = oBL.File_Attach_Anphi_Return(hdd_case.Value, _ANPHI_ID, ref V_FILE_NAME);
            string V_FILE_TYLE = "";
            if (V_FILE_NAME.LastIndexOf('.') > 0)
            {
                V_FILE_TYLE = V_FILE_NAME.Substring(V_FILE_NAME.LastIndexOf('.'));
            }
            if (V_FILE_NAME != "")
            {
                Load_Respon_File(V_FILE_NAME, V_FILE_DATA);
                //var cacheKey = Guid.NewGuid().ToString("N");
                //Context.Cache.Insert(key: cacheKey, value: V_FILE_DATA, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + V_FILE_NAME + "&Extension=" + V_FILE_TYLE + "';", true);
            }
        }
        void Load_Respon_File(String _FILE_NAME, byte[] b)
        {
            string fileEx = "";
            if (_FILE_NAME.LastIndexOf('.') > 0)
            {
                fileEx = _FILE_NAME.Substring(_FILE_NAME.LastIndexOf('.'));
            }
            Response.Clear();
            Response.ContentEncoding = Encoding.Unicode;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + _FILE_NAME);
            switch (fileEx)
            {
                case ".pdf": Response.ContentType = "application/pdf"; break;
                case ".dwg": Response.ContentType = "image/vnd.dwg"; break;
                case ".doc": Response.ContentType = "application/msword"; break;
                case ".docx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.wordprocessingml.FileAttach"; break;
                case ".xls": Response.ContentType = "application/vnd.ms-excel"; break;
                case ".xlsx": Response.ContentType = "application/vnd.openxmlformats-officeFileAttach.spreadsheetml.sheet"; break;
                case ".gif": Response.ContentType = "image/gif"; break;
                case ".jpeg": Response.ContentType = "image/jpg"; break;
                case ".jpg": Response.ContentType = "image/jpg"; break;
                case ".png": Response.ContentType = "image/png"; break;
                default: Response.ContentType = "application/octet-stream"; break; //getMimeType(sExtention, oConnection);  
            }
            Response.BinaryWrite(b);
            Response.Flush();
            Response.End();
        }
        protected void Upload_File(Decimal V_ANPHI_ID, String V_LOAIAN)
        {
            TUPHAP_ANPHI_BL oBL = new TUPHAP_ANPHI_BL();
            if (hddFilePath.Value == "")
            {
                lstMsgB.Text = "Bạn phải đính kèm file";
                return;
            }
            else
            {
                string strFilePath = hddFilePath.Value.Replace("/", "\\");
                FileInfo oF = new FileInfo(strFilePath);
                #region Lưu file
                byte[] V_FILE_DATA = null;
                using (FileStream fs = File.OpenRead(strFilePath))
                {
                    BinaryReader br = new BinaryReader(fs);
                    long numBytes = oF.Length;
                    V_FILE_DATA = br.ReadBytes((int)numBytes);
                    String oF_Name_file = oF.Name;
                    String V_FILE_NAME = "";
                    string V_FILE_TYLE = "";
                    if (oF_Name_file != "")
                    {
                        V_FILE_NAME = oF_Name_file.Replace(" ", "_").Replace("-", "_");
                        if (oF_Name_file.LastIndexOf('.') > 0)
                        {
                            V_FILE_TYLE = oF_Name_file.Substring(oF_Name_file.LastIndexOf('.'));
                        }
                    }
                    if (V_FILE_NAME != "")
                    {
                        if (oBL.ANPHI_FILE_UPD(V_LOAIAN, V_ANPHI_ID, V_FILE_NAME, V_FILE_DATA, V_FILE_TYLE, "A") == true)//A,S,X; A: Thêm mới; S: Thay thế, X: Xóa file    
                        {
                            String strMsg = "File đã được lưu thành công";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            lbtDownload.Visible = true; lbtXoa.Visible = true;
                        }
                        else
                        {
                            String strMsg = "Đã có lỗi khi lưu file kèm theo. Vui lòng kiểm tra lại.";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        }
                    }
                }
                #endregion
                File.Delete(strFilePath); //sau khi up thành công thì xóa luôn file đó trong thư mục lưu trữ
                                          //-------xóa những file đã hết hạn sau một ngày----------
                string path = Server.MapPath("~/TempUpload/");
                string[] files = Directory.GetFiles(path);
                foreach (string file in files)
                {
                    FileInfo fi = new FileInfo(file);
                    if (fi.LastAccessTime < DateTime.Now.AddDays(-1))
                        fi.Delete();
                }
            }
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        protected void SaveFile_KySo(Decimal V_ANPHI_ID, String V_LOAIAN)
        {
            TUPHAP_ANPHI_BL oBL = new TUPHAP_ANPHI_BL();
            if (!String.IsNullOrEmpty(hddFileKySo.Value))
            {
                string file_kyso = hddFileKySo.Value;
                String[] arr = file_kyso.Split('/');
                string file_name = arr[arr.Length - 1] + "";
                string file_name2 = hdd_matb.Value + "_" + hddDuongsu.Value + ".pdf";

                #region Đoạn này để chạy không load balancing 
                string folder_upload = "/TempUpload/";
                string file_path = Path.Combine(Server.MapPath(folder_upload), file_name);
                String file_path2 = Path.Combine(Server.MapPath(folder_upload), file_name2);
                #endregion

                #region Đoạn này để chạy load balancing 
                //String file_path = Path.Combine((pathAnphiTempUpload), file_name);
                //String file_path2 = Path.Combine((pathAnphiTempUpload), file_name2);
                #endregion
                //string strFilePath = hddFilePath.Value.Replace("/", "\\");
                FileInfo oF = new FileInfo(file_path);
                #region Lưu file
                byte[] V_FILE_DATA = null;
                using (FileStream fs = File.OpenRead(file_path))
                {
                    BinaryReader br = new BinaryReader(fs);
                    long numBytes = oF.Length;
                    V_FILE_DATA = br.ReadBytes((int)numBytes);
                    String oF_Name_file = oF.Name;
                    String V_FILE_NAME = "";
                    string V_FILE_TYLE = "";
                    if (oF_Name_file != "")
                    {
                        V_FILE_NAME = oF_Name_file.Replace(" ", "_").Replace("-", "_");
                        if (oF_Name_file.LastIndexOf('.') > 0)
                        {
                            V_FILE_TYLE = oF_Name_file.Substring(oF_Name_file.LastIndexOf('.'));
                        }
                    }
                    if (V_FILE_NAME != "")
                    {
                        if (oBL.ANPHI_FILE_UPD(V_LOAIAN, V_ANPHI_ID, V_FILE_NAME, V_FILE_DATA, V_FILE_TYLE, "A") == true)//A,S,X; A: Thêm mới; S: Thay thế, X: Xóa file    
                        {
                            //String strMsg = "File đã được lưu thành công";
                            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            lbtDownload.Visible = true; lbtXoa.Visible = true;
                            lbtDownload.Text = V_FILE_NAME;
                        }
                        else
                        {
                            String strMsg = "Đã có lỗi khi lưu file kèm theo. Vui lòng kiểm tra lại.";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        }
                    }
                }
                #endregion

                //sau khi up thành công thì xóa luôn file đó trong thư mục lưu trữ
                #region Đoạn này để chạy không load balancing  
                string path = Server.MapPath(folder_upload);
                string[] files = Directory.GetFiles(path, "*.pdf");
                foreach (string file in files)
                {
                    FileInfo fi = new FileInfo(file);
                    fi.Delete();
                    hddFileKySo.Value = Cls_Comon.GetRootURL() + "/TempUpload";
                }
                #endregion

                #region Đoạn này để chạy load balancing
                //string[] files = Directory.GetFiles(pathAnphiTempUpload, "*.pdf");
                //foreach (string file in files)
                //{
                //    FileInfo fi = new FileInfo(file);
                //    fi.Delete();
                //    hddFileKySo.Value = hidTempUpload;
                //}
                #endregion
            }
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }

        protected void lbtXoa_Click(object sender, EventArgs e)
        {
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            Decimal _ANPHI_ID = (String.IsNullOrEmpty(Request["ANPHI_ID"] + "")) ? 0 : Convert.ToDecimal(Request["ANPHI_ID"] + "");
            TUPHAP_ANPHI_BL oBL = new TUPHAP_ANPHI_BL();
            Decimal V_COUNT_TL = 0;
            if (oBL.ANPHI_FILE_UPD_XOA(hdd_case.Value, _ANPHI_ID, "X", ref V_COUNT_TL) == true)//V_COUNT_TL đã thụ lý và kết hợp với trạng thái khóa AND ENABLE=1 ở bảng ADS..._ANPHI
            {
                if (V_COUNT_TL > 0)
                {
                    String strMsg = "Vụ việc đã được được thụ lý bạn không được xóa";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                }
                else
                {
                    String strMsg = "File đã được xóa thành công";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                lbtXoa.Visible = false;
                lbtDownload.Visible = false;
                }
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
        }
        void LoadDropNopCho_DuongSu()
        {
            String _style_panel = (String.IsNullOrEmpty(Request["style_panel"] + "")) ? "" : Convert.ToString(Request["style_panel"] + "");
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            Decimal DONID = (String.IsNullOrEmpty(Request["donID"] + "")) ? 0 : Convert.ToDecimal(Request["donID"] + "");
            ddl_NopCho_DuongSu.Items.Clear();

            DataTable obj = new DataTable();

            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)
            {

                AHN_DON don = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                AHN_DON_DUONGSU_BL oDSBL = new AHN_DON_DUONGSU_BL();
                if (don.QHPLTKID == 1062)//2. Yêu cầu công nhận thuận tình ly hôn, thỏa thuận nuôi con, chia tài sản khi ly hôn
                {
                    obj = oDSBL.AHN_DON_DUONGSU_GETLIST(DONID);
                    ddl_NopCho_DuongSu.DataSource = obj;
                    ddl_NopCho_DuongSu.DataTextField = "DUONGSU";
                    ddl_NopCho_DuongSu.DataValueField = "ID";
                    ddl_NopCho_DuongSu.DataBind();
                    string ids = "";
                    foreach (DataRow row in obj.Rows)
                    {
                        ids += row["ID"].ToString() + ",";
                    }
                    ddl_NopCho_DuongSu.Items.Insert(ddl_NopCho_DuongSu.Items.Count, new ListItem("Cả nguyên đơn và bị đơn", ids.Remove(ids.Length - 1)));
                    ddl_NopCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                    // ddl_NopCho_DuongSu.SelectedValue = Convert.ToString(DuongSuIDS);
                }
                else
                {
                    obj = oDSBL.AHN_DON_DUONGSU_ANPHI(DONID);
                    ddl_NopCho_DuongSu.DataSource = obj;
                    ddl_NopCho_DuongSu.DataTextField = "TENDUONGSUS";
                    ddl_NopCho_DuongSu.DataValueField = "ID";
                    ddl_NopCho_DuongSu.DataBind();
                    ddl_NopCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                    // ddl_NopCho_DuongSu.SelectedValue = Convert.ToString(DuongSuIDS);
                    //   ddl_NopCho_DuongSu.SelectedIndex = 0;
                }
            }
            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
            {
                ADS_DON don = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                ADS_DON_DUONGSU_BL oDSBL = new ADS_DON_DUONGSU_BL();

                obj = oDSBL.ADS_DON_DUONGSU_ANPHI(DONID);
                ddl_NopCho_DuongSu.DataSource = obj;
                ddl_NopCho_DuongSu.DataTextField = "TENDUONGSUS";
                ddl_NopCho_DuongSu.DataValueField = "ID";
                ddl_NopCho_DuongSu.DataBind();
                ddl_NopCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                // ddl_NopCho_DuongSu.SelectedIndex = 0;
                // ddl_NopCho_DuongSu.SelectedValue = Convert.ToString(DuongSuID);
            }
            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
            {
                AKT_DON don = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
                AKT_DON_DUONGSU_BL oDSBL = new AKT_DON_DUONGSU_BL();

                obj = oDSBL.AKT_DON_DUONGSU_ANPHI(DONID);
                ddl_NopCho_DuongSu.DataSource = obj;
                ddl_NopCho_DuongSu.DataTextField = "TENDUONGSUS";
                ddl_NopCho_DuongSu.DataValueField = "ID";
                ddl_NopCho_DuongSu.DataBind();
                ddl_NopCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                //ddl_NopCho_DuongSu.SelectedValue = Convert.ToString(DuongSuID);
                // ddl_NopCho_DuongSu.SelectedIndex = 0;
            }
            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
            {
                ALD_DON don = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                ALD_DON_DUONGSU_BL oDSBL = new ALD_DON_DUONGSU_BL();

                obj = oDSBL.ALD_DON_DUONGSU_ANPHI(DONID);
                ddl_NopCho_DuongSu.DataSource = obj;
                ddl_NopCho_DuongSu.DataTextField = "TENDUONGSUS";
                ddl_NopCho_DuongSu.DataValueField = "ID";
                ddl_NopCho_DuongSu.DataBind();
                ddl_NopCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                //ddl_NopCho_DuongSu.SelectedValue = Convert.ToString(DuongSuID);
                //ddl_NopCho_DuongSu.SelectedIndex = 0;
            }
            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
            {
                AHC_DON don = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                AHC_DON_DUONGSU_BL oDSBL = new AHC_DON_DUONGSU_BL();

                obj = oDSBL.AHC_DON_DUONGSU_ANPHI(DONID);
                ddl_NopCho_DuongSu.DataSource = obj;
                ddl_NopCho_DuongSu.DataTextField = "TENDUONGSUS";
                ddl_NopCho_DuongSu.DataValueField = "ID";
                ddl_NopCho_DuongSu.DataBind();
                ddl_NopCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                // ddl_NopCho_DuongSu.SelectedIndex = 0;
            }

        }
        void LoadDropNhanCho_DuongSu()
        {
            String _style_panel = (String.IsNullOrEmpty(Request["style_panel"] + "")) ? "" : Convert.ToString(Request["style_panel"] + "");
            hdd_case.Value = (String.IsNullOrEmpty(Request.QueryString["styleCase"] + "")) ? "" : Convert.ToString(Request.QueryString["styleCase"] + "");
            DuongSuID = (String.IsNullOrEmpty(Request["dsID"] + "")) ? 0 : Convert.ToDecimal(Request["dsID"] + "");
            DuongSuIDS = Request["dsIDS"] + "";
            Decimal DONID = (String.IsNullOrEmpty(Request["donID"] + "")) ? 0 : Convert.ToDecimal(Request["donID"] + "");
            ddl_NhanCho_DuongSu.Items.Clear();

            DataTable obj = new DataTable();

            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH)
            {

                AHN_DON don = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
                AHN_DON_DUONGSU_BL oDSBL = new AHN_DON_DUONGSU_BL();
                if (don.QHPLTKID == 1062)//2. Yêu cầu công nhận thuận tình ly hôn, thỏa thuận nuôi con, chia tài sản khi ly hôn
                {
                    obj = oDSBL.AHN_DON_DUONGSU_GETLIST(DONID);
                    ddl_NhanCho_DuongSu.DataSource = obj;
                    ddl_NhanCho_DuongSu.DataTextField = "DUONGSU";
                    ddl_NhanCho_DuongSu.DataValueField = "ID";
                    ddl_NhanCho_DuongSu.DataBind();
                    string ids = "";
                    foreach (DataRow row in obj.Rows)
                    {
                        ids += row["ID"].ToString() + ",";
                    }
                    ddl_NhanCho_DuongSu.Items.Insert(ddl_NhanCho_DuongSu.Items.Count, new ListItem("Cả nguyên đơn và bị đơn", ids.Remove(ids.Length - 1)));
                    ddl_NhanCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                    // ddl_NhanCho_DuongSu.SelectedValue = Convert.ToString(DuongSuIDS);
                }
                else
                {
                    obj = oDSBL.AHN_DON_DUONGSU_ANPHI(DONID);
                    ddl_NhanCho_DuongSu.DataSource = obj;
                    ddl_NhanCho_DuongSu.DataTextField = "TENDUONGSUS";
                    ddl_NhanCho_DuongSu.DataValueField = "ID";
                    ddl_NhanCho_DuongSu.DataBind();
                    ddl_NhanCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                    // ddl_NhanCho_DuongSu.SelectedValue = Convert.ToString(DuongSuIDS);
                    //   ddl_NhanCho_DuongSu.SelectedIndex = 0;
                }
            }
            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
            {
                ADS_DON don = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                ADS_DON_DUONGSU_BL oDSBL = new ADS_DON_DUONGSU_BL();

                obj = oDSBL.ADS_DON_DUONGSU_ANPHI(DONID);
                ddl_NhanCho_DuongSu.DataSource = obj;
                ddl_NhanCho_DuongSu.DataTextField = "TENDUONGSUS";
                ddl_NhanCho_DuongSu.DataValueField = "ID";
                ddl_NhanCho_DuongSu.DataBind();
                ddl_NhanCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                // ddl_NhanCho_DuongSu.SelectedIndex = 0;
                // ddl_NhanCho_DuongSu.SelectedValue = Convert.ToString(DuongSuID);
            }
            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
            {
                AKT_DON don = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
                AKT_DON_DUONGSU_BL oDSBL = new AKT_DON_DUONGSU_BL();

                obj = oDSBL.AKT_DON_DUONGSU_ANPHI(DONID);
                ddl_NhanCho_DuongSu.DataSource = obj;
                ddl_NhanCho_DuongSu.DataTextField = "TENDUONGSUS";
                ddl_NhanCho_DuongSu.DataValueField = "ID";
                ddl_NhanCho_DuongSu.DataBind();
                ddl_NhanCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                //ddl_NhanCho_DuongSu.SelectedValue = Convert.ToString(DuongSuID);
                // ddl_NhanCho_DuongSu.SelectedIndex = 0;
            }
            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
            {
                ALD_DON don = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
                ALD_DON_DUONGSU_BL oDSBL = new ALD_DON_DUONGSU_BL();

                obj = oDSBL.ALD_DON_DUONGSU_ANPHI(DONID);
                ddl_NhanCho_DuongSu.DataSource = obj;
                ddl_NhanCho_DuongSu.DataTextField = "TENDUONGSUS";
                ddl_NhanCho_DuongSu.DataValueField = "ID";
                ddl_NhanCho_DuongSu.DataBind();
                ddl_NhanCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                //ddl_NhanCho_DuongSu.SelectedValue = Convert.ToString(DuongSuID);
                //ddl_NhanCho_DuongSu.SelectedIndex = 0;
            }
            if (hdd_case.Value == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
            {
                AHC_DON don = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                AHC_DON_DUONGSU_BL oDSBL = new AHC_DON_DUONGSU_BL();

                obj = oDSBL.AHC_DON_DUONGSU_ANPHI(DONID);
                ddl_NhanCho_DuongSu.DataSource = obj;
                ddl_NhanCho_DuongSu.DataTextField = "TENDUONGSUS";
                ddl_NhanCho_DuongSu.DataValueField = "ID";
                ddl_NhanCho_DuongSu.DataBind();
                ddl_NhanCho_DuongSu.Items.Insert(0, new ListItem("-- Chọn --", ""));
                // ddl_NhanCho_DuongSu.SelectedIndex = 0;
            }

        }
    }
}