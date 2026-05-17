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

using BL.GSTP.GDTTT;


namespace WEB.GSTP.QLAN.GDTTT.VuAn.AnTH
{
    public partial class DanhsachHoSo : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        Decimal trangthai_trinh_id = 0;
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
                    if ((Session[SessionSearch] + "") == "0")
                    {
                        lbtTTTK.Text = "[ Thu gọn ]";
                        pnTTTK.Visible = true;
                    }
                    if ((Session[SessionInBC] + "") == "0")
                    {
                        lkInBC_OpenForm.Text = "[ Thu gọn ]";
                        pnInBC.Visible = true;
                    }
                    //---------------------------
                    LoadDropBox();
                    SetGetSessionTK(false);
                   
                     Load_Data();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //Cls_Comon.SetButton(btnThemmoi, oPer.TAOMOI);
                }
                //if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                //    btnThemmoi.Visible = false;
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
                    Session[SS_TK.NGUYENDON] = txtBian.Text;
             
                    Session[SS_TK.LOAIAN] = ddlLoaiAn.SelectedValue;
                    Session[SS_TK.THAMTRAVIEN] = ddlThamtravien.SelectedValue;
                    Session[SS_TK.LANHDAOPHUTRACH] = ddlPhoVuTruong.SelectedValue;
                    Session[SS_TK.THAMPHAN] = ddlThamphan.SelectedValue;
            
                    Session[SS_TK.COQUANCHUYENDON] = "";// txtCoquanchuyendon.Text;

                    Session[SS_TK.THULY_TU] = txtTao_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtTao_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
                    Session[SS_TK.MUONHOSO] = ddlMuonHoso.SelectedValue;
                    Session[SS_TK.TRANGTHAITHULY] = ddlTrangthaithuly.SelectedValue;


                    string vArrSelectID = "";
                    foreach (DataGridItem Item in dgListHS.Items)
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
                    Session[SS_TK.TRANGTHAITOTRINH] = ddlTotrinh.SelectedValue + "";
                    Session[SS_TK.TRANGTHAIYKIENTT] = dropIsYKienKetLuatTrinhLD.SelectedValue + "";

                }
                else
                {
                    int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                    if (IsHome == 1)
                    {
                        pnTTTK.Visible = true;
                        txtSoQDBA.Text = Session[SS_TK.SOBAQD] + "";
                        txtNgayBAQD.Text = Session[SS_TK.NGAYBAQD] + "";
                        if (Session[SS_TK.TOAANXX] != null) ddlToaXetXu.SelectedValue = Session[SS_TK.TOAANXX] + "";

                        txtBian.Text = Session[SS_TK.NGUYENDON] + "";
                       
                        if (Session[SS_TK.LOAIAN] != null)
                            ddlLoaiAn.SelectedValue = Session[SS_TK.LOAIAN] + "";
                        if (Session[SS_TK.THAMTRAVIEN] != null) ddlThamtravien.SelectedValue = Session[SS_TK.THAMTRAVIEN] + "";
                        if (Session[SS_TK.LANHDAOPHUTRACH] != null)
                            ddlPhoVuTruong.SelectedValue = Session[SS_TK.LANHDAOPHUTRACH] + "";
                        if (Session[SS_TK.THAMPHAN] != null)
                            ddlThamphan.SelectedValue = Session[SS_TK.THAMPHAN] + "";

                      
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";
                        

                        if (Session[SS_TK.MUONHOSO] != null)
                            ddlMuonHoso.SelectedValue = Session[SS_TK.MUONHOSO] + "";

                    
                        else if (ddlMuonHoso.SelectedValue == "0")
                            ddlTrangthaithuly.SelectedValue = "1";
                       
                        //---------------------------------
                        if (Session[SS_TK.TRANGTHAITOTRINH] != null)
                            ddlTotrinh.SelectedValue = Session[SS_TK.TRANGTHAITOTRINH] + "";

                        //--------------------------------------------------
                        dropIsYKienKetLuatTrinhLD.SelectedValue = Session[SS_TK.TRANGTHAIYKIENTT] + "";
                        //dropBuocTT.SelectedValue = "1";
                      
                        if (Session[SS_TK.TRANGTHAITHULY] != null)
                            ddlTrangthaithuly.SelectedValue = Session[SS_TK.TRANGTHAITHULY] + "";
                        if (ddlTrangthaithuly.SelectedValue != "0")
                        {
                            lttYKienKetLuan.Visible = dropIsYKienKetLuatTrinhLD.Visible = true;
                           
                        }
                        if (ddlTrangthaithuly.SelectedValue == "3")
                        {
                            ddlMuonHoso.SelectedValue = "1";
                          
                            ddlTotrinh.SelectedValue = "0";
                        }
                       
                        //--------------------------------------------------
                       
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
            //Load Thẩm phán
            try
            {
                LoadDropThamphan();
            }
            catch (Exception ex) { }
            //Lãnh đạo
            try { LoadDropLanhDao(); } catch (Exception ex) { }

            //Trình trạng thụ lý
            LoadDrop_TinhTrangThuLy();
        }
        
      
        void LoadDrop_TinhTrangThuLy()
        {
            List<GDTTT_DM_TINHTRANG> lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
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
                                                && x.ID >= 6 && x.ID !=10).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
          
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
                    if (oCD.MA == ENUM_CHUCDANH.CHUCDANH_TTV && loai_hotro_db != 1)
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
                if ((oCD.MA == ENUM_CHUCDANH.CHUCDANH_TTV || oCD.MA == "TTVC") && loai_hotro_db != 1)
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
       

        void LoadDropThamphan()
        {
            Decimal ChucVuPCA = 0;
            Decimal ChucVuCA = 0;
            Decimal ChucDanh_TPTATC = 0;
            try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucVuCA = dt.DM_DATAITEM.Where(x => x.MA == "CA").FirstOrDefault().ID; } catch (Exception ex) { }
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }

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
                if (oCB.CHUCDANHID == ChucDanh_TPTATC)
                {
                    //ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
                    //----------anhvh add 30/10/2019
                    DataTable tbl = oGDTBL.GDTTT_Tp_Duoc_Phutrach(Session[ENUM_SESSION.SESSION_DONVIID] + "",Convert.ToInt32(oCB.ID));
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
                            IsLoadAll = true;
                        //LoadLoaiAnPhuTrach(oCB);
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
                        lblTitleBA.Text = "Bị án";
                      
                    }
                    LoadLoaiAnPhuTrach_TheoPB(obj);
                }
            }

            // if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            if (ddlLoaiAn.Items.Count > 1)
                ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

            if (obj.ISHINHSU == 1)
            {
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                //dgList.Columns[6].Visible = false;
                //dgList.Columns[5].HeaderText = "Bị cáo";
                lblTitleBA.Text = "Bị án";

            }
            LoadLoaiAnPhuTrach_TheoPB(obj);

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
            dgListHS.Visible = dgListHS.Visible = false;
            //SetTieuDeBaoCao();
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
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> bị án tử hình trong <b>" + hddTotalPage.Value + "</b> trang";
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
              
                dgListHS.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgListHS.DataSource = oDT;
                dgListHS.DataBind();
                dgListHS.Visible = true;

            }
           
        }
        private DataTable getDS(int page_size, int pageindex)
        {
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            decimal V_ID=0;
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);

            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim();
            DateTime? vNgayBAQD = txtNgayBAQD.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBAQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            string vBian = txtBian.Text;
            DateTime? vNgayTaoTu = txtTao_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtTao_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayTaoDen = txtTao_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtTao_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;


            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
  
            decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);

            int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
            
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
                vPhongbanID = 0;
            decimal v_Hosoangiam = Convert.ToDecimal(ddlIsHoSoAnGiam.SelectedValue);
        

            DataTable tbl = null;
            tbl = oBL.DUONGSU_TUHINH_SEARCH(Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", V_ID, v_Hosoangiam, vToaAnID, 
                vToaRaBAQD, vSoBAQD, vNgayBAQD, vLoaiAn, vBian, vNgayTaoTu, vNgayTaoDen, pageindex, page_size);
            
            return tbl;
        }

        void XoaHoSoAnGiam(Decimal CurrHSID)
        {
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            decimal _dele = oBL.Gdttt_Tuhinh_HoSo_Delete(CurrHSID);
            if (_dele == 0)
                lbtthongbao.Text = "Bạn không được xóa khi dữ liệu nhập giải quyết xin ân giảm có thông tin!";
            else
                Load_Data();
        }
        void TaoHoSoAnGiam(decimal DUONGSUID,decimal VUANID)
        {
            GDTTT_TUHINH_BL oBL = new GDTTT_TUHINH_BL();
            //CurrUserID
            decimal c_insert = oBL.Gdttt_Tuhinh_HoSo_Insert(DUONGSUID, VUANID, CurrUserID);
            if (c_insert == 1)
                    Load_Data();
            else
                lbtthongbao.Text = "Đương sự đã có hồ sơ xin ân giảm!";
        }

        private DataTable SearchNoPaging()
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            string vNguyendon = txtBian.Text;
          
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vLanhdao = Convert.ToDecimal(ddlPhoVuTruong.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            decimal vQHPLID = 0;
            decimal vQHPLDNID = 0;
            string vCoquanchuyendon = "";// txtCoquanchuyendon.Text.Trim();
           

            DateTime? vNgayThulyTu = txtTao_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtTao_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtTao_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtTao_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);
           

            int isTotrinh = Convert.ToInt16(ddlTotrinh.SelectedValue);
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);

            DataTable oDT = null;
            //oDT = oBL.VUAN_Search_NoPaging(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui,
            //   vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan,
            //   vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly,
            //   vTrangthai, vKetquathuly, vKetquaxetxu, isMuonHoSo
            //   , isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, ishoantha
            //   , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp);
            return oDT;
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgListHS.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            SetGetSessionTK(true);
        }
       
      
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
        
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
           

            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {

                case "XoaHS":
                    XoaHoSoAnGiam(Convert.ToDecimal(e.CommandArgument));
                    break;
                case "TAO_HS":
                    string[] arr = e.CommandArgument.ToString().Split('#');
                    if (arr.Length > 0)
                    {
                        decimal duongsu_id = String.IsNullOrEmpty(arr[1] + "") ? 0 : Convert.ToDecimal(arr[1] + "");
                        decimal vuanid = String.IsNullOrEmpty(arr[0] + "") ? 0 : Convert.ToDecimal(arr[0] + "");
                        TaoHoSoAnGiam(duongsu_id, vuanid);
                    }
                    break;
                case "SoDon":
                    string[] arr1 = e.CommandArgument.ToString().Split('#');
                    if (arr1.Length > 0)
                    {
                        decimal duongsu_id = String.IsNullOrEmpty(arr1[1] + "") ? 0 : Convert.ToDecimal(arr1[1] + "");
                        decimal vuanid = String.IsNullOrEmpty(arr1[0] + "") ? 0 : Convert.ToDecimal(arr1[0] + "");
                        string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/AnTH/pDsDonAnGiam.aspx?type=dt&vid="+ vuanid + "&dsID=" + duongsu_id + "','Danh sách đơn trùng HCTP nhận',1000,500);";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    }
                               
                    break;
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

            foreach (DataGridItem Item in dgListHS.Items)
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
            txtBian.Text = "";
          
            ddlLoaiAn.SelectedIndex = 0;

            ddlThamtravien.SelectedIndex = 0;
            ddlPhoVuTruong.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;

            ddlTrangthaithuly.SelectedIndex = 0;
            ddlTotrinh.SelectedIndex = 0;
            dropIsYKienKetLuatTrinhLD.SelectedValue = "2";
            dropIsYKienKetLuatTrinhLD.Visible = lttYKienKetLuan.Visible = true;

            txtTao_Tu.Text = "";
            txtTao_Den.Text = "";
            txtThuly_So.Text = "";
            ddlMuonHoso.SelectedValue = "2";

            Session.Remove("V_COLUME");
            Session.Remove("V_ASC_DESC");
            if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
            {
                Session["V_COLUME"] = "NGAYTAO";
                Session["V_ASC_DESC"] = "DESC";
            }
        }
        //---------------------------------
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
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            //SetGetSessionTK(true);
            //String SessionName = "GDTTT_ReportPL".ToUpper();
            ////--------------------------
            //String ReportName = "";
            //if (String.IsNullOrEmpty(txtTieuDeBC.Text))
            //    SetTieuDeBaoCao();
            //ReportName = txtTieuDeBC.Text.Trim();
            //Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();
            //String Parameter = "type=va&rID=" + dropMauBC.SelectedValue;
            //DataTable tbl = SearchNoPaging();
            //Session[SessionName] = tbl;
            //string URL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx" + (string.IsNullOrEmpty(Parameter) ? "" : "?" + Parameter);
            //Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");
        }
        
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            Load_Data();
            // LoadDropQHPL();
        }

        protected void ddlMuonHoso_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            if (ddlMuonHoso.SelectedValue == "1")
                dropMauBC.SelectedValue = "2";
            else if (ddlMuonHoso.SelectedValue == "0")
                dropMauBC.SelectedValue = "1";
        }
        protected void ddlTrangthaithuly_SelectedIndexChanged(object sender, EventArgs e)
        {
            
        }
        protected void ddlLoaiCV_SelectedIndexChanged(object sender, EventArgs e)
        {
           
        }

        protected void ddlPhoVuTruong_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlTotrinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            if (ddlTotrinh.SelectedValue != "2")
                dropMauBC.SelectedValue = "3";
        }
        protected void dropIsYKienKetLuatTrinhLD_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
            if (dropIsYKienKetLuatTrinhLD.Visible == true && dropIsYKienKetLuatTrinhLD.SelectedValue != "0")
            {
                dropMauBC.SelectedValue = "4";
            }
        }
        protected void dropAnDB_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        protected void ddlKetquaThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }

        protected void ddlIsHoSoAnGiam_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        
        protected void dropBuocTT_SelectedIndexChanged(object sender, EventArgs e)
        {
         
        }
        void SetTieuDeBaoCao()
        {
            string tieudebc = "";

            //-------------------------------------
            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += " " + ddlLoaiAn.SelectedItem.Text.ToLower();
            
            
            //-------------------------------------
            String canbophutrach = "";
            if (ddlThamphan.SelectedValue != "0")
                canbophutrach = "thẩm phán " + Cls_Comon.FormatTenRieng(ddlThamphan.SelectedItem.Text);

            //if (!String.IsNullOrEmpty(canbophutrach))
            //    canbophutrach += ", ";
            //if (ddlThamtravien.SelectedValue != "0")
            //    canbophutrach +=((string.IsNullOrEmpty(canbophutrach))?"":", " )+ "thẩm tra viên " + ddlThamtravien.SelectedItem.Text;

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

            if (dropIsYKienKetLuatTrinhLD.Visible == true && dropIsYKienKetLuatTrinhLD.SelectedValue != "2")
                tieudebc += " " + dropIsYKienKetLuatTrinhLD.SelectedItem.Text.ToLower();

            //--------------------------------------

           
            //-----------------------------
            txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc.Replace("...", "");
        }
    }
}
