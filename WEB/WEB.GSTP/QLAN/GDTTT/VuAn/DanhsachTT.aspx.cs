using BL.GSTP;
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

namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class DanhsachTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
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
        MenuPermission oPer = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            scriptManager.RegisterPostBackControl(this.cmdPrintBC);
            
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

            //Loại án
            LoadDropLoaiAn();

            //Trình trạng thụ lý
            LoadDrop_TinhTrangThuLy();
            SetVisible_SearchDateTime();
            LoadDropKQThuLyDon();
        }
        void LoadDropKQThuLyDon()
        {
            ddlKetquaThuLy.Items.Clear();
            ddlKetquaThuLy.Items.Add(new ListItem("--Tất cả--", "3"));
            ddlKetquaThuLy.Items.Add(new ListItem("Chưa có kết quả", "4"));
            ddlKetquaThuLy.Items.Add(new ListItem("Đã có kết quả", "5"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Trả lời đơn", "0"));
            //--------------------------
            ddlKetquaThuLy.Items.Add(new ListItem("...Kháng nghị(CA + VKS)", "-1"));
            ddlKetquaThuLy.Items.Add(new ListItem("......Kháng nghị(CA)", "1"));
            ddlKetquaThuLy.Items.Add(new ListItem("......Kháng nghị(VKS)", "-2"));
            //----------------------------
            ddlKetquaThuLy.Items.Add(new ListItem("...Xếp đơn", "2"));
            ddlKetquaThuLy.Items.Add(new ListItem("...VKS đang nghiên cứu", "8"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Xử lý khác", "6"));
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

            lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1
                                                && x.ID >= 6 && x.ID != 10).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
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
            Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            //Load Thẩm phán
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Boolean IsLoadAll = false;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC"|| oCD.MA =="TPCC")
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    else
                        IsLoadAll = true;
                }
                else
                    IsLoadAll = true;
            }
            catch (Exception ex) { IsLoadAll = true; }
            if (IsLoadAll)
            {
                // DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                DataTable tbl = oGDTBL.GDTTT_VUAN_GETALLCBTHEOPB_ALLXX(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
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
                if (oCD.MA == "TPTATC" || oCD.MA =="TPCC")
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

            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            if (ddlLoaiAn.Items.Count > 1)
            {
                if (obj != null)
                {
                    if (obj.ISHINHSU != 1)
                    {
                        ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                    }
                }
            }
        }
        void LoadAllLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
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

            int ketqua_thuly = Convert.ToInt32(ddlKetquaThuLy.SelectedValue);
            DataTable oDT = null;
                oDT = oBL.QLToTrinh_VuAn_Search(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
                , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                , vNgayThulyTu, vNgayThulyDen, vSoThuly
                , vTrangthai, captrinhtiep_id, is_dangkybaocao
                , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT
                , ketqua_thuly, LoaiAnDB, LoaiAnDB_TH, isHoanTHA
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
                    string StrTotrinh = "PopupReport('/QLAN/GDTTT/VuAn/Popup/QLTotrinh.aspx?vid=" + e.CommandArgument + "','Quản lý tờ trình',1000,700);";
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

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton cmdTotrinh = (LinkButton)e.Item.FindControl("cmdTotrinh");
                Cls_Comon.SetLinkButton(cmdTotrinh, oPer.TAOMOI);

                DataRowView rv = (DataRowView)e.Item.DataItem;
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");
                decimal trangthai_trinh_id = 0;
                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");

                decimal KQ_GQD_ID = String.IsNullOrEmpty(rv["KQ_GQD_ID"] + "") ? 0 : Convert.ToInt32(rv["KQ_GQD_ID"] + "");
                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");

                lttLanTT.Text = rv["TENTINHTRANG"] + "";
                int GiaiDoanTrinh = String.IsNullOrEmpty(rv["GiaiDoanTrinh"] + "") ? 0 : Convert.ToInt32(rv["GiaiDoanTrinh"] + "");

                //if ((trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRINH_THAMPHAN)
                //        || (trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRINH_PHOVT)
                //        || (trangthai == (int)ENUM_GDTTT_TRANGTHAI.TRINH_VUTRUONG))
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
            SetVisible_ZoneSearchTT();

            ddlKetquaThuLy.SelectedIndex = 0;
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
        protected void cmdPrint_Click_older(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            string link = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx";
            string openpopup = "";
            String SessionName = "GDTTT_ReportPL".ToUpper();
            //--------------------------
            if (String.IsNullOrEmpty(txtTieuDeBC.Text))
                SetTieuDeBaoCao();

            Session[SS_TK.TENBAOCAO] = txtTieuDeBC.Text.Trim().ToUpper();
            DataTable tbl = getDS(3000000, 1);
            Session[SessionName] = tbl;
            String para = "type=va&rID=3";
            openpopup = "PopupReport('" + link + (String.IsNullOrEmpty(para) ? "" : "?" + para) + "','Danh sách vụ án',1000,600)";
            Cls_Comon.CallFunctionJS(this, this.GetType(), openpopup);
        }
        //anhvh add 20/12/2019
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

                int ketqua_thuly = Convert.ToInt32(ddlKetquaThuLy.SelectedValue);
                DataTable tbl = null;
                tbl = oBL.QLToTrinh_VuAn_Search_Print(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
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

                int ketqua_thuly = Convert.ToInt32(ddlKetquaThuLy.SelectedValue);
                DataTable tbl = null;
                tbl = oBL.QLToTrinh_VuAn_Search_Print_BC(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
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

            txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc.Replace("...", "");
        }
        protected void lkInBC_OpenForm_Click(object sender, EventArgs e)
        {
            if (pnInBC.Visible == false)
            {
                lkInBC_OpenForm.Text = "[ Thu gọn ]";
                pnInBC.Visible = true;
                Session[SessionInBC] = "0";
            }
            else
            {
                lkInBC_OpenForm.Text = "[ Mở ]";
                pnInBC.Visible = false;
                Session[SessionInBC] = "1";
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
    }
}
