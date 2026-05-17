using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;
using BL.GSTP.GDTTT;
using System.Text;
using BL.GSTP.Danhmuc;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class DanhsachPH : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        Decimal trangthai_trinh_id = 0, PhongBanID = 0, CurrDonViID;
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
        String SessionInBC = "GDTTTVA_INBC_VISIBLE";
        String SessionSearch = "TTTKVISIBLE";
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            //---------------------------
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
                    {
                        Session["V_COLUME"] = "NGAYTHULYDON";
                        Session["V_ASC_DESC"] = "DESC";
                    }
                    //---------------------------
                    LoadDropBox();
                    SetGetSessionTK(false);
                    //-------------------------------
                    //Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    //if (LoginDonViID == 1)
                    //{
                    //    pnSearchCC.Visible = false;
                    //    txtNgayBA_Tu.Text = txtNgayBA_Den.Text = string.Empty;
                    //}
                    //else
                    //    pnSearchCC.Visible = true;

                    if (Session[SS_TK.NGUYENDON] != null)
                        Load_Data();
                }
                if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                {
                    lblLoaidon.Visible = true;
                    ddlloaidon.Visible = true;
                }
                LoadHinhThucGui();
            }
            else
                Response.Redirect("/Login.aspx");
        }
        private void SetGetSessionTK(bool isSet)
        {
            try
            {
                if (isSet)
                {
                    Session[SS_TK.TOAANXX] = ddlToaXetXu.SelectedValue;
                    Session[SS_TK.SOBAQD] = txtSoQDBA.Text;
                    Session[SS_TK.NGAYBAQD] = txtNgayBAQD.Text;
                    Session[SS_TK.NGUYENDON] = txtNguyendon.Text;
                    Session[SS_TK.BIDON] = txtBidon.Text;
                    Session[SS_TK.LOAIAN] = ddlLoaiAn.SelectedValue;
                    Session[SS_TK.THAMTRAVIEN] = ddlThamtravien.SelectedValue;
                    Session[SS_TK.LANHDAOPHUTRACH] = ddlPhoVuTruong.SelectedValue;
                    Session[SS_TK.THAMPHAN] = ddlThamphan.SelectedValue;
                    Session[SS_TK.NGUOIGUI] = txtNguoiguidon.Text;
                    Session[SS_TK.COQUANCHUYENDON] = "";// txtCoquanchuyendon.Text;

                    Session[SS_TK.TRALOIDON] = ddlTraloi.SelectedValue;

                    Session[SS_TK.LOAICV] = ddlLoaiCV.SelectedValue;
                    Session[SS_TK.THULY_TU] = txtThuly_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtThuly_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
                    Session[SS_TK.MUONHOSO] = ddlMuonHoso.SelectedValue;
                    Session[SS_TK.TRANGTHAITHULY] = ddlTrangthaithuly.SelectedValue;
                    Session[SS_TK.KETQUATHULY] = ddlKetquaThuLy.SelectedValue;
                    Session[SS_TK.KETQUAXETXU] = ddlKetquaXX.SelectedValue;
                    Session[SS_TK.BUOCTT] = dropBuocTT.SelectedValue;
                    Session[SS_TK.CHK_CONLAI_S] = chk_conlai.Checked;

                    string vArrSelectID = "";
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon != null && chkChon.Checked)
                        {
                            if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                            else vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                        }
                    }
                    if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";
                    Session[SS_TK.ARRSELECTID] = vArrSelectID;

                    Session[SS_TK.ANQUOCHOI_THOIHIEU] = dropAnDB.SelectedValue;

                    Session[SS_TK.ANTHOIHIEU] = dropAnDB_TH.SelectedValue;
                    Session[SS_TK.HOAN_THIHAHAN] = dropHoanTHA.SelectedValue + "";
                    Session[SS_TK.TRANGTHAITOTRINH] = ddlTotrinh.SelectedValue + "";
                    Session[SS_TK.TRANGTHAIYKIENTT] = dropIsYKienKetLuatTrinhLD.SelectedValue + "";

                }
                else
                {
                    int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                    if (IsHome == 1)
                    {
                        txtSoQDBA.Text = Session[SS_TK.SOBAQD] + "";
                        txtNgayBAQD.Text = Session[SS_TK.NGAYBAQD] + "";
                        if (Session[SS_TK.TOAANXX] != null) ddlToaXetXu.SelectedValue = Session[SS_TK.TOAANXX] + "";
                        txtNguyendon.Text = Session[SS_TK.NGUYENDON] + "";
                        txtBidon.Text = Session[SS_TK.BIDON] + "";
                        if (Session[SS_TK.LOAIAN] != null)
                            ddlLoaiAn.SelectedValue = Session[SS_TK.LOAIAN] + "";
                        if (Session[SS_TK.THAMTRAVIEN] != null) ddlThamtravien.SelectedValue = Session[SS_TK.THAMTRAVIEN] + "";
                        if (Session[SS_TK.LANHDAOPHUTRACH] != null)
                            ddlPhoVuTruong.SelectedValue = Session[SS_TK.LANHDAOPHUTRACH] + "";
                        if (Session[SS_TK.THAMPHAN] != null)
                            ddlThamphan.SelectedValue = Session[SS_TK.THAMPHAN] + "";

                        txtNguoiguidon.Text = Session[SS_TK.NGUOIGUI] + "";
                        if (Session[SS_TK.TRALOIDON] != null)
                            ddlTraloi.SelectedValue = Session[SS_TK.TRALOIDON] + "";
                        if (Session[SS_TK.LOAICV] != null)
                            ddlLoaiCV.SelectedValue = Session[SS_TK.LOAICV] + "";

                        txtThuly_Tu.Text = Session[SS_TK.THULY_TU] + "";
                        txtThuly_Den.Text = Session[SS_TK.THULY_DEN] + "";
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";


                        if (Session[SS_TK.KETQUAXETXU] != null)
                            ddlKetquaXX.SelectedValue = Session[SS_TK.KETQUAXETXU] + "";

                        if (Session[SS_TK.MUONHOSO] != null)
                            ddlMuonHoso.SelectedValue = Session[SS_TK.MUONHOSO] + "";

                        if (ddlMuonHoso.SelectedValue != "2")
                            ddlKetquaThuLy.SelectedValue = "4";
                        else if (ddlMuonHoso.SelectedValue == "0")
                            ddlTrangthaithuly.SelectedValue = "1";
                        if (Session[SS_TK.KETQUATHULY] != null)
                            ddlKetquaThuLy.SelectedValue = Session[SS_TK.KETQUATHULY] + "";
                        //---------------------------------
                        if (Session[SS_TK.TRANGTHAITOTRINH] != null)
                            ddlTotrinh.SelectedValue = Session[SS_TK.TRANGTHAITOTRINH] + "";

                        //--------------------------------------------------
                        dropIsYKienKetLuatTrinhLD.SelectedValue = Session[SS_TK.TRANGTHAIYKIENTT] + "";
                        //dropBuocTT.SelectedValue = "1";
                        dropBuocTT.SelectedValue = Session[SS_TK.BUOCTT] + "";
                        if (Session[SS_TK.TRANGTHAITHULY] != null)
                            ddlTrangthaithuly.SelectedValue = Session[SS_TK.TRANGTHAITHULY] + "";
                        if (ddlTrangthaithuly.SelectedValue != "0")
                        {
                            lttYKienKetLuan.Visible = dropIsYKienKetLuatTrinhLD.Visible = true;
                            lttBuocTT.Visible = dropBuocTT.Visible = true;
                            //if (Convert.ToDecimal(ddlTrangthaithuly.SelectedValue) > 3)
                            //    dropBuocTT.SelectedValue = "1";
                            //else
                            //    dropBuocTT.SelectedValue = "0";
                        }
                        if (ddlTrangthaithuly.SelectedValue == "3")
                        {
                            ddlMuonHoso.SelectedValue = "1";
                            ddlKetquaThuLy.SelectedValue = "4";
                            ddlTotrinh.SelectedValue = "0";
                        }
                        dropDangKyBC.SelectedValue = (String.IsNullOrEmpty(Session[SS_TK.ISDANGKYBAOCAO] + "")) ? "2" : Session[SS_TK.ISDANGKYBAOCAO].ToString();
                        if (dropDangKyBC.SelectedValue != "2")
                        {
                            dropDangKyBC.Enabled = true;
                            dropCapTrinhTiepTheo.Enabled = true;
                        }
                        //--------------------------------------------------
                        dropAnDB.SelectedValue = (String.IsNullOrEmpty(Session[SS_TK.ANQUOCHOI_THOIHIEU] + "")) ? "0" : Session[SS_TK.ANQUOCHOI_THOIHIEU] + "";
                        dropHoanTHA.SelectedValue = Session[SS_TK.HOAN_THIHAHAN] + "";
                        dropAnDB_TH.SelectedValue = Session[SS_TK.ANTHOIHIEU] + "";
                        dropTypeHDTP.SelectedValue = (String.IsNullOrEmpty(Session[SS_TK.XXGDT_HDTP] + "")) ? "0" : Session[SS_TK.XXGDT_HDTP].ToString();
                        //----------------
                        chk_conlai.Checked = Convert.ToBoolean(Session[SS_TK.CHK_CONLAI_S] + "");

                    }
                }
            }
            catch (Exception ex) { }
        }
        private void LoadDropBox()
        {
            //Loại án
            LoadDropLoaiAn();

            LoadDropToaAn();

            //Load loại công văn
            LoadDropLoaiCV();

            //Load Thẩm phán
            try
            {
                LoadDropThamphan();
            }
            catch (Exception ex) { }
            //Lãnh đạo
            try {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (oPer.DULIEU == true)
                    LoadDropLanhDao();
                else
                {
                    LoadAll_TTV();
                    Load_AllLanhDao();
                }

            } catch (Exception ex) { }

            //Trình trạng thụ lý
            LoadDrop_TinhTrangThuLy();

            //-------------------------------           
            LoadDRopKetQuaXX_GDTTT();
            LoadDropKQThuLyDon();
            LoadDropTypeHoiDongTP();
        }
        void LoadDropTypeHoiDongTP()
        {
            dropTypeHDTP.Items.Clear();
            dropTypeHDTP.Items.Add(new ListItem("---Tất cả----", "0"));

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
            {
                lttTypeHDTP.Visible = dropTypeHDTP.Visible = true;

                dropTypeHDTP.Items.Add(new ListItem("Chủ tọa", "3"));
                dropTypeHDTP.Items.Add(new ListItem("HĐTT", "1"));
                dropTypeHDTP.Items.Add(new ListItem("HĐ5", "2"));
            }
            else
            {
                lttTypeHDTP.Visible = dropTypeHDTP.Visible = false;
            }
        }

        void LoadDropKQThuLyDon()
        {
            ddlKetquaThuLy.Items.Clear();
            ddlKetquaThuLy.Items.Add(new ListItem("--Tất cả--", "3"));
            ddlKetquaThuLy.Items.Add(new ListItem("Tòa án giải quyết đơn", "7"));
            ddlKetquaThuLy.Items.Add(new ListItem("..Chưa có kết quả", "4"));
            ddlKetquaThuLy.Items.Add(new ListItem("..Đã có kết quả", "5"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Trả lời đơn", "0"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Kháng nghị(CA)", "1"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Xếp đơn", "2"));
            ddlKetquaThuLy.Items.Add(new ListItem("...VKS đang nghiên cứu", "8"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Giải quyết khác", "6"));
            ddlKetquaThuLy.Items.Add(new ListItem("Kháng nghị VKSTC chuyển sang", "-2"));
            ddlKetquaThuLy.Items.Add(new ListItem("Kháng nghị(CA + VKS)", "-1"));
            ddlKetquaThuLy.SelectedValue = "3";
            //if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
        }
        void LoadDrop_TinhTrangThuLy()
        {

            decimal[] kq = { 13, 14, 16, 18 };
            List<GDTTT_DM_TINHTRANG> lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1 && !kq.Contains(x.ID)).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
            SetName_Vu_Phongban(lst);//anhvh add 05/04/2011 add check name phong ban cap cao
            ddlTrangthaithuly.DataSource = lst;
            ddlTrangthaithuly.DataTextField = "TENTINHTRANG";
            ddlTrangthaithuly.DataValueField = "ID";
            ddlTrangthaithuly.DataBind();
            ddlTrangthaithuly.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            ddlTrangthaithuly.SelectedValue = "0"; //Da phan cong TTV

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
            {
                int count_lst = lst.Count;
                ddlTrangthaithuly.Items.Insert(count_lst + 1, new ListItem("Báo cáo PCA, Tổ TP, CA, Hội đồng TP", "-1"));
            }

            lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1
                                                && x.ID >= 6 && x.ID != 10).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
            SetName_Vu_Phongban(lst);//anhvh add
            dropCapTrinhTiepTheo.DataSource = lst;
            dropCapTrinhTiepTheo.DataTextField = "TENTINHTRANG";
            dropCapTrinhTiepTheo.DataValueField = "ID";
            dropCapTrinhTiepTheo.DataBind();
            dropCapTrinhTiepTheo.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        public List<GDTTT_DM_TINHTRANG> SetName_Vu_Phongban(List<GDTTT_DM_TINHTRANG> lst)
        {
            decimal PBID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            foreach (GDTTT_DM_TINHTRANG its in lst)
            {

                if (PBID == 2 || PBID == 3 || PBID == 4)//vụ giám đốc kiểm tra
                {
                    if (its.MA == "04")
                    {
                        its.TENTINHTRANG = "Phó Vụ trưởng";
                    }
                    else if (its.MA == "05")
                    {
                        its.TENTINHTRANG = "Vụ trưởng";
                    }
                    else if (its.MA == "10")
                    {
                        its.TENTINHTRANG = "Báo cáo Hội đồng thẩm phán";
                    }
                }
                else
                {
                    if (its.MA == "04")
                    {
                        its.TENTINHTRANG = "Trưởng phòng";
                    }
                    else if (its.MA == "05")
                    {
                        its.TENTINHTRANG = "Phó trưởng phòng";
                    }
                    else if (its.MA == "10")
                    {
                        its.TENTINHTRANG = "Báo cáo Ủy ban thẩm phán";
                    }
                }
            }
            return lst;
        }
        void LoadDropToaAn()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
        }
        void LoadDropLoaiCV()
        {
            DM_DATAITEM_BL cvBL = new DM_DATAITEM_BL();
            DataTable tbl = cvBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAICVGDTTT);
            if (tbl.Rows.Count > 0)
            {
                ddlLoaiCV.DataSource = tbl;
                ddlLoaiCV.DataTextField = "MA_TEN";
                ddlLoaiCV.DataValueField = "ID";
                ddlLoaiCV.DataBind();
            }
            ddlLoaiCV.Items.Insert(0, new ListItem("Tất cả trừ 8.1", "-1"));
            ddlLoaiCV.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        void LoadDropLanhDao()
        {
            decimal CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
            QT_NHOMNGUOIDUNG oGroup = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CurrNhomNSDID).Single();
            int loai_hotro_db = (int)oGroup.LOAI;

            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            decimal chucdanh_id = (string.IsNullOrEmpty(oCB.CHUCDANHID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCDANHID);
            decimal chucvu_id = (string.IsNullOrEmpty(oCB.CHUCVUID + "")) ? 0 : Convert.ToDecimal(oCB.CHUCVUID);
            if (chucvu_id > 0)
            {
                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucvu_id).FirstOrDefault();
                if (oCD.MA == ENUM_CHUCVU.CHUCVU_PVT)
                {
                    ddlPhoVuTruong.Items.Clear();
                    ddlPhoVuTruong.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));

                    hddLoaiTK.Value = ENUM_CHUCVU.CHUCVU_PVT;
                    //----------------------
                    LoadDropTTV_TheoLanhDao();
                }
                else
                {
                    Load_AllLanhDao();
                    // 042 la Pho truong phong quyen nhu TTV 
                    if (oCD.MA == "TTV" || oCD.MA == "TTVCC" || oCD.MA == "TTVC"
                    || oCD.MA == "TK1" || oCD.MA == "TK" || oCD.MA == "TKA" || oCD.MA == "C027"
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009"|| oCD.MA == "042")
                    {
                        ddlThamtravien.Items.Clear();
                        ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                    }
                    else
                        LoadAll_TTV();
                }
            }
            else if (chucdanh_id > 0)
            {
                Load_AllLanhDao();

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == chucdanh_id).Single();
                if (oCD.MA == "TTV" || oCD.MA == "TTVCC" || oCD.MA == "TTVC"
                    || oCD.MA == "TK1" || oCD.MA == "TK" || oCD.MA == "TKA" || oCD.MA == "C027"
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009")
                {
                    ddlThamtravien.Items.Clear();
                    ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                }
                else
                    LoadAll_TTV();
            }
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

        void LoadAll_TTV()
        {
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            int count = 0;
            //-----------------
            Decimal ChucDanh_TPTATC = 0;
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            DataTable tblTheoPB = new DataTable();
            if (oCB.CHUCDANHID == ChucDanh_TPTATC)
            {
                tblTheoPB = oGDTBL.GDTTT_Getall_TTV_TheoTP(LoginDonViID, oCB.ID);
            }
            else
            {
                tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
            }
            if (tblTheoPB != null && tblTheoPB.Rows.Count > 0)
            {
                count = tblTheoPB.Rows.Count;
                ddlThamtravien.DataSource = tblTheoPB;
                ddlThamtravien.DataTextField = "HOTEN";
                ddlThamtravien.DataValueField = "ID";
                ddlThamtravien.DataBind();
            }
            ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            ddlThamtravien.Items.Insert(count + 1, new ListItem("--- Khác ---", "-1"));
        }

        void LoadDropTTV_TheoLanhDao()
        {
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PhongBanID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            ddlThamtravien.Items.Clear();
            Decimal LanhDaoID = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            try
            {
                DM_CANBO_BL obj = new DM_CANBO_BL();
                DataTable tbl = new DataTable();
                tbl = obj.DM_CANBO_PB_CHUCDANH(PhongBanID, "TTV", LanhDaoID, 0, 1, 200000);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    ddlThamtravien.DataSource = tbl;
                    ddlThamtravien.DataTextField = "HOTEN";
                    ddlThamtravien.DataValueField = "CanBoID";
                    ddlThamtravien.DataBind();
                    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
            }
            catch (Exception ex)
            { }
        }
        //----------------------------------------
        void LoadDRopKetQuaXX_GDTTT()
        {
            ddlKetquaXX.Items.Clear();

            ddlKetquaXX.Items.Add(new ListItem("--- Tất cả ---", "0"));
            ddlKetquaXX.Items.Add(new ListItem("Chưa xét xử", "-1"));
            ddlKetquaXX.Items.Add(new ListItem("Đã xét xử", "-2"));

            DM_DATAITEM_BL oDMBL = new DM_DATAITEM_BL();
            DataTable tbl = oDMBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.KETLUANGDTTT);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    ddlKetquaXX.Items.Add(new ListItem("..." + row["MA_TEN"] + "", row["ID"] + ""));
            }
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
                    DataTable tbl = oGDTBL.GDTTT_Tp_Duoc_Phutrach(Session[ENUM_SESSION.SESSION_DONVIID] + "", Convert.ToInt32(oCB.ID));
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
                //DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCB.CHUCDANHID == ChucDanh_TPTATC || oCB.CHUCDANHID == ChucDanh_TPCC)
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
                //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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
            chk_conlai.Visible = false;
            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                Decimal CurrChucVuID = string.IsNullOrEmpty(oCB.CHUCVUID + "") ? 0 : (decimal)oCB.CHUCVUID;

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCD.MA == "TPTATC" || oCD.MA == "TPCC")
                {
                    chk_conlai.Visible = true;
                    oCD = dt.DM_DATAITEM.Where(x => x.ID == CurrChucVuID).FirstOrDefault();
                    if (oCD != null)
                    {
                        if (oCD.MA == "CA")
                            IsLoadAll = true;
                        else if (oCD.MA == "PCA")
                        {
                            // IsLoadAll = true;
                            LoadLoaiAnPhuTrach(oCB);
                            //anhvh bỏ comment LoadLoaiAnPhuTrach(oCB); theo yêu cầu của vanvt dùng cho trường hợp của PCA Nguyễn Văn Du
                        }
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
                        //dgList.Columns[6].Visible = false;
                        //dgList.Columns[5].HeaderText = "Bị cáo";
                        lblTitleBC.Text = "Bị cáo";
                        lblTitleBD.Visible = txtBidon.Visible = false;
                        tblQHPL.Text = "Tội danh";
                    }
                    LoadLoaiAnPhuTrach_TheoPB(obj);
                }
            }

            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            if (ddlLoaiAn.Items.Count > 1)
            {
                //anhvh add 05/04/2021 check loai an nếu tồn tại án hình sự thì không insert lựa chọn tất cả
                Boolean check_add = true;
                foreach (ListItem li in ddlLoaiAn.Items)
                {
                    if (li.Value == "01")
                    {
                        check_add = false;
                        break;
                    }
                }
                if (check_add == true)
                {
                    ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
            }
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

        //-----------------------------------------
        private void Load_Data()
        {
            dgList.Visible = dgListHS.Visible = false;
            lbtthongbao.Text = "";
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = getDS(page_size, pageindex);
            int count_all = 0;
            int sumTLM = 0;

            if (oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                DataTable oDT2 = getDS(10000, pageindex);
                for (int i = 0; i < oDT2.Rows.Count; i++)
                {
                    sumTLM = Convert.ToInt32(oDT2.Rows[i]["cThulymoi"]) + sumTLM;
                }
            }

            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án " + "<b>(" + sumTLM + " đơn TLM)</b> trong <b>" + hddTotalPage.Value + "</b> trang";
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
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                lblTitleBC.Text = "Bị cáo";
                tblQHPL.Text = "Tội danh";
                lblTitleBD.Visible = txtBidon.Visible = false;
                dgListHS.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgListHS.DataSource = oDT;
                dgListHS.DataBind();
                dgListHS.Visible = true;
                dgList.Visible = false;
            }
            else if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HANHCHINH)
            {
                lblTitleBC.Text = "Người khởi kiện";
                lblTitleBD.Text = "Người bị kiện";
                tblQHPL.Text = "Quan hệ PL";
                lblTitleBD.Visible = txtBidon.Visible = true;
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; dgListHS.Visible = false;
            }
            else
            {
                lblTitleBC.Text = "Nguyên đơn";
                tblQHPL.Text = "Quan hệ PL";
                lblTitleBD.Visible = txtBidon.Visible = true;
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; dgListHS.Visible = false;
            }
        }
        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            string vNguyendon = txtNguyendon.Text;
            string vBidon = txtBidon.Text;
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            decimal vQHPLID = 0;
            decimal vQHPLDNID = 0;
            string vCoquanchuyendon = "";// txtCoquanchuyendon.Text.Trim();
            string vNguoiGui = txtNguoiguidon.Text.Trim();

            decimal vTraloidon = Convert.ToDecimal(ddlTraloi.SelectedValue);
            decimal vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);

            int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
            int isBuocTT = Convert.ToInt16(dropBuocTT.SelectedValue);
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
            String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
            int isHoanTHA = Convert.ToInt16(dropHoanTHA.SelectedValue);
            int typetb = Convert.ToInt16(dropTypeTB.SelectedValue);

            int is_dangkybaocao = Convert.ToInt16(dropDangKyBC.SelectedValue);
            int captrinhtiep_id = Convert.ToInt16(dropCapTrinhTiepTheo.SelectedValue);
            int type_hoidong_tp = Convert.ToInt16(dropTypeHDTP.SelectedValue);

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
                vPhongbanID = 0;
            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            //--------------
            decimal _SodonTLM = Convert.ToDecimal(dropSoDonTLM.SelectedValue);
            decimal _LoaiGDT = Convert.ToDecimal(ddlLoaiGDT.SelectedValue);
            String vQHPL_TD = txtQHPL_TD.Text;

            String chk_conlai_s = Convert.ToInt32(chk_conlai.Checked).ToString();
            //-----------------------------
            //manhnd 
            decimal _loaingaysearch = Convert.ToDecimal(dropLoaiNgaySer.SelectedValue);
            DateTime? vNgaySearch_Tu = txtNgayBA_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgaySearch_Den = txtNgayBA_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            //-----------------------------
            DataTable tbl = null;
            tbl = oBL.VUAN_PHAT_HANH_SEARCH(Session[ENUM_SESSION.SESSION_USERID] + "", chk_conlai_s, Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
               , vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vTrangthai, vKetquathuly, vKetquaxetxu
               , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, LoaiAnDB_TH, isHoanTHA
               , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp, _ISXINANGIAM, _GDT_ISXINANGIAM, _SodonTLM, _LoaiGDT
               , vQHPL_TD, _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, txtSoVanBan.Text, txtNgayVB.Text, ddlTrangThai.SelectedValue, ddlVBPH.SelectedValue, pageindex, page_size);
            return tbl;
        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            SetGetSessionTK(true);
        }
        String temp = "";

        void XoaVuAn(Decimal CurrVuAnID)
        {

            GDTTT_TUHINH_BL obl = new GDTTT_TUHINH_BL();
            decimal count_ds = obl.HOSO_TUHINH_BY_VUANID(CurrVuAnID);
            if (count_ds > 0)
            {
                lbtthongbao.Text = "Bạn không được xóa Vụ án khi hồ sơ đang xem xin ân giảm";
                return;
            }

            List<GDTTT_QUANLYHS> lstHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstHS != null && lstHS.Count > 0)
            {
                lbtthongbao.Text = "Đã có dữ liệu liên quan, không được phép xóa!";
                return;
            }
            else
            {
                List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == CurrVuAnID).ToList();
                if (lstTT != null && lstTT.Count > 0)
                {
                    lbtthongbao.Text = "Đã có dữ liệu liên quan, không được phép xóa!";
                    return;
                }
            }
            //------------------------           
            List<GDTTT_VUAN_DUONGSU> lstDS = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstDS != null && lstDS.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU objDS in lstDS)
                    dt.GDTTT_VUAN_DUONGSU.Remove(objDS);
            }
            dt.SaveChanges();
            //-----------------------------
            List<GDTTT_VUAN_THAMTRAVIEN> lstTTV = dt.GDTTT_VUAN_THAMTRAVIEN.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstDS != null && lstDS.Count > 0)
            {
                foreach (GDTTT_VUAN_THAMTRAVIEN objTTV in lstTTV)
                    dt.GDTTT_VUAN_THAMTRAVIEN.Remove(objTTV);
            }
            dt.SaveChanges();
            //---------------anhvh add 29/05/2021--------------
            List<GDTTT_VUAN_DUONGSU_TOIDANH> lst_td = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstDS != null && lstDS.Count > 0)
            {
                foreach (GDTTT_VUAN_DUONGSU_TOIDANH obj_td in lst_td)
                    dt.GDTTT_VUAN_DUONGSU_TOIDANH.Remove(obj_td);
            }
            dt.SaveChanges();
            //---------------anhvh add 29/05/2021--------------
            List<GDTTT_VUAN_DS_KN> lst_kn = dt.GDTTT_VUAN_DS_KN.Where(x => x.VUANID == CurrVuAnID).ToList();
            if (lstDS != null && lstDS.Count > 0)
            {
                foreach (GDTTT_VUAN_DS_KN obj_kn in lst_kn)
                    dt.GDTTT_VUAN_DS_KN.Remove(obj_kn);
            }
            dt.SaveChanges();
            //-----------------------------
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
            dt.GDTTT_VUAN.Remove(oT);
            dt.SaveChanges();
            //-----------------------
            List<GDTTT_DON> lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == CurrVuAnID && x.CD_TRANGTHAI == 2).ToList();
            if (lstDon != null && lstDon.Count > 0)
            {
                foreach (GDTTT_DON oDon in lstDon)
                    oDon.VUVIECID = 0;
            }
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void cmd_ORDER_Click(object sender, ImageClickEventArgs e)
        {
            ImageButton img = (ImageButton)sender;
            String v_name_colum = img.CommandArgument;
            if (v_name_colum == "NGAYTHULYDON")
            {
                if (Session["V_COLUME"] + "" != "NGAYTHULYDON")
                {
                    Session.Remove("V_COLUME"); Session.Remove("V_ASC_DESC");
                }
                if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
                {
                    Session["V_COLUME"] = "NGAYTHULYDON";
                    Session["V_ASC_DESC"] = "ASC";
                }
                else if (Session["V_COLUME"] + "" == "NGAYTHULYDON" && Session["V_ASC_DESC"] + "" == "ASC")
                {
                    Session["V_COLUME"] = "NGAYTHULYDON";
                    Session["V_ASC_DESC"] = "DESC";
                }
                else if (Session["V_COLUME"] + "" == "NGAYTHULYDON" && Session["V_ASC_DESC"] + "" == "DESC")
                {
                    Session["V_COLUME"] = "NGAYTHULYDON";
                    Session["V_ASC_DESC"] = "ASC";
                }
            }
            else if (v_name_colum == "TENTHAMTRAVIEN")
            {
                if (Session["V_COLUME"] + "" != "TENTHAMTRAVIEN")
                {
                    Session.Remove("V_COLUME"); Session.Remove("V_ASC_DESC");
                }
                if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
                {
                    Session["V_COLUME"] = "TENTHAMTRAVIEN";
                    Session["V_ASC_DESC"] = "ASC";
                }
                else if (Session["V_COLUME"] + "" == "TENTHAMTRAVIEN" && Session["V_ASC_DESC"] + "" == "ASC")
                {
                    Session["V_COLUME"] = "TENTHAMTRAVIEN";
                    Session["V_ASC_DESC"] = "DESC";
                }
                else if (Session["V_COLUME"] + "" == "TENTHAMTRAVIEN" && Session["V_ASC_DESC"] + "" == "DESC")
                {
                    Session["V_COLUME"] = "TENTHAMTRAVIEN";
                    Session["V_ASC_DESC"] = "ASC";
                }
            }

            Load_Data();
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Header)
            {
                ImageButton cmd_NGAYTHULYDON_ORDER = (ImageButton)e.Item.FindControl("cmd_NGAYTHULYDON_ORDER");
                ImageButton cmd_TENTHAMTRAVIEN_ORDER = (ImageButton)e.Item.FindControl("cmd_TENTHAMTRAVIEN_ORDER");
                if (Session["V_COLUME"] + "" == "NGAYTHULYDON" && Session["V_ASC_DESC"] + "" == "ASC")
                {
                    cmd_NGAYTHULYDON_ORDER.ImageUrl = "/UI/img/orders_up.png";
                }
                if (Session["V_COLUME"] + "" == "NGAYTHULYDON" && Session["V_ASC_DESC"] + "" == "DESC")
                {
                    cmd_NGAYTHULYDON_ORDER.ImageUrl = "/UI/img/orders_down.png";
                }
                if (Session["V_COLUME"] + "" == "TENTHAMTRAVIEN" && Session["V_ASC_DESC"] + "" == "ASC")
                {
                    cmd_TENTHAMTRAVIEN_ORDER.ImageUrl = "/UI/img/orders_up.png";
                }
                if (Session["V_COLUME"] + "" == "TENTHAMTRAVIEN" && Session["V_ASC_DESC"] + "" == "DESC")
                {
                    cmd_TENTHAMTRAVIEN_ORDER.ImageUrl = "/UI/img/orders_down.png";
                }
                //----------------------------
                if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU.Replace("0", ""))
                {
                    e.Item.Cells[4].Text = "Tội danh";
                    e.Item.Cells[5].Text = "Bị cáo khiếu nại";
                }
            }

            //-------------------------------
            //if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            //{
            //    DataRowView rv = (DataRowView)e.Item.DataItem;
            //    string strID = e.Item.Cells[0].Text;
            //    Literal lttTTV = (Literal)e.Item.FindControl("lttTTV");
            //int count = 0;
            //string StrDisplay = "", temp = "";
            //string[] arr = null;
            //Decimal CurrVuAnID = Convert.ToDecimal(hddCurrID.Value);
            //String PhanCongTTV = rv["PhanCongTTV"] + "";
            //if (!String.IsNullOrEmpty(PhanCongTTV))
            //{
            //    lttTTV.Text = " TTV: <b>" + rv["TenThamTraVien"] + (String.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") ? "" : (" (" + rv["NGAYPHANCONGTTV"] + ")")) + "</b>";
            //    arr = PhanCongTTV.Split("*".ToCharArray());
            //    foreach (String str in arr)
            //    {
            //        if (str != "")
            //        {
            //            if (count == 0)
            //                StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
            //            else
            //                StrDisplay += "<br/>- " + str;
            //            count++;
            //        }
            //    }
            //}
            //else lttTTV.Text = " TTV: <b>" + rv["TenThamTraVien"] + "</b>";
            //lttTTV.Text += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";
            //lttTTV.Text =  rv["PhanCongTTV"] + "";
            //---------------------
            //}
            //--------------------------------------------------
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                temp = "";
                DataRowView rv = (DataRowView)e.Item.DataItem;
                //------------------------
                int loaian = String.IsNullOrEmpty(rv["LoaiAN"] + "") ? 0 : Convert.ToInt16(rv["LoaiAN"] + "");
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");
                //-------------------------------   
                TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                DataTable oDaGui = oBL.GET_VAN_BAN_PHAT_HANH_DAGUI(CurrVuAnID, ddlVBPH.SelectedValue, ddlTrangThai.SelectedValue);
                DataTable oChuaGui = oBL.GET_VAN_BAN_PHAT_HANH_CHUAGUI(CurrVuAnID, ddlVBPH.SelectedValue);
                string sChuaGui = oChuaGui.Rows[0]["VBPH"].ToString();
                string sDaGui = oDaGui.Rows[0]["VBPH"].ToString();
                if (ddlTrangThai.SelectedValue == "")
                {
                    e.Item.Cells[8].Text = sChuaGui != "" ? (sChuaGui + ";</br>" + sDaGui) : sDaGui;
                }
                if(ddlTrangThai.SelectedValue == "0")
                {
                    e.Item.Cells[8].Text = sChuaGui;
                }
                if (ddlTrangThai.SelectedValue != "" && ddlTrangThai.SelectedValue != "0")
                {
                    e.Item.Cells[8].Text = sDaGui;
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal vuanid = 0;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                //case "Sua":
                //    SetGetSessionTK(true);
                //    string[] arr = e.CommandArgument.ToString().Split('#');
                //    if (arr.Length > 0)
                //    {
                //        int loaian = String.IsNullOrEmpty(arr[1] + "") ? 0 : Convert.ToInt16(arr[1] + "");
                //        vuanid = String.IsNullOrEmpty(arr[0] + "") ? 0 : Convert.ToDecimal(arr[0] + "");
                //        if (loaian != Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                //            Response.Redirect("Thongtinvuan.aspx?ID=" + vuanid);
                //        else
                //            Response.Redirect("ThongtinvuanHS.aspx?ID=" + vuanid);
                //    }
                //    break;
                case "PhatHanh":
                    string[] arr = e.CommandArgument.ToString().Split('#');
                    int loaian = String.IsNullOrEmpty(arr[1] + "") ? 0 : Convert.ToInt16(arr[1] + "");
                    vuanid = String.IsNullOrEmpty(arr[0] + "") ? 0 : Convert.ToDecimal(arr[0] + "");
                    Session[ENUM_GDTTT_TONGDAT.IS_PHBS] = "0";
                    Session[ENUM_GDTTT_TONGDAT.IS_PHATHANHLAI] = "0";
                    string StrMsgPhatHanh = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pPhatHanh.aspx?vID=" + vuanid + "','Phát hành văn bản',1260,800);";
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv();");
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgPhatHanh, true);
                    break;
            }
        }
        protected void dgListHS_ItemDataBound(object sender, DataGridItemEventArgs e)
        {

        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            //  dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion
        //---------------CHỨC NĂNG-------------------
        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                chk.Checked = chkAll.Checked;
            }
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(false);
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
            txtNguyendon.Text = "";
            txtBidon.Text = "";
            ddlLoaiAn.SelectedIndex = 0;

            ddlThamtravien.SelectedIndex = 0;
            ddlPhoVuTruong.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;

            ddlTrangthaithuly.SelectedIndex = 0;
            ddlTotrinh.SelectedIndex = 0;
            dropIsYKienKetLuatTrinhLD.SelectedValue = "2";
            dropIsYKienKetLuatTrinhLD.Visible = lttYKienKetLuan.Visible = true;

            lttBuocTT.Visible = dropBuocTT.Visible = true;
            dropBuocTT.SelectedValue = "0";

            dropCapTrinhTiepTheo.SelectedIndex = dropDangKyBC.SelectedIndex = 0;
            dropCapTrinhTiepTheo.Enabled = dropDangKyBC.Enabled = true;

            ddlTraloi.SelectedIndex = 0;
            ddlLoaiCV.SelectedIndex = 0;

            txtThuly_Tu.Text = "";
            txtThuly_Den.Text = "";
            txtThuly_So.Text = "";

            txtNguoiguidon.Text = string.Empty;
            ddlMuonHoso.SelectedValue = "2";

            ddlKetquaThuLy.SelectedValue = "3";
            ddlKetquaXX.SelectedIndex = 0;
            dropAnDB.SelectedIndex = 0;
            dropAnDB_TH.SelectedIndex = 0;
            dropHoanTHA.SelectedIndex = 0;
            Session.Remove("V_COLUME");
            Session.Remove("V_ASC_DESC");
            if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
            {
                Session["V_COLUME"] = "NGAYTHULYDON";
                Session["V_ASC_DESC"] = "DESC";
            }

            dropTypeHDTP.SelectedIndex = 0;
            dropCapTrinhTiepTheo.SelectedIndex = 0;
            dropDangKyBC.SelectedIndex = 0;
            dropTypeTB.SelectedIndex = 0;
            dropDangKyBC.Enabled = dropCapTrinhTiepTheo.Enabled = false;

            txtNgayBA_Tu.Text = txtNgayBA_Den.Text = string.Empty;
            txtSoVanBan.Text = "";
            txtNgayVB.Text = "";
            ddlTrangThai.SelectedValue = "";
            ddlVBPH.SelectedValue = "";

        }
        //---------------------------------

        private DataTable SearchNoPaging()
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            string vNguyendon = txtNguyendon.Text;
            string vBidon = txtBidon.Text;
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            decimal vQHPLID = 0;
            decimal vQHPLDNID = 0;
            string vCoquanchuyendon = "";// txtCoquanchuyendon.Text.Trim();
            string vNguoiGui = txtNguoiguidon.Text.Trim();

            decimal vTraloidon = Convert.ToDecimal(ddlTraloi.SelectedValue);
            decimal vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);
            //int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            //int pageindex = Convert.ToInt32(hddPageIndex.Value);

            int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
            int isBuocTT = Convert.ToInt16(dropBuocTT.SelectedValue);
            int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
            int ishoantha = Convert.ToInt16(dropHoanTHA.SelectedValue);
            int typetb = Convert.ToInt16(dropTypeTB.SelectedValue);

            int is_dangkybaocao = Convert.ToInt16(dropDangKyBC.SelectedValue);
            int captrinhtiep_id = Convert.ToInt16(dropCapTrinhTiepTheo.SelectedValue);
            int type_hoidong_tp = Convert.ToInt16(dropTypeHDTP.SelectedValue);

            DataTable oDT = null;

            oDT = oBL.VUAN_Search_NoPaging(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui,
               vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan,
               vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly,
               vTrangthai, vKetquathuly, vKetquaxetxu, isMuonHoSo
               , isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, ishoantha
               , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp);
            return oDT;
        }

        protected void ddlVBPH_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(ddlVBPH.SelectedValue == "0" || ddlVBPH.SelectedValue == "1" || ddlVBPH.SelectedValue == "2" || ddlVBPH.SelectedValue == "3" || ddlVBPH.SelectedValue == "4")
            {
                pnPhatHanh.Visible = true;
            }
            else pnPhatHanh.Visible = false;
            //Load_Data();
        }

        private void LoadHinhThucGui()
        {
            DM_HINHTHUCGUI_BL oBL = new DM_HINHTHUCGUI_BL();
            dropHinhThucGui.DataSource = oBL.GETALL_ISHIEULUC();
            dropHinhThucGui.DataTextField = "TEN_HINHTHUCGUI";
            dropHinhThucGui.DataValueField = "GIATRI";
            dropHinhThucGui.DataBind();
            dropHinhThucGui.SelectedValue = "2";
        }
        protected void cmdPhatHanh_Click(object sender, EventArgs e)
        {
            if (txtNgaygui.Text == "")
            {
                lbThongbao.Text = "Bạn chưa chọn ngày gửi!";
                txtNgaygui.Focus();
                return;
            }
            int countCheck = 0;
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                //Hình sự
                foreach (DataGridItem Item in dgListHS.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkPhatHanh");
                    if (chkChon.Checked)
                    {
                        countCheck++;
                        HiddenField hdID = (HiddenField)Item.FindControl("hddID");
                        decimal idVuAn = Convert.ToDecimal(hdID.Value);
                        GDTTT_VUAN va = dt.GDTTT_VUAN.Where(x => x.ID == idVuAn).FirstOrDefault();
                        if (ddlVBPH.SelectedValue == "0" || ddlVBPH.SelectedValue == "1" || ddlVBPH.SelectedValue == "2" || ddlVBPH.SelectedValue == "3" || ddlVBPH.SelectedValue == "4")
                        {
                            string loai = ddlVBPH.SelectedValue == "0" ? "0" : ddlVBPH.SelectedValue == "1" ? "1" : ddlVBPH.SelectedValue == "2" ? "2" : ddlVBPH.SelectedValue == "3" ? "4" : "5";
                            List<GDTTT_QUANLYHS> lstHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == idVuAn && x.LOAI == loai).ToList<GDTTT_QUANLYHS>();
                            if (lstHS.Count > 0)
                            {
                                foreach (GDTTT_QUANLYHS hs in lstHS)
                                {
                                    TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                                    TONGDAT_GDKT oT = new TONGDAT_GDKT();
                                    oT.ID = 0;
                                    oT.NGAYTAO = DateTime.Now;
                                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    oT.VUAN_ID = idVuAn;
                                    oT.LOAIANID = va.LOAIAN;
                                    oT.TENVANBAN = ddlVBPH.SelectedItem.Text + " số " + hs.SOPHIEU.ToString() + " ngày " + DateTime.Parse(hs.NGAYTAO.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy"); ;
                                    oT.GIAIDOAN = 1;
                                    oT.ID_HS_TLDON = "HS" + hs.ID;
                                    oT.LOAIVB = ddlVBPH.SelectedItem.Text;
                                    oT.SOVB = hs.SOPHIEU.ToString();
                                    oT.NGAYVB = hs.NGAYTAO;
                                    decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                                    DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
                                    oT.DONVIPHATHANH_ID = phongBanID;
                                    oT.DONVIPHATHANH = pb.TENPHONGBAN;
                                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                    oT.ID = oBL.TONGDAT_GDKT_UP_IN(oT);
                                    DataTable obj = oBL.GET_VAN_BAN_PHAT_HANH_NOINHAN(va.ID, hs.ID, "HS");
                                    if (obj.Rows.Count > 0)
                                    {
                                        foreach (DataRow d in obj.Rows)
                                        {
                                            TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                            oN.ID = 0;
                                            oN.NGAYGUI = DateTime.Now;
                                            oN.DOITUONG = 2;
                                            oN.TRANGTHAI = 1;
                                            if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                            if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                            oN.NGAYTAO = DateTime.Now;
                                            oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                            oN.NOINHAN = d["NOINHAN"] + "";
                                            oN.DIACHI = d["DIACHI"] + "";
                                            oN.TONGDAT_GDKT_ID = oT.ID;
                                            oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                            DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                            decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                            if (isVBPH == 0)
                                            {
                                                oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                            }
                                            oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                        }
                                    }
                                }
                            }
                        }
                        else if (ddlVBPH.SelectedValue == "5" || ddlVBPH.SelectedValue == "6" || ddlVBPH.SelectedValue == "7")
                        {
                            decimal loai = ddlVBPH.SelectedValue == "5" ? 0 : ddlVBPH.SelectedValue == "6" ? 1 : 4;
                            decimal type = ddlVBPH.SelectedValue == "6" ? 4 : 3;
                            GDTTT_DON_TRALOI vTL = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == idVuAn && x.TYPETB == type).FirstOrDefault();
                            if (va.GQD_LOAIKETQUA == loai && vTL != null)
                            {
                                TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                                TONGDAT_GDKT oT = new TONGDAT_GDKT();
                                oT.ID = 0;
                                oT.NGAYTAO = DateTime.Now;
                                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oT.VUAN_ID = idVuAn;
                                oT.LOAIANID = va.LOAIAN;
                                oT.GIAIDOAN = 2;
                                oT.ID_HS_TLDON = "TL" + vTL.ID;
                                oT.LOAIVB = ddlVBPH.SelectedItem.Text;
                                oT.SOVB = vTL.SO;
                                oT.NGAYVB = vTL.NGAY;
                                oT.NGUOIKY = vTL.NGUOIKY;
                                oT.TENVANBAN = ddlVBPH.SelectedItem.Text + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy"); ;
                                decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                                DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
                                oT.DONVIPHATHANH_ID = phongBanID;
                                oT.DONVIPHATHANH = pb.TENPHONGBAN;
                                oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oT.ID = oBL.TONGDAT_GDKT_UP_IN(oT);
                                //Add đối tượng
                                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == va.ID && x.ISTHULY == 1).FirstOrDefault();
                                decimal isKhangNghi = ddlVBPH.SelectedValue == "6" ? 1 : 0;
                                decimal vThuLy = oDon == null ? 1 : 2;
                                DataTable objDT = oBL.GET_VBPH_NOINHAN_DOITUONG(va.ID, "GQD", va.LOAIAN, vThuLy, isKhangNghi);
                                if (objDT.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDT.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 1;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TUCACHTOTUNG = d["TUCACHTOTUNG"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                                //Add đơn vị nội bộ
                                DataTable objDV = oBL.GET_VAN_BAN_PHAT_HANH_NOINHAN(va.ID, 0, "GQD");
                                if (objDV.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDV.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 2;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                            }
                        }
                        else if (ddlVBPH.SelectedValue == "8" || ddlVBPH.SelectedValue == "9")
                        {
                            GDTTT_VUAN vVuAn = ddlVBPH.SelectedValue == "8" ? dt.GDTTT_VUAN.Where(x => x.ID == idVuAn && x.SOTHULYXXGDT != null).FirstOrDefault() : dt.GDTTT_VUAN.Where(x => x.ID == idVuAn && x.XXGDTTT_ISKETQUA == 1 && x.XXGDTTT_SOQD != null).FirstOrDefault();
                            if (vVuAn != null)
                            {
                                TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                                TONGDAT_GDKT oT = new TONGDAT_GDKT();
                                oT.ID = 0;
                                oT.NGAYTAO = DateTime.Now;
                                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oT.VUAN_ID = idVuAn;
                                oT.LOAIANID = va.LOAIAN;
                                oT.GIAIDOAN = 3;
                                oT.ID_HS_TLDON = "VA" + vVuAn.ID;
                                oT.LOAIVB = ddlVBPH.SelectedItem.Text;
                                oT.SOVB = ddlVBPH.SelectedValue == "8" ? vVuAn.SOTHULYXXGDT : vVuAn.XXGDTTT_SOQD;
                                oT.NGAYVB = ddlVBPH.SelectedValue == "8" ? vVuAn.NGAYTHULYXXGDT : vVuAn.XXGDTTT_NGAYQD;
                                oT.TENVANBAN = ddlVBPH.SelectedItem.Text + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                                decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                                DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
                                oT.DONVIPHATHANH_ID = phongBanID;
                                oT.DONVIPHATHANH = pb.TENPHONGBAN;
                                oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oT.ID = oBL.TONGDAT_GDKT_UP_IN(oT);
                                //Add đối tượng
                                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == vVuAn.ID && x.ISTHULY == 1).FirstOrDefault();
                                decimal vThuLy = oDon == null ? 1 : 2;
                                DataTable objDT = oBL.GET_VBPH_NOINHAN_DOITUONG(vVuAn.ID, "GDT", vVuAn.LOAIAN, vThuLy, 1);
                                if (objDT.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDT.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 1;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TUCACHTOTUNG = d["TUCACHTOTUNG"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                                //Add đơn vị nội bộ
                                DataTable objDV = oBL.GET_VAN_BAN_PHAT_HANH_NOINHAN(va.ID, 0, "GDT");
                                if (objDV.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDV.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 2;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                            }
                        }
                        else if (ddlVBPH.SelectedValue == "10" || ddlVBPH.SelectedValue == "11")
                        {
                            decimal loai = ddlVBPH.SelectedValue == "10" ? 1 : 2;
                            GDTTT_DON_TRALOI vTL = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == idVuAn && x.TYPETB == loai).FirstOrDefault();
                            if (vTL != null)
                            {
                                TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                                TONGDAT_GDKT oT = new TONGDAT_GDKT();
                                oT.ID = 0;
                                oT.NGAYTAO = DateTime.Now;
                                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oT.VUAN_ID = idVuAn;
                                oT.LOAIANID = va.LOAIAN;
                                oT.GIAIDOAN = 4;
                                oT.ID_HS_TLDON = "TL" + vTL.ID;
                                oT.LOAIVB = ddlVBPH.SelectedItem.Text;
                                oT.SOVB = vTL.SO;
                                oT.NGAYVB = vTL.NGAY;
                                oT.NGUOIKY = vTL.NGUOIKY;
                                oT.TENVANBAN = ddlVBPH.SelectedItem.Text + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                                decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                                DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
                                oT.DONVIPHATHANH_ID = phongBanID;
                                oT.DONVIPHATHANH = pb.TENPHONGBAN;
                                oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oT.ID = oBL.TONGDAT_GDKT_UP_IN(oT);
                                //Add đối tượng
                                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == idVuAn && x.ISTHULY == 1).FirstOrDefault();
                                decimal vThuLy = oDon == null ? 1 : 2;
                                DataTable objDT = oBL.GET_VBPH_NOINHAN_DOITUONG(idVuAn, "GDT", va.LOAIAN, vThuLy, 0);
                                if (objDT.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDT.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 1;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TUCACHTOTUNG = d["TUCACHTOTUNG"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                                //Add đơn vị nội bộ
                                DataTable objDV = oBL.GET_VAN_BAN_PHAT_HANH_NOINHAN(va.ID, 0, "DBQH");
                                if (objDV.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDV.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 2;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                //Dan sự chung
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkPhatHanh");
                    if (chkChon.Checked)
                    {
                        countCheck++;
                        HiddenField hdID = (HiddenField)Item.FindControl("hddID");
                        decimal idVuAn = Convert.ToDecimal(hdID.Value);
                        GDTTT_VUAN va = dt.GDTTT_VUAN.Where(x => x.ID == idVuAn).FirstOrDefault();
                        if (ddlVBPH.SelectedValue == "0" || ddlVBPH.SelectedValue == "1" || ddlVBPH.SelectedValue == "2" || ddlVBPH.SelectedValue == "3" || ddlVBPH.SelectedValue == "4")
                        {
                            string loai = ddlVBPH.SelectedValue == "0" ? "0" : ddlVBPH.SelectedValue == "1" ? "1" : ddlVBPH.SelectedValue == "2" ? "2" : ddlVBPH.SelectedValue == "3" ? "4" : "5";
                            List<GDTTT_QUANLYHS> lstHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == idVuAn && x.LOAI == loai).ToList<GDTTT_QUANLYHS>();
                            if (lstHS.Count > 0)
                            {
                                foreach (GDTTT_QUANLYHS hs in lstHS)
                                {
                                    TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                                    TONGDAT_GDKT oT = new TONGDAT_GDKT();
                                    oT.ID = 0;
                                    oT.NGAYTAO = DateTime.Now;
                                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                    oT.VUAN_ID = idVuAn;
                                    oT.LOAIANID = va.LOAIAN;
                                    oT.TENVANBAN = ddlVBPH.SelectedItem.Text + " số " + hs.SOPHIEU.ToString() + " ngày " + DateTime.Parse(hs.NGAYTAO.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                                    oT.GIAIDOAN = 1;
                                    oT.ID_HS_TLDON = "HS" + hs.ID;
                                    oT.LOAIVB = ddlVBPH.SelectedItem.Text;
                                    oT.SOVB = hs.SOPHIEU.ToString();
                                    oT.NGAYVB = hs.NGAYTAO;
                                    decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                                    DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
                                    oT.DONVIPHATHANH_ID = phongBanID;
                                    oT.DONVIPHATHANH = pb.TENPHONGBAN;
                                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                    oT.ID = oBL.TONGDAT_GDKT_UP_IN(oT);
                                    DataTable obj = oBL.GET_VAN_BAN_PHAT_HANH_NOINHAN(va.ID, hs.ID, "HS");
                                    if (obj.Rows.Count > 0)
                                    {
                                        foreach (DataRow d in obj.Rows)
                                        {
                                            TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                            oN.ID = 0;
                                            oN.NGAYGUI = DateTime.Now;
                                            oN.DOITUONG = 2;
                                            oN.TRANGTHAI = 1;
                                            if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                            if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                            oN.NGAYTAO = DateTime.Now;
                                            oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                            oN.NOINHAN = d["NOINHAN"] + "";
                                            oN.DIACHI = d["DIACHI"] + "";
                                            oN.TONGDAT_GDKT_ID = oT.ID;
                                            oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                            DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                            decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                            if (isVBPH == 0)
                                            {
                                                oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                            }
                                            oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                        }
                                    }
                                }
                            }
                        }
                        else if (ddlVBPH.SelectedValue == "5" || ddlVBPH.SelectedValue == "6" || ddlVBPH.SelectedValue == "7")
                        {
                            decimal loai = ddlVBPH.SelectedValue == "5" ? 0 : ddlVBPH.SelectedValue == "6" ? 1 : 4;
                            GDTTT_VUAN vVuAn = dt.GDTTT_VUAN.Where(x => x.ID == idVuAn && x.GQD_LOAIKETQUA == loai).FirstOrDefault();
                            if (vVuAn != null)
                            {
                                TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                                TONGDAT_GDKT oT = new TONGDAT_GDKT();
                                oT.ID = 0;
                                oT.NGAYTAO = DateTime.Now;
                                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oT.VUAN_ID = idVuAn;
                                oT.LOAIANID = va.LOAIAN;
                                oT.TENVANBAN = ddlVBPH.SelectedItem.Text + " số " + vVuAn.GDQ_SO + " ngày " + DateTime.Parse(vVuAn.GDQ_NGAY.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                                oT.GIAIDOAN = 2;
                                oT.ID_HS_TLDON = "VA" + vVuAn.ID;
                                oT.LOAIVB = ddlVBPH.SelectedItem.Text;
                                oT.SOVB = vVuAn.GDQ_SO;
                                oT.NGAYVB = vVuAn.GDQ_NGAY;
                                oT.NGUOIKY = vVuAn.GDQ_NGUOIKY;
                                decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                                DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
                                oT.DONVIPHATHANH_ID = phongBanID;
                                oT.DONVIPHATHANH = pb.TENPHONGBAN;
                                oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oT.ID = oBL.TONGDAT_GDKT_UP_IN(oT);
                                //Add đối tượng
                                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == vVuAn.ID && x.ISTHULY == 1).FirstOrDefault();
                                decimal isKhangNghi = ddlVBPH.SelectedValue == "6" ? 1 : 0;
                                decimal vThuLy = oDon == null ? 1 : 2;
                                DataTable objDT = oBL.GET_VBPH_NOINHAN_DOITUONG(vVuAn.ID, "GQD", vVuAn.LOAIAN, vThuLy, isKhangNghi);
                                if (objDT.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDT.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 1;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TUCACHTOTUNG = d["TUCACHTOTUNG"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                                //Add đơn vị nội bộ
                                DataTable objDV = oBL.GET_VAN_BAN_PHAT_HANH_NOINHAN(va.ID, 0, "GQD");
                                if (objDV.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDV.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 2;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                            }
                        }
                        else if (ddlVBPH.SelectedValue == "8" || ddlVBPH.SelectedValue == "9")
                        {
                            GDTTT_VUAN vVuAn = ddlVBPH.SelectedValue == "8" ? dt.GDTTT_VUAN.Where(x => x.ID == idVuAn && x.SOTHULYXXGDT != null).FirstOrDefault() : dt.GDTTT_VUAN.Where(x => x.ID == idVuAn && x.XXGDTTT_ISKETQUA == 1 && x.XXGDTTT_SOQD != null).FirstOrDefault();
                            if (vVuAn != null)
                            {
                                TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                                TONGDAT_GDKT oT = new TONGDAT_GDKT();
                                oT.ID = 0;
                                oT.NGAYTAO = DateTime.Now;
                                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oT.VUAN_ID = idVuAn;
                                oT.LOAIANID = va.LOAIAN;
                                oT.GIAIDOAN = 3;
                                oT.ID_HS_TLDON = "VA" + vVuAn.ID;
                                oT.LOAIVB = ddlVBPH.SelectedItem.Text;
                                oT.SOVB = ddlVBPH.SelectedValue == "8" ? vVuAn.SOTHULYXXGDT : vVuAn.XXGDTTT_SOQD;
                                oT.NGAYVB = ddlVBPH.SelectedValue == "8" ? vVuAn.NGAYTHULYXXGDT : vVuAn.XXGDTTT_NGAYQD;
                                oT.TENVANBAN = ddlVBPH.SelectedItem.Text + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy"); ;
                                decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                                DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
                                oT.DONVIPHATHANH_ID = phongBanID;
                                oT.DONVIPHATHANH = pb.TENPHONGBAN;
                                oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oT.ID = oBL.TONGDAT_GDKT_UP_IN(oT);
                                //Add đối tượng
                                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == vVuAn.ID && x.ISTHULY == 1).FirstOrDefault();
                                decimal vThuLy = oDon == null ? 1 : 2;
                                DataTable objDT = oBL.GET_VBPH_NOINHAN_DOITUONG(vVuAn.ID, "GDT", vVuAn.LOAIAN, vThuLy, 1);
                                if (objDT.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDT.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 1;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TUCACHTOTUNG = d["TUCACHTOTUNG"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                                //Add đơn vị nội bộ
                                DataTable objDV = oBL.GET_VAN_BAN_PHAT_HANH_NOINHAN(va.ID, 0, "GDT");
                                if (objDV.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDV.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 2;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                            }
                        }
                        else if (ddlVBPH.SelectedValue == "10" || ddlVBPH.SelectedValue == "11")
                        {
                            decimal loai = ddlVBPH.SelectedValue == "10" ? 1 : 2;
                            GDTTT_DON_TRALOI vTL = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == idVuAn && x.TYPETB == loai).FirstOrDefault();
                            if (vTL != null)
                            {
                                TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                                TONGDAT_GDKT oT = new TONGDAT_GDKT();
                                oT.ID = 0;
                                oT.NGAYTAO = DateTime.Now;
                                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oT.VUAN_ID = idVuAn;
                                oT.LOAIANID = va.LOAIAN;
                                oT.GIAIDOAN = 4;
                                oT.ID_HS_TLDON = "TL" + vTL.ID;
                                oT.LOAIVB = ddlVBPH.SelectedItem.Text;
                                oT.SOVB = vTL.SO;
                                oT.NGAYVB = vTL.NGAY;
                                oT.NGUOIKY = vTL.NGUOIKY;
                                oT.TENVANBAN = ddlVBPH.SelectedItem.Text + " số " + oT.SOVB + " ngày " + DateTime.Parse(oT.NGAYVB.ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                                decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                                DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
                                oT.DONVIPHATHANH_ID = phongBanID;
                                oT.DONVIPHATHANH = pb.TENPHONGBAN;
                                oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                oT.ID = oBL.TONGDAT_GDKT_UP_IN(oT);
                                //Add đối tượng
                                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == idVuAn && x.ISTHULY == 1).FirstOrDefault();
                                decimal vThuLy = oDon == null ? 1 : 2;
                                DataTable objDT = oBL.GET_VBPH_NOINHAN_DOITUONG(idVuAn, "GDT", va.LOAIAN, vThuLy, 0);
                                if (objDT.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDT.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 1;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TUCACHTOTUNG = d["TUCACHTOTUNG"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                                //Add đơn vị nội bộ
                                DataTable objDV = oBL.GET_VAN_BAN_PHAT_HANH_NOINHAN(va.ID, 0, "DBQH");
                                if (objDV.Rows.Count > 0)
                                {
                                    foreach (DataRow d in objDV.Rows)
                                    {
                                        TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                                        oN.ID = 0;
                                        oN.NGAYGUI = DateTime.Now;
                                        oN.DOITUONG = 2;
                                        oN.TRANGTHAI = 1;
                                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                                        oN.NGAYTAO = DateTime.Now;
                                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                        oN.NOINHAN = d["NOINHAN"] + "";
                                        oN.DIACHI = d["DIACHI"] + "";
                                        oN.TONGDAT_GDKT_ID = oT.ID;
                                        oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                                        DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                                        decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                                        if (isVBPH == 0)
                                        {
                                            oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        }
                                        oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                                    }
                                }
                            }
                        }
                    }
                }
            }                
            
            if (countCheck == 0)
            {
                lbThongbao.Text = "Bạn chưa chọn vụ án cần phát hành văn bản!";
                return;
            }
            lbThongbao.Text = "Phát hành thành công";
            txtNgaygui.Text = "";
            dropHinhThucGui.SelectedValue = "2";
            Load_Data();
        }

        protected void ddlTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Load_Data();
        }

        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Load_Data();
            // LoadDropQHPL();
        }

        protected void dropBuocTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropCapTrinhTiepTheo.Enabled = false;
            int tinhtrang = Convert.ToInt32(ddlTrangthaithuly.SelectedValue);
            if (dropBuocTT.SelectedValue == "1" && tinhtrang > 3)
                dropCapTrinhTiepTheo.Enabled = true;
            else
                dropCapTrinhTiepTheo.SelectedValue = "0";
        }

    }
}
