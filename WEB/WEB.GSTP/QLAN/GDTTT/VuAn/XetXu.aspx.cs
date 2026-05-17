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
    public partial class XetXu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        Decimal PhongBanID = 0, CurrDonViID = 0;
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
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrint);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            if (!IsPostBack)
            {


                //if ((Session["TTTKVISIBLE"] + "") == "0")
                //{
                //    lbtTTTK.Text = "[ Thu gọn ]";
                //    pnTTTK.Visible = true;
                //}
                LoadDropBox();
                LoadDropInBieuMau();

                SetGetSessionTK(false);
                if (Session[SS_TK.NGUYENDON] != null)
                    Load_Data();
                //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                //Cls_Comon.SetButton(btnThemmoi, oPer.TAOMOI);
            }
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
                    // Session[SS_TK.QHPKLT] = ddlQHPLTK.SelectedValue;
                    // Session[SS_TK.QHPLDN] = ddlQHPLDN.SelectedValue;
                    // Session[SS_TK.TRALOIDON] = ddlTraloi.SelectedValue;
                    // Session[SS_TK.NGUOIGUI] = txtNguoiguidon.Text;
                    // Session[SS_TK.COQUANCHUYENDON] = txtCoquanchuyendon.Text;
                    //  Session[SS_TK.LOAICV] = ddlLoaiCV.SelectedValue;
                    Session[SS_TK.THULY_TU] = txtThuly_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtThuly_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;

                    Session[SS_TK.TRANGTHAIXETXU] = dropTrangThaiXXGDT.SelectedValue;

                    Session[SS_TK.KETQUAXETXU] = ddlKetquaXX.SelectedValue;

                    string vArrSelectID = "";
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        //duongph 22/03/2022
                        //if (chkChon != null && chkChon.Checked)
                        if (chkChon != null && chkChon.Checked)
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
                    //if (Session[SS_TK.TRALOIDON] != null) ddlTraloi.SelectedValue = Session[SS_TK.TRALOIDON] + "";

                    //txtNguoiguidon.Text = Session[SS_TK.NGUOIGUI] + "";
                    //txtCoquanchuyendon.Text = Session[SS_TK.COQUANCHUYENDON] + "";
                    //if (Session[SS_TK.LOAICV] != null) ddlLoaiCV.SelectedValue = Session[SS_TK.LOAICV] + "";

                    txtThuly_Tu.Text = Session[SS_TK.THULY_TU] + "";
                    txtThuly_Den.Text = Session[SS_TK.THULY_DEN] + "";
                    txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";
                    if (Session[SS_TK.TRANGTHAIXETXU] != null) dropTrangThaiXXGDT.SelectedValue = Session[SS_TK.TRANGTHAITHULY] + "";
                    if (Session[SS_TK.KETQUAXETXU] != null) ddlKetquaXX.SelectedValue = Session[SS_TK.KETQUAXETXU] + "";
                }
            }
            catch (Exception ex) { }
        }


        private void LoadDropBox()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA;
            if (Session["CAP_XET_XU"] + "" == "CAPTINH")
                dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(ToaAnID, ToaAnID);
            else
                dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            //Loại án
            ddlLoaiAn.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();

            if (obj != null)
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

                if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
                if (ddlLoaiAn.Items.Count > 1 && obj.ISHINHSU != 1)
                    ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            else
            {
                ddlLoaiAn.Items.AddRange(ClsHelper.GetEnumLoaiAn().ToArray());
                ddlLoaiAn.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }


            try
            {
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
                // Load_AllLanhDao();
                //LoadAll_TTV();
                LoadDropThamphan();

            }
            catch (Exception ex) { }
            //---------------------------------

            LoadDropThamQuyenXX();
            LoadDropKQXX();
            //----Chi dùng cho các tòa án cấp cao-----------------------------
            if (CurrDonViID == 1)
            {
                pnVKS_Nguoiky_lable.Visible = pnVKS_Nguoiky.Visible = false;
            }
            else
            {
                pnVKS_Nguoiky_lable.Visible = pnVKS_Nguoiky.Visible = true;
            }


            LoadDropNGuoiKy_VKS();
        }
        void LoadDropKQXX()
        {
            ddlKetquaXX.Items.Clear();
            DM_DATAITEM_BL oDMBL = new DM_DATAITEM_BL();
            ddlKetquaXX.DataSource = oDMBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.KETLUANGDTTT);
            ddlKetquaXX.DataTextField = "MA_TEN";
            ddlKetquaXX.DataValueField = "ID";
            ddlKetquaXX.DataBind();
            ddlKetquaXX.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
        }
        void LoadDropThamQuyenXX()
        {
            //Thẩm quyền xét xử
            dropThamQuyenXX.Items.Clear();
            if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                dropThamQuyenXX.DataSource = dt.DM_TOAAN.Where(x => (x.LOAITOA == "TOICAO" || x.ID == CurrDonViID) && x.HIEULUC == 1 && x.HANHCHINHID > 0).OrderBy(x => x.ARRTHUTU).ToList();
            }
            else
                dropThamQuyenXX.DataSource = dt.DM_TOAAN.Where(x => (x.LOAITOA == "TOICAO" || x.LOAITOA == "CAPCAO") && x.HIEULUC == 1 && x.HANHCHINHID > 0).OrderBy(x => x.ARRTHUTU).ToList();
            dropThamQuyenXX.DataTextField = "TEN";
            dropThamQuyenXX.DataValueField = "ID";
            dropThamQuyenXX.DataBind();
            dropThamQuyenXX.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

            dropThamQuyenXX.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";

        }
        void LoadDropNGuoiKy_VKS()
        {
            dropVKS_NguoiKy.Items.Clear();
            DM_VKS_BL objBL = new DM_VKS_BL();
            DataTable tbl = objBL.GetAll_VKS_ToiCao_CapCao();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropVKS_NguoiKy.DataSource = tbl;
                dropVKS_NguoiKy.DataTextField = "Ten";
                dropVKS_NguoiKy.DataValueField = "ID";
                dropVKS_NguoiKy.DataBind();
            }
            if (CurrDonViID == 4)
                dropVKS_NguoiKy.Items.Insert(1, new ListItem("Chánh án TACC Hà Nội", "44"));
            else if (CurrDonViID == 5)
                dropVKS_NguoiKy.Items.Insert(1, new ListItem("Chánh án TACC Đà Nẵng", "55"));
            else if (CurrDonViID == 6)
                dropVKS_NguoiKy.Items.Insert(1, new ListItem("Chánh án TACC Hồ Chí Minh", "66"));

            dropVKS_NguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
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

            //DataTable oTLDDT = oGDTBL.CANBO_GETBYDONVI_2CHUCVU(LoginDonViID, PBID, ENUM_CHUCVU.CHUCVU_PVT, ENUM_CHUCVU.CHUCVU_VT);
            DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, "LDV");
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

            //Thẩm tra viên
            DataTable tblTheoPB = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_TTV);
            ddlThamtravien.DataSource = tblTheoPB;
            ddlThamtravien.DataTextField = "HOTEN";
            ddlThamtravien.DataValueField = "ID";
            ddlThamtravien.DataBind();
            ddlThamtravien.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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
                    if (oCD.MA == "TPTATC")
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
                DataTable tbl = oGDTBL.GDTTT_VuAn_GetAllCBTheoPB(LoginDonViID, PBID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
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
            decimal vTrangthai = Convert.ToDecimal(dropTrangThaiXXGDT.SelectedValue);

            decimal vKetquaxetxu = Convert.ToDecimal(ddlKetquaXX.SelectedValue);
            int thamquyenxx = Convert.ToInt16(dropThamQuyenXX.SelectedValue);
            DateTime? vNgayXX_TuNgay = txtNgayXX_TuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayXX_TuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayXX_DenNgay = txtNgayXX_DenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayXX_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string vSoKN = (string.IsNullOrEmpty(txtSoKN.Text + "")) ? "0" : txtSoKN.Text;
            DateTime? vNgayKN = txtNgayKN.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayKN.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            decimal vVIENTRUONGKN_NGUOIKY = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);
            decimal vQUAHAN_LUATDINH = Convert.ToDecimal(dropQuahan.SelectedValue);
            decimal vApdung_AnLe = Convert.ToDecimal(dropApdungAL.SelectedValue);

            /*DataTable oDT = oBL.VUAN_XETXU_SEARCH(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
               , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
               , vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vTrangthai, vKetquaxetxu, thamquyenxx
               , vNgayXX_TuNgay, vNgayXX_DenNgay,vSoKN, vNgayKN, vVIENTRUONGKN_NGUOIKY
               , pageindex, page_size);*/
            //duongph 21/03/2022
            decimal _LoaiGDT = Convert.ToDecimal(ddlLoaiGDT.SelectedValue);
            DataTable oDT = oBL.VUAN_XETXU_SEARCH(vToaAnID, vPhongbanID, vToaRaBAQD, vSoBAQD, vNgayBAQD
               , vNguyendon, vBidon, vLoaiAn, vThamtravien, vLanhdao, vThamphan
               , vNgayThulyTu, vNgayThulyDen, vSoThuly
               , vTrangthai, vKetquaxetxu, thamquyenxx
               , vNgayXX_TuNgay, vNgayXX_DenNgay, vSoKN, vNgayKN, vVIENTRUONGKN_NGUOIKY, _LoaiGDT, vQUAHAN_LUATDINH, vApdung_AnLe
               , pageindex, page_size);

            return oDT;
        }
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
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            SetGetSessionTK(true);
            Load_Data();
        }
        //protected void btnThemmoi_Click(object sender, EventArgs e)
        //{
        //    SetGetSessionTK(true);
        //    Response.Redirect("VAChuyenVKS.aspx");  
        //}
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                DataRowView rv = (DataRowView)e.Item.DataItem;
                Decimal CurrVuAnID = Convert.ToDecimal(rv["ID"] + "");

                Literal lttLanTT = (Literal)e.Item.FindControl("lttLanTT");
                Literal lttDetaiTinhTrang = (Literal)e.Item.FindControl("lttDetaiTinhTrang");

                int trangthai = String.IsNullOrEmpty(rv["TRANGTHAIID"] + "") ? 0 : Convert.ToInt32(rv["TRANGTHAIID"] + "");
                int VIENTRUONGKN_NGUOIKY = String.IsNullOrEmpty(rv["VIENTRUONGKN_NGUOIKY"] + "") ? 0 : Convert.ToInt32(rv["VIENTRUONGKN_NGUOIKY"] + "");
                string LoaiKN;
                if (VIENTRUONGKN_NGUOIKY == 818 && rv["IsVienTruongKN"].ToString() == "1")
                    LoaiKN = "(CA TANDTC)";
                else if (VIENTRUONGKN_NGUOIKY == 819 && rv["IsVienTruongKN"].ToString() == "1")
                    LoaiKN = "(CA TANDCC tại Hà Nội)";
                else if (VIENTRUONGKN_NGUOIKY == 820 && rv["IsVienTruongKN"].ToString() == "1")
                    LoaiKN = "(CA TANDCC tại Đà Nẵng)";
                else if (VIENTRUONGKN_NGUOIKY == 821 && rv["IsVienTruongKN"].ToString() == "1")
                    LoaiKN = "(CA TANDCC tại HCM)";
                else
                    LoaiKN = (rv["IsVienTruongKN"].ToString() == "0") ? "(CA)" : "(VKS)";

                if (trangthai == 14)
                {
                    lttLanTT.Text = "<b style='float:left;width:100%;'>" + rv["TENTINHTRANG"] + " " + LoaiKN + "</b>";
                    //load thong tin so KN/NgayKN
                    if ((VIENTRUONGKN_NGUOIKY == 818 || VIENTRUONGKN_NGUOIKY == 819 || VIENTRUONGKN_NGUOIKY == 820 || VIENTRUONGKN_NGUOIKY == 821) && rv["IsVienTruongKN"].ToString() == "1")
                        lttDetaiTinhTrang.Text = ((string.IsNullOrEmpty(rv["vientruongkn_so"] + "")) ? "" : "Số: " + rv["vientruongkn_so"].ToString())
                                            + ((string.IsNullOrEmpty(rv["vientruongkn_ngay"] + "")) ? "" : "<br/>Ngày: " + rv["vientruongkn_ngay"].ToString());
                    else
                        lttDetaiTinhTrang.Text = ((string.IsNullOrEmpty(rv["GDQ_SO"] + "")) ? "" : "Số: " + rv["GDQ_SO"].ToString())
                                             + ((string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : "<br/>Ngày: " + rv["GDQ_NGAY"].ToString());

                }
                else if (trangthai == 15)
                {
                    lttLanTT.Text = "<b>Kháng nghị " + LoaiKN + "</b>";
                    String temp = ((string.IsNullOrEmpty(rv["GDQ_SO"] + "")) ? "" : "<span style='padding-right:10px;'>Số: " + rv["GDQ_SO"].ToString() + "</span>")
                                           + ((string.IsNullOrEmpty(rv["GDQ_NGAY"] + "")) ? "" : "Ngày: " + rv["GDQ_NGAY"].ToString());
                    if (temp != "")
                        lttLanTT.Text += "<br/>" + temp;

                    //------------------------------------
                    if (lttLanTT.Text.Length > 0)
                        lttLanTT.Text += "<span class='line_space'></span>";

                    //load thong tin thu ly XXGDTTT
                    String TinhTrangXXGDTT = "<b style='float:left;width:100%;'>" + rv["TENTINHTRANG"] + "</b>"; ;
                    lttLanTT.Text += TinhTrangXXGDTT;
                    lttDetaiTinhTrang.Text += ((String.IsNullOrEmpty(rv["SOTHULYXXGDT"] + "")) ? "" : "<span style = 'padding-right:10px;' >Số: <b>" + rv["SOTHULYXXGDT"].ToString() + "</b></span>")
                                             + ((string.IsNullOrEmpty(rv["NGAYTHULYXXGDT"] + "")) ? "" : "Ngày: <b>" + rv["NGAYTHULYXXGDT"].ToString() + "</b>");

                    //An qua han luat dinh do nguyen nhan Khach quan va Chu quan
                    if (!String.IsNullOrEmpty(rv["inforQuahan"] + ""))
                    {
                        lttDetaiTinhTrang.Text += "<span style=''><b>" + rv["inforQuahan"].ToString() + "</b></span>";
                    }

                }

                //-------------------------------

                Literal lttKQGQ = (Literal)e.Item.FindControl("lttKQGQ");
                LinkButton lttcmdKetqua = (LinkButton)e.Item.FindControl("cmdKetqua");

                if (rv["THAMQUYENXXGDT"].toNumber() == CurrDonViID || rv["THAMQUYENXXGDT"] == null)
                {
                    lttcmdKetqua.Visible = true;
                    int IsHoan = Convert.ToInt16(rv["XXGDTTT_ISHOANPT"] + "");
                    if (IsHoan > 0)
                    {
                        lttKQGQ.Text = "<span class='line_space'>";
                        lttKQGQ.Text += "<b>Hoãn xét xử</b>" + "<br/>";
                        lttKQGQ.Text += "<span style='padding-right:10px;'>Ngày: <b>" + rv["XXGDTTT_NGAYHOAN"].ToString() + "</b></span>";
                        if (!String.IsNullOrEmpty(rv["XXGDTTT_LYDOHOAN"] + ""))
                            lttKQGQ.Text += "<br/>";
                        lttKQGQ.Text += "<span style=''>Lý do: <b>" + rv["XXGDTTT_LYDOHOAN"].ToString() + "</b></span>";
                        lttKQGQ.Text += "<br/>";
                        lttKQGQ.Text += "</span>";
                    }
                    else
                    {
                        if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + "")
                            || !String.IsNullOrEmpty(rv["KetQuaXXGDT"] + "")
                            || !String.IsNullOrEmpty(rv["XXGDTTT_NGAYQD"] + ""))
                        {
                            lttKQGQ.Text += "<span class='line_space'>";
                            lttKQGQ.Text += "<span style='float:left;width:100%;display:block;'>Kết quả XX</span>";
                            //------------------------------------  
                            if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                lttKQGQ.Text += "<span style='padding-right:10px;'><b>" + rv["XXGDTTT_SOQD"].ToString() + "</b></span>";
                            if (!String.IsNullOrEmpty(rv["XXGDTTT_SOQD"] + ""))
                                lttKQGQ.Text += "<span><b>" + rv["XXGDTTT_NGAYQD"].ToString() + "</b></span>";

                            if (lttKQGQ.Text != "")
                            {
                                lttKQGQ.Text += "<br/>";
                                if (!String.IsNullOrEmpty(rv["NGAYXUGIAMDOCTHAM"] + ""))
                                    lttKQGQ.Text += "<span style='padding-right:10px;'>Ngày xử: <b>" + rv["NGAYXUGIAMDOCTHAM"].ToString() + "</b></span>";
                            }
                            //--------------------------                    
                            if (!String.IsNullOrEmpty(rv["KetQuaXXGDT"] + ""))
                            {
                                lttKQGQ.Text += "<br/>";
                                lttKQGQ.Text += "<span style=''>KQ: <b>" + rv["KetQuaXXGDT"].ToString() + "</b></span>";
                            }
                            // Ap dung an le khong
                            if (!String.IsNullOrEmpty(rv["inforAnLe"] + ""))
                            {
                                lttKQGQ.Text += "<span style=''><b>" + rv["inforAnLe"].ToString() + "</b></span>";
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

                }
                else
                {
                    lttcmdKetqua.Visible = true;
                    if (rv["THAMQUYENXXGDT"].toNumber() == 4)
                        lttKQGQ.Text = "<br/>Tòa án nhân dân cấp cao tại Hà Nội xét xử";
                    else if (rv["THAMQUYENXXGDT"].toNumber() == 5)
                        lttKQGQ.Text = "<br/>Tòa án nhân dân cấp cao tại Đà Nẵng xét xử";
                    else if (rv["THAMQUYENXXGDT"].toNumber() == 6)
                        lttKQGQ.Text = "<br/>Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh xét xử";
                    else if (rv["THAMQUYENXXGDT"].toNumber() == 1)
                        lttKQGQ.Text = "<br/>Tòa án nhân dân Tối cao xét xử";
                }

                LinkButton cmdKetqua = (LinkButton)e.Item.FindControl("cmdKetqua");
                Cls_Comon.SetLinkButton(cmdKetqua, oPer.TAOMOI);
            }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "KETQUA":
                    Response.Redirect("ThongtinXetXu.aspx?ID=" + e.CommandArgument.ToString());
                    break;
                case "SoDonTrung":
                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    break;
                case "CongVan81":
                    string StrMsgArr81 = "PopupReport('/QLAN/GDTTT/VuAn/Popup/pDsDon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr81, true);
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

        //protected void lbtTTTK_Click(object sender, EventArgs e)
        //{
        //    if (pnTTTK.Visible == false)
        //    {
        //        lbtTTTK.Text = "[ Thu gọn ]";
        //        pnTTTK.Visible = true;
        //        Session["TTTKVISIBLE"] = "0";
        //    }
        //    else
        //    {
        //        lbtTTTK.Text = "[ Nâng cao ]";
        //        pnTTTK.Visible = false;
        //        Session["TTTKVISIBLE"] = "1";
        //    }
        //}

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
            txtNguyendon.Text = "";
            txtBidon.Text = "";
            ddlLoaiAn.SelectedIndex = 0;
            ddlLoaiAn.SelectedIndex = 0;

            ddlThamtravien.SelectedIndex = 0;
            ddlPhoVuTruong.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;

            txtThuly_Tu.Text = "";
            txtThuly_Den.Text = "";
            txtThuly_So.Text = "";

            dropTrangThaiXXGDT.SelectedIndex = 0;
            dropThamQuyenXX.SelectedIndex = 0;
            ddlKetquaXX.SelectedIndex = 0;

            txtSoKN.Text = "";
            txtNgayKN.Text = "";
        }
        //---------------------------------
        void LoadDropInBieuMau()
        {
        }

        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_Data();
        }
        protected void dropTrangThaiXXGDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropTrangThaiXXGDT.SelectedValue == "0" || dropTrangThaiXXGDT.SelectedValue == "2")
            {
                Cls_Comon.SetValueComboBox(ddlKetquaXX, "0");
                ddlKetquaXX.Enabled = false;
            }
            else
                ddlKetquaXX.Enabled = true;
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {

            int page_size = 50000000;
            int pageindex = 1;

            DataTable tbl = getDS(page_size, pageindex);

            Decimal Loaian = Convert.ToDecimal(Session[SS_TK.LOAIAN]);
            if (Loaian == 1)
            {
                LoadReportHS(tbl);
            }
            else
            {
                LoadReport(tbl);
            }

        }

        private void LoadReport(DataTable tbl)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();

            Literal Table_Str_Totals = new Literal();

            //-------------------------- String.IsNullOrEmpty(row["HS_TenToiDanh"] + "") ? "" : "
            SetGetSessionTK(true);
            String SessionName = "GDTTT_ReportPL".ToUpper();
            //--------------------------
            String ReportName = "DANH SÁCH CÁC VỤ ÁN " + ((ddlLoaiAn.SelectedValue == "0") ? "" : ddlLoaiAn.SelectedItem.Text.ToUpper()) + " ";

            if (ddlThamphan.SelectedValue != "0")
                ReportName += " " + ("do thẩm phán " + ddlThamphan.SelectedItem.Text).ToUpper() + " phụ trách".ToUpper();
            else if (ddlThamtravien.SelectedValue != "0")
                ReportName += " " + ("do thẩm tra viên " + ddlThamtravien.SelectedItem.Text).ToUpper() + " phụ trách".ToUpper();
            else if (ddlPhoVuTruong.SelectedValue != "0")
                ReportName += " " + ("do Lãnh đạo vụ " + ddlPhoVuTruong.SelectedItem.Text).ToUpper() + " phụ trách".ToUpper();


            if (dropTrangThaiXXGDT.SelectedValue != "-1")
                ReportName += dropTrangThaiXXGDT.SelectedItem.ToString().ToUpper();
            // Cls_Comon.ShowMessage(this, this.GetType(),"thông báo", ReportName);
            ReportName += " GIÁM ĐỐC THẨM";
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();

            Session[SessionName] = tbl;
            //den ngày
            DateTime dateAndTime = DateTime.Now;
            DateTime? vDenNgay = txtNgayXX_DenNgay.Text == "" ? (DateTime?)dateAndTime : DateTime.Parse(txtNgayXX_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            //Tiêu đề ngày tháng
            String title_date = "Tính ";
            if (!String.IsNullOrEmpty(txtNgayXX_TuNgay.Text + ""))
            {
                title_date += " từ ngày " + Convert.ToDateTime(txtNgayXX_TuNgay.Text).ToString("dd/MM/yyyy") + " đến ngày " + Convert.ToDateTime(vDenNgay).ToString("dd/MM/yyyy") + "";
            }
            else
            {
                title_date += " đến ngày " + Convert.ToDateTime(vDenNgay).ToString("dd/MM/yyyy") + "";
            }


            if (ToaAnID == 1)
            {
                foreach (DataRow row in tbl.Rows)
                {


                    Table_Str_Totals.Text += "<tr style=\"font-size: 11pt;\">"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["STT"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["SOANPHUCTHAM"] + "<br style='mso-data-placement:same-cell;'/>" + row["NGAYXUPHUCTHAM"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["TOAXX_VietTat"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["QHPLDN"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGUYENDON"] + "</td>"
                         + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["BIDON"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["LoaiKQ_GiaiQuyetDon"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGAYTHULYXXGDT"] + " </td>"
                        + "<td style=\"text - align: left; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["TENTHAMTRAVIEN"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["XXGDTTT_NGAYVKSTRAHS"] + "</td>"
                        + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["ThongTinKQ_XXGDTTT"] + "</td>" +
                        "</ tr > ";
                }
                string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                if (loaitoa.Contains("cấp cao"))
                {
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_GQ_XXGDT_GDTTT.xls");
                    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                    Response.ContentType = "application/vnd.xls";
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    //Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    htmlWrite.WriteLine("<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" style=\"font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;\">");

                    htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                            "<td style = \"width:0px;height:24px;\"></td >" +
                                            "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1400pt;height:24px;line-height:18px;text-align:center;vertical-align:middle;\"><nobr>" +
                                            ReportName + "</nobr></td>" +
                                        "</tr>");



                    htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:0pt; padding-bottom:5pt;text-align:center;\"><td colspan=\"11\"> (" + title_date + ")</td></tr>");
                    htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:5pt; padding-bottom:5pt;text-align:left;\"><td colspan=\"7\"> Tổng số án " + dropTrangThaiXXGDT.SelectedItem.Text.ToLower() + " Giám đốc thẩm là: " + tbl.Rows.Count + "</td><td colspan=\"4\"></td></tr>");

                    htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>STT</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Bản án<br  style='mso-data-placement:same-cell;' />Số & Ngày</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Tòa xét xử</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Quan hệ pháp luật</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Nguyên đơn</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Bị đơn</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Kháng nghị</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Ngày thụ lý xử<br style='mso-data-placement:same-cell;'/>Giám đốc thẩm</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Thẩm tra viên</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Ngày nhận HS<br  style='mso-data-placement:same-cell;' />xử Giám đốc thẩm</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Kết quả<br  style='mso-data-placement:same-cell;'/>Giám đốc thẩm</b></td>" +
                                         "</tr>");

                    Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                     "<td style = \"width:20pt;\"></td>" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:80pt;\"></td >" +
                                     "<td style = \"width:120pt;\" ></td >" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:100pt;\" ></td >" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:400pt;\" ></td >" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:100pt;\" ></td ></tr>" +
                                     "</table>";

                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());
                    Response.Write("</body>");   // add the style props to get the page orientation
                    Response.Write("</html>");   // add the style props to get the page orientation
                    Response.End();
                }
                else
                {
                    Response.Clear();
                    Response.AddHeader("content-disposition", "attachment;filename=BC_GQ_XXGDT_GDTTT.doc");
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
                    Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                    Response.Write("div.Section1 {page:Section1;}");
                    //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                    Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
                    Response.Write("div.Section2 {page:Section2;}");


                    Response.Write("</style>");
                    Response.Write("<style type=\"text/css\">" +
                                    ".csFAC41405 {color:#000000;background-color:transparent;border-left:#000000 1px solid;border-top:#000000 1px solid;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; }" +
                                    ".cs92D6B3BE {color:#000000;background-color:transparent;border-left:#000000 1px solid;border-top-style: none;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:normal; font-style:normal; padding-top:3px;padding-left:3px;padding-right:3px;}" +
                                    ".cs55A4355E {color:#000000;background-color:transparent;border-left-style: none;border-top:#000000 1px solid;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; }" +
                                    ".cs9308C9E5 {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:normal; font-style:normal; padding-top:3px;padding-left:3px;padding-right:3px;}" +
                                    ".csC9A92AEB {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right-style: none;border-bottom-style: none;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:italic; padding-left:2px;padding-right:2px;}" +
                                    ".cs1EF4761A {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right-style: none;border-bottom-style: none;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; padding-left:2px;padding-right:2px;}" +
                                    ".csAC6A4475 { height: 0px; width: 0px; overflow: hidden; font - size:0px; line - height:0px;}" +
                                    "</style>");


                    Response.Write("</head>");
                    Response.Write("<body>");
                    Response.Write("<div class=Section2>");
                    System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                    System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                    htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                    htmlWrite.WriteLine("<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" style=\"font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;\">");

                    htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                            "<td style = \"width:0px;height:24px;\"></td >" +
                                            "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1400pt;height:24px;line-height:18px;text-align:center;vertical-align:middle;\"><nobr>" +
                                            ReportName + "</nobr></td>" +
                                        "</tr>");



                    htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:0pt; padding-bottom:5pt;text-align:center;\"><td colspan=\"11\"> (" + title_date + ")</td></tr>");
                    htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:5pt; padding-bottom:5pt;text-align:left;\"><td colspan=\"7\"> Tổng số án " + dropTrangThaiXXGDT.SelectedItem.Text.ToLower() + " Giám đốc thẩm là: " + tbl.Rows.Count + "</td><td colspan=\"4\"></td></tr>");

                    htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>STT</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Bản án<br  style='mso-data-placement:same-cell;' />Số & Ngày</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Tòa xét xử</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Quan hệ pháp luật</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Nguyên đơn</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Bị đơn</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Kháng nghị</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Ngày thụ lý xử<br style='mso-data-placement:same-cell;'/>Giám đốc thẩm</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Thẩm tra viên</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Ngày nhận HS<br  style='mso-data-placement:same-cell;' />xử Giám đốc thẩm</b></td>" +
                                           "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\"><b>Kết quả<br  style='mso-data-placement:same-cell;'/>Giám đốc thẩm</b></td>" +
                                         "</tr>");

                    Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                     "<td style = \"width:20pt;\"></td>" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:80pt;\"></td >" +
                                     "<td style = \"width:120pt;\" ></td >" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:100pt;\" ></td >" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:400pt;\" ></td >" +
                                     "<td style = \"width:80pt;\" ></td >" +
                                     "<td style = \"width:80pt;\" ></td ></tr>" +
                                     "</table>";

                    Table_Str_Totals.RenderControl(htmlWrite);
                    Response.Write(stringWrite.ToString());

                    Response.Write("</div>");
                    Response.Write("</body>");
                    Response.Write("</html>");
                    Response.End();
                }

            }
            else
            {
                foreach (DataRow row in tbl.Rows)
                {


                    Table_Str_Totals.Text += "<tr style=\"font-size: 11pt;\">"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["STT"] + "</td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["SOANPHUCTHAM"] + "</td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["NGAYXUPHUCTHAM"] + "</td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["TOAXX_VietTat"] + "</td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["QHPLDN"] + "</td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["NGUYENDON"] + "</td>"
                         + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["BIDON"] + "</td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["LoaiKQ_GiaiQuyetDon"] + "</td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["NGAYTHULYXXGDT"] + " </td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["TENTHAMTRAVIEN"] + "</td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["XXGDTTT_NGAYVKSTRAHS"] + "</td>"
                        + "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\">" + row["ThongTinKQ_XXGDTTT"] + "</td>" +
                        "</ tr > ";
                }
                //-------------------Export---------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_VUAN_XXGDTTT.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                //Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
                htmlWrite.WriteLine("<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" style=\"font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;\">");

                htmlWrite.WriteLine("<tr style=\"vertical-align:top;\">" +
                                        "<td style = \"width:0px;height:24px;\"></td >" +
                                        "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1032px;height:24px;line-height:18px;text-align:center;vertical-align:middle;\"><nobr>" +
                                        ReportName + "</nobr></td>" +
                                    "</tr>");



                htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:0pt; padding-bottom:5pt;text-align:center;\"><td colspan=\"11\"> (" + title_date + ")</td></tr>");
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:5pt; padding-bottom:5pt;text-align:left;\"><td colspan=\"7\"> Tổng số án " + dropTrangThaiXXGDT.SelectedItem.Text.ToLower() + " Giám đốc thẩm là: " + tbl.Rows.Count + "</td><td colspan=\"4\"></td></tr>");

                htmlWrite.WriteLine("<tr style=\"vertical-align:top;\">" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>STT</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Số Bản án</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Ngày Bản án</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Tòa xét xử</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Quan hệ pháp luật</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Nguyên đơn</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Bị đơn</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Kháng nghị</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Ngày thụ lý xử<br style='mso-data-placement:same-cell;'/>Giám đốc thẩm</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Thẩm tra viên</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Ngày nhận HS<br style='mso-data-placement:same-cell;'/>xử Giám đốc thẩm</b></td>" +
                                       "<td style=\"text-align: center; vertical-align: middle; border: 0.1pt solid #000000;\"><b>Kết quả<br style='mso-data-placement:same-cell;'/>Giám đốc thẩm</b></td>" +
                                     "</tr>");

                Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                 "<td style = \"width:30pt;\"></td>" +
                                 "<td style = \"width:30pt;\" ></td >" +
                                 "<td style = \"width:50pt;\" ></td >" +
                                 "<td style = \"width:80pt;\"></td >" +
                                 "<td style = \"width:120pt;\" ></td >" +
                                 "<td style = \"width:80pt;\" ></td >" +
                                 "<td style = \"width:100pt;\" ></td >" +
                                 "<td style = \"width:80pt;\" ></td >" +
                                 "<td style = \"width:80pt;\" ></td >" +
                                 "<td style = \"width:400pt;\" ></td >" +
                                 "<td style = \"width:80pt;\" ></td >" +
                                 "<td style = \"width:100pt;\" ></td ></tr>" +
                                 "</table>";
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");   // add the style props to get the page orientation
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }

        }

        private void LoadReportHS(DataTable tbl)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();

            Literal Table_Str_Totals = new Literal();

            //-------------------------- String.IsNullOrEmpty(row["HS_TenToiDanh"] + "") ? "" : "
            SetGetSessionTK(true);
            String SessionName = "GDTTT_ReportPL".ToUpper();
            //--------------------------
            String ReportName = "DANH SÁCH CÁC VỤ ÁN " + ((ddlLoaiAn.SelectedValue == "0") ? "" : ddlLoaiAn.SelectedItem.Text.ToUpper()) + " ";

            if (ddlThamphan.SelectedValue != "0")
                ReportName += " " + ("do thẩm phán " + ddlThamphan.SelectedItem.Text).ToUpper() + " phụ trách".ToUpper();
            else if (ddlThamtravien.SelectedValue != "0")
                ReportName += " " + ("do thẩm tra viên " + ddlThamtravien.SelectedItem.Text).ToUpper() + " phụ trách".ToUpper();
            else if (ddlPhoVuTruong.SelectedValue != "0")
                ReportName += " " + ("do Lãnh đạo vụ " + ddlPhoVuTruong.SelectedItem.Text).ToUpper() + " phụ trách".ToUpper();


            if (dropTrangThaiXXGDT.SelectedValue != "-1")
                ReportName += dropTrangThaiXXGDT.SelectedItem.ToString().ToUpper();
            // Cls_Comon.ShowMessage(this, this.GetType(),"thông báo", ReportName);
            ReportName += " GIÁM ĐỐC THẨM";
            Session[SS_TK.TENBAOCAO] = ReportName.ToUpper();

            Session[SessionName] = tbl;

            //den ngày
            DateTime dateAndTime = DateTime.Now;
            DateTime? vDenNgay = txtNgayXX_DenNgay.Text == "" ? (DateTime?)dateAndTime : DateTime.Parse(txtNgayXX_DenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            //Tiêu đề ngày tháng
            String title_date = "Tính ";
            if (!String.IsNullOrEmpty(txtNgayXX_TuNgay.Text + ""))
            {
                title_date += " từ ngày " + Convert.ToDateTime(txtNgayXX_TuNgay.Text).ToString("dd/MM/yyyy") + " đến ngày " + Convert.ToDateTime(vDenNgay).ToString("dd/MM/yyyy") + " ";
            }
            else
            {
                title_date += " đến ngày" + Convert.ToDateTime(vDenNgay).ToString("dd/MM/yyyy") + " ";
            }



            foreach (DataRow row in tbl.Rows)
            {

                Table_Str_Totals.Text += "<tr style=\"font-size: 11pt;\">"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["STT"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["SOANPHUCTHAM"] + "<br/>" + row["NGAYXUPHUCTHAM"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["TOAXX_VietTat"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["QHPNDN_Report"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGUYENDON"] + " (Đầu vụ)<br/>" + row["BIDON"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["LoaiKQ_GiaiQuyetDon"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["NGAYTHULYXXGDT"] + " </td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["TENTHAMTRAVIEN"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["XXGDTTT_NGAYVKSTRAHS"] + "</td>"
                    + "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;\">" + row["ThongTinKQ_XXGDTTT"] + "</td>" +
                    "</ tr > ";
            }
            string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            if (loaitoa.Contains("cấp cao"))
            {
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_GQ_XXGDT_GDTTT.xls");
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                //Response.Write(AddExcelStyling(2, INSERT_PAGE_BREAK));   // add the style props to get the page orientation
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                htmlWrite.WriteLine("<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" style=\"font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;\">");

                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                        "<td style = \"width:0px;height:24px;\"></td >" +
                                        "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1032px;height:24px;line-height:18px;text-align:center;vertical-align:middle;\"><nobr> " +
                                        ReportName + "</nobr></td>" +
                                    "</tr>");



                htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:0pt; padding-bottom:5pt;text-align:center;\"><td colspan=\"11\"> (" + title_date + ")</td></tr>");
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:5pt; padding-bottom:5pt;text-align:left;\"><td colspan=\"7\"> Tổng số án " + dropTrangThaiXXGDT.SelectedItem.Text.ToLower() + " Giám đốc thẩm là: " + tbl.Rows.Count + "</td><td colspan=\"4\"></td></tr>");
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">STT</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bản án<br/>Số & Ngày</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tòa xét xử</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tội danh</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bị cáo</td>" +

                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Kháng nghị</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày thụ lý xử<br/>Giám đốc thẩm</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Thẩm tra viên</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày nhận HS<br>xử Giám đốc thẩm</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Kết quả<br/>Giám đốc thẩm</td>" +
                                      "</tr>");

                Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                    "<td style = \"width:20pt;\"></td>" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:80pt;\"></td >" +
                                    "<td style = \"width:120pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:100pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:120pt;\" ></td ></tr>" +
                                    "</table>";
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());
                Response.Write("</body>");   // add the style props to get the page orientation
                Response.Write("</html>");   // add the style props to get the page orientation
                Response.End();
            }
            else
            {
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=BC_GQ_XXGDT_GDTTT.doc");
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
                Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("div.Section1 {page:Section1;}");
                //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
                Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
                Response.Write("div.Section2 {page:Section2;}");


                Response.Write("</style>");
                Response.Write("<style type=\"text/css\">" +
                                ".csFAC41405 {color:#000000;background-color:transparent;border-left:#000000 1px solid;border-top:#000000 1px solid;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; }" +
                                ".cs92D6B3BE {color:#000000;background-color:transparent;border-left:#000000 1px solid;border-top-style: none;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:normal; font-style:normal; padding-top:3px;padding-left:3px;padding-right:3px;}" +
                                ".cs55A4355E {color:#000000;background-color:transparent;border-left-style: none;border-top:#000000 1px solid;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; }" +
                                ".cs9308C9E5 {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right:#000000 1px solid;border-bottom:#000000 1px solid;font-family:Times New Roman; font-size:16px; font-weight:normal; font-style:normal; padding-top:3px;padding-left:3px;padding-right:3px;}" +
                                ".csC9A92AEB {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right-style: none;border-bottom-style: none;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:italic; padding-left:2px;padding-right:2px;}" +
                                ".cs1EF4761A {color:#000000;background-color:transparent;border-left-style: none;border-top-style: none;border-right-style: none;border-bottom-style: none;font-family:Times New Roman; font-size:16px; font-weight:bold; font-style:normal; padding-left:2px;padding-right:2px;}" +
                                ".csAC6A4475 { height: 0px; width: 0px; overflow: hidden; font - size:0px; line - height:0px;}" +
                                "</style>");


                Response.Write("</head>");
                Response.Write("<body>");
                Response.Write("<div class=Section2>");
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
                htmlWrite.WriteLine("<table cellpadding=\"1\" cellspacing=\"1\" border=\"0\" style=\"font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;\">");

                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                        "<td style = \"width:0px;height:24px;\"></td >" +
                                        "<td class=\"cs1EF4761A\" colspan=\"10\" style=\"width:1032px;height:24px;line-height:18px;text-align:center;vertical-align:middle;\"><nobr> " +
                                        ReportName + "</nobr></td>" +
                                    "</tr>");



                htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:0pt; padding-bottom:5pt;text-align:center;\"><td colspan=\"11\"> (" + title_date + ")</td></tr>");
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;padding-top:5pt; padding-bottom:5pt;text-align:left;\"><td colspan=\"7\"> Tổng số án " + dropTrangThaiXXGDT.SelectedItem.Text.ToLower() + " Giám đốc thẩm là: " + tbl.Rows.Count + "</td><td colspan=\"4\"></td></tr>");
                htmlWrite.WriteLine("<tr style=\"vertical - align:top;\">" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">STT</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bản án<br/>Số & Ngày</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tòa xét xử</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Tội danh</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Bị cáo</td>" +

                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Kháng nghị</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày thụ lý xử<br/>Giám đốc thẩm</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Thẩm tra viên</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Ngày nhận HS<br>xử Giám đốc thẩm</td>" +
                                        "<td style=\"text - align: center; vertical - align: middle; border: 0.1pt solid #000000;font-weight:bold;\">Kết quả<br/>Giám đốc thẩm</td>" +
                                      "</tr>");

                Table_Str_Totals.Text += "<tr style=\"height: 1pt;\">" +
                                    "<td style = \"width:20pt;\"></td>" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:80pt;\"></td >" +
                                    "<td style = \"width:120pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:100pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:80pt;\" ></td >" +
                                    "<td style = \"width:120pt;\" ></td ></tr>" +
                                    "</table>";
                Table_Str_Totals.RenderControl(htmlWrite);
                Response.Write(stringWrite.ToString());

                Response.Write("</div>");
                Response.Write("</body>");
                Response.Write("</html>");
                Response.End();
            }

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
