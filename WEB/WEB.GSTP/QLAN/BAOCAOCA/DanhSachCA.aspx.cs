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
using BL.GSTP.QLAN;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.BAOCAOCA
{
    public partial class DanhSachCA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        Decimal PhongBanID = 0, CurrDonViID;
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
                lbtthongbao.Text = "GetBool: " + ex.ToString();
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
                lbtthongbao.Text = "GetDate:" + ex.ToString();
                return "";
            }
        }
        String SessionSearch = "TTTKVISIBLE";
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
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
                    //---------------------------
                    LoadDropBox();
                    var checkMH = SetGetSessionTK(false);
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
                    int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                    if (IsHome == 1)
                    {
                        //khi chọn từ màn hình login
                        Load_Data();
                    }
                    else
                    {
                        if (checkMH == true)
                        {
                            Load_Data();
                        }
                    }
                    Session[SS_TK.ISHOME] = "0";//khi load xong thi hủy trạng thái xác định chọn tu login
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        private bool SetGetSessionTK(bool isSet)
        {
            try
            {
                var bools = false;
                if (!isSet)
                {
                    pnTTTK.Visible = true;
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
                    bools = true;
                }
                return bools;
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = "SetGetSessionTK: " + ex.ToString();
                return false;
            }
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
            catch (Exception ex) { lbtthongbao.Text = "LoadDropBox: " + ex.ToString(); }
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
            catch (Exception ex) { lbtthongbao.Text = "LoadDropBox: " + ex.ToString(); }

            //Trình trạng thụ lý
            LoadDrop_TinhTrangThuLy();

            //-------------------------------           
            LoadDRopKetQuaXX_GDTTT();
            LoadDropKQThuLyDon();
        }
        void LoadDropKQThuLyDon()
        {
            ddlKetquaThuLy.Items.Clear();
            ddlKetquaThuLy.Items.Add(new ListItem("--Tất cả--", "2"));
            ddlKetquaThuLy.Items.Add(new ListItem("Đã giải quyết", "3"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Trả lời đơn", "4"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Kháng nghị", "5"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Xếp đơn", "6"));
            ddlKetquaThuLy.Items.Add(new ListItem("Chưa giải quyết", "7"));
            ddlKetquaThuLy.Items.Add(new ListItem("Đã thụ lý XXGĐT", "8"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Kháng nghị CA", "9"));
            ddlKetquaThuLy.Items.Add(new ListItem("...Kháng nghị VKS", "10"));
            ddlKetquaThuLy.Items.Add(new ListItem("Đã xét xử", "11"));
            ddlKetquaThuLy.Items.Add(new ListItem("Chưa xét xử", "12"));
        }
        void LoadDrop_TinhTrangThuLy()
        {
            decimal[] kq = { 13, 14, 16, 18 };
            List<GDTTT_DM_TINHTRANG> lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1 && !kq.Contains(x.ID)).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
            SetName_Vu_Phongban(lst);

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
            {
                int count_lst = lst.Count;
            }

            lst = dt.GDTTT_DM_TINHTRANG.Where(x => x.HIEULUC == 1
                                                && x.ID >= 6 && x.ID != 10).OrderBy(y => y.GIAIDOAN).OrderBy(x => x.THUTU).ToList();
            SetName_Vu_Phongban(lst);
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
                    hddLoaiTK.Value = ENUM_CHUCVU.CHUCVU_PVT;
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
            }
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
                        {
                            LoadLoaiAnPhuTrach(oCB);
                        }
                    }
                    else
                        IsLoadAll = true;
                    if (IsLoadAll) LoadAllLoaiAn();
                }
                else
                {
                    if (obj != null && obj.ISHINHSU == 1)
                    {
                        ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                        lblTitleBC.Text = "Bị cáo";
                        lblTitleBD.Visible = txtBidon.Visible = false;
                    }
                    //LoadLoaiAnPhuTrach_TheoPB(obj);
                    LoadAllLoaiAn();
                }
            }

            if (ddlLoaiAn.Items.Count > 1)
            {
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
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
        }
        void LoadLoaiAnPhuTrach_TheoPB(DM_PHONGBAN obj)
        {
            if (obj != null)
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

            // Lấy dữ liệu để đổ vào dgList
            DataTable oDT = getDS(page_size, pageindex);
            //-------------------------------
            int count_all = 0;

            if (oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            }

            if (oDT != null && count_all > 0)
            {
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

            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                lblTitleBD.Text = "Bị cáo";
                lblTitleBC.Visible = txtNguyendon.Visible = false;
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                // Ẩn cột "NGUYENDON"
                dgList.Columns[4].HeaderText = "Tội danh";
                dgList.Columns[5].HeaderText = "Bị cáo đầu vụ";
                dgList.Columns[6].HeaderText = "Bị cáo khác";
                // Thay tên cột "BIDON"               
            }
            else
            {
                lblTitleBD.Text = "Bị đơn";
                lblTitleBC.Visible = txtNguyendon.Visible = true;
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
                dgList.Columns[4].HeaderText = "Quan hệ pháp luật";
                dgList.Columns[5].HeaderText = "Nguyên đơn/ Người khởi kiện";
                dgList.Columns[6].HeaderText = "Bị đơn/ Người bị kiện";
            }
        }
        private DataTable getDS(int page_size, int pageindex)
        {
            decimal vToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vPhongbanID = 0;
            DASHBOARD_GDT_BL oBL = new DASHBOARD_GDT_BL();
            decimal vToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue);
            string vSoBAQD = txtSoQDBA.Text.Trim(), vNgayBAQD = txtNgayBAQD.Text;

            string vNguyendon = txtNguyendon.Text;
            string vBidon = txtBidon.Text;
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vThamphan = Convert.ToDecimal(ddlThamphan.SelectedValue);
            decimal vQHPLID = 0;
            decimal vQHPLDNID = 0;
            string vCoquanchuyendon = "";
            string vNguoiGui = txtNguoiguidon.Text.Trim();

            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoThuly = txtThuly_So.Text;
            decimal vKetquathuly = Convert.ToDecimal(ddlKetquaThuLy.SelectedValue);
            decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);

            int isYKienKLToTrinh = Convert.ToInt16(dropIsYKienKetLuatTrinhLD.SelectedValue);
            int LoaiAnDB = Convert.ToInt16(dropAnDB.SelectedValue);
            String LoaiAnDB_TH = dropAnDB_TH.SelectedValue;

            if (hddLoaiTK.Value == ENUM_CHUCDANH.CHUCDANH_THAMPHAN)
                vPhongbanID = 0;
            //anhvh phân quyên liên quan đến án tử hình
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal _ISXINANGIAM = Convert.ToDecimal(oPer.ISXINANGIAM);
            decimal _GDT_ISXINANGIAM = Convert.ToDecimal(oPer.GDT_ISXINANGIAM);
            //--------------
            decimal _loaingaysearch = Convert.ToDecimal(dropLoaiNgaySer.SelectedValue);
            DateTime? vNgaySearch_Tu = txtNgayBA_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Tu.Text + " 00:00:00", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgaySearch_Den = txtNgayBA_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayBA_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            //-----------------------------
            DataTable tbl = null;
            tbl = oBL.MHCA_DANHSACH_SEARCH(Session[ENUM_SESSION.SESSION_USERID] + "", Session["V_COLUME"] + "", Session["V_ASC_DESC"] + "",
                vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD, vNguoiGui
               , vCoquanchuyendon, vNguyendon, vBidon, vLoaiAn, vThamphan
               , vQHPLID, vQHPLDNID, vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vKetquathuly, vKetquaxetxu, isYKienKLToTrinh, LoaiAnDB, LoaiAnDB_TH
               , _ISXINANGIAM, _GDT_ISXINANGIAM
               , _loaingaysearch, vNgaySearch_Tu, vNgaySearch_Den, pageindex, page_size);
            return tbl;
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            //SetGetSessionTK(true);
        }
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            //SetGetSessionTK(true);
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC.AN_HINHSU)
            {
                CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
                String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
                Response.Redirect("ThongtinvuanHS.aspx?type=new");
            }
            else
                Response.Redirect("Thongtinvuan.aspx?type=new");
        }
        protected void lbBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/TrangChu.aspx");
        }
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
                    Literal txtNguoiKhieuNai = (Literal)e.Item.FindControl("txtNguoiKhieuNai");
                    Literal txtAnQuocHoi = (Literal)e.Item.FindControl("txtAnQuocHoi");
                    Literal txtThamPhan = (Literal)e.Item.FindControl("txtThamPhan");
                    Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");// kết quả giải quyết 
                    Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");// thông tin thụ lý XXGDT
                    Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");// kết quả xét xử
                    Literal lttOther = (Literal)e.Item.FindControl("lttOther");// hoãn thi hành án

                    if (Convert.ToDecimal(ddlKetquaThuLy.SelectedValue) > 7)
                    {
                        txtSTT.Text = rv["STT"] + "";
                        string SoNgayThuLys = rv["SONGAYTHULY"] + "";
                        if (!string.IsNullOrEmpty(SoNgayThuLys))
                        {
                            var lstSoNgayThuLy = SoNgayThuLys.Split('|').ToList();
                            if (lstSoNgayThuLy.Count > 0)
                            {
                                for (int i = 0; i < lstSoNgayThuLy.Count; i++)
                                {
                                    if (i == 0)
                                    {
                                        txtSoNgayThuLy.Text += lstSoNgayThuLy[i];
                                    }
                                    else
                                    {
                                        txtSoNgayThuLy.Text += "<span class='line_space'>";
                                        txtSoNgayThuLy.Text += lstSoNgayThuLy[i];
                                        txtSoNgayThuLy.Text += "</span>";
                                    }
                                }
                            }
                        }

                        if (!String.IsNullOrEmpty(rv["SOBA"] + "") || !String.IsNullOrEmpty(rv["NGAYBA"] + ""))
                        {
                            txtThongTinBanAn.Text = rv["SOBA"] + "";
                            txtThongTinBanAn.Text += "<br/>";
                            txtThongTinBanAn.Text += rv["NGAYBA"] + "";
                            txtThongTinBanAn.Text += "<br/>";
                            txtThongTinBanAn.Text += rv["TenToaVT"] + "";
                        }

                        txtQHPL.Text = rv["QUANHEPL"] + "";
                        txtNguyenDon.Text = rv["NGUYENDON"] + "";
                        txtBiDon.Text = rv["BIDON"] + "";

                        txtToiDanh.Text = rv["QUANHEPL"] + "";
                        txtBCDV.Text = rv["NGUYENDON"] + "";
                        txtBCK.Text = rv["BIDON"] + "";

                        var NGUOIKHIEUNAI = rv["NGUOIKHIEUNAI"] + "";
                        if (!string.IsNullOrEmpty(NGUOIKHIEUNAI))
                        {
                            var lstNGUOIKHIEUNAI = NGUOIKHIEUNAI.Split('|').ToArray();
                            if (lstNGUOIKHIEUNAI.Length > 0)
                            {
                                for (int i = 0; i < lstNGUOIKHIEUNAI.Length; i++)
                                {
                                    if (i == 0)
                                    {
                                        txtNguoiKhieuNai.Text += lstNGUOIKHIEUNAI[i];
                                    }
                                    else
                                    {
                                        txtNguoiKhieuNai.Text += ", " + lstNGUOIKHIEUNAI[i];
                                    }
                                }
                            }
                        }


                        var THUOCDON = rv["THUOCDON"] + "";
                        if (!string.IsNullOrEmpty(THUOCDON))
                        {
                            //var lstTHUOCDON = THUOCDON.Split('|').ToArray();
                            //if (lstTHUOCDON.Count() > 0)
                            //{
                            //    txtAnQuocHoi.Text = "X";
                            //}
                            var SONGAYAQH = rv["SONGAYAQH"] + "";
                            if (!string.IsNullOrEmpty(SONGAYAQH))
                            {
                                var lstSONGAYAQH = SONGAYAQH.Split('|').ToArray();
                                if (lstSONGAYAQH.Count() > 0)
                                {
                                    for (int i = 0; i < lstSONGAYAQH.Length; i++)
                                    {
                                        if (i == 0)
                                        {
                                            txtAnQuocHoi.Text = lstSONGAYAQH[i];
                                            txtAnQuocHoi.Text += "<br/>";
                                        }
                                        else
                                        {
                                            txtAnQuocHoi.Text += "<span class='line_space'>";
                                            txtAnQuocHoi.Text += lstSONGAYAQH[i];
                                            txtAnQuocHoi.Text += "</span>";
                                            txtAnQuocHoi.Text += "<br/>";
                                        }
                                    }
                                }
                            }
                        }

                        var TENTHAMPHAN = rv["TENTHAMPHAN"] + "";
                        if (!string.IsNullOrEmpty(TENTHAMPHAN))
                        {
                            var lstTENTHAMPHAN = TENTHAMPHAN.Split('|').ToArray();
                            if (lstTENTHAMPHAN.Count() > 0)
                            {
                                for (int i = 0; i < lstTENTHAMPHAN.Distinct().Count(); i++)
                                {
                                    if (i == 0)
                                    {
                                        txtThamPhan.Text += lstTENTHAMPHAN[i];
                                    }
                                    else
                                    {
                                        txtThamPhan.Text += ", " + lstTENTHAMPHAN[i];
                                    }
                                }
                            }
                        }

                        //load thông tin giải quyết đơn
                        #region thông tin giải quyết đơn
                        var KQGQ = rv["SONGAYKQGQ"] + "";
                        var lstKQGQ = KQGQ.Split('|').Distinct().ToArray();
                        if (lstKQGQ.Length > 0)
                        {
                            for (int i = 0; i < lstKQGQ.Length; i++)
                            {
                                if (i == 0)
                                {
                                    //lttKQGQ.Text += "<span class='line_space'>";
                                    lttKQGQ.Text += lstKQGQ[i];
                                    //lttKQGQ.Text += "</span>";
                                    lttKQGQ.Text += "<br/>";
                                }
                                else
                                {
                                    lttKQGQ.Text += "<span class='line_space'>";
                                    lttKQGQ.Text += lstKQGQ[i];
                                    lttKQGQ.Text += "</span>";
                                    lttKQGQ.Text += "<br/>";
                                }
                            }
                        }
                        #endregion

                        #region thông tin thụ lý XXGDT
                        if (!String.IsNullOrEmpty(rv["SOTHULYXX"] + "") || !String.IsNullOrEmpty(rv["NGAYTHULYXX"] + ""))
                        {
                            lttDetaiTinhTrang.Text += "<span class='line_space'>";
                            //lttDetaiTinhTrang.Text += "<span style='float:left;width:100%;'>Thông tin thụ lý XXGDT</span>";
                            //--------------------------                
                            lttDetaiTinhTrang.Text += !String.IsNullOrEmpty(rv["SOTHULYXX"] + "") ? "Số thụ lý XX: <b>" + rv["SOTHULYXX"].ToString() + "</b>" : "";
                            lttDetaiTinhTrang.Text += "<br/>";
                            lttDetaiTinhTrang.Text += !String.IsNullOrEmpty(rv["NGAYTHULYXX"] + "") ? "Ngày thụ lý XX: <b>" + rv["NGAYTHULYXX"].ToString() + "</b>" : "";
                            //-------------------------------
                            lttDetaiTinhTrang.Text += "</span>";
                        }
                        #endregion

                        #region kết quả xét xử
                        if (!String.IsNullOrEmpty(rv["SOQDXX"] + "") || !String.IsNullOrEmpty(rv["NGAYQDXX"] + ""))
                        {
                            lttLanTT.Text += "<span class='line_space'>";
                            lttLanTT.Text += "<span style='float:left;width:100%;'>Kết quả XX</span>";
                            //--------------------------   
                            String temp = !String.IsNullOrEmpty(rv["SOQDXX"] + "") ? "Số QĐXX: <b>" + rv["SOQDXX"].ToString() + "</b>" : "";
                            temp += "<br/>";
                            temp += !String.IsNullOrEmpty(rv["NGAYQDXX"] + "") ? "Ngày QĐXX: <b>" + rv["NGAYQDXX"].ToString() + "</b>" : "";
                            lttLanTT.Text += temp;
                            //-------------------------------
                            lttLanTT.Text += "</span>";
                        }
                        #endregion

                    }
                    else
                    {
                        txtSTT.Text = rv["STT"] + "";
                        if (!String.IsNullOrEmpty(rv["SOTHULY"] + "") || !String.IsNullOrEmpty(rv["NGAYTHULY"] + ""))
                        {
                            txtSoNgayThuLy.Text = rv["SOTHULY"] + "";
                            txtSoNgayThuLy.Text += "<br/>";
                            txtSoNgayThuLy.Text += "<i>" + rv["NGAYTHULY"] + "" + "</i>";

                        }
                        txtThongTinBanAn.Text = rv["InforBA"] + "";

                        txtQHPL.Text = rv["QUANHEPL"] + "";
                        txtNguyenDon.Text = rv["NGUYENDON"] + "";
                        txtBiDon.Text = rv["BIDON"] + "";

                        txtToiDanh.Text = rv["QUANHEPL"] + "";
                        txtBCDV.Text = rv["NGUYENDON"] + "";
                        txtBCK.Text = rv["BIDON"] + "";

                        txtNguoiKhieuNai.Text = rv["NGUOIKHIEUNAI"] + "";

                        if (!String.IsNullOrEmpty(rv["THUOCDON"] + ""))
                        {
                            //txtAnQuocHoi.Text = "X";
                            txtAnQuocHoi.Text += !String.IsNullOrEmpty(rv["CV_SO"] + "") ? "Số: <b>" + rv["CV_SO"] + "</b>" : "";
                            txtAnQuocHoi.Text += "<br/>";
                            txtAnQuocHoi.Text += !String.IsNullOrEmpty(rv["CV_NGAY"] + "") ? "Ngày: <b>" + rv["CV_NGAY"].ToString() + "</b>" : "";
                            txtAnQuocHoi.Text += "<br/>";
                            txtAnQuocHoi.Text += !String.IsNullOrEmpty(rv["CV_TENDONVI"] + "") ? "Đơn vị: " + rv["CV_TENDONVI"].ToString() : "";
                        }

                        txtThamPhan.Text = rv["TENTHAMPHAN"] + "";

                        //load thông tin giải quyết đơn
                        #region thông tin giải quyết đơn
                        if (!String.IsNullOrEmpty(rv["KQSO"] + "") || !String.IsNullOrEmpty(rv["KQNGAY"] + ""))
                        {
                            lttKQGQ.Text += !String.IsNullOrEmpty(rv["KQLOAI"] + "") ? "<span style=''>KQ: <b>" +
                                    (rv["KQLOAI"].ToString() == "0" ? "Trả lời đơn" :
                                    rv["KQLOAI"].ToString() == "1" ? "CA Kháng nghị" :
                                    rv["KQLOAI"].ToString() == "2" ? "Xếp đơn" : "") + "</b></span>" : "";
                            lttKQGQ.Text += "<br/>";
                            lttKQGQ.Text += !String.IsNullOrEmpty(rv["KQSO"] + "") ? "Số: <b>" + rv["KQSO"] + "</b>" : "";
                            lttKQGQ.Text += "<br/>";
                            lttKQGQ.Text += !String.IsNullOrEmpty(rv["KQNGAY"] + "") ? "Ngày: <b>" + rv["KQNGAY"].ToString() + "</b>" : "";
                        }
                        #endregion

                        #region thông tin thụ lý XXGDT
                        if (!String.IsNullOrEmpty(rv["SOTHULYXX"] + "") || !String.IsNullOrEmpty(rv["NGAYTHULYXX"] + ""))
                        {
                            lttDetaiTinhTrang.Text += "<span class='line_space'>";
                            //lttDetaiTinhTrang.Text += "<span style='float:left;width:100%;'>Thông tin thụ lý XXGDT</span>";
                            //--------------------------                
                            lttDetaiTinhTrang.Text += !String.IsNullOrEmpty(rv["SOTHULYXX"] + "") ? "Số thụ lý XX: <b>" + rv["SOTHULYXX"].ToString() + "</b>" : "";
                            lttDetaiTinhTrang.Text += "<br/>";
                            lttDetaiTinhTrang.Text += !String.IsNullOrEmpty(rv["NGAYTHULYXX"] + "") ? "Ngày thụ lý XX: <b>" + rv["NGAYTHULYXX"].ToString() + "</b>" : "";
                            //-------------------------------
                            lttDetaiTinhTrang.Text += "</span>";
                        }
                        #endregion

                        #region kết quả xét xử
                        if (!String.IsNullOrEmpty(rv["SOQDXX"] + "") || !String.IsNullOrEmpty(rv["NGAYQDXX"] + ""))
                        {
                            lttLanTT.Text += "<span class='line_space'>";
                            lttLanTT.Text += "<span style='float:left;width:100%;'>Kết quả XX</span>";
                            //--------------------------   
                            String temp = !String.IsNullOrEmpty(rv["SOQDXX"] + "") ? "Số QĐXX: <b>" + rv["SOQDXX"].ToString() + "</b>" : "";
                            temp += "<br/>";
                            temp += !String.IsNullOrEmpty(rv["NGAYQDXX"] + "") ? "Ngày QĐXX: <b>" + rv["NGAYQDXX"].ToString() + "</b>" : "";
                            lttLanTT.Text += temp;
                            //-------------------------------
                            lttLanTT.Text += "</span>";
                        }
                        #endregion
                    }

                    if (string.IsNullOrEmpty(lttLanTT.Text) && string.IsNullOrEmpty(lttDetaiTinhTrang.Text) && string.IsNullOrEmpty(lttKQGQ.Text))
                    {
                        if (rv["KQLOAI"].ToString() == "0")
                        {
                            lttOther.Text = "Trả lời đơn";
                        }
                        else if (rv["KQLOAI"].ToString() == "1")
                        {
                            lttOther.Text = "CA kháng nghị";
                        }
                        else if (rv["KQLOAI"].ToString() == "2")
                        {
                            lttOther.Text = "Xếp đơn";
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
                            lttOther.Text = "Đang giải quyết";
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
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal vuanid = 0;
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    //SetGetSessionTK(true);
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
                case "KETQUA":
                    string StrKetqua = "PopupReport('/QLAN/GDTTT/VuAn/Popup/Ketqua.aspx?vid=" + e.CommandArgument + "','Kết quả giải quyết',850,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrKetqua, true);
                    break;
                case "SoDonTrung":
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
            SetGetSessionTK(false);
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
            txtNguyendon.Text = "";
            txtBidon.Text = "";
            ddlLoaiAn.SelectedIndex = 0;

            ddlThamphan.SelectedIndex = 0;

            dropIsYKienKetLuatTrinhLD.SelectedValue = "2";
            dropIsYKienKetLuatTrinhLD.Visible = lttYKienKetLuan.Visible = true;

            txtThuly_Tu.Text = "";
            txtThuly_Den.Text = "";
            txtThuly_So.Text = "";

            txtNguoiguidon.Text = string.Empty;

            ddlKetquaThuLy.SelectedValue = "";
            ddlKetquaXX.SelectedIndex = 0;
            dropAnDB.SelectedIndex = 0;
            dropAnDB_TH.SelectedIndex = 0;
            Session.Remove("V_COLUME");
            Session.Remove("V_ASC_DESC");
            if (Session["V_COLUME"] == null && Session["V_ASC_DESC"] == null)
            {
                Session["V_COLUME"] = "NGAYTHULYDON";
                Session["V_ASC_DESC"] = "DESC";
            }
            txtNgayBA_Tu.Text = txtNgayBA_Den.Text = string.Empty;
        }
        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
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
        protected void ddlMuonHoso_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetTieuDeBaoCao();
        }
        protected void ddlTrangthaithuly_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetTieuDeBaoCao();
        }
        protected void ddlLoaiCV_SelectedIndexChanged(object sender, EventArgs e)
        {
            //-------------------------------------
            decimal cv_quochoi = 1023;
            List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.ID == cv_quochoi
                                                            || x.ARRSAPXEP.Contains(cv_quochoi + "/")).ToList();

        }
        protected void ddlPhoVuTruong_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetTieuDeBaoCao();
        }
        protected void ddlThamphan_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetTieuDeBaoCao();
        }
        protected void dropIsYKienKetLuatTrinhLD_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetTieuDeBaoCao();
        }
        protected void ddlTotrinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetTieuDeBaoCao();
        }
        protected void dropAnDB_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetTieuDeBaoCao();
        }
        protected void ddlKetquaThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetTieuDeBaoCao();
        }
        protected void ddlKetquaXX_SelectedIndexChanged(object sender, EventArgs e)
        {
            //SetTieuDeBaoCao();
        }
    }
}
