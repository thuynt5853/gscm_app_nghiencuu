using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.GDTTT;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.QLAN.GDTTT.In;

namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class DanhsachVAKN : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0;
        private const decimal ROOT = 0;
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
            {
                return false;
            }
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
            {
                return "";
            }
        }
        String SessionInBC = "GDTTTVA_INBC_VISIBLE";
        String SessionSearch = "TTTKVISIBLE";
        Decimal CurrUserID = 0;
        MenuPermission oPer = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.btnNBInDSVAKN);
            scriptManager.RegisterPostBackControl(this.btnNBInPVAKN);
            //---------------------------
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                if (!IsPostBack)
                {
                    Clear_SessionTK();
                    if ((Session[SessionSearch] + "") == "0")
                    {
                        lbtTTTK.Text = "[ Thu gọn ]";
                        pnTTTK.Visible = true;
                    }
                    LoadDropBox();
                    LoadDropTinh();
                    SetGetSessionTK(false);
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        public void Clear_SessionTK()
        {
            Session.Remove(SS_TK.TOAANXX);
            Session.Remove(SS_TK.SOBAQD);
            Session.Remove(SS_TK.NGAYBAQD);
            Session.Remove(SS_TK.NGUYENDON);
            Session.Remove(SS_TK.BIDON);
            Session.Remove(SS_TK.LOAIAN);
            Session.Remove(SS_TK.THAMTRAVIEN);
            Session.Remove(SS_TK.LANHDAOPHUTRACH);
            Session.Remove(SS_TK.THAMPHAN);
            Session.Remove(SS_TK.NGUOIGUI);
            Session.Remove(SS_TK.COQUANCHUYENDON);
            Session.Remove(SS_TK.TRALOIDON);
            Session.Remove(SS_TK.LOAICV);
            Session.Remove(SS_TK.THULY_TU);
            Session.Remove(SS_TK.THULY_DEN);
            Session.Remove(SS_TK.SOTHULY);
            Session.Remove(SS_TK.MUONHOSO);
            Session.Remove(SS_TK.TRANGTHAITHULY);
            Session.Remove(SS_TK.KETQUATHULY);
            Session.Remove(SS_TK.KETQUAXETXU);
            Session.Remove(SS_TK.BUOCTT);
            Session.Remove(SS_TK.ARRSELECTID);
            Session.Remove(SS_TK.ANQUOCHOI_THOIHIEU);
            Session.Remove(SS_TK.ANTHOIHIEU);
            Session.Remove(SS_TK.HOAN_THIHAHAN);
            Session.Remove(SS_TK.TRANGTHAITOTRINH);
            Session.Remove(SS_TK.TRANGTHAIYKIENTT);
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
                    Session[SS_TK.THULY_TU] = txtThuly_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtThuly_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
                    Session[SS_TK.MUONHOSO] = ddlMuonHoso.SelectedValue;
                    Session[SS_TK.TRANGTHAITHULY] = ddlTrangthaithuly.SelectedValue;
                    string vArrSelectID = "";
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                            else vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                        }
                    }
                    if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";
                    Session[SS_TK.ARRSELECTID] = vArrSelectID;
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
                        if (Session[SS_TK.LOAIAN] != null) ddlLoaiAn.SelectedValue = Session[SS_TK.LOAIAN] + "";
                        if (Session[SS_TK.THAMTRAVIEN] != null) ddlThamtravien.SelectedValue = Session[SS_TK.THAMTRAVIEN] + "";
                        if (Session[SS_TK.LANHDAOPHUTRACH] != null) ddlPhoVuTruong.SelectedValue = Session[SS_TK.LANHDAOPHUTRACH] + "";
                        if (Session[SS_TK.THAMPHAN] != null) ddlThamphan.SelectedValue = Session[SS_TK.THAMPHAN] + "";
                        //if (Session[SS_TK.QHPKLT] != null) ddlQHPLTK.SelectedValue = Session[SS_TK.QHPKLT] + "";
                        //if (Session[SS_TK.QHPLDN] != null) ddlQHPLDN.SelectedValue = Session[SS_TK.QHPLDN] + "";
                        //txtNguoiguidon.Text = Session[SS_TK.NGUOIGUI] + "";
                        //txtCoquanchuyendon.Text = Session[SS_TK.COQUANCHUYENDON] + "";
                        // if (Session[SS_TK.TRALOIDON] != null) ddlTraloi.SelectedValue = Session[SS_TK.TRALOIDON] + "";
                        // if (Session[SS_TK.LOAICV] != null) ddlLoaiCV.SelectedValue = Session[SS_TK.LOAICV] + "";

                        txtThuly_Tu.Text = Session[SS_TK.THULY_TU] + "";
                        txtThuly_Den.Text = Session[SS_TK.THULY_DEN] + "";
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";
                        if (Session[SS_TK.TRANGTHAITHULY] != null)
                            ddlTrangthaithuly.SelectedValue = Session[SS_TK.TRANGTHAITHULY] + "";

                        if (Session[SS_TK.MUONHOSO] != null)
                            ddlMuonHoso.SelectedValue = Session[SS_TK.MUONHOSO] + "";
                        SetVisible_SearchDateTime();
                        SetVisible_ZoneSearchTT();
                    }
                }
            }
            catch (Exception ex) { }
        }
        private void LoadDropBox()
        {
            decimal CurrNhomNSDID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
            QT_NHOMNGUOIDUNG oGroup = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == CurrNhomNSDID).Single();
            int loai_hotro_db = (int)oGroup.LOAI;

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);

            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));


            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();

            try
            {
                LoadDropThamphan();
            }
            catch (Exception ex) { }
            //Lãnh đạo
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (oPer.DULIEU == true)
                    LoadDropLanhDao();
                else
                {
                    LoadAll_TTV();
                    Load_AllLanhDao();
                }

            }
            catch (Exception ex) { }

            //Loại án
            LoadDropLoaiAn();

            //Trình trạng thụ lý
            LoadDrop_TinhTrangThuLy();
            SetVisible_SearchDateTime();
        }
        private void LoadDropTinh()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            //Load loại sổ văn bản
            DM_DATAITEM_BL soBL = new DM_DATAITEM_BL();
            DataTable tblso = soBL.DM_DATAITEM_GETBYGROUPNAME("QLSO_VUGD");
            if (tblso.Rows.Count > 0)
            {
                ddlLoaiso.DataSource = tblso;
                ddlLoaiso.DataTextField = "TEN";
                ddlLoaiso.DataValueField = "MA";
                ddlLoaiso.DataBind();
                ddlLoaiso.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                if (ddlLoaiso.SelectedValue == "0")
                {
                    ddlNguoiKy.Items.Clear();
                    ddlNguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                }

                //load tim kiem theo loai so
                ddlLOAICVPC.DataSource = tblso;
                ddlLOAICVPC.DataTextField = "TEN";
                ddlLOAICVPC.DataValueField = "MA";
                ddlLOAICVPC.DataBind();
                ddlLOAICVPC.Items.FindByValue("SoCV").Selected = true;
            }

            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            //Load Thẩm phán
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DataTable tbl = oBL.GDTTT_VuAn_GetAllCBTheoPB(ToaAnID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = tbl;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
            {
                int count_lst = lst.Count;
                ddlTrangthaithuly.Items.Insert(count_lst + 1, new ListItem("Báo cáo PCA, Tổ TP, CA, Hội đồng TP", "-1"));
            }

            lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1 && x.ID >= 6 && x.ID != 10).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
            SetName_Vu_Phongban(lst);//anhvh add 05/04/2011 add check name phong ban cap cao
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
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009" || oCD.MA == "042")
                    {
                        ddlThamtravien.Items.Clear();
                        ddlThamtravien.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_TTV;
                    }
                    else LoadAll_TTV();
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
                else LoadAll_TTV();
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
            //-----------------
            Decimal ChucDanh_TPTATC = 0;
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            int count = 0;
            //Thẩm tra viên
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

                DataTable tbl = obj.DM_CANBO_PB_CHUCDANH(PhongBanID, "TTV", LanhDaoID, 0, 1, 200000);
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

        void LoadDropThamphan()
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DataTable tbl = oBL.GDTTT_VuAn_GetAllCBTheoPB(ToaAnID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = tbl;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }

        //void LoadDropLoaiAn()
        //{
        //    ddlLoaiAn.Items.Clear();
        //    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
        //    decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
        //    DM_PHONGBAN obj = new DM_PHONGBAN();
        //    if (PBID != 0)
        //    {
        //         obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault();
        //        if (obj.ISHINHSU == 1)
        //        {
        //            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
        //            dgList.Columns[6].Visible = false;
        //            dgList.Columns[5].HeaderText = "Bị cáo";
        //            lblTitleBC.Text = "Bị cáo";
        //            lblTitleBD.Visible = txtBidon.Visible = false;
        //        }
        //    }
        //    if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
        //    if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
        //    if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
        //    if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
        //    if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
        //    // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
        //    if (ddlLoaiAn.Items.Count > 1)
        //        ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        //}
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
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault() ?? new DM_CANBO();
            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                Decimal CurrChucVuID = string.IsNullOrEmpty(oCB.CHUCVUID + "") ? 0 : (decimal)oCB.CHUCVUID;

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault() ?? new DM_DATAITEM();
                if (oCD.MA == "TPTATC" || oCD.MA == "TPCC")
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
                        lblTitleBC.Text = "Bị cáo";
                        lblTitleBD.Visible = txtBidon.Visible = false;
                    }
                    else
                    {
                        lblTitleBC.Text = "Nguyên đơn";
                        lblTitleBD.Visible = txtBidon.Visible = true;
                    }
                    LoadLoaiAnPhuTrach_TheoPB(obj);
                }
            }

            ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            //if (ddlLoaiAn.Items.Count > 1)
            //{
            //    if (obj != null)
            //    {
            //        if (obj.ISHINHSU != 1)
            //        {
            //            ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            //        }
            //    }
            //}
        }
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            ddlLoaiAn.Items.AddRange(ClsHelper.GetEnumLoaiAn().ToArray());
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
            if (obj.ISPHASAN == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
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
            if (obj.ISPHASAN == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            }
        }
        //-----------------------------------------
        private void Load_Data()
        {
            lbtthongbao.Text = "";
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;

            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = getDS(page_size, pageindex);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án trong <b>" + hddTotalPage.Value + "</b> trang";
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
                gridHS.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                gridHS.DataSource = oDT;
                gridHS.DataBind();
                gridHS.Visible = true;
                dgList.Visible = false;
                lblTitleBC.Text = "Bị cáo";
                lblTitleBD.Visible = txtBidon.Visible = false;
            }
            else
            {
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; gridHS.Visible = false;
                lblTitleBC.Text = "Nguyên đơn";
                lblTitleBD.Visible = txtBidon.Visible = true;
            }
        }
        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            string vNguyendon = txtNguyendon.Text;
            string vBidon = txtBidon.Text;
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamtravien = 0;
            decimal.TryParse(ddlThamtravien.SelectedValue, out vThamtravien);
            decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal vThamphan = 0;
            decimal.TryParse(ddlThamphan.SelectedValue, out vThamphan);

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);

            int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
            int isBuocTT = Convert.ToInt16(dropBuocTT.SelectedValue);
            int is_dangkybaocao = Convert.ToInt16(dropDangKyBC.SelectedValue);
            int captrinhtiep_id = Convert.ToInt16(dropCapTrinhTiepTheo.SelectedValue);

            int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
            String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
            int isHoanTHA = Convert.ToInt16(dropHoanTHA.SelectedValue);
            //huynt
            DateTime ? vNgayCongVan = string.IsNullOrEmpty(txtCV_Ngay.Text) ? (DateTime?)null : DateTime.Parse(txtCV_Ngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            int ketqua_thuly = 4; //kết qủa = 4 mặc định là chưa có kết quả
            DataTable oDT = null;
            oDT = oBL.QLToTrinh_VuAnKhangNghi_Search(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
            , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
            , vNgayThulyTu, vNgayThulyDen, vSoThuly
            , vTrangthai, captrinhtiep_id, is_dangkybaocao
            , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
            , ketqua_thuly, LoaiAnDB, LoaiAnDB_TH, isHoanTHA, vNgayCongVan, ddlLOAICVPC.SelectedValue, txtCV_So.Text, dropTrangThaiChuyen.SelectedValue
            , pageindex, page_size);
            return oDT;
        }

        private DataTable getDS_InPC(int page_size, int pageindex)
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

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);

            int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
            int isBuocTT = Convert.ToInt16(dropBuocTT.SelectedValue);
            int is_dangkybaocao = Convert.ToInt16(dropDangKyBC.SelectedValue);
            int captrinhtiep_id = Convert.ToInt16(dropCapTrinhTiepTheo.SelectedValue);

            int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
            String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
            int isHoanTHA = Convert.ToInt16(dropHoanTHA.SelectedValue);

            //huynt
            DateTime? vNgayCongVan = string.IsNullOrEmpty(txtCV_Ngay.Text) ? (DateTime?)null : DateTime.Parse(txtCV_Ngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            int ketqua_thuly = 4; //kết qủa = 4 mặc định là chưa có kết quả
            DataTable oDT = null;
            oDT = oBL.QLToTrinh_VuAnKhangNghi_InPhieu_Chuyen(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
            , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
            , vNgayThulyTu, vNgayThulyDen, vSoThuly
            , vTrangthai, captrinhtiep_id, is_dangkybaocao
            , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
            , ketqua_thuly, LoaiAnDB, LoaiAnDB_TH, isHoanTHA, vNgayCongVan, ddlLOAICVPC.SelectedValue, txtCV_So.Text, dropTrangThaiChuyen.SelectedValue
            , pageindex, page_size);
            return oDT;
        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            SetGetSessionTK(true);
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "TOTRINH":
                    String SessionName = "GDTTT_ReportPL".ToUpper();
                    Session[SS_TK.TENBAOCAO] = "Danh sách tờ trình".ToUpper();
                    int count_row = 1;
                    DataTable tblData = null;
                    string strvid = e.CommandArgument.ToString();
                    decimal VuAnID = Convert.ToDecimal(strvid);
                    GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
                    DataTable tbl = oBL.VUAN_TOTRINH(VuAnID);
                                        
                    string nguyendon = string.Empty;
                    string bidon = string.Empty;
                    GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
                    DataTable tblNGUYENDON = objBL.GetByVuAnID(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    if (tblNGUYENDON != null && tblNGUYENDON.Rows.Count > 0)
                        foreach (DataRow row in tblNGUYENDON.Rows)
                            if (!String.IsNullOrEmpty(nguyendon + "")) nguyendon += ", " + row["TenDuongSu"].ToString();
                            else nguyendon = row["TenDuongSu"].ToString();

                    DataTable tblBIDON = objBL.GetByVuAnID(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    if (tblBIDON != null && tblBIDON.Rows.Count > 0)
                        foreach (DataRow row in tblBIDON.Rows)
                            if (!String.IsNullOrEmpty(bidon + "")) bidon += ", " + row["TenDuongSu"].ToString();
                            else bidon = row["TenDuongSu"].ToString();

                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        tbl.Columns.Add("IsShow", typeof(Int16));
                        tbl.Columns.Add("Rowspan", typeof(Int16));
                        tblData = tbl.Clone();

                        #region Tao du lieu cho column LanTrinh 
                        int lantrinh = 1, IsTrinhLai = 0;
                        DataRow[] arr = tbl.Select("", "NgayTrinh asc, IsTrinhLai asc");
                        foreach (DataRow row in arr)
                        {
                            IsTrinhLai = Convert.ToInt16(row["IsTrinhLai"] + "");
                            count_row++;

                            if (IsTrinhLai == 1)
                            {
                                //bat dau vong trinh moi
                                lantrinh++;
                                count_row = 1;
                            }
                            row["LanTrinh"] = lantrinh;
                            row["YKienDuyetToTrinh"] = Join_YKienDuyetTT(row) + "";
                            row["nguyen_don"] = nguyendon;
                            row["bi_don"] = bidon;
                        }
                        #endregion
                    }
                    if (tbl != null && tbl.Rows.Count > 0)
                        Session[SessionName] = tbl;
                    string StrTotrinh = "PopupReport('/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=dstotrinh&vID=" + e.CommandArgument + "','In DS tờ trình',1000,700);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrTotrinh, true);
                    break;

                case "SoDonTrung":
                    //string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?type=dt&vID=" + e.Item.Cells[0].Text + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    break;
                case "CongVan81":
                    string StrMsgArr81 = "PopupReport('/QLAN/GDTTT/VuAn/Popup/DSDonQuocHoi.aspx?vID=" + e.Item.Cells[0].Text + "','Danh sách công văn 8.1',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr81, true);
                    break;
                case "CHIDAO":
                    string StrMsgChidao = "PopupReport('/QLAN/GDTTT/VuAn/Popup/DSDonChidao.aspx?vID=" + e.Item.Cells[0].Text + "','Danh sách công văn 8.1',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgChidao, true);
                    break;
            }
        }
        String Join_YKienDuyetTT(DataRow row)
        {
            string temp = "", temp_join;
            String YKienDuyetTT = "";

            temp = (row["CapTrinhTiep"] + "").Trim();
            YKienDuyetTT += String.IsNullOrEmpty(temp) ? "" : "Yêu cầu: " + temp;

            //-------------------------------------
            temp = (row["YKienLanhDao"] + "").Trim();
            if (String.IsNullOrEmpty(temp))
            {
                temp = (row["YKien"] + "").Trim();
                temp_join = String.IsNullOrEmpty(temp) ? "" : "Ý kiến: " + temp;
                if (YKienDuyetTT.Length > 0 && temp_join.Length > 0)
                    YKienDuyetTT += "<br>";
                YKienDuyetTT += temp_join;
            }
            else
            {
                temp_join = "Ý kiến: <b>" + row["YKienLanhDao"] + "" + "</b>";
                if (YKienDuyetTT.Length > 0)
                    YKienDuyetTT += "<br>";
                YKienDuyetTT += temp_join;

                temp = (row["YKien"] + "").Trim();
                YKienDuyetTT += String.IsNullOrEmpty(temp) ? "" : ", " + temp;
            }
            //-------------------------------------
            temp = (row["Ghichu"] + "").Trim();
            temp_join = (String.IsNullOrEmpty(temp)) ? "" : ("Ghi chú: " + temp + "");
            if (YKienDuyetTT.Length > 0 && temp_join.Length > 0)
                YKienDuyetTT += "<br>";
            YKienDuyetTT += temp_join;

            //-------------------------------------
            temp = (row["DX_TTV"] + "").Trim();
            temp_join = (String.IsNullOrEmpty(temp)) ? "" : ("Đề xuất TTV: " + temp);
            if (YKienDuyetTT.Length > 0 && temp_join.Length > 0)
                YKienDuyetTT += "<br>";
            YKienDuyetTT += temp_join;

            //-------------------------------------
            return YKienDuyetTT;
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ImageButton cmdPrinDS = (ImageButton)e.Item.FindControl("cmdPrinDS");
                Cls_Comon.SetLinkButton(cmdPrinDS, oPer.TAOMOI);

                DataRowView rv = (DataRowView)e.Item.DataItem;
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");
                decimal trangthai_trinh_id = 0;
                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");
                Literal lttYKien = (Literal)e.Item.FindControl("lttYKien");
                lttYKien.Text = "Ý kiến: " + rv["ykien"];

                decimal KQ_GQD_ID = String.IsNullOrEmpty(rv["KQ_GQD_ID"] + "") ? 0 : Convert.ToInt32(rv["KQ_GQD_ID"] + "");
                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");

                lttLanTT.Text = rv["TENTINHTRANG"] + "";
                int GiaiDoanTrinh = String.IsNullOrEmpty(rv["GiaiDoanTrinh"] + "") ? 0 : Convert.ToInt32(rv["GiaiDoanTrinh"] + "");

                if (trangthai != ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV && GiaiDoanTrinh == 2)
                {
                    #region Thông tin lien quan den To trinh
                    try
                    {
                        trangthai_trinh_id = Convert.ToDecimal(trangthai);
                        List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == CurrVuAnID
                                                          && x.TINHTRANGID == trangthai_trinh_id).OrderByDescending(y => y.NGAYTRINH).ToList();
                        if (lstTT != null && lstTT.Count > 0)
                        {
                            lttLanTT.Text += " lần " + lstTT.Count.ToString();
                            GDTTT_TOTRINH objTT = lstTT[0];
                            if (!string.IsNullOrEmpty(objTT.NGAYTRINH + "") || (DateTime)objTT.NGAYTRINH != DateTime.MinValue)
                                lttDetaiTinhTrang.Text = "<br/>Ngày trình: " + Convert.ToDateTime(objTT.NGAYTRINH).ToString("dd/MM/yyyy", cul);
                            if (!string.IsNullOrEmpty(objTT.NGAYTRA + "") || (DateTime)objTT.NGAYTRA != DateTime.MinValue)
                                lttDetaiTinhTrang.Text += "<br/><span style='margin-right:10px;'>Ngày trả: " + Convert.ToDateTime(objTT.NGAYTRA).ToString("dd/MM/yyyy", cul) + "</span>";

                            lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(lttDetaiTinhTrang.Text)) ? "" : "<br/>";
                            lttDetaiTinhTrang.Text += objTT.YKIEN + "";
                        }
                    }
                    catch (Exception ex) { }
                    #endregion
                }
                else
                {
                    if (trangthai == (int)ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV)
                    {
                        //hien ngay phan cong + qua trinh_ghi chu (GDTTT_VuAn)                       
                        lttDetaiTinhTrang.Text = (string.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") ? "" : (rv["NGAYPHANCONGTTV"].ToString() + "<br/>"))
                                                    + rv["QUATRINH_GHICHU"] + "";
                        lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();
                    }
                    else if (trangthai != ENUM_GDTTT_TRANGTHAI.THULY_XETXU_GDT)
                    {
                        int loai_giaiquyet_don = (string.IsNullOrEmpty(rv["KQ_GQD_ID"] + "")) ? 5 : Convert.ToInt16(rv["KQ_GQD_ID"] + "");
                        if (loai_giaiquyet_don <= 2)
                        {
                            String temp = "";
                            int loaian = String.IsNullOrEmpty(rv["LoaiAN"] + "") ? 0 : Convert.ToInt16(rv["LoaiAN"] + "");
                            if (loaian == Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                if (loai_giaiquyet_don == 0)
                                    lttDetaiTinhTrang.Text = rv["AHS_THONGTINGQD"] + "";
                                else
                                {
                                    temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                    temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                    temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                                    lttDetaiTinhTrang.Text = temp;
                                }
                            }
                            else
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                temp += (string.IsNullOrEmpty(rv["GQD_NGAYPHATHANHCV"] + "") || rv["GQD_NGAYPHATHANHCV"].ToString() == "01/01/0001") ? "" : "<br/>Ngày phát hành:" + rv["GQD_NGAYPHATHANHCV"].ToString();

                                lttDetaiTinhTrang.Text = temp;
                            }
                        }
                        else if (loai_giaiquyet_don == 3)
                        {
                            lttLanTT.Text = "<b>KQGQ_THS: " + " </b>" + rv["KQ_GQD"];
                        }
                        else if (loai_giaiquyet_don == 4)
                            lttLanTT.Text = "<b>Thông báo VKS " + " </b><br/>" + rv["KQ_GQD"];
                    }
                    else
                    {
                        lttDetaiTinhTrang.Text = String.IsNullOrEmpty(rv["SOTHULYXXGDT"] + "") ? "" : ("<span style='padding-right:10px;'>Số: <b>" + rv["SOTHULYXXGDT"].ToString() + "</b></span>");
                        lttDetaiTinhTrang.Text += (string.IsNullOrEmpty(rv["NGAYTHULYXXGDT"] + "")) ? "" : ("Ngày: <b>" + rv["NGAYTHULYXXGDT"].ToString() + "</b>");
                    }
                }
                //-------------------------------
                Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");
                int IsHoanTHA = Convert.ToInt16(rv["GQD_IsHoanTHA"] + "");
                if (IsHoanTHA > 0)
                {
                    lttKQGQ.Text = "<span class='line_space'>";
                    lttKQGQ.Text += "<b>Hoãn thi hành án</b>" + "<br/>";
                    lttKQGQ.Text += "Số: " + rv["GQD_HoanTHA_So"].ToString() + "<br/>";
                    lttKQGQ.Text += "Ngày: " + rv["GQD_HoanTHA_Ngay"].ToString() + "<br/>";
                    lttKQGQ.Text += "";
                    lttKQGQ.Text += "</span>";
                }
                //---------------------------
                Literal lttOther = (Literal)e.Item.FindControl("lttOther");
                int soluong = String.IsNullOrEmpty(rv["IsToTrinh"] + "") ? 0 : Convert.ToInt32(rv["IsToTrinh"] + "");
                lttOther.Text += "<span  class='line_space'>Số lần trình: <b>" + soluong + "</b></span>";
            }

            //-------------------------------
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                string strID = e.Item.Cells[0].Text;

                Literal lttTTV = (Literal)e.Item.FindControl("lttTTV");

                int count = 0;
                string StrDisplay = "", temp = "";
                string[] arr = null;
                //Decimal CurrVuAnID = Convert.ToDecimal(hddCurrID.Value);
                String PhanCongTTV = rv["PhanCongTTV"] + "";
                if (!String.IsNullOrEmpty(PhanCongTTV))
                {
                    lttTTV.Text = " TTV: <b>" + rv["TenThamTraVien"] + (String.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") ? "" : (" (" + rv["NGAYPHANCONGTTV"] + ")")) + "</b>";
                    arr = PhanCongTTV.Split("*".ToCharArray());
                    foreach (String str in arr)
                    {
                        if (str != "")
                        {
                            if (count == 0)
                                StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
                            else
                                StrDisplay += "<br/>- " + str;
                            count++;
                        }
                    }

                }
                else lttTTV.Text = " TTV: <b>" + rv["TenThamTraVien"] + "</b>";
                lttTTV.Text += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";

                //---------------------

            }
            //--------------------------------------------------

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

        protected void lbtTTTK_Click(object sender, EventArgs e)
        {
            if (pnTTTK.Visible == false)
            {
                lbtTTTK.Text = "[ Thu gọn ]";
                pnTTTK.Visible = true;
                Session[SessionSearch] = "0";
            }
            else
            {
                lbtTTTK.Text = "[ Nâng cao ]";
                pnTTTK.Visible = false;
                Session[SessionSearch] = "1";
            }
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
            txtNguyendon.Text = "";
            txtBidon.Text = "";
            ddlLoaiAn.SelectedIndex = 0;

            ddlThamtravien.SelectedIndex = 0;
            ddlPhoVuTruong.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;

            dropAnDB.SelectedIndex = 0;
            dropAnDB_TH.SelectedIndex = 0;
            //ddlTraloi.SelectedIndex = 0;
            //ddlLoaiCV.SelectedIndex = 0;

            txtThuly_Tu.Text = "";
            txtThuly_Den.Text = "";
            txtThuly_So.Text = "";
            //-----------------------------------------
            ddlTrangthaithuly.SelectedIndex = 0;

            dropIsYKienKetLuatTrinhLD.SelectedIndex = 0;
            //  dropIsYKienKetLuatTrinhLD.Enabled = dropBuocTT.Enabled = false;
            dropBuocTT.SelectedIndex = 0;

            dropCapTrinhTiepTheo.SelectedIndex = dropDangKyBC.SelectedIndex = 0;
            // dropDangKyBC.Enabled = false; dropCapTrinhTiepTheo.Enabled = true;

            //----------------------------
            ddlTotrinh.SelectedIndex = 0;
            SetVisible_SearchDateTime();

            ddlTrangthaithuly.SelectedIndex = 0;
            dropTrangThaiChuyen.SelectedIndex = 0;
            txtCV_So.Text = "";
            txtCV_Ngay.Text = "";
            SetVisible_ZoneSearchTT();

            //ddlKetquaThuLy.SelectedIndex = 0;
        }

        //---------------------------------
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            Load_Data();
            SetGetSessionTK(true);
        }
        protected void ddlPhoVuTruong_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }

        //protected void dropBuocTT_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    //dropCapTrinhTiepTheo.Enabled = false;
        //    //int tinhtrang = Convert.ToInt32(ddlTrangthaithuly.SelectedValue);
        //    //if (dropBuocTT.SelectedValue == "1" && tinhtrang > 3)
        //    //    dropCapTrinhTiepTheo.Enabled = true;
        //    //else
        //    //    dropCapTrinhTiepTheo.SelectedValue = "0";
        //}
        protected void ddlTrangthaithuly_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlTrangthaithuly.SelectedValue != "0")
            {
                decimal tt = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);
                GDTTT_DM_TINHTRANG objTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == tt).FirstOrDefault();
                if (objTT.GIAIDOAN == 2)
                {
                    //dropIsYKienKetLuatTrinhLD.Enabled = dropBuocTT.Enabled = dropDangKyBC.Enabled = true;
                    dropBuocTT.SelectedValue = "1";
                }
                else
                {
                    //dropIsYKienKetLuatTrinhLD.Enabled = dropBuocTT.Enabled = false;
                    dropIsYKienKetLuatTrinhLD.SelectedValue = dropDangKyBC.SelectedValue = "2";
                    dropCapTrinhTiepTheo.SelectedValue = dropBuocTT.SelectedValue = "0";
                    // dropDangKyBC.Enabled = false; dropCapTrinhTiepTheo.Enabled = true;
                }
                //---------------------------
                if (ddlTrangthaithuly.SelectedValue == ENUM_GDTTT_TRANGTHAI.NGHIENCUU_HOSO.ToString())
                {
                    ddlMuonHoso.SelectedValue = "1";
                    ddlTotrinh.SelectedValue = "0";
                }
                else if (tt >= ENUM_GDTTT_TRANGTHAI.TRINH_PHOVT)
                    dropCapTrinhTiepTheo.Enabled = true;
                else if (tt >= ENUM_GDTTT_TRANGTHAI.TRINH_THAMPHAN)
                    dropDangKyBC.Enabled = true;
                SetTieuDeBaoCao();
            }
            else
            {
                //dropIsYKienKetLuatTrinhLD.Enabled = dropBuocTT.Enabled = false;
                dropBuocTT.SelectedValue = "0";
                dropIsYKienKetLuatTrinhLD.SelectedValue = dropDangKyBC.SelectedValue = "2";
                dropCapTrinhTiepTheo.SelectedValue = dropBuocTT.SelectedValue = "0";
                // dropDangKyBC.Enabled = false; dropCapTrinhTiepTheo.Enabled = true;
            }
        }
        //-------------------------------------
        //protected void cmdPrint_Click_older(object sender, EventArgs e)
        //{
        //    SetGetSessionTK(true);
        //    string link = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx";
        //    string openpopup = "";
        //    String SessionName = "GDTTT_ReportPL".ToUpper();
        //    //--------------------------
        //    if (String.IsNullOrEmpty(txtTieuDeBC.Text))
        //        SetTieuDeBaoCao();

        //    Session[SS_TK.TENBAOCAO] = txtTieuDeBC.Text.Trim().ToUpper();
        //    DataTable tbl = getDS(3000000, 1);
        //    Session[SessionName] = tbl;
        //    String para = "type=va&rID=3";
        //    openpopup = "PopupReport('" + link + (String.IsNullOrEmpty(para) ? "" : "?" + para) + "','Danh sách vụ án',1000,600)";
        //    Cls_Comon.CallFunctionJS(this, this.GetType(), openpopup);
        //}

        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            try
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

                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                string vSoThuly = txtThuly_So.Text;
                decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);

                int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
                int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
                int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
                int isBuocTT = Convert.ToInt16(dropBuocTT.SelectedValue);
                int is_dangkybaocao = Convert.ToInt16(dropDangKyBC.SelectedValue);
                int captrinhtiep_id = Convert.ToInt16(dropCapTrinhTiepTheo.SelectedValue);

                int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
                String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
                int isHoanTHA = Convert.ToInt16(dropHoanTHA.SelectedValue);

                //huynt
                DateTime? vNgayCongVan = string.IsNullOrEmpty(txtCV_Ngay.Text) ? (DateTime?)null : DateTime.Parse(txtCV_Ngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                int ketqua_thuly = 4; //kết qủa = 4 mặc định là chưa có kết quả
                DataTable tbl = null;
                tbl = oBL.QLToTrinh_VuAnKhangNghi_Search_Print(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
                , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                , vNgayThulyTu, vNgayThulyDen, vSoThuly
                , vTrangthai, captrinhtiep_id, is_dangkybaocao
                , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
                , ketqua_thuly, LoaiAnDB, LoaiAnDB_TH, isHoanTHA, vNgayCongVan, ddlLOAICVPC.SelectedValue, txtCV_So.Text, dropTrangThaiChuyen.SelectedValue
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
                string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                if (loaitoa.Contains("cấp cao"))
                {
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_GDTTT.xls");
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
                else
                {
                    //--------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_TT_GDTTT.doc");
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
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");         
                    Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.2in 0.2in 0.5in 0.2in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
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
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }

        protected void cmdPrint_ClickKN(object sender, EventArgs e)
        {
            try
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

                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                string vSoThuly = txtThuly_So.Text;
                decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);

                int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
                int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
                int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
                int isBuocTT = Convert.ToInt16(dropBuocTT.SelectedValue);
                int is_dangkybaocao = Convert.ToInt16(dropDangKyBC.SelectedValue);
                int captrinhtiep_id = Convert.ToInt16(dropCapTrinhTiepTheo.SelectedValue);

                int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
                String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
                int isHoanTHA = Convert.ToInt16(dropHoanTHA.SelectedValue);

                //huynt
                DateTime? vNgayCongVan = string.IsNullOrEmpty(txtCV_Ngay.Text) ? (DateTime?)null : DateTime.Parse(txtCV_Ngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                int ketqua_thuly = 4; //kết qủa = 4 mặc định là chưa có kết quả
                DataTable tbl = null;
                tbl = oBL.QLToTrinh_VuAnKhangNghi_Search_Print(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
                , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                , vNgayThulyTu, vNgayThulyDen, vSoThuly
                , vTrangthai, captrinhtiep_id, is_dangkybaocao
                , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
                , ketqua_thuly, LoaiAnDB, LoaiAnDB_TH, isHoanTHA, vNgayCongVan, ddlLOAICVPC.SelectedValue, txtCV_So.Text, dropTrangThaiChuyen.SelectedValue
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
                else
                {
                    lbtthongbao.Text = "Không có dữ liệu để in.";
                    return;
                }
                Table_Str_Totals.Text = row["TEXT_REPORT"].ToString();


                string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                if (loaitoa.Contains("cấp cao"))
                {
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_GDTTT.xls");
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
                else
                {
                    //--------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_TT_GDTTT.doc");
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.ContentType = "application/msword";
                    HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
                    Response.Write("<html>");
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
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");         
                    Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.2in 0.2in 0.5in 0.2in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
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
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }


        protected void btnNBInPVAKN_Click(object sender, EventArgs e)
        {
            {
                SetGetSessionTK(true);
                Session["GDTTT_MABM"] = "NOIBO_VUANKHANGNGHI";
                int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
                int pageindex = Convert.ToInt32(hddPageIndex.Value);
                DataTable oDT = getDS_InPC(page_size, pageindex);
                if (oDT != null)
                {
                    if (oDT.Rows.Count == 0)
                    {
                        lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                        return;
                    }
                    //ĐỊa điểm
                    string strDiadiem = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "", strTenPhongban = "";
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                        strDiadiem = "Hà Nội";
                    else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (dNgayCV != DateTime.MinValue)
                    {
                        strNgay = dNgayCV.Day.ToString();
                        strThang = dNgayCV.Month.ToString();
                        strNam = dNgayCV.Year.ToString();
                    }
                    decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                    if (oNSD.PHONGBANID != null)
                    {
                        DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                        strTenPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                    }
                    string TAND_NHAN_ = "";
                    if (Session["CAP_XET_XU"] + "" == "TOICAO")
                    {
                        TAND_NHAN_ = "TANDTC";
                    }
                    else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        TAND_NHAN_ = "TANDCC";
                    }

                    string vNguoiKy = ddlNguoiKy.SelectedValue;
                    string v_chucvu = "";
                    if (ddlNguoiKy.SelectedValue != "0")
                    {
                        v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                        strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                    }


                    string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    DTGDTTT objds = new DTGDTTT();
                    DataTable dtTP = oDT.AsEnumerable()
                                    .AsParallel()
                                   .GroupBy(r => new { NOICHUYEN = r["NOICHUYEN"] })
                                   .Select(g => g.OrderBy(r => r["ID"]).First())
                                   .CopyToDataTable();
                    decimal sotb = Cls_Comon.GetNumber(txtBC_SoCV.Text);
                    foreach (DataRow obj in dtTP.Rows)
                    {

                        DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                        r.TENPHONGBANNHAN = obj["NOICHUYEN"] + "";

                        r.NGUOIKY = obj["NGUOIKY"].ToString();
                        DateTime vNgayCV = Convert.ToDateTime(obj["NGAYCV"]);
                        r.NGAY = vNgayCV.Day.ToString();
                        r.THANG = vNgayCV.Month.ToString();
                        r.NAM = vNgayCV.Year.ToString();
                        r.SOTOTRINH = obj["SOCV"].ToString();
                        sotb += 1;

                        r.TENDONVI = strTendonvi;
                        r.TENPHONGBANGUI = strTenPhongban;
                        r.DIADIEM = strDiadiem;
                        r.TAND_NHAN = TAND_NHAN_;
                        objds.DT_NOIBO_TOTRINH.AddDT_NOIBO_TOTRINHRow(r);
                        objds.AcceptChanges();

                    }
                    objds.AcceptChanges();
                    Session["NOIBO_DATASET"] = objds;
                }
                string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
        }

        protected void cmdPrintBC_Click(object sender, EventArgs e)
        {
            try
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

                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                string vSoThuly = txtThuly_So.Text;
                decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);

                int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
                int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
                int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
                int isBuocTT = Convert.ToInt16(dropBuocTT.SelectedValue);
                int is_dangkybaocao = Convert.ToInt16(dropDangKyBC.SelectedValue);
                int captrinhtiep_id = Convert.ToInt16(dropCapTrinhTiepTheo.SelectedValue);

                int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
                String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;
                int isHoanTHA = Convert.ToInt16(dropHoanTHA.SelectedValue);

                int ketqua_thuly = 4; //kết qủa = 4 mặc định là chưa có kết quả
                DataTable tbl = null;
                tbl = oBL.QLToTrinh_VuAnKhangNghi_Search_Print_BC(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
                , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                , vNgayThulyTu, vNgayThulyDen, vSoThuly
                , vTrangthai, captrinhtiep_id, is_dangkybaocao
                , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
                , ketqua_thuly, LoaiAnDB, LoaiAnDB_TH, isHoanTHA
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
                string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                if (loaitoa.Contains("cấp cao"))
                {
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_GDTTT.xls");
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
                else
                {
                    //--------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_DSTOTRINHDADUYET.doc");
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
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");         
                    Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.2in 0.2in 0.5in 0.2in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
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

            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        void SetTieuDeBaoCao()
        {
            string tieudebc = "";

            //-------------------------------------
            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += " " + ddlLoaiAn.SelectedItem.Text.ToLower();
            //-------------------------------------
            if (dropAnDB.SelectedValue != "0")
                tieudebc += " là " + dropAnDB.SelectedItem.Text.ToLower();
            //-------------------------------------
            String canbophutrach = "";
            if (ddlThamphan.SelectedValue != "0")
                canbophutrach = "thẩm phán " + Cls_Comon.FormatTenRieng(ddlThamphan.SelectedItem.Text);

            if (ddlPhoVuTruong.SelectedValue != "0")
                canbophutrach += ((string.IsNullOrEmpty(canbophutrach)) ? "" : ", ") + "lãnh đạo Vụ " + ddlPhoVuTruong.SelectedItem.Text;

            if (!String.IsNullOrEmpty(canbophutrach))
                canbophutrach += " phụ trách";

            tieudebc += (string.IsNullOrEmpty(canbophutrach)) ? "" : " do " + canbophutrach;
            //-------------------------------------
            if (ddlMuonHoso.SelectedValue != "2")
                tieudebc += " " + ddlMuonHoso.SelectedItem.Text.ToLower();

            if (ddlTotrinh.SelectedValue != "2")
                tieudebc += " " + ddlTotrinh.SelectedItem.Text.ToLower();

            if (ddlTrangthaithuly.SelectedValue != "0")
                tieudebc += " " + ddlTrangthaithuly.SelectedItem.Text.ToLower();

            if (dropIsYKienKetLuatTrinhLD.Enabled == true && dropIsYKienKetLuatTrinhLD.SelectedValue != "2")
                tieudebc += " " + dropIsYKienKetLuatTrinhLD.SelectedItem.Text.ToLower();

            //txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc.Replace("...", "");
        }
        //protected void lkInBC_OpenForm_Click(object sender, EventArgs e)
        //{
        //    if (pnInBC.Visible == false)
        //    {
        //        lkInBC_OpenForm.Text = "[ Thu gọn ]";
        //        pnInBC.Visible = true;
        //        Session[SessionInBC] = "0";
        //    }
        //    else
        //    {
        //        lkInBC_OpenForm.Text = "[ Mở ]";
        //        pnInBC.Visible = false;
        //        Session[SessionInBC] = "1";
        //    }
        //}
        protected void lbtTTBC_Click(object sender, EventArgs e)
        {
            if (pnTTBC.Visible)
            {
                lbtTTBC.Text = "[ Mở ]";
                pnTTBC.Visible = false;
                Session["TTBCVISIBLE"] = "0";
            }
            else
            {
                lbtTTBC.Text = "[ Đóng ]";
                pnTTBC.Visible = true;
                Session["TTBCVISIBLE"] = "1";
            }
        }
        protected void dropAnDB_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlTotrinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            SetVisible_SearchDateTime();
        }
        void SetVisible_SearchDateTime()
        {
            //dropIsYKienKetLuatTrinhLD.Enabled = dropBuocTT.Enabled = false;
            // dropDangKyBC.Enabled = false; dropCapTrinhTiepTheo.Enabled = true;
            string trangthai_totrinh = ddlTotrinh.SelectedValue;
            if ((trangthai_totrinh == "1") || (trangthai_totrinh == "-1"))
            {
                //txtThuly_Tu.Enabled = txtThuly_Den.Enabled = true;
                // dropIsYKienKetLuatTrinhLD.Enabled = dropBuocTT.Enabled = true;
                //  dropDangKyBC.Enabled = true; dropCapTrinhTiepTheo.Enabled = true;
            }
            else if (trangthai_totrinh == "0")
            {
                //txtThuly_Tu.Enabled = false;
                txtThuly_Tu.Text = "";
                txtThuly_Den.Enabled = true;
            }
            else if (trangthai_totrinh == "2")
            {
                txtThuly_Tu.Text = txtThuly_Den.Text = "";
                // txtThuly_Tu.Enabled = txtThuly_Den.Enabled = false;
            }
        }
        void SetVisible_ZoneSearchTT()
        {
            int trangthai = Convert.ToInt32(ddlTrangthaithuly.SelectedValue);
            if (trangthai <= 3)
            {
                //dropIsYKienKetLuatTrinhLD.Enabled = dropBuocTT.Enabled = false;
                dropIsYKienKetLuatTrinhLD.SelectedIndex = dropDangKyBC.SelectedIndex = 0;

                dropCapTrinhTiepTheo.SelectedIndex = dropBuocTT.SelectedIndex = 0;
                dropDangKyBC.Enabled = false; dropCapTrinhTiepTheo.Enabled = true;

                if (ddlTrangthaithuly.SelectedValue == ENUM_GDTTT_TRANGTHAI.NGHIENCUU_HOSO.ToString())
                {
                    ddlMuonHoso.SelectedValue = "1";
                    ddlTotrinh.SelectedValue = "0";
                }
            }
            else
            {
                //if (trangthai >= ENUM_GDTTT_TRANGTHAI.TRINH_PHOVT)
                //    dropCapTrinhTiepTheo.Enabled = true;
                //else if (trangthai >= ENUM_GDTTT_TRANGTHAI.TRINH_THAMPHAN)
                //    dropDangKyBC.Enabled = true;

                GDTTT_DM_TINHTRANG objTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == trangthai).FirstOrDefault();
                if (objTT.GIAIDOAN == 2)
                {
                    //dropIsYKienKetLuatTrinhLD.Enabled = dropBuocTT.Enabled = dropDangKyBC.Enabled = true;
                    dropBuocTT.SelectedValue = "1";
                }
                else
                {
                    //dropIsYKienKetLuatTrinhLD.Enabled = dropBuocTT.Enabled = false;
                    dropIsYKienKetLuatTrinhLD.SelectedValue = dropDangKyBC.SelectedValue = "2";
                    dropCapTrinhTiepTheo.SelectedValue = dropBuocTT.SelectedValue = "0";
                    // dropDangKyBC.Enabled = false; dropCapTrinhTiepTheo.Enabled = true;
                }
            }
        }
        protected void Drop_LoaiSo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiso.SelectedValue != "0")
            {
                Layso_SoVB();
                btnLuuVBchuyen.Enabled = true;
                btnLuuVBchuyen.CssClass = "buttoninput";

                Load_Data();
                LoadDropNguoiKy();
            }
            else
            {
                ddlNguoiKy.Items.Clear();
                ddlNguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

                btnLuuVBchuyen.Enabled = false;
                btnLuuVBchuyen.CssClass = "buttonprintdisable";
            }

        }
        private void Layso_SoVB()
        {
            //Load loại sổ văn bản
            string vddlLoaiso = ddlLoaiso.SelectedValue;
            DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            if (vddlLoaiso == "YCBS")
            {
                txtBC_SoCV.Text = oBL.YC_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, 0).ToString();
                txtBC_Ngaydk.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }
            else
            {
                txtBC_SoCV.Text = oBL.SOVB_GETMAXTT_VUAN(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PhongBanID, dNgayCV.Year, vddlLoaiso).ToString();
                txtBC_Ngaydk.Text = dNgayCV.ToString("dd/MM/yyyy");
            }
        }

        private void LoadDropNguoiKy()
        {
            // Load Ngườiky
            ddlNguoiKy.Items.Clear();
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable dt = oDMCBBL.DM_CANBO_GetAllVuTruong_PVT(PhongBanID); //chỉ lấy VT, PVT
            ddlNguoiKy.DataSource = dt;
            ddlNguoiKy.DataTextField = "MA_TEN";
            ddlNguoiKy.DataValueField = "MA_TEN";
            ddlNguoiKy.DataBind();

            ddlNguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {

            CheckBox chk = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chk.ToolTip);
            foreach (DataGridItem Item in dgList.Items)
            {


            }
        }
        private void setButtonPrint(bool flag, Button cmd)
        {
            if (flag)
            {
                cmd.Enabled = flag;
                cmd.CssClass = "buttonprint";
            }
            else
            {
                cmd.Enabled = flag;
                cmd.CssClass = "buttonprintdisable";
            }
        }
        protected void btnLuuVB_Click(object sender, EventArgs e)
        {
            if ((txtBC_Ngaydk.Text == "" || txtBC_SoCV.Text == "" || ddlNguoiKy.SelectedValue == "0"))
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa nhập đầy đủ thông tin số công văn, ngày chuyển, người ký!')", true);
                return;
            }
            else
            {
                try
                {
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                    decimal PBID = 0;
                    if (strPBID != "") PBID = Convert.ToDecimal(strPBID);
                    //kiem tra đã có số CV chưa
                    bool flag = false;
                    string mess;
                    //Kiem tra xem số công văn chuyển này đã có chưa 
                    string vCD_SOCV = txtBC_SoCV.Text;
                    DateTime vCD_NGAYCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                    //Lấy các đơn id sẽ thêm số
                    string vuanid_chon = null;
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            flag = true;
                            string strID = Item.Cells[0].Text;
                            if (vuanid_chon == null)
                                vuanid_chon = strID;
                            else
                                vuanid_chon = vuanid_chon + ',' + strID;
                        }
                    }

                    if (vuanid_chon != null)
                    {
                        //Kiểm tra vụ án đã có số chưa, nếu có rồi thì không cho thêm số
                        string[] strarr = vuanid_chon.Split(',');
                        if (strarr.Length > 0)
                        {
                            for (int k = 0; k < strarr.Length; k++)
                            {
                                decimal kID = Convert.ToDecimal(strarr[k]);
                                if (oBL.CHECK_VUAN_KHANGNGHI_LUUSO(CurrDonViID, PhongBanID, ddlLoaiso.SelectedValue, kID, TYPE_SOVB_DONVI.VUGIAMDOC) == true)
                                {
                                    mess = "alert('Vụ án này đã có Số " + ddlLoaiso.SelectedItem + "! Bạn kiểm tra lại')";
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                    return;
                                }
                                //kiểm tra vụ án đã được chuyển thì không cho thêm công văn
                                GDTTT_VUAN_CHITIET_CHUYEN oT = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == kID).FirstOrDefault();
                                if (oT != null && (oT.TRANGTHAI == 1 || oT.TRANGTHAI == 2))
                                {
                                    mess = "alert('Vụ án này đã chuyển! Không thể thêm công văn')";
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                    return;
                                }
                            }
                        }
                    }
                    if (flag == false)
                    {
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa chọn vụ án để thêm số Công văn!')", true);
                        return;
                    }

                    // kiem tra Văn bản da ton tai chua CHECK_SOVANBAN ngoài Tờ trình
                    decimal vPHATHANHID = 0;
                    if (oBL.CHECK_VUAN_SOVANBAN(CurrDonViID, PhongBanID, ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim()) == true)
                    {
                        mess = "alert('Số " + ddlLoaiso.SelectedItem + " " + vCD_SOCV + " Ngày " + vCD_NGAYCV.ToString("dd/MM/yyyy") + " này đã tồn tại! Bạn kiểm tra lại')";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                    }
                    else
                    {
                        string vNguoiKy = ddlNguoiKy.SelectedValue;
                        string v_chucvu = "";
                        string v_hoten = "";
                        if (ddlNguoiKy.SelectedValue != "0")
                        {
                            v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                            v_hoten = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                        }
                        //insert vao So Van ban
                        vPHATHANHID = oBL.SOVANBAN_VUAN_INSERT(CurrDonViID, PhongBanID, TYPE_SOVB_DONVI.VUGIAMDOC, null, ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim(),
                            v_hoten, v_chucvu, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                        if (vPHATHANHID > 0)
                        {
                            mess = "Cập nhật Số Văn bản thành công!";
                            foreach (DataGridItem Item in dgList.Items)
                            {
                                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                                if (chkChon.Checked)
                                {
                                    string strID = Item.Cells[0].Text;
                                    decimal ID = Convert.ToDecimal(strID);
                                    //Insert sophathanh_vuan
                                    oBL.SOPHATHANH_VUAN_INSERT(vPHATHANHID, ID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                }
                            }

                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành việc thêm số Văn bản vào vụ án!')", true);
                            Load_Data();
                            //Hiển thị nút chuyển đơn
                            btnChuyenVuAn.Enabled = true;
                            btnChuyenVuAn.CssClass = "buttoninput";
                        }
                        else
                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Cập nhật Số Văn bản lỗi. Liên hệ với quản trị để được hỗ trợ!')", true);
                    }

                    //Lay so van ban theo loại VB
                    Layso_SoVB();
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = "Lỗi khi thêm số Công văn: " + ex.Message;
                }
            }
        }

        protected void btnQuanlyVB_Click(object sender, EventArgs e)
        {
            Response.Redirect("/QLAN/GDTTT/VuAn/QuanlySoVBVAKN.aspx");
            //SetGetSessionTK(true);

            //string StrMsg = "PopupReport('/QLAN/GDTTT/Hoso/Popup/SuaCongvan.aspx','Sửa đổi công văn',1150,800);";
            //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnNBInTotrinh_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(2, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=ToTrinhPhanCong.doc");
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
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section1 {page:Section1;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section1>");//chỉ định khổ giấy
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
        private DataTable getDS_BC(Decimal mau_bc, bool isCV, bool isOnPrint, bool isTraigiam, bool isChiDao, bool isTBQuahan)
        {
            int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
            decimal isDonGoc = 1;
            if (txtThuly_So.Text != "")
                isDonGoc = 0;
            Session[SS_TK.ISDONGOC] = isDonGoc;
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue),
                 DiaChiTinh = 0,
                DiaChiHuyen = 0;
            string SoBAQD = txtSoQDBA.Text.Trim(), NgayBAQD = txtNgayBAQD.Text,
                strNguoiNhap = "";

            if (strNguoiNhap != "") strNguoiNhap = "," + strNguoiNhap + ",";

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault)
                , vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;

            decimal vTBQuahan = 0, vThamphanID = 0, vThamtravienID = 0, vLoaiCVID = 0;
            DateTime vNgayQuahan = DateTime.Now;
            if (isTBQuahan)
            {
                vTBQuahan = 1;
                if (txtBC_Ngaydk.Text != "")
                {
                    vNgayQuahan = DateTime.Parse(txtBC_Ngaydk.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (vNgayQuahan == null) vNgayQuahan = DateTime.Now;
                }
            }
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);
            if (isOnPrint)
            {
                pageindex = 1;
                page_size = 10000;
            }
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);

            DataTable oDT = new DataTable();
            if (mau_bc == 1)//Phiếu chuyển thụ lý mới
            {
                oDT = oBL.GDTTT_DON_SEARCH_THU_LY_MOI(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                       null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                       null, null, null, null, 0, strNguoiNhap, 0,
                       0, 0, 0, null, null, null, null, 0, 0
                       , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                       vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 2)//Tờ trình phân công
            {
                oDT = oBL.GDTTT_DON_SEARCH_TTRINH_PHANCONG(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                      null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                      null, null, null, null, 0, strNguoiNhap, 0,
                      0, 0, 0, null, null, null, null, 0, 0
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 3)//DS đơn & TP giải quyết
            {

                oDT = oBL.GDTTT_DON_TP_GIAI_QUYET(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                      null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                      null, null, null, null, 0, strNguoiNhap, 0,
                      0, 0, 0, null, null, null, null, 0, 0
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 4)//Danh sách thụ lý mới
            {

                oDT = oBL.GDTTT_DON_DS_TL_MOI(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                      null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                      null, null, null, null, 0, strNguoiNhap, 0,
                      0, 0, 0, null, null, null, null, 0, 0
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 5)//Danh sách đơn chưa đủ điều kiện
            {
                oDT = oBL.GDTTT_DON_DS_DON_CHUA_DU_DK(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                      null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                      null, null, null, null, 0, strNguoiNhap, 0,
                      0, 0, 0, null, null, null, null, 0, 0
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 6)//Danh sách đơn trùng
            {
                oDT = oBL.GDTTT_DON_TRUNG(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                      null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                      null, null, null, null, 0, strNguoiNhap, 0,
                      0, 0, 0, null, null, null, null, 0, 0
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 7)//Danh sách chuyển tòa án khác
            {
                oDT = oBL.GDTTT_DON_CHUYEN_TOA_AN_KHAC(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                      null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                      null, null, null, null, 0, strNguoiNhap, 0,
                      0, 0, 0, null, null, null, null, 0, 0
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 8)//Danh sách chuyển ngoài tòa
            {
                oDT = oBL.GDTTT_DON_CHUYEN_NGOAI_TOA(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                      null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                      null, null, null, null, 0, strNguoiNhap, 0,
                      0, 0, 0, null, null, null, null, 0, 0
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 9)//Danh sách Kết quả do cơ quan của quốc hội
            {
                oDT = oBL.GDTTT_DON_CHUYEN_CQ_QUOC_HOI(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                null, null, null, 0, strNguoiNhap, 0,
                0, 0, 0, null, null, null, null, 0, 0
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 10)//In phiếu gửi cơ quan chuyển đơn
            {
                oDT = oBL.GDTTT_GUI_COQUAN_CHUYENDON(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                      null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                      null, null, null, null, 0, strNguoiNhap, 0,
                      0, 0, 0, null, null, null, null, 0, 0
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 11)//Giấy xác nhận
            {
                oDT = oBL.GDTTT_DON_SEARCH_GIAY_XAC_NHAN(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                null, null, null, 0, strNguoiNhap, 0,
                0, 0, 0, null, null, null, null, 0, 0
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }
            else if (mau_bc == 12)//Thong bao yeu cau bo sung don khong du điều kiện
            {
                oDT = oBL.GDTTT_DON_SEARCH_THONG_BAO_YCBSCC(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                null, null, null, 0, strNguoiNhap, 0,
                0, 0, 0, null, null, null, null, 0, 0
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, 0, 0, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, null, null, isDonGoc, 0, vLoaiAn, null, null, null, 0, pageindex, page_size);
            }

            return oDT;
        }

        private bool Check_Bao_Cao(String v_bieumau)
        {
            //"SoGXN"  Giấy xác nhận//"SoCVC"  Công văn chuyển //"SoCVCTK"  Công văn chuyển Tòa khác //"SoCVCN"  Công văn chuyển ngoài
            //"SoTralaidon"  Trả lại đơn  //"SoTT"  Tờ trình      //"TBTP"  Thông báo phân công Thẩm phán
            String strMsg = "";
            if (dgList.Items.Count == 0)
            {
                strMsg = "chưa tìm thấy dữ liệu trên danh sách";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                return false;
            }
            if (v_bieumau == "btnNBPhieuchuyen")
            {
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        string strID = Item.Cells[0].Text;
                        decimal ID = Convert.ToDecimal(strID);
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        if ((oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3 || oT.CD_TRANGTHAI == 4) && (oT.CD_LOAI > 0 || (oT.CD_LOAI == 0 && oT.CD_TA_TRANGTHAI == 0)))
                        {
                            if (oT.ISTHULY == 1)//thụ lý mới
                            {
                                if (oT.THAMPHANID == 0 || oT.THAMPHANID == null)
                                {
                                    strMsg = "Bạn chưa phân công thẩm phán";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    return false;
                                }
                                if (oBL.CHECK_SOVB_DON("SoTT", CurrDonViID, PhongBanID, ID) == 0)
                                {
                                    strMsg = "Bạn chưa nhập thông tin tờ trình";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    return false;
                                }
                            }
                        }
                    }
                }
            }
            if (v_bieumau == "btnNBPhieuchuyen_TL_Lai")
            {
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        string strID = Item.Cells[0].Text;
                        decimal ID = Convert.ToDecimal(strID);
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        if ((oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3 || oT.CD_TRANGTHAI == 4) && (oT.CD_LOAI > 0 || (oT.CD_LOAI == 0 && oT.CD_TA_TRANGTHAI == 0)))
                        {
                            if (oT.ISTHULY == 1)//thụ lý mới
                            {
                                if (oT.THAMPHANID == 0 || oT.THAMPHANID == null)
                                {
                                    strMsg = "Bạn chưa phân công thẩm phán";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    return false;
                                }
                            }
                        }
                    }
                }
            }
            return true;
        }
        private string getDiaDiem(decimal ToaAnID)
        {
            try
            {
                string strDiadiem = "";
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                strDiadiem = oT.TEN.Replace("Tòa án nhân dân ", "");
                switch (oT.LOAITOA)
                {
                    case "CAPHUYEN":
                        DM_TOAAN opT = dt.DM_TOAAN.Where(x => x.ID == oT.CAPCHAID).FirstOrDefault();
                        strDiadiem = opT.TEN.Replace("Tòa án nhân dân ", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp." + strDiadiem;
                        break;
                    case "CAPTINH":
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp." + strDiadiem;
                        break;
                    case "CAPCAO":
                        strDiadiem = strDiadiem.Replace("cấp cao", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp." + strDiadiem;
                        break;
                }
                return strDiadiem;
            }
            catch (Exception ex) { return ""; }
        }
        private string reStr(string str)
        {
            if (str.Length == 1)
                str = "0" + str;
            return str;
        }
        //DS đơn & TP giải quyết
        protected void btnNBInDSTP_Click_Excel(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(3, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_DON_TP_GQ.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</body>");   // add the style props to get the page orientation
            Response.Write("</html>");   // add the style props to get the page orientation
            Response.End();
        }
        protected void btnNBInDSTP_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(3, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_DON_TP_GQ.doc");
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

        private string AddExcelStyling(Int32 landscape, String INSERT_PAGE_BREAK)
        {
            // add the style props to get the page orientation
            StringBuilder sb = new StringBuilder();
            sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'\n" +
            "xmlns:x='urn:schemas-microsoft-com:office:excel'\n" +
            "xmlns='http://www.w3.org/TR/REC-html40'>\n" +
            "<head>\n");
            sb.Append("<style>\n");
            sb.Append("@page");
            //page margin can be changed based on requirement.....            
            //sb.Append("{margin:0.5in 0.2992125984in 0.5in 0.5984251969in;\n");
            sb.Append("{margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;\n");
            sb.Append("mso-header-margin:.5in;\n");
            sb.Append("mso-footer-margin:.5in;\n");
            if (landscape == 2)//landscape orientation
            {
                sb.Append("mso-page-orientation:landscape;}\n");
            }
            sb.Append("</style>\n");
            sb.Append("<!--[if gte mso 9]><xml>\n");
            sb.Append("<x:ExcelWorkbook>\n");
            sb.Append("<x:ExcelWorksheets>\n");
            sb.Append("<x:ExcelWorksheet>\n");
            sb.Append("<x:Name>Projects 3 </x:Name>\n");
            sb.Append("<x:WorksheetOptions>\n");
            sb.Append("<x:Print>\n");
            sb.Append("<x:ValidPrinterInfo/>\n");
            sb.Append("<x:PaperSizeIndex>9</x:PaperSizeIndex>\n");
            sb.Append("<x:HorizontalResolution>600</x:HorizontalResolution\n");
            sb.Append("<x:VerticalResolution>600</x:VerticalResolution\n");
            sb.Append("</x:Print>\n");
            sb.Append("<x:Selected/>\n");
            sb.Append("<x:DoNotDisplayGridlines/>\n");
            sb.Append("<x:ProtectContents>False</x:ProtectContents>\n");
            sb.Append("<x:ProtectObjects>False</x:ProtectObjects>\n");
            sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>\n");
            sb.Append("</x:WorksheetOptions>\n");
            //-------------
            if (INSERT_PAGE_BREAK != null)
            {
                sb.Append("<x:PageBreaks> xmlns='urn:schemas-microsoft-com:office:excel'\n");
                sb.Append("<x:RowBreaks>\n");
                String[] rows_ = INSERT_PAGE_BREAK.Split(',');
                String Append_s = "";
                for (int i = 0; i < rows_.Length; i++)
                {
                    Append_s = Append_s + "<x:RowBreak><x:Row>" + rows_[i] + "</x:Row></x:RowBreak>\n";
                }
                sb.Append(Append_s);
                sb.Append("</x:RowBreaks>\n");
                sb.Append("</x:PageBreaks>\n");
            }
            //----------
            sb.Append("</x:ExcelWorksheet>\n");
            sb.Append("</x:ExcelWorksheets>\n");
            sb.Append("<x:WindowHeight>12780</x:WindowHeight>\n");
            sb.Append("<x:WindowWidth>19035</x:WindowWidth>\n");
            sb.Append("<x:WindowTopX>0</x:WindowTopX>\n");
            sb.Append("<x:WindowTopY>15</x:WindowTopY>\n");
            sb.Append("<x:ProtectStructure>False</x:ProtectStructure>\n");
            sb.Append("<x:ProtectWindows>False</x:ProtectWindows>\n");
            sb.Append("</x:ExcelWorkbook>\n");
            sb.Append("</xml><![endif]-->\n");
            sb.Append("</head>\n");
            sb.Append("<body>\n");
            return sb.ToString();
        }
        protected void btnNBInTBC_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(1, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=phieu_chuyen_tl_moi.doc");
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
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section1 {page:Section1;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section1>");//chỉ định khổ giấy
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
        protected void btnNBInDS_Click(object sender, EventArgs e)
        {

            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(4, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_DON_TL_MOI.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</body>");   // add the style props to get the page orientation
            Response.Write("</html>");   // add the style props to get the page orientation
            Response.End();
        }
        protected void btnNBInDSTrung_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(6, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_DON_TRUNG.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</body>");   // add the style props to get the page orientation
            Response.Write("</html>");   // add the style props to get the page orientation
            Response.End();
        }

        protected void btnNBDSChuaDDK_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(5, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_DON_CHUA_DU_DK.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Response.Write(AddExcelStyling(2, null));   // add the style props to get the page orientation
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</body>");   // add the style props to get the page orientation
            Response.Write("</html>");   // add the style props to get the page orientation
            Response.End();
        }
        protected void btnTKDanhsach_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            String INSERT_PAGE_BREAK = "";
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(7, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                INSERT_PAGE_BREAK = row["INSERT_PAGE_BREAK"] + "";
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_DON_CHUYEN_TA_KHAC.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</body>");   // add the style props to get the page orientation
            Response.Write("</html>");   // add the style props to get the page orientation
            Response.End();
        }
        protected void btnTKCoquan_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(10, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=gui_cq_chuyendon.doc");
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
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section1 {page:Section1;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section1>");//chỉ định khổ giấy
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
        protected void btnNTADanhsach_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            String INSERT_PAGE_BREAK = "";
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(8, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                INSERT_PAGE_BREAK = row["INSERT_PAGE_BREAK"] + "";
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_DON_CHUYEN_NGOAI_TOA.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</body>");   // add the style props to get the page orientation
            Response.Write("</html>");   // add the style props to get the page orientation
            Response.End();
        }
        //In danh sách kết quả do cơ quan quốc hội
        protected void btnNBInKQ_QuocHoi_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            String INSERT_PAGE_BREAK = "";
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(9, false, true, false, false, false);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                INSERT_PAGE_BREAK = row["INSERT_PAGE_BREAK"] + "";
            }
            //-------------------Export---------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_KQ_DO_CQ_QUOC_HOI.xls");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/vnd.xls";
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</body>");   // add the style props to get the page orientation
            Response.Write("</html>");   // add the style props to get the page orientation
            Response.End();
        }
        protected void btnChuyenVuAn_Click(object sender, EventArgs e)
        {
            if (Check_ChuyenVuAN() == true)
            {
                try
                {
                    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                    decimal PBID = 0;
                    if (strPBID != "") PBID = Convert.ToDecimal(strPBID);

                    int iCount = 0;

                    foreach (DataGridItem Item in dgList.Items)
                    {
                        string strID = Item.Cells[0].Text;
                        decimal ID = Convert.ToDecimal(strID);
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            GDTTT_VUAN_CHITIET_CHUYEN oT = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == ID).FirstOrDefault();
                            //vụ án đã được chuyển hoặc được HCTP nhận
                            if (oT != null && oT.TRANGTHAI == 1)
                            {
                                string strMsg = "Vụ án đã được chuyển, không thể chuyển tiếp";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                return;
                            }
                            if (oT != null && oT.TRANGTHAI == 2)
                            {
                                string strMsg = "Vụ án đã được HCTP nhận, không thể thao tác";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                return;
                            }
                            iCount += 1; // tổng số vụ án được tích chọn
                        }
                    }

                    //insert vào bảng thông tin chuyển
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    decimal thongTinChuyenNextVal = oBL.GET_GDTTT_VUAN_THONGTIN_CHUYEN_NEXTVAL();
                    GDTTT_VUAN_THONGTIN_CHUYEN tt = new GDTTT_VUAN_THONGTIN_CHUYEN()
                    {
                        ID = thongTinChuyenNextVal,
                        NGAYCHUYEN = DateTime.Now,
                        NGUOICHUYEN = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                        SOLUONGVUAN = iCount
                    };
                    dt.GDTTT_VUAN_THONGTIN_CHUYEN.Add(tt);
                    dt.SaveChanges();

                    //chạy vòng lặp insert vào bảng chi tiết chuyển
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            string strID = Item.Cells[0].Text;
                            decimal ID = Convert.ToDecimal(strID);
                            Update_VuAnChuyen(tt.ID, ID);
                        }
                    }

                    Load_Data();
                    lbtthongbao.Text = "Hoàn thành chuyển " + iCount.ToString() + " vụ án !";
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = "Lỗi khi chuyển vụ án: " + ex.Message;
                }
            }
            else
            {
                return;
            }
        }

        void Update_VuAnChuyen(Decimal THONGTIN_CHUYEN_ID, Decimal VuAnID)
        {
            GDTTT_VUAN_CHITIET_CHUYEN objLS;
            List<GDTTT_VUAN_CHITIET_CHUYEN> lstC = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
            if (lstC.Count > 0)
                objLS = lstC[0];
            else
                objLS = new GDTTT_VUAN_CHITIET_CHUYEN();
            objLS.THONGTIN_CHUYEN_ID = THONGTIN_CHUYEN_ID;
            objLS.VUANID = VuAnID;
            objLS.TRANGTHAI = 1;//đã chuyển chưa nhận
            objLS.NGAYCHUYEN = DateTime.Now;
            objLS.NGUOICHUYEN = Session[ENUM_SESSION.SESSION_USERNAME] + "";

            //Lay thong tin Số Cong van chuyển
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable objVB = oBL.GET_SOVB_VUAN("SoCV", CurrDonViID, PhongBanID, VuAnID);
            if (objVB.Rows.Count > 0)
            {
                //DateTime dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime dNgayCV;
                if (!DateTime.TryParse(objVB.Rows[0]["NGAYVB"].ToString(), out dNgayCV))
                {
                    dNgayCV = DateTime.MinValue;
                }
                objLS.SOCV = objVB.Rows[0]["SOVB"].ToString();
                objLS.NGAYCV = dNgayCV;
                objLS.NGUOIKY = objVB.Rows[0]["NGUOIKY"].ToString();
            }

            //lấy thông tin vụ án đang cần chuyển
            GDTTT_VUAN vuan = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault() ?? new GDTTT_VUAN();
            objLS.DONVICHUYENID = CurrDonViID;
            objLS.DONVINHANID = vuan.TOAANID;
            objLS.PHONGBANCHUYENID = PhongBanID;
            objLS.PHONGBANNHANID = vuan.PHONGBANID;
            if (lstC.Count == 0)
            {
                decimal chitietChuyenNextVal = oBL.GET_GDTTT_VUAN_CHITIET_CHUYEN_NEXTVAL();
                dt.GDTTT_VUAN_CHITIET_CHUYEN.Add(objLS);
                objLS.ID = chitietChuyenNextVal;
                dt.GDTTT_VUAN_CHITIET_CHUYEN.Add(objLS);
            }
            dt.SaveChanges();
        }

        protected void btnThuHoi_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                decimal PBID = 0;
                if (strPBID != "") PBID = Convert.ToDecimal(strPBID);

                bool flag = false;
                int count_Checked = 0;

                //validate
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        flag = true;
                        string strID = Item.Cells[0].Text;
                        decimal ID = Convert.ToDecimal(strID);

                        GDTTT_VUAN vuan = dt.GDTTT_VUAN.Where(x => x.ID == ID).FirstOrDefault() ?? new GDTTT_VUAN();
                        GDTTT_VUAN_CHITIET_CHUYEN ctChuyen = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == ID && x.DONVINHANID == vuan.TOAANID && x.PHONGBANNHANID == vuan.PHONGBANID).OrderByDescending(x => x.NGAYCHUYEN).FirstOrDefault();

                        if (ctChuyen == null)
                        {
                            string strMsg = "Vụ án có số phúc thẩm " + vuan.SOANPHUCTHAM + " chưa được chuyển nên không thể thu hồi !";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            return;
                        }
                        if (ctChuyen.TRANGTHAI == 2)//1 Chưa nhận; 2 Đã nhận; 3 Trả lại; 4 Đã chuyển
                        {
                            string strMsg = "Vụ án có số phúc thẩm " + vuan.SOANPHUCTHAM + " đã được HCTP nhận, bạn không thể thu hồi !";
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            return;
                        }
                    }
                }

                //thực hiện chuyển
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");

                    if (chkChon.Checked)
                    {
                        count_Checked += 1;
                        flag = true;
                        string strID = Item.Cells[0].Text;
                        decimal ID = Convert.ToDecimal(strID);

                        GDTTT_VUAN vuan = dt.GDTTT_VUAN.Where(x => x.ID == ID).FirstOrDefault() ?? new GDTTT_VUAN();
                        GDTTT_VUAN_CHITIET_CHUYEN ctChuyen = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == ID && x.DONVINHANID == vuan.TOAANID && x.PHONGBANNHANID == vuan.PHONGBANID).OrderByDescending(x => x.NGAYCHUYEN).FirstOrDefault();

                        if (ctChuyen.TRANGTHAI == 1)
                        {
                            //Xóa thông tin đã chuyển
                            dt.GDTTT_VUAN_CHITIET_CHUYEN.Remove(ctChuyen);
                        }
                    }
                }
                dt.SaveChanges();
                if (flag == false)
                {
                    lbtthongbao.Text = "Chưa chọn đơn để thu hồi !";
                    return;
                }
                else
                {
                    Load_Data();
                    lbtthongbao.Text = "Hoàn thành thu hồi " + count_Checked.ToString() + " đơn !";
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = "Lỗi khi chuyển đơn: " + ex.Message;
            }
        }

        private bool Check_ChuyenVuAN()
        {
            String strMsg = "";
            bool checkTick = false;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    checkTick = true;
                    string strID = Item.Cells[0].Text;
                    decimal ID = Convert.ToDecimal(strID);

                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    if (oBL.CHECK_SOVB_VUAN("SoCV", CurrDonViID, PhongBanID, ID) == 0)
                    {
                        strMsg = "Bạn chưa nhập thông tin công văn";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return false;
                    }
                }
            }
            if (!checkTick)
            {
                lbtthongbao.Text = "Chưa chọn vụ án để chuyển !";
                return false;
            }
            return true;
        }

        protected void txtCV_So_OnChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtCV_So.Text) && !string.IsNullOrEmpty(txtCV_Ngay.Text) && txtCV_Ngay.Text != "")
            {
                btnNBInPVAKN.Visible = true;
                btnNBInDSVAKN.Visible = true;
                Load_Data();
            }
            else
            {
                btnNBInPVAKN.Visible = false;
                btnNBInDSVAKN.Visible = false;
            }
        }

        protected void dropTrangThaiChuyen_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_Data();
        }

        protected void Drop_LoaiThamPhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);

            if (ddlLoaiThamPhan.SelectedValue == "0")
            {
                DataTable tbl = oBL.GDTTT_VuAn_GetAllCBTheoPB(ToaAnID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            else if (ddlLoaiThamPhan.SelectedValue == "1") // thẩm phán tối cao
            {
                ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "0", PBID);
                ddlThamphan.DataTextField = "hotenngaysinh";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
            }
            else if (ddlLoaiThamPhan.SelectedValue == "2") // thẩm phán bậc 3
            {
                ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", PBID);
                ddlThamphan.DataTextField = "hotenngaysinh";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
            }
        }
    }
}