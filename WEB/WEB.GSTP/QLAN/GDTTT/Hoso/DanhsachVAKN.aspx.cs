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

namespace WEB.GSTP.QLAN.GDTTT.Hoso
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
            scriptManager.RegisterPostBackControl(this.btnNBInTotrinh);
            scriptManager.RegisterPostBackControl(this.btnNBPhieuchuyen);
            scriptManager.RegisterPostBackControl(this.btnNBInDSVAKN);
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
                    //---------------------------
                    LoadDropBox();
                    LoadDropTinh();
                    SetGetSessionTK(false);
                    //Khong cho Load du lieu khi chua nhan tim kiem
                    //if (Session[SS_TK.NGUYENDON] != null)
                    //    Load_Data();
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
            DataTable tblso = soBL.DM_DATAITEM_GETBYGROUPNAME("QLSO_HCTP_TC");
            if (tblso.Rows.Count > 0)
            {
                DataTable dtLoaiSo = tblso.AsEnumerable().Where(x => x["MA"].ToString() == "SoTT" || x["MA"].ToString() == "TBTP").CopyToDataTable();

                ddlLoaiso.DataSource = dtLoaiSo;
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
                DataTable tblsoVGD = soBL.DM_DATAITEM_GETBYGROUPNAME("QLSO_VUGD");
                tblsoVGD.Merge(dtLoaiSo);
                tblsoVGD.AcceptChanges();
                ddlLOAICVPC.DataSource = tblsoVGD;
                ddlLOAICVPC.DataTextField = "TEN";
                ddlLOAICVPC.DataValueField = "MA";
                ddlLOAICVPC.DataBind();
                try { ddlLOAICVPC.Items.FindByValue("SoCV").Selected = true; } catch (Exception) { }
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
                        ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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
                    ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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
                ddlThamtravien.Items.Add(new ListItem("--- Tất cả ---", "0"));
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
            DataTable tptc = oBL.THAMPHAN_GETBY_NC(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), "0", 0);
            DataTable tpb3 = oBL.THAMPHAN_GETBY_NC(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), "1", 0);
            tptc.Merge(tpb3);
            tptc.AcceptChanges();
            ddlThamphan.DataSource = tptc;
            ddlThamphan.DataTextField = "hotenngaysinh";
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
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                Decimal CurrChucVuID = string.IsNullOrEmpty(oCB.CHUCVUID + "") ? 0 : (decimal)oCB.CHUCVUID;

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
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
            //        }
            //    }
            //}
        }
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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
            oDT = oBL.QLToTrinh_VuAnKhangNghi_Search_BTP(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
            , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
            , vNgayThulyTu, vNgayThulyDen, vSoThuly
            , vTrangthai, captrinhtiep_id, is_dangkybaocao
            , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
            , ketqua_thuly, LoaiAnDB, LoaiAnDB_TH, isHoanTHA, vNgayCongVan, ddlLOAICVPC.SelectedValue, txtCV_So.Text, Convert.ToDecimal(dropTrangThaiNhan.SelectedValue)
            , Convert.ToDecimal(dropTrangThaiPC.SelectedValue), pageindex, page_size);
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
            //oDT = oBL.QLToTrinh_VuAnKhangNghi_InPhieu_Chuyen(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
            //, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
            //, vNgayThulyTu, vNgayThulyDen, vSoThuly
            //, vTrangthai, captrinhtiep_id, is_dangkybaocao
            //, isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
            //, ketqua_thuly, LoaiAnDB, LoaiAnDB_TH, isHoanTHA, vNgayCongVan, txtCV_So.Text
            //, pageindex, page_size);
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
            }
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
            dropTrangThaiNhan.SelectedIndex = 0;
            ddlLOAICVPC.SelectedIndex = 0;
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

                btnNBInTotrinh.Visible = true;
                btnNBPhieuchuyen.Visible = true;
                btnNBInDSVAKN.Visible = true;
            }
            else
            {
                ddlNguoiKy.Items.Clear();
                ddlNguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

                btnLuuVBchuyen.Enabled = false;
                btnLuuVBchuyen.CssClass = "buttonprintdisable";

                btnNBInTotrinh.Visible = false;
                btnNBPhieuchuyen.Visible = false;
                btnNBInDSVAKN.Visible = false;
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
        //huynt
        private void LoadDropNguoiKy()
        {
            // Load Ngườiky
            ddlNguoiKy.Items.Clear();
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            decimal donViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            string loaiSo = ddlLoaiso.SelectedValue;

            DataTable dt1 = oDMCBBL.DM_CANBO_GETBYDONVI_ARR_CHUCVU(
                                donViID,
                                "023,022",
                                loaiSo
                            );
            DataTable dt2 = oDMCBBL.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);

            dt1.Merge(dt2);
            DataView dv = dt1.DefaultView;

            ddlNguoiKy.DataSource = dv.ToTable();
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
                                if (oBL.CHECK_VUAN_KHANGNGHI_LUUSO(CurrDonViID, PhongBanID, ddlLoaiso.SelectedValue, kID, TYPE_SOVB_DONVI.HCTP) == true)
                                {
                                    mess = "alert('Vụ án này đã có Số " + ddlLoaiso.SelectedItem + "! Bạn kiểm tra lại')";
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                    return;
                                }
                                //kiểm tra vụ án đã được chuyển thì không cho thêm công văn
                                GDTTT_VUAN_CHITIET_CHUYEN oT = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == kID).FirstOrDefault();
                                if (oT != null && oT.TRANGTHAI == 1) //chưa nhận
                                {
                                    mess = "alert('Bạn chưa nhận vụ án này! Không thể thao tác')";
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                    return;
                                }
                                if (oT != null && oT.TRANGTHAICHUYENTP == 1)
                                {
                                    mess = "alert('Vụ án này đã chuyển thẩm phán! Không thể thêm văn bản')";
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                    return;
                                }
                                //chưa phân công thẩm phán => không thêm được tờ trình
                                if (ddlLoaiso.SelectedValue == "SoTT")
                                    if (oT.THAMPHANID == 0 || oT.THAMPHANID == null)
                                    {
                                        mess = "alert('Vụ án chưa phân công Thẩm phán không thêm được Tờ Trình! Bạn kiểm tra lại')";
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                        return;
                                    }
                                //chưa phân công thẩm phán => không thêm được thông báo phân công TP
                                if (ddlLoaiso.SelectedValue == "TBTP")
                                    if (oT.THAMPHANID == 0 || oT.THAMPHANID == null)
                                    {
                                        mess = "alert('Vụ án chưa phân công Thẩm phán không thêm được Tờ Trình! Bạn kiểm tra lại')";
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                        return;
                                    }
                            }
                        }
                    }
                    if (flag == false)
                    {
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa chọn vụ án để thêm số văn bản!')", true);
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
                        vPHATHANHID = oBL.SOVANBAN_VUAN_INSERT(CurrDonViID, PhongBanID, TYPE_SOVB_DONVI.HCTP, null, ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim(),
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
            Response.Redirect("/QLAN/GDTTT/Hoso/Quanlycapso.aspx");
        }

        private DataTable getDS_BC(bool isCV, bool isOnPrint, bool isTraigiam, bool isChiDao, bool isTBQuahan)
        {
            int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue), DiaChiTinh = 0, DiaChiHuyen = 0;
            string SoBAQD = txtSoQDBA.Text.Trim(), NgayBAQD = txtNgayBAQD.Text, strNguoiNhap = "";

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
            oDT = oBL.GDTTTT_QLTOTRINH_VAKN_BTP_TTRINH_PHANCONG(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, null,
                      null, null, null, 0, null, DiaChiTinh, DiaChiHuyen,
                      null, null, null, null, 0, strNguoiNhap, 0, -1, 0, 0, null, null, null, null, 0, 0
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, -1, -1, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, null, null, 0, 0, vLoaiAn, null, null, null, -1, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]), pageindex, page_size);

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
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault() ?? new GDTTT_DON();
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
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault() ?? new GDTTT_DON();
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
                dt.GDTTT_VUAN_CHITIET_CHUYEN.Add(objLS);
            dt.SaveChanges();
        }

        //huynt
        protected void btnNhan_Click(object sender, EventArgs e)
        {
            if (Check_NhanVuAN() == true)
            {
                try
                {
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
                            if (oT != null && oT.TRANGTHAI == 2)
                            {
                                string strMsg = "Vụ án đã được nhận , không nhận chuyển tiếp";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                return;
                            }
                            if (oT != null && oT.TRANGTHAI == 1)
                            {
                                oT.TRANGTHAI = 2;
                                oT.NGUOINHAN = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                                oT.NGAYNHAN = DateTime.Now;
                                iCount++;
                            }
                        }
                    }
                    dt.SaveChanges();
                    Load_Data();
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = "Lỗi khi nhận vụ án: " + ex.Message;
                }
            }
            else
            {
                return;
            }
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

        private bool Check_NhanVuAN()
        {
            bool hasChecked = false;

            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)item.FindControl("chkChon");
                if (chkChon != null && chkChon.Checked)
                {
                    hasChecked = true;
                    break;
                }
            }

            if (!hasChecked)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn chưa chọn vụ án để nhận!');", true);
                return false;
            }

            return true;
        }

        protected void txtCV_So_OnChanged(object sender, EventArgs e)
        {
            Load_Data();
        }

        protected void dropTrangThaiNhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropTrangThaiNhan.SelectedValue == "1") //chưa nhận
            {
                btnChuyenTP.Enabled = false;
                btnChuyenTP.CssClass = "buttonprintdisable";
                btnLuuVBchuyen.Enabled = false;
                btnLuuVBchuyen.CssClass = "buttonprintdisable";
                btnQuanlyVB.Enabled = false;
                btnQuanlyVB.CssClass = "buttonprintdisable";

                btnNhanVuAn.Enabled = true;
                btnNhanVuAn.CssClass = "buttoninput";

                labelTrangThaiPC.Visible = false;
                dropTrangThaiPC.Visible = false;
                dropTrangThaiPC.SelectedIndex = 0;
            }
            else
            {
                btnChuyenTP.Enabled = true;
                btnChuyenTP.CssClass = "buttoninput";
                btnLuuVBchuyen.Enabled = true;
                btnLuuVBchuyen.CssClass = "buttoninput";
                btnQuanlyVB.Enabled = true;
                btnQuanlyVB.CssClass = "buttoninput";

                if (dropTrangThaiNhan.SelectedValue == "0") //chọn tất cả
                {
                    btnNhanVuAn.Enabled = true;
                    btnNhanVuAn.CssClass = "buttoninput";
                }
                else
                {
                    btnNhanVuAn.Enabled = false;
                    btnNhanVuAn.CssClass = "buttonprintdisable";
                }

                if (dropTrangThaiNhan.SelectedValue == "4") //Đã chuyển TP
                {
                    labelTrangThaiPC.Visible = false;
                    dropTrangThaiPC.Visible = false;
                    dropTrangThaiPC.SelectedIndex = 0;
                }
                else
                {
                    labelTrangThaiPC.Visible = true;
                    dropTrangThaiPC.Visible = true;
                }
            }
            Load_Data();
        }

        protected void dropTrangThaiPC_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_Data();
        }

        protected void ddlLOAICVPC_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtCV_So.Text) || (!string.IsNullOrEmpty(txtCV_Ngay.Text) && txtCV_Ngay.Text != ""))
            {
                Load_Data();
            }
        }

        protected void btnChuyenTP_Click(object sender, EventArgs e)
        {
            try
            {
                if (Check_ChuyenThamPhan())
                {
                    int iCount = 0;
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        string strID = Item.Cells[0].Text;
                        decimal ID = Convert.ToDecimal(strID);
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            GDTTT_VUAN_CHITIET_CHUYEN oT = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == ID).FirstOrDefault();
                            //vụ án đã được chuyển thẩm phán
                            if (oT != null && oT.TRANGTHAICHUYENTP == 1)
                            {
                                string strMsg = "Vụ án đã được chuyển, không thể chuyển tiếp";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                return;
                            }
                            //chưa phân công thẩm phán
                            if (oT != null && (oT.THAMPHANID == null || oT.THAMPHANID == 0))
                            {
                                string strMsg = "Vụ án chưa phân công thẩm phán, không thể chuyển";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                return;
                            }

                            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                            //kiểm tra vụ án phải có soTT mới được chuyển thẩm phán
                            if (!oBL.CHECK_VUAN_KHANGNGHI_LUUSO(CurrDonViID, PhongBanID, "SoTT", ID, TYPE_SOVB_DONVI.HCTP))
                            {
                                string strMsg = "Vụ án chưa có số tờ trình, không thể chuyển thẩm phán";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                return;
                            }

                            //kiểm tra vụ án phải có TBTP mới được chuyển thẩm phán
                            if (!oBL.CHECK_VUAN_KHANGNGHI_LUUSO(CurrDonViID, PhongBanID, "TBTP", ID, TYPE_SOVB_DONVI.HCTP))
                            {
                                string strMsg = "Vụ án chưa có thông báo phân công thẩm phán, không thể chuyển thẩm phán";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                return;
                            }
                            iCount += 1; // tổng số vụ án được tích chọn
                        }
                    }

                    //chạy vòng lặp cập nhật trạng thái chuyển thẩm phán
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            string strID = Item.Cells[0].Text;
                            decimal ID = Convert.ToDecimal(strID);
                            GDTTT_VUAN_CHITIET_CHUYEN oT = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == ID).FirstOrDefault();
                            oT.TRANGTHAICHUYENTP = 1;
                            oT.NGAYCHUYENTP = DateTime.Now;
                        }
                    }
                    dt.SaveChanges();

                    Load_Data();
                    lbtthongbao.Text = "Hoàn thành chuyển " + iCount.ToString() + " vụ án !";
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = "Lỗi khi chuyển thẩm phán: " + ex.Message;
            }
        }

        private bool Check_ChuyenThamPhan()
        {
            bool hasChecked = false;

            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)item.FindControl("chkChon");
                if (chkChon != null && chkChon.Checked)
                {
                    hasChecked = true;
                    break;
                }
            }

            if (!hasChecked)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn chưa chọn vụ án để chuyển thẩm phán!');", true);
                return false;
            }

            return true;
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

        protected void btnNBInTotrinh_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = getDS_BC(false, true, false, false, false);
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

        protected void btnNBPhieuchuyen_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            if (Check_Bao_Cao("btnNBPhieuchuyen") == true)
            {
                Session["GDTTT_MABM"] = "NOIBO_PHIEUCHUYEN_TOICAO";

                DataTable oDT = getDS(Convert.ToInt32(ddlPageCount.SelectedValue), Convert.ToInt32(hddPageIndex.Value));
                if (oDT != null)
                {
                    if (oDT.Rows.Count == 0)
                    {
                        lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                        return;
                    }
                    //ĐỊa điểm
                    string strSo = "", strDiadiem = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "", strChucVu = "", strTenPhongban = "";
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    {
                        strDiadiem = "Hà Nội";
                    }
                    else
                    {
                        strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
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

                    decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                    if (oNSD.PHONGBANID != null)
                    {
                        DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                        strTenPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                    }
                    String _phong = "";
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    {
                        _phong = "Vụ trưởng ";
                    }
                    else if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "6")
                    {
                        _phong = "Trưởng phòng ";
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
                    var seen = new HashSet<PrintThamPhan>();
                    var resultRows = new List<DataRow>();

                    foreach (DataRow row in oDT.Rows)
                    {
                        var key = new PrintThamPhan
                        {
                            TENTHAMPHAN = row["TENTHAMPHAN"].ToString(),
                            NOICHUYEN = row["NOICHUYEN"].ToString()
                        };

                        if (seen.Add(key))
                        {
                            resultRows.Add(row);
                        }
                    }

                    DataTable dtTP = resultRows.Count > 0 ? resultRows.CopyToDataTable() : oDT.Clone();

                    // DataTable dtTP = objgr[0];
                    foreach (DataRow obj in dtTP.Rows)
                    {
                        //Kiểm tra đã tồn tại THẩm phán chưa
                        bool flag = false;
                        foreach (DTGDTTT.DT_NOIBO_PHIEUCHUYENRow p in objds.DT_NOIBO_PHIEUCHUYEN.Rows)
                        {
                            if (p.TENTHAMPHAN == (obj["TENTHAMPHAN"] + ""))
                            {
                                flag = true;
                                p.TENPHONGBANNHAN += "\n-Đồng chí " + _phong + obj["NOICHUYEN"] + ".";
                                objds.AcceptChanges();
                                break;
                            }
                        }
                        if (flag == false)
                        {
                            DTGDTTT.DT_NOIBO_PHIEUCHUYENRow r = objds.DT_NOIBO_PHIEUCHUYEN.NewDT_NOIBO_PHIEUCHUYENRow();
                            r.TENTHAMPHAN = obj["thamphan_ten"] + "";
                            r.TENPHONGBANNHAN = "- Đồng chí " + _phong + obj["NOICHUYEN"] + ".";
                            r.SOTOTRINH = reStr(obj["SOVB"] + "");
                            r.NGAYTOTRINH = GetDate(obj["NGAYVB"]);

                            DateTime dNgayCV;
                            try
                            {
                                dNgayCV = (String.IsNullOrEmpty(obj["NGAY_TB"].ToString())) ? DateTime.MinValue : DateTime.Parse(obj["NGAY_TB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);

                                if (dNgayCV != DateTime.MinValue)
                                {
                                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                                    strNam = dNgayCV.Year.ToString();
                                }
                            }
                            catch { }

                            r.SOTHONGBAO = obj["SO_TB"] + "";
                            r.NGAY = strNgay;
                            r.THANG = strThang;
                            r.NAM = strNam;
                            r.NGUOIKY = obj["NGUOIKY_TB"] + "";
                            r.CHUCVU = obj["CHUCVU_TB"] + "";
                            r.TENDONVI = strTendonvi;
                            r.TENPHONGBANGUI = strTenPhongban;
                            r.DIADIEM = strDiadiem;
                            r.TAND_NHAN = TAND_NHAN_;
                            objds.DT_NOIBO_PHIEUCHUYEN.AddDT_NOIBO_PHIEUCHUYENRow(r);
                            objds.AcceptChanges();
                        }
                    }
                    objds.AcceptChanges();
                    Session["NOIBO_DATASET"] = objds;
                }
                string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
        }

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
                tbl = oBL.QLToTrinh_VuAnKhangNghi_BTP_Search_Print(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
                , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                , vNgayThulyTu, vNgayThulyDen, vSoThuly
                , vTrangthai, captrinhtiep_id, is_dangkybaocao
                , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
                , ketqua_thuly, LoaiAnDB, LoaiAnDB_TH, isHoanTHA, vNgayCongVan, ddlLOAICVPC.SelectedValue, txtCV_So.Text, dropTrangThaiNhan.SelectedValue
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
    }
}