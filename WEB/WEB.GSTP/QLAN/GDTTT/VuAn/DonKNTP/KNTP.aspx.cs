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

namespace WEB.GSTP.QLAN.GDTTT.VuAn.DonKNTP
{
    public partial class KNTP : System.Web.UI.Page
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
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
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
                    if (Session[SS_TK.NGUYENDON] != null)
                        Load_Data();
                }
                
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
                    Session[SS_TK.LOAIAN] = ddlLoaiAn.SelectedValue;
                    Session[SS_TK.THAMTRAVIEN] = ddlThamtravien.SelectedValue;
                    Session[SS_TK.LANHDAOPHUTRACH] = ddlLANHDAO.SelectedValue;
                  
                    Session[SS_TK.NGUOIGUI] = txtNguoiguidon.Text;
                    Session[SS_TK.COQUANCHUYENDON] = "";// txtCoquanchuyendon.Text;
                  
                    Session[SS_TK.THULY_TU] = txtThuly_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtThuly_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
                    Session[SS_TK.MUONHOSO] = ddlMuonHoso.SelectedValue;
                    Session[SS_TK.TRANGTHAITHULY] = 0;
                    Session[SS_TK.KETQUATHULY] = ddlKetquaThuLy.SelectedValue;
                   

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

                    Session[SS_TK.ANQUOCHOI_THOIHIEU] = dropAnDB.SelectedValue;
                    

                }
                else
                {
                    int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                    if (IsHome == 1)
                    {
                        
                        txtSoQDBA.Text = Session[SS_TK.SOBAQD] + "";
                        txtNgayBAQD.Text = Session[SS_TK.NGAYBAQD] + "";
                        if (Session[SS_TK.TOAANXX] != null) ddlToaXetXu.SelectedValue = Session[SS_TK.TOAANXX] + "";
                        
                        if (Session[SS_TK.LOAIAN] != null)
                            ddlLoaiAn.SelectedValue = Session[SS_TK.LOAIAN] + "";
                        if (Session[SS_TK.THAMTRAVIEN] != null) ddlThamtravien.SelectedValue = Session[SS_TK.THAMTRAVIEN] + "";
                        if (Session[SS_TK.LANHDAOPHUTRACH] != null)
                            ddlLANHDAO.SelectedValue = Session[SS_TK.LANHDAOPHUTRACH] + "";
                       

                        txtNguoiguidon.Text = Session[SS_TK.NGUOIGUI] + "";
                       

                        txtThuly_Tu.Text = Session[SS_TK.THULY_TU] + "";
                        txtThuly_Den.Text = Session[SS_TK.THULY_DEN] + "";
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";


                        

                        if (Session[SS_TK.MUONHOSO] != null)
                            ddlMuonHoso.SelectedValue = Session[SS_TK.MUONHOSO] + "";

                        if (ddlMuonHoso.SelectedValue != "2")
                            ddlKetquaThuLy.SelectedValue = "4";
                        
                        if (Session[SS_TK.KETQUATHULY] != null)
                            ddlKetquaThuLy.SelectedValue = Session[SS_TK.KETQUATHULY] + "";
                        //---------------------------------
                       
                       
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

            } catch (Exception ex) { }

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
                if (oCD.MA == "TPTATC" || oCD.MA == "TPCC")
                {
                   
                    oCD = dt.DM_DATAITEM.Where(x => x.ID == CurrChucVuID).FirstOrDefault();
                    if (oCD != null)
                    {
                        if (oCD.MA == "CA")
                            IsLoadAll = true;
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
       
        public List<GDTTT_DM_TINHTRANG>  SetName_Vu_Phongban(List<GDTTT_DM_TINHTRANG> lst)
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
                    ddlLANHDAO.Items.Clear();
                    ddlLANHDAO.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));

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
                    || oCD.MA == "C010" || oCD.MA == "C008" || oCD.MA == "C009"
                    || oCD.MA == "042")
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
            
            tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            
            ddlLANHDAO.DataSource = tbl;
            ddlLANHDAO.DataTextField = "HOTEN";
            ddlLANHDAO.DataValueField = "ID";
            ddlLANHDAO.DataBind();
            ddlLANHDAO.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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
            Decimal LanhDaoID = Convert.ToDecimal(ddlLANHDAO.SelectedValue);
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
           
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            if (oCB.CHUCVUID != null && oCB.CHUCVUID == ChucVuPCA || oCB.CHUCVUID == ChucVuCA)
            {
                if (oCB.CHUCDANHID == ChucDanh_TPTATC || oCB.CHUCDANHID == ChucDanh_TPCC)
                {
                    //ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
                    //----------anhvh add 30/10/2019

                    //DataTable tbl = oGDTBL.GDTTT_Tp_Duoc_Phutrach(Convert.ToInt32(oCB.ID));
                    //ddlThamphan.DataSource = tbl;
                    //ddlThamphan.DataTextField = "HOTEN";
                    //ddlThamphan.DataValueField = "ID";
                    //ddlThamphan.DataBind();
                }
                else
                IsLoadAll = true;
            }
           
        }
      
       
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Response.Redirect("DonKNTP/ThongtinKNTP.aspx?type=new");
        }
        //-----------------------------------------
        private void Load_Data()
        {
            dgList.Visible = false;
            SetTieuDeBaoCao();
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
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HANHCHINH)
            {
                
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true; 
            }
            else
            {
                
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Visible = true;
            }


        }
        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            string vNguyendon = null;
            string vBidon = null;
           
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vLanhdao = Convert.ToDecimal(ddlLANHDAO.SelectedValue);
           
            string vCoquanchuyendon = "";// txtCoquanchuyendon.Text.Trim();
            string vNguoiGui = txtNguoiguidon.Text.Trim();

           
            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = 0;
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
         
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
            int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
            String vNoidungKN = null;

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
                vPhongbanID = 0;
            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            //--------------
            decimal _SodonTLM = Convert.ToDecimal(dropSoDonTLM.SelectedValue);
            //-----------------------------
            //manhnd 
            decimal _loaingaysearch = Convert.ToDecimal(dropLoaiNgaySer.SelectedValue);
            DateTime? vNgaySearch_Tu = txtNgayBA_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgaySearch_Den = txtNgayBA_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            //-----------------------------

            DataTable tbl = null;
            tbl = oBL.KNTP_SEARCH(Session[ENUM_SESSION.SESSION_USERID] + "",  Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
                , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao
                , vNgayThulyTu, vNgayThulyDen, vSoThuly
                , vTrangthai, vKetquathuly
                , isMuonHoSo, LoaiAnDB, vNoidungKN
                , _SodonTLM
                , _loaingaysearch
                , vNgaySearch_Tu
                , vNgaySearch_Den
                , pageindex, page_size);
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
               
            }
            //--------------------------------------------------
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                temp = "";
                DataRowView rv = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                lblSua.Visible = oPer.CAPNHAT;
                lbtXoa.Visible = oPer.XOA;

                
                //------------------------
                int loaian =String.IsNullOrEmpty(rv["LoaiAN"]+"")?0: Convert.ToInt16(rv["LoaiAN"]+"");
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");
                String LoaiKQ = "";
               
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");

                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");
               
               
                int GiaiDoanTrinh = String.IsNullOrEmpty(rv["GiaiDoanTrinh"] + "") ? 0 : Convert.ToInt32(rv["GiaiDoanTrinh"] + "");
               
                if (trangthai == (int)ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV)
                {
                    //hien ngay phan cong + qua trinh_ghi chu (GDTTT_VuAn)                       
                    lttDetaiTinhTrang.Text = (string.IsNullOrEmpty(rv["NGAYPHANCONGTTV"] + "") ? "" : (rv["NGAYPHANCONGTTV"].ToString() + "<br/>"));
                }
                else if (trangthai != 15)
                {
                    int loai_giaiquyet_don = (string.IsNullOrEmpty(rv["KQ_GQD_ID"] + "")) ? 3 : Convert.ToInt16(rv["KQ_GQD_ID"] + "");
                    if (loai_giaiquyet_don <= 3)
                    {
                        if (loai_giaiquyet_don == 0)
                            LoaiKQ = "Chấp nhận khiếu nại";
                        else if (loai_giaiquyet_don == 1)
                            LoaiKQ = "Không Chấp nhận khiếu nại";
                        else if (loai_giaiquyet_don == 2)
                            LoaiKQ = "Xếp đơn";
                        else if (loai_giaiquyet_don == 3)
                            LoaiKQ = "Giải quyết khác";


                        temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                        temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                        lttDetaiTinhTrang.Text ="<b>" + LoaiKQ + "</b><br/>" + temp;
                    }
                    else
                        lttDetaiTinhTrang.Text = "Chưa phân công TTV";

                    //KQGQ_THS kết quả giải quyết đơn đề nghị và các tài liệu kèm theo
                }
              
                //---------------------------
                Literal lttOther = (Literal)e.Item.FindControl("lttOther");
                string NgayTTVNhanHS = rv["NGAYTTVNHANHS"] + "";
                int soluong = String.IsNullOrEmpty(rv["IsHoSo"] + "") ? 0 : Convert.ToInt32(rv["IsHoSo"] + "");
                lttOther.Text = (soluong > 0) ? ("<div class='line_space'><b>" + "Đã có hồ sơ" + (string.IsNullOrEmpty(NgayTTVNhanHS) ? "" : " (" + NgayTTVNhanHS + ")") + "</b></div>") : "";
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal vuanid = 0;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    string[] arr = e.CommandArgument.ToString().Split('#');
                    if (arr.Length > 0)
                    {
                        int loaian = String.IsNullOrEmpty(arr[1] + "") ? 0 : Convert.ToInt16(arr[1] + "");
                        vuanid = String.IsNullOrEmpty(arr[0] + "") ? 0 : Convert.ToDecimal(arr[0] + "");
                        Response.Redirect("ThongtinKNTP.aspx?ID=" + vuanid);
                        
                    }
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    XoaVuAn(Convert.ToDecimal(e.CommandArgument));
                    break;
               
                case "KETQUA":
                    string StrKetqua = "PopupReport('/QLAN/GDTTT/VuAn/Popup/Ketqua.aspx?vid=" + e.CommandArgument + "','Kết quả giải quyết',850,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrKetqua, true);
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
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
           
            ddlThamtravien.SelectedIndex = 0;
            ddlLANHDAO.SelectedIndex = 0;
                     
            txtThuly_Tu.Text = "";
            txtThuly_Den.Text = "";
            txtThuly_So.Text = "";

            txtNguoiguidon.Text = string.Empty;
            ddlMuonHoso.SelectedValue = "2";

            ddlKetquaThuLy.SelectedValue="3";
           
            dropAnDB.SelectedIndex = 0;

            txtNgayBA_Tu.Text = "";
            txtNgayBA_Den.Text = "";

            Session.Remove("V_COLUME");
            Session.Remove("V_ASC_DESC");
            if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
            {
                Session["V_COLUME"] = "NGAYTHULYDON";
                Session["V_ASC_DESC"] = "DESC";
            }

            SetGetSessionTK(false);
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
            try
            {
                decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
                decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
                string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;
                decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
                decimal vLanhdao = Convert.ToDecimal(ddlLANHDAO.SelectedValue);

                string vCoquanchuyendon = "";// txtCoquanchuyendon.Text.Trim();
                string vNguoiGui = txtNguoiguidon.Text.Trim();


                DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
                string vSoThuly = txtThuly_So.Text;
                decimal vTrangthai = 0;
                decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);

                int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
                int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
                String vNoidungKN = null;

                if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
                    vPhongbanID = 0;
                //anhvh phân quyên liên quan đến án tử hình
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
                decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
                //--------------
                decimal _SodonTLM = Convert.ToDecimal(dropSoDonTLM.SelectedValue);
                //-----------------------------
                //manhnd 
                decimal _loaingaysearch = Convert.ToDecimal(dropLoaiNgaySer.SelectedValue);
                DateTime? vNgaySearch_Tu = txtNgayBA_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime? vNgaySearch_Den = txtNgayBA_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
                //-----------------------------


                DataTable tbl = null;
                tbl = oBL.KNTP_SEARCH_PRINT(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
                , vCoquanchuyendon, vLoaiAn, vThamtravien, vLanhdao
                , vNgayThulyTu, vNgayThulyDen, vSoThuly
                , vTrangthai, vKetquathuly
                , isMuonHoSo, LoaiAnDB, vNoidungKN
                , _SodonTLM
                , _loaingaysearch
                , vNgaySearch_Tu
                , vNgaySearch_Den);
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                    //INSERT_PAGE_BREAK = row["INSERT_PAGE_BREAK"] + "";
                }
                //--------------------------
                //String INSERT_PAGE_BREAK = "";
                //-------------------Export---------------------------
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
            catch (Exception ex) {
                lbtthongbao.Text = ex.Message;
            }
        }
    
        private DataTable SearchNoPaging()
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            string vNguyendon = null;
            string vBidon = null;
           
            decimal vThamtravien = Convert.ToDecimal(ddlThamtravien.SelectedValue);
            decimal vLanhdao = Convert.ToDecimal(ddlLANHDAO.SelectedValue);
          
            
            string vNguoiGui = txtNguoiguidon.Text.Trim();

          
            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vTrangthai = 0;
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
           
            //int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            //int pageindex = Convert.ToInt32(hddPageIndex.Value);

           
            int isMuonHoSo = Convert.ToInt16(ddlMuonHoso.SelectedValue);
         
            int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
           


            DataTable oDT = null;

            //oDT = oBL.VUAN_Search_NoPaging(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui,
            //   vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan,
            //   vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly,
            //   vTrangthai, vKetquathuly, vKetquaxetxu, isMuonHoSo
            //   , isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, ishoantha
            //   , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp);
            return oDT;
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
       
        protected void ddlLANHDAO_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
       
   
        void SetTieuDeBaoCao()
        {
            string tieudebc = "";

           
            //-------------------------------------
            String canbophutrach = "";
           
            //if (!String.IsNullOrEmpty(canbophutrach))
            //    canbophutrach += ", ";
            //if (ddlThamtravien.SelectedValue != "0")
            //    canbophutrach +=((string.IsNullOrEmpty(canbophutrach))?"":", " )+ "thẩm tra viên " + ddlThamtravien.SelectedItem.Text;

            if (ddlLANHDAO.SelectedValue != "0")
                canbophutrach += ((string.IsNullOrEmpty(canbophutrach)) ? "" : ", ") + "lãnh đạo Vụ " + ddlLANHDAO.SelectedItem.Text;

            if (!String.IsNullOrEmpty(canbophutrach))
                canbophutrach += " phụ trách";

            tieudebc += (string.IsNullOrEmpty(canbophutrach)) ? "" : " do " + canbophutrach;
            //-------------------------------------
            if (ddlMuonHoso.SelectedValue != "2")
                tieudebc += " " + ddlMuonHoso.SelectedItem.Text.ToLower();

            //-----------------------------
            txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc.Replace("...", "");
        }
    }
}
