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
using System.Text;
using BL.GSTP.QLAN;

namespace WEB.GSTP.QLAN.BAOCAOCA
{
    public partial class DanhsachCA_VUAN : System.Web.UI.Page
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
                    //-------------------------------
                    Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    if (LoginDonViID == 1)
                    {
                        pnSearchCC.Visible = false;
                        txtNgayBA_Tu.Text = txtNgayBA_Den.Text = string.Empty;
                    }
                    else
                        pnSearchCC.Visible = true;
                    //Khong cho Load du lieu khi chua nhan tim kiem
                    //int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                    //if (IsHome == 1) //khi chọn từ màn hình login
                    Load_Data();
                    Session[SS_TK.ISHOME] = "0";//khi load xong thi hủy trạng thái xác định chọn tu login
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnThemmoi, oPer.TAOMOI);
                }
                if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                {
                    lblLoaidon.Visible = true;
                    ddlloaidon.Visible = true;
                }
                Clear_SessionTK();
            }
            else
                Response.Redirect("/Login.aspx");
        }
        private void SetGetSessionTK(bool isSet)
        {
            try
            {
                if (Session[SS_BAOCAO_CA.LOAIAN] != null)
                    ddlLoaiAn.SelectedValue = Session[SS_BAOCAO_CA.LOAIAN] + "";
                if (Session[SS_BAOCAO_CA.THAMPHAN] != null)
                    ddlThamphan.SelectedValue = Session[SS_BAOCAO_CA.THAMPHAN] + "";

                txtThuly_Tu.Text = Session[SS_BAOCAO_CA.TUNGAY] + "";
                txtThuly_Den.Text = Session[SS_BAOCAO_CA.DENNGAY] + "";

                if (Session[SS_BAOCAO_CA.COLUMN_SOLIEU] != null)
                    ddlKetquaThuLy.SelectedValue = Session[SS_BAOCAO_CA.COLUMN_SOLIEU] + "";

                if (Session[SS_BAOCAO_CA.VALUE_ANQUOCHOI] != null)
                    dropAnDB.SelectedValue = Session[SS_BAOCAO_CA.VALUE_ANQUOCHOI] + "";

                if (Session[SS_BAOCAO_CA.VALUE_ANTHOIHIEU] != null)
                    dropAnDB_TH.SelectedValue = Session[SS_BAOCAO_CA.VALUE_ANTHOIHIEU] + "";

                string viewName = Session[SS_BAOCAO_CA.VALUE_TAB] + "";
                // Xử lý chọn tab
                tabtatc.CssClass = "tab " + (viewName == "ViewTATC" ? "selected" : "");
                tabtptatc.CssClass = "tab " + (viewName == "ViewTPTATC" ? "selected" : "");
                tabstpt.CssClass = "tab " + (viewName == "ViewTAND" ? "selected" : "");
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
            ddlKetquaThuLy.Items.Add(new ListItem("--Tất cả--", ""));
            ddlKetquaThuLy.Items.Add(new ListItem("Cũ chuyển sang", "2"));
            ddlKetquaThuLy.Items.Add(new ListItem("Mới thụ lý", "3"));
            ddlKetquaThuLy.Items.Add(new ListItem("Tổng đã giải quyết", "4"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Trả lời đơn", "5"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Kháng nghị", "6"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Xếp đơn", "7"));
            ddlKetquaThuLy.Items.Add(new ListItem("Chưa giải quyết", "8"));
            ddlKetquaThuLy.Items.Add(new ListItem("Đã thụ lý XXGĐT", "9"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Kháng nghị CA", "10"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Kháng nghị VKS", "11"));
            ddlKetquaThuLy.Items.Add(new ListItem("Đã xét xử", "12"));
            ddlKetquaThuLy.Items.Add(new ListItem("Chưa xét xử", "13"));
        }
        void LoadDrop_TinhTrangThuLy()
        {
           
            decimal[] kq =  {13,14,16,18};
            List<GDTTT_DM_TINHTRANG> lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1 && !kq.Contains(x.ID)).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
            SetName_Vu_Phongban(lst);//anhvh add 05/04/2011 add check name phong ban cap cao
            ddlTrangthaithuly.DataSource = lst;
            ddlTrangthaithuly.DataTextField = "TENTINHTRANG";
            ddlTrangthaithuly.DataValueField = "ID";
            ddlTrangthaithuly.DataBind();
            ddlTrangthaithuly.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            //ddlTrangthaithuly.SelectedValue = "2"; //Da phan cong TTV

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
            {
                int count_lst = lst.Count;
                ddlTrangthaithuly.Items.Insert(count_lst + 1, new ListItem("Báo cáo PCA, Tổ TP, CA, Hội đồng TP", "-1"));
            }

            lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1
                                                && x.ID >= 6 && x.ID !=10).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
            SetName_Vu_Phongban(lst);//anhvh add
            dropCapTrinhTiepTheo.DataSource = lst;
            dropCapTrinhTiepTheo.DataTextField = "TENTINHTRANG";
            dropCapTrinhTiepTheo.DataValueField = "ID";
            dropCapTrinhTiepTheo.DataBind();
            dropCapTrinhTiepTheo.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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
            ddlThamtravien.Items.Insert(count + 1, new ListItem("-- Chưa phân công --", "-1"));
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
            //Decimal ChucVuPCA = 0;
            //Decimal ChucVuCA = 0;
            //Decimal ChucDanh_TPTATC = 0;
            //Decimal ChucDanh_TPCC = 0;
            //int count = 0;
            //try { ChucVuPCA = dt.DM_DATAITEM.Where(x => x.MA == "PCA").FirstOrDefault().ID; } catch (Exception ex) { }
            //try { ChucVuCA = dt.DM_DATAITEM.Where(x => x.MA == "CA").FirstOrDefault().ID; } catch (Exception ex) { }
            //try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            //try { ChucDanh_TPCC = dt.DM_DATAITEM.Where(x => x.MA == "TPCC").FirstOrDefault().ID; } catch (Exception ex) { }

            //Decimal LoginDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            //decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            ////Load Thẩm phán
            //GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            //Boolean IsLoadAll = false;
            //ddlThamphan.Items.Clear();
            //Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            //DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            //if (oCB.CHUCVUID != null && oCB.CHUCVUID == ChucVuPCA || oCB.CHUCVUID == ChucVuCA)
            //{
            //    if (oCB.CHUCDANHID == ChucDanh_TPTATC || oCB.CHUCDANHID == ChucDanh_TPCC)
            //    {
            //        //ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
            //        hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
            //        //----------anhvh add 30/10/2019
            //        DataTable tbl = oGDTBL.GDTTT_Tp_Duoc_Phutrach(Session[ENUM_SESSION.SESSION_DONVIID] + "",Convert.ToInt32(oCB.ID));
            //        ddlThamphan.DataSource = tbl;
            //        ddlThamphan.DataTextField = "HOTEN";
            //        ddlThamphan.DataValueField = "ID";
            //        ddlThamphan.DataBind();
            //    }
            //    else
            //    IsLoadAll = true;
            //}
            //else if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            //{
            //    //DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
            //    if (oCB.CHUCDANHID == ChucDanh_TPTATC|| oCB.CHUCDANHID == ChucDanh_TPCC)
            //    {
            //        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
            //        hddLoaiTK.Value = ENUM_CHUCDANH.CHUCDANH_THAMPHAN;
            //    }
            //    else
            //        IsLoadAll = true;
            //}
            //else
            //    IsLoadAll = true;
            //if (IsLoadAll)
            //{
            //    //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            //    DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            //    count = tbl.Rows.Count;
            //    ddlThamphan.DataSource = tbl;
            //    ddlThamphan.DataTextField = "HOTEN";
            //    ddlThamphan.DataValueField = "ID";
            //    ddlThamphan.DataBind();
            //    ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            //    ddlThamphan.Items.Insert(count + 1, new ListItem("-- Chưa phân công --", "-1"));
            //}
            DASHBOARD_GDT_BL OBL = new DASHBOARD_GDT_BL();
            decimal vThamphan_id;
            if (ddlThamphan.SelectedValue == "" || ddlThamphan.SelectedValue == "0")
            {
                vThamphan_id = 0;
            }
            else
            {
                vThamphan_id = Convert.ToInt32(ddlThamphan.SelectedValue);
            }

            DataTable tbl = OBL.MHCA_DANHSACH_THAMPHAN_TOICAO(Session[ENUM_SESSION.SESSION_DONVIID] + "", (Int32)vThamphan_id);
            ddlThamphan.DataSource = tbl;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
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
            //chk_conlai.Visible = false;
            if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
            {
                Decimal CurrChucVuID = string.IsNullOrEmpty(oCB.CHUCVUID + "") ? 0 : (decimal)oCB.CHUCVUID;

                DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                if (oCD.MA == "TPTATC"|| oCD.MA =="TPCC")
                {
                    //chk_conlai.Visible = true;
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
            ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
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

        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                //GDTTT_VUAN obj = new GDTTT_VUAN();
                //obj.LOAIAN = 1;
                //obj.ISTOTRINH = 0;
                //obj.PHONGBANID = PhongBanID;
                //obj.TOAANID = CurrDonViID;
                //obj.NGAYTAO = DateTime.Now;
                //obj.NGUOITAO = UserName;
                //obj.NGAYSUA = DateTime.Now;
                //obj.NGUOISUA = UserName;
                //dt.GDTTT_VUAN.Add(obj);
                //dt.SaveChanges();
                //Session["VUVIECID_CC"] = obj.ID.ToString();// oGDTBL.GDTTT_VUAN_REIDS();
                Response.Redirect("ThongtinvuanHS.aspx?type=new");
            }
            else
                Response.Redirect("Thongtinvuan.aspx?type=new");
        }
        //-----------------------------------------
        private void Load_Data()
        {
            dgList.Visible = dgListHS.Visible = false;
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
                //DataTable oDT2 = getDS(count_all, pageindex);
                //for (int i = 0; i < oDT2.Rows.Count; i++)
                //{
                //    sumTLM = Convert.ToInt32(oDT2.Rows[i]["cThulymoi"]) + sumTLM;
                //}
            }
                
            if (oDT != null && count_all > 0)
            {
                //#region "Xác định số lượng trang"
                //hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                //lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> vụ án " + "<b>(" + sumTLM + " đơn TLM)</b> trong <b>" + hddTotalPage.Value + "</b> trang";
                //Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                //             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                //#endregion
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> bản ghi " + "trong <b>" + hddTotalPage.Value + "</b> trang";
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
        }
        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DASHBOARD_GDT_BL oBL = new DASHBOARD_GDT_BL();
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
            String LoaiAnDB_TH  = dropAnDB_TH.SelectedValue;
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

            String chk_conlai_s=Convert.ToInt32(chk_conlai.Checked).ToString();
            //-----------------------------
            //manhnd 
            decimal _loaingaysearch = Convert.ToDecimal(dropLoaiNgaySer.SelectedValue);
            DateTime? vNgaySearch_Tu = txtNgayBA_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgaySearch_Den = txtNgayBA_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            //-----------------------------
            DataTable tbl = null;

            if (vKetquathuly < 9 && LoaiAnDB == 0 && string.IsNullOrEmpty(LoaiAnDB_TH))
            {
                //anhpn
                if (vLoaiAn == 1)//án hình sự
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_DON_HS(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                else if(vThamphan > 0 && Session[SS_BAOCAO_CA.VALUE_TAB].ToString() == "ViewTPTATC")
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_DON_TP(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                else
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_DON(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                //-----------
                dgListHS.Visible = false;
                dgList.Visible = false;
                //-----------
                if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                {
                    lblTitleBD.Text = "Bị cáo";
                    lblTitleBC.Visible = txtNguyendon.Visible = false;
                    dgListDon.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListDon.DataSource = tbl;
                    dgListDon.DataBind();
                    // Ẩn cột "NGUYENDON"
                    dgListDon.Columns[4].HeaderText = "Tội danh";
                    dgListDon.Columns[5].HeaderText = "Bị cáo đầu vụ";
                    dgListDon.Columns[6].HeaderText = "Bị cáo khác";
                    // Thay tên cột "BIDON"   
                    lblTitleBD.Text = "Bị cáo";
                    lblTitleBC.Visible = txtNguyendon.Visible = false;

                    dgListDon.Columns[4].Visible = false;
                    dgListDon.Columns[5].Visible = false;
                    dgListDon.Columns[6].Visible = false;
                    dgListDon.Columns[7].Visible = true;
                    dgListDon.Columns[8].Visible = true;
                    dgListDon.Columns[9].Visible = true;
                    dgListDon.Columns[10].Visible = false;
                    dgListDon.Columns[11].Visible = false;
                }
                else if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HANHCHINH)
                {
                    lblTitleBC.Text = "Người khởi kiện";
                    lblTitleBD.Text = "Người bị kiện";
                    tblQHPL.Text = "Quan hệ PL";
                    lblTitleBD.Visible = txtBidon.Visible = true;
                    dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListDon.DataSource = tbl;
                    dgListDon.DataBind();

                    dgListDon.Columns[4].Visible = true;
                    dgListDon.Columns[5].Visible = false;
                    dgListDon.Columns[6].Visible = false;
                    dgListDon.Columns[7].Visible = false;
                    dgListDon.Columns[8].Visible = false;
                    dgListDon.Columns[9].Visible = false;
                    dgListDon.Columns[10].Visible = true;
                    dgListDon.Columns[11].Visible = true;
                }
                else
                {
                    lblTitleBD.Text = "Bị đơn";
                    lblTitleBC.Visible = txtNguyendon.Visible = true;
                    dgListDon.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListDon.DataSource = tbl;
                    dgListDon.DataBind();
                    dgListDon.Columns[4].HeaderText = "Quan hệ pháp luật";
                    dgListDon.Columns[5].HeaderText = "Nguyên đơn/ Người khởi kiện";
                    dgListDon.Columns[6].HeaderText = "Bị đơn/ Người bị kiện";

                    lblTitleBD.Text = "Bị đơn";
                    lblTitleBC.Visible = txtNguyendon.Visible = true;

                    dgListDon.Columns[4].Visible = true;
                    dgListDon.Columns[5].Visible = true;
                    dgListDon.Columns[6].Visible = true;
                    dgListDon.Columns[7].Visible = false;
                    dgListDon.Columns[8].Visible = false;
                    dgListDon.Columns[9].Visible = false;
                    dgListDon.Columns[10].Visible = false;
                    dgListDon.Columns[11].Visible = false;
                }
            }
            else if (vKetquathuly < 9 && LoaiAnDB == 0 && !string.IsNullOrEmpty(LoaiAnDB_TH))
            {
                //anhpn
                if (vLoaiAn == 1)//án hình sự
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_DON_HS(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                else if (vThamphan > 0 && Session[SS_BAOCAO_CA.VALUE_TAB].ToString() == "ViewTPTATC")
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_DON_TP(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                else
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_DON(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                //-----------
                dgListHS.Visible = false;
                dgList.Visible = false;
                //-----------
                if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                {
                    lblTitleBD.Text = "Bị cáo";
                    lblTitleBC.Visible = txtNguyendon.Visible = false;
                    dgListDon.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListDon.DataSource = tbl;
                    dgListDon.DataBind();
                    // Ẩn cột "NGUYENDON"
                    dgListDon.Columns[4].HeaderText = "Tội danh";
                    dgListDon.Columns[5].HeaderText = "Bị cáo đầu vụ";
                    dgListDon.Columns[6].HeaderText = "Bị cáo khác";
                    // Thay tên cột "BIDON"   
                    lblTitleBD.Text = "Bị cáo";
                    lblTitleBC.Visible = txtNguyendon.Visible = false;

                    dgListDon.Columns[4].Visible = false;
                    dgListDon.Columns[5].Visible = false;
                    dgListDon.Columns[6].Visible = false;
                    dgListDon.Columns[7].Visible = true;
                    dgListDon.Columns[8].Visible = true;
                    dgListDon.Columns[9].Visible = true;
                    dgListDon.Columns[10].Visible = false;
                    dgListDon.Columns[11].Visible = false;
                }
                else if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HANHCHINH)
                {
                    lblTitleBC.Text = "Người khởi kiện";
                    lblTitleBD.Text = "Người bị kiện";
                    tblQHPL.Text = "Quan hệ PL";
                    lblTitleBD.Visible = txtBidon.Visible = true;
                    dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListDon.DataSource = tbl;
                    dgListDon.DataBind();

                    dgListDon.Columns[4].Visible = true;
                    dgListDon.Columns[5].Visible = false;
                    dgListDon.Columns[6].Visible = false;
                    dgListDon.Columns[7].Visible = false;
                    dgListDon.Columns[8].Visible = false;
                    dgListDon.Columns[9].Visible = false;
                    dgListDon.Columns[10].Visible = true;
                    dgListDon.Columns[11].Visible = true;
                }
                else
                {
                    lblTitleBD.Text = "Bị đơn";
                    lblTitleBC.Visible = txtNguyendon.Visible = true;
                    dgListDon.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListDon.DataSource = tbl;
                    dgListDon.DataBind();
                    dgListDon.Columns[4].HeaderText = "Quan hệ pháp luật";
                    dgListDon.Columns[5].HeaderText = "Nguyên đơn/ Người khởi kiện";
                    dgListDon.Columns[6].HeaderText = "Bị đơn/ Người bị kiện";

                    lblTitleBD.Text = "Bị đơn";
                    lblTitleBC.Visible = txtNguyendon.Visible = true;

                    dgListDon.Columns[4].Visible = true;
                    dgListDon.Columns[5].Visible = true;
                    dgListDon.Columns[6].Visible = true;
                    dgListDon.Columns[7].Visible = false;
                    dgListDon.Columns[8].Visible = false;
                    dgListDon.Columns[9].Visible = false;
                    dgListDon.Columns[10].Visible = false;
                    dgListDon.Columns[11].Visible = false;
                }
            }
            else if (vKetquathuly < 9 && LoaiAnDB != 0 && string.IsNullOrEmpty(LoaiAnDB_TH))
            {
                //anhpn
                if (vLoaiAn == 1)//án hình sự
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_DON_HS(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                else if (vThamphan > 0 && Session[SS_BAOCAO_CA.VALUE_TAB].ToString() == "ViewTPTATC")
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_DON_TP(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                else
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_DON(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                //-----------
                dgListHS.Visible = false;
                dgList.Visible = false;
                //-----------
                if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                {
                    lblTitleBD.Text = "Bị cáo";
                    lblTitleBC.Visible = txtNguyendon.Visible = false;
                    dgListDon.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListDon.DataSource = tbl;
                    dgListDon.DataBind();
                    // Ẩn cột "NGUYENDON"
                    dgListDon.Columns[4].HeaderText = "Tội danh";
                    dgListDon.Columns[5].HeaderText = "Bị cáo đầu vụ";
                    dgListDon.Columns[6].HeaderText = "Bị cáo khác";
                    // Thay tên cột "BIDON"   
                    lblTitleBD.Text = "Bị cáo";
                    lblTitleBC.Visible = txtNguyendon.Visible = false;

                    dgListDon.Columns[4].Visible = false;
                    dgListDon.Columns[5].Visible = false;
                    dgListDon.Columns[6].Visible = false;
                    dgListDon.Columns[7].Visible = true;
                    dgListDon.Columns[8].Visible = true;
                    dgListDon.Columns[9].Visible = true;
                    dgListDon.Columns[10].Visible = false;
                    dgListDon.Columns[11].Visible = false;
                }
                else if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HANHCHINH)
                {
                    lblTitleBC.Text = "Người khởi kiện";
                    lblTitleBD.Text = "Người bị kiện";
                    tblQHPL.Text = "Quan hệ PL";
                    lblTitleBD.Visible = txtBidon.Visible = true;
                    dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListDon.DataSource = tbl;
                    dgListDon.DataBind();

                    dgListDon.Columns[4].Visible = true;
                    dgListDon.Columns[5].Visible = false;
                    dgListDon.Columns[6].Visible = false;
                    dgListDon.Columns[7].Visible = false;
                    dgListDon.Columns[8].Visible = false;
                    dgListDon.Columns[9].Visible = false;
                    dgListDon.Columns[10].Visible = true;
                    dgListDon.Columns[11].Visible = true;
                }
                else
                {
                    lblTitleBD.Text = "Bị đơn";
                    lblTitleBC.Visible = txtNguyendon.Visible = true;
                    dgListDon.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListDon.DataSource = tbl;
                    dgListDon.DataBind();
                    dgListDon.Columns[4].HeaderText = "Quan hệ pháp luật";
                    dgListDon.Columns[5].HeaderText = "Nguyên đơn/ Người khởi kiện";
                    dgListDon.Columns[6].HeaderText = "Bị đơn/ Người bị kiện";

                    lblTitleBD.Text = "Bị đơn";
                    lblTitleBC.Visible = txtNguyendon.Visible = true;

                    dgListDon.Columns[4].Visible = true;
                    dgListDon.Columns[5].Visible = true;
                    dgListDon.Columns[6].Visible = true;
                    dgListDon.Columns[7].Visible = false;
                    dgListDon.Columns[8].Visible = false;
                    dgListDon.Columns[9].Visible = false;
                    dgListDon.Columns[10].Visible = false;
                    dgListDon.Columns[11].Visible = false;
                }
            }
            else
            {
                if (vThamphan > 0 && Session[SS_BAOCAO_CA.VALUE_TAB].ToString() == "ViewTPTATC")
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_VUAN_TP(Session[ENUM_SESSION.SESSION_USERID] + "", chk_conlai_s, Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
                   , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                   , vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly
                   , vTrangthai, vKetquathuly, vKetquaxetxu
                   , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, LoaiAnDB_TH, isHoanTHA
                   , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp, _ISXINANGIAM, _GDT_ISXINANGIAM, _SodonTLM, _LoaiGDT
                   , vQHPL_TD, _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                else if (!string.IsNullOrEmpty(LoaiAnDB_TH))
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_VUAN_THOIHIEU(Session[ENUM_SESSION.SESSION_USERID] + "", chk_conlai_s, Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
                   , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                   , vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly
                   , vTrangthai, vKetquathuly, vKetquaxetxu
                   , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, LoaiAnDB_TH, isHoanTHA
                   , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp, _ISXINANGIAM, _GDT_ISXINANGIAM, _SodonTLM, _LoaiGDT
                   , vQHPL_TD, _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }
                else
                {
                    tbl = oBL.MHCA_DANHSACH_SEARCH_VUAN(Session[ENUM_SESSION.SESSION_USERID] + "", chk_conlai_s, Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
                   , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                   , vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly
                   , vTrangthai, vKetquathuly, vKetquaxetxu
                   , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, LoaiAnDB_TH, isHoanTHA
                   , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp, _ISXINANGIAM, _GDT_ISXINANGIAM, _SodonTLM, _LoaiGDT
                   , vQHPL_TD, _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
                }

                if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                {
                    lblTitleBC.Text = "Bị cáo";
                    tblQHPL.Text = "Tội danh";
                    lblTitleBD.Visible = txtBidon.Visible = false;
                    dgListHS.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgListHS.DataSource = tbl;
                    dgListHS.DataBind();
                    dgListHS.Visible = true;
                    dgList.Visible = false;  
                    dgListDon.Visible = false;
                }
                else if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HANHCHINH)
                {
                    lblTitleBC.Text = "Người khởi kiện";
                    lblTitleBD.Text = "Người bị kiện";
                    tblQHPL.Text = "Quan hệ PL";
                    lblTitleBD.Visible = txtBidon.Visible = true;
                    dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgList.DataSource = tbl;
                    dgList.DataBind();
                    dgList.Visible = true;
                    dgListHS.Visible = false;
                    dgListDon.Visible = false;
                }
                else
                {
                    lblTitleBC.Text = "Nguyên đơn";
                    tblQHPL.Text = "Quan hệ PL";
                    lblTitleBD.Visible = txtBidon.Visible = true;
                    dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                    dgList.DataSource = tbl;
                    dgList.DataBind();
                    dgList.Visible = true;
                    dgListHS.Visible = false;
                    dgListDon.Visible = false;
                }
            }    
           return tbl;
        }

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        String temp = "";

        void XoaVuAn(Decimal CurrVuAnID)
        {

            //GDTTT_TUHINH_BL obl = new GDTTT_TUHINH_BL();
            //decimal count_ds = obl.HOSO_TUHINH_BY_VUANID(CurrVuAnID);
            //if (count_ds > 0)
            //{
            //    lbtthongbao.Text = "Bạn không được xóa Vụ án khi hồ sơ đang xem xin ân giảm";
            //    return;
            //}

            //List<GDTTT_QUANLYHS> lstHS = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == CurrVuAnID).ToList();
            //if (lstHS != null && lstHS.Count > 0)
            //{
            //    lbtthongbao.Text = "Đã có dữ liệu liên quan, không được phép xóa!";
            //    return;
            //}
            //else
            //{
            //    List<GDTTT_TOTRINH> lstTT = dt.GDTTT_TOTRINH.Where(x => x.VUANID == CurrVuAnID).ToList();
            //    if (lstTT != null && lstTT.Count > 0)
            //    {
            //        lbtthongbao.Text = "Đã có dữ liệu liên quan, không được phép xóa!";
            //        return;
            //    }
            //}
            ////------------------------           
            //List<GDTTT_VUAN_DUONGSU> lstDS = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID).ToList();
            //if (lstDS != null && lstDS.Count > 0)
            //{
            //    foreach (GDTTT_VUAN_DUONGSU objDS in lstDS)
            //        dt.GDTTT_VUAN_DUONGSU.Remove(objDS);
            //}
            //dt.SaveChanges();
            ////-----------------------------
            //List<GDTTT_VUAN_THAMTRAVIEN> lstTTV = dt.GDTTT_VUAN_THAMTRAVIEN.Where(x => x.VUANID == CurrVuAnID).ToList();
            //if (lstDS != null && lstDS.Count > 0)
            //{
            //    foreach (GDTTT_VUAN_THAMTRAVIEN objTTV in lstTTV)
            //        dt.GDTTT_VUAN_THAMTRAVIEN.Remove(objTTV);
            //}
            //dt.SaveChanges();
            ////---------------anhvh add 29/05/2021--------------
            //List<GDTTT_VUAN_DUONGSU_TOIDANH> lst_td = dt.GDTTT_VUAN_DUONGSU_TOIDANH.Where(x => x.VUANID == CurrVuAnID).ToList();
            //if (lstDS != null && lstDS.Count > 0)
            //{
            //    foreach (GDTTT_VUAN_DUONGSU_TOIDANH obj_td in lst_td)
            //        dt.GDTTT_VUAN_DUONGSU_TOIDANH.Remove(obj_td);
            //}
            //dt.SaveChanges();
            ////---------------anhvh add 29/05/2021--------------
            //List<GDTTT_VUAN_DS_KN> lst_kn = dt.GDTTT_VUAN_DS_KN.Where(x => x.VUANID == CurrVuAnID).ToList();
            //if (lstDS != null && lstDS.Count > 0)
            //{
            //    foreach (GDTTT_VUAN_DS_KN obj_kn in lst_kn)
            //        dt.GDTTT_VUAN_DS_KN.Remove(obj_kn);
            //}
            //dt.SaveChanges();
            ////-----------------------------
            //GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
            //dt.GDTTT_VUAN.Remove(oT);
            //dt.SaveChanges();
            ////-----------------------
            //List<GDTTT_DON> lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == CurrVuAnID && x.CD_TRANGTHAI == 2).ToList();
            //if (lstDon != null && lstDon.Count > 0)
            //{
            //    foreach (GDTTT_DON oDon in lstDon)
            //        oDon.VUVIECID = 0;
            //}
            //dt.SaveChanges();
            //dgList.CurrentPageIndex = 0;
            //hddPageIndex.Value = "1";
            //Load_Data();
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

                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");
                Literal txtAnQuocHoi = (Literal)e.Item.FindControl("txtAnQuocHoi");
                Literal txtSoNgayThuLy = (Literal)e.Item.FindControl("txtSoNgayThuLy");

                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");
                string LoaiKN = (rv["IsVienTruongKN"].ToString() == "0") ? "(CA)" : "(VKS)";
                lttLanTT.Text = "<b>" + rv["TENTINHTRANG"] + "</b>";

                if (trangthai == (int)ENUM_GDTTT_TRANGTHAI.KHANGNGHI)
                    lttLanTT.Text += " " + LoaiKN;
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
                            lttLanTT.Text = "<b>" + rv["TENTINHTRANG"] + " lần " + lstTT.Count.ToString() + "</b>";

                            GDTTT_TOTRINH objTT = lstTT[0];
                            if (!string.IsNullOrEmpty(objTT.NGAYTRINH + "") || (DateTime)objTT.NGAYTRINH != DateTime.MinValue)
                                lttDetaiTinhTrang.Text = "<br/><span style='margin-right:10px;'>Ngày trình: " + Convert.ToDateTime(objTT.NGAYTRINH).ToString("dd/MM/yyyy", cul) + "</span>";
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
                    }
                    else if (trangthai != 15)
                    {
                        int loai_giaiquyet_don = (string.IsNullOrEmpty(rv["KQ_GQD_ID"] + "")) ? 5 : Convert.ToInt16(rv["KQ_GQD_ID"] + "");
                        if (loai_giaiquyet_don <= 2)
                        {
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

                                    //----Có kết quả trả lời đơn---------------
                                    List<GDTTT_DON_TRALOI> lstTLD = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == CurrVuAnID && x.TYPETB == 3).ToList();
                                    if (lstTLD.Count > 0)
                                        temp += "</br> <b><b>Trả lời đơn </b></b> </br>" + rv["AHS_THONGTINGQD"] + "";

                                    lttDetaiTinhTrang.Text = temp;
                                }
                            }
                            else
                            {
                                lttLanTT.Text = "<b>" + rv["KQ_GQD"] + " " + rv["LoaiKN"].ToString() + " </b>";
                                temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                                temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                                lttDetaiTinhTrang.Text = temp;
                            }
                        } else if (loai_giaiquyet_don == 4)
                            lttLanTT.Text = "<b>Thông báo VKS " + " </b><br/>" + rv["KQ_GQD"];
                          else if (loai_giaiquyet_don == 3)
                            lttLanTT.Text = "<b>KQGQ_THS: " + " </b>" + rv["KQ_GQD"];
                        //KQGQ_THS kết quả giải quyết đơn đề nghị và các tài liệu kèm theo
                    }
                    else if (trangthai == 15)
                    {
                        lttLanTT.Text = "<b>Kháng nghị " + rv["LoaiKN"].ToString() + " </b>";
                        temp = String.IsNullOrEmpty(rv["GDQ_SO"] + "") ? "" : ("<span style=''>Số: <b>" + rv["GDQ_SO"].ToString() + "</b></span>");
                        temp += (String.IsNullOrEmpty(temp) ? "" : (string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : ("<br/>Ngày: <b>" + rv["GDQ_NGAY"].ToString() + "</b>"));
                        lttLanTT.Text += (String.IsNullOrEmpty(temp) ? "" : "</br>") + temp;
                        //-------thong tin thu ly XXGDTTT------------------------------
                        if (Convert.ToInt16(rv["IsRutKN"] + "") == 0)
                        {
                            if (lttLanTT.Text.Length > 0)
                                lttLanTT.Text += "<span class='line_space'></span>";
                            lttLanTT.Text += "<b style='float:left;width:100%;'>" + rv["TENTINHTRANG"] + "</b>";

                            //So/ngay thu ly XXGDTTT
                            lttDetaiTinhTrang.Text = (String.IsNullOrEmpty(rv["SOTHULYXXGDT"] + "")) ? "" : "<span style = 'margin-right:10px;' >Số TL: " + rv["SOTHULYXXGDT"].ToString()
                                                     + ((string.IsNullOrEmpty(rv["NGAYTHULYXXGDT"] + "")) ? "" : "<br/>Ngày TL: " + rv["NGAYTHULYXXGDT"].ToString());
                        }
                    }

                }
                //-------------------------------
                if (Convert.ToInt16(rv["IsRutKN"] + "") > 0)
                {
                    if (lttLanTT.Text.Length > 0)
                        lttLanTT.Text += "<br/><span class='line_space'></span>";
                    lttLanTT.Text += "<br/><b>Rút kháng nghị</b>";
                    temp = String.IsNullOrEmpty(rv["SORUTKN"] + "") ? "" : "Số <b>" + rv["SORUTKN"].ToString() + "</b>";
                    if ((temp != "") && (!String.IsNullOrEmpty(rv["NGAYRUTKN"].ToString())))
                        temp += " ngày <b>" + rv["NGAYRUTKN"] + "" + "</b>";
                    if (!String.IsNullOrEmpty(temp))
                        lttLanTT.Text += "<br/>" + temp;
                }
                //-------------------------------
                Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");
                if (trangthai != 15)
                {
                    int IsHoanTHA = Convert.ToInt16(rv["GQD_ISHOANTHA"] + "");
                    if (IsHoanTHA > 0)
                    {
                        lttKQGQ.Text = "<span class='line_space'>";
                        lttKQGQ.Text += "<b>Hoãn thi hành án</b>" + "<br/>";
                        lttKQGQ.Text += "<span style='margin-right:10px;'>Số: <b>" + rv["GQD_HoanTHA_So"].ToString() + "</b></span>";
                        lttKQGQ.Text += "<span style=''>Ngày: <b>" + rv["GQD_HoanTHA_Ngay"].ToString() + "</b></span><br/>";
                        lttKQGQ.Text += "";
                        lttKQGQ.Text += "</span>";
                    }
                }
                else
                {
                    #region XXGDTTT
                    int IsHoan = Convert.ToInt16(rv["XXGDTTT_ISHOANPT"] + "");
                    if (IsHoan > 0)
                    {
                        lttKQGQ.Text = "<span class='line_space'>";
                        lttKQGQ.Text += "<b>Hoãn xét xử</b>" + "<br/>";
                        lttKQGQ.Text += "<span style='margin-right:10px;'>Ngày: <b>" + rv["XXGDTTT_NGAYHOAN"].ToString() + "</b></span>";
                        if (!String.IsNullOrEmpty(rv["XXGDTTT_LYDOHOAN"] + ""))
                            lttKQGQ.Text += "<br/>";
                        lttKQGQ.Text += "<span style=''>Lý do: <b>" + rv["XXGDTTT_LYDOHOAN"].ToString() + "</b></span>";
                        lttKQGQ.Text += "<br/>";
                        lttKQGQ.Text += "</span>";
                    }
                    else
                    {
                        if (!String.IsNullOrEmpty(rv["NGAYXUGIAMDOCTHAM"] + ""))
                        {
                            lttKQGQ.Text = "<span class='line_space'>";
                            lttKQGQ.Text += "<b>Kết quả XX</b>" + "<br/>";
                            //--------------------------                    
                            if (!String.IsNullOrEmpty(rv["NGAYXUGIAMDOCTHAM"] + ""))
                                lttKQGQ.Text += "<span style=''>Ngày xử: <b>" + rv["NGAYXUGIAMDOCTHAM"].ToString() + "</b></span>";

                            if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + "") || !String.IsNullOrEmpty(rv["XXGDTTT_NGAYQD"] + ""))
                            {
                                lttKQGQ.Text += "<br/>";
                                if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                    lttKQGQ.Text += "<span style='margin-right:10px;'>Số QĐ: <b>" + rv["XXGDTTT_SOQD"].ToString() + "</b></span>";
                                if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                    lttKQGQ.Text += "<span style=''>Ngày QĐ: <b>" + rv["XXGDTTT_NGAYQD"].ToString() + "</b></span>";
                            }
                            if (!String.IsNullOrEmpty(rv["KetQuaXXGDT"] + ""))
                            {
                                lttKQGQ.Text += "<br/>";
                                lttKQGQ.Text += "<span style=''>KQ: <b>" + rv["KetQuaXXGDT"].ToString() + "</b></span>";
                            }
                            if (!String.IsNullOrEmpty(rv["HOIDONGXX"] + ""))
                            {
                                lttKQGQ.Text += rv["HOIDONGXX"];
                            }
                            if (!String.IsNullOrEmpty(rv["TEN_CHUTOA"] + ""))
                            {
                                lttKQGQ.Text += rv["TEN_CHUTOA"];
                            }
                            lttKQGQ.Text += "</span>";
                        }
                    }
                    #endregion
                }

                //---------------------------
                if (!String.IsNullOrEmpty(rv["ISANQUOCHOI"] + "") && rv["ISANQUOCHOI"].ToString() == "1")
                {
                    var VuAnID = decimal.Parse(rv["ID"] + "");
                    var OGDTTT_DON = dt.GDTTT_DON.Where(o => o.VUVIECID == VuAnID).FirstOrDefault();
                    if (OGDTTT_DON != null)
                    {
                        txtAnQuocHoi.Text += "Đơn vị chuyển: " + OGDTTT_DON.CV_TENDONVI + "";
                        txtAnQuocHoi.Text += "<br/>";
                        txtAnQuocHoi.Text += "Số CV: <b>" + OGDTTT_DON.CV_SO + " </b>";
                        txtAnQuocHoi.Text += "<br/>";
                        txtAnQuocHoi.Text += "Ngày: <b>" + OGDTTT_DON.CV_NGAY.Value.ToString("dd/MM/yyyy") + "</b>";
                    }
                    else
                    {
                        txtAnQuocHoi.Text = "X";
                    }
                }
                if (ddlKetquaThuLy.SelectedValue == "10")
                {
                    txtSoNgayThuLy.Text = "Hồ sơ kháng nghị VKS";
                }
                else
                {
                    txtSoNgayThuLy.Text = (rv["LisThuLyDon"] + "").Replace(";", ", <br/>");
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
                        if (loaian != Convert.ToInt16(ENUM_LOAIVUVIEC.AN_HINHSU))
                            Response.Redirect("Thongtinvuan.aspx?ID=" + vuanid);
                        else
                            Response.Redirect("ThongtinvuanHS.aspx?ID=" + vuanid);
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
                //case "QLHS":
                //    string StrQLHS = "PopupReport('/QLAN/GDTTT/VuAn/Popup/QLHoso.aspx?vid=" + e.CommandArgument + "','Quản lý mượn trả hồ sơ',1000,600);";
                //    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrQLHS, true);
                //    break;
                //case "TOTRINH":
                //    string StrTotrinh = "PopupReport('/QLAN/GDTTT/VuAn/Popup/QLTotrinh.aspx?vid=" + e.CommandArgument + "','Quản lý tờ trình',1000,700);";
                //    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrTotrinh, true);
                //    break;
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
        protected void dgListDon_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    Literal txtSTT = (Literal)e.Item.FindControl("txtSTT");
                    Literal txtSoNgayThuLy = (Literal)e.Item.FindControl("txtSoNgayThuLy");
                    Literal txtThongTinBanAn = (Literal)e.Item.FindControl("txtThongTinBanAn");
                    Literal txtQHPL = (Literal)e.Item.FindControl("txtQHPL");
                    Literal txtNguyenDon = (Literal)e.Item.FindControl("txtNguyenDon");
                    Literal txtBiDon = (Literal)e.Item.FindControl("txtBiDon");
                    Literal txtToiDanh = (Literal)e.Item.FindControl("txtToiDanh");
                    Literal txtBCDV = (Literal)e.Item.FindControl("txtBCDV");
                    Literal txtBCK = (Literal)e.Item.FindControl("txtBCK");
                    Literal txtNKK = (Literal)e.Item.FindControl("txtNKK");
                    Literal txtNBK = (Literal)e.Item.FindControl("txtNBK");
                    Literal txtNguoiKhieuNai = (Literal)e.Item.FindControl("txtNguoiKhieuNai");
                    Literal txtAnQuocHoi = (Literal)e.Item.FindControl("txtAnQuocHoi");
                    Literal txtThamPhan = (Literal)e.Item.FindControl("txtThamPhan");
                    Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");// kết quả giải quyết 
                    Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");// thông tin thụ lý XXGDT
                    Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");// kết quả xét xử
                    Literal lttOther = (Literal)e.Item.FindControl("lttOther");// hoãn thi hành án

                    #region MyRegion
                    txtSTT.Text = rv["STT"] + "";
                    if (!String.IsNullOrEmpty(rv["SOTHULY"] + "") || !String.IsNullOrEmpty(rv["NGAYTHULY"] + ""))
                    {
                        txtSoNgayThuLy.Text = rv["SOTHULY"] + "";
                        txtSoNgayThuLy.Text += "<br/>";
                        txtSoNgayThuLy.Text += "<i>" + rv["NGAYTHULY"] + "" + "</i>";
                    }
                    if (ddlKetquaThuLy.SelectedValue == "10")
                    {
                        txtSoNgayThuLy.Text = "Hồ sơ kháng nghị VKS";
                    }
                    txtThongTinBanAn.Text = rv["InforBA"] + "";

                    txtQHPL.Text = rv["QUANHEPL"] + "";
                    txtNguyenDon.Text = rv["NGUYENDON"] + "";
                    txtBiDon.Text = rv["BIDON"] + "";

                    txtToiDanh.Text = rv["QUANHEPL"] + "";
                    txtBCDV.Text = rv["NGUYENDON"] + "";
                    txtBCK.Text = rv["BIDON"] + "";

                    txtNKK.Text = rv["NGUYENDON"] + "";
                    txtNBK.Text = rv["BIDON"] + "";

                    txtNguoiKhieuNai.Text = rv["NGUOIKHIEUNAI"] + "";

                    if (!String.IsNullOrEmpty(rv["THUOCDON"] + ""))
                    {
                        //txtAnQuocHoi.Text = "X";
                        txtAnQuocHoi.Text += !String.IsNullOrEmpty(rv["CV_TENDONVI"] + "") ? "Đơn vị chuyển: " + rv["CV_TENDONVI"].ToString() : "";
                        txtAnQuocHoi.Text += "<br/>";
                        txtAnQuocHoi.Text += !String.IsNullOrEmpty(rv["CV_SO"] + "") ? "Số CV: <b>" + rv["CV_SO"] + "</b>" : "";
                        txtAnQuocHoi.Text += "<br/>";
                        txtAnQuocHoi.Text += !String.IsNullOrEmpty(rv["CV_NGAY"] + "") ? "Ngày: <b>" + rv["CV_NGAY"].ToString() + "</b>" : "";
                    }

                    txtThamPhan.Text = rv["TENTHAMPHAN"] + "";

                    //load thông tin giải quyết đơn
                    #region thông tin giải quyết đơn
                    if (!String.IsNullOrEmpty(rv["KQSO"] + "") || !String.IsNullOrEmpty(rv["KQNGAY"] + ""))
                    {
                        var a = rv["KQLOAI"].ToString();
                        lttKQGQ.Text += !String.IsNullOrEmpty(rv["KQLOAI"] + "") ? "<span style=''>Giải quyết đơn: <b>" +
                                (rv["KQLOAI"].ToString() == "0" ? "Trả lời đơn" :
                                rv["KQLOAI"].ToString() == "1" ? "CA Kháng nghị" :
                                rv["KQLOAI"].ToString() == "2" ? "Xếp đơn" : 
                                rv["KQLOAI"].ToString() == "3" ? "Xử lý khác" :
                                rv["KQLOAI"].ToString() == "4" ? "VKS đang giải quyết" : "") + "</b></span>" : "";
                        //lttKQGQ.Text += "<br/>";
                        //lttKQGQ.Text += !String.IsNullOrEmpty(rv["KQSO"] + "") ? "Số: <b>" + rv["KQSO"] + "</b>" : "";
                        //lttKQGQ.Text += "<br/>";
                        //lttKQGQ.Text += !String.IsNullOrEmpty(rv["KQNGAY"] + "") ? "Ngày: <b>" + rv["KQNGAY"].ToString() + "</b>" : "";
                    }
                    #endregion

                    #region thông tin thụ lý XXGDT
                    //if (!String.IsNullOrEmpty(rv["SOTHULYXX"] + "") || !String.IsNullOrEmpty(rv["NGAYTHULYXX"] + ""))
                    //{
                    //    lttDetaiTinhTrang.Text += "<span class='line_space'>";
                    //    //lttDetaiTinhTrang.Text += "<span style='float:left;width:100%;'>Thông tin thụ lý XXGDT</span>";
                    //    //--------------------------                
                    //    lttDetaiTinhTrang.Text += !String.IsNullOrEmpty(rv["SOTHULYXX"] + "") ? "Số thụ lý XX: <b>" + rv["SOTHULYXX"].ToString() + "</b>" : "";
                    //    lttDetaiTinhTrang.Text += "<br/>";
                    //    lttDetaiTinhTrang.Text += !String.IsNullOrEmpty(rv["NGAYTHULYXX"] + "") ? "Ngày thụ lý XX: <b>" + rv["NGAYTHULYXX"].ToString() + "</b>" : "";
                    //    //-------------------------------
                    //    lttDetaiTinhTrang.Text += "</span>";
                    //}
                    #endregion

                    #region kết quả xét xử
                    //if (!String.IsNullOrEmpty(rv["SOQDXX"] + "") || !String.IsNullOrEmpty(rv["NGAYQDXX"] + ""))
                    //{
                    //    lttLanTT.Text += "<span class='line_space'>";
                    //    lttLanTT.Text += "<span style='float:left;width:100%;'>Kết quả XX</span>";
                    //    //--------------------------   
                    //    String temp = !String.IsNullOrEmpty(rv["SOQDXX"] + "") ? "Số QĐXX: <b>" + rv["SOQDXX"].ToString() + "</b>" : "";
                    //    temp += "<br/>";
                    //    temp += !String.IsNullOrEmpty(rv["NGAYQDXX"] + "") ? "Ngày QĐXX: <b>" + rv["NGAYQDXX"].ToString() + "</b>" : "";
                    //    lttLanTT.Text += temp;
                    //    //-------------------------------
                    //    lttLanTT.Text += "</span>";
                    //}
                    #endregion

                    #endregion

                    if (string.IsNullOrEmpty(lttLanTT.Text) && string.IsNullOrEmpty(lttDetaiTinhTrang.Text) && string.IsNullOrEmpty(lttKQGQ.Text))
                    {
                        if (rv["KQLOAI"].ToString() == "0")
                        {
                            lttOther.Text = "Giải quyết đơn: Trả lời đơn";
                        }
                        else if (rv["KQLOAI"].ToString() == "1")
                        {
                            lttOther.Text = "Giải quyết đơn: Kháng nghị";
                        }
                        else if (rv["KQLOAI"].ToString() == "2")
                        {
                            lttOther.Text = "Giải quyết đơn: Xếp đơn";
                        }
                        //else if (rv["KQLOAI"].ToString() == "3")
                        //{
                        //    lttOther.Text = "Xử lý khác";
                        //}
                        //else if (rv["KQLOAI"].ToString() == "4")
                        //{
                        //    lttOther.Text = "VKS kháng nghị";
                        //}
                        else
                        {
                            lttOther.Text = "Giải quyết đơn: Đang giải quyết";
                        }
                    }

                    if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
                    {
                        lblTitleBD.Text = "Bị cáo";
                        lblTitleBC.Visible = txtNguyendon.Visible = false;

                        dgList.Columns[4].Visible = false;
                        dgList.Columns[5].Visible = false;
                        dgList.Columns[6].Visible = false;

                        dgList.Columns[7].Visible = true;
                        dgList.Columns[8].Visible = true;
                        dgList.Columns[9].Visible = true;
                    }
                    else
                    {
                        lblTitleBD.Text = "Bị đơn";
                        lblTitleBC.Visible = txtNguyendon.Visible = true;

                        dgList.Columns[4].Visible = true;
                        dgList.Columns[5].Visible = true;
                        dgList.Columns[6].Visible = true;

                        dgList.Columns[7].Visible = false;
                        dgList.Columns[8].Visible = false;
                        dgList.Columns[9].Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = "dgList_ItemDataBound: " + ex.ToString();
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

            ddlKetquaThuLy.SelectedValue="3";
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
        protected void cmdPrint_Click_Older(object sender, EventArgs e)
        {
            String SessionName = "GDTTT_ReportPL".ToUpper();
            //--------------------------
            String ReportName = "";
            if (String.IsNullOrEmpty(txtTieuDeBC.Text))
                SetTieuDeBaoCao();
            ReportName = txtTieuDeBC.Text.Trim();
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();
            String Parameter = "type=va&rID=" + dropMauBC.SelectedValue;
            DataTable tbl = SearchNoPaging();
            Session[SessionName] = tbl;
            string URL = "/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx" + (string.IsNullOrEmpty(Parameter) ? "" : "?" + Parameter);
            Cls_Comon.CallFunctionJS(this, this.GetType(), "PopupReport('" + URL + "','In báo cáo',1000,600)");
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


                DataTable tbl = null;
                tbl = oBL.VUAN_SEARCH_PRINT(chk_conlai_s,Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "", vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
                   , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
                   , vQHPLID, vQHPLDNID, vTraloidon, vLoaiCVID, vNgayThulyTu, vNgayThulyDen, vSoThuly
                   , vTrangthai, vKetquathuly, vKetquaxetxu
                   , isMuonHoSo, isTotrinh, isYKienKLToTrinh, isBuocTT, LoaiAnDB, LoaiAnDB_TH, isHoanTHA
                   , typetb, is_dangkybaocao, captrinhtiep_id, type_hoidong_tp, _ISXINANGIAM, _GDT_ISXINANGIAM, _SodonTLM, _LoaiGDT
                   , vQHPL_TD, _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den
                   , 0, 0);
                
                //-----------------------------------------
                Literal Table_Str_Totals = new Literal();
                DataRow row = tbl.NewRow();
                //-----------
                if (vToaAnID == 1)
                {
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        row = tbl.Rows[0];
                        Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                    }
                    //--------------------------
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_GDTTT.doc");
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
                }else
                {
                    //String INSERT_PAGE_BREAK = "";
                    //-----------
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        row = tbl.Rows[0];
                        Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                        //INSERT_PAGE_BREAK = row["INSERT_PAGE_BREAK"] + "";
                    }
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

            }
            catch (Exception ex) {
                lbtthongbao.Text = ex.Message;
            }
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
            //if (Convert.ToDecimal(ddlTrangthaithuly.SelectedValue) > 3)
            //{
            SetTieuDeBaoCao();
            dropCapTrinhTiepTheo.Enabled = dropDangKyBC.Enabled = false;

            decimal tt = Convert.ToDecimal(ddlTrangthaithuly.SelectedValue);
            if (tt != 0 && tt!=-1)
            {
                GDTTT_DM_TINHTRANG objTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == tt).Single();
                if (objTT.GIAIDOAN == 2)
                {
                    lttYKienKetLuan.Visible = dropIsYKienKetLuatTrinhLD.Visible = true;
                    lttBuocTT.Visible = dropBuocTT.Visible = true;
                    dropDangKyBC.Enabled = true;
                }
                else
                {
                    dropIsYKienKetLuatTrinhLD.Visible = lttYKienKetLuan.Visible = true;
                    dropIsYKienKetLuatTrinhLD.SelectedValue = "2";

                    lttBuocTT.Visible = dropBuocTT.Visible = true;
                    dropBuocTT.SelectedValue = "0";

                    dropDangKyBC.Enabled = true;
                    dropDangKyBC.SelectedValue = "2";

                    dropCapTrinhTiepTheo.SelectedValue = "0";
                    dropCapTrinhTiepTheo.Enabled = true;
                }
            }
            //-------------------------
            if (tt <= ENUM_GDTTT_TRANGTHAI.NGHIENCUU_HOSO)
                ddlKetquaThuLy.SelectedValue = "4";
            else if (tt == ENUM_GDTTT_TRANGTHAI.NGHIENCUU_HOSO)
            {
                ddlMuonHoso.SelectedValue = "1";
                ddlTotrinh.SelectedValue = "0";
            }
            else if (tt >= ENUM_GDTTT_TRANGTHAI.TRINH_PHOVT)
                dropCapTrinhTiepTheo.Enabled = true;
            else if (tt >= ENUM_GDTTT_TRANGTHAI.TRINH_THAMPHAN)
                dropDangKyBC.Enabled = true;
            //}
            //else
            //{
            //    dropIsYKienKetLuatTrinhLD.Visible = lttYKienKetLuan.Visible = false;
            //    lttBuocTT.Visible = dropBuocTT.Visible = false;
            //    dropBuocTT.SelectedValue = "0";
            //    dropIsYKienKetLuatTrinhLD.SelectedValue = dropDangKyBC.SelectedValue = "2";
            //    dropCapTrinhTiepTheo.SelectedValue = dropBuocTT.SelectedValue = "0";
            //    dropCapTrinhTiepTheo.Enabled = dropDangKyBC.Enabled = false;
            //}
        }
        protected void ddlLoaiCV_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiCV.SelectedValue != "0")
                SetTieuDeBaoCao();
            //-------------------------------------
            decimal cv_quochoi = 1023;
            decimal loaicv = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.ID == cv_quochoi
                                                            || x.ARRSAPXEP.Contains(cv_quochoi + "/")).ToList();
            if (lst != null && lst.Count > 0)
            {
                Cls_Comon.SetValueComboBox(dropMauBC, "5");
            }
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
            SetTieuDeBaoCao();
            if (dropAnDB.SelectedValue == "1")
                dropTypeTB.Enabled = true;
            else
            {
                Cls_Comon.SetValueComboBox(dropTypeTB, 0);
                dropTypeTB.Enabled = false;
            }
        }
        protected void ddlKetquaThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
        }
        protected void ddlKetquaXX_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetTieuDeBaoCao();
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
        void Clear_SessionTK()
        {
            Session[SS_BAOCAO_CA.LOAIAN] = 0;
            Session[SS_BAOCAO_CA.THAMPHAN] = "0";
            Session[SS_BAOCAO_CA.TUNGAY] = "";
            Session[SS_BAOCAO_CA.DENNGAY] = "";
            Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = "";

            Session[SS_BAOCAO_CA.VUANIDs] = "";

            Session[SS_BAOCAO_CA.VALUE_TAB] = "";
            Session[SS_BAOCAO_CA.VALUE_TIME] = "";

            Session[SS_BAOCAO_CA.VALUE_ANQUOCHOI] = "";
            Session[SS_BAOCAO_CA.VALUE_ANTHOIHIEU] = "";
        }
        protected void TabClick(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string TabIndex = btn.CommandArgument;
            if (TabIndex == "0")
            {
                Session[SS_BAOCAO_CA.VALUE_TAB] = "ViewTATC";
            }
            else if (TabIndex == "1")
            {
                Session[SS_BAOCAO_CA.VALUE_TAB] = "ViewTPTATC";
            }
            else if (TabIndex == "2")
            {
                Session[SS_BAOCAO_CA.VALUE_TAB] = "ViewTAND";
            }
            Session[SS_BAOCAO_CA.LOAIAN] = ddlLoaiAn.SelectedValue;
            Session[SS_BAOCAO_CA.THAMPHAN] = ddlThamphan.SelectedValue;
            Session[SS_BAOCAO_CA.TUNGAY] = txtThuly_Tu.Text;
            Session[SS_BAOCAO_CA.DENNGAY] = txtThuly_Den.Text;
            Session[SS_BAOCAO_CA.COLUMN_SOLIEU] = ddlKetquaThuLy.SelectedValue;
            Session[SS_BAOCAO_CA.VALUE_ANQUOCHOI] = dropAnDB.SelectedValue;
            Session[SS_BAOCAO_CA.VALUE_ANTHOIHIEU] = dropAnDB_TH.SelectedValue;
            //Response.Redirect("~/TrangChu.aspx");
            Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/BAOCAOCA/Trangchu.aspx");
        }
        void SetTieuDeBaoCao()
        {
            string tieudebc = "";

            //-------------------------------------
            if (ddlLoaiAn.SelectedValue != "0")
                tieudebc += " " + ddlLoaiAn.SelectedItem.Text.ToLower();
            if (dropAnDB.SelectedValue != "0")
                tieudebc += " là " + dropAnDB.SelectedItem.Text.ToLower();
            //-------------------------------------
            if (ddlLoaiCV.SelectedValue != "0" && ddlLoaiCV.SelectedValue != "-1")
                tieudebc += " có " + ddlLoaiCV.SelectedItem.Text.ToLower();
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

            if (ddlKetquaThuLy.SelectedValue != "3")
            {
                int kq = Convert.ToInt32(ddlKetquaThuLy.SelectedValue);
                if (kq < 3)
                    tieudebc += " có kết quả thụ lý là";
                tieudebc += " " + ddlKetquaThuLy.SelectedItem.Text.Replace("...", "").ToLower();
            }

            if (ddlKetquaXX.SelectedValue != "0")
            {
                int xx = Convert.ToInt32(ddlKetquaXX.SelectedValue);
                if (xx > 0)
                    tieudebc += " có kết quả xét xử là";
                tieudebc += " " + ddlKetquaXX.SelectedItem.Text.Replace("...", "").ToLower();
            }

            //-----------------------------
            txtTieuDeBC.Text = "Danh sách các vụ án" + tieudebc.Replace("...", "");
        }
    }
}
