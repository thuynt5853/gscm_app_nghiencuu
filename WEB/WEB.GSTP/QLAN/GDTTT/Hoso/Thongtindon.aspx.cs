using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.GDTTT;
using DAL.GSTP;
using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Spreadsheet;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;


namespace WEB.GSTP.QLAN.GDTTT.Hoso
{
    public partial class Thongtindon : System.Web.UI.Page
    {
        //private static GSTPContext dt = new GSTPContext();
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        decimal don_id = 0;
        DataTable lstDonVi;
        DataTable tbl_temp = new DataTable();
        public int bicao = 0;
        String UserName = "";
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        public decimal VuAnID = 0;
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        Decimal GetDonID()
        {
            string current_id = Request["ID"] + "";
            if (current_id == "")
            {
                if (hddDontrungID.Value != "" && hddDontrungID.Value != "0")
                {
                    don_id = Convert.ToDecimal(hddDontrungID.Value);
                    if (hddID.Value != "" && hddID.Value != "0")
                    {
                        don_id = Convert.ToDecimal(Session["DONID_CC"] + "");
                    }
                }
                else
                {
                    if (Session["VUVIECID_CC"] != null)
                    {
                        don_id = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
                    }
                    else
                        if (Session["DONID_CC"] != null)
                    {
                        don_id = Convert.ToDecimal(Session["DONID_CC"] + "");
                    }
                }
            }
            else
            {
                if (hddDontrungID.Value != "" && hddDontrungID.Value != "0")
                {
                    don_id = Convert.ToDecimal(hddDontrungID.Value);
                    if (hddID.Value != "" && hddID.Value != "0")
                    {
                        don_id = Convert.ToDecimal(Session["DONID_CC"] + "");
                    }
                }
                else
                {
                    if (Session["VUVIECID_CC"] != null)
                    {
                        don_id = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
                    }
                    else
                        if (Session["DONID_CC"] != null)
                        don_id = Convert.ToDecimal(Session["DONID_CC"] + "");
                }
            }
            return don_id;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            VuAnID = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
            try
            {
                if (!IsPostBack)
                {
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdUpdateAndNew, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdUpdateB, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, oPer.CAPNHAT);
                    //------------
                    Cls_Comon.SetButton(cmdSaveDSHinhSu, true);
                    Cls_Comon.SetButton(cmdRefresh, true);

                    Cls_Comon.SetButton(cmdXoaTL, true);
                    Cls_Comon.SetButton(cmdXuLyLai, true);

                    lkThemNguoiKN.Enabled = true;
                    lkThemNguoiKN.CssClass = "button_empty";
                    lkThem_BC.Enabled = true;
                    lkThem_BC.CssClass = "button_empty";

                    lkThemND.Enabled = true;
                    lkThemND.CssClass = "buttonpopup them_user clear_bottom";
                    lkThemBD.Enabled = true;
                    lkThemBD.CssClass = "buttonpopup them_user clear_bottom";
                    lkThemDSKhac.Enabled = true;
                    lkThemDSKhac.CssClass = "buttonpopup them_user clear_bottom";

                    dropTPTC.Visible = false;
                    //chkIsTuHinh.Visible = false;

                    LoadCombobox();
                    load_lable_ba_qd();

                    //LoadDropNGuoiKy_VKS();
                    chkIsCongVan.Visible = false;
                    string current_id = Request["ID"] + "";
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();

                    txtNgaynhandon.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    /////
                    Check_BC_NKN();
                    if (current_id != "" && current_id != "0")
                    {
                        decimal ID = Convert.ToDecimal(current_id);
                        string strType = Request["type"] + "";
                        if (strType == "dontrung")
                        {
                            // pnDonTrung.Visible = false;
                            TrangThaiDon_load(ID, true);
                            LoadInfo(ID, true);
                            ThuLy_load(ID, true);
                            //check_span_batbuoc();
                            txtSohieudon.Text = txtSohieudon_VB.Text = txtNgaynhandon.Text = txtNgayghidon.Text = "";
                            txtVB_Ngay.Text = "";
                            Cls_Comon.SetButton(cmdUpdate, true);
                            Cls_Comon.SetButton(cmdUpdateAndNew, true);
                            Cls_Comon.SetButton(cmdUpdateB, true);
                            Cls_Comon.SetButton(cmdUpdateAndNewB, true);
                            //Thêm số thụ lý, ngày cho đơn trùng
                            LoadDSTrung();
                            LoadDSTLL();
                            LoadDSKemTheo();
                            //Create_Bicao_duongsu();
                        }
                        else
                        {
                            //pnDonTrung.Visible = false;
                            hddID.Value = current_id.ToString();
                            TrangThaiDon_load(ID, false);
                            LoadInfo(ID, false);
                            ThuLy_load(ID, false);
                            //check_span_batbuoc();
                            LoadBoSungTL(ID);
                            //Load danh sách trùng
                            LoadDSTrung();
                            LoadDSTLL();
                            LoadDSKemTheo();
                            Load_pnkiem_tratrung();
                        }
                        if (Request["vt_id"] + "" != "")//anhvh add dùng cho văn thư đến 22/10/2020
                        {
                            //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                            decimal sothuly_ = 0;
                            oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                            txtSoThuLy.Text = Convert.ToString(sothuly_);
                            //--------------
                            txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
                        }
                        //---bi cao --người KN
                        ///--------
                        Load_NKN_BC();
                    }
                    else
                    {
                        //Ngay xu ly don là ngay hệ thống
                        txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
                        //pnDonTrung.Visible = true;//tạm ẩn khi nào sửa xong chức năng các đơn thụ lý kèm theo, khi có cái đơn trùng kèm theo luôn là thụ lý mơi
                        //Bỏ vì không có tác dụng - ng yêu cầu đ/c Mạnh
                        //chkIsCongVan.Visible = true;
                        txtSoCMND.Text = Session[SS_TK.SOCMND] + "";
                        txtNguoigui.Text = Session[SS_TK.NGUOIGUI] + "";
                        txtSoQDBA.Text = Session[SS_TK.SOBAQD] + "";
                        txtNgayBA.Text = Session[SS_TK.NGAYBAQD] + "";
                        try
                        {
                            if ((Session[SS_TK.HUYENID] + "") != "" && (Session[SS_TK.HUYENID] + "") != "0")
                            {
                                decimal IDHuyen = Convert.ToDecimal(Session[SS_TK.HUYENID]);
                                DM_HANHCHINH oHC = dt.DM_HANHCHINH.Where(x => x.ID == IDHuyen).FirstOrDefault();
                                hddNGDCID.Value = oHC.ID.ToString();
                                txtNGHuyen.Text = oHC.MA_TEN;
                                txtDiachi.Text = Session[SS_TK.DIACHICHITIET] + "";
                            }
                            if (Session[SS_TK.TOAANXX] != null) ddlToaXetXu.SelectedValue = Session[SS_TK.TOAANXX] + "";
                            //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                            decimal sothuly_ = 0;
                            oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                            txtSoThuLy.Text = Convert.ToString(sothuly_);
                            //-------------------
                            LoadIsTuHinh(ddlLoaiAn.SelectedValue);
                            txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
                            ///--------
                            Load_NKN_BC();
                        }
                        catch (Exception ex) { }
                        TrangThaiDon_load(0, false);
                        ThuLy_load(0, true);
                    }
                    if (ddlCapXetXu.SelectedValue == "3")
                    {
                        pnPhucTham.Visible = false;
                        pnAnST.Visible = true;
                    }
                    Check_Nguoi_KN_LoaiAn();
                    ddlHinhthucdonChange();
                    setLoaichuyen();
                    ChuyendenDVChange(0);

                    //Xoa thu ly Kiem tra xem neu la Don thu ly moi thi hien thị nut                     
                    AnHienkhiXoathulydon(hddID.Value);
                    DonTrung_Check();
                    //20/12/2024 chi mo ra de test 
                    //load_temp_suadulieu();
                    var idF = Request["cc_id"];
                    if (idF != "" && idF != "0" && idF != null)
                    {
                        decimal ID = Convert.ToDecimal(idF);
                        //GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        var GDTTT_CC_TC_MAPPINGExist = DataExtensions.GetAllByDonId<GDTTT_CC_TC_MAPPING>(ID).Count();
                        if (GDTTT_CC_TC_MAPPINGExist > 0)
                        {
                            lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                            lstMsgT.Text = lstMsgB.Text = "Đơn đã được xử lý. Vui lòng chọn đơn khác!";
                            divCommandT.Visible = false;
                            divCommandB.Visible = false;
                            return;
                        }

                        string strType = Request["type"] + "";
                        hddIDCC.Value = idF;

                        //pnDonTrung.Visible = false;
                        //hddID.Value = idF.ToString();
                        TrangThaiDon_load(ID, false);
                        LoadInfoCC(ID, false);
                        ThuLy_load(ID, false);
                        //check_span_batbuoc();
                        LoadBoSungTL(ID);
                        //Load danh sách trùng
                        LoadDSTrung();
                        LoadDSTLL();
                        LoadDSKemTheo();
                        Load_pnkiem_tratrung();


                        //---bi cao --người KN
                        ///--------
                        Load_NKN_BC();
                        //Load so thu ly
                        decimal sothuly_ = 0;
                        oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                        txtSoThuLy.Text = Convert.ToString(sothuly_);

                        if (rdbThuLy.SelectedValue == "2")
                            pnThuLy.Visible = false;
                        else
                            pnThuLy.Visible = true;
                        Cls_Comon.SetFocus(this, this.GetType(), rdbThuLy.ClientID);
                    }
                }
            }
            catch (Exception ex) { lstMsgB.Text = lstMsgT.Text = ex.Message; }
        }
        //----------------------------
        protected void cmdUpdate_NDBD_Click(object sender, EventArgs e)
        {
            if (hddID.Value != "" || hddID.Value != "0")
            {
                Decimal _ID = Convert.ToDecimal(hddID.Value);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == _ID).FirstOrDefault();
                UPDATE_NDBD_NKN(oT);
            }
            lstMsgBB.ForeColor = System.Drawing.Color.Blue;
            lstMsgBB.Text = "Lưu thành công";
        }


        protected void Load_NKN_BC()
        {
            if (ddlLoaiAn.SelectedValue == "01")
            {
                LoadDropNguoiKhieuNai();
                LoadDropBiCao();
                LoadDanhSachBiCao();
            }
            else
            {
                LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            }
        }
        private void Check_BC_NKN()
        {
            bool Check_display = false;
            string current_id = Request["ID"] + "";
            if (current_id != "" && current_id != "0")
            {
                string strType = Request["type"] + "";
                if (strType == "dontrung")
                {
                    Check_display = false;
                    if (hddID.Value != "" && hddID.Value != "0")
                    {
                        Check_display = true;
                        current_id = hddID.Value;
                    }
                }
                else
                {
                    Check_display = true;
                }
                Session["DONID_CC"] = current_id;
            }
            else
            {
                if (hddID.Value != "" && hddID.Value != "0")
                {
                    Check_display = true;
                    Session["DONID_CC"] = hddID.Value;
                }
                else
                {
                    Check_display = false;
                    Session["DONID_CC"] = null;
                }
            }
            if (Check_display == true)
            {
                Cls_Comon.SetButton(cmdSaveDSHinhSu, true);
                Cls_Comon.SetButton(cmdRefresh, true);
                lkThemNguoiKN.Enabled = true;
                lkThemNguoiKN.CssClass = "button_empty";
                lkThem_BC.Enabled = true;
                lkThem_BC.CssClass = "button_empty";
                lkThemND.Enabled = true;
                lkThemND.CssClass = "buttonpopup them_user clear_bottom";
                lkThemBD.Enabled = true;
                lkThemBD.CssClass = "buttonpopup them_user clear_bottom";
                lkThemDSKhac.Enabled = true;
                lkThemDSKhac.CssClass = "buttonpopup them_user clear_bottom";
                Cls_Comon.SetButton(cmdUpdate_NDBD, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdSaveDSHinhSu, false);
                Cls_Comon.SetButton(cmdRefresh, false);
                lkThemNguoiKN.Enabled = false;
                lkThemNguoiKN.CssClass = "button_empty_disable";
                lkThem_BC.Enabled = false;
                lkThem_BC.CssClass = "button_empty_disable";
                lkThemND.Enabled = false;
                lkThemND.CssClass = "buttonpopup_diable them_user_diable clear_bottom";
                lkThemBD.Enabled = false;
                lkThemBD.CssClass = "buttonpopup_diable them_user_diable clear_bottom";
                lkThemDSKhac.Enabled = false;
                lkThemDSKhac.CssClass = "buttonpopup_diable them_user_diable clear_bottom";
                Cls_Comon.SetButton(cmdUpdate_NDBD, false);
            }
        }
        private void ThuLy_load(decimal ID, bool isLoadTrung)
        {

            rdbThuLy.Items.Clear();
            if (ID > 0)
            {
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (isLoadTrung)
                {
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    string V_GQD_LOAIKETQUA = "0";
                    oBL.GET_KETQUA_GQ(Convert.ToString(ID), ref V_GQD_LOAIKETQUA);
                    if (oT != null)
                    {
                        if (oT.ISTHULY == 1)//&& V_GQD_LOAIKETQUA == "0"
                        {
                            rdbThuLy.Items.Add(new ListItem("Thụ lý trùng TP", "1"));
                            rdbThuLy.Items.Add(new ListItem("Đã thụ lý", "2"));
                        }
                        else
                        {
                            rdbThuLy.Items.Add(new ListItem("Thụ lý mới", "1"));
                            rdbThuLy.Items.Add(new ListItem("Đã thụ lý", "2"));
                        }
                        rdbThuLy.SelectedValue = "2";
                        txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    }
                }
                else
                {
                    if (oT.ISTHULY == 1 && oT.ARR_DON_ID > 0)
                    {
                        rdbThuLy.Items.Add(new ListItem("Thụ lý trùng TP", "1"));
                        rdbThuLy.Items.Add(new ListItem("Đã thụ lý", "2"));
                    }
                    else
                    {
                        rdbThuLy.Items.Add(new ListItem("Thụ lý mới", "1"));
                        rdbThuLy.Items.Add(new ListItem("Đã thụ lý", "2"));
                    }
                    rdbThuLy.SelectedValue = Convert.ToString(oT.ISTHULY);
                }
            }
            else
            {
                rdbThuLy.Items.Add(new ListItem("Thụ lý mới", "1"));
                rdbThuLy.Items.Add(new ListItem("Đã thụ lý", "2"));
                rdbThuLy.SelectedValue = "2";
            }
        }
        private void TrangThaiDon_load(decimal ID, bool is_load)
        {
            if (ID > 0)
            {
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.CD_TA_TRANGTHAI != null)
                {
                    ddlTrangthaidon.SelectedValue = oT.CD_TA_TRANGTHAI.ToString();
                }
                if (oT.CD_TA_TRANGTHAI == null)
                {
                    ddlTrangthaidon.SelectedValue = "1";
                }
                ddlTrangthaidon_SelectedIndexChanged(new object(), new EventArgs());
            }
        }
        private void Dongkhieunai_Check_Update(String _ID, Decimal _ID_NEW_KEMTHEO)
        {
            Decimal ID = Convert.ToDecimal(_ID);
            if (ID > 0)
            {
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (_ID_NEW_KEMTHEO > 0)
                {
                    GDTTT_DON oT_kt = dt.GDTTT_DON.Where(x => x.ID == _ID_NEW_KEMTHEO).FirstOrDefault();
                    if (oT_kt.DONGKHIEUNAI.Trim() == "")
                    {
                        oT_kt.DONGKHIEUNAI = oT.DONGKHIEUNAI;
                        dt.SaveChanges();
                    }
                }
                if (_ID_NEW_KEMTHEO == 0)
                {
                    if (oT.DONGKHIEUNAI.Trim() == "")
                    {
                        string strDSNguoiKN = "";
                        if (ddlHinhthucdon.SelectedValue == "2" || ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9")
                        {
                            strDSNguoiKN = oT.CV_TENDONVI;
                        }
                        else if (ddlHinhthucdon.SelectedValue == "4")
                        {
                            strDSNguoiKN = drop_DONVICHUYEN_HSKN.Text;
                        }
                        else
                        {
                            strDSNguoiKN = oT.NGUOIGUI_HOTEN;
                        }
                        //Lưu người khiếu nại
                        foreach (DataGridItem item in dgNguoiKN.Items)
                        {
                            TextBox txtHoten = (TextBox)item.FindControl("txtHoten");
                            TextBox txtDiachi = (TextBox)item.FindControl("txtDiachi");
                            DropDownList ddlGioitinhDNK = (DropDownList)item.FindControl("ddlGioitinhDNK");
                            string strKNID = item.Cells[0].Text;
                            if (txtHoten.Text.Trim() != "")
                            {
                                strDSNguoiKN = strDSNguoiKN + ", " + txtHoten.Text.Trim();
                                GDTTT_DON_NGUOIKN oKN = new GDTTT_DON_NGUOIKN();
                                if (strKNID != "" && strKNID != "0")
                                {
                                    decimal KNID = Convert.ToDecimal(strKNID);
                                    oKN = dt.GDTTT_DON_NGUOIKN.Where(x => x.ID == KNID).FirstOrDefault();
                                    oKN.HOTEN = txtHoten.Text;
                                    oKN.DIACHI = txtDiachi.Text;
                                    oKN.GIOITINH = Convert.ToDecimal(ddlGioitinhDNK.SelectedValue);
                                    oKN.DONID = oT.ID;
                                }
                                else
                                {
                                    oKN.HOTEN = txtHoten.Text;
                                    oKN.DIACHI = txtDiachi.Text;
                                    oKN.GIOITINH = Convert.ToDecimal(ddlGioitinhDNK.SelectedValue);
                                    oKN.DONID = oT.ID;
                                    dt.GDTTT_DON_NGUOIKN.Add(oKN);
                                }
                            }
                            else
                            {
                                if (strKNID != "" && strKNID != "0")
                                {
                                    decimal KNID = Convert.ToDecimal(strKNID);
                                    GDTTT_DON_NGUOIKN oKN = dt.GDTTT_DON_NGUOIKN.Where(x => x.ID == KNID).FirstOrDefault();
                                    dt.GDTTT_DON_NGUOIKN.Remove(oKN);
                                }
                            }
                        }
                        if (txtNguoigui_VB.Text != null && txtNguoigui_VB.Text != "")
                        {
                            oT.NGUOIGUI_HOTEN = txtNguoigui_VB.Text;
                        }
                        oT.DONGKHIEUNAI = strDSNguoiKN;
                        //--------------
                        dt.SaveChanges();
                    }
                }
            }
        }
        private void DonTrung_Check()
        {
            string current_id = Request["ID"] + "";
            decimal _ID = 0;
            if (current_id != "" && current_id != "0")
            {
                _ID = Convert.ToDecimal(current_id);
            }
            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == _ID).FirstOrDefault();
            string strType = Request["type"] + "";
            if (strType == "dontrung")
            {
                if (oT.ISTHULY == 1)
                {
                    //ddl_LOAI_GDTTT.Enabled = false;
                    //rdbBAQD.Enabled = false;
                    //chkKN_TBTLD.Enabled = false;
                    //txtSoQDBA.Enabled = false;
                    //txtNgayBA.Enabled = false;
                    ////------------
                    //ddlToaXetXu.Enabled = false;
                    //ddlCapXetXu.Enabled = false;
                    //chkIsNotGDT.Enabled = false;
                    ////------------
                    //txtSoBA_ST.Enabled = false;
                    //txtNgayBA_ST.Enabled = false;
                    //dropToaAnST.Enabled = false;
                    //------------
                    rdbLoaichuyen.Enabled = false;
                    //ddlChuyendenDV.Enabled = false;
                    ddlLoaiAn.Enabled = false;
                    ddlTrangthaidon.Enabled = false;
                }
            }
            GDTTT_DON oTchon = new GDTTT_DON();
            if (hddDontrungID_Chon.Value != "0")
            {
                decimal _ChonID = Convert.ToDecimal(hddDontrungID_Chon.Value);
                oTchon = dt.GDTTT_DON.Where(x => x.ID == _ChonID).FirstOrDefault();
                if (oTchon.ISTHULY == 1)
                {
                    //ddl_LOAI_GDTTT.Enabled = false;
                    //rdbBAQD.Enabled = false;
                    //chkKN_TBTLD.Enabled = false;
                    //txtSoQDBA.Enabled = false;
                    //txtNgayBA.Enabled = false;
                    ////------------
                    //ddlToaXetXu.Enabled = false;
                    //ddlCapXetXu.Enabled = false;
                    //chkIsNotGDT.Enabled = false;
                    ////------------
                    //txtSoBA_ST.Enabled = false;
                    //txtNgayBA_ST.Enabled = false;
                    //dropToaAnST.Enabled = false;
                    //------------
                    rdbLoaichuyen.Enabled = false;
                    //ddlChuyendenDV.Enabled = false;
                    ddlLoaiAn.Enabled = false;
                    ddlTrangthaidon.Enabled = false;
                }
            }
        }
        private void Huy_DonTrung_Check()
        {
            if (hddDontrungID_Huy.Value != "0")//khi nhấn vào nút hủy trùng
            {
                rdbLoaichuyen.Enabled = true;
                ddlChuyendenDV.Enabled = true;
                ddlLoaiAn.Enabled = true;
                ddlTrangthaidon.Enabled = true;
            }
        }
        private void Set_ThamPhan_ThuLylai(decimal ID, bool isLoadTrung)
        {
            if (ID > 0)
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                oBL.SET_THAMPHAN_THULYLAI(hddDontrungID.Value, hddID.Value, ddlTrangthaidon.SelectedValue, rdbThuLy.SelectedValue);
            }
        }
        protected void check_span_batbuoc()
        {
            if (ddlHinhthucdon.SelectedValue == "5")
            {
                spSOBA.Visible = false; spNGBA.Visible = false; spTOAXX.Visible = false;
            }
            else
            {
                spSOBA.Visible = true; spNGBA.Visible = true; spTOAXX.Visible = true;
            }
        }
        //-----Dan su-----------------------
        protected void Create_NguyenDonBD()
        {
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            rptNguyenDon.DataSource = tbl;
            rptNguyenDon.DataBind();

            tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            rptBiDon.DataSource = tbl;
            rptBiDon.DataBind();

            tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            rptDsKhac.DataSource = tbl;
            rptDsKhac.DataBind();

        }
        void Update_DuongSu(string tucachtt, Repeater rpt)
        {
            GDTTT_DON_DUONGSU_CC obj = new GDTTT_DON_DUONGSU_CC();
            bool IsUpdate = false;
            Decimal CurrVuAnID = GetDonID();
            Decimal CurrDS = 0;
            String StrEditID = ",";
            String StrUpdate = "";
            int soluongdong = 0;
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
            int count_item = 0;
            foreach (RepeaterItem item in rpt.Items)
            {
                count_item++;
                IsUpdate = false;

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
                            obj = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.ID == CurrDS && x.DONID == CurrVuAnID).Single<GDTTT_DON_DUONGSU_CC>();
                            if (obj != null)
                                IsUpdate = true;
                            else obj = new GDTTT_DON_DUONGSU_CC();
                        }
                        catch (Exception ex) { obj = new GDTTT_DON_DUONGSU_CC(); }
                    }
                    else
                        obj = new GDTTT_DON_DUONGSU_CC();

                    obj.DONID = CurrVuAnID;
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
                    }
                    else
                    {
                        obj.DIACHI = "";
                        obj.HUYENID = 0;
                        obj.TINHID = 0;
                    }

                    if (!IsUpdate)
                    {
                        obj.NGAYTAO = DateTime.Now;
                        obj.NGUOITAO = UserName;
                        dt.GDTTT_DON_DUONGSU_CC.Add(obj);
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

            //-------------------------
            //StrUpdate = "";
            #region Update_ListNGUyenDon_BiDon Trong GDTTT_VuAn
            //if (!String.IsNullOrEmpty(StrUpdate) && tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
            //{
            //    switch (tucachtt)
            //    {
            //        case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
            //            objVA.NGUYENDON = StrUpdate;
            //            hddSoND.Value = count_item.ToString();
            //            break;
            //        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
            //            objVA.BIDON = StrUpdate;
            //            hddSoBD.Value = count_item.ToString();
            //            break;
            //        case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
            //            hddSoDSKhac.Value = count_item.ToString();
            //            break;
            //    }
            //    if (tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
            //    {
            //        objVA.TENVUAN = objVA.NGUYENDON + " - " + objVA.BIDON + " - " + dropQHPL.SelectedItem.Text;
            //        dt.SaveChanges();
            //    }
            //}
            #endregion

        }
        protected void rptNguyenDon_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Panel pn_diachi = (Panel)e.Item.FindControl("pn_diachi");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);
                //--------------------
                if (Session["VUVIECID_CC"] == null)
                {
                    if (Convert.ToInt16(rowView["isdelete"] + "") == 0)
                        lkXoa.Visible = false;
                    if (rowView["CD_TRANGTHAI"] + "" != "")
                    {
                        if (Convert.ToDecimal(rowView["CD_TRANGTHAI"] + "") > 0 && Convert.ToDecimal(rowView["CD_TRANGTHAI"] + "") != 3)
                        {
                            if (hddDontrungID.Value == "" || hddDontrungID.Value == "0")
                            {
                                lkXoa.Visible = false;
                            }
                            else
                            {
                                lkXoa.Visible = true;
                            }
                        }
                        else
                        {
                            lkXoa.Visible = true;
                        }
                    }
                    else
                    {
                        lkXoa.Visible = true;
                    }
                }
                else if (Session["VUVIECID_CC"] != null)
                {
                    lkXoa.Visible = false;
                }
                try
                {
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
                    if (rowView["IsInputAddress"] + "" == "" || rowView["IsInputAddress"] + "" == "0")
                    {
                        pn_diachi.Visible = false;
                    }
                    else
                    {
                        pn_diachi.Visible = true;
                        HiddenField hddHuyenID = (HiddenField)e.Item.FindControl("hddHuyenID");
                        string strHID = hddHuyenID.Value + "";
                        if (strHID != "")
                            ddlTinhHuyen.SelectedValue = strHID;
                    }
                }
                catch (Exception ex) { }
            }
        }
        protected void rptBiDon_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Panel pn_diachi = (Panel)e.Item.FindControl("pn_diachi");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);
                //--------------------
                if (Session["VUVIECID_CC"] == null)
                {
                    if (Convert.ToInt16(rowView["isdelete"] + "") == 0)
                        lkXoa.Visible = false;
                    if (rowView["CD_TRANGTHAI"] + "" != "")
                    {
                        if (Convert.ToDecimal(rowView["CD_TRANGTHAI"] + "") > 0 && Convert.ToDecimal(rowView["CD_TRANGTHAI"] + "") != 3)
                        {
                            if (hddDontrungID.Value == "" || hddDontrungID.Value == "0")
                            {
                                lkXoa.Visible = false;
                            }
                            else
                            {
                                lkXoa.Visible = true;
                            }
                        }
                        else
                        {
                            lkXoa.Visible = true;
                        }
                    }
                    else
                    {
                        lkXoa.Visible = true;
                    }
                }
                else if (Session["VUVIECID_CC"] != null)
                {
                    lkXoa.Visible = false;
                }
                try
                {
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
                    if (rowView["IsInputAddress"] + "" == "" || rowView["IsInputAddress"] + "" == "0")
                    {
                        pn_diachi.Visible = false;
                    }
                    else
                    {
                        pn_diachi.Visible = true;
                        HiddenField hddHuyenID = (HiddenField)e.Item.FindControl("hddHuyenID");
                        string strHID = hddHuyenID.Value + "";
                        if (strHID != "")
                            ddlTinhHuyen.SelectedValue = strHID;
                    }
                }
                catch (Exception ex) { }
            }
        }
        protected void rptDsKhac_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Panel pn_diachi = (Panel)e.Item.FindControl("pn_diachi");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);
                //--------------------
                if (Session["VUVIECID_CC"] == null)
                {
                    if (Convert.ToInt16(rowView["isdelete"] + "") == 0)
                        lkXoa.Visible = false;
                    if (rowView["CD_TRANGTHAI"] + "" != "")
                    {
                        if (Convert.ToDecimal(rowView["CD_TRANGTHAI"] + "") > 0 && Convert.ToDecimal(rowView["CD_TRANGTHAI"] + "") != 3)
                        {
                            if (hddDontrungID.Value == "" || hddDontrungID.Value == "0")
                            {
                                lkXoa.Visible = false;
                            }
                            else
                            {
                                lkXoa.Visible = true;
                            }
                        }
                        else
                        {
                            lkXoa.Visible = true;
                        }
                    }
                    else
                    {
                        lkXoa.Visible = true;
                    }
                }
                try
                {
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
                    if (rowView["IsInputAddress"] + "" == "" || rowView["IsInputAddress"] + "" == "0")
                    {
                        pn_diachi.Visible = false;
                    }
                    else
                    {
                        pn_diachi.Visible = true;
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
            decimal curr_duongsu_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_duongsu_id, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    break;
            }
        }

        protected void rptBiDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_duongsu_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_duongsu_id, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    break;
            }
        }

        protected void rptDsKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_duongsu_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_duongsu_id, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    break;
            }
        }

        void Xoa_DS(decimal curr_duongsu_id, string tucachtt)
        {
            string temp = "";
            int count_ds = 0;
            //-----------

            //-------------
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value + "");
            if (curr_duongsu_id > 0)
            {
                GDTTT_DON_DUONGSU_CC oT = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.ID == curr_duongsu_id).FirstOrDefault();
                if (oT != null)
                {
                    dt.GDTTT_DON_DUONGSU_CC.Remove(oT);
                    dt.SaveChanges();
                }
                //------------------------------------

                List<GDTTT_DON_DUONGSU_CC> lst = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == CurrVuAnID
                                                                            && x.TUCACHTOTUNG == tucachtt).ToList();
                if (lst != null && lst.Count > 0)
                {
                    count_ds = lst.Count;
                    foreach (GDTTT_DON_DUONGSU_CC ds in lst)
                        temp += ((string.IsNullOrEmpty(temp + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(ds.TENDUONGSU);
                }
                //---------------------------
                //GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
                //if (oVA != null)
                //{
                //    switch (tucachtt)
                //    {
                //        case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                //            oVA.NGUYENDON = temp;
                //            hddSoND.Value = count_ds > 0 ? count_ds.ToString() : "1";
                //            break;
                //        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                //            oVA.BIDON = temp;
                //            hddSoBD.Value = count_ds > 0 ? count_ds.ToString() : "1";
                //            break;
                //        case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                //            hddSoDSKhac.Value = count_ds.ToString();
                //            break;
                //    }

                //    if (tucachtt != ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
                //    {
                //        oVA.TENVUAN = oVA.NGUYENDON + " - " + oVA.BIDON + " - " + dropQHPL.SelectedItem.Text;
                //        dt.SaveChanges();
                //    }
                //}
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

            //-------------------------------
            DataTable tbl = null;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    rptNguyenDon.DataSource = tbl;
                    rptNguyenDon.DataBind();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    rptBiDon.DataSource = tbl;
                    rptBiDon.DataBind();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    rptDsKhac.DataSource = tbl;
                    rptDsKhac.DataBind();
                    break;
            }
            lttMsg.Text = "Xóa thành công!";
        }
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
        void LoadDMQuanHePL()
        {
            //    try
            //    {
            //        int LoaiAn = Convert.ToInt16(ddlLoaiAn.SelectedValue);
            //        List<GDTTT_DM_QHPL> lst = dt.GDTTT_DM_QHPL.Where(x => x.LOAIAN == LoaiAn).OrderBy(y => y.TENQHPL).ToList();
            //        if (lst != null && lst.Count > 0)
            //        {
            //            dropQHPL.Items.Clear();
            //            dropQHPL.DataSource = lst;
            //            dropQHPL.DataTextField = "TenQHPL";
            //            dropQHPL.DataValueField = "ID";
            //            dropQHPL.DataBind();
            //            dropQHPL.Items.Insert(0, new ListItem("Chọn", "0"));
            //        }
            //    }
            //    catch (Exception ex) { }
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
            tbl.Columns.Add("CD_TRANGTHAI", typeof(string));
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
            //-------------
            Decimal CurrVuAnID = 0;
            if (Session["VUVIECID_CC"] == null)
            {
                CurrVuAnID = GetDonID();
            }
            else if (Session["VUVIECID_CC"] != null)
            {
                CurrVuAnID = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
            }
            if (CurrVuAnID > 0)
            {
                GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
                DataTable tblData = new DataTable();
                if (Session["VUVIECID_CC"] == null)
                {
                    tblData = objBL.GetByDonID(CurrVuAnID, tucachtt);
                }
                else if (Session["VUVIECID_CC"] != null)
                {
                    tblData = objBL.GetByVuAnID(CurrVuAnID, tucachtt);
                }
                if (tblData != null && tblData.Rows.Count > 0)
                {
                    IsInputAddress = (string.IsNullOrEmpty(tblData.Rows[0]["IsInputAddress"] + "")) ? 0 : Convert.ToInt16(tblData.Rows[0]["IsInputAddress"] + "");
                    int count_data = tblData.Rows.Count;
                    foreach (DataRow row in tblData.Rows)
                    {
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
                            newrow["CD_TRANGTHAI"] = row["CD_TRANGTHAI"] + "";
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
                    newrow["CD_TRANGTHAI"] = 0;
                    tbl.Rows.Add(newrow);
                }
            }
            return tbl;
        }
        //-------------------------------------------      
        protected void chkND_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptNguyenDon.Items)
            {
                Panel pn_diachi = (Panel)item.FindControl("pn_diachi");
                if (chkND.Checked && pn_diachi != null)
                    pn_diachi.Visible = true;
                else pn_diachi.Visible = false;
            }
        }
        protected void lkThemND_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = msg_check;
                return;
            }
            //Update duong su
            Update_DuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);
            hddSoND.Value = (Convert.ToInt32(hddSoND.Value) + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            rptNguyenDon.DataSource = tbl;
            rptNguyenDon.DataBind();
        }
        //--------------------------
        protected void chkBD_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptBiDon.Items)
            {
                Panel pn_diachi = (Panel)item.FindControl("pn_diachi");
                if (chkBD.Checked && pn_diachi != null)
                    pn_diachi.Visible = true;
                else pn_diachi.Visible = false;
            }
        }
        protected void lkThemBD_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = msg_check;
                return;
            }
            //Update duong su
            Update_DuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);
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
                Panel pn_diachi = (Panel)item.FindControl("pn_diachi");
                if (chkDSKhac.Checked && pn_diachi != null)
                    pn_diachi.Visible = true;
                else pn_diachi.Visible = false;
            }
        }
        protected void lkThemDSKhac_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = msg_check;
                return;
            }
            //Update duong su
            Update_DuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);
            int old = Convert.ToInt32(hddSoDSKhac.Value);
            hddSoDSKhac.Value = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            rptDsKhac.DataSource = tbl;
            rptDsKhac.DataBind();
        }
        //-----Dan su end-----------------------
        //-Hinh su----Người khiếu nại, bị cáo anhvh add 20/04/2021-----------
        void LoadDropBiCao()
        {
            Decimal don_id = 0;
            //----------------
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = new DataTable();
            if (Session["VUVIECID_CC"] == null)
            {
                don_id = GetDonID();
                tbl = objBL.AHS_GetAllByLoaiDS_DONID(don_id, bicao);
            }
            else if (Session["VUVIECID_CC"] != null)
            {
                don_id = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
                tbl = objBL.AHS_GetAllByLoaiDS(don_id, bicao);
            }
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
        protected void dropNguoiKhieuNai_SelectedIndexChanged(object sender, EventArgs e)
        {


        }
        protected void cmd_loadbc_Click(object sender, EventArgs e)
        {
            LoadDropBiCao();
            LoadDanhSachBiCao();
        }
        protected void cmd_NguoiGui_check_Click(object sender, EventArgs e)
        {
            Session["SS_NGUOIGUI_DON"] = txtNguoigui.Text.Trim();
        }
        protected void rptBiCao_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                String temp = "";
                DataRowView dv = (DataRowView)e.Item.DataItem;
                Repeater rptBCKN = (Repeater)e.Item.FindControl("rptBCKN");
                Literal lttBiCao = (Literal)e.Item.FindControl("lttBiCao");
                Literal lttTenDS = (Literal)e.Item.FindControl("lttTenDS");
                //--------------------
                Literal lttSua = (Literal)e.Item.FindControl("lttSua");
                Literal ltt_them_td = (Literal)e.Item.FindControl("ltt_them_td");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                //--------------------
                if (Session["VUVIECID_CC"] == null)
                {
                    if (dv["CD_TRANGTHAI"] + "" != "")
                    {
                        if (Convert.ToDecimal(dv["CD_TRANGTHAI"] + "") > 0 && Convert.ToDecimal(dv["CD_TRANGTHAI"] + "") != 3)
                        {
                            if (hddDontrungID.Value == "" || hddDontrungID.Value == "0")
                            {
                                lttSua.Visible = false;
                                ltt_them_td.Visible = false;
                                lbtXoa.Visible = false;
                            }
                            else
                            {
                                lttSua.Visible = true;
                                ltt_them_td.Visible = true;
                                lbtXoa.Visible = true;
                            }
                        }
                        else
                        {
                            lttSua.Visible = true;
                            ltt_them_td.Visible = true;
                            lbtXoa.Visible = true;
                        }
                    }
                    else
                    {
                        lttSua.Visible = true;
                        ltt_them_td.Visible = true;
                        lbtXoa.Visible = true;
                    }
                    if (hddID.Value == "" || hddID.Value == "0")
                    {
                        lttSua.Visible = false;
                        ltt_them_td.Visible = false;
                        lbtXoa.Visible = false;
                    }
                }
                else if (Session["VUVIECID_CC"] != null)
                {
                    lttSua.Visible = false;
                    ltt_them_td.Visible = false;
                    lbtXoa.Visible = false;
                }
                /////----
                System.Web.UI.Control td_sua_div = e.Item.FindControl("td_sua_div");
                int is_nguoikn = Convert.ToInt16(dv["HS_IsKhieuNai"] + "");
                int is_bicao = Convert.ToInt16(dv["HS_IsBiCao"] + "");
                int is_dauvu = Convert.ToInt16(dv["HS_BiCanDauVu"] + "");

                lttSua.Text = "<a href='javascript:;' style='color:#0E7EEE' onclick='popup_edit_ND_BD(" + dv["ID"].ToString() + ");'>Sửa</a>";
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
                        if (hddDontrungID.Value == "" || hddDontrungID.Value == "0")
                        {
                            td_sua_div.Visible = false;
                        }
                        else
                        {
                            td_sua_div.Visible = true;
                        }
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
                    don_id = GetDonID();
                    GDTTT_VUANVUVIEC_DUONGSU_BL oBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
                    try
                    {
                        DataTable tbl = new DataTable();
                        if (Session["VUVIECID_CC"] == null)
                        {
                            tbl = oBL.AHS_GetBiCaoKN_ByNguoiKN_CC(don_id, NguoiKhieuNaiID);
                        }
                        else
                        {
                            tbl = oBL.AHS_GetBiCaoKN_ByNguoiKN(don_id, NguoiKhieuNaiID);
                        }

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
                            if (hddDontrungID.Value == "" || hddDontrungID.Value == "0")
                            {
                                td_sua_div.Visible = false;
                            }
                            else
                            {
                                td_sua_div.Visible = true;
                            }
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
        void LoadDsNguoiDuocKN(Decimal NguoiKhieuNaiID, String NoidungKN, Repeater rptBCKN, Literal lttBiCao)
        {
            Decimal don_id = GetDonID();
            //-------------------------
            String temp = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL oBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            try
            {
                DataTable tbl = new DataTable();
                if (Session["VUVIECID_CC"] == null)
                    tbl = oBL.AHS_GetBiCaoKN_ByNguoiKN_CC(don_id, NguoiKhieuNaiID);
                else
                    tbl = oBL.AHS_GetBiCaoKN_ByNguoiKN(don_id, NguoiKhieuNaiID);

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
        protected void rptBiCao_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Sua":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_ND_BD(" + curr_id + ");");
                    break;
                case "them_td":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_td_cc(" + curr_id + ");");
                    break;
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_DUONGSU_CC oT = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.ID == curr_id).FirstOrDefault();
                    if (oT.HS_ISKHIEUNAI == 1)
                    {
                        if (hddDontrungID.Value != "" && hddDontrungID.Value != null && hddDontrungID.Value != "0")
                        {
                            XoaDuongSu_AnHS(curr_id);
                            LoadDanhSachBiCao();
                            LoadDropBiCao();
                            lttMsgBC.Text = "Xóa bị cáo thành công";
                        }
                        else
                        {
                            lttMsgBC.Text = "Bạn không thể xóa được người khiếu nại.";
                        }
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
            Decimal CurrVuAnID = GetDonID();
            if (curr_duongsu_id > 0)
            {
                GDTTT_DON_DUONGSU_CC oT = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.ID == curr_duongsu_id).FirstOrDefault();
                if (oT != null)
                {
                    XoaAllToiDanh(curr_duongsu_id);
                    //------------------------------------
                    dt.GDTTT_DON_DUONGSU_CC.Remove(oT);
                    dt.SaveChanges();
                }
            }
            lttMsgBC.Text = "Xóa thành công!";
        }
        void XoaAllToiDanh(Decimal DuongsuID)
        {
            Decimal CurrVuAnID = GetDonID();
            List<GDTTT_DON_DUONGSU_TOIDANH_CC> lst = dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.DONID == CurrVuAnID && x.DUONGSUID == DuongsuID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_DON_DUONGSU_TOIDANH_CC item in lst)
                    dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Remove(item);
            }
            dt.SaveChanges();
        }
        public void LoadDanhSachBiCao()
        {
            Decimal don_id = 0;
            //----------------
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = new DataTable();
            if (Session["VUVIECID_CC"] == null)
            {
                don_id = GetDonID();
                if (hddID.Value != "" && hddID.Value != "0")
                {
                    tbl = objBL.AnHS_GetAllDuongSu_CC(don_id, "", 2);
                }
                else//khi chọn là đơn trùng thì không load người khiếu nại
                {
                    tbl = objBL.AnHS_GetAllDuongSu_CC_NOT_KN(don_id, "", 2);
                }
            }
            else if (Session["VUVIECID_CC"] != null)
            {
                don_id = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
                tbl = objBL.AnHS_GetAllDuongSu(don_id, "", 2);
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows.Count);
                rptBiCao.DataSource = tbl;
                rptBiCao.DataBind();
                rptBiCao.Visible = true;
            }
            else rptBiCao.Visible = false;
        }
        protected void dropBiCao_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        protected void lkThemNguoiKN_Click(object sender, EventArgs e)
        {
            Decimal don_id = GetDonID();
            //---------------------------
            try
            {
                if (ddlHinhthucdon.SelectedValue == "4")
                {
                    if (dropNguoiKhieuNai.Items.Count == 1)
                    {
                        if (drop_DONVICHUYEN_HSKN.SelectedValue == "0")
                        {
                            lttMsgBC_NKN.Text = "Bạn phải chọn Đơn vị chuyển HS";
                        }
                        else
                        {
                            ThemNguoiKhieuNai(don_id, drop_DONVICHUYEN_HSKN.SelectedItem.Text);
                            LoadDropNguoiKhieuNai();
                            LoadDanhSachBiCao();
                            LoadDropBiCao();
                            lttMsgBC_NKN.Text = "Bạn đã tạo người khiếu nại thành công";
                            if (dropNguoiKhieuNai.Items.Count > 1)
                            {
                                dropNguoiKhieuNai.SelectedIndex = 1;
                            }
                        }
                    }
                    else
                    {
                        Session["SS_NGUOIGUI_DON"] = txtNguoigui.Text.Trim();
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_ND_BD(" + don_id + ")");
                    }
                }
                else
                {
                    if (dropNguoiKhieuNai.Items.Count == 1)
                    {
                        if (txtNguoigui.Text.Trim() == "" && txtNGHuyen.Text.Trim() == "")
                        {
                            lttMsgBC_NKN.Text = "Bạn phải nhập người gửi và địa chỉ gửi";
                        }
                        else if (txtNguoigui.Text.Trim() == "")
                        {
                            lttMsgBC_NKN.Text = "Bạn phải nhập người gửi";
                        }
                        else if (txtNGHuyen.Text.Trim() == "")
                        {
                            lttMsgBC_NKN.Text = "Bạn phải nhập địa chỉ gửi";
                        }
                        else
                        {
                            ThemNguoiKhieuNai(don_id, txtNguoigui.Text.Trim());
                            LoadDropNguoiKhieuNai();
                            LoadDanhSachBiCao();
                            LoadDropBiCao();
                            lttMsgBC_NKN.Text = "Bạn đã tạo người khiếu nại thành công";
                            if (dropNguoiKhieuNai.Items.Count > 1)
                            {
                                dropNguoiKhieuNai.SelectedIndex = 1;
                            }
                        }
                    }
                    else
                    {
                        Session["SS_NGUOIGUI_DON"] = txtNguoigui.Text.Trim();
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_ND_BD(" + don_id + ")");
                    }
                }
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void lkThemBiCao_Click(object sender, EventArgs e)
        {
            lttMsgBC_NKN.Text = string.Empty;
            Decimal don_id = GetDonID();
            try
            {
                Session["SS_NGUOIGUI_DON"] = txtNguoigui.Text.Trim();
                Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_ND_BD(" + don_id + ")");
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
            }
        }
        void LoadDropNguoiKhieuNai()
        {
            Decimal don_id = 0;
            //----------------
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = new DataTable();
            if (Session["VUVIECID_CC"] == null)
            {
                don_id = GetDonID();
                tbl = objBL.AHS_GetAllByLoaiDS_DONID(don_id, 2);
            }
            else if (Session["VUVIECID_CC"] != null)
            {
                don_id = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
                tbl = objBL.AHS_GetAllByLoaiDS(don_id, 2);
            }
            dropNguoiKhieuNai.Items.Clear();
            dropNguoiKhieuNai.Items.Add(new ListItem("-----Chọn-----", "0"));

            if (tbl != null && tbl.Rows.Count > 0 && hddID.Value != "0")//khi chọn là đơn trùng thì không load người khiếu nại
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
        protected void ThemNguoiKhieuNai(Decimal CurrdonID, String TenDS)
        {
            String TenNguoiKhieuNai = TenDS.Trim().ToLower();
            Boolean IsUpdate = false;
            GDTTT_DON_DUONGSU_CC obj = new GDTTT_DON_DUONGSU_CC();
            List<GDTTT_DON_DUONGSU_CC> lst = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == CurrdonID
                                                                         && x.HS_ISKHIEUNAI == 1
                                                                         && x.TENDUONGSU.Trim().ToLower() == TenNguoiKhieuNai).ToList();
            if (lst != null && lst.Count > 0)
            {
                obj = lst[0]; IsUpdate = true;
            }
            else
            {
                obj = new GDTTT_DON_DUONGSU_CC();
            }
            obj.DONID = CurrdonID;

            obj.LOAI = 0;
            obj.GIOITINH = 2;
            obj.NAMSINH = 0;
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
            if (txtDiachi.Text.Trim() != "")
            {
                obj.DIACHI = txtDiachi.Text.Trim() + ", " + txtNGHuyen.Text;
            }
            else
            {
                obj.DIACHI = txtNGHuyen.Text;
            }
            //----------------------
            if (!IsUpdate)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

                dt.GDTTT_DON_DUONGSU_CC.Add(obj);
                dt.SaveChanges();
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
        void XoaDuongSu_AnHS_BCKN(decimal curr_duongsu_id)
        {
            if (curr_duongsu_id > 0)
            {
                GDTTT_DON_DS_KN_CC oT = dt.GDTTT_DON_DS_KN_CC.Where(x => x.ID == curr_duongsu_id).FirstOrDefault();
                if (oT != null)
                {
                    //XoaAllToiDanh(Convert.ToDecimal(oT.BICAOID));
                    Xoa_KN(Convert.ToDecimal(oT.BICAOID));
                    //------------------------------------
                    GDTTT_DON_DUONGSU_CC oTs = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.ID == oT.BICAOID).FirstOrDefault();
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
            Decimal don_id = GetDonID();
            //-------------------------------------
            List<GDTTT_DON_DS_KN_CC> lst = dt.GDTTT_DON_DS_KN_CC.Where(x => x.DONID == don_id
                                                                    && x.BICAOID == BiCaoID
                                                                ).ToList<GDTTT_DON_DS_KN_CC>();
            foreach (GDTTT_DON_DS_KN_CC item in lst)
            {
                dt.GDTTT_DON_DS_KN_CC.Remove(item);
            }
            dt.SaveChanges();
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
            Decimal don_id = GetDonID();
            //-------------
            Boolean IsUpdate = false;
            GDTTT_DON_DS_KN_CC oKN = new GDTTT_DON_DS_KN_CC();
            Decimal NguoiKhieuNaiId = Convert.ToDecimal(dropNguoiKhieuNai.SelectedValue);
            GDTTT_DON_DS_KN_CC objDSKN = new GDTTT_DON_DS_KN_CC();
            try
            {
                List<GDTTT_DON_DS_KN_CC> lst = dt.GDTTT_DON_DS_KN_CC.Where(x => x.DONID == don_id
                                                                     && x.BICAOID == BiCaoID
                                                                     && x.NGUOIKHIEUNAIID == NguoiKhieuNaiId).ToList();
                if (lst != null && lst.Count > 0)
                {
                    oKN = lst[0];
                    IsUpdate = true;
                }
                else
                    oKN = new GDTTT_DON_DS_KN_CC();
            }
            catch (Exception ex)
            {
                oKN = new GDTTT_DON_DS_KN_CC();
            }
            oKN.BICAOID = BiCaoID;
            oKN.NGUOIKHIEUNAIID = NguoiKhieuNaiId;
            oKN.DONID = don_id;
            oKN.NOIDUNGKHIEUNAI = txtNguoiKN_NoiDung.Text.Trim();
            if (!IsUpdate)
            {
                dt.GDTTT_DON_DS_KN_CC.Add(oKN);
            }
            dt.SaveChanges();
        }
        protected void cmdRefresh_Click(object sender, EventArgs e)
        {
            LoadDanhSachBiCao();
            LoadDropNguoiKhieuNai();
            LoadDropBiCao();
            lttMsgBC.Text = string.Empty;
            lttMsgBC_NKN.Text = string.Empty;
            txtNguoiKN_NoiDung.Text = string.Empty;
        }
        protected void cmd_load_dstd_cc_Click(object sender, EventArgs e)
        {
            LoadDanhSachBiCao();
        }
        //-----NĐ,BĐ,nguoi khieu nai
        protected void UPDATE_NDBD_NKN(GDTTT_DON obj)
        {
            Decimal CurrDS = GetDonID();

            DUONGSU_INS_UP();

            //-------------
            List<GDTTT_DON_DUONGSU_CC> lst = new List<GDTTT_DON_DUONGSU_CC>();
            lst = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == CurrDS).OrderByDescending(x => x.NGAYTAO).ToList();
            foreach (GDTTT_DON_DUONGSU_CC dt in lst)
            {
                dt.DONID = obj.ID;
            }
            if (ddlLoaiAn.SelectedValue == "01")
            {
                List<GDTTT_DON_DUONGSU_TOIDANH_CC> lst_td = new List<GDTTT_DON_DUONGSU_TOIDANH_CC>();
                lst_td = dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.DONID == CurrDS).OrderByDescending(x => x.ID).ToList();
                foreach (GDTTT_DON_DUONGSU_TOIDANH_CC dt in lst_td)
                {
                    dt.DONID = obj.ID;
                }
                List<GDTTT_DON_DS_KN_CC> lst_bc = new List<GDTTT_DON_DS_KN_CC>();
                lst_bc = dt.GDTTT_DON_DS_KN_CC.Where(x => x.DONID == CurrDS).OrderByDescending(x => x.ID).ToList();
                foreach (GDTTT_DON_DS_KN_CC dt in lst_bc)
                {
                    dt.DONID = obj.ID;
                }
            }
            dt.SaveChanges();
            //-------------
        }
        protected void DUONGSU_INS_UP()
        {
            String msg_check = CheckNhapDuongSu();
            //Update duong su
            if (ddlLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                Update_DuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);
                LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            }
            Update_DuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);
            LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);

            Update_DuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);
            LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
        }
        string CheckNhapDuongSu()
        {
            String StrNguyenDon = "", StrBiDon = "";
            int count_item = 0;
            if (ddlLoaiAn.SelectedValue != ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                foreach (RepeaterItem item in rptNguyenDon.Items)
                {
                    count_item++;
                    TextBox txtTen = (TextBox)item.FindControl("txtTen");
                    if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                        StrNguyenDon += (String.IsNullOrEmpty(StrNguyenDon) ? "" : ", ") + count_item.ToString();
                }
                if (!String.IsNullOrEmpty(StrNguyenDon))
                    StrNguyenDon = "nguyên đơn thứ " + StrNguyenDon;
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
                StrBiDon = "bị đơn  thứ " + StrBiDon;

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

        void LoadDsDuongSu(Repeater rpt, String tucachtt)
        {
            int count_all = 0, IsInputAddress = 0;

            Decimal CurrVuAnID = 0;
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = new DataTable();
            if (Session["VUVIECID_CC"] == null)
            {
                CurrVuAnID = GetDonID();
                tbl = objBL.GetByDonID(CurrVuAnID, tucachtt);
            }
            else if (Session["VUVIECID_CC"] != null)
            {
                CurrVuAnID = Convert.ToDecimal(Session["VUVIECID_CC"] + "");
                tbl = objBL.GetByVuAnID(CurrVuAnID, tucachtt);
            }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                count_all = tbl.Rows.Count;
                IsInputAddress = Convert.ToInt16(tbl.Rows[0]["IsInputAddress"] + "");
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
            }
            rpt.DataSource = tbl;
            rpt.DataBind();

            //--------------------
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    if (count_all > 0)
                    {
                        hddSoND.Value = count_all.ToString();
                        chkND.Checked = (IsInputAddress == 0) ? false : true;
                    }
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    if (count_all > 0)
                    {
                        hddSoBD.Value = count_all.ToString();
                        chkBD.Checked = (IsInputAddress == 0) ? false : true;
                    }
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    if (count_all > 0)
                    {
                        hddSoDSKhac.Value = count_all.ToString();
                        chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                    }
                    break;
            }
        }
        //-----kiem tra an thoi hieu-----------
        private void Canhbao_thoihieu()
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal capxx = Convert.ToDecimal(ddlCapXetXu.SelectedValue);
            decimal loaian = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            DateTime ngayBA;
            DateTime ngayThuly;
            TimeSpan t;
            String strMsg;
            if (txtNgaythuly.Text != "")
                ngayThuly = DateTime.Parse(txtNgaythuly.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayThuly = DateTime.Today;
            if (txtNgayBA.Text != "")
                ngayBA = DateTime.Parse(txtNgayBA.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            else
                ngayBA = DateTime.Today;

            t = ngayThuly - ngayBA;

            if (capxx == 2)
            {
                if (loaian == 1)
                {
                    if ((1 * 365 - t.TotalDays) <= 60 && (1 * 365 - t.TotalDays) > 0)
                    {
                        strMsg = "Còn " + (1 * 365 - t.TotalDays) + " ngày nữa là hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                    else if ((1 * 365 - t.TotalDays) <= 0)
                    {
                        strMsg = "Đã hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                }
                //an hanh chinh
                else if (loaian == 6)
                {
                    if ((3 * 365 - t.TotalDays) <= 30 && (3 * 365 - t.TotalDays) > 0)
                    {
                        strMsg = "Còn " + (3 * 365 - t.TotalDays) + " ngày nữa là hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                    else if ((3 * 365 - t.TotalDays) <= 0)
                    {
                        strMsg = "Đã hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                }
                else
                {

                    if ((3 * 365 - t.TotalDays) < 30 && (3 * 365 - t.TotalDays) > 0)
                    {
                        strMsg = "Còn " + (3 * 365 - t.TotalDays) + " ngày nữa là hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                    else
                    {
                        if ((5 * 365 - t.TotalDays) < 30 && (5 * 365 - t.TotalDays) > 0)
                        {
                            strMsg = "Còn " + (5 * 365 - t.TotalDays) + " ngày nữa là hết thời hiệu giải quyết";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        }
                        else if ((5 * 365 - t.TotalDays) <= 0)
                        {
                            strMsg = "Đã hết thời hiệu giải quyết";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        }

                    }
                }
            }
            else
            {

                if (loaian == 1)
                {
                    if ((1 * 365 - t.TotalDays) <= 60 && (1 * 365 - t.TotalDays) > 0)
                    {
                        strMsg = "Còn " + (1 * 365 - t.TotalDays) + " ngày nữa là hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                    else if ((1 * 365 - t.TotalDays) <= 0)
                    {
                        strMsg = "Đã hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                }
                //an hanh chinh
                else if (loaian == 6)
                {
                    if ((3 * 365 - t.TotalDays) <= 30 && (3 * 365 - t.TotalDays) > 0)
                    {
                        strMsg = "Còn " + (3 * 365 - t.TotalDays) + " ngày nữa là hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                    else if ((3 * 365 - t.TotalDays) <= 0)
                    {
                        strMsg = "Đã hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                }
                else
                {

                    if ((3 * 365 - t.TotalDays) <= 30 && (3 * 365 - t.TotalDays) > 0)
                    {
                        strMsg = "Còn " + (3 * 365 - t.TotalDays) + " ngày nữa là hết thời hiệu giải quyết";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    }
                    else
                    {
                        if ((5 * 365 - t.TotalDays) <= 30 && (5 * 365 - t.TotalDays) > 0)
                        {
                            strMsg = "Còn " + (5 * 365 - t.TotalDays) + " ngày nữa là hết thời hiệu giải quyết";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        }
                        else if ((5 * 365 - t.TotalDays) <= 0)
                        {
                            strMsg = "Đã hết thời hiệu giải quyết";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        }

                    }
                }
            }

        }
        private void LoadInfo(decimal ID, bool isLoadTrung)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
            try
            {
                rdbThamquyen.SelectedValue = oBL.GET_TPB3(ID);
            }
            catch (Exception e) { }
            string strType = Request["type"] + "";
            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                //Them ngay xu ly don
                if (oT.NGAYXULYDON != null)
                {
                    if (((DateTime)oT.NGAYXULYDON).ToString("dd/MM/yyyy") == "01/01/0001")
                        txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    else
                        txtNgayXuLy.Text = ((DateTime)oT.NGAYXULYDON).ToString("dd/MM/yyyy");
                }
                else
                    txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");


                if (oT.LOAIDON != null)
                {
                    ddlHinhthucdon.SelectedValue = oT.LOAIDON.ToString();
                    ddlHinhthucdon_kntc.SelectedValue = oT.LOAIDON.ToString();
                }
                ddlHinhthucdonChange();
                LoadPhongban();
                if (ddlHinhthucdon_kntc.SelectedValue != "8" && ddlHinhthucdon_kntc.SelectedValue != "10")
                {
                    ChuyendenDVChange(0);
                    LoadLoaiAn();
                }
                setLoaichuyen();

                ddl_LOAI_GDTTT.SelectedValue = Convert.ToString(oT.LOAI_GDTTTT);
                if (oT.BAQD_CAPXETXU == 2)
                    pnPhucTham.Visible = pnAnST.Visible = false;
                else if (oT.BAQD_CAPXETXU == 3)
                {
                    pnPhucTham.Visible = false;
                    pnAnST.Visible = true;
                }
                else
                {
                    //DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oT.BAQD_TOAANID).FirstOrDefault();
                    //if (oTA.LOAITOA == "CAPTINH")
                    //{
                    //    pnPhucTham.Visible = false;
                    //    pnAnST.Visible = true;
                    //}
                    //else
                    //    pnPhucTham.Visible = pnAnST.Visible = true;

                    var oTA = dt.DM_TOAAN.FirstOrDefault(x => x.ID == oT.BAQD_TOAANID);
                    if (oTA != null)
                    {
                        // Xử lý khi tìm thấy kết quả
                        if (oTA.LOAITOA == "CAPTINH")
                        {
                            pnPhucTham.Visible = false;
                            pnAnST.Visible = true;
                        }
                        else
                            pnPhucTham.Visible = pnAnST.Visible = true;

                    }
                }

                if (oT.CD_TRANGTHAI > 0 && oT.CD_TRANGTHAI != 3 && oT.CD_TRANGTHAI != 4 && isLoadTrung == false)
                {
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdUpdateAndNew, false);
                    Cls_Comon.SetButton(cmdUpdateB, false);
                    Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                }
                if (oT.CD_LOAI != null)
                {
                    rdbLoaichuyen.SelectedValue = oT.CD_LOAI.ToString();
                    setLoaichuyen();
                    switch (rdbLoaichuyen.SelectedValue)
                    {
                        case "0"://Nội bộ tòa án  
                            if (oT.CD_TA_DONVIID != null)
                            {
                                ddlChuyendenDV.SelectedValue = oT.CD_TA_DONVIID.ToString();
                            }
                            if (ddlHinhthucdon.SelectedValue == "5")
                            {
                                ddlChuyendenDV_VB.SelectedValue = oT.CD_TA_DONVIID.ToString();
                                txtNgayChuyen_VB.Text = oT.NGAYCHUYEN_VB + "" == "" ? "" : ((DateTime)oT.NGAYCHUYEN_VB).ToString("dd/MM/yyyy");
                            }
                            else if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
                            {
                                //Vơi don khieu nai tu phap và đơn vị nhận là hội đồng thẩm phán thì lưu thêm id lãnh đạo
                                if (ddlChuyendenDV.SelectedValue == "102")
                                {

                                    Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                    decimal v_chucdanh = 486;//TPTATC
                                    //Chi áp dung với TANDTC
                                    if (LoginDonViID == 1)
                                    {
                                        dropTPTC.Visible = true;
                                        LoadAllHoiDongTP(v_chucdanh, LoginDonViID);
                                        dropTPTC.SelectedValue = oT.CANBO_ID_GIAIQUYET_KN.ToString();
                                    }
                                    else
                                    {
                                        dropTPTC.Visible = false;
                                        dropTPTC.SelectedValue = "0";
                                    }
                                }

                            }

                            if (oT.CD_TA_DONVIID != null)
                            {
                                ChuyendenDVChange(Convert.ToDecimal(oT.CD_TA_DONVIID));
                                LoadLoaiAn();
                                //16/04/2025
                                if (strType == "dontrung")
                                {

                                }
                            }

                            if (pnBAQDGDT.Visible)
                            {
                                if (oT.CD_TA_TRANGTHAI != null)
                                {
                                    ddlTrangthaidon.SelectedValue = oT.CD_TA_TRANGTHAI.ToString();
                                }
                                LoadLoaiAn();
                                try
                                {
                                    if (oT.BAQD_LOAIAN != null)
                                        ddlLoaiAn.SelectedValue = "0" + oT.BAQD_LOAIAN.ToString();
                                    LoadIsTuHinh(ddlLoaiAn.SelectedValue);
                                    if (trTuHinh.Visible)
                                    {
                                        chkIsTuHinh.Checked = oT.ISANTUHINH == 1 ? true : false;
                                        if (chkIsTuHinh.Checked)
                                        {
                                            chkIsAnGiam.Visible = chkKeuOan.Visible = true;
                                            chkIsAnGiam.Checked = oT.ISTH_ANGIAM == 1 ? true : false;
                                            chkKeuOan.Checked = oT.ISTH_KEUOAN == 1 ? true : false;
                                        }
                                    }
                                }
                                catch (Exception ex) { }
                                if (ddlTrangthaidon.SelectedValue == "1")
                                {
                                    lblLydoCDDK.Text = "Lý do";
                                    chkLydoCDDK.Visible = true;
                                    pnThuLy.Visible = false;
                                    rdbThuLy.Visible = false;
                                    chkLydoCDDK.Items[0].Selected = oT.CD_TA_LYDO_ISBAQD == 1 ? true : false;
                                    chkLydoCDDK.Items[1].Selected = oT.CD_TA_LYDO_ISXACNHAN == 1 ? true : false;
                                    chkLydoCDDK.Items[2].Selected = oT.CD_TA_LYDO_ISKHAC == 1 ? true : false;
                                    if (oT.CD_TA_LYDO_ISKHAC == 1)
                                    {
                                        trLydokhac.Visible = true;
                                        txtLydoCDDK_Khac.Text = oT.CD_TA_LYDO_KHAC + "";
                                    }
                                }
                                else
                                {
                                    lblLydoCDDK.Text = "Thụ lý đơn";
                                    chkLydoCDDK.Visible = false;

                                    rdbThuLy.Visible = true;
                                    if (oT.ISTHULY != null) rdbThuLy.SelectedValue = oT.ISTHULY + "";
                                    pnThuLy.Visible = true;
                                    txtSoThuLy.Text = oT.TL_SO + "";
                                    txtNgaythuly.Text = oT.TL_NGAY + "" == "" ? "" : ((DateTime)oT.TL_NGAY).ToString("dd/MM/yyyy");
                                    if (isLoadTrung)
                                    {
                                        //rdbThuLy.SelectedValue = "2";
                                        pnThuLy.Visible = false;
                                        //27/03/2024
                                        //string strOption = Request["option"] + "";
                                        //if (strOption == "thulylai")
                                        //{
                                        //    rdbThuLy.SelectedValue = "1";
                                        //}
                                    }
                                    else
                                    {
                                        if (rdbThuLy.SelectedValue == "2")
                                            pnThuLy.Visible = false;
                                    }
                                }
                                txt_QHPL.Text = oT.QHPL_TEXT;
                                // txt_GHICHU_TTCD.Text = oT.GHICHU_TTCD;
                            }
                            break;
                        case "1":
                            if (oT.CD_TK_DONVIID != null)
                            {
                                ddlToaKhac.SelectedValue = oT.CD_TK_DONVIID + "";

                            }
                            if (oT.CD_TK_NOIGUI != null)
                                rdbDonguitoi.SelectedValue = oT.CD_TK_NOIGUI.ToString();
                            break;
                        case "2":
                            txtNgoaitoaan.Text = oT.CD_NTA_TENDONVI;
                            break;
                        case "3":
                            if (oT.CD_TRALAI_LYDOID != null && oT.CD_TRALAI_LYDOID != 0)
                            {
                                ddlLydotralai.SelectedValue = oT.CD_TRALAI_LYDOID.ToString();
                            }
                            else
                            {
                                ddlLydotralai.SelectedValue = "0";
                                txtTralaikhac.Text = oT.CD_TRALAI_LYDOKHAC;
                                lblLydokhac.Visible = true;
                                txtTralaikhac.Visible = true;
                            }
                            txtTralaiYeucau.Text = oT.CD_TRALAI_YEUCAU;
                            txtTralaiSophieu.Text = oT.CD_TRALAI_SOPHIEU;
                            txtTralaiNgay.Text = oT.CD_TRALAI_NGAYTRA + "" == "" ? "" : ((DateTime)oT.CD_TRALAI_NGAYTRA).ToString("dd/MM/yyyy");
                            break;
                        default:
                            break;
                    }
                }
                ddlHinhthucdonChange_set_pnBAQDGDT();
                if (pnBAQDGDT.Visible)
                {
                    rdbBAQD.SelectedValue = oT.BAQD_LOAIQDBA.ToString();
                    if (rdbBAQD.SelectedValue == "1")
                    {
                        pnSoKhangNghi.Visible = true;

                        if (oT.BAQD_CAPXETXU == 4)
                        {
                            pnAnST.Visible = pnPhucTham.Visible = pnSoBA.Visible = true;
                        }
                        else if (oT.BAQD_CAPXETXU == 3)
                        {
                            pnPhucTham.Visible = pnSoBA.Visible = true;
                            pnAnST.Visible = false;
                        }
                        else if (oT.BAQD_CAPXETXU == 2)
                        {
                            pnAnST.Visible = true;
                            pnPhucTham.Visible = pnSoBA.Visible = false;
                        }
                        else
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                        }

                        if (oT.BAQD_CAPXETXU == 4)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                        }
                        if (oT.BAQD_CAPXETXU >= 3)
                        {
                            txtSoBA_PT.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_PT.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_PT > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnPT, oT.BAQD_TOAANID_PT);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                            }
                        }
                        if (oT.BAQD_CAPXETXU >= 2)
                        {
                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_ST > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                            }
                        }


                        txtSoQDKN.Text = oT.KN_SOQD;
                        txtNgayKhangNghi.Text = oT.KN_NGAY + "" == "" ? "" : ((DateTime)oT.KN_NGAY).ToString("dd/MM/yyyy");
                        if (oT.NGUOIKHANGNGHI != null)
                            ddlNguoiKhangNghi.SelectedValue = oT.NGUOIKHANGNGHI + "";
                    }
                    //else if (rdbBAQD.SelectedValue == "0")
                    //{

                    //}
                    else
                    {
                        rdbBAQD.SelectedValue = "0";
                        pnSoKhangNghi.Visible = false;
                        pnSoBA.Visible = true;
                        if (oT.BAQD_CAPXETXU == 4)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }


                            txtSoBA_PT.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_PT.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oT.BAQD_TOAANID).FirstOrDefault();
                            if (oTA.LOAITOA == "CAPTINH")
                            {
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                            else
                            {

                                if (oT.BAQD_TOAANID_PT > 0)
                                {
                                    Cls_Comon.SetValueComboBox(dropToaAnPT, oT.BAQD_TOAANID_PT);
                                    LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                                }
                            }

                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_ST > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                            }
                        }
                        else if (oT.BAQD_CAPXETXU == 3)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            //if (ddlToaXetXu.Items.FindByValue(oT.BAQD_TOAANID_PT + "") != null)
                            //    ddlToaXetXu.SelectedValue = oT.BAQD_TOAANID_PT + "";
                            if (oT.BAQD_TOAANID_PT > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID_PT);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                            }

                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }


                            if (oT.BAQD_TOAANID_ST > 0)
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                        }
                        else if (oT.BAQD_CAPXETXU == 2)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }


                            if (ddlToaXetXu.Items.FindByValue(oT.BAQD_TOAANID_ST + "") != null)
                                ddlToaXetXu.SelectedValue = oT.BAQD_TOAANID_ST + "";
                        }
                        else
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                        }
                    }

                    if (oT.KN_TRALOIDON != null)
                        chkKN_TBTLD.Checked = oT.KN_TRALOIDON == 1 ? true : false;
                    if (chkKN_TBTLD.Checked)
                    {
                        trThongbaoTLD.Visible = true;

                    }

                    if (ddlCapXetXu.Items.FindByValue(oT.BAQD_CAPXETXU + "") != null)
                        ddlCapXetXu.SelectedValue = oT.BAQD_CAPXETXU + "";
                    else
                        ddlCapXetXu.SelectedValue = "0";

                }
                else
                {
                    string strPhanloai = oT.ARRPHANLOAI + "";
                    foreach (ListItem i in chkPhanloai.Items)
                    {
                        if (("," + strPhanloai + ",").Contains("," + i.Value + ","))
                            i.Selected = true;
                    }
                    txtDoituongbiKN.Text = oT.DOITUONGBIKNTC;
                    rdbLoaiKNTC.SelectedValue = oT.LOAIKNTC + "";
                }
                if (ddlTraloi.Items.FindByValue(oT.TRALOIDON + "") != null)
                    ddlTraloi.SelectedValue = oT.TRALOIDON + "";

                if (oT.TRALOIDON == 1)
                {
                    if (ddlTraloi.SelectedValue == "1")
                        pnCV_traloi.Visible = true;
                    else
                        pnCV_traloi.Visible = false;
                    txtCV_Traloi_Noidung.Text = oT.CV_TRALOI_NOIDUNG;
                }
                else
                {
                    txtCV_Traloi_Noidung.Text = "";
                }
                txtMaDon.Text = oT.MADON;
                txtNguoigui.Text = oT.NGUOIGUI_HOTEN;
                txtSoCMND.Text = oT.NGUOIGUI_CMND;
                if (oT.NGUOIGUI_GIOITINH != null)
                    ddlGioitinh.SelectedValue = oT.NGUOIGUI_GIOITINH.ToString();
                txtNgaynhandon.Text = oT.NGAYNHANDON == null ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy");
                txtNgayghidon.Text = oT.NGAYGHITRENDON == null ? "" : ((DateTime)oT.NGAYGHITRENDON).ToString("dd/MM/yyyy");
                txtSohieudon.Text = oT.SOHIEUDON;

                //if (oT.LOAIDON != null)
                //    ddlHinhthucdon.SelectedValue = oT.LOAIDON.ToString();

                if (oT.DUNGDONLA != null)
                    ddlDungdonla.SelectedValue = oT.DUNGDONLA.ToString();
                if (oT.NGUOIGUI_TUCACHTOTUNG != null)
                    ddlTucachTT.SelectedValue = oT.NGUOIGUI_TUCACHTOTUNG.ToString();

                if (oT.NGUOIGUI_HUYENID != null && oT.NGUOIGUI_HUYENID != 0)
                {
                    try
                    {
                        DM_HANHCHINH oDCHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.NGUOIGUI_HUYENID).FirstOrDefault();
                        hddNGDCID.Value = oDCHuyen.ID.ToString();
                        txtNGHuyen.Text = oDCHuyen.MA_TEN;
                    }
                    catch (Exception ex) { }
                }
                txtDiachi.Text = oT.NGUOIGUI_DIACHI;
                txtNoidung.Text = oT.NOIDUNGDON;
                txtGhichu.Text = oT.GHICHU + "";
                if (oT.ISNOTGDTTT == 1)
                {
                    chkIsNotGDT.Checked = true;
                    chkIsNotGDTChange();

                }
                if (oT.ISGDTTT_KNTC == 1) chkGDTIsKNTC.Checked = true;
                lblTucach.Visible = ddlTucachTT.Visible = true;
                if (ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "31"
                    || ddlHinhthucdon.SelectedValue == "2" || ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9"
                    || ddlHinhthucdon.SelectedValue == "10")
                // Loại đơn + công văn
                {
                    //Load cac loai cong van
                    LoadDropLoaiCongVan();
                    if (ddlLoaiCongVan.Items.FindByValue(oT.LOAICONGVAN + "") != null)
                        ddlLoaiCongVan.SelectedValue = oT.LOAICONGVAN + "";
                    ChangeLoaiCV();

                    decimal IDLoai = Convert.ToDecimal(ddlLoaiCongVan.SelectedValue);
                    DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();

                    if (oLoai.MA == ENUM_GDT_LOAICV.NHACLAI)// công văn nhắc lại
                    {
                        pnCongVanNhacLai.Visible = true;
                        txtCongVan.Text = oT.CV_NHACLAITEXT;
                        hddNhaclaiCVID.Value = oT.CV_NHACLAIID == null ? "0" : oT.CV_NHACLAIID.ToString();
                    }
                    else
                    {
                        pnCongVanNhacLai.Visible = false;
                    }
                    chkIsTrongNganh.Checked = oT.CV_ISTRONGNGANH == 1 ? true : false;
                    if (chkIsTrongNganh.Checked)
                    {
                        pnDonViGuiTrongNganh.Visible = true;
                        pnDonViGuiNgoaiNganh.Visible = false;
                        ddlCV_Donvi.SelectedValue = oT.CV_TOAANID + "";
                        // chkTraigiam.Visible = false;
                    }
                    else
                    {
                        chkTraigiam.Checked = oT.CV_ISTRAIGIAM == 1 ? true : false;
                        pnDonViGuiTrongNganh.Visible = false;
                        pnDonViGuiNgoaiNganh.Visible = true;
                        txtCV_DonViGuiNgoaiNganh.Text = oT.CV_TENDONVI;
                        // chkTraigiam.Visible = true;
                        if (chkTraigiam.Checked) lblTraigiamhientai.Visible = txtTraigiamhientai.Visible = true;

                    }
                    txtTraigiamhientai.Text = oT.CV_TRAIGIAMHIENTAI + "";
                    if (oT.CV_HUYENID != null)
                    {
                        try
                        {
                            DM_HANHCHINH oCVHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.CV_HUYENID).FirstOrDefault();
                            hddCVDCID.Value = oCVHuyen.ID.ToString();
                            txtCVDC.Text = oCVHuyen.MA_TEN;
                        }
                        catch (Exception ex) { }
                    }
                    txtCVDiachi.Text = oT.CV_DIACHI + "";
                    txtCV_So.Text = oT.CV_SO;
                    txtCV_Ngay.Text = oT.CV_NGAY + "" == "" ? "" : ((DateTime)oT.CV_NGAY).ToString("dd/MM/yyyy");
                    txtCV_Nguoiky.Text = oT.CV_NGUOIKY;
                    txtCV_Chucvu.Text = oT.CV_CHUCVU;
                    pnCongvan.Visible = true;


                }
                if (oT.PHANLOAIXULY != null)
                {
                    ddlPhanloai.SelectedValue = oT.PHANLOAIXULY.ToString();
                }
                if (ddlPhanloai.SelectedValue == "04")
                {
                    ddlTrangthaidon.SelectedValue = "1";
                    lblLydoCDDK.Text = "Lý do";
                    chkLydoCDDK.Visible = true;
                }
                ddlHinhthucdonChange();
                if (ddlPhanloai.SelectedValue == "2" || ddlPhanloai.SelectedValue == "3")//Đơn trùng hoặc đơn khiếu nại
                {
                    txtSoLuongDon.Text = oT.SOLUONGDON + "";
                }

                if (isLoadTrung)
                {
                    ddlPhanloai.SelectedValue = "3";
                    hddDontrungID.Value = oT.ID.ToString();
                    //txtTenDonTrung.Text = "Số hiệu: " + oT.SOHIEUDON + ";Người gửi: " + oT.NGUOIGUI_HOTEN + "";
                    lstMsg_dontrung.Text = "Số hiệu: " + oT.SOHIEUDON + "; người gửi: " + oT.NGUOIGUI_HOTEN;
                    txtTenDonTrung.Enabled = false;
                    cmdCheckTrungDon.Visible = false;
                    cmdHuyTrungDon.Visible = true;
                }
                if (oT.CV_YEUCAUTHONGBAO != null) ddlYeucauthongbao.SelectedValue = oT.CV_YEUCAUTHONGBAO.ToString();

                if (oT.CHIDAO_COKHONG != null)
                {
                    if (oT.CHIDAO_COKHONG == 1)
                    {

                        trChidao.Visible = true;
                        if (oT.CHIDAO_LANHDAOID != null)
                            ddlCAChidao.SelectedValue = oT.CHIDAO_LANHDAOID + "";
                        txtCA_Noidung.Text = oT.CHIDAO_NOIDUNG + "";

                    }
                    else
                        ddlCAChidao.SelectedValue = "0";
                }
                divCommandT.Visible = divCommandB.Visible = true;
                List<GDTTT_DON_NGUOIKN> lstKN = dt.GDTTT_DON_NGUOIKN.Where(x => x.DONID == oT.ID).OrderBy(y => y.HOTEN).ToList();
                ddlSonguoiKN.SelectedValue = lstKN.Count.ToString();
                dgNguoiKN.DataSource = lstKN;
                dgNguoiKN.DataBind();
                //////////////////
                // LoadDSKemTheo_to_table();
                getTable_load();
                if (chkKN_TBTLD.Checked)
                {
                    LoadTBTLD(oT.ID);
                }
                if (ddlHinhthucdon.SelectedValue == "4")
                {
                    try
                    {
                        Load_CAChidao_kn();
                        txtSOKN.Text = oT.SO_HSKN;
                        txt_NGAYQDKN.Text = oT.NGAY_HSKN + "" == "" ? "" : ((DateTime)oT.NGAY_HSKN).ToString("dd/MM/yyyy");
                        drop_DONVICHUYEN_HSKN.SelectedValue = Convert.ToString(oT.DONVICHUYEN_HSKN);
                        txtNgaynhandon_kn.Text = oT.NGAYNHANDON + "" == "" ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy").Replace("01/01/0001", "");
                        if (oT.CHIDAO_COKHONG != null)
                        {
                            if (oT.CHIDAO_COKHONG == 1)
                            {
                                trChidao_kn.Style.Remove("Display");
                                if (oT.CHIDAO_LANHDAOID != null)
                                    ddlCAChidao_kn.SelectedValue = oT.CHIDAO_LANHDAOID + "";
                                txtCA_Noidung_kn.Text = oT.CHIDAO_NOIDUNG + "";
                            }
                            else
                            {
                                ddlCAChidao_kn.SelectedValue = "0";
                                trChidao_kn.Style.Add("Display", "none");
                            }
                        }
                        txt_GHICHU_HS.Text = oT.GHICHU;
                    }
                    catch (Exception ex) { String mess = ex.Message; }
                }

                setLoaichuyen();
                //Lưu session
                if (Request["vt_id"] + "" != "")
                {
                    VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
                    DataTable tbl = obj_M.VT_VANBANDEN_LOAD_BYID(Session[ENUM_SESSION.SESSION_DONVIID] + "", Request["vt_id"] + "");
                    ddlChuyendenDV.SelectedValue = tbl.Rows[0]["CD_TA_DONVIID"] + "";
                    LoadLoaiAn();
                    ddlLoaiAn.SelectedValue = "0" + tbl.Rows[0]["LOAI_AN_DON"] + "";
                    if (txtNgaynhandon.Text == "01/01/0001")
                    {
                        txtNgaynhandon.Text = "";
                    }
                    //txtNgaynhandon.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    rdbThuLy.SelectedValue = "1";
                }
                
                rdbThamquyen.SelectedValue = oT.ISTPB3.ToString();

                //nếu đã phân công thẩm phán
                if (oT.THAMPHANID != null && oT.THAMPHANID > 0)
                {
                    //không cho sửa loại thẩm quyền của đơn
                    rdbThamquyen.Enabled = false;
                }
            }
            load_lable_ba_qd();
        }
        protected bool check_not_update_content()
        {
            if (ddlHinhthucdon.SelectedValue == "1")
            {
                if (txtNgaynhandon.Text.Trim() != "" || txtNguoigui.Text != "" || txtNGHuyen.Text != "")
                {
                    return false;//không đổ dữ liệu khi đã có dữ liệu
                }
            }
            if (ddlHinhthucdon.SelectedValue == "3")
            {
                if (txtNgaynhandon.Text.Trim() != "" || txtNguoigui.Text != "" || txtNGHuyen.Text != "")
                {
                    return false;
                }
                if (chkIsTrongNganh.Checked == true)
                {
                    if (ddlCV_Donvi.SelectedValue != "0")
                        return false;
                }
                if (chkIsTrongNganh.Checked == false)
                {
                    if (txtCV_DonViGuiNgoaiNganh.Text.Trim() != "")
                    {
                        return false;
                    }
                }
            }
            if (ddlHinhthucdon.SelectedValue == "6")
            {
                if (txtNgaynhandon.Text.Trim() != "")
                {
                    return false;
                }
                if (chkIsTrongNganh.Checked == true)
                {
                    if (ddlCV_Donvi.SelectedValue != "0")
                        return false;

                }
                if (chkIsTrongNganh.Checked == false)
                {
                    if (txtCV_DonViGuiNgoaiNganh.Text.Trim() != "")
                    {
                        return false;
                    }
                }
            }
            if (ddlHinhthucdon.SelectedValue == "9")
            {
                if (txtNgaynhandon.Text.Trim() != "")
                {
                    return false;
                }
                if (chkIsTrongNganh.Checked == true)
                {
                    if (ddlCV_Donvi.SelectedValue != "0")
                        return false;

                }
                if (chkIsTrongNganh.Checked == false)
                {
                    if (txtCV_DonViGuiNgoaiNganh.Text.Trim() != "")
                    {
                        return false;
                    }
                }
            }
            return true;//sẽ bỏ qua việc check không đổ dữ liệu
        }
        private void LoadInfo_fromDon(decimal ID, bool isLoadTrung)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                if (oT.CD_LOAI != null)
                {
                    rdbLoaichuyen.SelectedValue = oT.CD_LOAI.ToString();
                    setLoaichuyen();
                    switch (rdbLoaichuyen.SelectedValue)
                    {
                        case "0"://Nội bộ tòa án                            
                            if (oT.CD_TA_DONVIID != null)
                                ddlChuyendenDV.SelectedValue = oT.CD_TA_DONVIID.ToString();
                            if (ddlHinhthucdon.SelectedValue == "5")
                            {
                                ddlChuyendenDV_VB.SelectedValue = oT.CD_TA_DONVIID.ToString();
                                txtNgayChuyen_VB.Text = oT.NGAYCHUYEN_VB + "" == "" ? "" : ((DateTime)oT.NGAYCHUYEN_VB).ToString("dd/MM/yyyy");
                            }
                            ChuyendenDVChange(0);
                            LoadLoaiAn();
                            if (pnBAQDGDT.Visible)
                            {
                                if (oT.CD_TA_TRANGTHAI != null)
                                {
                                    ddlTrangthaidon.SelectedValue = oT.CD_TA_TRANGTHAI.ToString();
                                }
                                LoadLoaiAn();
                                try
                                {
                                    if (oT.BAQD_LOAIAN != null)
                                        ddlLoaiAn.SelectedValue = "0" + oT.BAQD_LOAIAN.ToString();
                                    LoadIsTuHinh(ddlLoaiAn.SelectedValue);
                                    if (trTuHinh.Visible)
                                    {
                                        chkIsTuHinh.Checked = oT.ISANTUHINH == 1 ? true : false;
                                        if (chkIsTuHinh.Checked)
                                        {
                                            chkIsAnGiam.Visible = chkKeuOan.Visible = true;
                                            chkIsAnGiam.Checked = oT.ISTH_ANGIAM == 1 ? true : false;
                                            chkKeuOan.Checked = oT.ISTH_KEUOAN == 1 ? true : false;
                                        }
                                    }
                                }
                                catch (Exception ex) { }
                                if (ddlTrangthaidon.SelectedValue == "1")
                                {
                                    lblLydoCDDK.Text = "Lý do";
                                    chkLydoCDDK.Visible = true;
                                    pnThuLy.Visible = false;
                                    rdbThuLy.Visible = false;
                                    //trTuHinh.Visible = false;
                                    chkLydoCDDK.Items[0].Selected = oT.CD_TA_LYDO_ISBAQD == 1 ? true : false;
                                    chkLydoCDDK.Items[1].Selected = oT.CD_TA_LYDO_ISXACNHAN == 1 ? true : false;
                                    chkLydoCDDK.Items[2].Selected = oT.CD_TA_LYDO_ISKHAC == 1 ? true : false;
                                    if (oT.CD_TA_LYDO_ISKHAC == 1)
                                    {
                                        trLydokhac.Visible = true;
                                        txtLydoCDDK_Khac.Text = oT.CD_TA_LYDO_KHAC + "";
                                    }
                                }
                                else
                                {
                                    lblLydoCDDK.Text = "Thụ lý đơn";
                                    chkLydoCDDK.Visible = false;
                                    rdbThuLy.Visible = true;
                                    if (oT.ISTHULY != null) rdbThuLy.SelectedValue = oT.ISTHULY + "";
                                    pnThuLy.Visible = true;
                                    //trTuHinh.Visible = true;
                                    txtSoThuLy.Text = oT.TL_SO + "";
                                    txtNgaythuly.Text = oT.TL_NGAY + "" == "" ? "" : ((DateTime)oT.TL_NGAY).ToString("dd/MM/yyyy");
                                    if (isLoadTrung)
                                    {
                                        rdbThuLy.SelectedValue = "2";
                                        pnThuLy.Visible = false;
                                    }
                                    else
                                    {
                                        if (rdbThuLy.SelectedValue == "2") pnThuLy.Visible = false;
                                    }
                                }
                                //---anhvh add
                                txt_QHPL.Text = oT.QHPL_TEXT;
                                //txt_GHICHU_TTCD.Text = oT.GHICHU_TTCD;
                            }
                            break;
                        case "1":
                            if (oT.CD_TK_DONVIID != null)
                            {
                                ddlToaKhac.SelectedValue = oT.CD_TK_DONVIID + "";

                            }
                            if (oT.CD_TK_NOIGUI != null)
                                rdbDonguitoi.SelectedValue = oT.CD_TK_NOIGUI.ToString();
                            break;
                        case "2":
                            txtNgoaitoaan.Text = oT.CD_NTA_TENDONVI;
                            break;
                        case "3":
                            if (oT.CD_TRALAI_LYDOID != null && oT.CD_TRALAI_LYDOID != 0)
                            {
                                ddlLydotralai.SelectedValue = oT.CD_TRALAI_LYDOID.ToString();
                            }
                            else
                            {
                                ddlLydotralai.SelectedValue = "0";
                                txtTralaikhac.Text = oT.CD_TRALAI_LYDOKHAC;
                                lblLydokhac.Visible = true;
                                txtTralaikhac.Visible = true;
                            }
                            txtTralaiYeucau.Text = oT.CD_TRALAI_YEUCAU;
                            txtTralaiSophieu.Text = oT.CD_TRALAI_SOPHIEU;
                            txtTralaiNgay.Text = oT.CD_TRALAI_NGAYTRA + "" == "" ? "" : ((DateTime)oT.CD_TRALAI_NGAYTRA).ToString("dd/MM/yyyy");
                            break;
                        default:
                            break;
                    }
                }

                if (check_not_update_content() == true)
                {
                    if (ddlTraloi.Items.FindByValue(oT.TRALOIDON + "") != null)
                        ddlTraloi.SelectedValue = oT.TRALOIDON + "";

                    if (oT.TRALOIDON == 1)
                    {
                        if (ddlTraloi.SelectedValue == "1")
                            pnCV_traloi.Visible = true;
                        else
                            pnCV_traloi.Visible = false;
                        txtCV_Traloi_Noidung.Text = oT.CV_TRALOI_NOIDUNG;
                    }
                    else
                    {
                        txtCV_Traloi_Noidung.Text = "";
                    }
                }
                if (Request["vt_id"] + "" == "")
                {
                    if (check_not_update_content() == true)
                    {
                        txtMaDon.Text = oT.MADON;
                        txtNguoigui.Text = oT.NGUOIGUI_HOTEN;
                        txtSoCMND.Text = oT.NGUOIGUI_CMND;
                        txtSoCMND.Text = oT.NGUOIGUI_DIENTHOAI;
                        if (oT.NGUOIGUI_GIOITINH != null)
                            ddlGioitinh.SelectedValue = oT.NGUOIGUI_GIOITINH.ToString();
                        txtNgaynhandon.Text = oT.NGAYNHANDON == null ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy");
                        txtNgayghidon.Text = oT.NGAYGHITRENDON == null ? "" : ((DateTime)oT.NGAYGHITRENDON).ToString("dd/MM/yyyy");
                        txtSohieudon.Text = oT.SOHIEUDON;

                        if (oT.DUNGDONLA != null)
                            ddlDungdonla.SelectedValue = oT.DUNGDONLA.ToString();
                        if (oT.NGUOIGUI_TUCACHTOTUNG != null)
                            ddlTucachTT.SelectedValue = oT.NGUOIGUI_TUCACHTOTUNG.ToString();
                        if (oT.NGUOIGUI_HUYENID != null)
                        {
                            try
                            {
                                DM_HANHCHINH oDCHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.NGUOIGUI_HUYENID).FirstOrDefault();
                                hddNGDCID.Value = oDCHuyen.ID.ToString();
                                txtNGHuyen.Text = oDCHuyen.MA_TEN;
                            }
                            catch (Exception ex) { }
                        }
                        txtDiachi.Text = oT.NGUOIGUI_DIACHI;
                        txtNoidung.Text = oT.NOIDUNGDON;
                        txtGhichu.Text = oT.GHICHU + "";
                    }
                    if (oT.ISNOTGDTTT == 1)
                    {
                        chkIsNotGDT.Checked = true;
                        chkIsNotGDTChange();

                    }
                    if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
                    {
                        pn_LOAI_GDTTT.Visible = false;
                        pnKiemtraTrung.Visible = false;
                        pn_Loai_KNTP.Visible = true;
                        KN_BiCao.Style.Add("Display", "none");
                    }


                    lblTucach.Visible = ddlTucachTT.Visible = true;
                    if (ddlHinhthucdon.SelectedValue == "31" || ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "2"
                    || ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9" || ddlHinhthucdon.SelectedValue == "10")// Loại đơn + công văn
                    {
                        //Load cac loai cong van
                        LoadDropLoaiCongVan();
                        if (ddlLoaiCongVan.Items.FindByValue(oT.LOAICONGVAN + "") != null)
                            ddlLoaiCongVan.SelectedValue = oT.LOAICONGVAN + "";
                        ChangeLoaiCV();

                        decimal IDLoai = Convert.ToDecimal(ddlLoaiCongVan.SelectedValue);
                        DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();

                        if (oLoai.MA == ENUM_GDT_LOAICV.NHACLAI)// công văn nhắc lại
                        {
                            pnCongVanNhacLai.Visible = true;
                            txtCongVan.Text = oT.CV_NHACLAITEXT;
                            hddNhaclaiCVID.Value = oT.CV_NHACLAIID == null ? "0" : oT.CV_NHACLAIID.ToString();
                        }
                        else
                        {
                            pnCongVanNhacLai.Visible = false;
                        }
                        chkIsTrongNganh.Checked = oT.CV_ISTRONGNGANH == 1 ? true : false;
                        if (chkIsTrongNganh.Checked)
                        {
                            pnDonViGuiTrongNganh.Visible = true;
                            pnDonViGuiNgoaiNganh.Visible = false;
                            ddlCV_Donvi.SelectedValue = oT.CV_TOAANID + "";
                            // chkTraigiam.Visible = false;
                        }
                        else
                        {
                            chkTraigiam.Checked = oT.CV_ISTRAIGIAM == 1 ? true : false;
                            pnDonViGuiTrongNganh.Visible = false;
                            pnDonViGuiNgoaiNganh.Visible = true;
                            txtCV_DonViGuiNgoaiNganh.Text = oT.CV_TENDONVI;
                            // chkTraigiam.Visible = true;
                            if (chkTraigiam.Checked) lblTraigiamhientai.Visible = txtTraigiamhientai.Visible = true;

                        }
                        txtTraigiamhientai.Text = oT.CV_TRAIGIAMHIENTAI + "";
                        if (oT.CV_HUYENID != null)
                        {
                            try
                            {
                                DM_HANHCHINH oCVHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.CV_HUYENID).FirstOrDefault();
                                hddCVDCID.Value = oCVHuyen.ID.ToString();
                                txtCVDC.Text = oCVHuyen.MA_TEN;
                            }
                            catch (Exception ex) { }
                        }
                        txtCVDiachi.Text = oT.CV_DIACHI + "";
                        txtCV_So.Text = oT.CV_SO;
                        if (oT.CV_NGAY != null)
                        {
                            if (((DateTime)oT.CV_NGAY).ToString("dd/MM/yyyy") == "01/01/0001")
                            {
                                txtCV_Ngay.Text = "";
                            }
                            else
                            {
                                txtCV_Ngay.Text = ((DateTime)oT.CV_NGAY).ToString("dd/MM/yyyy");
                            }
                        }
                        else
                            txtCV_Ngay.Text = "";
                        txtCV_Nguoiky.Text = oT.CV_NGUOIKY;
                        txtCV_Chucvu.Text = oT.CV_CHUCVU;
                        pnCongvan.Visible = true;
                    }
                    if (oT.PHANLOAIXULY != null)
                    {
                        ddlPhanloai.SelectedValue = oT.PHANLOAIXULY.ToString();
                    }
                    if (ddlPhanloai.SelectedValue == "04")
                    {
                        ddlTrangthaidon.SelectedValue = "1";
                        lblLydoCDDK.Text = "Lý do";
                        chkLydoCDDK.Visible = true;
                    }
                    if (ddlPhanloai.SelectedValue == "2" || ddlPhanloai.SelectedValue == "3")//Đơn trùng hoặc đơn khiếu nại
                    {
                        txtSoLuongDon.Text = oT.SOLUONGDON + "";
                    }

                    if (isLoadTrung)
                    {
                        ddlPhanloai.SelectedValue = "3";
                        hddDontrungID.Value = oT.ID.ToString();
                        // txtTenDonTrung.Text = "Số hiệu: " + oT.SOHIEUDON + ";Người gửi: " + oT.NGUOIGUI_HOTEN + "";
                        lstMsg_dontrung.Text = "Số hiệu: " + oT.SOHIEUDON + "; người gửi: " + oT.NGUOIGUI_HOTEN;
                        txtTenDonTrung.Enabled = false;
                        cmdCheckTrungDon.Visible = false;
                        cmdHuyTrungDon.Visible = true;
                    }
                    if (oT.CV_YEUCAUTHONGBAO != null) ddlYeucauthongbao.SelectedValue = oT.CV_YEUCAUTHONGBAO.ToString();

                    if (oT.CHIDAO_COKHONG != null)
                    {
                        if (oT.CHIDAO_COKHONG == 1)
                        {

                            trChidao.Visible = true;
                            if (oT.CHIDAO_LANHDAOID != null)
                                ddlCAChidao.SelectedValue = oT.CHIDAO_LANHDAOID + "";
                            txtCA_Noidung.Text = oT.CHIDAO_NOIDUNG + "";

                        }
                        else
                            ddlCAChidao.SelectedValue = "0";
                    }
                    divCommandT.Visible = divCommandB.Visible = true;
                    List<GDTTT_DON_NGUOIKN> lstKN = dt.GDTTT_DON_NGUOIKN.Where(x => x.DONID == oT.ID).OrderBy(y => y.HOTEN).ToList();
                    ddlSonguoiKN.SelectedValue = lstKN.Count.ToString();
                    dgNguoiKN.DataSource = lstKN;
                    dgNguoiKN.DataBind();
                    getTable_load();
                    if (chkKN_TBTLD.Checked)
                    {
                        LoadTBTLD(oT.ID);
                    }
                    if (ddlHinhthucdon.SelectedValue == "4")
                    {
                        try
                        {
                            Load_CAChidao_kn();
                            txtSOKN.Text = oT.SO_HSKN;
                            txt_NGAYQDKN.Text = oT.NGAY_HSKN + "" == "" ? "" : ((DateTime)oT.NGAY_HSKN).ToString("dd/MM/yyyy");
                            drop_DONVICHUYEN_HSKN.SelectedValue = Convert.ToString(oT.DONVICHUYEN_HSKN);
                            txtNgaynhandon_kn.Text = oT.NGAYNHANDON + "" == "" ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy").Replace("01/01/0001", "");
                            if (oT.CHIDAO_COKHONG != null)
                            {
                                if (oT.CHIDAO_COKHONG == 1)
                                {
                                    trChidao_kn.Style.Remove("Display");
                                    if (oT.CHIDAO_LANHDAOID != null)
                                        ddlCAChidao_kn.SelectedValue = oT.CHIDAO_LANHDAOID + "";
                                    txtCA_Noidung_kn.Text = oT.CHIDAO_NOIDUNG + "";
                                }
                                else
                                {
                                    ddlCAChidao_kn.SelectedValue = "0";
                                    trChidao_kn.Style.Add("Display", "none");
                                }
                            }
                            txt_GHICHU_HS.Text = oT.GHICHU;
                        }
                        catch (Exception ex) { String mess = ex.Message; }
                    }
                    if (ddlHinhthucdon.SelectedValue == "5")
                    {
                        pnNoibo.Visible = false;
                        txtSohieudon_VB.Text = oT.CV_SO;
                        txtVB_Ngay.Text = oT.CV_NGAY == null ? "" : ((DateTime)oT.CV_NGAY).ToString("dd/MM/yyyy");
                        txtNgaynhandon_VB.Text = oT.NGAYNHANDON == null ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy");
                        if (oT.DUNGDONLA != null)
                            ddlDungdonla_VB.SelectedValue = oT.DUNGDONLA.ToString();
                        txtNguoigui_VB.Text = oT.NGUOIGUI_HOTEN;
                        txtDiachi_VB.Text = oT.NGUOIGUI_DIACHI;
                        txtNoidung_VB.Text = oT.NOIDUNGDON;
                        txtGhichu_VB.Text = oT.GHICHU + "";
                        ddlTraloi_VB.SelectedValue = Convert.ToString(oT.TRALOIDON);
                        if (oT.NGUOIGUI_HUYENID != null)
                        {
                            try
                            {
                                DM_HANHCHINH oCVHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.NGUOIGUI_HUYENID).FirstOrDefault();
                                ddl_DIACHI_GUI_BT_ID.SelectedValue = oCVHuyen.ID.ToString();
                            }
                            catch (Exception ex) { }
                        }
                        if (oT.TRALOIDON == 1)
                        {
                            if (ddlTraloi_VB.SelectedValue == "1")
                                pnCV_traloi_VB.Visible = true;
                            else
                                pnCV_traloi_VB.Visible = false;
                            txtCV_Traloi_Noidung_VB.Text = oT.CV_TRALOI_NOIDUNG;
                        }
                        else
                        {
                            txtCV_Traloi_Noidung_VB.Text = "";
                        }
                        if (oT.CHIDAO_COKHONG != null)
                        {
                            if (oT.CHIDAO_COKHONG == 1)
                            {

                                trChidao_VB.Visible = true;
                                if (oT.CHIDAO_LANHDAOID != null)
                                    ddlCAChidao_VB.SelectedValue = oT.CHIDAO_LANHDAOID + "";
                                txtCA_Noidung_VB.Text = oT.CHIDAO_NOIDUNG + "";
                            }
                            else
                                ddlCAChidao_VB.SelectedValue = "0";
                        }
                    }
                    load_pn_st_pt();
                }
                //06/11/2024
                if (pnBAQDGDT.Visible)
                {
                    rdbBAQD.SelectedValue = oT.BAQD_LOAIQDBA.ToString();
                    if (rdbBAQD.SelectedValue == "0")
                    {
                        if (oT.BAQD_CAPXETXU == 4)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }
                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                            txtSoBA_PT.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_PT.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_PT > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnPT, oT.BAQD_TOAANID_PT);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                            }

                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_ST > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                            }
                        }
                        else if (oT.BAQD_CAPXETXU == 3)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            //if (ddlToaXetXu.Items.FindByValue(oT.BAQD_TOAANID_PT + "") != null)
                            //    ddlToaXetXu.SelectedValue = oT.BAQD_TOAANID_PT + "";
                            if (oT.BAQD_TOAANID_PT > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID_PT);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                            }

                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }


                            if (oT.BAQD_TOAANID_ST > 0)
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                        }
                        else if (oT.BAQD_CAPXETXU == 2)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }


                            if (ddlToaXetXu.Items.FindByValue(oT.BAQD_TOAANID_ST + "") != null)
                                ddlToaXetXu.SelectedValue = oT.BAQD_TOAANID_ST + "";
                        }
                        else
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                        }
                    }
                    //---------------------
                    LoadCapXetXu(Convert.ToDecimal(oT.BAQD_CAPXETXU));
                    ddlCapXetXu.SelectedValue = Convert.ToString(oT.BAQD_CAPXETXU);
                    load_pn_st_pt();
                }
            }

        }
        private void LoadInfo_FromVuan(Decimal V_ID_DON, decimal VUAN_ID, bool isLoadTrung)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            GDTTT_VUAN oV = dt.GDTTT_VUAN.Where(x => x.ID == VUAN_ID).FirstOrDefault();
            if (oV != null)
            {
                ddl_LOAI_GDTTT.SelectedValue = Convert.ToString(oV.LOAI_GDTTTT);
                rdbLoaichuyen.SelectedValue = "0";//nội bộ
                setLoaichuyen();
                switch (rdbLoaichuyen.SelectedValue)
                {
                    case "0"://Nội bộ tòa án                            
                        if (oV.PHONGBANID != null)
                            ddlChuyendenDV.SelectedValue = oV.PHONGBANID.ToString();
                        if (ddlHinhthucdon.SelectedValue == "5")
                        {
                            ddlChuyendenDV_VB.SelectedValue = oV.PHONGBANID.ToString();
                        }
                        ChuyendenDVChange(0);
                        LoadLoaiAn();
                        if (pnBAQDGDT.Visible)
                        {
                            LoadLoaiAn();
                            try
                            {
                                if (oV.LOAIAN != null)
                                    ddlLoaiAn.SelectedValue = "0" + oV.LOAIAN.ToString();
                                LoadIsTuHinh(ddlLoaiAn.SelectedValue);
                            }
                            catch (Exception ex) { }
                            if (ddlTrangthaidon.SelectedValue == "1")
                            {
                                lblLydoCDDK.Text = "Lý do";
                                chkLydoCDDK.Visible = true;
                                pnThuLy.Visible = false;
                                //trTuHinh.Visible = false;
                                rdbThuLy.Visible = false;

                            }
                            else
                            {
                                lblLydoCDDK.Text = "Thụ lý đơn";
                                chkLydoCDDK.Visible = false;
                                rdbThuLy.Visible = true;
                                pnThuLy.Visible = true;
                                //trTuHinh.Visible = true;
                                txtSoThuLy.Text = oV.SOTHULYDON + "";
                                txtNgaythuly.Text = oV.NGAYTHULYDON + "" == "" ? "" : ((DateTime)oV.NGAYTHULYDON).ToString("dd/MM/yyyy");
                                if (isLoadTrung)
                                {
                                    rdbThuLy.SelectedValue = "2";
                                    pnThuLy.Visible = false;
                                }
                                else
                                {
                                    if (rdbThuLy.SelectedValue == "2") pnThuLy.Visible = false;
                                }
                            }
                            //---add
                            txt_QHPL.Text = oV.QHPL_TEXT;
                        }
                        break;
                    default:
                        break;
                }
                if (Request["vt_id"] + "" == "")
                {
                    if (check_not_update_content() == true)
                    {
                        txtCV_Traloi_Noidung.Text = "";
                        txtNguoigui.Text = oV.NGUOIKHIEUNAI;
                        txtNgaynhandon.Text = oV.NGAYNHANDONDENGHI == null ? "" : ((DateTime)oV.NGAYNHANDONDENGHI).ToString("dd/MM/yyyy");
                        txtNgayghidon.Text = oV.NGAYTRONGDON == null ? "" : ((DateTime)oV.NGAYTRONGDON).ToString("dd/MM/yyyy");
                        if (oV.TRUONGHOPTHULY == 0)
                        {
                            ddlHinhthucdon.SelectedValue = "1";
                        }
                        if (oV.TRUONGHOPTHULY == 1)
                        {
                            ddlHinhthucdon.SelectedValue = "4";
                        }
                        txtDiachi.Text = oV.DIACHINGUOIDENGHI;
                        txtGhichu.Text = oV.GHICHU + "";
                    }
                }
                //--------------------
                //06/11/2024
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == V_ID_DON).FirstOrDefault();
                if (pnBAQDGDT.Visible)
                {
                    rdbBAQD.SelectedValue = oT.BAQD_LOAIQDBA.ToString();
                    if (rdbBAQD.SelectedValue == "0")
                    {
                        if (oT.BAQD_CAPXETXU == 4)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }
                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                            txtSoBA_PT.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_PT.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_PT > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnPT, oT.BAQD_TOAANID_PT);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                            }

                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_ST > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                            }
                        }
                        else if (oT.BAQD_CAPXETXU == 3)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            //if (ddlToaXetXu.Items.FindByValue(oT.BAQD_TOAANID_PT + "") != null)
                            //    ddlToaXetXu.SelectedValue = oT.BAQD_TOAANID_PT + "";
                            if (oT.BAQD_TOAANID_PT > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID_PT);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                            }

                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }


                            if (oT.BAQD_TOAANID_ST > 0)
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                        }
                        else if (oT.BAQD_CAPXETXU == 2)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }


                            if (ddlToaXetXu.Items.FindByValue(oT.BAQD_TOAANID_ST + "") != null)
                                ddlToaXetXu.SelectedValue = oT.BAQD_TOAANID_ST + "";
                        }
                        else
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                        }
                    }
                    //---------------------
                    LoadCapXetXu(Convert.ToDecimal(oT.BAQD_CAPXETXU));
                    ddlCapXetXu.SelectedValue = Convert.ToString(oT.BAQD_CAPXETXU);
                    load_pn_st_pt();
                }
            }

        }
        //------------them thong tin BA PT, ST----------------------------
        protected void ddlCapXetXu_SelectedIndexChanged(object sender, EventArgs e)
        {
            //----Chech an thoi hieu------------
            Canhbao_thoihieu();
            //---------------
            load_pn_st_pt();
        }
        protected void load_pn_st_pt()
        {
            if (ddlCapXetXu.SelectedValue == "3")
            {
                pnPhucTham.Visible = false;
                pnAnST.Visible = true;
                LoadDropToaST_TheoPT(Convert.ToDecimal(ddlToaXetXu.SelectedValue));

            }
            else if (ddlCapXetXu.SelectedValue == "2")
            {
                pnPhucTham.Visible = false;
                pnAnST.Visible = false;
            }
            else if (ddlCapXetXu.SelectedValue == "4")
            {
                decimal vToaid = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                DM_TOAAN obj;
                try
                {
                    obj = dt.DM_TOAAN.Where(x => x.ID == vToaid).Single();
                }
                catch (Exception ex)
                {
                    obj = null;
                }



                if (obj != null)
                {
                    if (obj.LOAITOA == "CAPTINH")
                    {
                        pnPhucTham.Visible = false;
                    }
                    else
                    {
                        pnPhucTham.Visible = true;
                    }
                }else{ 
                    pnPhucTham.Visible = true; 
                }    
                    

                pnAnST.Visible = true;
                LoadDropToaPT_TheoGDT(Convert.ToDecimal(ddlToaXetXu.SelectedValue));
                LoadDropToaST_Full_ST();
            }
            else
            {
                pnPhucTham.Visible = false;
                pnAnST.Visible = false;
            }
        }
        protected void dropToaAnPT_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnAnST.Visible = false;
            decimal toa_an_id = Convert.ToDecimal(dropToaAnPT.SelectedValue);
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
                string banan_pt = txtSoBA_PT.Text.Trim();
                if (!string.IsNullOrEmpty(banan_pt)) Cls_Comon.SetFocus(this, this.GetType(), txtSoBA_PT.ClientID);

            }
            else
            {
                pnAnST.Visible = false;
                Cls_Comon.SetFocus(this, this.GetType(), dropToaAnPT.ClientID);
                dropToaAnST.Items.Clear();
            }

        }
        void LoadDropToaPT_TheoGDT(decimal ToaGDT_ID)
        {
            dropToaAnPT.Items.Clear();
            DM_TOAAN_BL bl = new DM_TOAAN_BL();
            //Decimal CapChaID = Convert.ToDecimal(dropToaGDT.SelectedValue);
            DataTable tbl = bl.GetByCapChaID(ToaGDT_ID);
            dropToaAnPT.DataSource = tbl;
            dropToaAnPT.DataTextField = "MA_TEN";
            dropToaAnPT.DataValueField = "ID";
            dropToaAnPT.DataBind();
            dropToaAnPT.Items.Insert(0, new ListItem("Chọn", "0"));
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
        //PN_HOSO_KN------ thêm-----Thông tin Quyết định Kháng nghị-------
        protected void lbtGYChidao_kn_Click(object sender, EventArgs e)
        {
            string strND = "Thực hiện ý kiến chỉ đạo của đồng chí ";
            try
            {
                decimal IDCB = Convert.ToDecimal(ddlCAChidao_kn.SelectedValue);
                DM_CANBO oLD = dt.DM_CANBO.Where(x => x.ID == IDCB).FirstOrDefault();
                if (oLD.CHUCVUID == null || oLD.CHUCVUID == 0)
                {
                    strND += oLD.HOTEN + ", Thẩm phán Tòa án nhân dân cấp cao";
                }
                else
                {
                    DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oLD.CHUCVUID).FirstOrDefault();
                    if (oCV.MA == ENUM_CHUCVU.CHUCVU_PCA)
                    {
                        strND += oLD.HOTEN + ", Phó Chánh án Tòa án nhân dân cấp cao";
                    }
                    else
                        strND += "Chánh án Tòa án nhân dân cấp cao";
                }
            }
            catch (Exception ex) { }
            strND += ", Văn phòng Tòa án nhân dân cấp cao chuyển";
            if (ddlHinhthucdon.SelectedValue == "1")
                strND += " đơn nêu trên";
            else if (ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9")
                strND += " Công văn nêu trên của " + txtCV_DonViGuiNgoaiNganh.Text;
            else if (ddlHinhthucdon.SelectedValue == "3")
                strND += " đơn nêu trên";
            if (rdbLoaichuyen.SelectedValue == "0")
                strND += " đến " + ddlChuyendenDV.SelectedItem.Text;
            else if (rdbLoaichuyen.SelectedValue == "1")
                strND += " đến " + ddlToaKhac.SelectedItem.Text;
            else if (rdbLoaichuyen.SelectedValue == "2")
                strND += " đến " + txtNgoaitoaan.Text;
            txtCA_Noidung_kn.Text = strND;
        }
        private void Load_CAChidao_kn()
        {
            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCAPCA = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU_HCTP(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            //Load cán bộ KN
            ddlCAChidao_kn.DataSource = oCAPCA;
            ddlCAChidao_kn.DataTextField = "MA_TEN";
            ddlCAChidao_kn.DataValueField = "ID";
            ddlCAChidao_kn.DataBind();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            DataTable oTPTATC = oGDTBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            foreach (DataRow r in oTPTATC.Rows)
            {
                bool isTPTATC = true;
                foreach (DataRow rPCA in oCAPCA.Rows)
                {
                    if ((rPCA["ID"] + "") == (r["ID"] + ""))
                    {
                        isTPTATC = false;
                        break;
                    }
                }
                if (isTPTATC)
                {
                    ddlCAChidao_kn.Items.Add(new ListItem(r["HOTEN"] + "-Thẩm phán TANDTC", r["ID"] + ""));
                }
            }
            ddlCAChidao_kn.Items.Insert(0, new ListItem("Không", "0"));
        }
        protected void ddlCAChidao_kn_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_trChidao_kn();
        }
        void Load_trChidao_kn()
        {
            if (ddlCAChidao_kn.SelectedValue == "0")
            {
                trChidao_kn.Style.Add("Display", "none");
            }
            else
            {
                trChidao_kn.Style.Remove("Display");
            }
        }
        private void clear_kn()
        {
            txtSOKN.Text = string.Empty;
            txt_NGAYQDKN.Text = string.Empty;
            drop_DONVICHUYEN_HSKN.SelectedValue = "0";
            txtNgaynhandon_kn.Text = string.Empty;
            ddlCAChidao_kn.SelectedValue = "0";
            txtCA_Noidung_kn.Text = string.Empty;
            txt_GHICHU_HS.Text = string.Empty;
        }
        void LoadDropNGuoiKy_VKS()
        {
            try
            {

                DM_VKS_BL objBL = new DM_VKS_BL();
                DataTable tbl = objBL.GetAll_VKS_CapCao();
                if (tbl != null)
                {
                    if (tbl.Rows.Count > 0)
                    {
                        drop_DONVICHUYEN_HSKN.Items.Clear();
                        drop_DONVICHUYEN_HSKN.DataSource = tbl;
                        drop_DONVICHUYEN_HSKN.DataTextField = "Ten";
                        drop_DONVICHUYEN_HSKN.DataValueField = "ID";
                        drop_DONVICHUYEN_HSKN.DataBind();

                        //        ListItemCollection liCol = drop_DONVICHUYEN_HSKN.Items;
                        //        for (int i = 0; i < tbl.Rows.Count; i++)
                        //        {
                        //            string v_loaivks = tbl.Rows[i]["LOAIVKS"] + "";
                        //            string v_TOAANID = tbl.Rows[i]["TOAANID"] + "";

                        //            if (v_loaivks == "CAPCAO" && v_TOAANID != CurrDonViID.ToString())
                        //            {
                        //                string v_index = tbl.Rows[i]["ID"] + "";
                        //                for (int j = 0; j < liCol.Count; j++)
                        //                {
                        //                    ListItem li = liCol[j];
                        //                    if (li.Value == v_index)
                        //                        drop_DONVICHUYEN_HSKN.Items.Remove(li);
                        //                }
                        //            }
                        //        }
                    }
                }
                drop_DONVICHUYEN_HSKN.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = ex.Message;
            }

        }
        //------------Thông tin Quyết định Kháng nghị end---------
        private void LoadTBTLD(decimal DonID)
        {
            List<GDTTT_DON_TBTLD> lstTBTLD = dt.GDTTT_DON_TBTLD.Where(x => x.DONID == DonID).OrderBy(y => y.NGAY).ToList();
            if (ddlSoTBTLD.Items.FindByValue(lstTBTLD.Count.ToString()) != null)
                ddlSoTBTLD.SelectedValue = lstTBTLD.Count.ToString();
            dgTBTLD.Columns[4].Visible = true;
            dgTBTLD.DataSource = lstTBTLD;
            dgTBTLD.DataBind();
            trThongbaoTLD.Visible = true;
            if (lstTBTLD.Count == 0)
            {
                chkKN_TBTLD.Checked = false;
                trThongbaoTLD.Visible = false;
            }
        }

        private void LoadBoSungTL(decimal DonID)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            dgDS.DataSource = oBL.BOSUNGTAILIEU(DonID);
            dgDS.DataBind();

            if (dgDS.Items.Count > 0)
                pnBoSung.Visible = true;
            else
                pnBoSung.Visible = false;
        }
        private void LoadDSTrung()
        {
            decimal DonID = Convert.ToDecimal(hddID.Value);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable tbl = oBL.DANHSACHDONTRUNG(DonID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int total = tbl.Rows.Count;
                hddTotalPageDT.Value = Cls_Comon.GetTotalPage(total, Convert.ToInt32(dgDSDonTrung.PageSize)).ToString();
                lstSobanghiTDT.Text = lstSobanghiBDT.Text = "Có <b>" + total + " </b> đơn!";
                Cls_Comon.SetPageButton(hddTotalPageDT, hddPageIndexDT, lbTFirstDT, lbBFirstDT, lbTLastDT, lbBLastDT, lbTNextDT, lbBNextDT, lbTBackDT, lbBBackDT, lbTStep1DT, lbBStep1DT, lbTStep2DT,
                             lbBStep2DT, lbTStep3DT, lbBStep3DT, lbTStep4DT, lbBStep4DT, lbTStep5DT, lbBStep5DT, lbTStep6DT, lbBStep6DT);
                #endregion
                dgDSDonTrung.DataSource = tbl;
                dgDSDonTrung.DataBind();
                pnDSTrung.Visible = true;

            }
            else
            {
                pnDSTrung.Visible = false;
            }
        }
        private void LoadDSTLL()
        {
            decimal DonID = Convert.ToDecimal(hddID.Value);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable tbl = oBL.DANHSACHDON_TLL(DonID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int total = tbl.Rows.Count;
                hddTotalPageTLL.Value = Cls_Comon.GetTotalPage(total, Convert.ToInt32(dgDSDonTrung.PageSize)).ToString();
                lstSobanghiTTLL.Text = lstSobanghiBDT.Text = "Có <b>" + total + " </b> đơn!";
                Cls_Comon.SetPageButton(hddTotalPageDT, hddPageIndexDT, lbTFirstDT, lbBFirstDT, lbTLastDT, lbBLastDT, lbTNextDT, lbBNextDT, lbTBackDT, lbBBackDT, lbTStep1DT, lbBStep1DT, lbTStep2DT,
                             lbBStep2DT, lbTStep3DT, lbBStep3DT, lbTStep4DT, lbBStep4DT, lbTStep5DT, lbBStep5DT, lbTStep6DT, lbBStep6DT);
                #endregion
                dgDSDonTLL.DataSource = tbl;
                dgDSDonTLL.DataBind();
                pnDS_Thulylai_theo_don.Visible = true;

            }
            else
            {
                pnDS_Thulylai_theo_don.Visible = false;
            }
        }
        private void LoadDSKemTheo()
        {
            decimal DonID = Convert.ToDecimal(hddID.Value);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable tbl = oBL.DANHSACHDON_KEMTHEO(DonID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int total = tbl.Rows.Count;
                hddTotalPageDT.Value = Cls_Comon.GetTotalPage(total, Convert.ToInt32(dgDSDonTrung.PageSize)).ToString();
                lstSobanghiTDT.Text = lstSobanghiBDT.Text = "Có <b>" + total + " </b> đơn!";
                Cls_Comon.SetPageButton(hddTotalPageDT, hddPageIndexDT, lbTFirstDT, lbBFirstDT, lbTLastDT, lbBLastDT, lbTNextDT, lbBNextDT, lbTBackDT, lbBBackDT, lbTStep1DT, lbBStep1DT, lbTStep2DT,
                             lbBStep2DT, lbTStep3DT, lbBStep3DT, lbTStep4DT, lbBStep4DT, lbTStep5DT, lbBStep5DT, lbTStep6DT, lbBStep6DT);
                #endregion
                dgDSDonKemTheo.DataSource = tbl;
                dgDSDonKemTheo.DataBind();
                pnDS_DonKemTheo.Visible = true;
            }
            else
            {
                pnDS_DonKemTheo.Visible = false;
            }
        }
        private void LoadDSKemTheo_to_table()
        {
            //decimal DonID = Convert.ToDecimal(hddID.Value);
            //GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            //DataTable tbl = oBL.DANHSACHDON_KEMTHEO(DonID);
            //if (tbl != null && tbl.Rows.Count > 0)
            //{
            //    dgList.DataSource = tbl;
            //    dgList.DataBind();
            //    ddlSoLuong.SelectedValue = Convert.ToString(tbl.Rows.Count);
            //}
            //ddlSoLuong.SelectedValue = "1";
            //getTable(1);
        }
        private bool CheckValid()
        {
            //<asp:DropDownList ID="ddlHinhthucdon" Width="250px" CssClass="chosen-select" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlHinhthucdon_SelectedIndexChanged">
            //<asp:ListItem Value="11" Text="1. Đơn"></asp:ListItem>
            //<asp:ListItem Value="1" Text=" -- Đơn đề nghị GĐT,TT" Selected="True"></asp:ListItem>
            //<asp:ListItem Value="8" Text=" -- Đơn khiếu nại tư pháp"></asp:ListItem>
            //<asp:ListItem Value="31" Text="2. Đơn + Công văn"></asp:ListItem>
            //<asp:ListItem Value="3" Text=" -- Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn"></asp:ListItem>
            //<asp:ListItem Value="10" Text=" -- Đơn khiếu nại tư pháp kèm CV chuyển đơn"></asp:ListItem>
            //<asp:ListItem Value="2" Text="3. Công văn"></asp:ListItem>
            //<asp:ListItem Value="6" Text=" -- CV kiến nghị GĐT,TT"></asp:ListItem>
            //<asp:ListItem Value="9" Text=" -- CV kiến nghị GĐT,TT kèm Hồ sơ"></asp:ListItem>
            //<asp:ListItem Value="12" Text=" -- CV khác"></asp:ListItem>
            //<asp:ListItem Value="5" Text="4. Văn bản hành chính,Tài liệu chung"></asp:ListItem>
            //<asp:ListItem Value="4" Text="5. Hồ sơ Kháng nghị GĐT,TT"></asp:ListItem>
            //<asp:ListItem Value="7" Text="6. Thông báo phát hiện vi phạm pháp luật"></asp:ListItem>
            //</asp:DropDownList>
            if (ddlHinhthucdon.SelectedValue == "5")
            {
                if (txtSohieudon_VB.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập số văn bản";
                    return false;
                }
                if (txtVB_Ngay.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày văn bản";
                    return false;
                }
                if (txtNguoigui_VB.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập người gửi";
                    return false;
                }
            }
            else
            {
                lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                if (rdbLoaichuyen.SelectedValue == "1" && ddlToaKhac.SelectedValue == "0")
                {
                    lstMsgT.Text = lstMsgB.Text = "Chưa chọn tòa án để chuyển đơn !";
                    ddlToaKhac.Focus();
                    return false;
                }
                else if (rdbLoaichuyen.SelectedValue == "2" && txtNgoaitoaan.Text == "")
                {
                    lstMsgT.Text = lstMsgB.Text = "Chưa nhập đơn vị ngoài tòa án !";
                    txtNgoaitoaan.Focus();
                    return false;
                }
                if (pnBAQDGDT.Visible)
                {
                    if (rdbBAQD.SelectedValue != "1" && ddlHinhthucdon.SelectedValue != "8" && ddlHinhthucdon.SelectedValue != "10" && ddlHinhthucdon.SelectedValue != "5")
                    {
                        if (txtSoQDBA.Text == "" && spSOBA.Visible && chkIsNotGDT.Checked == false && ddlTrangthaidon.SelectedValue == "0")
                        {
                            lstMsgT.Text = lstMsgB.Text = "Chưa nhập số BA/QD. Hãy nhập lại!";
                            txtSoQDBA.Focus();
                            return false;
                        }
                        if ((txtNgayBA.Text == "" || Cls_Comon.IsValidDate(txtNgayBA.Text) == false) && spNGBA.Visible && chkIsNotGDT.Checked == false && ddlTrangthaidon.SelectedValue == "0")
                        {
                            lstMsgT.Text = lstMsgB.Text = "Ngày bản án chưa nhập hoặc không hợp lệ. Hãy nhập lại!";
                            txtSoQDBA.Focus();
                            return false;
                        }
                    }
                    else
                    {
                        if (txtSoQDKN.Text == "" && spSOKN.Visible && chkIsNotGDT.Checked == false)
                        {
                            lstMsgT.Text = lstMsgB.Text = "Chưa nhập Số QĐ kháng nghị. Hãy nhập lại!";
                            txtSoQDKN.Focus();
                            return false;
                        }
                        if ((txtNgayKhangNghi.Text == "" || Cls_Comon.IsValidDate(txtNgayKhangNghi.Text) == false) && spNGKN.Visible && chkIsNotGDT.Checked == false)
                        {
                            lstMsgT.Text = lstMsgB.Text = "Ngày quyết định chưa nhập hoặc không hợp lệ. Hãy nhập lại!";
                            txtNgayKhangNghi.Focus();
                            return false;
                        }
                    }
                    if (ddlToaXetXu.SelectedValue == "0" && spTOAXX.Visible && chkIsNotGDT.Checked == false && ddlTrangthaidon.SelectedValue == "0")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Chưa chọn tòa án xét xử !";
                        ddlToaXetXu.Focus();
                        return false;
                    }

                    if (pnThuLy.Visible)
                    {
                        //manh bo bát để duy nhập dữ liệu
                        //if (txtSoThuLy.Text == "")
                        //{
                        //    lstMsgT.Text = lstMsgB.Text = "Chưa nhập số thụ lý!";
                        //    txtSoThuLy.Focus();
                        //    return false;
                        //}
                        if (txtNgaythuly.Text == "" || Cls_Comon.IsValidDate(txtNgaythuly.Text) == false)
                        {
                            lstMsgT.Text = lstMsgB.Text = "Ngày thụ lý chưa nhập hoặc không hợp lệ. Hãy nhập lại!";
                            txtNgaythuly.Focus();
                            return false;
                        }
                    }
                }
                else
                {
                    if (txtDoituongbiKN.Text == "")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Chưa nhập đối tượng bị khiếu nại, tố cáo!";
                        txtDoituongbiKN.Focus();
                        return false;
                    }
                }
                //Công văn 
                if (ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "7" || ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
                {
                    int LengthNguoigui = txtNguoigui.Text.Trim().Length;
                    if (LengthNguoigui == 0)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập người gửi. Hãy nhập lại!";
                        txtNguoigui.Focus();
                        return false;
                    }
                    if (LengthNguoigui > 250)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Tên người gửi không quá 250 ký tự. Hãy nhập lại!";
                        txtNguoigui.Focus();
                        return false;
                    }
                    if (txtSoCMND.Text.Trim().Length > 50)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Số CMND không quá 50 ký tự. Hãy nhập lại!";
                        txtSoCMND.Focus();
                        return false;
                    }


                    //validate so dien thoai

                    if (!string.IsNullOrEmpty(txtSoDienThoai.Text.Trim()))
                    {

                        if (txtSoDienThoai.Text.Trim().Length > 15)
                        {
                            lstMsgT.Text = lstMsgB.Text = "Số điện thoại không quá 15 ký tự. Hãy nhập lại!";

                            txtSoDienThoai.Focus();
                            return false;
                        }
                        var motif = @"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$";
                        if (!Regex.IsMatch(txtSoDienThoai.Text.Trim(), motif))
                        {
                            lstMsgT.Text = lstMsgB.Text = "Số điện thoại không đúng định dạng. Hãy nhập lại!";

                            txtSoDienThoai.Focus();
                            return false;
                        }


                    }

                    if (hddNGDCID.Value == "" || hddNGDCID.Value == "0")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Chưa chọn địa chỉ gửi đơn !";
                        txtNGHuyen.Focus();
                        return false;
                    }
                }
                if (ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "2")// Đơn + Công văn
                {

                    if (chkIsTrongNganh.Checked)
                    {
                        if (ddlCV_Donvi.SelectedValue == "0")
                        {
                            lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn đơn vị gửi công văn. Hãy nhập lại!";
                            ddlCV_Donvi.Focus();
                            return false;
                        }
                    }
                    else
                    {
                        if (txtCV_DonViGuiNgoaiNganh.Text == "")
                        {
                            lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập tên đơn vị gửi công văn. Hãy nhập lại!";
                            txtCV_DonViGuiNgoaiNganh.Focus();
                            return false;
                        }
                    }
                }
                if (ddlHinhthucdon.SelectedValue == "1" || ddlHinhthucdon.SelectedValue == "3"
                    || ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "7"
                    || ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "9" || ddlHinhthucdon.SelectedValue == "10")
                {
                    if (txtNgaynhandon.Text.Trim() == "")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày nhận. Hãy nhập lại!";
                        txtNgaynhandon.Focus();
                        return false;
                    }
                    else if (Cls_Comon.IsValidDate(txtNgaynhandon.Text) == false)
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn phải nhập ngày nhận theo định dạng (dd/MM/yyyy). Hãy nhập lại!";
                        txtNgaynhandon.Focus();
                        return false;
                    }
                }
                if (ddlHinhthucdon.SelectedValue == "4")// Hồ sơ Kháng nghị GĐT,TT
                {
                    if (txtSOKN.Text.Trim() == "")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập số QĐKN";
                        txtSOKN.Focus();
                        return false;
                    }
                    if (txt_NGAYQDKN.Text.Trim() == "")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày QĐKN";
                        txt_NGAYQDKN.Focus();
                        return false;
                    }
                    if (drop_DONVICHUYEN_HSKN.SelectedValue == "0")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn Đơn vị chuyển hồ sơ";
                        drop_DONVICHUYEN_HSKN.Focus();
                        return false;
                    }
                    if (txtNgaynhandon_kn.Text.Trim() == "")
                    {
                        lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày nhận";
                        txtNgaynhandon_kn.Focus();
                        return false;
                    }
                }
            }
            //Bỏ bắt buộc chọn thủ tục giải quyết đối với Đơn KNTP và Đơn KNTP kèm CV
            //if (ddlHinhthucdon.SelectedValue != "8" || ddlHinhthucdon.SelectedValue != "10")
            //{
            //    if (ddl_LOAI_GDTTT.SelectedValue == "0")
            //    {
            //        lstMsgT.Text = lstMsgB.Text = "Bạn phải chọn thủ tục giải quyết";
            //        ddl_LOAI_GDTTT.Focus();
            //        return false;
            //    }
            //}

            //hàm kiểm tra nếu hiện tại là thụ lý mới thì không được thêm tiếp đơn trùng lỵ lý mới nữa
            //string strOption = Request["option"] + "";
            //if (hddDontrungID.Value != "0" && hddDontrungID.Value != "" && strOption != "thulylai")
            //{
            //    decimal DonTrungID = Convert.ToDecimal(hddDontrungID.Value);
            //    GDTTT_DON objDT = dt.GDTTT_DON.Where(x => x.ID == DonTrungID).FirstOrDefault();
            //    if (objDT.ISTHULY == 1)
            //    {
            //        if (ddlTrangthaidon.SelectedValue == "1")//Đơn chưa đủ điều kiện
            //        {
            //            lstMsgT.Text = lstMsgB.Text = "Đơn hiện tại là thụ lý mới bạn không thể thêm đơn trùng là chưa đủ điều kiện";
            //            return false;
            //        }
            //        if (ddlTrangthaidon.SelectedValue == "0")//Đơn đủ điều kiện
            //        {
            //            if (rdbThuLy.SelectedValue == "1")//Thụ lý mới
            //            {
            //                lstMsgT.Text = lstMsgB.Text = "Đơn hiện tại là thụ lý mới bạn không thể thêm đơn trùng thụ lý mới, nếu muốn thụ lý mới lần n.. bạn phải chọn ở danh sách ngoài";
            //                return false;
            //            }
            //        }
            //    }
            //}
            if (ddlHinhthucdon.SelectedValue == "31" || ddlHinhthucdon.SelectedValue == "2")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn phải chọn hình thức chi tiết của Hình thức đơn')", true);
                return false;
            }
            //if (ddlHinhthucdon.SelectedValue == "11" || ddlHinhthucdon.SelectedValue == "31" || ddlHinhthucdon.SelectedValue == "2")
            //{
            //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn phải chọn hình thức chi tiết của Hình thức đơn')", true);
            //    return false;
            //}
            if (pnNoibo.Visible == true && ddlHinhthucdon.SelectedValue != "8" && ddlHinhthucdon.SelectedValue != "10")
            {
                if (ddlTrangthaidon.SelectedValue == "0")//Đơn đủ điều kiện
                {
                    if (rdbThuLy.SelectedValue == "")//Thụ lý mới
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn phải chọn thụ lý đơn?')", true);
                        rdbThuLy.Focus();
                        return false;
                    }
                }
            }
            return true;
        }
        private void ResetControls_huydontrung()
        {
            //txtSoQDBA.Text = txtNgayBA.Text = "";
            txtSoQDKN.Text = txtNgayKhangNghi.Text = "";
            // Cls_Comon.SetValueComboBox(ddlCapXetXu, "0");
            pnPhucTham.Visible = pnAnST.Visible = false;
            txtSoBA_PT.Text = txtNgayBA_PT.Text = txtSoBA_ST.Text = txtNgayBA_ST.Text = "";
            Cls_Comon.SetValueComboBox(dropToaAnPT, "0");
            Cls_Comon.SetValueComboBox(dropToaAnST, "0");

            //ddlNguoiKhangNghi.SelectedValue = string.Empty;
            txtDoituongbiKN.Text = "";
            chkKN_TBTLD.Checked = false;
            txtNguoigui.Text = txtSoCMND.Text = "";
            txtSoDienThoai.Text = "";
            hddNGDCID.Value = "0";
            txtNGHuyen.Text = "";
            //ddlToaXetXu.SelectedValue = "0";
            ddlGioitinh.SelectedIndex = 0;
            chkIsTuHinh.Checked = false; chkKeuOan.Visible = chkIsAnGiam.Visible = false;
            txtNgaynhandon.Text = txtNgaynhandon_VB.Text = txtNgayghidon.Text = txtSohieudon.Text = txtSohieudon_VB.Text = "";
            txtVB_Ngay.Text = "";
            //ddlHinhthucdon.SelectedIndex =
            ddlDungdonla.SelectedIndex = ddlDungdonla_VB.SelectedIndex = ddlTucachTT.SelectedIndex = 0;
            hddNGDCID.Value = "0";
            hddCVDCID.Value = "0";
            txtDiachi.Text = txtDiachi_VB.Text = txtNoidung.Text = txtGhichu.Text = "";
            txtSoLuongDon.Text = "1";
            txtCA_Noidung.Text = "";
            txtCA_Noidung_VB.Text = "";
            ddlCAChidao.SelectedIndex = 0;
            trChidao.Visible = false;
            if (ddlHinhthucdon.SelectedValue == "3")// Loại đơn + công văn
            {
                chkIsTrongNganh.Visible = true;

                if (chkIsTrongNganh.Checked)
                {
                    pnDonViGuiTrongNganh.Visible = true;
                    pnDonViGuiNgoaiNganh.Visible = false;
                    ddlCV_Donvi.SelectedValue = "0";
                }
                else
                {
                    pnDonViGuiTrongNganh.Visible = false;
                    pnDonViGuiNgoaiNganh.Visible = true;
                    txtCV_DonViGuiNgoaiNganh.Text = "";
                }
                txtCV_So.Text = txtCV_Ngay.Text = txtCV_Nguoiky.Text = txtCV_Chucvu.Text = "";
                pnCongvan.Visible = true;
                txtTraigiamhientai.Text = "";
            }
            else
                pnCongvan.Visible = false;
            ddlCV_Donvi.SelectedIndex = 0;
            txtCV_DonViGuiNgoaiNganh.Text = "";
            hddCVDCID.Value = "0";
            txtCVDC.Text = "";
            txtCVDiachi.Text = "";
            txtCV_So.Text = "";
            txtCV_Ngay.Text = "";
            txtCV_Nguoiky.Text = txtCV_Chucvu.Text = "";
            ddlTraloi.SelectedIndex = ddlYeucauthongbao.SelectedIndex = 0;
            hddID.Value = "0";
            trDongkhieunai.Visible = true;
            // pnDonTrung.Visible = true;
            ddlSoLuong.SelectedIndex = 0;

            dgListDontrung.DataSource = null;
            dgListDontrung.DataBind();
            // dgList.Visible = false;
            ddlSonguoiKN.SelectedIndex = 0;
            ddlTraloi.SelectedValue = "2";
            txtCV_Traloi_Noidung.Text = "";
            txtCV_Traloi_Noidung_VB.Text = "";
            pnCV_traloi.Visible = false;
            chkGDTIsKNTC.Checked = false;
            Cls_Comon.SetFocus(this, this.GetType(), txtSoQDBA.ClientID);
            dgNguoiKN.DataSource = null;
            dgNguoiKN.DataBind();
            dgNguoiKN.Visible = false;
            if (pnKNTCDoituong.Visible)
            {
                foreach (ListItem i in chkPhanloai.Items)
                {
                    i.Selected = false;
                }
            }
            if (pnBAQDGDT.Visible)
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                decimal sothuly_ = 0;
                oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                txtSoThuLy.Text = Convert.ToString(sothuly_);
                //-------------------
            }
            Load_pnkiem_tratrung();
            txtTenDonTrung.Enabled = true;
            txtTenDonTrung.Text = ""; hddDontrungID.Value = "0";
            trDSTrung.Visible = false;
            dgDSDonTrung.DataSource = null;
            dgDSDonTrung.DataBind();
            pnDSTrung.Visible = false;
            pnDS_DonKemTheo.Visible = false;
            chkKN_TBTLD.Checked = false;
            dgTBTLD.DataSource = null;
            dgTBTLD.DataBind();
            ddlSoTBTLD.SelectedValue = "1";
            chkKN_TBTLD_CheckedChanged(null, null);
            txt_QHPL.Text = string.Empty;
            //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
            rdbThamquyen.SelectedValue = "0";
            lblThamquyen.Text = "Dựa trên thông tin đơn, đây là đơn dành cho thẩm phán tối cao";
            ///------------
            clear_kn();
        }
        private void ResetControls()
        {
            txtSoQDBA.Text = txtNgayBA.Text = "";
            txtSoQDKN.Text = txtNgayKhangNghi.Text = "";

            Cls_Comon.SetValueComboBox(ddlCapXetXu, "0");
            pnPhucTham.Visible = pnAnST.Visible = false;
            txtSoBA_PT.Text = txtNgayBA_PT.Text = txtSoBA_ST.Text = txtNgayBA_ST.Text = "";
            Cls_Comon.SetValueComboBox(dropToaAnPT, "0");
            Cls_Comon.SetValueComboBox(dropToaAnST, "0");

            ddlNguoiKhangNghi.SelectedValue = "0";
            txtDoituongbiKN.Text = "";
            chkKN_TBTLD.Checked = false;
            txtNguoigui.Text = txtSoCMND.Text = "";
            txtSoDienThoai.Text = "";
            hddNGDCID.Value = "0";
            txtNGHuyen.Text = "";
            ddlToaXetXu.SelectedValue = "0";
            ddlGioitinh.SelectedIndex = 0;
            chkIsTuHinh.Checked = false; chkKeuOan.Visible = chkIsAnGiam.Visible = false;
            txtNgaynhandon.Text = txtNgaynhandon_VB.Text = txtNgayghidon.Text = txtSohieudon.Text = txtSohieudon_VB.Text = "";
            txtVB_Ngay.Text = "";
            ddlHinhthucdon.SelectedIndex = ddlDungdonla.SelectedIndex = ddlDungdonla_VB.SelectedIndex = ddlTucachTT.SelectedIndex = 0;
            hddNGDCID.Value = "0";
            hddCVDCID.Value = "0";
            txtDiachi.Text = txtDiachi_VB.Text = txtNoidung.Text = txtGhichu.Text = "";
            txtSoLuongDon.Text = "1";
            txtCA_Noidung.Text = "";
            txtCA_Noidung_VB.Text = "";
            ddlCAChidao.SelectedIndex = 0;
            trChidao.Visible = false;
            if (ddlHinhthucdon.SelectedValue == "3")// Loại đơn + công văn
            {
                chkIsTrongNganh.Visible = true;

                if (chkIsTrongNganh.Checked)
                {
                    pnDonViGuiTrongNganh.Visible = true;
                    pnDonViGuiNgoaiNganh.Visible = false;
                    ddlCV_Donvi.SelectedValue = "0";
                }
                else
                {
                    pnDonViGuiTrongNganh.Visible = false;
                    pnDonViGuiNgoaiNganh.Visible = true;
                    txtCV_DonViGuiNgoaiNganh.Text = "";
                }
                txtCV_So.Text = txtCV_Ngay.Text = txtCV_Nguoiky.Text = txtCV_Chucvu.Text = "";
                pnCongvan.Visible = true;
                txtTraigiamhientai.Text = "";
            }
            else
                pnCongvan.Visible = false;
            ddlCV_Donvi.SelectedIndex = 0;
            txtCV_DonViGuiNgoaiNganh.Text = "";
            hddCVDCID.Value = "0";
            txtCVDC.Text = "";
            txtCVDiachi.Text = "";
            txtCV_So.Text = "";
            txtCV_Ngay.Text = "";
            txtCV_Nguoiky.Text = txtCV_Chucvu.Text = "";
            ddlTraloi.SelectedIndex = ddlYeucauthongbao.SelectedIndex = 0;
            hddID.Value = "0";
            trDongkhieunai.Visible = true;
            // pnDonTrung.Visible = true;
            ddlSoLuong.SelectedIndex = 0;

            dgListDontrung.DataSource = null;
            dgListDontrung.DataBind();
            //dgList.Visible = false;
            ddlSonguoiKN.SelectedIndex = 0;
            ddlTraloi.SelectedValue = "2";
            txtCV_Traloi_Noidung.Text = "";
            txtCV_Traloi_Noidung_VB.Text = "";
            pnCV_traloi.Visible = false;
            chkGDTIsKNTC.Checked = false;
            Cls_Comon.SetFocus(this, this.GetType(), txtSoQDBA.ClientID);
            dgNguoiKN.DataSource = null;
            dgNguoiKN.DataBind();
            dgNguoiKN.Visible = false;
            if (pnKNTCDoituong.Visible)
            {
                foreach (ListItem i in chkPhanloai.Items)
                {
                    i.Selected = false;
                }
            }
            if (pnBAQDGDT.Visible)
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                decimal sothuly_ = 0;
                oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                txtSoThuLy.Text = Convert.ToString(sothuly_);
                //-------------------
            }
            Load_pnkiem_tratrung();
            txtTenDonTrung.Enabled = true;
            txtTenDonTrung.Text = ""; hddDontrungID.Value = "0";
            trDSTrung.Visible = false;
            dgDSDonTrung.DataSource = null;
            dgDSDonTrung.DataBind();
            pnDSTrung.Visible = false;
            pnDS_DonKemTheo.Visible = false;
            chkKN_TBTLD.Checked = false;
            dgTBTLD.DataSource = null;
            dgTBTLD.DataBind();
            ddlSoTBTLD.SelectedValue = "1";
            chkKN_TBTLD_CheckedChanged(null, null);
            txt_QHPL.Text = string.Empty;
            //txt_GHICHU_TTCD.Text = String.Empty;
            ///------------
            clear_kn();
        }
        protected void Load_pnkiem_tratrung()
        {
            if (ddlHinhthucdon.SelectedValue == "1" || ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "11" || ddlHinhthucdon.SelectedValue == "31"
             || ddlHinhthucdon.SelectedValue == "2" || ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9")
            {
                pnKiemtraTrung.Visible = true;
            }
            else
            {
                pnKiemtraTrung.Visible = false;
            }

        }
        private void ResetControls_ThemMoi()
        {
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            //Session["DONID_CC"] = oGDTBL.GDTTT_DON_CC_REIDS();
            //Session["VUVIECID_CC"] = null;
            //---------
            Response.Redirect("Thongtindon.aspx?type=new");
        }
        private void LoadCombobox()
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            lstDonVi = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            for (int i = 1; i < 30; i++)
            {
                ddlSoLuong.Items.Add(new ListItem(i.ToString() + " đơn kèm theo", i.ToString()));
            }
            ddlSoLuong.Items.Insert(0, new ListItem("Không có đơn kèm theo", "0"));
            for (int i = 1; i < 30; i++)
            {
                ddlSonguoiKN.Items.Add(new ListItem(i.ToString() + " người đồng khiếu nại", i.ToString()));
            }
            ddlSonguoiKN.Items.Insert(0, new ListItem("Không có người đồng khiếu nại", "0"));

            for (int i = 1; i < 10; i++)
            {
                ddlSoTBTLD.Items.Add(new ListItem(i.ToString() + " thông báo TLĐ", i.ToString()));
            }

            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);// oTABL.DM_TOAAN_GETBY(1);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            DataTable dtTA2 = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaKhac.DataSource = dtTA2;
            ddlToaKhac.DataTextField = "MA_TEN";
            ddlToaKhac.DataValueField = "ID";
            ddlToaKhac.DataBind();
            ddlToaKhac.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
            ddlCV_Donvi.DataSource = dtTA2;
            ddlCV_Donvi.DataTextField = "MA_TEN";
            ddlCV_Donvi.DataValueField = "ID";
            ddlCV_Donvi.DataBind();
            ddlCV_Donvi.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));


            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCAPCA = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU_HCTP(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlCAChidao.DataSource = oCAPCA;
            ddlCAChidao.DataTextField = "MA_TEN";
            ddlCAChidao.DataValueField = "ID";
            ddlCAChidao.DataBind();
            //------------
            //Load cán bộ
            ddlCAChidao_VB.DataSource = oCAPCA;
            ddlCAChidao_VB.DataTextField = "MA_TEN";
            ddlCAChidao_VB.DataValueField = "ID";
            ddlCAChidao_VB.DataBind();
            //------------
            Load_CAChidao_kn();
            Load_trChidao_kn();
            //---------------
            //Load thêm Thẩm phán
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            DataTable oTPTATC = oGDTBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            foreach (DataRow r in oTPTATC.Rows)
            {
                bool isTPTATC = true;
                foreach (DataRow rPCA in oCAPCA.Rows)
                {
                    if ((rPCA["ID"] + "") == (r["ID"] + ""))
                    {
                        isTPTATC = false;
                        break;
                    }
                }
                if (isTPTATC)
                {
                    ddlCAChidao.Items.Add(new ListItem(r["HOTEN"] + "-Thẩm phán TANDTC", r["ID"] + ""));
                    ddlCAChidao_VB.Items.Add(new ListItem(r["HOTEN"] + "-Thẩm phán TANDTC", r["ID"] + ""));
                }
            }
            ddlCAChidao.Items.Insert(0, new ListItem("Không", "0"));
            ddlCAChidao_VB.Items.Insert(0, new ListItem("Không", "0"));
            //Load loại BA, QD Or QD, CV, TB
            //Load_BAQD();

            LoadDropLoaiCongVan();
            LoadCapXetXu(0);
            load_pn_st_pt();
            LoadPhongban();
            LoadPhongban_VB();
            LoadLoaiAn();
            //Check_Nguoi_KN_LoaiAn();

            //Người kháng nghị
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlNguoiKhangNghi.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.NGUOIKHANGNGHI);
            ddlNguoiKhangNghi.DataTextField = "TEN";
            ddlNguoiKhangNghi.DataValueField = "ID";
            ddlNguoiKhangNghi.DataBind();
            ddlNguoiKhangNghi.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            LoadDropNGuoiKy_VKS();

            //Load Lý do trả lại
            ddlLydotralai.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME("LYDOTRADONGDT");
            ddlLydotralai.DataTextField = "TEN";
            ddlLydotralai.DataValueField = "ID";
            ddlLydotralai.DataBind();
            ddlLydotralai.Items.Add(new ListItem("Lý do khác ", "0"));
            LoadInfoTradon();
            //Load loại KNTC

            chkPhanloai.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.PHANLOAIKNTC);
            chkPhanloai.DataTextField = "TEN";
            chkPhanloai.DataValueField = "ID";
            chkPhanloai.DataBind();
            LoadDiaChiGui();
        }
        private void LoadInfoTradon()
        {
            if (ddlLydotralai.SelectedValue != "0")
            {
                decimal ID = Convert.ToDecimal(ddlLydotralai.SelectedValue);
                DM_DATAITEM oT = dt.DM_DATAITEM.Where(x => x.ID == ID).FirstOrDefault();
                txtTralaiYeucau.Text = oT.MOTA;
                lblLydokhac.Visible = false;
                txtTralaikhac.Visible = false;
            }
            else
            {
                lblLydokhac.Visible = true;
                txtTralaikhac.Visible = true;
            }
        }

        void LoadAllHoiDongTP(decimal vChucdanh, decimal vDonviID)
        {

            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            dropTPTC.DataSource = oBL.CANBO_GETBYDONVI_HDTP(vDonviID, vChucdanh);
            dropTPTC.DataTextField = "MA_TEN";
            dropTPTC.DataValueField = "ID";
            dropTPTC.DataBind();
            dropTPTC.Items.Insert(0, new ListItem("-----Chọn------", "0"));
        }

        private void LoadPhongban()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
            {
                ddlChuyendenDV.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID && (x.ISGIAIQUYETDON == 2 || x.ISGIAIQUYETDON == 1) && x.HIEULUC == 1).OrderBy(x => x.THUTU).ToList();//19/06/2025  (x.ISGIAIQUYETDON == 2) 
            }
            else
            {
                ddlChuyendenDV.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID && x.ISGIAIQUYETDON == 1 && x.HIEULUC == 1).OrderBy(x => x.THUTU).ToList();
            }
            ddlChuyendenDV.DataTextField = "TENPHONGBAN";
            ddlChuyendenDV.DataValueField = "ID";
            ddlChuyendenDV.DataBind();
        }
        private void LoadPhongban_VB()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ddlChuyendenDV_VB.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID && x.ISGIAIQUYETDON == 1 && x.HIEULUC == 1).OrderBy(x => x.THUTU).ToList();
            ddlChuyendenDV_VB.DataTextField = "TENPHONGBAN";
            ddlChuyendenDV_VB.DataValueField = "ID";
            ddlChuyendenDV_VB.DataBind();
        }
        private void LoadCapXetXu(decimal LOAI)
        {
            ddlCapXetXu.Items.Clear();
            if (LOAI == ENUM_GIAIDOANVUAN.SOTHAM)
            {
                ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (LOAI == ENUM_GIAIDOANVUAN.PHUCTHAM)
            {
                ddlCapXetXu.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
                ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.SOTHAM.ToString();
            }
            else
            {
                ddlCapXetXu.Items.Add(new ListItem("--- Chọn ---", "0"));
                ddlCapXetXu.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
                ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                ddlCapXetXu.Items.Add(new ListItem("GĐT,TT", ENUM_GIAIDOANVUAN.THULYGDT.ToString()));
                ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.SOTHAM.ToString();
            }

            //ddlCapXetXu_QDKN.Items.Clear();
            //if (LOAI == ENUM_GIAIDOANVUAN.SOTHAM)
            //{
            //    ddlCapXetXu_QDKN.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            //}
            //else if (LOAI == ENUM_GIAIDOANVUAN.PHUCTHAM)
            //{
            //    ddlCapXetXu_QDKN.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            //    ddlCapXetXu_QDKN.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            //    ddlCapXetXu_QDKN.SelectedValue = ENUM_GIAIDOANVUAN.SOTHAM.ToString();
            //}
            //else
            //{
            //    ddlCapXetXu_QDKN.Items.Add(new ListItem("--- Chọn ---", "0"));
            //    ddlCapXetXu_QDKN.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            //    ddlCapXetXu_QDKN.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            //    ddlCapXetXu_QDKN.Items.Add(new ListItem("GĐT,TT", ENUM_GIAIDOANVUAN.THULYGDT.ToString()));
            //    ddlCapXetXu_QDKN.SelectedValue = ENUM_GIAIDOANVUAN.SOTHAM.ToString();
            //}
        }
        private void LoadDropLoaiCongVan()
        {
            DM_DATAITEM_BL cvBL = new DM_DATAITEM_BL();
            DataTable tbl = cvBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAICVGDTTT);
            if (tbl.Rows.Count > 0)
            {
                ddlLoaiCongVan.DataSource = tbl;
                ddlLoaiCongVan.DataTextField = "MA_TEN";
                ddlLoaiCongVan.DataValueField = "ID";
                ddlLoaiCongVan.DataBind();
            }
            else
            {
                ddlLoaiCongVan.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }
        private bool SaveData()
        {

            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            try
            {
                if (!CheckValid()) return false;
                GDTTT_DON oT;
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    //Kiểm tra số thụ lý
                    if (pnThuLy.Visible && txtSoThuLy.Text != "")
                    {
                        if (oBL.DON_TL_CHECK(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue), txtSoThuLy.Text, 0, Convert.ToDecimal(ddlHinhthucdon.SelectedValue)))
                        {
                            lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                            //decimal strMax = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue));
                            decimal sothuly_ = 0;
                            if (ddlHinhthucdon.SelectedValue == "4")
                                sothuly_ = oBL.TLXXGDT_GETMAXTT(CurrDonViID, DateTime.Now.Year, ddlLoaiAn.SelectedValue);
                            else
                                oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                            decimal strMax = sothuly_;
                            //-------------------
                            lstMsgT.Text = lstMsgB.Text = "Số thụ lý " + txtSoThuLy.Text + " đã sử dụng, số gần nhất là " + (strMax).ToString();
                            txtSoThuLy.Focus();
                            return false;
                        }
                    }
                    oT = new GDTTT_DON();
                    //Them moi thi Ngày xu ly don chinh là ngay hệ thống
                    oT.NGAYXULYDON = DateTime.ParseExact(txtNgayXuLy.Text, "dd/MM/yyyy", null);
                }
                else
                {
                    //Kiểm tra số thụ lý khi update
                    if (pnThuLy.Visible && txtSoThuLy.Text != "")
                    {
                        DateTime NgayTL = DateTime.ParseExact(txtNgaythuly.Text, "dd/MM/yyyy", null);
                        if (oBL.DON_TL_CHECK(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(NgayTL.Year), Convert.ToDecimal(ddlLoaiAn.SelectedValue), txtSoThuLy.Text, Convert.ToDecimal(hddID.Value), Convert.ToDecimal(ddlHinhthucdon.SelectedValue)))
                        {
                            lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                            decimal sothuly_ = 0;
                            if (ddlHinhthucdon.SelectedValue == "4")
                                sothuly_ = oBL.TLXXGDT_GETMAXTT(CurrDonViID, DateTime.Now.Year, ddlLoaiAn.SelectedValue);
                            else
                                oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                            decimal strMax = sothuly_;
                            //decimal strMax = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue));
                            //-------------------
                            lstMsgT.Text = lstMsgB.Text = "Số thụ lý " + txtSoThuLy.Text + " đã sử dụng, số gần nhất là " + (strMax).ToString();
                            txtSoThuLy.Focus();
                            return false;
                        }
                    }
                    //Kiem tra so thu ly khi sưa đơn đã thụ lý thành đơn thụ lý mới 
                    //Xóa đơn gốc khi đơn được sửa là đơn thụ lý mới cần kiểm tra 

                    decimal ID = Convert.ToDecimal(hddID.Value);
                    oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                    //update khi luu kiem tra thoi hieu
                    if (oT.ISTHULY == 1)
                        Canhbao_thoihieu();
                    //Them moi thi Ngày xu ly don chinh là ngay hệ thống
                    oT.NGAYXULYDON = DateTime.ParseExact(txtNgayXuLy.Text, "dd/MM/yyyy", null);
                }
                oT.LOAIDON = Convert.ToDecimal(ddlHinhthucdon.SelectedValue);
                oT.CD_LOAI = Convert.ToDecimal(rdbLoaichuyen.SelectedValue);
                Decimal CurrTrangThai = (String.IsNullOrEmpty(oT.CD_TRANGTHAI + "") ? 0 : (decimal)oT.CD_TRANGTHAI);
                oT.CD_TRANGTHAI = CurrTrangThai; //oT.CD_TRANGTHAI=0;
                oT.LOAI_GDTTTT = Convert.ToDecimal(ddl_LOAI_GDTTT.SelectedValue);//add 26/04/2020
                oT.GHICHU_TTCD = null;
                switch (rdbLoaichuyen.SelectedValue)
                {
                    case "0"://Nội bộ tòa án                       
                        oT.CD_TA_DONVIID = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
                        if (ddlHinhthucdon.SelectedValue == "5")
                        {
                            oT.CD_TA_DONVIID = Convert.ToDecimal(ddlChuyendenDV_VB.SelectedValue);
                            oT.NGAYCHUYEN_VB = txtNgayChuyen_VB.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayChuyen_VB.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        }
                        else if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
                        {
                            //Vơi don khieu nai tu phap và đơn vị nhận là hội đồng thẩm phán thì lưu thêm id lãnh đạo
                            if (ddlChuyendenDV.SelectedValue == "102")
                            {
                                oT.CANBO_ID_GIAIQUYET_KN = Convert.ToDecimal(dropTPTC.SelectedValue);
                            }
                            else
                            {
                                oT.CANBO_ID_GIAIQUYET_KN = 0;
                            }
                        }

                        if (pnBAQDGDT.Visible)
                        {
                            oT.CD_TA_TRANGTHAI = Convert.ToDecimal(ddlTrangthaidon.SelectedValue);//
                            oT.BAQD_LOAIAN = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                            oT.QHPL_TEXT = txt_QHPL.Text;//anhvh add 23/04/2021
                            if (chkLydoCDDK.Visible == true)
                            {
                                oT.CD_TA_LYDO_ISBAQD = chkLydoCDDK.Items[0].Selected ? 1 : 0;
                                oT.CD_TA_LYDO_ISXACNHAN = chkLydoCDDK.Items[1].Selected ? 1 : 0;
                                oT.CD_TA_LYDO_ISKHAC = chkLydoCDDK.Items[2].Selected ? 1 : 0;
                                if (oT.CD_TA_LYDO_ISKHAC == 1)
                                    oT.CD_TA_LYDO_KHAC = txtLydoCDDK_Khac.Text;
                            }
                            else if (chkLydoCDDK.Visible == false)
                            {
                                oT.CD_TA_LYDO_ISBAQD = 0;
                                oT.CD_TA_LYDO_ISXACNHAN = 0;
                                oT.CD_TA_LYDO_ISKHAC = 0;
                                oT.CD_TA_LYDO_KHAC = string.Empty;
                                //--------------
                                oT.ISTHULY = null; oT.TL_SO = null; oT.TL_SOTT = null; oT.TL_NGAY = null;
                            }
                            oT.TL_SO = "";
                            oT.TL_NGAY = (DateTime?)null;
                            if (rdbThuLy.Visible == true)
                            {
                                oT.ISTHULY = Convert.ToDecimal(rdbThuLy.SelectedValue);
                                if (pnThuLy.Visible == true)
                                {
                                    //cần kiểm tra số thụ ly
                                    oT.TL_SO = txtSoThuLy.Text;
                                    oT.TL_SOTT = Cls_Comon.GetNumber(oT.TL_SO);
                                    oT.TL_NGAY = txtNgaythuly.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaythuly.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                                }
                                else if (pnThuLy.Visible == false)
                                {
                                    oT.TL_SO = null; oT.TL_SOTT = null; oT.TL_NGAY = null;
                                }
                            }
                            else if (rdbThuLy.Visible == false)
                            {
                                oT.ISTHULY = null; oT.TL_SO = null; oT.TL_SOTT = null; oT.TL_NGAY = null;
                            }
                            oT.ISANTUHINH = 0;
                            oT.ISTH_ANGIAM = 0;
                            oT.ISTH_KEUOAN = 0;
                            if (trTuHinh.Visible && chkIsTuHinh.Checked)
                            {
                                oT.ISANTUHINH = 1;
                                oT.ISTH_ANGIAM = chkIsAnGiam.Checked ? 1 : 0;
                                oT.ISTH_KEUOAN = chkKeuOan.Checked ? 1 : 0;
                            }
                        }
                        //oT.GHICHU_TTCD = txt_GHICHU_TTCD.Text;
                        break;
                    case "1":
                        oT.CD_TK_DONVIID = Convert.ToDecimal(ddlToaKhac.SelectedValue);
                        oT.CD_TK_NOIGUI = Convert.ToDecimal(rdbDonguitoi.SelectedValue);
                        break;
                    case "2":
                        oT.CD_NTA_TENDONVI = txtNgoaitoaan.Text;
                        //Kiểm tra và lưu lại thông tin danh mục
                        try
                        {
                            string strTenCQ = txtNgoaitoaan.Text.Trim().ToLower();
                            List<DM_COQUANNGOAI> lstCQN = dt.DM_COQUANNGOAI.Where(x => x.TENCOQUAN.ToLower().Contains(strTenCQ)).ToList();
                            if (lstCQN.Count == 0)
                            {
                                DM_COQUANNGOAI oCQN = new DM_COQUANNGOAI();
                                oCQN.TENCOQUAN = txtNgoaitoaan.Text.Trim();
                                dt.DM_COQUANNGOAI.Add(oCQN);
                                dt.SaveChanges();
                            }
                            else
                            {
                                DM_COQUANNGOAI objCQN = lstCQN[0];
                                objCQN.TENCOQUAN = txtNgoaitoaan.Text.Trim();
                                dt.SaveChanges();
                            }
                        }
                        catch (Exception ex) { }
                        break;
                    case "3":
                        oT.CD_TRALAI_LYDOID = Convert.ToDecimal(ddlLydotralai.SelectedValue);
                        if (ddlLydotralai.SelectedValue == "0")
                            oT.CD_TRALAI_LYDOKHAC = txtTralaikhac.Text;
                        else
                            oT.CD_TRALAI_LYDOKHAC = ddlLydotralai.SelectedItem.Text;
                        oT.CD_TRALAI_YEUCAU = txtTralaiYeucau.Text;
                        oT.CD_TRALAI_SOPHIEU = txtTralaiSophieu.Text;
                        oT.CD_TRALAI_NGAYTRA = txtTralaiNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtTralaiNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        break;
                    default:
                        break;
                }

                if (pnBAQDGDT.Visible)//Đơn GĐT,TT
                {
                    oT.LOAIKNTC = 0;
                    oT.KN_TRALOIDON = chkKN_TBTLD.Checked ? 1 : 0;
                    if (rdbBAQD.SelectedValue == "0")
                    {
                        oT.BAQD_LOAIQDBA = 0;
                        if (ddlCapXetXu.SelectedValue == "4")
                        {    //Thong tin BA bị đề nghị GĐT,TT
                            oT.BAQD_SO = txtSoQDBA.Text.Trim();
                            oT.BAQD_NGAYBA = txtNgayBA.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            oT.BAQD_TOAANID = Convert.ToDecimal(ddlToaXetXu.SelectedValue);

                            //Thong tin BA Phúc thẩm
                            oT.BAQD_SO_PT = txtSoBA_PT.Text + "";
                            oT.BAQD_NGAYBA_PT = txtNgayBA_PT.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_PT.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            if (dropToaAnPT.SelectedValue != "0" && !String.IsNullOrEmpty(dropToaAnPT.SelectedValue + ""))
                                oT.BAQD_TOAANID_PT = Convert.ToDecimal(dropToaAnPT.SelectedValue);
                            //Thong tin BA ST
                            oT.BAQD_SO_ST = txtSoBA_ST.Text + "";
                            oT.BAQD_NGAYBA_ST = txtNgayBA_ST.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_ST.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            if (dropToaAnST.SelectedValue != "0" && !String.IsNullOrEmpty(dropToaAnST.SelectedValue + ""))
                                oT.BAQD_TOAANID_ST = Convert.ToDecimal(dropToaAnST.SelectedValue);
                        }
                        else if (ddlCapXetXu.SelectedValue == "3")
                        {
                            //Thong tin BA bị đề nghị Phuc Tham
                            oT.BAQD_SO_PT = txtSoQDBA.Text.Trim();
                            oT.BAQD_NGAYBA_PT = txtNgayBA.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            oT.BAQD_TOAANID_PT = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                            //Thong tin BA ST
                            oT.BAQD_SO_ST = txtSoBA_ST.Text + "";
                            oT.BAQD_NGAYBA_ST = txtNgayBA_ST.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_ST.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            if (dropToaAnST.SelectedValue != "0" && !String.IsNullOrEmpty(dropToaAnST.SelectedValue + ""))
                                oT.BAQD_TOAANID_ST = Convert.ToDecimal(dropToaAnST.SelectedValue);
                        }
                        else if (ddlCapXetXu.SelectedValue == "2")
                        {
                            oT.BAQD_SO_ST = txtSoQDBA.Text.Trim();
                            oT.BAQD_NGAYBA_ST = txtNgayBA.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            oT.BAQD_TOAANID_ST = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                        }
                        //Thong tin bản án khác
                    }
                    else//Kháng nghị
                    {
                        oT.BAQD_LOAIQDBA = 1;
                        oT.KN_SOQD = txtSoQDKN.Text;
                        oT.KN_NGAY = txtNgayKhangNghi.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayKhangNghi.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        oT.NGUOIKHANGNGHI = Convert.ToDecimal(ddlNguoiKhangNghi.SelectedValue);

                        if (ddlCapXetXu.SelectedValue == "4")
                        {    //Thong tin BA bị đề nghị GĐT,TT
                            oT.BAQD_SO = txtSoQDBA.Text.Trim();
                            oT.BAQD_NGAYBA = txtNgayBA.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            oT.BAQD_TOAANID = Convert.ToDecimal(ddlToaXetXu.SelectedValue);

                            //Thong tin BA Phúc thẩm
                            oT.BAQD_SO_PT = txtSoBA_PT.Text + "";
                            oT.BAQD_NGAYBA_PT = txtNgayBA_PT.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_PT.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            if (dropToaAnPT.SelectedValue != "0" && !String.IsNullOrEmpty(dropToaAnPT.SelectedValue + ""))
                                oT.BAQD_TOAANID_PT = Convert.ToDecimal(dropToaAnPT.SelectedValue);
                            //Thong tin BA ST
                            oT.BAQD_SO_ST = txtSoBA_ST.Text + "";
                            oT.BAQD_NGAYBA_ST = txtNgayBA_ST.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_ST.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            if (dropToaAnST.SelectedValue != "0" && !String.IsNullOrEmpty(dropToaAnST.SelectedValue + ""))
                                oT.BAQD_TOAANID_ST = Convert.ToDecimal(dropToaAnST.SelectedValue);
                        }
                        else if (ddlCapXetXu.SelectedValue == "3")
                        {   //Thong tin BA bị đề nghị Phuc Tham
                            oT.BAQD_SO_PT = txtSoQDBA.Text.Trim();
                            oT.BAQD_NGAYBA_PT = txtNgayBA.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            oT.BAQD_TOAANID_PT = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                            //Thong tin BA ST
                            oT.BAQD_SO_ST = txtSoBA_ST.Text + "";
                            oT.BAQD_NGAYBA_ST = txtNgayBA_ST.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_ST.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            if (dropToaAnST.SelectedValue != "0" && !String.IsNullOrEmpty(dropToaAnST.SelectedValue + ""))
                                oT.BAQD_TOAANID_ST = Convert.ToDecimal(dropToaAnST.SelectedValue);
                        }
                        else if (ddlCapXetXu.SelectedValue == "2")
                        {
                            oT.BAQD_SO_ST = txtSoQDBA.Text.Trim();
                            oT.BAQD_NGAYBA_ST = txtNgayBA.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                            oT.BAQD_TOAANID_ST = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                        }

                    }
                    oT.BAQD_CAPXETXU = Convert.ToDecimal(ddlCapXetXu.SelectedValue);
                }


                //Don KNTC
                if (pnKNTCDoituong.Visible)
                {
                    if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
                    {
                        oT.ISGDTTT_KNTC = 1;
                        oT.LOAIKNTC = Convert.ToDecimal(rdbLoaiKNTC_cc.SelectedValue);
                        oT.DOITUONGBIKNTC = txtDoituongbiKN.Text;
                        //Phân loại KNTC
                        string strPhanloai = "";
                        foreach (ListItem i in chkPhanloai.Items)
                        {
                            if (i.Selected)
                            {
                                if (strPhanloai == "")
                                    strPhanloai = i.Value;
                                else
                                    strPhanloai = strPhanloai + "," + i.Value;
                            }
                        }
                        oT.ARRPHANLOAI = strPhanloai;
                    }
                }

                if (PN_DON_CV.Visible == true)
                {
                    oT.NGAYNHANDON = (String.IsNullOrEmpty(txtNgaynhandon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaynhandon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.SOHIEUDON = txtSohieudon.Text;
                    oT.PHANLOAIXULY = Convert.ToDecimal(ddlPhanloai.SelectedValue);
                    oT.NOIDUNGDON = txtNoidung.Text;
                    oT.NOIDUNGTOMTAT = Cls_Comon.CatXau(oT.NOIDUNGDON, 245);
                    if (oT.NOIDUNGDON.Length <= 245)
                        oT.ISSHOWFULL = 0;
                    else
                        oT.ISSHOWFULL = 1;
                    oT.GHICHU = txtGhichu.Text;
                    oT.ISGDTTT_KNTC = chkGDTIsKNTC.Checked ? 1 : 0;
                    oT.ISNOTGDTTT = chkIsNotGDT.Checked ? 1 : 0;
                }
                if (pnTTDon.Visible == true)
                {
                    if (ddlCAChidao.SelectedValue == "0")
                        oT.CHIDAO_COKHONG = 0;
                    else
                    {
                        oT.CHIDAO_COKHONG = 1;
                        oT.CHIDAO_NOIDUNG = txtCA_Noidung.Text;

                        oT.CHIDAO_LANHDAOID = Convert.ToDecimal(ddlCAChidao.SelectedValue);
                    }
                    oT.TRALOIDON = Convert.ToDecimal(ddlTraloi.SelectedValue);
                    if (oT.TRALOIDON == 1)
                    {
                        oT.CV_TRALOI_NOIDUNG = txtCV_Traloi_Noidung.Text;
                    }
                }

                //Thông tin của Đơn hoặc Đơn + Công văn
                if (ddlHinhthucdon.SelectedValue == "11" || ddlHinhthucdon.SelectedValue == "31" || ddlHinhthucdon.SelectedValue == "1" || ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "6"
                    || ddlHinhthucdon.SelectedValue == "7" || ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10"
                    || ddlHinhthucdon.SelectedValue == "9" || ddlHinhthucdon.SelectedValue == "12"
                    )
                {
                    //if(ddlDungdonla.SelectedValue=="3")
                    oT.NGUOIGUI_HOTEN = txtNguoigui.Text;
                    // else
                    // oT.NGUOIGUI_HOTEN = Cls_Comon.FormatTenRieng(txtNguoigui.Text);
                    oT.NGUOIGUI_CMND = txtSoCMND.Text;
                    oT.NGUOIGUI_DIENTHOAI = txtSoDienThoai.Text;


                    oT.NGUOIGUI_GIOITINH = Convert.ToDecimal(ddlGioitinh.SelectedValue);
                    oT.NGAYGHITRENDON = (String.IsNullOrEmpty(txtNgayghidon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayghidon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.DUNGDONLA = Convert.ToDecimal(ddlDungdonla.SelectedValue);
                    oT.NGUOIGUI_TUCACHTOTUNG = Convert.ToDecimal(ddlTucachTT.SelectedValue);
                    if (hddNGDCID.Value != "0")
                    {
                        try
                        {
                            oT.NGUOIGUI_HUYENID = Convert.ToDecimal(hddNGDCID.Value);
                            DM_HANHCHINH oDCHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.NGUOIGUI_HUYENID).FirstOrDefault();
                            oT.NGUOIGUI_TINHID = oDCHuyen.CAPCHAID;
                        }
                        catch (Exception ex) { }
                    }
                    oT.NGUOIGUI_DIACHI = txtDiachi.Text;
                }
                //Đơn + Công văn hoặc Công văn
                if (ddlHinhthucdon.SelectedValue == "2" || ddlHinhthucdon.SelectedValue == "31"
                    || ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "6"
                    || ddlHinhthucdon.SelectedValue == "9" || ddlHinhthucdon.SelectedValue == "10")
                {
                    oT.CV_ISTRONGNGANH = chkIsTrongNganh.Checked ? 1 : 0;
                    oT.LOAICONGVAN = Convert.ToDecimal(ddlLoaiCongVan.SelectedValue);

                    if (chkIsTrongNganh.Checked)
                    {
                        oT.CV_TENDONVI = ddlCV_Donvi.SelectedItem.Text;
                        oT.CV_TOAANID = Convert.ToDecimal(ddlCV_Donvi.SelectedValue);
                    }
                    else
                    {
                        oT.CV_TENDONVI = txtCV_DonViGuiNgoaiNganh.Text;
                        oT.CV_ISTRAIGIAM = chkTraigiam.Checked ? 1 : 0;
                        //Kiểm tra và lưu lại thông tin danh mục
                        try
                        {
                            string strTenCQ = txtCV_DonViGuiNgoaiNganh.Text.Trim().ToLower();
                            List<DM_COQUANNGOAI> lstCQN = dt.DM_COQUANNGOAI.Where(x => x.TENCOQUAN.ToLower().Contains(strTenCQ)).ToList();
                            if (lstCQN.Count == 0)
                            {
                                DM_COQUANNGOAI oCQN = new DM_COQUANNGOAI();
                                oCQN.TENCOQUAN = txtCV_DonViGuiNgoaiNganh.Text.Trim();
                                dt.DM_COQUANNGOAI.Add(oCQN);
                                dt.SaveChanges();
                            }
                            else
                            {
                                DM_COQUANNGOAI objCQN = lstCQN[0];
                                objCQN.TENCOQUAN = txtCV_DonViGuiNgoaiNganh.Text.Trim();
                                dt.SaveChanges();
                            }
                        }
                        catch (Exception ex) { }
                        oT.CV_TRAIGIAMHIENTAI = txtTraigiamhientai.Text;
                        //if (chkTraigiam.Checked) 
                        //else oT.CV_TRAIGIAMHIENTAI = "";
                    }

                    if (hddCVDCID.Value != "0")
                    {
                        try
                        {
                            oT.CV_HUYENID = Convert.ToDecimal(hddCVDCID.Value);
                            DM_HANHCHINH oDCHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.CV_HUYENID).FirstOrDefault();
                            oT.CV_TINHID = oDCHuyen.CAPCHAID;
                        }
                        catch (Exception ex) { }
                    }
                    oT.CV_DIACHI = txtCVDiachi.Text;
                    oT.CV_SO = txtCV_So.Text;
                    oT.CV_NGAY = (String.IsNullOrEmpty(txtCV_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtCV_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.CV_NGUOIKY = txtCV_Nguoiky.Text;
                    oT.CV_CHUCVU = txtCV_Chucvu.Text;

                    if (pnCongVanNhacLai.Visible)//Tham chiếu đến nhắc lại công văn
                    {
                        oT.CV_NHACLAIID = Convert.ToDecimal(hddNhaclaiCVID.Value);
                        oT.CV_NHACLAITEXT = txtCongVan.Text;
                    }

                    oT.CV_YEUCAUTHONGBAO = Convert.ToDecimal(ddlYeucauthongbao.SelectedValue);
                }
                if (ddlHinhthucdon.SelectedValue == "5")
                {
                    oT.CV_SO = txtSohieudon_VB.Text;
                    oT.CV_NGAY = (String.IsNullOrEmpty(txtVB_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtVB_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.NGAYGHITRENDON = (String.IsNullOrEmpty(txtVB_Ngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtVB_Ngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.NGAYNHANDON = (String.IsNullOrEmpty(txtNgaynhandon_VB.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaynhandon_VB.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.DUNGDONLA = Convert.ToDecimal(ddlDungdonla_VB.SelectedValue);
                    oT.NGUOIGUI_HOTEN = txtNguoigui_VB.Text;
                    if (ddl_DIACHI_GUI_BT_ID.SelectedValue != "0")
                    {
                        try
                        {
                            oT.NGUOIGUI_HUYENID = Convert.ToDecimal(ddl_DIACHI_GUI_BT_ID.SelectedValue);
                            DM_HANHCHINH oDCHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.NGUOIGUI_HUYENID).FirstOrDefault();
                            oT.NGUOIGUI_TINHID = oDCHuyen.CAPCHAID;
                        }
                        catch (Exception ex) { }
                    }
                    oT.NGUOIGUI_DIACHI = txtDiachi_VB.Text;
                    oT.NOIDUNGDON = txtNoidung_VB.Text;
                    oT.NOIDUNGTOMTAT = Cls_Comon.CatXau(oT.NOIDUNGDON, 245);
                    if (oT.NOIDUNGDON.Length <= 245)
                        oT.ISSHOWFULL = 0;
                    else
                        oT.ISSHOWFULL = 1;
                    oT.GHICHU = txtGhichu_VB.Text;
                    if (ddlCAChidao_VB.SelectedValue == "0")
                        oT.CHIDAO_COKHONG = 0;
                    else
                    {
                        oT.CHIDAO_COKHONG = 1;
                        oT.CHIDAO_NOIDUNG = txtCA_Noidung_VB.Text;

                        oT.CHIDAO_LANHDAOID = Convert.ToDecimal(ddlCAChidao_VB.SelectedValue);
                    }
                    oT.TRALOIDON = Convert.ToDecimal(ddlTraloi_VB.SelectedValue);
                    if (oT.TRALOIDON == 1)
                    {
                        oT.CV_TRALOI_NOIDUNG = txtCV_Traloi_Noidung_VB.Text;
                    }
                }
                if (ddlHinhthucdon.SelectedValue == "4")
                {
                    oT.NGAYNHANDON = (String.IsNullOrEmpty(txtNgaynhandon_kn.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaynhandon_kn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.SO_HSKN = txtSOKN.Text.Trim();
                    oT.NGAY_HSKN = (String.IsNullOrEmpty(txt_NGAYQDKN.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txt_NGAYQDKN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    oT.DONVICHUYEN_HSKN = Convert.ToDecimal(drop_DONVICHUYEN_HSKN.SelectedValue);
                    oT.CHIDAO_LANHDAOID = Convert.ToDecimal(ddlCAChidao_kn.SelectedValue);
                    oT.CHIDAO_NOIDUNG = txtCA_Noidung_kn.Text.Trim();
                    oT.GHICHU = txt_GHICHU_HS.Text.Trim();
                    if (ddlCAChidao_kn.SelectedValue == "0")
                        oT.CHIDAO_COKHONG = 0;
                    else
                    {
                        oT.CHIDAO_COKHONG = 1;
                        oT.CHIDAO_NOIDUNG = txtCA_Noidung_kn.Text;
                        oT.CHIDAO_LANHDAOID = Convert.ToDecimal(ddlCAChidao_kn.SelectedValue);
                    }
                }

                if (ddlHinhthucdon.SelectedValue == "2")//Công văn
                {
                    oT.NGUOIGUI_HOTEN = oT.CV_TENDONVI;
                    oT.NGAYGHITRENDON = oT.CV_NGAY;
                    oT.NGUOIGUI_HUYENID = oT.CV_HUYENID;
                    oT.NGUOIGUI_DIACHI = oT.CV_DIACHI;
                }
                bool isNew = false;
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    isNew = true;
                    GDTTT_DON_BL dsBL = new GDTTT_DON_BL();
                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.CD_TRANGTHAI = 0;
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.MADON = ENUM_LOAIVUVIEC.AN_GDTTT + Session[ENUM_SESSION.SESSION_MADONVI] + oT.TT.ToString();
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    oT.TRANGTHAIDON = 0;
                    oT.SOLUONGDON = 1;
                    dt.GDTTT_DON.Add(oT);
                    //bool saveFailed;
                    //do
                    //{
                    //    saveFailed = false;
                    try
                    {
                        dt.SaveChanges();
                        //29/07/2024
                        if (hddDontrungID.Value != "" && hddDontrungID.Value != "0")
                        {
                            oBL.INS_UP_TRUNG_CC(hddDontrungID.Value, Convert.ToString(oT.ID), ddlLoaiAn.SelectedValue);
                        }
                        else
                        {
                            if (hddDontrungID_Huy.Value != "0")//khi nhấn vào nút hủy trùng
                            {
                                oBL.INS_UP_TRUNG_CC(hddDontrungID_Huy.Value, Convert.ToString(oT.ID), ddlLoaiAn.SelectedValue);
                                oT.THAMPHANID = 0;
                            }
                        }
                        //UPDATE_NDBD_NKN(oT);//add them nguoi khieu nai, bi cao
                        var idF = Request["cc_id"];
                        if (idF != "" && idF != "0" && idF != null)
                        {
                            decimal ID = Convert.ToDecimal(idF);
                            GDTTT_DON oTTT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();

                            var GDTTT_CC_TC_MAPPING = new GDTTT_CC_TC_MAPPING();
                            GDTTT_CC_TC_MAPPING.DONID = oTTT.ID;
                            GDTTT_CC_TC_MAPPING.NGAYCHUYEN = DateTime.Now;
                            GDTTT_CC_TC_MAPPING.NGUOICHUYEN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            GDTTT_CC_TC_MAPPING.TOAANCAPCAO = oTTT.TOAANID;
                            GDTTT_CC_TC_MAPPING.TRANGTHAI = "";
                            GDTTT_CC_TC_MAPPING.VUVIECID = oTTT.VUVIECID;
                            GDTTT_CC_TC_MAPPING.VUVIECLOAI = oTTT.LOAIDON + "";
                            DataExtensions.Insert(GDTTT_CC_TC_MAPPING);
                        }
                    }
                    catch (DbUpdateConcurrencyException ex)
                    {
                        //var value = ex.Entries.Single();
                        //value.OriginalValues.SetValues(value.GetDatabaseValues());
                        //dt.SaveChanges();
                        // saveFailed = true;
                        // Update the values of the entity that failed to save from the store 
                        ex.Entries.Single().Reload();
                        //dt.Entry<GDTTT_DON>(oT).Reload();
                        lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                        lstMsgT.Text = lstMsgB.Text = "Lỗi khi lưu, bạn hãy thử lại: " + ex.Message;
                        return false;
                    }
                    //} while (saveFailed);
                    if (hddDontrungID.Value == "0" || hddDontrungID.Value == "")
                    {
                        oT.CONLAI_SOLUONG = 1;
                        oT.CONLAI_ARRDONID = oT.ID.ToString();
                        dt.SaveChanges();
                    }
                    else
                    {
                        hddID.Value = oT.ID.ToString();
                        //Update Lại đơn trùng                         
                        decimal DonTrungID = Convert.ToDecimal(hddDontrungID.Value);
                        GDTTT_DON objDT = dt.GDTTT_DON.Where(x => x.ID == DonTrungID).FirstOrDefault();
                        //Trường hợp đơn trùng không phải đơn gốc
                        List<GDTTT_DON> lstTrung = null;
                        if (objDT.DONTRUNGID > 0)
                        {
                            lstTrung = dt.GDTTT_DON.Where(x => x.DONTRUNGID == objDT.DONTRUNGID || x.ID == objDT.DONTRUNGID).ToList();

                        }
                        else
                        {
                            objDT.SOLUONGDON = 1;
                            objDT.DONTRUNGID = oT.ID;
                            dt.SaveChanges();
                            lstTrung = dt.GDTTT_DON.Where(x => x.DONTRUNGID == objDT.ID).ToList();
                            //-------------------------------------
                        }
                        if (lstTrung.Count > 0)
                        {
                            foreach (GDTTT_DON d in lstTrung)
                            {
                                d.DONTRUNGID = oT.ID;
                                d.SOLUONGDON = 1;
                                dt.SaveChanges();
                            }
                            dt.SaveChanges();
                        }
                        oBL.UPDATESOLUONGDON(oT.ID);
                        //-------add 25/03/2024
                        //xử lý lại việc tách và gộp đơn trùng, 
                        //và thêm trường ARR_DON_ID để nhóm tập đơn theo luồng mới Thẩm phán
                        oBL.ARR_DONTRUNGID_UP(hddDontrungID.Value, hddID.Value, ddlTrangthaidon.SelectedValue, rdbThuLy.SelectedValue, rdbLoaichuyen.SelectedValue);
                        //26/08/2024
                        Set_ThamPhan_ThuLylai(oT.ID, true);
                    }
                    hddID.Value = oT.ID.ToString();
                    Session["DONID_CC"] = oT.ID.ToString();
                }
                else
                {
                    //--luồng đơn đã tồn tại và trùng với 1 đơn khác
                    if (hddDontrungID_Chon.Value != "0")
                    {
                        oBL.ARR_DONTRUNGID_UP(hddDontrungID.Value, hddID.Value, ddlTrangthaidon.SelectedValue, rdbThuLy.SelectedValue, rdbLoaichuyen.SelectedValue);
                        Set_ThamPhan_ThuLylai(Convert.ToDecimal(hddID.Value), true);//08/10/2024
                        Session["DONID_CC"] = hddID.Value;
                    }
                    else
                    {
                        hddDontrungID.Value = string.Empty;
                    }
                    //29/07/2024
                    //UPDATE_NDBD_NKN(oT);//add them nguoi khieu nai, bi cao
                    if (oT.NGUOITAO == null)//add nếu là người sửa đầu tiên đơn  nhận từ Văn Thư, thì update người tạo.
                    {
                        oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oT.NGAYTAO = DateTime.Now;
                    }

                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    try
                    {
                        dt.SaveChanges();
                    }
                    catch (DbUpdateConcurrencyException ex)
                    {
                        //var value = ex.Entries.Single();
                        //value.OriginalValues.SetValues(value.GetDatabaseValues());
                        //dt.SaveChanges();

                        // saveFailed = true;

                        // Update the values of the entity that failed to save from the store 
                        ex.Entries.Single().Reload();
                        //dt.Entry<GDTTT_DON>(oT).Reload();
                        lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                        lstMsgT.Text = lstMsgB.Text = "Lỗi khi lưu, bạn hãy thử lại: " + ex.Message;
                        return false;
                    }
                    catch (EntityDataSourceValidationException e)
                    {
                        lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                        lstMsgT.Text = lstMsgB.Text = "Lỗi Entities: " + e.Message;

                        return false;
                    }
                    catch (System.Data.Entity.Validation.DbEntityValidationException ex)
                    {
                        string strErr = "";
                        foreach (var eve in ex.EntityValidationErrors)
                        {
                            foreach (var ve in eve.ValidationErrors)
                            {
                                strErr += ve.PropertyName + " : " + ve.ErrorMessage;
                            }
                        }
                        lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                        lstMsgT.Text = lstMsgB.Text = "Có lỗi, hãy thử lại: " + strErr;

                        return false;
                    }
                    oBL.UPDATESOLUONGDON(oT.ID);
                }
                string strDSNguoiKN = "";
                if (ddlHinhthucdon.SelectedValue == "2" || ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9")
                {
                    strDSNguoiKN = oT.CV_TENDONVI;
                }
                else if (ddlHinhthucdon.SelectedValue == "4")
                {
                    strDSNguoiKN = drop_DONVICHUYEN_HSKN.Text;
                }
                else
                {
                    strDSNguoiKN = oT.NGUOIGUI_HOTEN;
                }

                //Lưu người khiếu nại
                foreach (DataGridItem item in dgNguoiKN.Items)
                {
                    TextBox txtHoten = (TextBox)item.FindControl("txtHoten");
                    TextBox txtDiachi = (TextBox)item.FindControl("txtDiachi");
                    DropDownList ddlGioitinhDNK = (DropDownList)item.FindControl("ddlGioitinhDNK");
                    string strKNID = item.Cells[0].Text;
                    if (txtHoten.Text.Trim() != "")
                    {
                        strDSNguoiKN = strDSNguoiKN + ", " + txtHoten.Text.Trim();
                        GDTTT_DON_NGUOIKN oKN = new GDTTT_DON_NGUOIKN();
                        if (strKNID != "" && strKNID != "0")
                        {
                            decimal KNID = Convert.ToDecimal(strKNID);
                            oKN = dt.GDTTT_DON_NGUOIKN.Where(x => x.ID == KNID).FirstOrDefault();
                            oKN.HOTEN = txtHoten.Text;
                            oKN.DIACHI = txtDiachi.Text;
                            oKN.GIOITINH = Convert.ToDecimal(ddlGioitinhDNK.SelectedValue);
                            oKN.DONID = oT.ID;
                        }
                        else
                        {
                            oKN.HOTEN = txtHoten.Text;
                            oKN.DIACHI = txtDiachi.Text;
                            oKN.GIOITINH = Convert.ToDecimal(ddlGioitinhDNK.SelectedValue);
                            oKN.DONID = oT.ID;
                            dt.GDTTT_DON_NGUOIKN.Add(oKN);
                        }
                    }
                    else
                    {
                        if (strKNID != "" && strKNID != "0")
                        {
                            decimal KNID = Convert.ToDecimal(strKNID);
                            GDTTT_DON_NGUOIKN oKN = dt.GDTTT_DON_NGUOIKN.Where(x => x.ID == KNID).FirstOrDefault();
                            dt.GDTTT_DON_NGUOIKN.Remove(oKN);
                        }
                    }
                }
                if (txtNguoigui_VB.Text != null && txtNguoigui_VB.Text != "")
                {
                    oT.NGUOIGUI_HOTEN = txtNguoigui_VB.Text;
                }
                oT.DONGKHIEUNAI = strDSNguoiKN;

                //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
                bool isPC = true;
                //với những hình thức này thì không được phân thẩm phán bậc3
                if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10" || ddlHinhthucdon.SelectedValue == "5" || ddlHinhthucdon.SelectedValue == "4")
                {
                    isPC = false;
                }
                if (isPC)
                {
                    oT.ISTPB3 = Convert.ToDecimal(rdbThamquyen.SelectedValue);
                }

                //Lưu thông báo trả lời đơn
                try
                {
                    foreach (DataGridItem item in dgTBTLD.Items)
                    {
                        TextBox txtSo = (TextBox)item.FindControl("txtSo");
                        TextBox txtNgay = (TextBox)item.FindControl("txtNgay");
                        DropDownList ddlToaAn = (DropDownList)item.FindControl("ddlToaAn");
                        string strKNID = item.Cells[0].Text;
                        if (isNew)
                            strKNID = "0";
                        if (txtSo.Text.Trim() != "")
                        {
                            GDTTT_DON_TBTLD oKN = new GDTTT_DON_TBTLD();
                            if (strKNID != "" && strKNID != "0")
                            {
                                decimal KNID = Convert.ToDecimal(strKNID);
                                oKN = dt.GDTTT_DON_TBTLD.Where(x => x.ID == KNID).FirstOrDefault();
                                oKN.SO = txtSo.Text;
                                DateTime? dNgay = (String.IsNullOrEmpty(txtNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                oKN.NGAY = dNgay;
                                oKN.DONVITB = Convert.ToDecimal(ddlToaAn.SelectedValue);
                                oKN.DONID = oT.ID;
                            }
                            else
                            {
                                if (dt.GDTTT_DON_TBTLD.Where(x => x.DONID == oT.ID && x.SO == txtSo.Text).ToList().Count == 0)
                                {
                                    oKN.SO = txtSo.Text;
                                    DateTime? dNgay = (String.IsNullOrEmpty(txtNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                    oKN.NGAY = dNgay;
                                    oKN.DONID = oT.ID;
                                    oKN.DONVITB = Convert.ToDecimal(ddlToaAn.SelectedValue);
                                    dt.GDTTT_DON_TBTLD.Add(oKN);

                                }
                            }
                        }
                        else
                        {
                            if (strKNID != "" && strKNID != "0")
                            {
                                decimal KNID = Convert.ToDecimal(strKNID);
                                GDTTT_DON_TBTLD oKN = dt.GDTTT_DON_TBTLD.Where(x => x.ID == KNID).FirstOrDefault();
                                dt.GDTTT_DON_TBTLD.Remove(oKN);
                            }
                        }
                    }
                }
                catch (Exception ex) { }
                try
                {

                    dt.SaveChanges();
                    //23/07/2024
                    //check lại xem DONTRUNGID, arr_don_id có bị null hay không
                    GDTTT_DON otc = dt.GDTTT_DON.Where(x => x.ID == oT.ID).FirstOrDefault();
                    if (Convert.ToString(otc.DONTRUNGID) == "" || Convert.ToString(otc.DONTRUNGID) == null)
                    {
                        otc.DONTRUNGID = 0;
                        if (Convert.ToString(otc.ARR_DON_ID) != "" && Convert.ToString(otc.ARR_DON_ID) != null)
                        {
                            if (otc.ARR_DON_ID > 0)
                            {
                                otc.DONTRUNGID = otc.ARR_DON_ID;
                            }
                        }
                    }
                    if (Convert.ToString(otc.ARR_DON_ID) == "" || Convert.ToString(otc.ARR_DON_ID) == null)
                    {
                        otc.ARR_DON_ID = 0;
                    }
                    dt.SaveChanges();
                    ///--------
                    Check_BC_NKN();
                    Load_NKN_BC();
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    //var value = ex.Entries.Single();
                    //value.OriginalValues.SetValues(value.GetDatabaseValues());
                    //dt.SaveChanges();
                    // saveFailed = true;
                    // Update the values of the entity that failed to save from the store 
                    ex.Entries.Single().Reload();
                    //dt.Entry<GDTTT_DON>(oT).Reload();
                    lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                    lstMsgT.Text = lstMsgB.Text = "Lỗi khi lưu, bạn hãy thử lại: " + ex.Message;
                    return false;
                }
                //Xoa thu ly Kiem tra xem neu la Don thu ly moi thi hien thị nut                     
                AnHienkhiXoathulydon(oT.ID.ToString());

                return true;
            }
            catch (EntityDataSourceValidationException e)
            {
                lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                lstMsgT.Text = lstMsgB.Text = "Lỗi Entities: " + e.Message;

                return false;
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException ex)
            {
                string strErr = "";
                foreach (var eve in ex.EntityValidationErrors)
                {
                    foreach (var ve in eve.ValidationErrors)
                    {
                        strErr += ve.PropertyName + " : " + ve.ErrorMessage;
                    }
                }
                lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                lstMsgT.Text = lstMsgB.Text = "Có lỗi, hãy thử lại: " + strErr;

                return false;
            }
            catch (Exception ex)
            {
                lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message + " | " + ex.InnerException.ToString();
                return false;
            }
        }
        private void CheckVisibleControls()
        {
            if (txtSoQDBA.Visible == false)
                txtSoQDBA.Text = "";

            if (txtNgayBA.Visible == false)
                txtNgayBA.Text = "";

            if (txtSoQDKN.Visible == false)
                txtSoQDKN.Text = "";

            if (txtNgayKhangNghi.Visible == false)
                txtNgayKhangNghi.Text = "";

            if (txtSoBA_PT.Visible == false)
                txtSoBA_PT.Text = "";

            if (txtNgayBA_PT.Visible == false)
                txtNgayBA_PT.Text = "";

            if (txtSoBA_ST.Visible == false)
                txtSoBA_ST.Text = "";

            if (txtNgayBA_ST.Visible == false)
                txtNgayBA_ST.Text = "";

            if (txtDoituongbiKN.Visible == false)
                txtDoituongbiKN.Text = "";

            if (txtNguoigui.Visible == false)
                txtNguoigui.Text = "";

            if (txtSoCMND.Visible == false)
                txtSoCMND.Text = "";

            if (txtSoDienThoai.Visible == false)
                txtSoDienThoai.Text = "";

            if (txtNGHuyen.Visible == false)
                txtNGHuyen.Text = "";

            if (txtNgaynhandon.Visible == false)
                txtNgaynhandon.Text = "";

            if (txtNgaynhandon_VB.Visible == false)
                txtNgaynhandon_VB.Text = "";

            if (txtNgayghidon.Visible == false)
                txtNgayghidon.Text = "";

            if (txtSohieudon.Visible == false)
                txtSohieudon.Text = "";

            if (txtSohieudon_VB.Visible == false)
                txtSohieudon_VB.Text = "";

            if (txtVB_Ngay.Visible == false)
                txtVB_Ngay.Text = "";

            if (txtDiachi_VB.Visible == false)
                txtDiachi_VB.Text = "";

            if (txtNoidung.Visible == false)
                txtNoidung.Text = "";

            if (txtGhichu.Visible == false)
                txtGhichu.Text = "";

            if (txtSoLuongDon.Visible == false)
                txtSoLuongDon.Text = "1";

            if (txtCA_Noidung.Visible == false)
                txtCA_Noidung.Text = "";

            if (txtCA_Noidung_VB.Visible == false)
                txtCA_Noidung_VB.Text = "";

            if (ddlCapXetXu.Visible == false)
            {
                Cls_Comon.SetValueComboBox(ddlCapXetXu, "0");
            }

            if (dropToaAnPT.Visible == false)
            {
                Cls_Comon.SetValueComboBox(dropToaAnPT, "0");
                txtNgayBA_PT.Text = "";
            }

            if (dropToaAnST.Visible == false)
            {
                Cls_Comon.SetValueComboBox(dropToaAnST, "0");
                txtNgayBA_ST.Text = "";
            }

            if (ddlNguoiKhangNghi.Visible == false)
                ddlNguoiKhangNghi.SelectedValue = "0";

            if (chkKN_TBTLD.Visible == false)
            {
                chkKN_TBTLD.Checked = false;
            }

            if (chkIsNotGDT.Visible == false)
            {
                chkIsNotGDT.Checked = false;
            }

            if (hddNGDCID.Visible == false)
                hddNGDCID.Value = "0";

            if (ddlToaXetXu.Visible == false)
                ddlToaXetXu.SelectedValue = "0";

            if (ddlGioitinh.Visible == false)
                ddlGioitinh.SelectedIndex = 0;

            if (chkIsTuHinh.Visible == false)
            {
                chkIsTuHinh.Checked = false;
                chkKeuOan.Checked = chkIsAnGiam.Checked = false;
            }

            if (ddlHinhthucdon.Visible == false)
                ddlHinhthucdon.SelectedIndex = 0;

            if (ddlDungdonla.Visible == false)
                ddlDungdonla.SelectedIndex = 0;

            if (ddlDungdonla_VB.Visible == false)
                ddlDungdonla_VB.SelectedIndex = 0;

            if (ddlTucachTT.Visible == false)
                ddlTucachTT.SelectedIndex = 0;

            if (hddNGDCID.Visible == false)
                hddNGDCID.Value = "0";

            if (hddCVDCID.Visible == false)
                hddCVDCID.Value = "0";

            if (ddlCAChidao.Visible == false)
            {
                ddlCAChidao.SelectedIndex = 0;
                trChidao.Visible = false;
            }

            if (ddlHinhthucdon.SelectedValue != "31" && ddlHinhthucdon.SelectedValue != "3" && ddlHinhthucdon.SelectedValue != "10" && ddlHinhthucdon.SelectedValue != "2"
                && ddlHinhthucdon.SelectedValue != "6" && ddlHinhthucdon.SelectedValue != "9")// Loại đơn + công văn
            {
                chkIsTrongNganh.Visible = true;

                if (chkIsTrongNganh.Checked)
                {
                    pnDonViGuiTrongNganh.Visible = true;
                    pnDonViGuiNgoaiNganh.Visible = false;
                    if (ddlCV_Donvi.Visible == false)
                        ddlCV_Donvi.SelectedValue = "0";
                }
                else
                {
                    pnDonViGuiTrongNganh.Visible = false;
                    pnDonViGuiNgoaiNganh.Visible = true;
                    if (txtCV_DonViGuiNgoaiNganh.Visible == false)
                        txtCV_DonViGuiNgoaiNganh.Text = "";
                }
                if (txtCV_So.Visible == false)
                    txtCV_So.Text = "";

                if (txtCV_Ngay.Visible == false)
                    txtCV_Ngay.Text = "";

                if (txtCV_Nguoiky.Visible == false)
                    txtCV_Nguoiky.Text = "";

                if (txtCV_Chucvu.Visible == false)
                    txtCV_Chucvu.Text = "";

                if (txtCVDC.Visible == false)
                    txtCVDC.Text = "";

                if (txtCVDiachi.Visible == false)
                    txtCVDiachi.Text = "";

                if (ddlYeucauthongbao.Visible == false)
                    ddlYeucauthongbao.SelectedValue = "0";

                if (ddlLoaiCongVan.Visible == false)
                    ddlLoaiCongVan.SelectedValue = "547";

                pnCongvan.Visible = false;

                if (txtTraigiamhientai.Visible == false)
                    txtTraigiamhientai.Text = "";
            }


            if (ddlCV_Donvi.Visible == false)
                ddlCV_Donvi.SelectedIndex = 0;

            if (txtCV_DonViGuiNgoaiNganh.Visible == false)
                txtCV_DonViGuiNgoaiNganh.Text = "";

            if (hddCVDCID.Visible == false)
                hddCVDCID.Value = "0";

            if (txtCVDC.Visible == false)
                txtCVDC.Text = "";

            if (txtCVDiachi.Visible == false)
                txtCVDiachi.Text = "";

            if (txtCV_So.Visible == false)
                txtCV_So.Text = "";

            if (txtCV_Ngay.Visible == false)
                txtCV_Ngay.Text = "";

            if (txtCV_Nguoiky.Visible == false)
                txtCV_Nguoiky.Text = txtCV_Chucvu.Text = "";

            if (ddlGioitinh.Visible == false)
                ddlTraloi.SelectedIndex = 0;

            if (ddlYeucauthongbao.Visible == false)
                ddlYeucauthongbao.SelectedIndex = 0;

            if (trDongkhieunai.Visible == false)
            {
                ddlSonguoiKN.SelectedIndex = 0;
                chkIsCongVan.Visible = true;
            }


            //if (hddID.Visible == false)
            //    hddID.Value = "0";
            // pnDonTrung.Visible = true;

            if (ddlSoLuong.Visible == false)
                ddlSoLuong.SelectedIndex = 0;
            if (dgListDontrung.Visible == false)
            {
                dgListDontrung.DataSource = null;
                dgListDontrung.DataBind();
            }

            if (pnCongvan.Visible == false)
            {
                pnDonViGuiTrongNganh.Visible = false;
                pnDonViGuiNgoaiNganh.Visible = false;
            }
            //dgList.Visible = false;

            if (ddlSonguoiKN.Visible == false)
            {
                ddlSonguoiKN.SelectedIndex = 0;
                dgNguoiKN.DataSource = null;
                dgNguoiKN.DataBind();
                dgNguoiKN.Visible = false;
            }

            if (ddlTraloi.Visible == false)
            {
                ddlTraloi.SelectedValue = "3";
            }

            if (ddlTraloi_VB.Visible == false)
            {
                ddlTraloi_VB.SelectedValue = "3";
            }

            if (pnCV_traloi.Visible == false || ddlTraloi.SelectedValue == "2" || ddlTraloi.SelectedValue == "3")
            {
                txtCV_Traloi_Noidung.Text = "";
            }

            if (pnCV_traloi_VB.Visible == false || ddlTraloi_VB.SelectedValue == "2" || ddlTraloi_VB.SelectedValue == "3")
            {
                txtCV_Traloi_Noidung_VB.Text = "";
            }

            if (txtCV_Traloi_Noidung.Visible == false)
                txtCV_Traloi_Noidung.Text = "";

            if (txtCV_Traloi_Noidung_VB.Visible == false)
                txtCV_Traloi_Noidung_VB.Text = "";

            if (chkGDTIsKNTC.Visible == false)
            {
                chkGDTIsKNTC.Checked = false;
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtSoQDBA.ClientID);

            if (pnKNTCDoituong.Visible == false)
            {
                foreach (ListItem i in chkPhanloai.Items)
                {
                    i.Selected = false;
                }
            }
            if (pnBAQDGDT.Visible == false)
            {
                //GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                ////txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                //decimal sothuly_ = 0;
                //oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                txtSoThuLy.Text = "";
                //-------------------
            }
            Load_pnkiem_tratrung();
            txtTenDonTrung.Enabled = true;

            if (txtTenDonTrung.Visible == false)
                txtTenDonTrung.Text = "";

            if (hddDontrungID.Visible == false)
                hddDontrungID.Value = "0";
            if (trDSTrung.Visible == false)
            {
                dgListTrung.DataSource = null;
                dgListTrung.DataBind();
            }

            if (pnDSTrung.Visible == false)
            {
                dgDSDonTrung.DataSource = null;
                dgDSDonTrung.DataBind();
            }

            if (pnDS_DonKemTheo.Visible == false)
            {
                dgDSDonKemTheo.DataSource = null;
                dgDSDonKemTheo.DataBind();
            }

            if (chkKN_TBTLD.Visible == false)
            {
                dgTBTLD.DataSource = null;
                dgTBTLD.DataBind();
            }

            if (ddlSoTBTLD.Visible == false)
                ddlSoTBTLD.SelectedValue = "1";
            //chkKN_TBTLD_CheckedChanged(null, null);

            if (txt_QHPL.Visible == false)
                txt_QHPL.Text = string.Empty;
            //txt_GHICHU_TTCD.Text = String.Empty;
            ///------------
            ///
            if (txtSOKN.Visible == false)
                txtSOKN.Text = string.Empty;

            if (txt_NGAYQDKN.Visible == false)
                txt_NGAYQDKN.Text = string.Empty;

            if (drop_DONVICHUYEN_HSKN.Visible == false)
                drop_DONVICHUYEN_HSKN.SelectedValue = "0";

            if (txtNgaynhandon_kn.Visible == false)
                txtNgaynhandon_kn.Text = string.Empty;

            if (ddlCAChidao_kn.Visible == false)
                ddlCAChidao_kn.SelectedValue = "0";

            if (txtCA_Noidung_kn.Visible == false)
                txtCA_Noidung_kn.Text = string.Empty;

            if (txt_GHICHU_HS.Visible == false)
                txt_GHICHU_HS.Text = string.Empty;

        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            var idF = Request["cc_id"];
            if (idF != "" && idF != "0" && idF != null)
            {
                decimal ID = Convert.ToDecimal(idF);
                //GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                var GDTTT_CC_TC_MAPPINGExist = DataExtensions.GetAllByDonId<GDTTT_CC_TC_MAPPING>(ID).Count();
                if (GDTTT_CC_TC_MAPPINGExist > 0)
                {
                    lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Red;
                    lstMsgT.Text = lstMsgB.Text = "Đơn đã được xử lý. Vui lòng chọn đơn khác!";
                    divCommandT.Visible = false;
                    divCommandB.Visible = false;
                    return;
                }
            }
            CheckVisibleControls();

            if (SaveData())
            {
                if (pnDonTrung.Visible && ddlSoLuong.SelectedValue != "0")//lưu đơn đính kèm
                {
                    hddNext.Value = "0";
                    SaveDonKemTheo();
                    LoadDSKemTheo();
                    // ddlSoLuong.SelectedValue = "0";
                    // pnDonTrung.Visible = false;
                }
                //load lại TB trả lời đơn
                if (chkKN_TBTLD.Checked)
                {
                    LoadTBTLD(Convert.ToDecimal(hddID.Value));
                }
                // Response.Redirect("Danhsachdon.aspx");
                lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Blue;
                lstMsgT.Text = lstMsgB.Text = "Lưu thành công !";
                lstMsg_dontrung.Text = string.Empty;
                //-------
                Dongkhieunai_Check_Update(hddID.Value, 0);
                //add 22/10/2020 update trang thai da xu ly vào văn thư đến
                if (Request["vt_id"] + "" != "")
                {
                    VT_CHUYEN_NHAN o_Object = new VT_CHUYEN_NHAN();
                    VT_CHUYEN_NHAN_BL M_Object = new VT_CHUYEN_NHAN_BL();
                    M_Object.TRANGTHAI_XULY_UP(hddID.Value);
                }
                //------17/06/2021anhvh-update một số giá trị ngược lại văn thư đây là trường hợp khi lưu bên văn thư bị lỗi không lưu được vào database ----
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                oBL.IN_UP_VANTHU_V_NULL_CC(hddID.Value);
            }
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            try
            {
                if (SaveData())
                {
                    if (pnDonTrung.Visible && ddlSoLuong.SelectedValue != "0")
                    {
                        hddNext.Value = "1";
                        SaveDonKemTheo();
                        LoadDSKemTheo();
                    }
                    //--------
                    Dongkhieunai_Check_Update(hddID.Value, 0);
                    //22/10/2020 update trang thai da xu ly vào văn thư đến
                    if (Request["vt_id"] + "" != "")
                    {
                        VT_CHUYEN_NHAN o_Object = new VT_CHUYEN_NHAN();
                        VT_CHUYEN_NHAN_BL M_Object = new VT_CHUYEN_NHAN_BL();
                        M_Object.TRANGTHAI_XULY_UP(hddID.Value);
                    }
                    //--------------------------------
                    ResetControls();
                    ResetControls_ThemMoi();//---13/05/2021
                    lstMsgT.ForeColor = lstMsgB.ForeColor = System.Drawing.Color.Blue;
                    lstMsgT.Text = lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin đơn tiếp theo !";
                    lstMsg_dontrung.Text = string.Empty;
                }
            }
            catch (Exception ex) { lstMsgB.Text = lstMsgT.Text = ex.Message; }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsachdon.aspx");
        }
        protected void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ResetControls();
            ResetControls_ThemMoi();
        }
        private void ddlHinhthucdonChange()
        {
            //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
            if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10" || ddlHinhthucdon.SelectedValue == "5")
            {
                rdbThamquyen.Visible = false;
                lblThamquyen.Visible = false;
            }
            else
            {
                rdbThamquyen.Visible = true;
                lblThamquyen.Visible = true;
            }
            if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
            {
                pnToaanXX.Visible = false;
            }
            else
            {
                pnToaanXX.Visible = true;
            }
            lblTucach.Visible = true;
            ddlTucachTT.Visible = true;
            lblTitleNgaytrendon.Visible = true;
            txtNgayghidon.Visible = true;
            lblTitleNoidung.Text = "Nội dung đơn";
            // pnDonTrung.Visible = false;
            pn_LOAI_GDTTT.Visible = true;
            PN_VBHC_TL.Visible = false;
            KN_BiCao.Style.Remove("Display");
            pnNoibo.Visible = true;
            pnNoibo_vb.Visible = false;
            TTChuyenDon.Text = "Thông tin chuyển đơn";


            pn_Loai_KNTP.Visible = false;


            load_lable_ba_qd();
            rdbLoaichuyen.Enabled = true;
            rdbThuLy.Enabled = true;
            lblSoThuly.Text = "Số thụ lý";
            lblNgaythuly.Text = "Ngày thụ lý";

            ddlTrangthaidon.Enabled = true;

            if (ddlHinhthucdon.SelectedValue == "31" || ddlHinhthucdon.SelectedValue == "3")//Đơn + Công văn
            {
                pnTTDon.Visible = true;
                pnKiemtraTrung.Visible = true;
                trDongkhieunai.Visible = true;
                trTitleCongvan.Visible = true;
                pnCongvan.Visible = true;
                if (hddID.Value == "0")
                    //pnDonTrung.Visible = true;
                    ChangeLoaiCV();

                showHideddlGioitinhByDungdonla();

                if (pnCongvan.Visible)
                {
                    if (chkIsTrongNganh.Checked)
                    {
                        pnDonViGuiTrongNganh.Visible = true;
                        pnDonViGuiNgoaiNganh.Visible = false;
                        // chkTraigiam.Visible = false;
                    }
                    else
                    {
                        // chkTraigiam.Visible = true;
                        pnDonViGuiTrongNganh.Visible = false;
                        pnDonViGuiNgoaiNganh.Visible = true;
                    }
                }
                PN_HOSO_KN.Visible = false;
                PN_DON_CV.Visible = true;
                lbl_nguoi_gui.Text = "Người đứng đơn";
                lbl_diachi_gui.Text = "Địa chỉ người đứng đơn";
            }
            else if (ddlHinhthucdon.SelectedValue == "2" || ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9")//Công văn
            {
                lblTitleNgaytrendon.Visible = false;
                txtNgayghidon.Visible = false;
                pnTTDon.Visible = false;
                trDongkhieunai.Visible = false;
                trTitleCongvan.Visible = false;
                pnCongvan.Visible = true;
                // pnDonTrung.Visible = false;
                lblTitleNoidung.Text = "Nội dung công văn";
                PN_HOSO_KN.Visible = false;
                PN_DON_CV.Visible = true;
                lbl_nguoi_gui.Text = "Người gửi";
                lbl_diachi_gui.Text = "Địa chỉ người gửi";
                if (ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9")
                {
                    ddlLoaiCongVan.SelectedValue = "544";
                }
                else
                {
                    ddlLoaiCongVan.SelectedValue = "547";
                }

            }
            else if (ddlHinhthucdon.SelectedValue == "4")
            {
                PN_HOSO_KN.Visible = true;
                PN_DON_CV.Visible = false;
                //LoadDropNGuoiKy_VKS();
                //Load_CAChidao_kn();
                // Load_trChidao_kn();
                lbl_nguoi_gui.Text = "Người gửi";
                lbl_diachi_gui.Text = "Địa chỉ người gửi";
                //luon la thu ly moi
                rdbThuLy.SelectedValue = "1";
                rdbThuLy.Enabled = false;
                //Chỉ chuyển nội bộ
                rdbLoaichuyen.SelectedValue = "0";
                rdbLoaichuyen.Enabled = false;
                //Luon la du dieu kien
                ddlTrangthaidon.SelectedValue = "0";
                ddlTrangthaidon.Enabled = false;
                TTChuyenDon.Text = "Thông tin thụ lý Xét xử Giám đốc thẩm";
                lblSoThuly.Text = "Số thụ lý XXGDT";
                lblNgaythuly.Text = "Ngày thụ lý XXGDT";

            }
            else if (ddlHinhthucdon.SelectedValue == "1" || ddlHinhthucdon.SelectedValue == "11") //Don GDT, Don
            {
                showHideddlGioitinhByDungdonla();

                pnTTDon.Visible = true;
                pnKiemtraTrung.Visible = true;
                trDongkhieunai.Visible = true;
                trTitleCongvan.Visible = true;
                pnCongvan.Visible = false;
                if (hddID.Value == "0")
                    //pnDonTrung.Visible = true;
                    PN_HOSO_KN.Visible = false;
                PN_DON_CV.Visible = true;
                lbl_nguoi_gui.Text = "Người đứng đơn";
                lbl_diachi_gui.Text = "Địa chỉ người đứng đơn";
            }
            else if (ddlHinhthucdon.SelectedValue == "5")
            {
                lblTitleNgaytrendon.Visible = false;
                txtNgayghidon.Visible = false;
                pnTTDon.Visible = false;
                trDongkhieunai.Visible = false;
                trTitleCongvan.Visible = false;
                pnCongvan.Visible = true;
                //pnDonTrung.Visible = false;
                lblTitleNoidung.Text = "Nội dung công văn";
                PN_HOSO_KN.Visible = false;
                PN_DON_CV.Visible = false;
                lbl_nguoi_gui.Text = "Người gửi";
                lbl_diachi_gui.Text = "Địa chỉ người gửi";
                pn_LOAI_GDTTT.Visible = false;
                PN_VBHC_TL.Visible = true;
                KN_BiCao.Style.Add("Display", "none");
                pnNoibo.Visible = false;
                pnNoibo_vb.Visible = true;
                TTChuyenDon.Text = "Thông tin chuyển văn bản";
            }
            else if (ddlHinhthucdon.SelectedValue == "8")// Don KNTP
            {
                pnTTDon.Visible = true;
                trDongkhieunai.Visible = true;
                trTitleCongvan.Visible = true;
                pnCongvan.Visible = false;
                if (hddID.Value == "0")
                    //pnDonTrung.Visible = true;
                    PN_HOSO_KN.Visible = false;
                PN_HOSO_KN.Visible = false;
                PN_DON_CV.Visible = true;
                lbl_nguoi_gui.Text = "Người đứng đơn";
                lbl_diachi_gui.Text = "Địa chỉ người đứng đơn";

                pn_LOAI_GDTTT.Visible = false;
                pnKiemtraTrung.Visible = false;
                pn_Loai_KNTP.Visible = true;
                KN_BiCao.Style.Add("Display", "none");
                showHideddlGioitinhByDungdonla();
                rdbLoaichuyen.Enabled = true;

            }
            else if (ddlHinhthucdon.SelectedValue == "10")// Don KNTP + Cong van chuyen don
            {
                rdbLoaichuyen.Enabled = true;

                pnTTDon.Visible = true;
                trDongkhieunai.Visible = true;
                trTitleCongvan.Visible = true;
                pnCongvan.Visible = false;
                if (hddID.Value == "0")
                    //pnDonTrung.Visible = true;
                    PN_HOSO_KN.Visible = false;
                PN_HOSO_KN.Visible = false;
                PN_DON_CV.Visible = true;
                lbl_nguoi_gui.Text = "Người đứng đơn";
                lbl_diachi_gui.Text = "Địa chỉ người đứng đơn";

                pn_LOAI_GDTTT.Visible = false;
                pnKiemtraTrung.Visible = false;
                pn_Loai_KNTP.Visible = true;
                KN_BiCao.Style.Add("Display", "none");

                pnCongvan.Visible = true;
                if (hddID.Value == "0")
                    //pnDonTrung.Visible = true;
                    ChangeLoaiCV();
                showHideddlGioitinhByDungdonla();
                if (pnCongvan.Visible)
                {
                    if (chkIsTrongNganh.Checked)
                    {
                        pnDonViGuiTrongNganh.Visible = true;
                        pnDonViGuiNgoaiNganh.Visible = false;
                        // chkTraigiam.Visible = false;
                    }
                    else
                    {
                        // chkTraigiam.Visible = true;
                        pnDonViGuiTrongNganh.Visible = false;
                        pnDonViGuiNgoaiNganh.Visible = true;
                    }
                }


                pnThuLy.Visible = false;
                trTrangthaidon.Visible = false;
                pnBAQDGDT.Visible = false;
                pnKNTCDoituong.Visible = true;
                ddlLoaiAn.Visible = false;
                chkGDTIsKNTC.Visible = false;
                lblLoaiAn.Visible = false;
                LoadLoaiAn();
                LoaiAnChange();

            }
            else//ĐƠn
            {
                pnTTDon.Visible = true;
                pnKiemtraTrung.Visible = true;
                trDongkhieunai.Visible = true;
                trTitleCongvan.Visible = true;
                pnCongvan.Visible = false;
                if (hddID.Value == "0")
                    //pnDonTrung.Visible = true;
                    PN_HOSO_KN.Visible = false;
                PN_DON_CV.Visible = true;
                lbl_nguoi_gui.Text = "Người gửi";
                lbl_diachi_gui.Text = "Địa chỉ người gửi";

                showHideddlGioitinhByDungdonla();
            }
        }
        protected void ddlHinhthucdon_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlHinhthucdon_kntc.SelectedValue = ddlHinhthucdon.SelectedValue;
            ddlHinhthucdonChange();
            clear_kn();
            Cls_Comon.SetFocus(this, this.GetType(), ddlHinhthucdon.ClientID);
            //-----------
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
            //decimal sothuly_ = 0;
            //oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
            //txtSoThuLy.Text = Convert.ToString(sothuly_);
            //---------------
            check_span_batbuoc();
            Load_pnkiem_tratrung();
            //Load_BAQD();
            //if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
            //{
            //    LoadPhongban();
            //    ddlChuyendenDV.SelectedValue = "21";
            //}
            //else
            //{
            LoadPhongban();
            ChuyendenDVChange(0);
            LoadLoaiAn();

            //}
            //----------//19/06/2025
            if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
            {
                ddlChuyendenDV.SelectedValue = "21";
            }
            //----------//19/06/2025 end
            setLoaichuyen();

            if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
            {
                pnToaanXX.Visible = false;
                pnBAQDGDT.Visible = false;
                pnKNTCDoituong.Visible = true;
            }
            else
            {
                pnToaanXX.Visible = true;
                pnBAQDGDT.Visible = true;
                pnKNTCDoituong.Visible = false;
            }
            //-----------------------------------------------------
            string current_id = Request["ID"] + "";
            if (current_id != "" && current_id != "0")
            {
                LoadInfo_CheckLoaiDon(Convert.ToDecimal(current_id), false);
            }
            else
            {
                if (hddID.Value != "" && hddID.Value != "0")
                {
                    LoadInfo_CheckLoaiDon(Convert.ToDecimal(hddID.Value), false);
                }
            }
        }
        private void LoadInfo_CheckLoaiDon(decimal ID, bool isLoadTrung)
        {//khi htd=true thì sẽ load lại theo đúng trên db, mà không load về mặc định (có thể hiểu là hàm trên sẽ giữ nguyên những cái đã lưu trên db)
            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
            bool htd = false;
            if (oT != null)
            {
                if (oT.CD_LOAI != null)
                {
                    if ((ddlHinhthucdon.SelectedValue == "1" || ddlHinhthucdon.SelectedValue == "3") && (oT.LOAIDON == 1 || oT.LOAIDON == 3))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10") && (oT.LOAIDON == 8 || oT.LOAIDON == 10))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9" || ddlHinhthucdon.SelectedValue == "12") && (oT.LOAIDON == 6 || oT.LOAIDON == 9 || oT.LOAIDON == 12))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "11" || ddlHinhthucdon.SelectedValue == "1" || ddlHinhthucdon.SelectedValue == "3") && (oT.LOAIDON == 11 || oT.LOAIDON == 1 || oT.LOAIDON == 3))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "31" || ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "1") && (oT.LOAIDON == 31 || oT.LOAIDON == 3 || oT.LOAIDON == 1))
                    {
                        htd = true;
                    }
                    //1.Đơn đề nghị GĐT,TT-> 9.CV kiến nghị GĐT,TT kèm Hồ sơ
                    //1.Đơn đề nghị GĐT,TT-> 12.CV khác
                    //3.Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn-> 6.CV kiến nghị GĐT,TT
                    //3.Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn-> 9.CV kiến nghị GĐT,TT kèm Hồ sơ
                    //3.Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn-> 12.CV khác
                    //19/11/2024
                    if ((ddlHinhthucdon.SelectedValue == "1" || ddlHinhthucdon.SelectedValue == "9") && (oT.LOAIDON == 1 || oT.LOAIDON == 9))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "1" || ddlHinhthucdon.SelectedValue == "6") && (oT.LOAIDON == 1 || oT.LOAIDON == 6))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "1" || ddlHinhthucdon.SelectedValue == "12") && (oT.LOAIDON == 1 || oT.LOAIDON == 12))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "6") && (oT.LOAIDON == 3 || oT.LOAIDON == 6))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "9") && (oT.LOAIDON == 3 || oT.LOAIDON == 9))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "12") && (oT.LOAIDON == 3 || oT.LOAIDON == 12))
                    {
                        htd = true;
                    }
                    if ((ddlHinhthucdon.SelectedValue == "2" || ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9"
                        || ddlHinhthucdon.SelectedValue == "12" || ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "10")
                        && (oT.LOAIDON == 2 || oT.LOAIDON == 6 || oT.LOAIDON == 9 || oT.LOAIDON == 12 || oT.LOAIDON == 3 || oT.LOAIDON == 10))
                    {
                        htd = true;
                    }
                    if (htd == true)
                    {
                        rdbLoaichuyen.SelectedValue = oT.CD_LOAI.ToString();
                        switch (rdbLoaichuyen.SelectedValue)
                        {
                            case "0"://Nội bộ tòa án  
                                if (oT.CD_TA_DONVIID != null)
                                    try { ddlChuyendenDV.SelectedValue = oT.CD_TA_DONVIID.ToString(); }
                                    catch (Exception ex) { }
                                if (ddlHinhthucdon.SelectedValue == "5")
                                {
                                    ddlChuyendenDV_VB.SelectedValue = oT.CD_TA_DONVIID.ToString();
                                    txtNgayChuyen_VB.Text = oT.NGAYCHUYEN_VB + "" == "" ? "" : ((DateTime)oT.NGAYCHUYEN_VB).ToString("dd/MM/yyyy");
                                }
                                else if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
                                {
                                    //Vơi don khieu nai tu phap và đơn vị nhận là hội đồng thẩm phán thì lưu thêm id lãnh đạo
                                    if (ddlChuyendenDV.SelectedValue == "102")
                                    {

                                        Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                        decimal v_chucdanh = 486;//TPTATC
                                                                 //Chi áp dung với TANDTC
                                        if (LoginDonViID == 1)
                                        {
                                            dropTPTC.Visible = true;
                                            LoadAllHoiDongTP(v_chucdanh, LoginDonViID);
                                            dropTPTC.SelectedValue = oT.CANBO_ID_GIAIQUYET_KN.ToString();
                                        }
                                        else
                                        {
                                            dropTPTC.Visible = false;
                                            dropTPTC.SelectedValue = "0";
                                        }
                                    }
                                }

                                if (oT.CD_TA_DONVIID != null)
                                {
                                    ChuyendenDVChange(Convert.ToDecimal(oT.CD_TA_DONVIID));
                                    LoadLoaiAn();
                                }

                                if (pnBAQDGDT.Visible)
                                {
                                    if (oT.CD_TA_TRANGTHAI != null)
                                    {
                                        ddlTrangthaidon.SelectedValue = oT.CD_TA_TRANGTHAI.ToString();
                                    }
                                    if (oT.CD_TA_TRANGTHAI == null)
                                    {
                                        ddlTrangthaidon.SelectedValue = "1";
                                    }
                                    LoadLoaiAn();
                                    try
                                    {
                                        if (oT.BAQD_LOAIAN != null)
                                            ddlLoaiAn.SelectedValue = "0" + oT.BAQD_LOAIAN.ToString();
                                        LoadIsTuHinh(ddlLoaiAn.SelectedValue);
                                        if (trTuHinh.Visible)
                                        {
                                            chkIsTuHinh.Checked = oT.ISANTUHINH == 1 ? true : false;
                                            if (chkIsTuHinh.Checked)
                                            {
                                                chkIsAnGiam.Visible = chkKeuOan.Visible = true;
                                                chkIsAnGiam.Checked = oT.ISTH_ANGIAM == 1 ? true : false;
                                                chkKeuOan.Checked = oT.ISTH_KEUOAN == 1 ? true : false;
                                            }
                                        }
                                    }
                                    catch (Exception ex) { }
                                    if (ddlTrangthaidon.SelectedValue == "1")
                                    {
                                        lblLydoCDDK.Text = "Lý do";
                                        chkLydoCDDK.Visible = true;
                                        pnThuLy.Visible = false;
                                        rdbThuLy.Visible = false;
                                        chkLydoCDDK.Items[0].Selected = oT.CD_TA_LYDO_ISBAQD == 1 ? true : false;
                                        chkLydoCDDK.Items[1].Selected = oT.CD_TA_LYDO_ISXACNHAN == 1 ? true : false;
                                        chkLydoCDDK.Items[2].Selected = oT.CD_TA_LYDO_ISKHAC == 1 ? true : false;
                                        if (oT.CD_TA_LYDO_ISKHAC == 1)
                                        {
                                            trLydokhac.Visible = true;
                                            txtLydoCDDK_Khac.Text = oT.CD_TA_LYDO_KHAC + "";
                                        }
                                    }
                                    else
                                    {
                                        lblLydoCDDK.Text = "Thụ lý đơn";
                                        chkLydoCDDK.Visible = false;

                                        rdbThuLy.Visible = true;
                                        //if (oT.ISTHULY != null) rdbThuLy.SelectedValue = oT.ISTHULY + ""; // Load cũ

                                        pnThuLy.Visible = true;
                                        txtSoThuLy.Text = oT.TL_SO + "";
                                        txtNgaythuly.Text = oT.TL_NGAY + "" == "" ? "" : ((DateTime)oT.TL_NGAY).ToString("dd/MM/yyyy");
                                        if (isLoadTrung)
                                        {
                                            // rdbThuLy.SelectedValue = "2";
                                            pnThuLy.Visible = false;
                                            //27/03/2024
                                            //string strOption = Request["option"] + "";
                                            //if (strOption == "thulylai")
                                            //{
                                            //    rdbThuLy.SelectedValue = "1";
                                            //}
                                        }
                                        else
                                        {
                                            if (rdbThuLy.SelectedValue == "2")
                                                pnThuLy.Visible = false;
                                        }
                                    }
                                    txt_QHPL.Text = oT.QHPL_TEXT;
                                    // txt_GHICHU_TTCD.Text = oT.GHICHU_TTCD;
                                }
                                break;
                            case "1":
                                if (oT.CD_TK_DONVIID != null)
                                {
                                    ddlToaKhac.SelectedValue = oT.CD_TK_DONVIID + "";

                                }
                                if (oT.CD_TK_NOIGUI != null)
                                    rdbDonguitoi.SelectedValue = oT.CD_TK_NOIGUI.ToString();
                                break;
                            case "2":
                                txtNgoaitoaan.Text = oT.CD_NTA_TENDONVI;
                                break;
                            case "3":
                                if (oT.CD_TRALAI_LYDOID != null && oT.CD_TRALAI_LYDOID != 0)
                                {
                                    ddlLydotralai.SelectedValue = oT.CD_TRALAI_LYDOID.ToString();
                                }
                                else
                                {
                                    ddlLydotralai.SelectedValue = "0";
                                    txtTralaikhac.Text = oT.CD_TRALAI_LYDOKHAC;
                                    lblLydokhac.Visible = true;
                                    txtTralaikhac.Visible = true;
                                }
                                txtTralaiYeucau.Text = oT.CD_TRALAI_YEUCAU;
                                txtTralaiSophieu.Text = oT.CD_TRALAI_SOPHIEU;
                                txtTralaiNgay.Text = oT.CD_TRALAI_NGAYTRA + "" == "" ? "" : ((DateTime)oT.CD_TRALAI_NGAYTRA).ToString("dd/MM/yyyy");
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
        }
        protected void ddlHinhthucdon_kntc_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlHinhthucdon.SelectedValue = ddlHinhthucdon_kntc.SelectedValue;
            ddlHinhthucdonChange();
            clear_kn();
            Cls_Comon.SetFocus(this, this.GetType(), ddlHinhthucdon.ClientID);
            //-----------
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
            //decimal sothuly_ = 0;
            //oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
            //txtSoThuLy.Text = Convert.ToString(sothuly_);
            //---------------
            check_span_batbuoc();
            Load_pnkiem_tratrung();
            if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
            {
                LoadPhongban();
                ddlChuyendenDV.SelectedValue = "21";


            }
            else
            {
                LoadPhongban();
                ChuyendenDVChange(0);
                LoadLoaiAn();

            }
            setLoaichuyen();

            if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
            {
                pnToaanXX.Visible = false;
                pnBAQDGDT.Visible = false;
                pnKNTCDoituong.Visible = true;
            }
            else
            {
                pnToaanXX.Visible = true;
                pnBAQDGDT.Visible = true;
                pnKNTCDoituong.Visible = false;
            }
            //-----------------------------------------------------
            string current_id = Request["ID"] + "";
            if (current_id != "" && current_id != "0")
            {
                LoadInfo_CheckLoaiDon(Convert.ToDecimal(current_id), false);
            }
            else
            {
                if (hddID.Value != "" && hddID.Value != "0")
                {
                    LoadInfo_CheckLoaiDon(Convert.ToDecimal(hddID.Value), false);
                }
            }
        }
        protected void chkIsTrongNganh_CheckedChanged(object sender, EventArgs e)
        {
            if (pnCongvan.Visible)
            {
                if (chkIsTrongNganh.Checked)
                {
                    pnDonViGuiTrongNganh.Visible = true;
                    pnDonViGuiNgoaiNganh.Visible = false;
                    chkTraigiam.Checked = false;
                }
                else
                {
                    pnDonViGuiTrongNganh.Visible = false;
                    pnDonViGuiNgoaiNganh.Visible = true;
                }
            }
        }
        protected void chkTraigiam_CheckedChanged(object sender, EventArgs e)
        {
            if (chkTraigiam.Checked)
            {
                pnDonViGuiTrongNganh.Visible = false;
                pnDonViGuiNgoaiNganh.Visible = true;
                lblTraigiamhientai.Visible = txtTraigiamhientai.Visible = true;
                chkIsTrongNganh.Checked = false;
            }
            else
            {
                pnDonViGuiTrongNganh.Visible = true;
                pnDonViGuiNgoaiNganh.Visible = false;
                lblTraigiamhientai.Visible = txtTraigiamhientai.Visible = false;
            }
        }
        protected void rdbBAQD_SelectedIndexChanged(object sender, EventArgs e)
        {
            load_lable_ba_qd();
            Cls_Comon.SetFocus(this, this.GetType(), chkKN_TBTLD.ClientID);
        }
        protected void load_lable_ba_qd()
        {
            if (rdbBAQD.SelectedValue == "0" || rdbBAQD.SelectedValue == "")
            {
                lbl_so_ba_qd.Text = "Số bản án";
                lbl_ngay_ba_qd.Text = "Ngày bản án";
                pnSoKhangNghi.Visible = false;
                pnSoBA.Visible = true;
                spSOBA.Visible = spNGBA.Visible = spTOAXX.Visible = true;
            }
            else if (rdbBAQD.SelectedValue == "1")
            {
                lbl_so_ba_qd.Text = "Số BA/QĐ";
                lbl_ngay_ba_qd.Text = "Ngày BA/QĐ";
                pnSoKhangNghi.Visible = true;
                pnSoBA.Visible = true;
                spSOBA.Visible = spNGBA.Visible = spTOAXX.Visible = false;
            }
            else if (rdbBAQD.SelectedValue == "2")
            {
                lbl_so_ba_qd.Text = "Số quyết định";
                lbl_ngay_ba_qd.Text = "Ngày quyết định";
                pnSoKhangNghi.Visible = false;
                pnSoBA.Visible = true;
                spSOBA.Visible = spNGBA.Visible = spTOAXX.Visible = true;
            }
            else if (rdbBAQD.SelectedValue == "3")
            {
                lbl_so_ba_qd.Text = "Số Công văn";
                lbl_ngay_ba_qd.Text = "Ngày Công văn";
                pnSoKhangNghi.Visible = false;
                pnSoBA.Visible = true;
                spSOBA.Visible = spNGBA.Visible = spTOAXX.Visible = true;
            }
            else if (rdbBAQD.SelectedValue == "4")
            {
                lbl_so_ba_qd.Text = "Số Thông báo";
                lbl_ngay_ba_qd.Text = "Ngày Thông báo";
                pnSoKhangNghi.Visible = false;
                pnSoBA.Visible = true;
                spSOBA.Visible = spNGBA.Visible = spTOAXX.Visible = true;
            }

        }
        protected void ddlPhanloai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlPhanloai.SelectedValue == "04")
            {
                ddlTrangthaidon.SelectedValue = "1";
                lblLydoCDDK.Text = "Lý do";
                chkLydoCDDK.Visible = true;
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlPhanloai.ClientID);
        }
        private void LoaiAnChange()
        {
            if ((hddID.Value == "" || hddID.Value == "0" || txtSoThuLy.Text == "") && pnBAQDGDT.Visible)
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                decimal sothuly_ = 0;
                oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                txtSoThuLy.Text = Convert.ToString(sothuly_);
                //-------------------
            }
            LoadIsTuHinh(ddlLoaiAn.SelectedValue);
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Ngay xu ly don là ngay hệ thống
            if (hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.BAQD_LOAIAN != Convert.ToDecimal(ddlLoaiAn.SelectedValue))
                    txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }

            //Load_DV_Chuyen();
            TL_GETMAXTT();
            Check_Nguoi_KN_LoaiAn();
            //if (ddlLoaiAn.SelectedValue != "01")
            //{
            //    Create_NguyenDonBD();
            //}
            LoadIsTuHinh(ddlLoaiAn.SelectedValue);
            if (Session["DONID_CC"] + "" != "" || Session["VUVIECID_CC"] + "" != "")
            {
                if (ddlLoaiAn.SelectedValue == "01")
                {
                    LoadDropNguoiKhieuNai();
                    LoadDropBiCao();
                    LoadDanhSachBiCao();
                }
                else
                {
                    LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    //-----------------------------
                }
            }

            //Ngay xu ly don là ngay hệ thống
            if (hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.BAQD_LOAIAN != Convert.ToDecimal(ddlLoaiAn.SelectedValue))
                    txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }

            //Load_DV_Chuyen();//anhvh add 22/04/2021 selected donvi khi chon loai an.
            if ((hddID.Value == "" || hddID.Value == "0") && pnBAQDGDT.Visible && rdbThuLy.SelectedValue != "2")
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                decimal sothuly_ = 0;
                oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                txtSoThuLy.Text = sothuly_ + "";
                //-------------------
                Cls_Comon.SetFocus(this, this.GetType(), ddlTrangthaidon.ClientID);
            }
            else
            {
                if (rdbThuLy.SelectedValue != "2")
                {
                    VT_CHUYEN_NHAN_BL M_Object = new VT_CHUYEN_NHAN_BL();
                    DataTable oVTCN = null;
                    decimal vVanBanDenID = Convert.ToDecimal(hddID.Value);
                    oVTCN = M_Object.GET_VANBAN_CHUYENNHAN(vVanBanDenID);
                    if (oVTCN != null && oVTCN.Rows.Count > 0)
                    {
                        if (oVTCN.Rows[0]["TRANG_THAI_XLY"].ToString() == "3")//du lieu don thu chưa xử lý
                        {
                            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                            //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                            decimal sothuly_ = 0;
                            oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                            txtSoThuLy.Text = Convert.ToString(sothuly_);
                            //-------------------
                            Cls_Comon.SetFocus(this, this.GetType(), ddlTrangthaidon.ClientID);
                        }
                    }
                }
            }
            Check_Nguoi_KN_LoaiAn();
            //if (ddlLoaiAn.SelectedValue != "01")
            //{
            //    Create_NguyenDonBD();
            //}
            LoadIsTuHinh(ddlLoaiAn.SelectedValue);
            if (Session["DONID_CC"] + "" != "" || Session["VUVIECID_CC"] + "" != "")
            {
                if (ddlLoaiAn.SelectedValue == "01")
                {
                    LoadDropNguoiKhieuNai();
                    LoadDropBiCao();
                    LoadDanhSachBiCao();
                }
                else
                {
                    LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    //-----------------------------
                }
            }


        }
        private void TL_GETMAXTT()
        {
            if ((hddID.Value == "" || hddID.Value == "0") && pnBAQDGDT.Visible && rdbThuLy.SelectedValue != "2")
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                decimal sothuly_ = 0;
                oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                txtSoThuLy.Text = Convert.ToString(sothuly_);
                //-------------------
                Cls_Comon.SetFocus(this, this.GetType(), ddlTrangthaidon.ClientID);
            }
            else
            {
                if (rdbThuLy.SelectedValue != "2")
                {
                    VT_CHUYEN_NHAN_BL M_Object = new VT_CHUYEN_NHAN_BL();
                    DataTable oVTCN = null;
                    decimal vVanBanDenID = Convert.ToDecimal(hddID.Value);
                    oVTCN = M_Object.GET_VANBAN_CHUYENNHAN(vVanBanDenID);
                    if (oVTCN != null && oVTCN.Rows.Count > 0)
                    {
                        if (oVTCN.Rows[0]["TRANG_THAI_XLY"].ToString() == "3")//du lieu don thu chưa xử lý
                        {
                            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                            //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                            decimal sothuly_ = 0;
                            oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                            txtSoThuLy.Text = Convert.ToString(sothuly_);
                            //-------------------
                            Cls_Comon.SetFocus(this, this.GetType(), ddlTrangthaidon.ClientID);
                        }
                    }
                }
            }
        }
        protected void Check_Nguoi_KN_LoaiAn()
        {
            if (ddlLoaiAn.SelectedValue == "01")
            {
                lbl_KN_BC.Text = "Bị cáo, Người khiếu nại";
                BC_NKN_HS.Visible = true;
                BC_NKN_DS.Visible = false;
            }
            else if (ddlLoaiAn.SelectedValue == "06")
            {
                lbl_KN_BC.Text = "Người khởi kiện, Người bị kiện";
                BC_NKN_HS.Visible = false;
                BC_NKN_DS.Visible = true;
                // LoadDMQuanHePL();
            }
            else
            {
                lbl_KN_BC.Text = "Nguyên đơn, Bị đơn";
                BC_NKN_HS.Visible = false;
                BC_NKN_DS.Visible = true;
                // LoadDMQuanHePL();
            }
        }
        protected void Load_DV_Chuyen()
        {
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            DataTable tbl = new DataTable();
            tbl = oGDTBL.Get_DV_tu_LoaianID(ddlLoaiAn.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "");
            DataRow row = tbl.NewRow();
            String donvi_ = "";
            donvi_ = tbl.Rows[0]["PHONGBAN_ID"] + "";
            ddlChuyendenDV.SelectedValue = donvi_;
            if (ddlHinhthucdon.SelectedValue == "5")
            {
                ddlChuyendenDV_VB.SelectedValue = donvi_;
            }
        }
        private void ChangeLoaiCV()
        {
            lstNguoiguiTitle.Text = "Người gửi/Đơn vị gửi";
            lblTraigiamhientai.Text = "Trại giam hiện tại (nếu thay đổi)";
            if (pnCongvan.Visible)
            {
                decimal IDLoai = Convert.ToDecimal(ddlLoaiCongVan.SelectedValue);
                DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();
                pnCongVanNhacLai.Visible = false;
                if (oLoai.MA == ENUM_GDT_LOAICV.CV8_1_DBQH)// công văn của đại biểu quốc hội
                {
                    chkIsTrongNganh.Checked = false;
                    chkIsTrongNganh.Visible = false;
                    chkIsTrongNganh_CheckedChanged(null, null);
                    // chkTraigiam.Visible = false;
                    lstNguoiguiTitle.Text = "Tên Đại biểu";
                    lblTraigiamhientai.Text = "Đơn vị(Khóa?,Đoàn Đại biểu?)";
                    lblTraigiamhientai.Visible = true;
                    txtTraigiamhientai.Visible = true;
                    pnDonViGuiNgoaiNganh.Visible = true;
                    pnDonViGuiTrongNganh.Visible = false;
                }
                else if (oLoai.MA == ENUM_GDT_LOAICV.NHACLAI)// Công văn nhắc lại
                {
                    chkIsTrongNganh.Visible = true;
                    // chkTraigiam.Visible = true;
                    lblTraigiamhientai.Visible = false;
                    txtTraigiamhientai.Visible = false;
                    pnCongVanNhacLai.Visible = true;
                }
                else
                {
                    chkIsTrongNganh.Visible = true;
                    // chkTraigiam.Visible = true;
                    lblTraigiamhientai.Visible = false;
                    txtTraigiamhientai.Visible = false;
                }
            }
        }
        protected void ddlLoaiCongVan_SelectedIndexChanged(object sender, EventArgs e)
        {
            ChangeLoaiCV();
            Cls_Comon.SetFocus(this, this.GetType(), ddlLoaiCongVan.ClientID);
        }
        protected void ddlTraloi_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlTraloi.SelectedValue == "1")
                pnCV_traloi.Visible = true;
            else
                pnCV_traloi.Visible = false;
            Cls_Comon.SetFocus(this, this.GetType(), ddlTraloi.ClientID);
        }

        public void showHideddlGioitinhByDungdonla()
        {
            try
            {
                if (ddlDungdonla.SelectedValue == "3")
                {
                    ddlGioitinh.Visible = false;
                    lbl_Gioitinh.Visible = false;
                }

                else
                {
                    lbl_Gioitinh.Visible = true;
                    ddlGioitinh.Visible = true;
                }

            }
            catch
            {


            }

        }
        protected void ddlDungdonla_SelectedIndexChanged(object sender, EventArgs e)
        {
            showHideddlGioitinhByDungdonla();
            Cls_Comon.SetFocus(this, this.GetType(), ddlDungdonla.ClientID);
        }

        protected void ddlTrangthaidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Ngay xu ly don là ngay hệ thống
            if (hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.CD_TA_TRANGTHAI != Convert.ToDecimal(ddlTrangthaidon.SelectedValue))
                    txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }

            if (ddlTrangthaidon.SelectedValue == "0")
            {
                lblLydoCDDK.Text = "Thụ lý đơn";
                chkLydoCDDK.Visible = false;
                rdbThuLy.Visible = true;
                //----19/11/2024
                if (rdbThuLy.SelectedValue == "1")
                    pnThuLy.Visible = true;
                else
                    pnThuLy.Visible = false;
                //trTuHinh.Visible = true;
                trLydokhac.Visible = false;
                LoaiAnChange();
                spSOBA.Visible = true;
                spNGBA.Visible = true;
                spTOAXX.Visible = true;
            }
            else
            {
                lblLydoCDDK.Text = "Lý do";
                chkLydoCDDK.Visible = true;
                rdbThuLy.Visible = false;
                pnThuLy.Visible = false;
                //trTuHinh.Visible = false;
                spSOBA.Visible = false;
                spNGBA.Visible = false;
                spTOAXX.Visible = false;
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlTrangthaidon.ClientID);
        }

        private void LoadLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            if (!string.IsNullOrEmpty(ddlChuyendenDV.SelectedValue))
            {
                decimal vPBID = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
                DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == vPBID).OrderBy(x => x.THUTU).FirstOrDefault();
                if (obj.ISHINHSU == 1) ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            }
            string current_id = Request["ID"] + "";
            if (!string.IsNullOrEmpty(Request["ID"]) && ddlLoaiAn.SelectedValue == "0")
            {
                decimal vID = Convert.ToDecimal(current_id);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == vID).FirstOrDefault();
                if (oT.BAQD_LOAIAN != null)
                    ddlLoaiAn.SelectedValue = "0" + oT.BAQD_LOAIAN.ToString();
                load_lable_ba_qd();
            }
            //lay so thu ly moi theo loai an
            TL_GETMAXTT();
            //---------------
            if (current_id != "")
            {
                string strType = Request["type"] + "";
                decimal ID = Convert.ToDecimal(current_id);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (strType == "dontrung")
                {
                    if (ddlLoaiAn.Items.FindByValue("0" + oT.BAQD_LOAIAN) == null)
                    {
                        if (oT.BAQD_LOAIAN == 1) ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                        if (oT.BAQD_LOAIAN == 2) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                        if (oT.BAQD_LOAIAN == 6) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                        if (oT.BAQD_LOAIAN == 3) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                        if (oT.BAQD_LOAIAN == 4) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                        if (oT.BAQD_LOAIAN == 5) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                        if (oT.BAQD_LOAIAN == 7) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
                    }
                    if (ddlLoaiAn.Items.FindByValue("0" + oT.BAQD_LOAIAN) != null)
                    {
                        ddlLoaiAn.SelectedValue = "0" + oT.BAQD_LOAIAN;
                    }
                }
            }

        }
        private void ChuyendenDVChange(decimal IS_IDPhongBan)
        {
            //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
            bool isToaCapTinh = false;
            List<DM_TOAAN> lstToaancaptinh = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPTINH") && x.HIEULUC == 1).ToList();
            List<DM_TOAAN> lstToaancapcao = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPCAO") && x.HIEULUC == 1).ToList();

            foreach (DataGridItem item in dgTBTLD.Items)
            {
                DropDownList ddlToaAn = (DropDownList)item.FindControl("ddlToaAn");
                foreach (DM_TOAAN item1 in lstToaancaptinh)
                {
                    if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item1.ID)
                    {
                        isToaCapTinh = true;
                    }
                }
                foreach (DM_TOAAN item2 in lstToaancapcao)
                {
                    if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item2.ID)
                    {
                        isToaCapTinh = false;
                    }
                }
            }

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal ToaAXXID = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            bool isTPB3 = false;
            decimal idPB = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            if (oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", idPB).Rows.Count > 0)
            {
                isTPB3 = true;
            }
            lblalert.Text = "";
            lblThamquyen.Visible = false;
            try
            {
                bool checkLoaiThamQuyen = true;
                string current_id = Request["ID"] + "";
                if (current_id != "" && current_id != "0")
                {
                    decimal ID = Convert.ToDecimal(current_id);
                    GDTTT_DON don = dt.GDTTT_DON.FirstOrDefault(x => x.ID == ID);
                    if (don != null || (don.THAMPHANID != null && don.THAMPHANID > 0)) checkLoaiThamQuyen = false;
                }

                //đã phân công thẩm phán thì không gợi ý loại thẩm quyền đơn nữa
                if (checkLoaiThamQuyen)
                {
                    DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == ToaAXXID).Single();
                    if ((obj.LOAITOA == "CAPTINH" & !chkKN_TBTLD.Checked & isTPB3) || ((obj.LOAITOA == "CAPHUYEN" || obj.LOAITOA == "QSKHUVUC") & chkKN_TBTLD.Checked & isToaCapTinh & isTPB3))
                    {
                        rdbThamquyen.SelectedValue = "1";
                        lblThamquyen.Text = "Dựa trên thông tin đơn, đây là đơn dành cho thẩm phán bậc 3";
                        lblThamquyen.Visible = true;
                        
                        List_thamphan.Visible = true;
                        LoadThamphan_Tongan();
                    }
                    else
                    {
                        rdbThamquyen.SelectedValue = "0";
                        lblThamquyen.Text = "Dựa trên thông tin đơn, đây là đơn dành cho thẩm phán tối cao";
                        lblThamquyen.Visible = true;

                        List_thamphan.Visible = false;
                    }
                }
            }
            catch (Exception ex) { }

            if (string.IsNullOrEmpty(ddlChuyendenDV.SelectedValue))
            {
                decimal IDPhongBan = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
                DM_PHONGBAN oPB = new DM_PHONGBAN();
                if (IS_IDPhongBan == 0)
                {
                    oPB = dt.DM_PHONGBAN.Where(x => x.ID == IDPhongBan && x.HIEULUC == 1).OrderBy(x => x.THUTU).FirstOrDefault();
                }
                else
                {
                    oPB = dt.DM_PHONGBAN.Where(x => x.ID == IS_IDPhongBan && x.HIEULUC == 1).OrderBy(x => x.THUTU).FirstOrDefault();
                }
                if (oPB.ISGIAIQUYETDON == 1)
                {
                    if (ddlHinhthucdon.SelectedValue != "8" && ddlHinhthucdon.SelectedValue != "10")//----23/06/2025
                    {
                        trTrangthaidon.Visible = true;
                        pnBAQDGDT.Visible = true;
                        pnKNTCDoituong.Visible = false;

                        ddlLoaiAn.Visible = true;
                        chkGDTIsKNTC.Visible = true;
                        lblLoaiAn.Visible = true;
                        if (ddlTrangthaidon.SelectedValue == "0" && rdbThuLy.SelectedValue == "1")
                            pnThuLy.Visible = true;
                        else
                            pnThuLy.Visible = false;
                    }
                }
                else
                {
                    pnThuLy.Visible = false;
                    trTrangthaidon.Visible = false;
                    pnBAQDGDT.Visible = false;
                    pnKNTCDoituong.Visible = true;

                    ddlLoaiAn.Visible = false;
                    chkGDTIsKNTC.Visible = false;
                    lblLoaiAn.Visible = false;
                }
                LoaiAnChange();
            }
        }
        protected void ddlChuyendenDV_SelectedIndexChanged(object sender, EventArgs e)
        {//Ngay xu ly don là ngay hệ thống
            if (hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.CD_TA_DONVIID != Convert.ToDecimal(ddlChuyendenDV.SelectedValue))
                    txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }
            ChuyendenDVChange(0);
            LoadLoaiAn();
            Cls_Comon.SetFocus(this, this.GetType(), ddlChuyendenDV.ClientID);
            //--------------------
            Check_Nguoi_KN_LoaiAn();
            ///--------
            Load_NKN_BC();

            //if (ddlLoaiAn.SelectedValue != "01")
            //{
            //    Create_NguyenDonBD();
            //}
            LoadIsTuHinh(ddlLoaiAn.SelectedValue);
            //if (Session["DONID_CC"] + "" != "" || Session["VUVIECID_CC"] + "" != "")
            //{
            //    if (ddlLoaiAn.SelectedValue == "01")
            //    {
            //        LoadDropNguoiKhieuNai();
            //        LoadDropBiCao();
            //        LoadDanhSachBiCao();
            //    }
            //    else
            //    {
            //        LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            //        LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
            //        LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            //        //-----------------------------
            //    }
            //}

            //Hien thi Tham phan giai quyet voi don KNTP
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal v_chucdanh = 486;//TPTATC
            //Chi áp dung với TANDTC
            if (LoginDonViID == 1)
            {
                if (ddlChuyendenDV.SelectedValue == "102")
                {
                    dropTPTC.Visible = true;
                    LoadAllHoiDongTP(v_chucdanh, LoginDonViID);
                }
                else
                {
                    dropTPTC.Visible = false;
                    dropTPTC.SelectedValue = "0";
                }
            }
            else { dropTPTC.Visible = false; }




        }
        private void setLoaichuyen()
        {//Ngay xu ly don là ngay hệ thống
            if (hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.CD_LOAI != Convert.ToDecimal(rdbLoaichuyen.SelectedValue))
                    txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }

            spSOBA.Visible = spSOKN.Visible = spTOAXX.Visible = spNGBA.Visible = spNGKN.Visible = false;
            pnNoibo_vb.Visible = false;
            switch (rdbLoaichuyen.SelectedValue)
            {
                case "0":
                    spSOBA.Visible = spSOKN.Visible = spTOAXX.Visible = spNGBA.Visible = spNGKN.Visible = true;
                    pnToakhac.Visible = false;
                    pnNgoaitoaan.Visible = false;
                    pnTralaidon.Visible = false;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    decimal IDPhongBan = 0;
                    if (ddlHinhthucdon.SelectedValue == "5")
                    {
                        pnNoibo.Visible = false;
                        IDPhongBan = Convert.ToDecimal(ddlChuyendenDV_VB.SelectedValue);
                        pnNoibo_vb.Visible = true;
                        spSOBA.Visible = false; spNGBA.Visible = false; spTOAXX.Visible = false;
                    }
                    else
                    {
                        pnNoibo.Visible = true;
                        IDPhongBan = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
                        pnNoibo_vb.Visible = false;
                        spSOBA.Visible = true; spNGBA.Visible = true; spTOAXX.Visible = true;
                    }
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == IDPhongBan).OrderBy(x => x.THUTU).FirstOrDefault();
                    if (oPB.ISGIAIQUYETDON == 1)
                    {

                        trTrangthaidon.Visible = true;
                        pnBAQDGDT.Visible = true;
                        pnKNTCDoituong.Visible = false;

                        ddlLoaiAn.Visible = true;
                        chkGDTIsKNTC.Visible = true;
                        lblLoaiAn.Visible = true;
                        if (ddlTrangthaidon.SelectedValue == "0")
                        {
                            if (rdbThuLy.SelectedValue != "2")
                                pnThuLy.Visible = true;
                            else
                                pnThuLy.Visible = false;
                        }
                        else
                            pnThuLy.Visible = false;
                    }
                    else
                    {
                        pnThuLy.Visible = false;
                        trTrangthaidon.Visible = false;
                        pnBAQDGDT.Visible = false;
                        pnKNTCDoituong.Visible = true;

                        ddlLoaiAn.Visible = false;
                        chkGDTIsKNTC.Visible = false;
                        lblLoaiAn.Visible = false;
                    }
                    if (ddlHinhthucdon.SelectedValue != "5" && ddlHinhthucdon.SelectedValue != "8" && ddlHinhthucdon.SelectedValue != "10")
                    {
                        KN_BiCao.Style.Remove("Display");
                    }
                    break;
                case "1":
                    pnNoibo.Visible = false;
                    pnToakhac.Visible = true;
                    pnNgoaitoaan.Visible = false;
                    pnTralaidon.Visible = false;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    lblLoaiAn.Visible = true;
                    chkGDTIsKNTC.Visible = true;
                    KN_BiCao.Style.Add("Display", "none");
                    break;
                case "2":
                    pnNoibo.Visible = false;
                    pnToakhac.Visible = false;
                    pnNgoaitoaan.Visible = true;
                    pnTralaidon.Visible = false;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    chkGDTIsKNTC.Visible = true;
                    KN_BiCao.Style.Add("Display", "none");
                    break;
                case "3":
                    pnNoibo.Visible = false;
                    pnToakhac.Visible = false;
                    pnNgoaitoaan.Visible = false;
                    pnTralaidon.Visible = true;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    chkGDTIsKNTC.Visible = true;
                    KN_BiCao.Style.Add("Display", "none");
                    break;
                default:
                    pnNoibo.Visible = false;
                    pnToakhac.Visible = false;
                    pnNgoaitoaan.Visible = false;
                    pnTralaidon.Visible = false;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    chkGDTIsKNTC.Visible = true;
                    KN_BiCao.Style.Add("Display", "none");
                    break;
            }
        }
        protected void rdbLoaichuyen_SelectedIndexChanged(object sender, EventArgs e)
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = 0;
            if (strPBID != "") PBID = Convert.ToDecimal(strPBID);
            //kiem tra neu van ban da co so thì phai xóa đi mơi được chọn lại nơi chuyển
            if (hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                //Neu Nơi nhận đã lưu khác với nơi nhận mơi
                if (oT.CD_LOAI != Convert.ToDecimal(rdbLoaichuyen.SelectedValue) && oT.CD_LOAI != 4)
                {
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    string vLoaiso, vTenSo = "";
                    if (oT.CD_LOAI == 0)
                    {
                        vLoaiso = "SoCVC";
                        vTenSo = "Sổ Văn bản nội bộ";
                    }
                    else if (oT.CD_LOAI == 3)
                    {
                        vLoaiso = "SoTralaidon";
                        vTenSo = "Sổ Văn bản Trả lại đơn";
                    }
                    else if (oT.CD_LOAI == 1)
                    {
                        vLoaiso = "SoCVCTK";
                        vTenSo = "Sổ Văn bản Chuyển Tòa khác";
                    }
                    else
                    {
                        vLoaiso = "SoCVCN";
                        vTenSo = "Sổ Văn bản Chuyển ngoài Tòa";
                    }

                    if (oBL.CHECK_SOVB_DON("SoGXN", Convert.ToDecimal(oT.TOAANID), PBID, ID) > 0)
                    {
                        string strMsg = "Bạn phải xóa số văn bản trong Sổ Giấy xác nhận đã cấp cho đơn này mới chuyển được nơi chuyển mới";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        rdbLoaichuyen.SelectedValue = oT.CD_LOAI + "";
                    }
                    else if (oBL.CHECK_SOVB_DON("SoGXN_DV", Convert.ToDecimal(oT.TOAANID), PBID, ID) > 0)
                    {
                        string strMsg = "Bạn phải xóa số văn bản trong Sổ Giấy xác nhận đơn vị đã cấp cho đơn này mới chuyển được nơi chuyển mới";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        rdbLoaichuyen.SelectedValue = oT.CD_LOAI + "";
                    }
                    else
                    {
                        if (oBL.CHECK_SOVB_DON(vLoaiso, Convert.ToDecimal(oT.TOAANID), PBID, ID) > 0)
                        {
                            string strMsg = "Bạn phải xóa số văn bản trong " + vTenSo + " đã cấp cho đơn này mới chuyển được nơi chuyển mới";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            rdbLoaichuyen.SelectedValue = oT.CD_LOAI + "";
                        }
                        else
                        {
                            setLoaichuyen();
                            rdbLoaichuyen.Focus();

                            if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
                            {
                                pnToaanXX.Visible = false;
                                pnBAQDGDT.Visible = false;
                                pnKNTCDoituong.Visible = true;
                            }
                            else
                            {
                                pnToaanXX.Visible = true;
                                pnBAQDGDT.Visible = true;
                                pnKNTCDoituong.Visible = false;
                            }
                        }
                    }

                }
                else
                {
                    setLoaichuyen();
                    rdbLoaichuyen.Focus();

                    if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
                    {
                        pnToaanXX.Visible = false;
                        pnBAQDGDT.Visible = false;
                        pnKNTCDoituong.Visible = true;
                    }
                    else
                    {
                        pnToaanXX.Visible = true;
                        pnBAQDGDT.Visible = true;
                        pnKNTCDoituong.Visible = false;
                    }
                }

            }
            else
            {
                setLoaichuyen();
                rdbLoaichuyen.Focus();

                if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
                {
                    pnToaanXX.Visible = false;
                    pnBAQDGDT.Visible = false;
                    pnKNTCDoituong.Visible = true;
                }
                else
                {
                    pnToaanXX.Visible = true;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                }
            }







        }

        protected void ddlLydotralai_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadInfoTradon();
            Cls_Comon.SetFocus(this, this.GetType(), ddlLydotralai.ClientID);
        }

        protected void cmdDanhsach_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsachdon_cc.aspx");
        }

        protected void chkLydoCDDK_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (chkLydoCDDK.Items[2].Selected)
                trLydokhac.Visible = true;
            else
                trLydokhac.Visible = false;
            Cls_Comon.SetFocus(this, this.GetType(), chkLydoCDDK.ClientID);

        }

        protected void chkIsCongVan_CheckedChanged(object sender, EventArgs e)
        {
            ddlHinhthucdon.SelectedValue = "3";
            ddlHinhthucdonChange();

            chkIsCongVan.Visible = false;
            Cls_Comon.SetFocus(this, this.GetType(), ddlCAChidao.ClientID);
        }
        private void SaveDonKemTheo()
        {
            decimal ID = Convert.ToDecimal(hddID.Value);
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
            GDTTT_DON_BL dsBL = new GDTTT_DON_BL();
            string str_ID = "";
            foreach (DataGridItem item in dgListDontrung.Items)
            {

                TextBox txtSohieudon = (TextBox)item.FindControl("txtSohieudon");
                TextBox txtNgaynhandon = (TextBox)item.FindControl("txtNgaynhandon");
                TextBox txtNgayghitrendon = (TextBox)item.FindControl("txtNgayghitrendon");
                DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgaynhandon.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgaynhandon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime dNgaytrendon = (String.IsNullOrEmpty(txtNgayghitrendon.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayghitrendon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                string strTT = item.Cells[0].Text;
                str_ID = item.Cells[1].Text;
                CheckBox chkIsCV = (CheckBox)item.FindControl("chkIsCV");
                TextBox txtSoCV = (TextBox)item.FindControl("txtSoCV");
                TextBox txtNgayCV = (TextBox)item.FindControl("txtNgayCV");
                CheckBox chkIsTrongnganh = (CheckBox)item.FindControl("chkIsTrongnganh");
                TextBox txtDontrung_Donvi = (TextBox)item.FindControl("txtDontrung_Donvi");
                DropDownList ddlDontrung_Donvi = (DropDownList)item.FindControl("ddlDontrung_Donvi");
                TextBox txtDontrung_Nguoiky = (TextBox)item.FindControl("txtDontrung_Nguoiky");
                TextBox txtDontrung_Chucvu = (TextBox)item.FindControl("txtDontrung_Chucvu");

                if (dNgayNhan != DateTime.MinValue)// && dNgaytrendon != DateTime.MinValue
                {
                    GDTTT_DON obj = new GDTTT_DON();
                    Decimal _ID = 0;
                    if (str_ID != "" && str_ID != "&nbsp;") //04-07-2024 sửa thông tin
                    {
                        _ID = Convert.ToDecimal(str_ID);
                        obj = dt.GDTTT_DON.Where(x => x.ID == _ID).FirstOrDefault();
                        oDon = dt.GDTTT_DON.Where(x => x.ID == _ID).FirstOrDefault();
                    }
                    obj.TOAANID = oDon.TOAANID;

                    obj.BAQD_LOAIAN = oDon.BAQD_LOAIAN;
                    obj.BAQD_LOAIQDBA = oDon.BAQD_LOAIQDBA;
                    obj.VUVIECID = oDon.VUVIECID;
                    obj.BAQD_CAPXETXU = oDon.BAQD_CAPXETXU;

                    obj.BAQD_SO = oDon.BAQD_SO;
                    obj.BAQD_NGAYBA = oDon.BAQD_NGAYBA;
                    obj.BAQD_TOAANID = oDon.BAQD_TOAANID;

                    obj.BAQD_SO_PT = oDon.BAQD_SO_PT;
                    obj.BAQD_NGAYBA_PT = oDon.BAQD_NGAYBA_PT;
                    obj.BAQD_TOAANID_PT = oDon.BAQD_TOAANID_PT;

                    obj.BAQD_SO_ST = oDon.BAQD_SO_ST;
                    obj.BAQD_NGAYBA_ST = oDon.BAQD_NGAYBA_ST;
                    obj.BAQD_TOAANID_ST = oDon.BAQD_TOAANID_ST;


                    obj.KN_LOAI = oDon.KN_LOAI;
                    obj.KN_SOQD = oDon.KN_SOQD;
                    obj.KN_NGAY = oDon.KN_NGAY;
                    obj.LOAIDON = oDon.LOAIDON;

                    obj.NGAYNHANDON = dNgayNhan;
                    obj.NGAYGHITRENDON = dNgaytrendon;
                    obj.SOHIEUDON = txtSohieudon.Text;
                    obj.DUNGDONLA = oDon.DUNGDONLA;
                    obj.NGUOIGUI_HOTEN = oDon.NGUOIGUI_HOTEN;
                    obj.NGUOIGUI_GIOITINH = oDon.NGUOIGUI_GIOITINH;
                    obj.NGUOIGUI_CMND = oDon.NGUOIGUI_CMND;
                    obj.NGUOIGUI_TINHID = oDon.NGUOIGUI_TINHID;
                    obj.NGUOIGUI_HUYENID = oDon.NGUOIGUI_HUYENID;
                    obj.NGUOIGUI_DIACHI = oDon.NGUOIGUI_DIACHI;
                    obj.NGUOIGUI_DIENTHOAI = oDon.NGUOIGUI_DIENTHOAI;
                    obj.NGUOIGUI_EMAIL = oDon.NGUOIGUI_EMAIL;
                    obj.NGUOIGUI_TUCACHTOTUNG = oDon.NGUOIGUI_TUCACHTOTUNG;
                    obj.DONGKHIEUNAI = obj.NGUOIGUI_HOTEN;

                    obj.NOIDUNGDON = oDon.NOIDUNGDON;
                    obj.SOLUONGDON = 1;
                    obj.SOTHUTUDON = oDon.SOTHUTUDON;


                    obj.PHANLOAIXULY = 3;
                    obj.TRALOIDON = oDon.TRALOIDON;
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.NGAYTAO = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.NGAYSUA = DateTime.Now;
                    obj.TT = dsBL.GETNEWTT((decimal)obj.TOAANID);
                    obj.MADON = ENUM_LOAIVUVIEC.AN_GDTTT + Session[ENUM_SESSION.SESSION_MADONVI] + obj.TT.ToString();


                    obj.MAGIAIDOAN = oDon.MAGIAIDOAN;
                    obj.LOAICONGVAN = oDon.LOAICONGVAN;
                    obj.DONVIUUTIEN = oDon.DONVIUUTIEN;
                    obj.NGUOIKHANGNGHI = oDon.NGUOIKHANGNGHI;
                    obj.CV_NHACLAIID = oDon.CV_NHACLAIID;

                    obj.ISCHUYENXULY = oDon.ISCHUYENXULY;
                    obj.DONVIXULYID = oDon.DONVIXULYID;
                    obj.CV_NHACLAITEXT = oDon.CV_NHACLAITEXT;
                    obj.DONTRUNGTEXT = oDon.DONTRUNGTEXT;
                    obj.CV_TRALOI_SO = oDon.CV_TRALOI_SO;
                    obj.CV_TRALOI_NGAY = oDon.CV_TRALOI_NGAY;
                    obj.CV_TRALOI_NOIDUNG = oDon.CV_TRALOI_NOIDUNG;
                    obj.CD_LOAI = oDon.CD_LOAI;
                    obj.CD_TA_DONVIID = oDon.CD_TA_DONVIID;
                    obj.CD_TA_TRANGTHAI = oDon.CD_TA_TRANGTHAI;
                    obj.CD_TA_LYDO_ISBAQD = oDon.CD_TA_LYDO_ISBAQD;
                    obj.CD_TA_LYDO_ISXACNHAN = oDon.CD_TA_LYDO_ISXACNHAN;
                    obj.CD_TA_LYDO_ISKHAC = oDon.CD_TA_LYDO_ISKHAC;

                    obj.CD_TK_DONVIID = oDon.CD_TK_DONVIID;
                    obj.CD_TK_NOIGUI = oDon.CD_TK_NOIGUI;
                    obj.CD_NTA_TENDONVI = oDon.CD_NTA_TENDONVI;
                    obj.CD_TRALAI_LYDOID = oDon.CD_TRALAI_LYDOID;
                    obj.CD_TRALAI_YEUCAU = oDon.CD_TRALAI_YEUCAU;
                    obj.CD_TRALAI_SOPHIEU = oDon.CD_TRALAI_SOPHIEU;
                    obj.CD_TRALAI_NGAYTRA = oDon.CD_TRALAI_NGAYTRA;
                    obj.CD_TRANGTHAI = 0;

                    obj.GHICHU = oDon.GHICHU;
                    obj.TRANGTHAIDON = 0;
                    obj.ISTHULY = null;
                    obj.TL_SO = oDon.TL_SO;
                    obj.TL_NGAY = oDon.TL_NGAY;
                    obj.TL_NGUOI = oDon.TL_NGUOI;
                    obj.THAMPHANID = oDon.THAMPHANID;
                    obj.CD_NGUOIKY = oDon.CD_NGUOIKY;
                    obj.NOIDUNGTOMTAT = oDon.NOIDUNGTOMTAT;
                    obj.ISSHOWFULL = oDon.ISSHOWFULL;

                    obj.CD_TRALAI_LYDOKHAC = oDon.CD_TRALAI_LYDOKHAC;
                    obj.CD_TA_LYDO_KHAC = oDon.CD_TA_LYDO_KHAC;
                    if (chkIsCV.Checked)
                    {
                        obj.LOAIDON = 3;
                        obj.CV_SO = txtSoCV.Text;
                        DateTime dNgayCV = (String.IsNullOrEmpty(txtNgayCV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        obj.CV_NGAY = dNgayCV;
                        if (chkIsTrongnganh.Checked)
                        {
                            obj.CV_ISTRONGNGANH = 1;
                            obj.CV_TOAANID = Convert.ToDecimal(ddlDontrung_Donvi.SelectedValue);
                            obj.CV_TENDONVI = ddlDontrung_Donvi.SelectedItem.Text;
                            obj.CV_NHACLAIID = 4;
                        }
                        else
                        {
                            obj.CV_ISTRONGNGANH = 0;
                            obj.CV_TENDONVI = txtDontrung_Donvi.Text;
                        }
                    }
                    else
                    {
                        obj.LOAIDON = 1;
                        obj.CV_SO = "";
                        txtNgayCV.Text = "";
                        DateTime dNgayCV = (String.IsNullOrEmpty(txtNgayCV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        obj.CV_NGAY = dNgayCV;
                        if (chkIsTrongnganh.Checked)
                        {
                            obj.CV_ISTRONGNGANH = 0;
                            obj.CV_TOAANID = 0;
                            obj.CV_TENDONVI = "";
                            obj.CV_NHACLAIID = 0;
                        }
                        else
                        {
                            obj.CV_ISTRONGNGANH = 0;
                            obj.CV_TENDONVI = "";
                        }

                    }
                    if (str_ID == "" || str_ID == "&nbsp;")//04-07-2024 sửa thông tin
                    {
                        dt.GDTTT_DON.Add(obj);
                        oDon.SOLUONGDON = 1;
                        dt.SaveChanges();
                        //-------add 25/03/2024
                        //đơn kèm theo
                        dsBL.ARR_DONTRUNGID_UP(hddID.Value, Convert.ToString(obj.ID), "3", "", rdbLoaichuyen.SelectedValue);
                        //---------------------------
                        if (obj.BAQD_LOAIAN == 1)
                        {
                            ADD_BICAO_DON_FROM_DON(obj.ID, Convert.ToDecimal(hddID.Value));
                        }
                        else
                        {
                            ADD_DUONGSU_DON_FROM_DON(obj.ID, Convert.ToDecimal(hddID.Value));
                        }
                    }
                    dt.SaveChanges();
                    //23/07/2024
                    //check lại xem DONTRUNGID, arr_don_id có bị null hay không
                    GDTTT_DON otc = dt.GDTTT_DON.Where(x => x.ID == obj.ID).FirstOrDefault();
                    if (Convert.ToString(otc.DONTRUNGID) == "" || Convert.ToString(otc.DONTRUNGID) == null)
                    {
                        otc.DONTRUNGID = 0;
                        if (Convert.ToString(otc.ARR_DON_ID) != "" && Convert.ToString(otc.ARR_DON_ID) != null)
                        {
                            if (otc.ARR_DON_ID > 0)
                            {
                                otc.DONTRUNGID = otc.ARR_DON_ID;
                            }
                        }
                    }
                    if (Convert.ToString(otc.ARR_DON_ID) == "" || Convert.ToString(otc.ARR_DON_ID) == null)
                    {
                        otc.ARR_DON_ID = 0;
                    }
                    dt.SaveChanges();
                    /////
                    Check_BC_NKN();
                    //---check DONGKHIEUNAI
                    Dongkhieunai_Check_Update(hddID.Value, obj.ID);
                }
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                oBL.UPDATESOLUONGDON(ID);
            }
        }
        private void getTable()
        {
            int SL = 0; int SL_ONE = 0;
            if (ddlSoLuong.SelectedValue != "0")
            {
                SL = Convert.ToInt32(ddlSoLuong.SelectedValue);
            }
            //05/06/2020
            //lấy các giá trị đã nhập trước đó đổ vào một bảng tạm
            tbl_temp.Columns.Add("TT");
            tbl_temp.Columns.Add("ID");
            tbl_temp.Columns.Add("SOHIEUDON");
            tbl_temp.Columns.Add("NGAYNHANDON");
            tbl_temp.Columns.Add("NGAYGHIDON");
            tbl_temp.Columns.Add("HINHTHUCDON");
            tbl_temp.Columns.Add("SOCV");
            tbl_temp.Columns.Add("NGAYCV");
            tbl_temp.Columns.Add("LOAIDONVI");
            tbl_temp.Columns.Add("DONVIGUI");
            tbl_temp.Columns.Add("DONVIGUI_TEXT");
            tbl_temp.Columns.Add("CV_NGUOIKY");
            tbl_temp.Columns.Add("CV_CHUCVU");
            tbl_temp.AcceptChanges();
            //--Đổ tất cả các dữ liệu đã có vào bảng tạm để khi có sự kiện sẽ đổ lại cho table hiển thị
            foreach (DataGridItem Item in dgListDontrung.Items)
            {
                TextBox txtSohieudon = (TextBox)Item.FindControl("txtSohieudon");
                TextBox txtNgaynhandon = (TextBox)Item.FindControl("txtNgaynhandon");
                TextBox txtNgayghitrendon = (TextBox)Item.FindControl("txtNgayghitrendon");
                CheckBox chkIsCV = (CheckBox)Item.FindControl("chkIsCV");
                TextBox txtSoCV = (TextBox)Item.FindControl("txtSoCV");
                TextBox txtNgayCV = (TextBox)Item.FindControl("txtNgayCV");
                CheckBox chkIsTrongnganh = (CheckBox)Item.FindControl("chkIsTrongnganh");
                DropDownList ddlDontrung_Donvi = (DropDownList)Item.FindControl("ddlDontrung_Donvi");
                TextBox txtDontrung_Donvi = (TextBox)Item.FindControl("txtDontrung_Donvi");
                TextBox txtDontrung_Nguoiky = (TextBox)Item.FindControl("txtDontrung_Nguoiky");
                TextBox txtDontrung_Chucvu = (TextBox)Item.FindControl("txtDontrung_Chucvu");
                DataRow r_tpm = tbl_temp.NewRow();
                r_tpm["TT"] = Item.Cells[0].Text;
                r_tpm["ID"] = Item.Cells[1].Text;
                r_tpm["SOHIEUDON"] = txtSohieudon.Text;
                r_tpm["NGAYNHANDON"] = txtNgaynhandon.Text;
                r_tpm["NGAYGHIDON"] = txtNgayghitrendon.Text;
                r_tpm["HINHTHUCDON"] = Convert.ToString(Convert.ToInt32(chkIsCV.Checked));
                r_tpm["SOCV"] = txtSoCV.Text;
                r_tpm["NGAYCV"] = txtNgayCV.Text;
                r_tpm["LOAIDONVI"] = Convert.ToString(Convert.ToInt32(chkIsTrongnganh.Checked));
                r_tpm["DONVIGUI"] = ddlDontrung_Donvi.SelectedValue;
                r_tpm["DONVIGUI_TEXT"] = txtDontrung_Donvi.Text;
                r_tpm["CV_NGUOIKY"] = txtDontrung_Nguoiky.Text;
                r_tpm["CV_CHUCVU"] = txtDontrung_Chucvu.Text;
                tbl_temp.Rows.Add(r_tpm);
            }
            tbl_temp.AcceptChanges();

            DataTable obj = new DataTable();
            obj.Columns.Add("TT");
            obj.Columns.Add("ID");
            obj.Columns.Add("SOHIEUDON");
            obj.Columns.Add("NGAYNHANDON");
            obj.Columns.Add("NGAYGHIDON");
            obj.Columns.Add("HINHTHUCDON");
            obj.Columns.Add("SOCV");
            obj.Columns.Add("NGAYCV");
            obj.Columns.Add("LOAIDONVI");
            obj.Columns.Add("DONVIGUI");
            obj.Columns.Add("DONVIGUI_TEXT");
            obj.Columns.Add("CV_NGUOIKY");
            obj.Columns.Add("CV_CHUCVU");
            obj.AcceptChanges();

            if (tbl_temp != null && tbl_temp.Rows.Count > 0)//04/07/2024 sửa thông tin
            {
                for (int i = 0; i <= tbl_temp.Rows.Count - 1; i++)
                {
                    DataRow r = obj.NewRow();
                    r["TT"] = tbl_temp.Rows[i]["TT"] + "";
                    r["ID"] = tbl_temp.Rows[i]["ID"] + "";
                    r["SOHIEUDON"] = tbl_temp.Rows[i]["SOHIEUDON"] + "";
                    r["NGAYNHANDON"] = tbl_temp.Rows[i]["NGAYNHANDON"] + "";
                    r["NGAYGHIDON"] = tbl_temp.Rows[i]["NGAYGHIDON"] + "";
                    r["HINHTHUCDON"] = tbl_temp.Rows[i]["HINHTHUCDON"] + "";
                    r["SOCV"] = tbl_temp.Rows[i]["SOCV"] + "";
                    r["NGAYCV"] = tbl_temp.Rows[i]["NGAYCV"] + "";
                    r["HINHTHUCDON"] = tbl_temp.Rows[i]["HINHTHUCDON"] + "";
                    r["LOAIDONVI"] = tbl_temp.Rows[i]["LOAIDONVI"] + "";
                    r["DONVIGUI"] = tbl_temp.Rows[i]["DONVIGUI"] + "";
                    r["DONVIGUI_TEXT"] = tbl_temp.Rows[i]["DONVIGUI_TEXT"] + "";
                    r["CV_NGUOIKY"] = tbl_temp.Rows[i]["CV_NGUOIKY"] + "";
                    r["CV_CHUCVU"] = tbl_temp.Rows[i]["CV_CHUCVU"] + "";
                    obj.Rows.Add(r);
                }
            }
            if (SL > tbl_temp.Rows.Count)
            {
                SL_ONE = SL - tbl_temp.Rows.Count;
                Int32 stt_ = tbl_temp.Rows.Count;
                for (int i = 0; i <= SL_ONE - 1; i++)
                {
                    stt_ += 1;
                    DataRow r = obj.NewRow();
                    r["TT"] = stt_.ToString();
                    r["ID"] = "";
                    r["HINHTHUCDON"] = "0";
                    r["LOAIDONVI"] = "0";
                    obj.Rows.Add(r);
                }
            }
            /////04/07/2024
            //tbl_temp.DefaultView.Sort = "TT DESC";
            //DataTable tbl_temp_s = new DataTable();
            //tbl_temp_s = tbl_temp.DefaultView.ToTable();
            //xóa từ dưới lên trên,xóa cho đến khi số lượng bằng với drop số lượng đơn, và chỉ xóa những đơn chưa lưu vào db
            if (SL < tbl_temp.Rows.Count)
            {
                for (int i = tbl_temp.Rows.Count - 1; i > SL - 1; i--)
                {
                    if (tbl_temp.Rows[i]["ID"] + "" == "" || tbl_temp.Rows[i]["ID"] + "" == "&nbsp;")
                    {
                        tbl_temp.Rows[i].Delete();
                    }
                }
                for (int i = obj.Rows.Count - 1; i > SL - 1; i--)
                {
                    if (obj.Rows[i]["ID"] + "" == "" || obj.Rows[i]["ID"] + "" == "&nbsp;")
                    {
                        obj.Rows[i].Delete();
                    }
                }
                //-----------
                tbl_temp.AcceptChanges();
            }
            ddlSoLuong.SelectedValue = Convert.ToString(SL);
            obj.AcceptChanges();
            dgListDontrung.DataSource = obj;
            dgListDontrung.DataBind();
        }
        private void getTable_load()
        {
            int SL = 0; int SL_ONE = 0;
            if (ddlSoLuong.SelectedValue != "0")
            {
                SL = Convert.ToInt32(ddlSoLuong.SelectedValue);
            }
            decimal DonID = Convert.ToDecimal(hddID.Value);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable tbl = oBL.DANHSACHDON_KEMTHEO(DonID);//04-07-2024 sửa thông tin
            // 05/06/2020
            //lấy các giá trị đã nhập trước đó đổ vào một bảng tạm
            tbl_temp.Columns.Add("TT");
            tbl_temp.Columns.Add("ID");
            tbl_temp.Columns.Add("SOHIEUDON");
            tbl_temp.Columns.Add("NGAYNHANDON");
            tbl_temp.Columns.Add("NGAYGHIDON");
            tbl_temp.Columns.Add("HINHTHUCDON");
            tbl_temp.Columns.Add("SOCV");
            tbl_temp.Columns.Add("NGAYCV");
            tbl_temp.Columns.Add("LOAIDONVI");
            tbl_temp.Columns.Add("DONVIGUI");
            tbl_temp.Columns.Add("DONVIGUI_TEXT");
            tbl_temp.Columns.Add("CV_NGUOIKY");
            tbl_temp.Columns.Add("CV_CHUCVU");
            tbl_temp.AcceptChanges();
            foreach (DataGridItem Item in dgListDontrung.Items)
            {
                TextBox txtSohieudon = (TextBox)Item.FindControl("txtSohieudon");
                TextBox txtNgaynhandon = (TextBox)Item.FindControl("txtNgaynhandon");
                TextBox txtNgayghitrendon = (TextBox)Item.FindControl("txtNgayghitrendon");
                CheckBox chkIsCV = (CheckBox)Item.FindControl("chkIsCV");
                TextBox txtSoCV = (TextBox)Item.FindControl("txtSoCV");
                TextBox txtNgayCV = (TextBox)Item.FindControl("txtNgayCV");
                CheckBox chkIsTrongnganh = (CheckBox)Item.FindControl("chkIsTrongnganh");
                DropDownList ddlDontrung_Donvi = (DropDownList)Item.FindControl("ddlDontrung_Donvi");
                TextBox txtDontrung_Donvi = (TextBox)Item.FindControl("txtDontrung_Donvi");
                TextBox txtDontrung_Nguoiky = (TextBox)Item.FindControl("txtDontrung_Nguoiky");
                TextBox txtDontrung_Chucvu = (TextBox)Item.FindControl("txtDontrung_Chucvu");
                DataRow r_tpm = tbl_temp.NewRow();
                r_tpm["TT"] = Item.Cells[0].Text;
                r_tpm["ID"] = Item.Cells[1].Text;
                r_tpm["SOHIEUDON"] = txtSohieudon.Text;
                r_tpm["NGAYNHANDON"] = txtNgaynhandon.Text;
                r_tpm["NGAYGHIDON"] = txtNgayghitrendon.Text;
                r_tpm["HINHTHUCDON"] = Convert.ToString(Convert.ToInt32(chkIsCV.Checked));
                r_tpm["SOCV"] = txtSoCV.Text;
                r_tpm["NGAYCV"] = txtNgayCV.Text;
                r_tpm["LOAIDONVI"] = Convert.ToString(Convert.ToInt32(chkIsTrongnganh.Checked));
                r_tpm["DONVIGUI"] = ddlDontrung_Donvi.SelectedValue;
                r_tpm["DONVIGUI_TEXT"] = txtDontrung_Donvi.Text;
                r_tpm["CV_NGUOIKY"] = txtDontrung_Nguoiky.Text;
                r_tpm["CV_CHUCVU"] = txtDontrung_Chucvu.Text;
                tbl_temp.Rows.Add(r_tpm);
            }
            tbl_temp.AcceptChanges();
            ////////////////////////
            DataTable obj = new DataTable();
            obj.Columns.Add("TT");
            obj.Columns.Add("ID");
            obj.Columns.Add("SOHIEUDON");
            obj.Columns.Add("NGAYNHANDON");
            obj.Columns.Add("NGAYGHIDON");
            obj.Columns.Add("HINHTHUCDON");
            obj.Columns.Add("SOCV");
            obj.Columns.Add("NGAYCV");
            obj.Columns.Add("LOAIDONVI");
            obj.Columns.Add("DONVIGUI");
            obj.Columns.Add("DONVIGUI_TEXT");
            obj.Columns.Add("CV_NGUOIKY");
            obj.Columns.Add("CV_CHUCVU");
            obj.AcceptChanges();

            if (tbl != null && tbl.Rows.Count > 0)//04-07-2024 sửa thông tin
            {
                for (int i = 0; i <= tbl.Rows.Count - 1; i++)
                {
                    DataRow r = obj.NewRow();
                    r["TT"] = tbl.Rows[i]["TT"] + "";
                    r["ID"] = tbl.Rows[i]["ID"] + "";
                    r["SOHIEUDON"] = tbl.Rows[i]["SOHIEUDON"] + "";
                    r["NGAYNHANDON"] = tbl.Rows[i]["NGAYNHANDON"] + "";
                    r["NGAYGHIDON"] = tbl.Rows[i]["NGAYGHIDON"] + "";
                    r["HINHTHUCDON"] = tbl.Rows[i]["HINHTHUCDON"] + "";
                    r["SOCV"] = tbl.Rows[i]["CV_SO"] + "";
                    r["NGAYCV"] = tbl.Rows[i]["CV_NGAY"] + "";
                    r["HINHTHUCDON"] = tbl.Rows[i]["HINHTHUCDON"] + "";
                    r["LOAIDONVI"] = tbl.Rows[i]["LOAIDONVI"] + "";
                    r["DONVIGUI"] = tbl.Rows[i]["CV_TOAANID"] + "";
                    r["DONVIGUI_TEXT"] = tbl.Rows[i]["CV_TENDONVI"] + "";
                    r["CV_NGUOIKY"] = tbl.Rows[i]["CV_NGUOIKY"] + "";
                    r["CV_CHUCVU"] = tbl.Rows[i]["CV_CHUCVU"] + "";
                    obj.Rows.Add(r);
                }
            }
            if (SL > tbl.Rows.Count)
            {
                SL_ONE = SL - tbl.Rows.Count;
                for (int i = 1; i <= SL_ONE; i++)
                {
                    DataRow r = obj.NewRow();
                    r["TT"] = i.ToString();
                    r["ID"] = "";
                    r["HINHTHUCDON"] = "0";
                    r["LOAIDONVI"] = "0";
                    obj.Rows.Add(r);
                }
            }
            if (tbl.Rows.Count == 0)
            {
                ddlSoLuong.SelectedValue = "0";
                ddlSoLuong_SelectedIndexChanged(new object(), new EventArgs());
            }
            else
            {
                ddlSoLuong.SelectedValue = Convert.ToString(SL_ONE + tbl.Rows.Count);
            }
            //-----khi load lan dau tien tu danh sach, đổ từ dữ liệu vào bảng tạm
            tbl_temp = obj;
            tbl_temp.AcceptChanges();
            //------end
            obj.AcceptChanges();
            dgListDontrung.DataSource = obj;
            dgListDontrung.DataBind();
        }
        protected void dgListDontrung_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    DropDownList ddlDontrung_Donvi = (DropDownList)e.Item.FindControl("ddlDontrung_Donvi");
                    ddlDontrung_Donvi.DataSource = lstDonVi;
                    ddlDontrung_Donvi.DataTextField = "TEN";
                    ddlDontrung_Donvi.DataValueField = "ID";
                    ddlDontrung_Donvi.DataBind();
                    ddlDontrung_Donvi.Items.Add(new ListItem("----- Chọn đơn vị -----", "0"));

                    //05/06/2020---------lấy lại các giá trị đã nhập trước đó
                    if (e.Item.ItemIndex < tbl_temp.Rows.Count)
                    {
                        TextBox txtSohieudon = (TextBox)e.Item.FindControl("txtSohieudon");
                        TextBox txtNgaynhandon = (TextBox)e.Item.FindControl("txtNgaynhandon");
                        TextBox txtNgayghitrendon = (TextBox)e.Item.FindControl("txtNgayghitrendon");
                        CheckBox chkIsCV = (CheckBox)e.Item.FindControl("chkIsCV");
                        TextBox txtSoCV = (TextBox)e.Item.FindControl("txtSoCV");
                        TextBox txtNgayCV = (TextBox)e.Item.FindControl("txtNgayCV");
                        CheckBox chkIsTrongnganh = (CheckBox)e.Item.FindControl("chkIsTrongnganh");
                        Panel pnlDontrung = (Panel)e.Item.FindControl("pnlDontrung");
                        TextBox txtDontrung_Donvi = (TextBox)e.Item.FindControl("txtDontrung_Donvi");
                        TextBox txtDontrung_Nguoiky = (TextBox)e.Item.FindControl("txtDontrung_Nguoiky");
                        TextBox txtDontrung_Chucvu = (TextBox)e.Item.FindControl("txtDontrung_Chucvu");
                        //chuyển từ bảng tạm vào 
                        txtSohieudon.Text = tbl_temp.Rows[e.Item.ItemIndex][2].ToString();
                        txtNgaynhandon.Text = tbl_temp.Rows[e.Item.ItemIndex][3].ToString().Replace("01/01/0001 0:00:00", "");
                        txtNgayghitrendon.Text = tbl_temp.Rows[e.Item.ItemIndex][4].ToString().Replace("01/01/0001 0:00:00", "");
                        chkIsCV.Checked = Convert.ToBoolean(Convert.ToInt32(tbl_temp.Rows[e.Item.ItemIndex][5].ToString()));
                        txtSoCV.Text = tbl_temp.Rows[e.Item.ItemIndex][6].ToString();
                        txtNgayCV.Text = tbl_temp.Rows[e.Item.ItemIndex][7].ToString().Replace("01/01/0001 0:00:00", "");
                        chkIsTrongnganh.Checked = Convert.ToBoolean(Convert.ToInt32(tbl_temp.Rows[e.Item.ItemIndex][8].ToString()));
                        ddlDontrung_Donvi.SelectedValue = tbl_temp.Rows[e.Item.ItemIndex][9].ToString();
                        txtDontrung_Donvi.Text = tbl_temp.Rows[e.Item.ItemIndex][10].ToString();
                        txtDontrung_Nguoiky.Text = tbl_temp.Rows[e.Item.ItemIndex][11].ToString();
                        txtDontrung_Chucvu.Text = tbl_temp.Rows[e.Item.ItemIndex][12].ToString();
                        if (chkIsCV.Checked == true)
                        {
                            txtSoCV.Visible = true;
                            txtNgayCV.Visible = true;
                            chkIsTrongnganh.Visible = true;
                            txtDontrung_Donvi.Visible = true;
                            ddlDontrung_Donvi.Visible = false;
                            pnlDontrung.Visible = true;
                            if (chkIsTrongnganh.Checked == true)
                            {
                                txtDontrung_Donvi.Visible = false;
                                ddlDontrung_Donvi.Visible = true;
                            }
                            else if (chkIsTrongnganh.Checked == false)
                            {
                                txtDontrung_Donvi.Visible = true;
                                ddlDontrung_Donvi.Visible = false;
                            }
                        }
                        else if (chkIsCV.Checked == false)
                        {
                            txtSoCV.Visible = false;
                            txtNgayCV.Visible = false;
                            chkIsTrongnganh.Visible = false;
                            pnlDontrung.Visible = false;
                            txtDontrung_Donvi.Visible = false;
                            ddlDontrung_Donvi.Visible = false;
                        }
                    }
                    //---------lấy lại các giá trị đã nhập trước đó end
                }
                catch (Exception ex) { }
            }
        }
        protected void ddlSoLuong_SelectedIndexChanged(object sender, EventArgs e)
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            lstDonVi = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            if (ddlSoLuong.SelectedValue == "0")
                dgListDontrung.Visible = false;
            else
            {
                getTable();
                dgListDontrung.Visible = true;
            }
        }
        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }

        protected void chkDontrung_IsCV_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            string ID = chk.ToolTip;
            foreach (DataGridItem Item in dgListDontrung.Items)
            {
                CheckBox chkIsCV = (CheckBox)Item.FindControl("chkIsCV");
                TextBox txtSoCV = (TextBox)Item.FindControl("txtSoCV");
                TextBox txtNgayCV = (TextBox)Item.FindControl("txtNgayCV");

                CheckBox chkIsTrongnganh = (CheckBox)Item.FindControl("chkIsTrongnganh");
                Panel pnlDontrung = (Panel)Item.FindControl("pnlDontrung");
                TextBox txtDontrung_Donvi = (TextBox)Item.FindControl("txtDontrung_Donvi");
                DropDownList ddlDontrung_Donvi = (DropDownList)Item.FindControl("ddlDontrung_Donvi");
                TextBox txtDontrung_Nguoiky = (TextBox)Item.FindControl("txtDontrung_Nguoiky");
                TextBox txtDontrung_Chucvu = (TextBox)Item.FindControl("txtDontrung_Chucvu");
                if (chk.ToolTip == chkIsCV.ToolTip)
                {
                    if (chk.Checked)
                    {
                        txtSoCV.Visible = true;
                        txtNgayCV.Visible = true;
                        chkIsTrongnganh.Visible = true;
                        pnlDontrung.Visible = true;
                        txtDontrung_Donvi.Visible = true;
                        ddlDontrung_Donvi.Visible = false;
                    }
                    else
                    {
                        txtSoCV.Visible = false;
                        txtNgayCV.Visible = false;
                        chkIsTrongnganh.Visible = false;
                        pnlDontrung.Visible = false;
                        txtDontrung_Donvi.Visible = false;
                        ddlDontrung_Donvi.Visible = false;

                        txtDontrung_Donvi.Text = "";
                        ddlDontrung_Donvi.SelectedIndex = 0;
                        txtDontrung_Nguoiky.Text = "";
                        txtDontrung_Chucvu.Text = "";
                    }
                }
            }
        }
        protected void chkDontrung_IsTrongnganh_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            string ID = chk.ToolTip;
            foreach (DataGridItem Item in dgListDontrung.Items)
            {
                CheckBox chkIsTrongnganh = (CheckBox)Item.FindControl("chkIsTrongnganh");
                Panel pnlDontrung = (Panel)Item.FindControl("pnlDontrung");
                TextBox txtDontrung_Donvi = (TextBox)Item.FindControl("txtDontrung_Donvi");
                DropDownList ddlDontrung_Donvi = (DropDownList)Item.FindControl("ddlDontrung_Donvi");
                TextBox txtDontrung_Nguoiky = (TextBox)Item.FindControl("txtDontrung_Nguoiky");
                TextBox txtDontrung_Chucvu = (TextBox)Item.FindControl("txtDontrung_Chucvu");
                if (chk.ToolTip == chkIsTrongnganh.ToolTip)
                {
                    if (chk.Checked)
                    {
                        pnlDontrung.Visible = true;
                        txtDontrung_Donvi.Visible = false;
                        ddlDontrung_Donvi.Visible = true;

                        txtDontrung_Donvi.Text = "";
                    }
                    else
                    {
                        txtDontrung_Donvi.Visible = true;
                        ddlDontrung_Donvi.Visible = false;

                        ddlDontrung_Donvi.SelectedIndex = 0;
                        txtDontrung_Nguoiky.Text = "";
                        txtDontrung_Chucvu.Text = "";
                    }
                }
            }
        }
        protected void ddlSonguoiKN_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlSonguoiKN.SelectedValue == "0")
                dgNguoiKN.Visible = false;
            else
            {
                if (hddID.Value == "" || hddID.Value == "0")
                    getNguoiKN(Convert.ToInt32(ddlSonguoiKN.SelectedValue), false);
                else
                    getNguoiKN(Convert.ToInt32(ddlSonguoiKN.SelectedValue), true);
                dgNguoiKN.Visible = true;
            }
        }
        private void getNguoiKN(int SL, bool isUpdate)
        {
            DataTable obj = new DataTable();
            obj.Columns.Add("ID");
            obj.Columns.Add("HOTEN");
            obj.Columns.Add("DIACHI");
            obj.Columns.Add("GIOITINH");
            obj.AcceptChanges();

            if (isUpdate == false)
            {
                for (int i = 1; i <= SL; i++)
                {
                    DataRow r = obj.NewRow();
                    r["ID"] = "0";
                    r["HOTEN"] = "";
                    r["DIACHI"] = "";
                    r["GIOITINH"] = "-1";
                    obj.Rows.Add(r);
                }
                obj.AcceptChanges();
            }
            else
            {
                foreach (DataGridItem item in dgNguoiKN.Items)
                {
                    DataRow r = obj.NewRow();
                    TextBox txtHoten = (TextBox)item.FindControl("txtHoten");
                    TextBox txtDiachi = (TextBox)item.FindControl("txtDiachi");
                    DropDownList ddlGioitinhDNK = (DropDownList)item.FindControl("ddlGioitinhDNK");
                    string strKNID = item.Cells[0].Text;
                    if (txtHoten.Text.Trim() != "")
                    {
                        r["ID"] = strKNID;
                        r["HOTEN"] = txtHoten.Text;
                        r["DIACHI"] = txtDiachi.Text;
                        r["GIOITINH"] = ddlGioitinhDNK.SelectedValue;
                        obj.Rows.Add(r);
                        obj.AcceptChanges();
                    }
                }
                if (SL > dgNguoiKN.Items.Count)
                {
                    for (int i = dgNguoiKN.Items.Count + 1; i <= SL; i++)
                    {
                        DataRow r = obj.NewRow();
                        r["ID"] = "0";
                        r["HOTEN"] = "";
                        r["DIACHI"] = "";
                        r["GIOITINH"] = "-1";
                        obj.Rows.Add(r);
                        obj.AcceptChanges();
                    }
                }
            }
            dgNguoiKN.DataSource = obj;
            dgNguoiKN.DataBind();
        }
        protected void ddlCAChidao_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlCAChidao.SelectedValue == "0")
            {
                trChidao.Visible = false;
            }
            else
            {

                trChidao.Visible = true;

            }
        }

        //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
        protected void ddlToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                bool isToaCapTinh = false;
                List<DM_TOAAN> lstToaancaptinh = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPTINH") && x.HIEULUC == 1).ToList();
                List<DM_TOAAN> lstToaancapcao = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPCAO") && x.HIEULUC == 1).ToList();

                foreach (DataGridItem item in dgTBTLD.Items)
                {
                    DropDownList ddlToaAn = (DropDownList)item.FindControl("ddlToaAn");
                    foreach (DM_TOAAN item1 in lstToaancaptinh)
                    {
                        if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item1.ID)
                        {
                            isToaCapTinh = true;
                        }
                    }
                    foreach (DM_TOAAN item2 in lstToaancapcao)
                    {
                        if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item2.ID)
                        {
                            isToaCapTinh = false;
                        }
                    }
                }
                decimal ToaAnID = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                bool isTPB3 = false;
                decimal idPB = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                if (oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", idPB).Rows.Count > 0)
                {
                    isTPB3 = true;
                }
                lblalert.Text = "";
                lblThamquyen.Visible = false;
                try
                {
                    bool checkLoaiThamQuyen = true;
                    string current_id = Request["ID"] + "";
                    if (current_id != "" && current_id != "0")
                    {
                        decimal ID = Convert.ToDecimal(current_id);
                        GDTTT_DON don = dt.GDTTT_DON.FirstOrDefault(x => x.ID == ID);
                        if (don != null && don.THAMPHANID != null && don.THAMPHANID > 0) checkLoaiThamQuyen = false;
                    }

                    //đã phân công thẩm phán thì không gợi ý loại thẩm quyền đơn nữa
                    if (checkLoaiThamQuyen)
                    {
                        DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).Single();
                        if ((obj.LOAITOA == "CAPTINH" & !chkKN_TBTLD.Checked & isTPB3) || ((obj.LOAITOA == "CAPHUYEN" || obj.LOAITOA == "QSKHUVUC") & chkKN_TBTLD.Checked & isToaCapTinh & isTPB3))
                        {
                            rdbThamquyen.SelectedValue = "1";
                            lblThamquyen.Text = "Dựa trên thông tin đơn, đây là đơn dành cho thẩm phán bậc 3";
                            lblThamquyen.Visible = true;

                            List_thamphan.Visible = true;
                            LoadThamphan_Tongan();
                        }
                        else
                        {
                            rdbThamquyen.SelectedValue = "0";
                            lblThamquyen.Text = "Dựa trên thông tin đơn, đây là đơn dành cho thẩm phán tối cao";
                            lblThamquyen.Visible = true;
                            
                            List_thamphan.Visible = false;
                        }
                    }
                }
                catch (Exception ex) { }

            }
            catch (Exception) { }
        }

        protected void chkKN_TBTLD_CheckedChanged(object sender, EventArgs e)
        {
            if (chkKN_TBTLD.Checked)
            {
                trThongbaoTLD.Visible = true;
                if (dgTBTLD.Items.Count == 0)
                    getTBTLD(1, false);
            }
            else
            {
                trThongbaoTLD.Visible = false;
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtSoQDBA.ClientID);

            //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
            try
            {
                bool isToaCapTinh = false;
                List<DM_TOAAN> lstToaancaptinh = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPTINH") && x.HIEULUC == 1).ToList();
                List<DM_TOAAN> lstToaancapcao = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPCAO") && x.HIEULUC == 1).ToList();

                foreach (DataGridItem item in dgTBTLD.Items)
                {
                    DropDownList ddlToaAn = (DropDownList)item.FindControl("ddlToaAn");
                    foreach (DM_TOAAN item1 in lstToaancaptinh)
                    {
                        if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item1.ID)
                        {
                            isToaCapTinh = true;
                        }
                    }
                    foreach (DM_TOAAN item2 in lstToaancapcao)
                    {
                        if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item2.ID)
                        {
                            isToaCapTinh = false;
                        }
                    }
                }
                decimal ToaAnID = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                bool isTPB3 = false;
                decimal idPB = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                if (oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", idPB).Rows.Count > 0)
                {
                    isTPB3 = true;
                }
                lblalert.Text = "";
                lblThamquyen.Visible = false;
                try
                {
                    bool checkLoaiThamQuyen = true;
                    string current_id = Request["ID"] + "";
                    if (current_id != "" && current_id != "0")
                    {
                        decimal ID = Convert.ToDecimal(current_id);
                        GDTTT_DON don = dt.GDTTT_DON.FirstOrDefault(x => x.ID == ID);
                        if (don != null && don.THAMPHANID != null && don.THAMPHANID > 0) checkLoaiThamQuyen = false;
                    }

                    //đã phân công thẩm phán thì không gợi ý loại thẩm quyền đơn nữa
                    if (checkLoaiThamQuyen)
                    {
                        DM_TOAAN obj = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).Single();
                        if ((obj.LOAITOA == "CAPTINH" & !chkKN_TBTLD.Checked & isTPB3) || ((obj.LOAITOA == "CAPHUYEN" || obj.LOAITOA == "QSKHUVUC") & chkKN_TBTLD.Checked & isToaCapTinh & isTPB3))
                        {
                            string strType = Request["type"] + "";
                            if (strType != "dontrung")
                            {
                                rdbThamquyen.SelectedValue = "1";
                                lblThamquyen.Text = "Dựa trên thông tin đơn, đây là đơn dành cho thẩm phán bậc 3";
                                lblThamquyen.Visible = true;

                                List_thamphan.Visible = true;
                                LoadThamphan_Tongan();
                            }
                        }
                        else
                        {
                            string strType = Request["type"] + "";
                            if (strType != "dontrung")
                            {
                                rdbThamquyen.SelectedValue = "0";
                                lblThamquyen.Text = "Dựa trên thông tin đơn, đây là đơn dành cho thẩm phán tối cao";
                                lblThamquyen.Visible = true;

                                List_thamphan.Visible = false;
                            }
                        }
                    }
                }
                catch (Exception ex) { }

            }
            catch (Exception) { }
        }

        //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
        protected void rdbTq_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ToaAnID = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
            bool isToaCapTinh = false;
            List<DM_TOAAN> lstToaancaptinh = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPTINH") && x.HIEULUC == 1).ToList();
            List<DM_TOAAN> lstToaancapcao = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPCAO") && x.HIEULUC == 1).ToList();

            foreach (DataGridItem item in dgTBTLD.Items)
            {
                DropDownList ddlToaAn = (DropDownList)item.FindControl("ddlToaAn");
                foreach (DM_TOAAN item1 in lstToaancaptinh)
                {
                    if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item1.ID)
                    {
                        isToaCapTinh = true;
                    }
                }
                foreach (DM_TOAAN item2 in lstToaancapcao)
                {
                    if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item2.ID)
                    {
                        isToaCapTinh = false;
                    }
                }
            }
            bool isTPB3 = false;
            decimal idPB = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            if (oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", idPB).Rows.Count > 0)
            {
                isTPB3 = true;
            }
            bool tpB3 = false;
            if ((oTA.LOAITOA == "CAPTINH" & !chkKN_TBTLD.Checked & isTPB3) || ((oTA.LOAITOA == "CAPHUYEN" || oTA.LOAITOA == "QSKHUVUC") & chkKN_TBTLD.Checked & isToaCapTinh & isTPB3))
            {
                tpB3 = true;
            }

            lblalert.Text = "";
            if (rdbThamquyen.SelectedValue == "1" & tpB3 == false)
            {
                lblalert.Text = "Vụ GĐTKT không có TP bậc 3, đề nghị phân công cho TP tối cao.";

                List_thamphan.Visible = false;
            }
            else
            {
                lblalert.Text = "";

                if (ToaAnID == 1 && ddlLoaiAn.SelectedValue =="2")
                {
                    List_thamphan.Visible = true;
                    LoadThamphan_Tongan();
                }
            }
        }

        protected void rdbThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Ngay xu ly don là ngay hệ thống
            if (hddID.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.ISTHULY != Convert.ToDecimal(rdbThuLy.SelectedValue))
                    txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            if (rdbThuLy.SelectedValue != "2" && (hddID.Value == "0" || txtSoThuLy.Text == ""))
            {
                //txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlLoaiAn.SelectedValue)).ToString();
                decimal sothuly_ = 0;
                oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                txtSoThuLy.Text = Convert.ToString(sothuly_);
                //--------------
            }
            if (rdbThuLy.SelectedValue == "2")
                pnThuLy.Visible = false;
            else
                pnThuLy.Visible = true;
            Cls_Comon.SetFocus(this, this.GetType(), rdbThuLy.ClientID);
        }
        protected void dgDSDonTLL_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Sua":
                    hddID.Value = e.CommandArgument.ToString();
                    TrangThaiDon_load(Convert.ToDecimal(hddID.Value), false);
                    LoadInfo(Convert.ToDecimal(hddID.Value), false);
                    ThuLy_load(Convert.ToDecimal(hddID.Value), false);
                    txtNoidung.Focus();
                    break;
                case "Xoa":
                    if (hddID.Value != "" || hddID.Value != "0")
                    {
                        Decimal ID = Convert.ToDecimal(hddID.Value);
                        Decimal id_goc = Convert.ToDecimal(e.CommandArgument.ToString());
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        GDTTT_DON d_goc = dt.GDTTT_DON.Where(x => x.ID == id_goc).FirstOrDefault();
                        decimal DontrungID = d.DONTRUNGID == null ? 0 : (decimal)d.DONTRUNGID;
                        decimal ARR_DON_ID = d.ARR_DON_ID == null ? 0 : (decimal)d.ARR_DON_ID;
                        if (ARR_DON_ID > 0)
                        {
                            d.ARR_DON_ID = 0;   //hủy trùng cho trường mới ARR_DON_ID 25/06/2024
                            d.CD_TA_TRANGTHAI = 0;  //1 Đơn chưa đủ điều kiện
                            d.THAMPHANID = 0;//xóa thẩm phán của đơn hủy trùng
                            d.ISTHULY = 1;//thụ lý mới 20/09/2024
                            d.NGAYSUA = DateTime.Now;
                            d.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            d_goc.NGAYSUA = DateTime.Now;
                            d_goc.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            dt.SaveChanges();
                            LoadDSTrung();
                            LoadDSTLL();
                            LoadDSKemTheo();
                            oBL.SOVANBAN_XOATHEO_MA(ID, "SoTT_TLL,TBTP");//20/09/2024 xóa tờ trình Thụ lý trùng TP, thông báo thẩm phán của đơn đang mở (đơn Thụ lý trùng TP)  

                        }
                    }
                    break;
            }
        }

        protected void dgDSDonTrung_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Sua":
                    hddID.Value = e.CommandArgument.ToString();
                    TrangThaiDon_load(Convert.ToDecimal(hddID.Value), false);
                    LoadInfo(Convert.ToDecimal(hddID.Value), false);
                    ThuLy_load(Convert.ToDecimal(hddID.Value), false);
                    txtNoidung.Focus();
                    break;
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                    decimal DontrungID = d.DONTRUNGID == null ? 0 : (decimal)d.DONTRUNGID;
                    decimal ARR_DON_ID = d.ARR_DON_ID == null ? 0 : (decimal)d.ARR_DON_ID;
                    if (ARR_DON_ID > 0)
                    {
                        d.ARR_DON_ID = 0;   //hủy trùng cho trường mới ARR_DON_ID 25/06/2024
                        d.CD_TA_TRANGTHAI = 1;  //1 Đơn chưa đủ điều kiện
                        d.THAMPHANID = 0;
                        d.ISTHULY = null;//29/08/2024
                        dt.SaveChanges();
                        LoadDSTrung();
                        LoadDSTLL();
                        LoadDSKemTheo();
                    }
                    //else   //hiện tại tạm thời đóng lại vì việc quản lý đơn trùng không quản lý nữa
                    //{
                    //    if (DontrungID > 0)
                    //    {
                    //        d.DONTRUNGID = 0;
                    //        d.SOLUONGDON = 1;
                    //        dt.SaveChanges();
                    //        oBL.UPDATESOLUONGDON(DontrungID);
                    //        LoadDSTrung();
                    //    }
                    //    else //Đơn Hủy chính là đơn gốc
                    //    {
                    //        d.SOLUONGDON = 1;
                    //        dt.SaveChanges();
                    //        List<GDTTT_DON> lstT = dt.GDTTT_DON.Where(x => x.DONTRUNGID == ID).OrderByDescending(x => x.NGAYTAO).ToList();
                    //        if (lstT.Count == 1)
                    //        {
                    //            d.SOLUONGDON = 1;
                    //            lstT[0].SOLUONGDON = 1;
                    //            lstT[0].DONTRUNGID = 0;
                    //            dt.SaveChanges();
                    //            LoadDSTrung();
                    //        }
                    //        else if (lstT.Count > 1)
                    //        {
                    //            GDTTT_DON dtGoc = lstT[0];
                    //            dtGoc.SOLUONGDON = 1;
                    //            dtGoc.DONTRUNGID = 0;
                    //            foreach (GDTTT_DON dt in lstT)
                    //            {
                    //                if (dt.ID != dtGoc.ID)
                    //                {
                    //                    t.SOLUONGDON = 1;
                    //                    dt.DONTRUNGID = dtGoc.ID;
                    //                }
                    //            }
                    //            dt.SaveChanges();
                    //            oBL.UPDATESOLUONGDON(dtGoc.ID);
                    //            LoadDSTrung();
                    //        }
                    //    }
                    //}
                    break;
            }
        }
        protected void dgDSDonKemTheo_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Sua":
                    hddID.Value = e.CommandArgument.ToString();
                    TrangThaiDon_load(Convert.ToDecimal(hddID.Value), false);
                    LoadInfo(Convert.ToDecimal(hddID.Value), false);
                    ThuLy_load(Convert.ToDecimal(hddID.Value), false);
                    txtNoidung.Focus();
                    break;
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                    decimal DontrungID = d.DONTRUNGID == null ? 0 : (decimal)d.DONTRUNGID;
                    decimal ARR_DON_ID = d.ARR_DON_ID == null ? 0 : (decimal)d.ARR_DON_ID;
                    if (ARR_DON_ID > 0)//15/10/2024
                    {
                        d.ARR_DON_ID = 0;   //hủy trùng cho trường mới ARR_DON_ID 25/06/2024
                        d.CD_TA_TRANGTHAI = 1;  //1 Đơn chưa đủ điều kiện
                        d.THAMPHANID = 0;//xóa thẩm phán của đơn hủy trùng
                        d.ISTHULY = null;
                        d.NGAYSUA = DateTime.Now;
                        d.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        //------------
                        dt.SaveChanges();
                        LoadDSTrung();
                        LoadDSTLL();
                        LoadDSKemTheo();
                        getTable_load();
                    }
                    break;
            }
        }
        protected void ddlSoTBTLD_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (hddID.Value == "" || hddID.Value == "0")
                getTBTLD(Convert.ToInt32(ddlSoTBTLD.SelectedValue), false);
            else
                getTBTLD(Convert.ToInt32(ddlSoTBTLD.SelectedValue), true);
        }

        private void getTBTLD(int SL, bool isUpdate)
        {
            try
            {
                DataTable obj = new DataTable();
                obj.Columns.Add("ID");
                obj.Columns.Add("SO");
                obj.Columns.Add("NGAY", Type.GetType("System.DateTime"));
                obj.Columns.Add("DONVITB");
                obj.AcceptChanges();

                if (isUpdate == false)
                {
                    for (int i = 1; i <= SL; i++)
                    {
                        DataRow r = obj.NewRow();
                        r["ID"] = "0";
                        r["SO"] = "";
                        // r["NGAY"] = null;
                        r["DONVITB"] = "0";
                        obj.Rows.Add(r);
                    }
                    obj.AcceptChanges();
                }
                else
                {
                    foreach (DataGridItem item in dgTBTLD.Items)
                    {
                        DataRow r = obj.NewRow();
                        TextBox txtSo = (TextBox)item.FindControl("txtSo");
                        TextBox txtNgay = (TextBox)item.FindControl("txtNgay");
                        DropDownList ddlToaAn = (DropDownList)item.FindControl("ddlToaAn");
                        string strKNID = item.Cells[0].Text;
                        if (txtSo.Text.Trim() != "")
                        {
                            r["ID"] = strKNID;
                            r["SO"] = txtSo.Text;
                            DateTime? dNgay = (String.IsNullOrEmpty(txtNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            if (dNgay != null)
                                r["NGAY"] = dNgay;
                            r["DONVITB"] = ddlToaAn.SelectedValue;
                            obj.Rows.Add(r);
                            obj.AcceptChanges();
                        }
                    }
                    if (SL > obj.Rows.Count)
                    {
                        for (int i = obj.Rows.Count + 1; i <= SL; i++)
                        {
                            DataRow r = obj.NewRow();
                            r["ID"] = "0";
                            r["SO"] = "";

                            r["DONVITB"] = "0";
                            obj.Rows.Add(r);
                            obj.AcceptChanges();
                        }
                    }
                }
                dgTBTLD.DataSource = obj;
                dgTBTLD.DataBind();
            }
            catch (Exception ex) { }
        }
        protected void dgTBTLD_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                try
                {

                    DropDownList ddlToaAn = (DropDownList)e.Item.FindControl("ddlToaAn");
                    HiddenField hddToaID = (HiddenField)e.Item.FindControl("hddToaID");

                    ddlToaAn.ToolTip = e.Item.Cells[0].Text;

                    //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
                    //ddlToaAn.DataSource = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPCAO" || x.LOAITOA == "QSTRUNGUONG" || x.LOAITOA == "TOICAO") && x.HIEULUC == 1).ToList();
                    ddlToaAn.DataSource = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPTINH" || x.LOAITOA == "CAPCAO" || x.LOAITOA == "QSTRUNGUONG" || x.LOAITOA == "TOICAO") && x.HIEULUC == 1).ToList();
                    ddlToaAn.DataTextField = "TEN";
                    ddlToaAn.DataValueField = "ID";
                    ddlToaAn.DataBind();
                    ddlToaAn.Items.Insert(0, new ListItem("----", "0"));
                    if (hddToaID.Value != "" && hddToaID.Value != "0") ddlToaAn.SelectedValue = hddToaID.Value;
                }
                catch (Exception ex) { }
            }
        }

        protected void lbtGYNoidung_Click(object sender, EventArgs e)
        {
            if (pnBAQDGDT.Visible)
            {
                if ((rdbBAQD.SelectedValue == "0" || rdbBAQD.SelectedValue == "2") && txtSoQDBA.Text != "") //Số bản án/QĐ
                {
                    string strND = "khiếu nại Bản án/Quyết định số";
                    strND += " " + txtSoQDBA.Text + " ngày " + txtNgayBA.Text + " của ";
                    if (ddlToaXetXu.SelectedValue != "0")
                        strND += ddlToaXetXu.SelectedItem.Text + ";";
                    if (txtNoidung.Text == "")
                        txtNoidung.Text = strND;
                    else
                        txtNoidung.Text = txtNoidung.Text + "\n" + strND;
                }
                else//KN Quyết định
                {
                    string strND = "khiếu nại Quyết định kháng nghị số";
                    strND += " " + txtSoQDKN.Text + " ngày " + txtNgayKhangNghi.Text + " của ";
                    if (ddlNguoiKhangNghi.SelectedValue != "0")
                        strND += ddlNguoiKhangNghi.SelectedItem.Text + "";
                    strND += " đối với Bản án số " + txtSoQDBA.Text + " ngày " + txtNgayBA.Text + " của ";
                    if (ddlToaXetXu.SelectedValue != "0")
                        strND += ddlToaXetXu.SelectedItem.Text + ";";
                    if (txtNoidung.Text == "")
                        txtNoidung.Text = strND;
                    else
                        txtNoidung.Text = txtNoidung.Text + "\n" + strND + "";
                }
            }
        }
        protected void lbtGYGhichu_Click(object sender, EventArgs e)
        {
            if (trThongbaoTLD.Visible && dgTBTLD.Items.Count > 0)
            {
                string strND = "";
                foreach (DataGridItem item in dgTBTLD.Items)
                {
                    TextBox txtSo = (TextBox)item.FindControl("txtSo");
                    TextBox txtNgay = (TextBox)item.FindControl("txtNgay");
                    DropDownList ddlToaAn = (DropDownList)item.FindControl("ddlToaAn");
                    if (strND == "")
                    {
                        strND = "Thông báo giải quyết đơn số " + txtSo.Text + " ngày " + txtNgay.Text;
                        if (ddlToaAn.SelectedIndex > 0)
                            strND += " của " + ddlToaAn.SelectedItem.Text + ".";
                    }
                    else
                    {
                        strND += "\n" + "Thông báo giải quyết đơn số " + txtSo.Text + " ngày " + txtNgay.Text;
                        if (ddlToaAn.SelectedIndex > 0)
                            strND += " của " + ddlToaAn.SelectedItem.Text + ".";
                    }
                }

                if (txtGhichu.Text == "")
                    txtGhichu.Text = strND;
                else
                    txtGhichu.Text = txtGhichu.Text + "\n" + strND;
            }
        }

        protected void lbtGYChidao_Click(object sender, EventArgs e)
        {
            string strND = "Thực hiện ý kiến chỉ đạo của đồng chí ";
            try
            {
                decimal IDCB = Convert.ToDecimal(ddlCAChidao.SelectedValue);
                DM_CANBO oLD = dt.DM_CANBO.Where(x => x.ID == IDCB).FirstOrDefault();
                if (oLD.CHUCVUID == null || oLD.CHUCVUID == 0)
                {
                    strND += oLD.HOTEN + ", Thẩm phán Tòa án nhân dân cấp cao";
                }
                else
                {
                    DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oLD.CHUCVUID).FirstOrDefault();
                    if (oCV.MA == ENUM_CHUCVU.CHUCVU_PCA)
                    {
                        strND += oLD.HOTEN + ", Phó Chánh án Tòa án nhân dân cấp cao";
                    }
                    else
                        strND += "Chánh án Tòa án nhân dân cấp cao";
                }
            }
            catch (Exception ex) { }
            strND += ", Văn phòng Tòa án nhân dân cấp cao chuyển";
            if (ddlHinhthucdon.SelectedValue == "1")
                strND += " đơn nêu trên";
            else if (ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9")
                strND += " Công văn nêu trên của " + txtCV_DonViGuiNgoaiNganh.Text;
            else if (ddlHinhthucdon.SelectedValue == "3")
                strND += " đơn nêu trên";
            if (rdbLoaichuyen.SelectedValue == "0")
                strND += " đến " + ddlChuyendenDV.SelectedItem.Text;
            else if (rdbLoaichuyen.SelectedValue == "1")
                strND += " đến " + ddlToaKhac.SelectedItem.Text;
            else if (rdbLoaichuyen.SelectedValue == "2")
                strND += " đến " + txtNgoaitoaan.Text;
            txtCA_Noidung.Text = strND;
        }
        public void Load_DonTrung()
        {
            GDTTT_DON_BL bl = new GDTTT_DON_BL();
            string strSoBAQD = txtSoQDBA.Text;
            string strNgayBAQD = txtNgayBA.Text;
            string strToaID = ddlToaXetXu.SelectedValue;
            decimal Currid = 0;
            if (hddID.Value != "")
            {
                Currid = Convert.ToDecimal(hddID.Value);
            }
            if (rdbBAQD.SelectedValue == "1")
            {
                strSoBAQD = txtSoQDKN.Text;
                strNgayBAQD = txtNgayKhangNghi.Text;
                strToaID = ddlNguoiKhangNghi.SelectedValue;
            }
            if (strSoBAQD == "" && strNgayBAQD == "")
            {
                // txtTenDonTrung.Text = "Chưa nhập thông tin bản án !";
                lstMsg_dontrung.Text = "Chưa nhập thông tin bản án";
                txtSoQDBA.Focus();
                trDSTrung.Visible = false;
                return;
            }
            if (strSoBAQD == "" && strNgayBAQD == "")
            {
                // txtTenDonTrung.Text = "Chưa nhập thông tin bản án !";
                lstMsg_dontrung.Text = "Chưa nhập thông tin bản án";
                txtNgayBA.Focus();
                trDSTrung.Visible = false;
                return;
            }
            if (ddlCapXetXu.SelectedValue == "0")
            {
                lstMsg_dontrung.Text = "Bạn phải chọn cấp xét xử";
                ddlCapXetXu.Focus();
                trDSTrung.Visible = false;
                return;
            }
            DataTable tbl = bl.GDTTT_DON_GETDONTRUNG(Convert.ToDecimal(ddlHinhthucdon.SelectedValue), CurrDonViID, Currid, txtTenDonTrung.Text.Trim(), strSoBAQD.Trim(), strNgayBAQD.Trim(), strToaID, ddlCapXetXu.SelectedValue, rdbBAQD.SelectedValue);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                int total = tbl.Rows.Count;
                hddTotalPage.Value = Cls_Comon.GetTotalPage(total, Convert.ToInt32(dgListTrung.PageSize)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + total + " </b> đơn có thể trùng !";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                trDSTrung.Visible = true;
                lstMsg_dontrung.Text = string.Empty;
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có đơn trùng !";
                trDSTrung.Visible = false;
                lstMsg_dontrung.Text = "Không có đơn trùng";
            }

            dgListTrung.DataSource = tbl;
            dgListTrung.DataBind();
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgListTrung.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                Load_DonTrung();
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = ex.Message;
            }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgListTrung.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Load_DonTrung();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgListTrung.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                Load_DonTrung();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgListTrung.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                Load_DonTrung();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgListTrung.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                Load_DonTrung();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        #endregion

        protected void dgListTrung_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Select":
                    String ND_id = e.CommandArgument.ToString();
                    //anhvh edit 25/06/2021
                    String[] ND_id_arr = ND_id.Split(';');
                    hddDontrungID.Value = ND_id_arr[0] + "";
                    hddDontrungID_Chon.Value = ND_id_arr[0] + "";
                    String VUAN_ID = ND_id_arr[1] + "";
                    String LOAIAN_ = ND_id_arr[2] + "";
                    Check_BC_NKN();
                    TrangThaiDon_load(Convert.ToDecimal(hddDontrungID.Value), true);
                    ThuLy_load(Convert.ToDecimal(hddDontrungID.Value), true);
                    Decimal V_ID_DON = 0;
                    if (ND_id_arr[0] + "" != "")
                        V_ID_DON = Convert.ToDecimal(ND_id_arr[0] + "");
                    //-----------
                    if (VUAN_ID != null && VUAN_ID != "")//Bị cáo đương sự lấy từ vụ án 
                    {
                        LoadInfo_FromVuan(V_ID_DON, Convert.ToDecimal(VUAN_ID), true);
                    }
                    else//Bị cáo đương sự lấy từ đơn
                    {
                        LoadInfo_fromDon(Convert.ToDecimal(ND_id_arr[0] + ""), true);
                    }
                    trDSTrung.Visible = false;
                    txtTenDonTrung.Enabled = true;
                    lstMsg_dontrung.Text = "Số hiệu: " + e.Item.Cells[3].Text + "; người gửi: " + e.Item.Cells[4].Text;
                    txtVB_Ngay.Text = "";
                    txtSohieudon.Focus();
                    cmdCheckTrungDon.Visible = false;
                    cmdHuyTrungDon.Visible = true;
                    ddlLoaiAn.SelectedValue = "0" + LOAIAN_;
                    ///----------------
                    if (LOAIAN_ == "1")
                    {
                        LoadDropNguoiKhieuNai();
                        LoadDropBiCao();
                        LoadDanhSachBiCao();
                    }
                    else
                    {
                        //-------- load nguyên đơn, bị đơn 24/04/2021
                        LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                        LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                        LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                        //-----------------------------
                    }
                    Check_Nguoi_KN_LoaiAn();
                    ////---------lấy lại số thụ lý
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    decimal sothuly_ = 0;
                    if (ddlHinhthucdon.SelectedValue == "4")
                        sothuly_ = oBL.TLXXGDT_GETMAXTT(CurrDonViID, DateTime.Now.Year, ddlLoaiAn.SelectedValue);
                    else
                        oBL.SO_THULY_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", ddlHinhthucdon.SelectedValue, ddlLoaiAn.SelectedValue, ref sothuly_);
                    txtSoThuLy.Text = Convert.ToString(sothuly_);
                    //------------------
                    DonTrung_Check();
                    break;
            };
        }
        protected void Create_Bicao_duongsu()
        {
            string ND_id = Request["ID"] + "";
            Decimal _ID = Convert.ToDecimal(ND_id);
            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == _ID).FirstOrDefault();
            hddDontrungID.Value = ND_id;
            String VUAN_ID = oT.VUVIECID + "";
            String LOAIAN_ = oT.BAQD_LOAIAN + "";
            //txtTenDonTrung.Text = "Ngày nhận: " + e.Item.Cells[2].Text + "; người gửi: " + e.Item.Cells[3].Text + ", số BAQĐ: " + e.Item.Cells[4].Text + ", ngày BAQĐ: " + e.Item.Cells[5].Text;
            if (VUAN_ID != null && VUAN_ID != "")//Bị cáo đương sự lấy từ vụ án 
            {
                don_id = Convert.ToDecimal(Session["DONID_CC"] + "");
                if (LOAIAN_ == "1")
                {
                    ADD_BICAO_DON(don_id, Convert.ToDecimal(VUAN_ID));
                }
                else
                {
                    ADD_DUONGSU_DON(don_id, Convert.ToDecimal(VUAN_ID));
                }
            }
            else//Bị cáo đương sự lấy từ đơn
            {
                if (Session["DONID_CC"] != null)
                {
                    don_id = Convert.ToDecimal(Session["DONID_CC"] + "");
                    if (LOAIAN_ == "1")
                    {
                        ADD_BICAO_DON_FROM_DON(don_id, Convert.ToDecimal(ND_id + ""));
                    }
                    else
                    {
                        ADD_DUONGSU_DON_FROM_DON(don_id, Convert.ToDecimal(ND_id + ""));
                    }
                }
            }
        }
        protected void ADD_DUONGSU_DON(Decimal donid, Decimal vuanid_old)
        {
            //de lay ra Nguyen don và Bi don tu Don
            string vNguyenDon = "", vBiDON = "";
            List<GDTTT_VUAN_DUONGSU> lsDS = null;
            lsDS = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == vuanid_old).ToList();
            if (lsDS.Count > 0)
            {
                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_DON_DUONGSU_CC objBC = new GDTTT_DON_DUONGSU_CC();
                    objBC.VUANID = vuanid_old;
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
                    dt.GDTTT_DON_DUONGSU_CC.Add(objBC);
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
                dt.SaveChanges();
            }
        }
        protected void ADD_DUONGSU_DON_FROM_DON(Decimal donid, Decimal DONID_old)
        {
            //de lay ra Nguyen don và Bi don tu Don
            string vNguyenDon = "", vBiDON = "";
            List<GDTTT_DON_DUONGSU_CC> lsDS = null;
            lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DONID_old).ToList();
            if (lsDS.Count > 0)
            {
                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_DON_DUONGSU_CC objBC = new GDTTT_DON_DUONGSU_CC();
                    objBC.VUANID = 0;
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
                    dt.GDTTT_DON_DUONGSU_CC.Add(objBC);
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
                dt.SaveChanges();
            }
        }
        protected void ADD_BICAO_DON(Decimal donid, Decimal VUANID_OLD)
        {
            //de lay ra Nguyen don và Bi don tu Don
            string bican_dauvu = "", toidanh = "";
            List<GDTTT_VUAN_DUONGSU> lsDS = null;
            lsDS = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == VUANID_OLD).ToList();
            if (lsDS.Count > 0)
            {
                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_DON_DUONGSU_CC objBC = new GDTTT_DON_DUONGSU_CC();
                    objBC.VUANID = VUANID_OLD;
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
                    dt.GDTTT_DON_DUONGSU_CC.Add(objBC);
                    dt.SaveChanges();
                    //Danh sach ten bi cao dau vu
                    if (lsDS[i].HS_BICANDAUVU == 1)
                    {
                        if (bican_dauvu != "")
                            bican_dauvu += (String.IsNullOrEmpty(bican_dauvu)) ? "" : ", ";
                        bican_dauvu += lsDS[i].TENDUONGSU;
                        toidanh += ((string.IsNullOrEmpty(toidanh + "")) ? "" : ", ") + lsDS[i].HS_TENTOIDANH;
                    }
                    List<GDTTT_VUAN_DUONGSU_TOIDANH> loTD_DON = null;
                    decimal vDuongsuid_old = Convert.ToDecimal(lsDS[i].ID);

                    loTD_DON = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.DUONGSUID == vDuongsuid_old).ToList();

                    for (int j = 0; j < loTD_DON.Count; j++)
                    {
                        GDTTT_DON_DUONGSU_TOIDANH_CC oDSva = new GDTTT_DON_DUONGSU_TOIDANH_CC();
                        oDSva.DONID = donid;
                        oDSva.VUANID = VUANID_OLD;//id vu an moi
                        oDSva.DUONGSUID = objBC.ID;// id Duong su moi
                        oDSva.TOIDANHID = loTD_DON[j].TOIDANHID;
                        oDSva.TENTOIDANH = loTD_DON[j].TENTOIDANH;
                        dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Add(oDSva);
                        dt.SaveChanges();
                    }
                    //Update nguoi Khieu Nai mơi sinh ra vao bang DS-KN
                    if (lsDS[i].HS_ISKHIEUNAI == 1)
                    {
                        //Kiem tra Nguoi khieu nai nay co Khieu nai cho bi cao nao khong
                        List<GDTTT_VUAN_DS_KN> oNKNCC = dt.GDTTT_VUAN_DS_KN.Where(x => x.NGUOIKHIEUNAIID == vDuongsuid_old).ToList();
                        foreach (GDTTT_VUAN_DS_KN ist in oNKNCC)
                        {
                            ist.DON_NGUOIKHIEUNAI_NEW = objBC.ID;
                            dt.SaveChanges();
                        }
                    }
                    //Update Bi cao được khiếu nại mới Sinh ra ở Vu an vào Bảng  GDTTT_DON_DS_KN_CC để xác định Bị Cáo được khiếu nại
                    GDTTT_VUAN_DS_KN odKNCC = dt.GDTTT_VUAN_DS_KN.Where(x => x.BICAOID == vDuongsuid_old).FirstOrDefault();
                    if (odKNCC != null)
                    {
                        odKNCC.DON_BICAO_NEW = objBC.ID;
                        dt.SaveChanges();
                    }
                }
                //Them duong su khieu nai vào bang GDTTT_VUAN_DS_KN
                GDTTT_VUAN_DUONGSU oDSKN_DON = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == VUANID_OLD && x.HS_ISKHIEUNAI == 1).FirstOrDefault() ?? new GDTTT_VUAN_DUONGSU();
                if (oDSKN_DON != null)
                {
                    List<GDTTT_DON_DS_KN_CC> lsDSKN = dt.GDTTT_DON_DS_KN_CC.Where(x => x.NGUOIKHIEUNAIID == oDSKN_DON.ID).ToList();
                    for (int k = 0; k < lsDSKN.Count; k++)
                    {
                        GDTTT_DON_DS_KN_CC obDSKN = new GDTTT_DON_DS_KN_CC();
                        obDSKN.DONID = donid;
                        //ID người khiếu nại đang sai cần lấy ID mới của người khiếu lại
                        obDSKN.NGUOIKHIEUNAIID = lsDSKN[k].VUAN_NGUOIKHIEUNAI_NEW;
                        obDSKN.BICAOID = lsDSKN[k].VUAN_BICAO_NEW;
                        obDSKN.NOIDUNGKHIEUNAI = lsDSKN[k].NOIDUNGKHIEUNAI;
                        dt.GDTTT_DON_DS_KN_CC.Add(obDSKN);
                        dt.SaveChanges();
                    }
                }
                dt.SaveChanges();
            }
        }
        protected void ADD_BICAO_DON_FROM_DON(Decimal donid, Decimal DONID_OLD)
        {
            //de lay ra Nguyen don và Bi don tu Don
            string bican_dauvu = "", toidanh = "";
            List<GDTTT_DON_DUONGSU_CC> lsDS = null;
            lsDS = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DONID_OLD).ToList();
            if (lsDS.Count > 0)
            {
                for (int i = 0; i < lsDS.Count; i++)
                {
                    GDTTT_DON_DUONGSU_CC objBC = new GDTTT_DON_DUONGSU_CC();
                    objBC.VUANID = 0;
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
                    dt.GDTTT_DON_DUONGSU_CC.Add(objBC);
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
                        GDTTT_DON_DUONGSU_TOIDANH_CC oDSva = new GDTTT_DON_DUONGSU_TOIDANH_CC();
                        oDSva.DONID = donid;
                        oDSva.VUANID = 0;//id vu an moi
                        oDSva.DUONGSUID = objBC.ID;// id Duong su moi
                        oDSva.TOIDANHID = loTD_DON[j].TOIDANHID;
                        oDSva.TENTOIDANH = loTD_DON[j].TENTOIDANH;
                        dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Add(oDSva);
                        dt.SaveChanges();
                    }
                    //Update nguoi Khieu Nai mơi sinh ra vao bang DS-KN
                    //if (lsDS[i].HS_ISKHIEUNAI == 1)
                    //{
                    //    //Kiem tra Nguoi khieu nai nay co Khieu nai cho bi cao nao khong
                    //    List<GDTTT_DON_DS_KN_CC> oNKNCC = dt.GDTTT_DON_DS_KN_CC.Where(x => x.NGUOIKHIEUNAIID == vDuongsuid_old).ToList();
                    //    if (hddDontrungID.Value == "" && hddDontrungID.Value == "0")
                    //    {
                    //        foreach (GDTTT_DON_DS_KN_CC ist in oNKNCC)
                    //        {
                    //            ist.NGUOIKHIEUNAIID = objBC.ID;
                    //            dt.SaveChanges();
                    //        }
                    //    }
                    //}
                    //Update Bi cao được khiếu nại mới Sinh ra ở Vu an vào Bảng  GDTTT_DON_DS_KN_CC để xác định Bị Cáo được khiếu nại
                    //GDTTT_DON_DS_KN_CC odKNCC = dt.GDTTT_DON_DS_KN_CC.Where(x => x.BICAOID == vDuongsuid_old).FirstOrDefault();
                    //if (hddDontrungID.Value == "" && hddDontrungID.Value == "0")
                    //{
                    //    if (odKNCC != null)
                    //    {
                    //        odKNCC.BICAOID = objBC.ID;
                    //        dt.SaveChanges();
                    //    }
                    //}
                }
                //Them duong su khieu nai vào bang GDTTT_VUAN_DS_KN
                GDTTT_DON_DUONGSU_CC oDSKN_DON = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == DONID_OLD && x.HS_ISKHIEUNAI == 1).FirstOrDefault() ?? new GDTTT_DON_DUONGSU_CC();
                if (oDSKN_DON != null)
                {
                    List<GDTTT_DON_DS_KN_CC> lsDSKN = dt.GDTTT_DON_DS_KN_CC.Where(x => x.NGUOIKHIEUNAIID == oDSKN_DON.ID).ToList();
                    for (int k = 0; k < lsDSKN.Count; k++)
                    {
                        GDTTT_DON_DS_KN_CC obDSKN = new GDTTT_DON_DS_KN_CC();
                        obDSKN.DONID = donid;
                        //ID người khiếu nại đang sai cần lấy ID mới của người khiếu lại
                        obDSKN.NGUOIKHIEUNAIID = lsDSKN[k].VUAN_NGUOIKHIEUNAI_NEW;
                        obDSKN.BICAOID = lsDSKN[k].VUAN_BICAO_NEW;
                        obDSKN.NOIDUNGKHIEUNAI = lsDSKN[k].NOIDUNGKHIEUNAI;
                        dt.GDTTT_DON_DS_KN_CC.Add(obDSKN);
                        dt.SaveChanges();
                    }
                }
                dt.SaveChanges();
            }
        }
        protected void cmdCheckTrungDon_Click(object sender, EventArgs e)
        {
            lstMsgT.Text = lstMsgB.Text = ""; lstMsg_dontrung.Text = string.Empty;
            Load_DonTrung();
            //if (trDSTrung.Visible == false)
            //    txtSohieudon.Focus();
            //else
            //    dgListTrung.Focus();
        }
        protected void cmdHuyTrungDon_Click(object sender, EventArgs e)
        {
            hddDontrungID_Huy.Value = hddDontrungID.Value;
            hddDontrungID.Value = "0";
            txtTenDonTrung.Text = "";
            cmdCheckTrungDon.Visible = true;
            cmdHuyTrungDon.Visible = false;
            lstMsg_dontrung.Text = string.Empty;
            Huy_DonTrung_Check();
            //txtTenDonTrung.Enabled = true;
            //cmdCheckTrungDon.Visible = true;
            //cmdHuyTrungDon.Visible = false;
            //////-----------------
            ////manhnd bo do TANDTC khong nhap NGUYENDON - BIDON
            //Decimal Don_ID = 0;

            //if (Session["DONID_CC"] + "" != "" && Session["DONID_CC"] + "" != null)
            //{
            //    Don_ID = Convert.ToDecimal(Session["DONID_CC"] + "");
            //    XOA_ND_BD_NKN(Don_ID);
            //    dt.SaveChanges();
            //    if (ddlLoaiAn.SelectedValue == "01")
            //    {
            //        LoadDropNguoiKhieuNai();
            //        LoadDropBiCao();
            //        LoadDanhSachBiCao();
            //    }
            //    else
            //    {
            //        LoadDsDuongSu(rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            //        LoadDsDuongSu(rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
            //        LoadDsDuongSu(rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            //    }
            //}
            //ResetControls_huydontrung();
            ////-------------
            //string current_id = Request["ID"] + "";
            //decimal ID = Convert.ToDecimal(current_id);
            //ThuLy_load(ID, true);
        }
        protected void XOA_ND_BD_NKN(Decimal ID)
        {
            List<GDTTT_DON_DUONGSU_TOIDANH_CC> lst = dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Where(x => x.DONID == ID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (GDTTT_DON_DUONGSU_TOIDANH_CC item in lst)
                    dt.GDTTT_DON_DUONGSU_TOIDANH_CC.Remove(item);
            }
            List<GDTTT_DON_DS_KN_CC> lkn = dt.GDTTT_DON_DS_KN_CC.Where(x => x.DONID == ID).ToList();
            if (lkn != null && lkn.Count > 0)
            {
                foreach (GDTTT_DON_DS_KN_CC item in lkn)
                    dt.GDTTT_DON_DS_KN_CC.Remove(item);
            }
            List<GDTTT_DON_DUONGSU_CC> lds = dt.GDTTT_DON_DUONGSU_CC.Where(x => x.DONID == ID).ToList();
            if (lds != null && lds.Count > 0)
            {
                foreach (GDTTT_DON_DUONGSU_CC item in lds)
                    dt.GDTTT_DON_DUONGSU_CC.Remove(item);
            }
        }

        #region "Phân trang đơn trùng"
        protected void lbTBackDT_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonTrung.CurrentPageIndex = Convert.ToInt32(hddPageIndexDT.Value) - 2;
                hddPageIndexDT.Value = (Convert.ToInt32(hddPageIndexDT.Value) - 1).ToString();
                LoadDSTrung();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTFirstDT_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonTrung.CurrentPageIndex = 0;
                hddPageIndexDT.Value = "1";
                LoadDSTrung();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTLastDT_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonTrung.CurrentPageIndex = Convert.ToInt32(hddTotalPageDT.Value) - 1;
                hddPageIndexDT.Value = Convert.ToInt32(hddTotalPageDT.Value).ToString();
                LoadDSTrung();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTNextDT_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonTrung.CurrentPageIndex = Convert.ToInt32(hddPageIndexDT.Value);
                hddPageIndexDT.Value = (Convert.ToInt32(hddPageIndexDT.Value) + 1).ToString();
                LoadDSTrung();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTStepDT_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgDSDonTrung.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndexDT.Value = lbCurrent.Text;
                LoadDSTrung();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        #endregion
        #region "Phân trang đơn Thụ lý trùng TP từ đơn"
        protected void lbTBackTLL_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonTLL.CurrentPageIndex = Convert.ToInt32(hddPageIndexTLL.Value) - 2;
                hddPageIndexTLL.Value = (Convert.ToInt32(hddPageIndexTLL.Value) - 1).ToString();
                LoadDSTLL();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTFirstTLL_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonTLL.CurrentPageIndex = 0;
                hddPageIndexTLL.Value = "1";
                LoadDSTLL();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTLastTLL_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonTLL.CurrentPageIndex = Convert.ToInt32(hddTotalPageTLL.Value) - 1;
                hddPageIndexTLL.Value = Convert.ToInt32(hddTotalPageTLL.Value).ToString();
                LoadDSTLL();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTNextTLL_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonTLL.CurrentPageIndex = Convert.ToInt32(hddPageIndexTLL.Value);
                hddPageIndexTLL.Value = (Convert.ToInt32(hddPageIndexTLL.Value) + 1).ToString();
                LoadDSTLL();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTStepTLL_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgDSDonTLL.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndexTLL.Value = lbCurrent.Text;
                LoadDSTLL();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        #endregion
        #region "Phân trang đơn kèm theo"
        protected void lbTBackDKT_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonKemTheo.CurrentPageIndex = Convert.ToInt32(hddPageIndexDKT.Value) - 2;
                hddPageIndexDKT.Value = (Convert.ToInt32(hddPageIndexDKT.Value) - 1).ToString();
                LoadDSKemTheo();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTFirstDKT_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonKemTheo.CurrentPageIndex = 0;
                hddPageIndexDKT.Value = "1";
                LoadDSKemTheo();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTLastDKT_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonKemTheo.CurrentPageIndex = Convert.ToInt32(hddTotalPageDKT.Value) - 1;
                hddPageIndexDKT.Value = Convert.ToInt32(hddTotalPageDKT.Value).ToString();
                LoadDSKemTheo();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTNextDKT_Click(object sender, EventArgs e)
        {
            try
            {
                dgDSDonKemTheo.CurrentPageIndex = Convert.ToInt32(hddPageIndexDKT.Value);
                hddPageIndexDKT.Value = (Convert.ToInt32(hddPageIndexDKT.Value) + 1).ToString();
                LoadDSKemTheo();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        protected void lbTStepDKT_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgDSDonKemTheo.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndexDKT.Value = lbCurrent.Text;
                LoadDSKemTheo();
            }
            catch (Exception ex) { lstMsgT.Text = lstMsgB.Text = ex.Message; }
        }
        #endregion
        protected void ddlToaXetXu_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlToaXetXu.SelectedValue != "0")
            {
                decimal ToaAnID = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();

                //31/10/2025 restore code tu nhanh Gtel_TPBac3_gscm_app_git
                bool isToaCapTinh = false;
                List<DM_TOAAN> lstToaancaptinh = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPTINH") && x.HIEULUC == 1).ToList();
                List<DM_TOAAN> lstToaancapcao = dt.DM_TOAAN.Where(x => (x.LOAITOA == "CAPCAO") && x.HIEULUC == 1).ToList();

                foreach (DataGridItem item in dgTBTLD.Items)
                {
                    DropDownList ddlToaAn = (DropDownList)item.FindControl("ddlToaAn");
                    foreach (DM_TOAAN item1 in lstToaancaptinh)
                    {
                        if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item1.ID)
                        {
                            isToaCapTinh = true;
                        }
                    }
                    foreach (DM_TOAAN item2 in lstToaancapcao)
                    {
                        if (Convert.ToDecimal(ddlToaAn.SelectedValue) == item2.ID)
                        {
                            isToaCapTinh = false;
                        }
                    }
                }
                bool isTPB3 = false;
                decimal idPB = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();

                if (oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", idPB).Rows.Count > 0)
                {
                    isTPB3 = true;
                }
                lblalert.Text = "";
                lblThamquyen.Visible = false;

                bool checkLoaiThamQuyen = true;
                string current_id = Request["ID"] + "";
                if (current_id != "" && current_id != "0")
                {
                    decimal ID = Convert.ToDecimal(current_id);
                    GDTTT_DON don = dt.GDTTT_DON.FirstOrDefault(x => x.ID == ID);
                    if (don != null && don.THAMPHANID != null && don.THAMPHANID > 0) checkLoaiThamQuyen = false;
                }

                //đã phân công thẩm phán thì không gợi ý loại thẩm quyền đơn nữa
                if (checkLoaiThamQuyen)
                {
                    if ((oTA.LOAITOA == "CAPTINH" & !chkKN_TBTLD.Checked & isTPB3) || ((oTA.LOAITOA == "CAPHUYEN" || oTA.LOAITOA == "QSKHUVUC") & chkKN_TBTLD.Checked & isToaCapTinh & isTPB3))
                    {
                        rdbThamquyen.SelectedValue = "1";
                        lblThamquyen.Text = "Dựa trên thông tin đơn, đây là đơn dành cho thẩm phán bậc 3";
                        lblThamquyen.Visible = true;

                        List_thamphan.Visible = true;
                        LoadThamphan_Tongan();
                    }
                    else
                    {
                        rdbThamquyen.SelectedValue = "0";
                        lblThamquyen.Text = "Dựa trên thông tin đơn, đây là đơn dành cho thẩm phán tối cao";
                        lblThamquyen.Visible = true;
                        
                        List_thamphan.Visible = false;
                    }
                }

                if (oTA.LOAITOA == "CAPHUYEN")
                {
                    LoadCapXetXu(ENUM_GIAIDOANVUAN.SOTHAM);
                    load_pn_st_pt();
                    ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.SOTHAM.ToString();
                    //-------
                    pnPhucTham.Visible = pnAnST.Visible = false;
                }
                else if (oTA.LOAITOA == "CAPTINH")
                {
                    //LoadCapXetXu(ENUM_GIAIDOANVUAN.PHUCTHAM);
                    LoadCapXetXu(ENUM_GIAIDOANVUAN.THULYGDT);
                    load_pn_st_pt();
                    ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.PHUCTHAM.ToString();
                    //-------
                    pnPhucTham.Visible = false;
                    pnAnST.Visible = true;
                    LoadDropToaST_TheoPT(Convert.ToDecimal(ddlToaXetXu.SelectedValue));
                }
                else if (oTA.LOAITOA == "CAPCAO")
                {
                    LoadCapXetXu(ENUM_GIAIDOANVUAN.THULYGDT);
                    load_pn_st_pt();
                    if (ddlCapXetXu.SelectedValue == "4")
                    {
                        ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.PHUCTHAM.ToString();

                        pnPhucTham.Visible = false;
                        pnAnST.Visible = true;
                        LoadDropToaST_TheoPT(Convert.ToDecimal(ddlToaXetXu.SelectedValue));
                    }
                    else if (ddlCapXetXu.SelectedValue == "3")
                    {
                        ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.THULYGDT.ToString();

                        pnPhucTham.Visible = pnAnST.Visible = true;
                        LoadDropToaPT_TheoGDT(Convert.ToDecimal(ddlToaXetXu.SelectedValue));
                        LoadDropToaST_Full_ST();
                    }
                    else
                    {
                        ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.PHUCTHAM.ToString();

                        pnPhucTham.Visible = false;
                        pnAnST.Visible = true;
                        LoadDropToaST_TheoPT(Convert.ToDecimal(ddlToaXetXu.SelectedValue));
                    }
                }
                else if (oTA.LOAITOA == "TOICAO")
                {
                    LoadCapXetXu(ENUM_GIAIDOANVUAN.THULYGDT);
                    load_pn_st_pt();
                    ddlCapXetXu.SelectedValue = ENUM_GIAIDOANVUAN.THULYGDT.ToString();
                    //-------
                    pnPhucTham.Visible = pnAnST.Visible = true;
                    LoadDropToaPT_TheoGDT(Convert.ToDecimal(ddlToaXetXu.SelectedValue));
                    LoadDropToaST_Full_ST();
                }
            }
            Cls_Comon.SetFocus(this, this.GetType(), ddlToaXetXu.ClientID);
        }

        protected void dgTBTLD_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Xoa":
                    try
                    {
                        decimal TBID = Convert.ToDecimal(e.CommandArgument.ToString());
                        decimal DonID = Convert.ToDecimal(hddID.Value);
                        GDTTT_DON_TBTLD oTB = dt.GDTTT_DON_TBTLD.Where(x => x.ID == TBID).FirstOrDefault();
                        dt.GDTTT_DON_TBTLD.Remove(oTB);
                        dt.SaveChanges();
                        LoadTBTLD(DonID);
                    }
                    catch (Exception ex)
                    { }
                    break;
            }
        }

        private void chkIsNotGDTChange()
        {
            if (chkIsNotGDT.Checked || rdbLoaichuyen.SelectedValue != "0")
            {
                spSOBA.Visible = spSOKN.Visible = spTOAXX.Visible = spNGBA.Visible = spNGKN.Visible = false;
            }
            else
            {
                spSOBA.Visible = spSOKN.Visible = spTOAXX.Visible = spNGBA.Visible = spNGKN.Visible = true;
            }
        }
        protected void chkIsNotGDT_CheckedChanged(object sender, EventArgs e)
        {
            chkIsNotGDTChange();
            Cls_Comon.SetFocus(this, this.GetType(), txtSoQDBA.ClientID);
        }

        protected void chkIsTuHinh_CheckedChanged(object sender, EventArgs e)
        {
            if (chkIsTuHinh.Checked)
            {
                chkIsAnGiam.Visible = true;
                chkKeuOan.Visible = true;
            }
            else
            {
                chkIsAnGiam.Visible = false;
                chkKeuOan.Visible = false;
                chkIsAnGiam.Checked = chkKeuOan.Checked = false;
            }
        }
        private void LoadIsTuHinh(string strLoaiAn)
        {

            if (strLoaiAn == ENUM_LOAIVUVIEC.AN_HINHSU && (ddlHinhthucdon.SelectedValue == "1"
                                                            || ddlHinhthucdon.SelectedValue == "11"
                                                            || ddlHinhthucdon.SelectedValue == "31"
                                                            || ddlHinhthucdon.SelectedValue == "3"
                                                            || ddlHinhthucdon.SelectedValue == "6"
                                                            || ddlHinhthucdon.SelectedValue == "9"
                                                            || ddlHinhthucdon.SelectedValue == "7"))
            {
                trTuHinh.Visible = true;

            }
            else
            {
                trTuHinh.Visible = false;
                chkIsAnGiam.Visible = false;
                chkKeuOan.Visible = false;
                chkIsTuHinh.Checked = chkIsAnGiam.Checked = chkKeuOan.Checked = false;
            }

        }

        protected void dgDS_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BOSUNG oT = dt.GDTTT_DON_BOSUNG.Where(x => x.ID == ID).FirstOrDefault();
                    dt.GDTTT_DON_BOSUNG.Remove(oT);
                    dt.SaveChanges();
                    string current_id = Request["ID"] + "";
                    LoadBoSungTL(Convert.ToDecimal(current_id));
                    break;
            }
        }
        protected void cmdThugon_Click(object sender, EventArgs e)
        {
            trDSTrung.Visible = false;
        }
        //-----------------------------
        private void LoadDiaChiGui()
        {
            ddl_DIACHI_GUI_BT_ID.Items.Clear();
            List<DM_HANHCHINH> lstTinhHuyen;
            if (Session["DMTINHHUYEN"] == null)
                lstTinhHuyen = dt.DM_HANHCHINH.OrderBy(x => x.ARRTHUTU).ToList();
            else
                lstTinhHuyen = (List<DM_HANHCHINH>)(Session["DMTINHHUYEN"]);
            ddl_DIACHI_GUI_BT_ID.DataSource = lstTinhHuyen;
            ddl_DIACHI_GUI_BT_ID.DataTextField = "MA_TEN";
            ddl_DIACHI_GUI_BT_ID.DataValueField = "ID";
            ddl_DIACHI_GUI_BT_ID.DataBind();
            ddl_DIACHI_GUI_BT_ID.Items.Insert(0, new ListItem("---Tỉnh/Huyện---", "0"));
        }
        protected void ddlTraloi_VB_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlTraloi_VB.SelectedValue == "1")
                pnCV_traloi_VB.Visible = true;
            else
                pnCV_traloi_VB.Visible = false;
            Cls_Comon.SetFocus(this, this.GetType(), ddlTraloi_VB.ClientID);
        }
        protected void ddlCAChidao_VB_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlCAChidao_VB.SelectedValue == "0")
            {
                trChidao_VB.Visible = false;
            }
            else
            {
                trChidao_VB.Visible = true;
            }
        }
        //-----------------------------
        protected void SetLoaiAnFrom_vt()
        {
            //Lưu session
            if (Request["vt_id"] + "" != "")
            {
                VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
                DataTable tbl = obj_M.VT_VANBANDEN_LOAD_BYID(Session[ENUM_SESSION.SESSION_DONVIID] + "", Request["vt_id"] + "");
                ddlLoaiAn.SelectedValue = "0" + tbl.Rows[0]["LOAI_AN_DON"] + "";
            }
        }

        protected void cmdXoaTL_Click(object sender, EventArgs e)
        {
            decimal vdon_id = Convert.ToDecimal(Request["ID"]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == vdon_id).FirstOrDefault();
            if (oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3)
            {
                //Don Thụ lý trùng TP 
                if (oT.ARR_DON_ID > 0 && oT.CD_TA_TRANGTHAI == 0)
                {
                    string strMsg = "Đơn Thụ lý mới trùng TP phải hủy trùng để xóa thụ lý!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                    return;
                }
                else
                {
                    //kiem tra xem co don thu ly moi trung TP khong
                    List<GDTTT_DON> lst = dt.GDTTT_DON.Where(x => x.ARR_DON_ID == vdon_id && x.ISTHULY == 1).ToList();
                    if (lst.Count() > 0)
                    {
                        string strMsg = "Có đơn Thụ lý mới trùng TP phải hủy trùng để xóa thụ lý!";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                        return;
                    }
                    else
                    {
                        MP_Add.Show();
                    }
                }
            }
            else
            {
                string strMsg = "Đơn đã chuyển không được phép xóa thụ lý!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                return;
            }

        }
        protected void cmdXuLyLai_Click(object sender, EventArgs e)
        {
            decimal vdon_id = Convert.ToDecimal(Request["ID"]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == vdon_id).FirstOrDefault();
            String strMsg = "";
            if (oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3)
            {
                //Don Thụ lý trùng TP 
                if (oT.ARR_DON_ID > 0 && oT.CD_TA_TRANGTHAI == 0)
                {
                     strMsg = "Đơn Thụ lý mới trùng TP phải hủy trùng để xóa thụ lý!";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                    return;
                }
                //26/01/2026 chặn do: văn phòng kiện mất thẩm phán, tờ trình, thông báo phân công
                if(oT.THAMPHANID>0)
                {
                     strMsg = "Bạn phải xóa phân công Thẩm phán";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                    return;
                }
                if (oBL.CHECK_SOVB_DON("SoTT", CurrDonViID, PhongBanID, vdon_id) > 0)
                {
                    strMsg = "Bạn phải xóa tờ trình thẩm phán";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }
                if (oBL.CHECK_SOVB_DON("TBTP", CurrDonViID, PhongBanID, vdon_id) > 0)
                {
                    strMsg = "Bạn phải xóa thông báo phân công thẩm phán";
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                    return;
                }
                else
                {
                    //kiem tra xem co don thu ly moi trung TP khong
                    List<GDTTT_DON> lst = dt.GDTTT_DON.Where(x => x.ARR_DON_ID == vdon_id && x.ISTHULY == 1).ToList();
                    if (lst.Count() > 0)
                    {
                         strMsg = "Có đơn Thụ lý mới trùng TP phải hủy trùng để xóa thụ lý!";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                        return;
                    }
                    else
                    {                        
                        if (oBL.DELETE_XuLyLai_DONTLM_GDTTT(vdon_id, UserName) == true)
                        {
                            strMsg = "Xóa thành công!";
                            txtSoThuLy.Text = null;
                            txtNgaythuly.Text = null;
                            rdbThuLy.SelectedValue = "2";
                            rdbThuLy.Enabled = true;
                            pnThuLy.Visible = false;
                            cmdXoaTL.Visible = cmdXuLyLai.Visible = false;
                            AnHienkhiXoathulydon(vdon_id.ToString());
                        }
                        else
                        {
                            strMsg = "Xóa Không thành công!";
                        }
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                    }
                }

            }
            else
            {
                strMsg = "Đơn đã chuyển không được phép xóa!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                return;
            }
        }
        #region popup them moi
        protected void btnUp_XoaThuLy_Click(object sender, EventArgs e)
        {
            try
            {
                if (CheckData() == false)
                {
                    return;
                }

                decimal vdon_id = Convert.ToDecimal(Request["ID"]);
                GDTTT_DON objNoiDung = dt.GDTTT_DON.Where(x => x.ID == vdon_id).First();

                string jsonString = JsonConvert.SerializeObject(objNoiDung);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                string strMsg;
                if (oBL.DELETE_SOTHULY_GDTTT_DON(vdon_id, txt_XOATHULY.Text, UserName, jsonString) == true)
                {
                    strMsg = "Xóa số thụ lý thành công!";
                    txtSoThuLy.Text = null;
                    txtNgaythuly.Text = null;
                    rdbThuLy.SelectedValue = "2";
                    cmdXoaTL.Visible = cmdXuLyLai.Visible = false;
                    AnHienkhiXoathulydon(vdon_id.ToString());
                }
                else
                {
                    strMsg = "Xóa số thụ lý Không thành công!";
                }

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                MP_Add.Hide();
            }
            catch (Exception ex)
            {
                lbtthongbao_popup.Text = "Lỗi: " + ex.Message;
            }
        }

        private bool CheckData()
        {

            if (txt_XOATHULY.Text.Trim() == "")
            {
                lbtthongbao_popup.Text = "Bạn chưa nhập Lý do xóa thụ lý";
                Cls_Comon.SetFocus(this.txt_XOATHULY, this.GetType(), txt_XOATHULY.ClientID);
                return false;
            }
            return true;
        }

        private void AnHienkhiXoathulydon(string vdonid)
        {
            try
            {
                if (vdonid != "" && vdonid != "0")
                {
                    decimal donID = Convert.ToDecimal(vdonid);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == donID).FirstOrDefault();
                    if (oT.ISTHULY == 1)
                    {
                        if (oT.CD_TRANGTHAI == 4)
                        {

                            Cls_Comon.SetButton(cmdXoaTL, false);
                            Cls_Comon.SetButton(cmdXuLyLai, false);

                        }
                        else if (oT.CD_TRANGTHAI == 3)
                        {//tra lại để sửa thì chỉ được xóa thụ lý
                            Cls_Comon.SetButton(cmdXoaTL, true);
                            Cls_Comon.SetButton(cmdXuLyLai, false);
                        }
                        else
                        {
                            Cls_Comon.SetButton(cmdXoaTL, true);
                            Cls_Comon.SetButton(cmdXuLyLai, true);
                        }

                        ddlHinhthucdon.Enabled = false;
                        ddlTrangthaidon.Enabled = false;
                        ddlChuyendenDV.Enabled = false;
                        ddlLoaiAn.Enabled = false;
                        rdbLoaichuyen.Enabled = false;
                        rdbThuLy.Enabled = false;
                        txtSoThuLy.Enabled = txtNgaythuly.Enabled = false;
                    }
                    else
                    {
                        Cls_Comon.SetButton(cmdXoaTL, false);
                        Cls_Comon.SetButton(cmdXuLyLai, false);
                        //cmdXoaTL.Visible = cmdXuLyLai.Visible = false;
                        ddlHinhthucdon.Enabled = true;
                        ddlTrangthaidon.Enabled = true;
                        ddlChuyendenDV.Enabled = true;
                        ddlLoaiAn.Enabled = true;
                        rdbLoaichuyen.Enabled = true;
                        rdbThuLy.Enabled = true;
                        pnThuLy.Visible = false;
                    }
                }
                else
                {
                    //An nut Xoa thu ly va xu ly lai khi chua lưu don
                    //cmdXoaTL.Visible = cmdXuLyLai.Visible = false;
                    Cls_Comon.SetButton(cmdXoaTL, false);
                    Cls_Comon.SetButton(cmdXuLyLai, false);
                }
            }
            catch (Exception ex) { }
        }
        protected void dgDSDonTLL_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                String CD_TRANGTHAI = ((DataRowView)e.Item.DataItem)["CD_TRANGTHAI"].ToString();
                if (CD_TRANGTHAI == "4")
                {
                    cmdXoa.Visible = false;
                }
                else
                {
                    cmdXoa.Visible = true;
                }
            }
        }
        protected void dgDSDonKemTheo_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                String CD_TRANGTHAI = ((DataRowView)e.Item.DataItem)["CD_TRANGTHAI"].ToString();
                if (CD_TRANGTHAI == "4")
                {
                    cmdXoa.Visible = false;
                }
                else
                {
                    cmdXoa.Visible = true;
                }
            }
        }
        #endregion
        protected void ddlHinhthucdonChange_set_pnBAQDGDT()
        {
            if (ddlHinhthucdon.SelectedValue == "8" || ddlHinhthucdon.SelectedValue == "10")
            {
                pnBAQDGDT.Visible = false;
            }
            else
            {
                pnBAQDGDT.Visible = true;
            }
        }
        //20/12/2024 chi mo ra de test 
        //protected void load_temp_suadulieu()
        //{
        //    rdbLoaichuyen.Visible = true;
        //    rdbLoaichuyen.Enabled = true;
        //    cmdUpdateB.Enabled = true;
        //    //noi bo
        //    rdbThuLy.Enabled = true;
        //    lblSoThuly.Text = "Số thụ lý";
        //    lblNgaythuly.Text = "Ngày thụ lý";
        //    spSOBA.Visible = spSOKN.Visible = spTOAXX.Visible = spNGBA.Visible = spNGKN.Visible = true;
        //    pnToakhac.Visible = false;
        //    pnNgoaitoaan.Visible = false;
        //    pnTralaidon.Visible = false;
        //    pnBAQDGDT.Visible = true;
        //    pnKNTCDoituong.Visible = false;
        //}

        private void LoadInfoCC(decimal ID, bool isLoadTrung)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            string strType = Request["type"] + "";
            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                //Them ngay xu ly don
                //if (oT.NGAYXULYDON != null)
                //{
                //    if (((DateTime)oT.NGAYXULYDON).ToString("dd/MM/yyyy") == "01/01/0001")
                //        txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
                //    else
                //        txtNgayXuLy.Text = ((DateTime)oT.NGAYXULYDON).ToString("dd/MM/yyyy");
                //}
                //else
                //    txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");


                if (oT.LOAIDON != null)
                {
                    ddlHinhthucdon.SelectedValue = oT.LOAIDON.ToString();
                    ddlHinhthucdon_kntc.SelectedValue = oT.LOAIDON.ToString();
                }
                ddlHinhthucdonChange();
                LoadPhongban();
                if (ddlHinhthucdon_kntc.SelectedValue != "8" && ddlHinhthucdon_kntc.SelectedValue != "10")
                {
                    ChuyendenDVChange(0);
                    LoadLoaiAn();
                }
                //setLoaichuyen();

                ddl_LOAI_GDTTT.SelectedValue = Convert.ToString(oT.LOAI_GDTTTT);
                if (oT.BAQD_CAPXETXU == 2)
                    pnPhucTham.Visible = pnAnST.Visible = false;
                else if (oT.BAQD_CAPXETXU == 3)
                {
                    pnPhucTham.Visible = false;
                    pnAnST.Visible = true;
                }
                else
                {
                    pnPhucTham.Visible = pnAnST.Visible = true;
                }

                //if (oT.CD_TRANGTHAI > 0 && oT.CD_TRANGTHAI != 3 && oT.CD_TRANGTHAI != 4 && isLoadTrung == false)
                //{
                //    Cls_Comon.SetButton(cmdUpdate, false);
                //    Cls_Comon.SetButton(cmdUpdateAndNew, false);
                //    Cls_Comon.SetButton(cmdUpdateB, false);
                //    Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                //}
                rdbLoaichuyen.SelectedValue = "0";


                ddlHinhthucdonChange_set_pnBAQDGDT();
                if (pnBAQDGDT.Visible)
                {
                    rdbBAQD.SelectedValue = oT.BAQD_LOAIQDBA.ToString();
                    if (rdbBAQD.SelectedValue == "1")
                    {
                        pnSoKhangNghi.Visible = true;

                        if (oT.BAQD_CAPXETXU == 4)
                        {
                            pnAnST.Visible = pnPhucTham.Visible = pnSoBA.Visible = true;
                        }
                        else if (oT.BAQD_CAPXETXU == 3)
                        {
                            pnPhucTham.Visible = pnSoBA.Visible = true;
                            pnAnST.Visible = false;
                        }
                        else if (oT.BAQD_CAPXETXU == 2)
                        {
                            pnAnST.Visible = true;
                            pnPhucTham.Visible = pnSoBA.Visible = false;
                        }
                        else
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                        }

                        if (oT.BAQD_CAPXETXU == 4)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                        }
                        if (oT.BAQD_CAPXETXU >= 3)
                        {
                            txtSoBA_PT.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_PT.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_PT > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnPT, oT.BAQD_TOAANID_PT);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                            }
                        }
                        if (oT.BAQD_CAPXETXU >= 2)
                        {
                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_ST > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                            }
                        }


                        txtSoQDKN.Text = oT.KN_SOQD;
                        txtNgayKhangNghi.Text = oT.KN_NGAY + "" == "" ? "" : ((DateTime)oT.KN_NGAY).ToString("dd/MM/yyyy");
                        if (oT.NGUOIKHANGNGHI != null)
                            ddlNguoiKhangNghi.SelectedValue = oT.NGUOIKHANGNGHI + "";
                    }
                    //else if (rdbBAQD.SelectedValue == "0")
                    //{

                    //}
                    else
                    {
                        rdbBAQD.SelectedValue = "0";
                        pnSoKhangNghi.Visible = false;
                        pnSoBA.Visible = true;
                        if (oT.BAQD_CAPXETXU == 4)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }


                            txtSoBA_PT.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_PT.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_PT > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnPT, oT.BAQD_TOAANID_PT);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                            }

                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID_ST > 0)
                            {
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                            }
                        }
                        else if (oT.BAQD_CAPXETXU == 3)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO_PT;
                            if (oT.BAQD_NGAYBA_PT != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA_PT).ToString("dd/MM/yyyy");
                            }

                            //if (ddlToaXetXu.Items.FindByValue(oT.BAQD_TOAANID_PT + "") != null)
                            //    ddlToaXetXu.SelectedValue = oT.BAQD_TOAANID_PT + "";
                            if (oT.BAQD_TOAANID_PT > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID_PT);
                                LoadDropToaST_TheoPT(Convert.ToDecimal(oT.BAQD_TOAANID_PT));
                            }

                            txtSoBA_ST.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA_ST.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }


                            if (oT.BAQD_TOAANID_ST > 0)
                                Cls_Comon.SetValueComboBox(dropToaAnST, oT.BAQD_TOAANID_ST);
                        }
                        else if (oT.BAQD_CAPXETXU == 2)
                        {
                            txtSoQDBA.Text = oT.BAQD_SO_ST;
                            if (oT.BAQD_NGAYBA_ST != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA_ST).ToString("dd/MM/yyyy");
                            }


                            if (ddlToaXetXu.Items.FindByValue(oT.BAQD_TOAANID_ST + "") != null)
                                ddlToaXetXu.SelectedValue = oT.BAQD_TOAANID_ST + "";
                        }
                        else
                        {
                            txtSoQDBA.Text = oT.BAQD_SO;
                            if (oT.BAQD_NGAYBA != null)
                            {
                                if (((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") != "01/01/0001")
                                    txtNgayBA.Text = ((DateTime)oT.BAQD_NGAYBA).ToString("dd/MM/yyyy");
                            }

                            if (oT.BAQD_TOAANID > 0)
                            {
                                Cls_Comon.SetValueComboBox(ddlToaXetXu, oT.BAQD_TOAANID);
                                LoadDropToaPT_TheoGDT(Convert.ToDecimal(oT.BAQD_TOAANID));
                            }
                        }
                    }

                    if (oT.KN_TRALOIDON != null)
                        chkKN_TBTLD.Checked = oT.KN_TRALOIDON == 1 ? true : false;
                    if (chkKN_TBTLD.Checked)
                    {
                        trThongbaoTLD.Visible = true;

                    }

                    if (ddlCapXetXu.Items.FindByValue(oT.BAQD_CAPXETXU + "") != null)
                        ddlCapXetXu.SelectedValue = oT.BAQD_CAPXETXU + "";
                    else
                        ddlCapXetXu.SelectedValue = "0";

                }
                else
                {
                    string strPhanloai = oT.ARRPHANLOAI + "";
                    foreach (ListItem i in chkPhanloai.Items)
                    {
                        if (("," + strPhanloai + ",").Contains("," + i.Value + ","))
                            i.Selected = true;
                    }
                    txtDoituongbiKN.Text = oT.DOITUONGBIKNTC;
                    rdbLoaiKNTC.SelectedValue = oT.LOAIKNTC + "";
                }
                if (ddlTraloi.Items.FindByValue(oT.TRALOIDON + "") != null)
                    ddlTraloi.SelectedValue = oT.TRALOIDON + "";

                if (oT.TRALOIDON == 1)
                {
                    if (ddlTraloi.SelectedValue == "1")
                        pnCV_traloi.Visible = true;
                    else
                        pnCV_traloi.Visible = false;
                    txtCV_Traloi_Noidung.Text = oT.CV_TRALOI_NOIDUNG;
                }
                else
                {
                    txtCV_Traloi_Noidung.Text = "";
                }
                txtMaDon.Text = oT.MADON;
                txtNguoigui.Text = oT.NGUOIGUI_HOTEN;
                txtSoCMND.Text = oT.NGUOIGUI_CMND;
                txtSoDienThoai.Text = oT.NGUOIGUI_DIENTHOAI;
                if (oT.NGUOIGUI_GIOITINH != null)
                    ddlGioitinh.SelectedValue = oT.NGUOIGUI_GIOITINH.ToString();
                txtNgaynhandon.Text = oT.NGAYNHANDON == null ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy");
                txtNgayghidon.Text = oT.NGAYGHITRENDON == null ? "" : ((DateTime)oT.NGAYGHITRENDON).ToString("dd/MM/yyyy");
                txtSohieudon.Text = oT.SOHIEUDON;

                //if (oT.LOAIDON != null)
                //    ddlHinhthucdon.SelectedValue = oT.LOAIDON.ToString();

                if (oT.DUNGDONLA != null)
                    ddlDungdonla.SelectedValue = oT.DUNGDONLA.ToString();
                if (oT.NGUOIGUI_TUCACHTOTUNG != null)
                    ddlTucachTT.SelectedValue = oT.NGUOIGUI_TUCACHTOTUNG.ToString();

                if (oT.NGUOIGUI_HUYENID != null && oT.NGUOIGUI_HUYENID != 0)
                {
                    try
                    {
                        DM_HANHCHINH oDCHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.NGUOIGUI_HUYENID).FirstOrDefault();
                        hddNGDCID.Value = oDCHuyen.ID.ToString();
                        txtNGHuyen.Text = oDCHuyen.MA_TEN;
                    }
                    catch (Exception ex) { }
                }
                txtDiachi.Text = oT.NGUOIGUI_DIACHI;
                txtNoidung.Text = oT.NOIDUNGDON;
                txtGhichu.Text = oT.GHICHU + "";
                if (oT.ISNOTGDTTT == 1)
                {
                    chkIsNotGDT.Checked = true;
                    chkIsNotGDTChange();

                }
                if (oT.ISGDTTT_KNTC == 1) chkGDTIsKNTC.Checked = true;
                lblTucach.Visible = ddlTucachTT.Visible = true;
                if (ddlHinhthucdon.SelectedValue == "3" || ddlHinhthucdon.SelectedValue == "31"
                    || ddlHinhthucdon.SelectedValue == "2" || ddlHinhthucdon.SelectedValue == "6" || ddlHinhthucdon.SelectedValue == "9"
                    || ddlHinhthucdon.SelectedValue == "10")
                // Loại đơn + công văn
                {
                    //Load cac loai cong van
                    LoadDropLoaiCongVan();
                    if (ddlLoaiCongVan.Items.FindByValue(oT.LOAICONGVAN + "") != null)
                        ddlLoaiCongVan.SelectedValue = oT.LOAICONGVAN + "";
                    ChangeLoaiCV();

                    decimal IDLoai = Convert.ToDecimal(ddlLoaiCongVan.SelectedValue);
                    DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();

                    if (oLoai.MA == ENUM_GDT_LOAICV.NHACLAI)// công văn nhắc lại
                    {
                        pnCongVanNhacLai.Visible = true;
                        txtCongVan.Text = oT.CV_NHACLAITEXT;
                        hddNhaclaiCVID.Value = oT.CV_NHACLAIID == null ? "0" : oT.CV_NHACLAIID.ToString();
                    }
                    else
                    {
                        pnCongVanNhacLai.Visible = false;
                    }
                    chkIsTrongNganh.Checked = oT.CV_ISTRONGNGANH == 1 ? true : false;
                    if (chkIsTrongNganh.Checked)
                    {
                        pnDonViGuiTrongNganh.Visible = true;
                        pnDonViGuiNgoaiNganh.Visible = false;
                        ddlCV_Donvi.SelectedValue = oT.CV_TOAANID + "";
                        // chkTraigiam.Visible = false;
                    }
                    else
                    {
                        chkTraigiam.Checked = oT.CV_ISTRAIGIAM == 1 ? true : false;
                        pnDonViGuiTrongNganh.Visible = false;
                        pnDonViGuiNgoaiNganh.Visible = true;
                        txtCV_DonViGuiNgoaiNganh.Text = oT.CV_TENDONVI;
                        // chkTraigiam.Visible = true;
                        if (chkTraigiam.Checked) lblTraigiamhientai.Visible = txtTraigiamhientai.Visible = true;

                    }
                    txtTraigiamhientai.Text = oT.CV_TRAIGIAMHIENTAI + "";
                    if (oT.CV_HUYENID != null)
                    {
                        try
                        {
                            DM_HANHCHINH oCVHuyen = dt.DM_HANHCHINH.Where(x => x.ID == oT.CV_HUYENID).FirstOrDefault();
                            hddCVDCID.Value = oCVHuyen.ID.ToString();
                            txtCVDC.Text = oCVHuyen.MA_TEN;
                        }
                        catch (Exception ex) { }
                    }
                    txtCVDiachi.Text = oT.CV_DIACHI + "";
                    txtCV_So.Text = oT.CV_SO;
                    txtCV_Ngay.Text = oT.CV_NGAY + "" == "" ? "" : ((DateTime)oT.CV_NGAY).ToString("dd/MM/yyyy");
                    txtCV_Nguoiky.Text = oT.CV_NGUOIKY;
                    txtCV_Chucvu.Text = oT.CV_CHUCVU;
                    pnCongvan.Visible = true;


                }
                if (oT.PHANLOAIXULY != null)
                {
                    //ddlPhanloai.SelectedValue = oT.PHANLOAIXULY.ToString();
                }
                if (ddlPhanloai.SelectedValue == "04")
                {
                    ddlTrangthaidon.SelectedValue = "1";
                    lblLydoCDDK.Text = "Lý do";
                    chkLydoCDDK.Visible = true;
                }
                ddlHinhthucdonChange();
                if (ddlPhanloai.SelectedValue == "2" || ddlPhanloai.SelectedValue == "3")//Đơn trùng hoặc đơn khiếu nại
                {
                    txtSoLuongDon.Text = oT.SOLUONGDON + "";
                }

                if (isLoadTrung)
                {
                    ddlPhanloai.SelectedValue = "3";
                    hddDontrungID.Value = oT.ID.ToString();
                    //txtTenDonTrung.Text = "Số hiệu: " + oT.SOHIEUDON + ";Người gửi: " + oT.NGUOIGUI_HOTEN + "";
                    lstMsg_dontrung.Text = "Số hiệu: " + oT.SOHIEUDON + "; người gửi: " + oT.NGUOIGUI_HOTEN;
                    txtTenDonTrung.Enabled = false;
                    cmdCheckTrungDon.Visible = false;
                    cmdHuyTrungDon.Visible = true;
                }
                if (oT.CV_YEUCAUTHONGBAO != null) ddlYeucauthongbao.SelectedValue = oT.CV_YEUCAUTHONGBAO.ToString();

                if (oT.CHIDAO_COKHONG != null)
                {
                    if (oT.CHIDAO_COKHONG == 1)
                    {

                        trChidao.Visible = true;
                        if (oT.CHIDAO_LANHDAOID != null)
                            ddlCAChidao.SelectedValue = oT.CHIDAO_LANHDAOID + "";
                        txtCA_Noidung.Text = oT.CHIDAO_NOIDUNG + "";

                    }
                    else
                        ddlCAChidao.SelectedValue = "0";
                }
                divCommandT.Visible = divCommandB.Visible = true;
                List<GDTTT_DON_NGUOIKN> lstKN = dt.GDTTT_DON_NGUOIKN.Where(x => x.DONID == oT.ID).OrderBy(y => y.HOTEN).ToList();
                ddlSonguoiKN.SelectedValue = lstKN.Count.ToString();
                dgNguoiKN.DataSource = lstKN;
                dgNguoiKN.DataBind();
                //////////////////
                // LoadDSKemTheo_to_table();
                getTable_load();
                if (chkKN_TBTLD.Checked)
                {
                    LoadTBTLD(oT.ID);
                }
                if (ddlHinhthucdon.SelectedValue == "4")
                {
                    try
                    {
                        Load_CAChidao_kn();
                        txtSOKN.Text = oT.SO_HSKN;
                        txt_NGAYQDKN.Text = oT.NGAY_HSKN + "" == "" ? "" : ((DateTime)oT.NGAY_HSKN).ToString("dd/MM/yyyy");
                        drop_DONVICHUYEN_HSKN.SelectedValue = Convert.ToString(oT.DONVICHUYEN_HSKN);
                        txtNgaynhandon_kn.Text = oT.NGAYNHANDON + "" == "" ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy").Replace("01/01/0001", "");
                        if (oT.CHIDAO_COKHONG != null)
                        {
                            if (oT.CHIDAO_COKHONG == 1)
                            {
                                trChidao_kn.Style.Remove("Display");
                                if (oT.CHIDAO_LANHDAOID != null)
                                    ddlCAChidao_kn.SelectedValue = oT.CHIDAO_LANHDAOID + "";
                                txtCA_Noidung_kn.Text = oT.CHIDAO_NOIDUNG + "";
                            }
                            else
                            {
                                ddlCAChidao_kn.SelectedValue = "0";
                                trChidao_kn.Style.Add("Display", "none");
                            }
                        }
                        txt_GHICHU_HS.Text = oT.GHICHU;
                    }
                    catch (Exception ex) { String mess = ex.Message; }
                }


                //setLoaichuyenCC();
                //Lưu session
                if (Request["vt_id"] + "" != "")
                {
                    VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
                    DataTable tbl = obj_M.VT_VANBANDEN_LOAD_BYID(Session[ENUM_SESSION.SESSION_DONVIID] + "", Request["vt_id"] + "");
                    ddlChuyendenDV.SelectedValue = tbl.Rows[0]["CD_TA_DONVIID"] + "";
                    LoadLoaiAn();
                    ddlLoaiAn.SelectedValue = "0" + tbl.Rows[0]["LOAI_AN_DON"] + "";
                    if (txtNgaynhandon.Text == "01/01/0001")
                    {
                        txtNgaynhandon.Text = "";
                    }
                    //txtNgaynhandon.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    rdbThuLy.SelectedValue = "1";
                }

            }
            load_lable_ba_qd();
        }

        private void setLoaichuyenCC()
        {//Ngay xu ly don là ngay hệ thống
            if (hddIDCC.Value != "0")
            {
                decimal ID = Convert.ToDecimal(hddIDCC.Value);
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                if (oT.CD_LOAI != Convert.ToDecimal(rdbLoaichuyen.SelectedValue))
                    txtNgayXuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }

            spSOBA.Visible = spSOKN.Visible = spTOAXX.Visible = spNGBA.Visible = spNGKN.Visible = false;
            pnNoibo_vb.Visible = false;
            switch (rdbLoaichuyen.SelectedValue)
            {
                case "0":
                    spSOBA.Visible = spSOKN.Visible = spTOAXX.Visible = spNGBA.Visible = spNGKN.Visible = true;
                    pnToakhac.Visible = false;
                    pnNgoaitoaan.Visible = false;
                    pnTralaidon.Visible = false;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    decimal IDPhongBan = 0;
                    if (ddlHinhthucdon.SelectedValue == "5")
                    {
                        pnNoibo.Visible = false;
                        IDPhongBan = Convert.ToDecimal(ddlChuyendenDV_VB.SelectedValue);
                        pnNoibo_vb.Visible = true;
                        spSOBA.Visible = false; spNGBA.Visible = false; spTOAXX.Visible = false;
                    }
                    else
                    {
                        pnNoibo.Visible = true;
                        IDPhongBan = Convert.ToDecimal(ddlChuyendenDV.SelectedValue);
                        pnNoibo_vb.Visible = false;
                        spSOBA.Visible = true; spNGBA.Visible = true; spTOAXX.Visible = true;
                    }
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == IDPhongBan).OrderBy(x => x.THUTU).FirstOrDefault();
                    if (oPB.ISGIAIQUYETDON == 1)
                    {

                        trTrangthaidon.Visible = true;
                        pnBAQDGDT.Visible = true;
                        pnKNTCDoituong.Visible = false;

                        ddlLoaiAn.Visible = true;
                        chkGDTIsKNTC.Visible = true;
                        lblLoaiAn.Visible = true;
                        if (ddlTrangthaidon.SelectedValue == "0")
                        {
                            if (rdbThuLy.SelectedValue != "2")
                                pnThuLy.Visible = true;
                            else
                                pnThuLy.Visible = false;
                        }
                        else
                            pnThuLy.Visible = false;
                    }
                    else
                    {
                        pnThuLy.Visible = false;
                        trTrangthaidon.Visible = false;
                        pnBAQDGDT.Visible = false;
                        pnKNTCDoituong.Visible = true;

                        ddlLoaiAn.Visible = false;
                        chkGDTIsKNTC.Visible = false;
                        lblLoaiAn.Visible = false;
                    }
                    if (ddlHinhthucdon.SelectedValue != "5" && ddlHinhthucdon.SelectedValue != "8" && ddlHinhthucdon.SelectedValue != "10")
                    {
                        KN_BiCao.Style.Remove("Display");
                    }
                    break;
                case "1":
                    pnNoibo.Visible = false;
                    pnToakhac.Visible = true;
                    pnNgoaitoaan.Visible = false;
                    pnTralaidon.Visible = false;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    lblLoaiAn.Visible = true;
                    chkGDTIsKNTC.Visible = true;
                    KN_BiCao.Style.Add("Display", "none");
                    break;
                case "2":
                    pnNoibo.Visible = false;
                    pnToakhac.Visible = false;
                    pnNgoaitoaan.Visible = true;
                    pnTralaidon.Visible = false;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    chkGDTIsKNTC.Visible = true;
                    KN_BiCao.Style.Add("Display", "none");
                    break;
                case "3":
                    pnNoibo.Visible = false;
                    pnToakhac.Visible = false;
                    pnNgoaitoaan.Visible = false;
                    pnTralaidon.Visible = true;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    chkGDTIsKNTC.Visible = true;
                    KN_BiCao.Style.Add("Display", "none");
                    break;
                default:
                    pnNoibo.Visible = false;
                    pnToakhac.Visible = false;
                    pnNgoaitoaan.Visible = false;
                    pnTralaidon.Visible = false;
                    pnBAQDGDT.Visible = true;
                    pnKNTCDoituong.Visible = false;
                    chkGDTIsKNTC.Visible = true;
                    KN_BiCao.Style.Add("Display", "none");
                    break;
            }
        }
        protected void txtNgayThuLy_TextChanged(object sender, EventArgs e)
        {
            LoadThamphan_Tongan();
        }
        private void LoadThamphan_Tongan()
        {
            int vNam = txtNgaythuly.Text.toSysDate()?.Year ?? 0;
            GDTTT_DON_BL oDSTPBL = new GDTTT_DON_BL();
            DataTable dsTP = oDSTPBL.DS_ThamPhan_TongAN(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(ddlChuyendenDV.SelectedValue), vNam, null);
            List_thamphan.DataSource = dsTP;
            List_thamphan.DataBind();
        }
    }
}