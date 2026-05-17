using Aspose.Words;
using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.GDTTT;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.QLAN.GDTTT.In;

namespace WEB.GSTP.QLAN.GDTTT.Hoso
{
    public partial class Danhsachdon_cc_chuyen : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0;
        private const decimal ROOT = 0;
        string pathTemplateWord = ConfigurationManager.AppSettings["TemplateWord"];
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
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            //Further code goes here....
            //-----------------
            if (!IsPostBack)
            {

                //if ((Session["TTBCVISIBLE"] + "") == "1")
                //{
                //    lbtTTBC.Text = "[ Đóng ]";
                //    pnTTBC.Visible = true;
                //}
                if ((Session["TTTKVISIBLE"] + "") == "0")
                {
                    lbtTTTK.Text = "[ Thu gọn ]";
                    pnTTTK.Visible = true;
                }
                //---------Văn thư - văn bản đến
                if ((Session["VT_VBD_VISIBLE"] + "") == "1")
                {
                    lbt_vt_vbd.Text = "[ Đóng ]";
                    pn_VT_VBD.Visible = true;
                }
                if ((Session["VT_VBD_VISIBLE"] + "") == "0")
                {
                    lbt_vt_vbd.Text = "[ Thu gọn ]";
                    pn_VT_VBD.Visible = true;
                }
                Load_Noi_NhanSearch();
                LoadDropTinh();
                LoadLoaiAn(Convert.ToDecimal(ddlPhongban.SelectedValue));
                LoadDropToaAnCC();
                SetGetSessionTK(false);
                //Lay so moi nhat cho van ban phat hanh
                // Layso_SoVB();

                if (Session[SS_TK.SOBAQD] != null)
                    Load_Data();
                //if (ddlTrangthaichuyen.SelectedValue == "0")
                //else
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                //Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                //--------
                if (Session[ENUM_SESSION.SESSION_USERNAME] + "" == "tc.vanphonga")
                {
                }
                //khi được phân quyền chức năng nhận văn bản thì mới được hiển thì group tìm kiếm văn thư - và được gán vào quyền xem
                MenuPermission oPer_vanthuden = Cls_Comon.GetMenuPer("/QLAN/GDTTT/VT_DEN/Van_ban_den_form.aspx", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                pn_vanthu.Visible = oPer_vanthuden.XEM;
            }

        }
        protected void Load_Noi_NhanSearch()
        {
            Drop_NOI_NHAN_SEARCH.Items.Clear();
            Drop_NOI_NHAN_SEARCH.Items.Add(new ListItem("Văn Thư", Session[ENUM_SESSION.SESSION_DONVIID] + ""));//giá trị = 1 chỉ là để khác null để check
            //---------------
            Drop_NOI_NHAN_SEARCH.Items.Insert(0, new ListItem("---Tất cả---", ""));
        }
        protected void cmd_xuly_vt_vbd_Click(object sender, ImageClickEventArgs e)
        {
            ImageButton img = (ImageButton)sender;
            String[] ND_id_arr = img.CommandArgument.ToString().Split(';');
            String _Id = ND_id_arr[0] + "";
            String _VANBANDEN_ID = ND_id_arr[1] + "";
            Session[SS_TK.ISHOME] = 1;
            Session["DONID_CC"] = _Id;
            Session["VUVIECID_CC"] = null;
            Response.Redirect("Thongtindon_cc.aspx?ID=" + _Id + "&vt_id=" + _VANBANDEN_ID);
        }
        private void SetGetSessionTK(bool isSet)
        {
            try
            {
                if (isSet)
                {
                    decimal isDonGoc = 1;
                    if (txtSohieudon.Text != "" || txtThuly_So.Text != ""
                        || //txtNgaynhapTu.Text !="" || txtNgaynhapDen.Text !="" ||
                       ddlPhanloaiDdon.SelectedValue == "2")
                        isDonGoc = 0;
                    Session[SS_TK.PHANLOAIDON] = ddlPhanloaiDdon.SelectedValue;
                    Session[SS_TK.ISDONGOC] = isDonGoc;
                    Session[SS_TK.ISTUHINH] = ddlAnTuHinh.SelectedValue;
                    Session[SS_TK.TOAANXX] = ddlToaXetXu.SelectedValue;
                    Session[SS_TK.SOBAQD] = txtSoQDBA.Text;
                    Session[SS_TK.NGAYBAQD] = txtNgayBAQD.Text;
                    Session[SS_TK.NGUOIGUI] = txtNguoigui.Text;
                    Session[SS_TK.SOCMND] = txtSoCMND.Text;
                    Session[SS_TK.NGAYNHANTU] = txtNgayNhanTu.Text;
                    Session[SS_TK.NGAYNHANDEN] = txtNgayNhanDen.Text;
                    Session[SS_TK.HINHTHUCDON] = ddlHinhthucdon.SelectedValue;
                    Session[SS_TK.MADON] = txtSohieudon.Text;
                    if (ddlHuyen.SelectedValue == "0")
                    {
                        Session[SS_TK.TINHID] = 0;
                        Session[SS_TK.HUYENID] = 0;
                    }
                    else
                    {
                        decimal TinhHuyenID = Convert.ToDecimal(ddlHuyen.SelectedValue);
                        DM_HANHCHINH oDMHC = dt.DM_HANHCHINH.Where(x => x.ID == TinhHuyenID).FirstOrDefault();
                        if (oDMHC.LOAI == 1)//TỈnh
                        {
                            Session[SS_TK.TINHID] = oDMHC.ID.ToString();
                            Session[SS_TK.HUYENID] = 0;
                        }
                        else
                        {
                            Session[SS_TK.TINHID] = oDMHC.CAPCHAID;
                            Session[SS_TK.HUYENID] = oDMHC.ID;
                        }
                    }
                    Session[SS_TK.DIACHICHITIET] = txtDiachi.Text;
                    Session[SS_TK.SOCV] = txtCV_So.Text;
                    Session[SS_TK.NGAYCV] = txtCV_Ngay.Text;
                    Session[SS_TK.TRALOIDON] = ddlTraloi.SelectedValue;
                    Session[SS_TK.LOAICHUYEN] = ddlNoichuyenden.SelectedValue;
                    Session[SS_TK.TRANGTHAICHUYEN] = ddlTrangthaichuyen.SelectedValue;
                    Session[SS_TK.PHONGBANCHUYEN] = ddlPhongban.SelectedValue;
                    Session[SS_TK.LOAIAN] = ddlLoaiAn.SelectedValue;
                    Session[SS_TK.DIEUKIENCHUYEN] = ddlTrangthaidon.SelectedValue;
                    Session[SS_TK.NGAYCHUYENTU] = txtNgaychuyenTu.Text;
                    Session[SS_TK.NGAYCHUYENDEN] = txtNgaychuyenDen.Text;
                    Session[SS_TK.TOAKHACID] = ddlToaKhac.SelectedValue;
                    Session[SS_TK.TENNGOAITOAAN] = txtNgoaitoaan.Text;
                    Session[SS_TK.THULYDON] = ddlThuLy.SelectedValue;
                    Session[SS_TK.CHANHANCHIDAO] = ddlChidao.SelectedValue;
                    Session[SS_TK.TRAIGIAM] = ddlTraigiam.SelectedValue;
                    Session[SS_TK.THAMPHAN] = ddlThamphan.SelectedValue;
                    Session[SS_TK.LOAICV] = ddlLoaiCV.SelectedValue;
                    //Session[SS_TK.BC_SOCV] = txtBC_SoCV.Text;
                    //Session[SS_TK.BC_NGAYCV] = txtBC_Ngaydk.Text;
                    //Session[SS_TK.BC_NGUOIKY] = txtBC_Nguoiky.Text;
                    Session[SS_TK.NGAYNHAPTU] = txtNgaynhapTu.Text;
                    Session[SS_TK.NGAYNHAPDEN] = txtNgaynhapDen.Text;
                    Session[SS_TK.THULY_TU] = txtThuly_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtThuly_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
                    Session[SS_TK.NDBD_VALUE] = Drop_NDBD.SelectedValue;
                    Session[SS_TK.NDBD_TEXT] = txt_NDBD.Text;
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
                    Session[SS_TK.NGUOINHAP] = lstDataUS.Value;

                    Session[SS_TK.CVPC_SO] = txtCVPC_So.Text;
                    Session[SS_TK.CVPC_NGAY] = txtCVPC_Ngay.Text;
                    Session[SS_TK.CVPC_TenCQ] = txtCVPC_TenCQ.Text;
                    Session[SS_TK.GUITOI_CA_TA] = ddlChuyentoi.SelectedValue;
                    //--------------------------------
                    Session[SS_TK.NOI_NHAN_SEARCH] = Drop_NOI_NHAN_SEARCH.SelectedValue;
                    Session[SS_TK.TRANG_THAI_XLY_VT] = Drop_TRANGTHAICHUYEN.SelectedValue;
                    Session[SS_TK.LOAI_VB] = Drop_LOAI_VB_Search.SelectedValue;
                    Session[SS_TK.SODEN] = txt_SODEN_SEARCH.Text.Trim();
                    Session[SS_TK.SODEN_DEN] = txt_SODEN_SEARCH_DEN.Text.Trim();
                    Session[SS_TK.NGAY_FROM] = txt_NGAY_FROM.Text.Trim();
                    Session[SS_TK.NGAY_FROM_DEN] = txt_NGAY_TO.Text.Trim();
                    Session[SS_TK.NGUOI_GUI_BT] = txt_NGUOI_GUI_BT_SEARCH.Text.Trim();
                }
                else
                {
                    int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                    if (IsHome == 1)
                    {
                        ddlPhanloaiDdon.SelectedValue = Session[SS_TK.PHANLOAIDON] + "";
                        txtNguoigui.Text = Session[SS_TK.NGUOIGUI] + "";
                        txtSoQDBA.Text = Session[SS_TK.SOBAQD] + "";
                        txtNgayBAQD.Text = Session[SS_TK.NGAYBAQD] + "";
                        if (Session[SS_TK.TOAANXX] != null) ddlToaXetXu.SelectedValue = Session[SS_TK.TOAANXX] + "";
                        txtNgayNhanTu.Text = Session[SS_TK.NGAYNHANTU] + "";
                        txtNgayNhanDen.Text = Session[SS_TK.NGAYNHANDEN] + "";
                        if (Session[SS_TK.LOAICHUYEN] != null) ddlNoichuyenden.SelectedValue = Session[SS_TK.LOAICHUYEN] + "";
                        ddlNoichuyenden_SelectedIndexChanged(null, null);
                        if (Session[SS_TK.PHONGBANCHUYEN] != null) ddlPhongban.SelectedValue = Session[SS_TK.PHONGBANCHUYEN] + "";
                        if (Session[SS_TK.LOAIAN] != null) ddlLoaiAn.SelectedValue = Session[SS_TK.LOAIAN] + "";

                        if (Session[SS_TK.DIEUKIENCHUYEN] != null) ddlTrangthaidon.SelectedValue = Session[SS_TK.DIEUKIENCHUYEN] + "";
                        txtNgaychuyenTu.Text = Session[SS_TK.NGAYCHUYENTU] + "";
                        txtNgaychuyenDen.Text = Session[SS_TK.NGAYCHUYENDEN] + "";
                        if (Session[SS_TK.TOAKHACID] != null) ddlToaKhac.SelectedValue = Session[SS_TK.TOAKHACID] + "";
                        txtNgoaitoaan.Text = Session[SS_TK.TENNGOAITOAAN] + "";
                        if (Session[SS_TK.THULYDON] != null) ddlThuLy.SelectedValue = Session[SS_TK.THULYDON] + "";
                        if (Session[SS_TK.HINHTHUCDON] != null) ddlHinhthucdon.SelectedValue = Session[SS_TK.HINHTHUCDON] + "";
                        txtSoCMND.Text = Session[SS_TK.SOCMND] + "";
                        txtSohieudon.Text = Session[SS_TK.MADON] + "";
                        string strTinhID = Session[SS_TK.TINHID] + "";
                        string strHuyenID = Session[SS_TK.HUYENID] + "";
                        if (strHuyenID != "" && strHuyenID != "0")
                            ddlHuyen.SelectedValue = strHuyenID;
                        else
                        {
                            if (strTinhID != "" && strTinhID != "0")
                                ddlHuyen.SelectedValue = strTinhID;
                        }
                        txtDiachi.Text = Session[SS_TK.DIACHICHITIET] + "";
                        if (Session[SS_TK.TRALOIDON] != null) ddlTraloi.SelectedValue = Session[SS_TK.TRALOIDON] + "";

                        txtCV_So.Text = Session[SS_TK.SOCV] + "";
                        txtCV_Ngay.Text = Session[SS_TK.NGAYCV] + "";
                        if (Session[SS_TK.TRANGTHAICHUYEN] != null) ddlTrangthaichuyen.SelectedValue = Session[SS_TK.TRANGTHAICHUYEN] + "";

                        if (Session[SS_TK.CHANHANCHIDAO] != null) ddlChidao.SelectedValue = Session[SS_TK.CHANHANCHIDAO] + "";
                        if (Session[SS_TK.TRAIGIAM] != null) ddlTraigiam.SelectedValue = Session[SS_TK.TRAIGIAM] + "";

                        //txtBC_SoCV.Text = Session[SS_TK.BC_SOCV] + "";
                        //txtBC_Ngaydk.Text = Session[SS_TK.BC_NGAYCV] + "";
                        //txtBC_Nguoiky.Text = Session[SS_TK.BC_NGUOIKY] + "";

                        txtNgaynhapTu.Text = Session[SS_TK.NGAYNHAPTU] + "";
                        txtNgaynhapDen.Text = Session[SS_TK.NGAYNHAPDEN] + "";
                        if (Session[SS_TK.THAMPHAN] != null) ddlThamphan.SelectedValue = Session[SS_TK.THAMPHAN] + "";
                        if (Session[SS_TK.LOAICV] != null) ddlLoaiCV.SelectedValue = Session[SS_TK.LOAICV] + "";
                        if (Session[SS_TK.ISTUHINH] != null) ddlAnTuHinh.SelectedValue = Session[SS_TK.ISTUHINH] + "";

                        txtThuly_Tu.Text = Session[SS_TK.THULY_TU] + "";
                        txtThuly_Den.Text = Session[SS_TK.THULY_DEN] + "";
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";
                        Drop_NDBD.SelectedValue = Session[SS_TK.NDBD_VALUE] + "";
                        txt_NDBD.Text = Session[SS_TK.NDBD_TEXT] + "";

                        lstDataUS.Value = Session[SS_TK.NGUOINHAP] + "";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "call_fu_set", "ddlMultiSelect_fu_setvalue();", true);

                        txtCVPC_So.Text = Session[SS_TK.CVPC_SO] + "";
                        txtCVPC_Ngay.Text = Session[SS_TK.CVPC_NGAY] + "";
                        txtCVPC_TenCQ.Text = Session[SS_TK.CVPC_TenCQ] + "";
                        if (Session[SS_TK.GUITOI_CA_TA] != null) ddlChuyentoi.SelectedValue = Session[SS_TK.GUITOI_CA_TA] + "";

                        Drop_NOI_NHAN_SEARCH.SelectedValue = Session[SS_TK.NOI_NHAN_SEARCH] + "";
                        Drop_TRANGTHAICHUYEN.SelectedValue = Session[SS_TK.TRANG_THAI_XLY_VT] + "";
                        Drop_LOAI_VB_Search.SelectedValue = Session[SS_TK.LOAI_VB] + "";

                        txt_SODEN_SEARCH.Text = Session[SS_TK.SODEN] + "";
                        txt_SODEN_SEARCH_DEN.Text = Session[SS_TK.SODEN_DEN] + "";
                        txt_NGAY_FROM.Text = Session[SS_TK.NGAY_FROM] + "";
                        txt_NGAY_TO.Text = Session[SS_TK.NGAY_FROM_DEN] + "";
                        txt_NGUOI_GUI_BT_SEARCH.Text = Session[SS_TK.NGUOI_GUI_BT] + "";
                        //--------------------------------
                        ShowButtonPrint();
                    }
                }
            }
            catch (Exception ex) { }
        }
        private DataTable getDS(Decimal V_GET_LIS_ID, bool isCV, bool isOnPrint, bool isTraigiam, bool isChiDao, bool isTBQuahan)
        {
            int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
            decimal isDonGoc = 1;
            if (txtSohieudon.Text != "" || txtThuly_So.Text != ""
                ||// txtNgaynhapTu.Text != "" || txtNgaynhapDen.Text != "" ||
                ddlPhanloaiDdon.SelectedValue == "2")
                isDonGoc = 0;
            Session[SS_TK.ISDONGOC] = isDonGoc;
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue),
                HinhThucDon = Convert.ToDecimal(ddlHinhthucdon.SelectedValue), DiaChiTinh = 0,
                DiaChiHuyen = 0, TraLoi = Convert.ToDecimal(ddlTraloi.SelectedValue);
            string SoBAQD = txtSoQDBA.Text.Trim(), NgayBAQD = txtNgayBAQD.Text, NguoiGui = txtNguoigui.Text.Trim(),
                SoCMND = txtSoCMND.Text.Trim(), SoHieuDon = txtSohieudon.Text.Trim(), DiaChiCT = txtDiachi.Text.Trim(),
                SoVanBan = txtCV_So.Text.Trim(), NgayVanBan = txtCV_Ngay.Text,
                strNguoiNhap = "";
            DateTime? TuNgay = txtNgayNhanTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanTu.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                DenNgay = txtNgayNhanDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayNhanDen.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            if (ddlHuyen.SelectedValue == "0")
            {
                DiaChiTinh = 0;
                DiaChiHuyen = 0;
            }
            else
            {
                decimal TinhHuyenID = Convert.ToDecimal(ddlHuyen.SelectedValue);
                DM_HANHCHINH oDMHC = dt.DM_HANHCHINH.Where(x => x.ID == TinhHuyenID).FirstOrDefault();
                if (oDMHC.LOAI == 1)//TỈnh
                {
                    DiaChiTinh = (decimal)oDMHC.ID;
                    DiaChiHuyen = 0;
                }
                else
                {
                    DiaChiTinh = (decimal)oDMHC.CAPCHAID;
                    DiaChiHuyen = oDMHC.ID;
                }
            }
            if (isCV) HinhThucDon = 3;
            string vArrSelectID = "";
            if (isOnPrint)
            {
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                        else vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                    }
                }
            }
            if (vArrSelectID != "") vArrSelectID = "," + vArrSelectID + ",";

            strNguoiNhap = lstDataUS.Value;
            if (strNguoiNhap != "") strNguoiNhap = "," + strNguoiNhap + ",";

            decimal vNoichuyen = Convert.ToDecimal(ddlNoichuyenden.SelectedValue);
            decimal vTrangthai = Convert.ToDecimal(ddlTrangthaichuyen.SelectedValue);
            decimal vCD_DONVIID = 0, vCD_TA_TRANGTHAI = -1;
            if (ddlNoichuyenden.SelectedValue == "0")
            {
                vCD_DONVIID = Convert.ToDecimal(ddlPhongban.SelectedValue);
                vCD_TA_TRANGTHAI = Convert.ToDecimal(ddlTrangthaidon.SelectedValue);
            }
            else if (ddlNoichuyenden.SelectedValue == "1")
            {
                vCD_DONVIID = Convert.ToDecimal(ddlToaKhac.SelectedValue);
            }
            string vCD_TENDONVI, vLoaiSoVB;
            DateTime? vNgaychuyenTu = txtNgaychuyenTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenTu.Text, cul, DateTimeStyles.NoCurrentDateDefault)
                , vNgaychuyenDen = txtNgaychuyenDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaychuyenDen.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            decimal vIsThuLy = Convert.ToDecimal(ddlThuLy.SelectedValue);
            decimal vPhanloaixuly = 0;// Convert.ToDecimal(ddlPhanloaiDdon.SelectedValue);
            if (ddlThuLy.Visible == false) vIsThuLy = -1;
            if (IsHome == 1)//khi người dùng nhấn vào số liệu từ bảng thống kê sau login
            {
                vIsThuLy = Convert.ToDecimal(ddlThuLy.SelectedValue);
            }
            DateTime? vNgayThulyTu = txtThuly_Tu.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Tu.Text, cul, DateTimeStyles.NoCurrentDateDefault)
                , vNgayThulyDen = txtThuly_Den.Text == "" ? (DateTime?)null : DateTime.Parse(txtThuly_Den.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? vNgayNhapTu = txtNgaynhapTu.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaynhapTu.Text, cul, DateTimeStyles.NoCurrentDateDefault)
               , vNgayNhapDen = txtNgaynhapDen.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaynhapDen.Text + " 23:59:59", cul, DateTimeStyles.NoCurrentDateDefault);
            //if (vNgayNhapDen != null)
            //{
            //    vNgayNhapDen = ((DateTime)vNgayNhapDen).AddHours(23);
            //}
            string vSoThuly = txtThuly_So.Text;
            decimal vChidao = Convert.ToDecimal(ddlChidao.SelectedValue);
            if (isChiDao) vChidao = 0;
            decimal vTraigiam = Convert.ToDecimal(ddlTraigiam.SelectedValue);
            decimal vTBQuahan = 0, vThamphanID = 0, vThamtravienID = 0, vLoaiCVID = 0, vIsTuHinh = Convert.ToDecimal(ddlAnTuHinh.SelectedValue);
            DateTime vNgayQuahan = DateTime.Now;
            if (isTBQuahan)
            {
                vTBQuahan = 1;
                //if (txtBC_Ngaydk.Text != "")
                //{
                //    vNgayQuahan = DateTime.Parse(txtBC_Ngaydk.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                //    if (vNgayQuahan == null) vNgayQuahan = DateTime.Now;
                //}
            }
            if (isTraigiam) vTraigiam = 1;
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);
            vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            if (isOnPrint)
            {
                pageindex = 1;
                page_size = 0;//10000;
            }
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vGuitoiCA_TA = Convert.ToDecimal(ddlChuyentoi.SelectedValue);
            string vCVPC_So = txtCVPC_So.Text.Trim(), vCVPC_Ngay = txtCVPC_Ngay.Text, vCVPC_TenCQ = txtCVPC_TenCQ.Text.Trim();
            //Dùng kết hợp trong trường hợp chọn số tờ trình
            //if ((vNoichuyen == 0 || vNoichuyen == -1) && ddlLOAICVPC.SelectedValue == "1") 
            //{
            //    vCD_TENDONVI = "TTR";
            //}
            //else if (vNoichuyen == 2)
            //{
            //    vCD_TENDONVI = txtNgoaitoaan.Text;
            //}
            //else
            //{
            //    if (vCD_TENDONVI == "" && ddlLOAICVPC.SelectedValue == "0")
            //        vCD_TENDONVI = "CVPC";
            //} 

            if (vNoichuyen == 2)
            {
                vCD_TENDONVI = txtNgoaitoaan.Text;
            }
            else
            {
                vCD_TENDONVI = null;
            }
            vLoaiSoVB = ddlLOAICVPC.SelectedValue;
            var toaCcId = Convert.ToDecimal(ddlToaAnCc.SelectedValue);

            //ddl_LOAI_GDTTT //--------------------
            decimal vLOAI_GDTTT = Convert.ToDecimal(ddl_LOAI_GDTTT.SelectedValue);
            DataTable oDT = oBL.GDTTT_DON_SEARCH_FOR_TOATOICAO(V_GET_LIS_ID, Drop_NDBD.SelectedValue, txt_NDBD.Text, Drop_NOI_NHAN_SEARCH.SelectedValue, Drop_TRANGTHAICHUYEN.SelectedValue, Drop_LOAI_VB_Search.SelectedValue, txt_SODEN_SEARCH.Text.Trim(), txt_SODEN_SEARCH_DEN.Text.Trim()
                   , txt_NGAY_FROM.Text.Trim(), txt_NGAY_TO.Text.Trim(), txt_NGUOI_GUI_BT_SEARCH.Text.Trim()
                   , Session[ENUM_SESSION.SESSION_USERID] + "", toaCcId, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui
                   , SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen, DiaChiCT
                   , vLoaiSoVB, SoVanBan, NgayVanBan, TraLoi, strNguoiNhap, vNoichuyen
                   , vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                   , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                   vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, vLOAI_GDTTT
                  , pageindex, page_size);
            return oDT;
        }
         private void Load_Data()
        {
            //lbtthongbao.Text = "";
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;
            DataTable oDT = getDS(0, false, false, false, false, false);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> đơn trong <b>" + hddTotalPage.Value + "</b> trang";
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
            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            dgList.DataSource = oDT;
            dgList.DataBind();

        }
        //-----
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
            SetGetSessionTK(true);

            lstDataUS.Value = Session[SS_TK.NGUOINHAP] + "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "call_fu_set", "ddlMultiSelect_fu_setvalue();", true);

            Decimal SoCV = String.IsNullOrEmpty(txtCV_So.Text) ? 0 : Convert.ToDecimal(txtCV_So.Text);
            if (SoCV > 0)
            {
            }
            else
            {
            }
        }
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            ///------------
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Session["DONID_CC"] = oGDTBL.GDTTT_DON_CC_REIDS();
            Session["VUVIECID_CC"] = null;
            //---------
            Response.Redirect("Thongtindon_cc.aspx?type=new");


        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    break;
                case "Xoa":
                    break;
                case "SoDonTrung":
                    //string StrMsgArr = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Lichsudon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    break;
                case "Lichsu":
                    //string StrMsg = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Lichsudon.aspx?vid=" + e.CommandArgument + "','Lịch sử quá trình chuyển đơn',1000,500);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
                case "XuLy":
                    Decimal id = Convert.ToDecimal(e.CommandArgument.ToString());
                    //GDTTT_DON oTT = dt.GDTTT_DON.Where(x => x.ID == id).FirstOrDefault();
                    var GDTTT_CC_TC_MAPPINGExist = DataExtensions.GetAllByDonId<GDTTT_CC_TC_MAPPING>(id).Count();
                    if (GDTTT_CC_TC_MAPPINGExist > 0)
                    {
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Đơn đã được xử lý!')", true);
                    }
                    else { Response.Redirect("Thongtindon.aspx?type=new&cc_id=" + e.CommandArgument.ToString()); }

                    break;
                case "NhieuDonTrung":
                    //string strThemDonTrung = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Themdontrung.aspx?vid=" + e.CommandArgument + "','Thêm đơn trùng',950,650);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), strThemDonTrung, true);
                    break;
                case "DonTrung":
                    //GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
                    //Session["DONID_CC"] = oGDTBL.GDTTT_DON_CC_REIDS();
                    //Session["VUVIECID_CC"] = null;
                    //Response.Redirect("Thongtindon_cc.aspx?type=dontrung&ID=" + e.CommandArgument.ToString());
                    break;
                case "Xemthem":
                    //string Strxt = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Noidungdon.aspx?vid=" + e.CommandArgument + "','Nội dung đơn',800,500);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), Strxt, true);
                    break;
                case "KQGQ":
                    //string Strkqgqt = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Ketquagiaiquyet.aspx?vid=" + e.CommandArgument + "','Nội dung đơn',600,350);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), Strkqgqt, true);
                    break;
                case "KINHTRINH":
                    //string StrKinhtrinh = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Kinhtrinh.aspx?vid=" + e.CommandArgument + "','Nội dung đơn',600,350);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrKinhtrinh, true);
                    break;
                case "BOSUNGTL":
                    //string StrBSTL = "PopupReport('/QLAN/GDTTT/Hoso/Popup/BoSungTL.aspx?vid=" + e.CommandArgument + "','Bổ sung tài liệu',800,450);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrBSTL, true);
                    break;
                case "YCBS":
                    //Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv();");
                    //string StrYCBS = "PopupReport('/QLAN/GDTTT/Hoso/Popup/YCBoSung.aspx?vid=" + e.CommandArgument + "&ycbs=1','Yêu cầu bổ sung',820,450);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrYCBS, true);
                    break;
                case "DSYCBS":
                    //Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv();");
                    //string StrDSYCBS = "PopupReport('/QLAN/GDTTT/Hoso/Popup/YCBoSung.aspx?vid=" + e.CommandArgument + "&ycbs=0','Danh sách yêu cầu bổ sung',820,600);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrDSYCBS, true);
                    break;
            }

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
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            Decimal ChucDanh_TPTATC = 0;
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            //----------------
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                CheckBox chkChon = (CheckBox)e.Item.FindControl("chkChon");
                LinkButton cmdKQGQ = (LinkButton)e.Item.FindControl("cmdKQGQ");
                Panel pn_TTGQ = (Panel)e.Item.FindControl("pn_TTGQ");
                Panel pn_TTGQ_VT = (Panel)e.Item.FindControl("pn_TTGQ_VT");
                Panel pn_TTNGDVG = (Panel)e.Item.FindControl("pn_TTNGDVG");
                Panel pn_TTNGDVG_VT = (Panel)e.Item.FindControl("pn_TTNGDVG_VT");
                Panel pn_TTD = (Panel)e.Item.FindControl("pn_TTD");
                Panel pn_TTD_VT = (Panel)e.Item.FindControl("pn_TTD_VT");
                Panel pn_THAOTAC = (Panel)e.Item.FindControl("pn_THAOTAC");
                //Panel pn_THAOTAC_VT = (Panel)e.Item.FindControl("pn_THAOTAC_VT");
                Panel pn_TTD_HCTP = (Panel)e.Item.FindControl("pn_TTD_HCTP");
                Panel pnDSYCBS = (Panel)e.Item.FindControl("pnDSYCBS");
                //------------------
                //ImageButton cmd_xuly_vt_vbd = (ImageButton)e.Item.FindControl("cmd_xuly_vt_vbd");
                String TRANG_THAI_XLY = ((DataRowView)e.Item.DataItem)["TRANG_THAI_XLY"].ToString();
                String CANBO_NHAN_ID = ((DataRowView)e.Item.DataItem)["CANBO_NHAN_ID"].ToString();
                String LOAIDON = ((DataRowView)e.Item.DataItem)["LOAIDON"].ToString();
                String YCBS = ((DataRowView)e.Item.DataItem)["YCBS"].ToString();

                if (LOAIDON == "5")
                {
                    chkChon.Visible = false;
                }
                else
                {
                    chkChon.Visible = true;
                }
                if (ddlHinhthucdon.SelectedValue == "5")
                {
                    chkChon.Visible = true;
                }
                if (TRANG_THAI_XLY == "3")//du lieu don thu chưa xử lý
                {
                    //cmd_xuly_vt_vbd.Visible = true;
                    pn_TTGQ.Visible = false;//Thông tin giải quyết
                    pn_TTGQ_VT.Visible = true;
                    pn_TTNGDVG.Visible = false;
                    pn_TTNGDVG_VT.Visible = true;
                    pn_TTD.Visible = false;
                    pn_TTD_VT.Visible = true;
                    pn_THAOTAC.Visible = false;
                    //pn_THAOTAC_VT.Visible = true;
                    pn_TTD_HCTP.Visible = false;
                }
                else
                {
                    //cmd_xuly_vt_vbd.Visible = false;
                    pn_TTGQ.Visible = true;
                    pn_TTGQ_VT.Visible = false;
                    pn_TTNGDVG.Visible = true;
                    pn_TTNGDVG_VT.Visible = false;
                    pn_TTD.Visible = true;
                    pn_TTD_VT.Visible = false;
                    pn_THAOTAC.Visible = true;
                    //pn_THAOTAC_VT.Visible = false;
                    pn_TTD_HCTP.Visible = true;
                    //-------------------------
                    //-------
                    //if (CANBO_NHAN_ID != "")//trường hợp đã nhận rồi thì không được xóa
                    //{
                    //    lbtXoa.Visible = false;
                    //    //lbtXoa.ImageUrl = "~/UI/img/delete_dis.png";
                    //}
                    //else
                    //{
                    //    lbtXoa.Visible = oPer.XOA;
                    //    //lbtXoa.ImageUrl = "~/UI/img/delete.png";
                    //}
                    //---------------
                    if (e.Item.Cells[9].Text == null || e.Item.Cells[9].Text == "&nbsp;")
                    {
                        //cmdKQGQ.Text = "Nhập kết quả giải quyết";
                    }
                    else if (e.Item.Cells[9].Text != null && e.Item.Cells[9].Text != "&nbsp;")
                    {
                        cmdKQGQ.Text = "<p style='color:#cc0000;'> KQ GQ: " + e.Item.Cells[9].Text + "</p>";//Đã có kết quả giải quyết
                    }
                    //if (ddlTrangthaichuyen.SelectedValue != "0" && ddlTrangthaichuyen.SelectedValue !="4")
                    //{
                    //    lbtXoa.Visible = false;
                    //    lblSua.ToolTip = "Chi tiết";
                    //}
                    if (oCB.CHUCDANHID == ChucDanh_TPTATC)//nếu là thẩm phán
                    {
                        cmdKQGQ.Visible = true;
                    }
                }
                if (YCBS != "")
                {
                    pnDSYCBS.Visible = true;
                }
                else pnDSYCBS.Visible = false;
            }
        }
        //protected void ddlTinh_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        LoadNG_Huyen();
        //    }
        //    catch (Exception ex) { lstSobanghiT.Text = lstSobanghiB.Text = ex.Message; }
        //}
        private void LoadPhongban()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID && (x.ISGIAIQUYETDON == 1 || x.ISGIAIQUYETDON == 2)).ToList();
            ddlPhongban.DataTextField = "TENPHONGBAN";
            ddlPhongban.DataValueField = "ID";
            ddlPhongban.DataBind();
            ddlPhongban.Items.Insert(0, new ListItem("--Chọn đơn vị--", "0"));
            //Load Loại án

        }
        private void LoadLoaiAn(decimal PBID)
        {
            ddlLoaiAn.Items.Clear();
            if (PBID > 0)
            {
                DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
                if (obj.ISHINHSU == 1) ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                if (obj.ISDANSU == 1) ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                if (obj.ISHANHCHINH == 1) ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                if (obj.ISHNGD == 1) ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                if (obj.ISPHASAN == 1) ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            }
            else
            {
                ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            }
            ddlLoaiAn.Items.Add(new ListItem("Chưa xác định", "55"));
            ddlLoaiAn.Items.Insert(0, new ListItem("Tất cả", "0"));
            //----------anhvh add 20/08/2020 check thêm nếu là phó chánh an thì chỉ lấy những loại án của PCA đó-------------------------
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
                        if (oCD.MA == "PCA")
                        {
                            ddlLoaiAn.Items.Clear();
                            LoadLoaiAnPhuTrach(oCB);
                        }
                    }
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
        private void LoadDropTinh()
        {

            //Load loại sổ văn bản
            DM_DATAITEM_BL soBL = new DM_DATAITEM_BL();
            DataTable tblso = soBL.DM_DATAITEM_GETBYGROUPNAME("QLSO");
            if (tblso.Rows.Count > 0)
            {
                //ddlLoaiso.DataSource = tblso;
                //ddlLoaiso.DataTextField = "TEN";
                //ddlLoaiso.DataValueField = "MA";
                //ddlLoaiso.DataBind();
                //ddlLoaiso.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

                //load tim kiem theo loai so 
                ddlLOAICVPC.DataSource = tblso;
                ddlLOAICVPC.DataTextField = "TEN";
                ddlLOAICVPC.DataValueField = "MA";
                ddlLOAICVPC.DataBind();
                ddlLOAICVPC.Items.FindByValue("SoCVC").Selected = true;
            }
            //List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            //if (lstTinh != null && lstTinh.Count > 0)
            //{
            //    ddlTinh.DataSource = lstTinh;
            //    ddlTinh.DataTextField = "TEN";
            //    ddlTinh.DataValueField = "ID";
            //    ddlTinh.DataBind();
            //}
            //ddlTinh.Items.Insert(0, new ListItem("--- Tỉnh/Thành phố ---", "0"));
            LoadNG_Huyen();

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //QT_NGUOIDUNG_BL oNDBL = new QT_NGUOIDUNG_BL();

            //chkNguoinhap.DataSource = oNDBL.QT_NGUOIDUNG_GETBYGDTTT(ToaAnID, 0, 0);
            //chkNguoinhap.DataTextField = "USERNAME";
            //chkNguoinhap.DataValueField = "USERNAME";
            //chkNguoinhap.DataBind();
            //manhnd thay
            GetUSERNHAP();

            LoadPhongban();

            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            ddlToaXetXu.DataSource = dtTA;
            ddlToaXetXu.DataTextField = "MA_TEN";
            ddlToaXetXu.DataValueField = "ID";
            ddlToaXetXu.DataBind();
            ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

            DataTable dtTA2 = oTABL.DM_TOAAN_GETBYNOTCUR(0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlToaKhac.DataSource = dtTA2;
            ddlToaKhac.DataTextField = "MA_TEN";
            ddlToaKhac.DataValueField = "ID";
            ddlToaKhac.DataBind();
            ddlToaKhac.Items.Insert(0, new ListItem("Các tòa địa phương", "-1"));
            ddlToaKhac.Items.Insert(0, new ListItem("--- Chọn tòa án --- ", "0"));
            //Load loại công văn
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
            //Load Thẩm phán
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI_TP(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN, Session[ENUM_SESSION.SESSION_CANBOID] + "");
            //----------------
            Decimal ChucDanh_TPTATC = 0;
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            //----------------
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            if (oCB.CHUCDANHID != ChucDanh_TPTATC)
            {
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            DataTable oCAPCA = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlChidao.DataSource = oCAPCA;
            ddlChidao.DataTextField = "MA_TEN";
            ddlChidao.DataValueField = "ID";
            ddlChidao.DataBind();
            //Load thêm Thẩm phán           
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
                    ddlChidao.Items.Add(new ListItem(r["HOTEN"] + "-Thẩm phán TANDTC", r["ID"] + ""));
                }
            }
            ddlChidao.Items.Insert(0, new ListItem("Tất cả lãnh đạo", "0"));
            ddlChidao.Items.Insert(0, new ListItem("Không có ý kiến chỉ đạo", "1"));
            ddlChidao.Items.Insert(0, new ListItem("---Tất cả--- ", "-1"));
        }
        private void LoadNG_Huyen()
        {
            ddlHuyen.Items.Clear();

            List<DM_HANHCHINH> lstTinhHuyen;
            if (Session["DMTINHHUYEN"] == null)
                lstTinhHuyen = dt.DM_HANHCHINH.OrderBy(x => x.ARRTHUTU).ToList();
            else
                lstTinhHuyen = (List<DM_HANHCHINH>)(Session["DMTINHHUYEN"]);
            ddlHuyen.DataSource = lstTinhHuyen;
            ddlHuyen.DataTextField = "MA_TEN";
            ddlHuyen.DataValueField = "ID";
            ddlHuyen.DataBind();
            ddlHuyen.Items.Insert(0, new ListItem("Tỉnh/Huyện", "0"));

        }

        private void LoadDropToaAnCC()
        {
            ddlToaAnCc.DataSource = dt.DM_TOAAN.Where(x => x.CAPCHAID == 1 && (x.ID == 5 || x.ID == 4 || x.ID == 6)).OrderBy(x => x.ARRTHUTU).ToList(); ;
            ddlToaAnCc.DataTextField = "TEN";
            ddlToaAnCc.DataValueField = "ID";
            ddlToaAnCc.DataBind();
        }

        protected void Drop_LOAICVPC_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void Drop_LoaiSo_SelectedIndexChanged(object sender, EventArgs e)
        {
            //if (ddlLoaiso.SelectedValue != "0")
            //{
            //    Layso_SoVB();
            //    //if (ddlLoaiso.SelectedValue == "SoGXN" || ddlLoaiso.SelectedValue == "SoCVC")
            //    //    ddlNoichuyenden.SelectedValue = "0"; //Noi bộ
            //    //else if (ddlLoaiso.SelectedValue == "SoCVCTK")
            //    //    ddlNoichuyenden.SelectedValue = "1"; //Tòa khác
            //    //else if (ddlLoaiso.SelectedValue == "SoCVCN")
            //    //    ddlNoichuyenden.SelectedValue = "-2"; //Ngoài tòa + Toa Khác
            //    //else if (ddlLoaiso.SelectedValue == "SoTralaidon")
            //    //    ddlNoichuyenden.SelectedValue = "3"; //Tra lai don

            //    LoadNoichuyenden();
            //    Load_Data();
            //}
            //else
            //{
            //}
        }

        private void Layso_SoVB()
        {
            //Load loại sổ văn bản
            //string vddlLoaiso = ddlLoaiso.SelectedValue;
            //DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //GDTTT_DON_BL oBL = new GDTTT_DON_BL();

            //txtBC_SoCV.Text = oBL.SOVB_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PhongBanID, dNgayCV.Year, vddlLoaiso).ToString();
            //txtBC_Ngaydk.Text = dNgayCV.ToString("dd/MM/yyyy");
        }

        protected void ddlNoichuyenden_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadNoichuyenden();
        }

        protected void LoadNoichuyenden()
        {
            switch (ddlNoichuyenden.SelectedValue)
            {
                case "0":
                    ddlPhongban.Visible = true;
                    ddlTrangthaidon.Visible = true;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;
                    break;
                case "1":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = true;
                    txtNgoaitoaan.Visible = false;
                    break;
                case "2":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = true;
                    break;
                case "3":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;
                    break;
                default:
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;
                    break;

            }
            //if (ddlNoichuyenden.SelectedValue != "-1" && Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]) == 4)
            //{
            //    decimal Trangthaidon = 0;
            //    if (ddlTrangthaidon.SelectedValue == "1" && ddlNoichuyenden.SelectedValue == "0")
            //        Trangthaidon = Convert.ToDecimal(ddlTrangthaidon.SelectedValue);
            //    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            //    txtBC_SoCV.Text = oBL.CV_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlNoichuyenden.SelectedValue), Trangthaidon).ToString();
            //    txtBC_Ngaydk.Text = DateTime.Now.ToString("dd/MM/yyyy");
            //}
            ShowButtonPrint();
        }

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
        private void ShowButtonPrint()
        {

            switch (ddlNoichuyenden.SelectedValue)
            {
                case "0":
                    decimal IDPhongBan = Convert.ToDecimal(ddlPhongban.SelectedValue);
                    if (IDPhongBan > 0)
                    {
                        DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == IDPhongBan).FirstOrDefault();
                        if (oPB.ISGIAIQUYETDON > 1)
                        {
                        }
                    }

                    if (ddlThuLy.SelectedValue == "1")
                    {
                    }
                    else
                    {
                    }

                    if (ddlTrangthaidon.SelectedValue == "0")
                    {
                        if (ddlThuLy.SelectedValue == "1")
                        {
                        }
                        else if (ddlThuLy.SelectedValue == "2")
                        {
                        }
                        else
                        {
                        }
                    }
                    else
                    {
                    }

                    break;
                case "1":
                    if (ddlToaKhac.SelectedValue == "0" || ddlTrangthaidon.SelectedValue == "3")
                    {
                    }
                    else
                    {
                    }
                    break;
                case "2":
                case "3":
                    break;
            }
        }
        protected void ddlPhongban_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowButtonPrint();
            LoadLoaiAn(Convert.ToDecimal(ddlPhongban.SelectedValue));
        }
        protected void ddlToaKhac_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowButtonPrint();
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
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPTINH":
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPCAO":
                        strDiadiem = strDiadiem.Replace("cấp cao", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                }
                return strDiadiem;
            }
            catch (Exception ex) { return ""; }
        }

        //In danh sách kết quả do cơ quan quốc hội
        protected void btnNBInKQ_QuocHoi_Click(object sender, EventArgs e)
        {
            Literal Table_Str_Totals = new Literal();
            String INSERT_PAGE_BREAK = "";
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
           // tbl = getDS_BC(9, false, true, false, false, false);
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

        private string reStr(string str)
        {
            if (str.Length == 1)
                str = "0" + str;
            return str;
        }
        protected void ddlTrangthaidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlNoichuyenden.SelectedValue != "-1" && Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]) == 4)
            {
                decimal Trangthaidon = 0;
                if (ddlTrangthaidon.SelectedValue == "1" && ddlNoichuyenden.SelectedValue == "0")
                    Trangthaidon = Convert.ToDecimal(ddlTrangthaidon.SelectedValue);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                //txtBC_SoCV.Text = oBL.CV_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlNoichuyenden.SelectedValue), Trangthaidon).ToString();
                //txtBC_Ngaydk.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }
            ShowButtonPrint();
            if (ddlTrangthaidon.SelectedValue == "4") Load_Data();
        }
        protected void ddlThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowButtonPrint();
        }

       
        protected void ddlTrangthaichuyen_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowButtonPrint();
        }
        void Update_DonChuyen(GDTTT_DON oT, Decimal PBID, String ArrDonTrung)
        {
            Decimal DonID = oT.ID;
            GDTTT_DON_CHUYEN objLS;
            List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID
            && x.DONVINHANID == oT.TOAANID
            && x.PHONGBANNHANID == oT.CD_TA_DONVIID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
            //List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == DonID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
            if (lstC.Count > 0)
                objLS = lstC[0];
            else
                objLS = new GDTTT_DON_CHUYEN();
            objLS.DONID = DonID;
            objLS.DONVICHUYENID = oT.TOAANID;
            objLS.PHONGBANCHUYENID = PBID;
            objLS.NGAYCHUYEN = DateTime.Now;
            objLS.TRANGTHAI = 1;//đã chuyển
            objLS.NGUOICHUYEN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            objLS.LOAICHUYEN = oT.CD_LOAI;
            //Lay thong tin Số Cong van chuyển  NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)'                
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            string vLoaiso = "";
            if (oT.CD_LOAI == 0)
                vLoaiso = "SoCVC";
            else
                vLoaiso = "SoCVCN";

            DataTable objVB = oBL.GET_DON_SOVANBAN(Convert.ToDecimal(oT.TOAANID), PBID, vLoaiso, DonID.ToString());
            if (objVB.Rows.Count > 0)
            {
                DateTime dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                objLS.SOCV = objVB.Rows[0]["SOVB"].ToString();
                objLS.NGAYCV = dNgayCV;
                objLS.NGUOIKY = objVB.Rows[0]["NGUOIKY"].ToString();
            }

            string[] strarr = ArrDonTrung.Split(',');
            objLS.SOLUONGDON = strarr.Length;//Số lượng đơn chuyển đến
            objLS.ARRDONTRUNG = ArrDonTrung;//Danh sách các đơn chuyển cùng 
            switch ((int)oT.CD_LOAI)
            {
                case 0:
                    objLS.DONVINHANID = oT.TOAANID;
                    objLS.PHONGBANNHANID = oT.CD_TA_DONVIID;
                    break;
                case 1:
                    objLS.DONVINHANID = oT.CD_TK_DONVIID;
                    objLS.PHONGBANNHANID = 0;
                    break;
            }
            if (lstC.Count == 0)
                dt.GDTTT_DON_CHUYEN.Add(objLS);
            dt.SaveChanges();
        }

        protected void lbtTTBC_Click(object sender, EventArgs e)
        {
            //if (pnTTBC.Visible)
            //{
            //    lbtTTBC.Text = "[ Mở ]";
            //    pnTTBC.Visible = false;
            //    Session["TTBCVISIBLE"] = "0";
            //}
            //else
            //{
            //    lbtTTBC.Text = "[ Đóng ]";
            //    pnTTBC.Visible = true;
            //    Session["TTBCVISIBLE"] = "1";
            //}
        }
        protected void lbt_vt_vbd_Click(object sender, EventArgs e)
        {
            if (pn_VT_VBD.Visible)
            {
                lbt_vt_vbd.Text = "[ Mở ]";
                pn_VT_VBD.Visible = false;
                Session["VT_VBD_VISIBLE"] = "0";
            }
            else
            {
                lbt_vt_vbd.Text = "[ Đóng ]";
                pn_VT_VBD.Visible = true;
                Session["VT_VBD_VISIBLE"] = "1";
            }
        }
        protected void lbtTTTK_Click(object sender, EventArgs e)
        {
            if (pnTTTK.Visible == false)
            {
                lbtTTTK.Text = "[ Thu gọn ]";
                pnTTTK.Visible = true;
                Session["TTTKVISIBLE"] = "0";
            }
            else
            {
                lbtTTTK.Text = "[ Nâng cao ]";
                pnTTTK.Visible = false;
                Session["TTTKVISIBLE"] = "1";
            }
            lstDataUS.Value = Session[SS_TK.NGUOINHAP] + "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "call_fu_set", "ddlMultiSelect_fu_setvalue();", true);
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            lstDataUS.Value = "";

            txtNguoigui.Text = "";
            txtSoQDBA.Text = "";
            txtNgayBAQD.Text = "";
            ddlToaXetXu.SelectedIndex = 0;
            txtNgayNhanTu.Text = "";
            txtNgayNhanDen.Text = "";

            ddlHuyen.SelectedIndex = 0;
            txtDiachi.Text = "";
            ddlTraloi.SelectedIndex = 0;
            ddlHinhthucdon.SelectedIndex = 0;
            txtSoCMND.Text = "";
            txtSohieudon.Text = "";
            ddlNoichuyenden.SelectedIndex = 0;
            ddlTrangthaidon.SelectedIndex = 0;
            txtNgaychuyenTu.Text = txtNgaychuyenDen.Text = "";
            ddlThuLy.SelectedIndex = 0;
            //ddlPhanloaiDdon.SelectedIndex = 0;
            txtCV_So.Text = "";
            txtCV_Ngay.Text = "";
            ddlTrangthaichuyen.SelectedIndex = 0;
            ddlChidao.SelectedIndex = 0;
            ddlTraigiam.SelectedIndex = 0;
            txtThuly_Tu.Text = txtThuly_Den.Text = txtThuly_So.Text = "";
            ddlLoaiCV.SelectedIndex = 0;
            ddlThamphan.SelectedIndex = 0;
            txtNgaynhapTu.Text = txtNgaynhapDen.Text = "";
            ddlLoaiAn.SelectedIndex = 0;
            ddlAnTuHinh.SelectedIndex = 0;
            ddlChuyentoi.SelectedIndex = 0;
            lbtthongbao.Text = string.Empty;
            Session["VUANID_CC"] = string.Empty;
            Session["VUVIECID_CC"] = string.Empty;
            //--------
            Drop_NOI_NHAN_SEARCH.SelectedValue = string.Empty;
            Drop_TRANGTHAICHUYEN.SelectedValue = string.Empty;
            Drop_LOAI_VB_Search.SelectedValue = string.Empty;
            txt_SODEN_SEARCH.Text = string.Empty;
            txt_SODEN_SEARCH_DEN.Text = string.Empty;
            txt_NGAY_FROM.Text = string.Empty;
            txt_NGAY_TO.Text = string.Empty;
            txt_NGUOI_GUI_BT_SEARCH.Text = string.Empty;
            //--------------------------------
            Session[SS_TK.NGUOIGUI] = string.Empty;
            //manhnd thay
            ddl_USER_ID.ClearSelection();
            lstDataUS.Value = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "call_fu_set", "ddlMultiSelect_fu_setvalue();", true);
            ddlNoichuyenden_SelectedIndexChanged(new object(), new EventArgs());
            //---------
            Drop_NDBD.SelectedValue = "0";
            txt_NDBD.Text = string.Empty;

        }
        protected void Drop_TRANGTHAICHUYEN_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session[SS_TK.TRANG_THAI_XLY_VT] = string.Empty;
        }

        public string CatXau(string str, int length)
        {
            if (str.Length > length)
            {
                if (str.Substring(length, 1) == " ")
                {
                    //Hết 1 từ
                    str = str.Substring(0, length);
                }
                else
                {
                    //Cắt giữa từ
                    str = str.Substring(0, length);
                    str = str.Substring(0, str.LastIndexOf(' '));
                }
                while (str.Substring(str.Length - 1, 1) == " ") str = str.Substring(0, str.Length - 1);
                str += "...";

            }

            return str;

        }
        void xoa_thongtinchuyen(Decimal CurrDonID, Decimal CurrDonViNhanID)
        {
            try
            {
                List<GDTTT_DON_CHUYEN> lstC = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == CurrDonID
                                                                            && x.DONVINHANID == CurrDonViNhanID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                if (lstC.Count > 0)
                {
                    GDTTT_DON_CHUYEN oC = lstC[0];
                    //Xóa thông tin đẫ chuyển từ bảng đơn chuyển
                    dt.GDTTT_DON_CHUYEN.Remove(oC);
                    dt.SaveChanges();

                }
            }
            catch (Exception ex) { }
        }

        // In phieu Rut hồ sơ
          //Chọn này để cấp số tự động
       
        protected void ExportData(string fileName, string path)
        {
            try
            {
                //copy to MemoryStream
                MemoryStream ms = new MemoryStream();
                using (FileStream fs = File.OpenRead(Path.Combine(path)))
                {
                    fs.CopyTo(ms);
                }

                //Delete file
                if (File.Exists(Path.Combine(path)))
                    File.Delete(Path.Combine(path));

                //Download file
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
                Response.BinaryWrite(ms.ToArray());
            }
            catch { }

            Response.End();
        }

        public void GetUSERNHAP()
        {
            ddl_USER_ID.ClearSelection();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            QT_NGUOIDUNG_BL oNDBL = new QT_NGUOIDUNG_BL();
            DataTable tbl = oNDBL.QT_NGUOIDUNG_GETBYGDTTT(ToaAnID, 0, 0);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddl_USER_ID.DataSource = tbl;
                ddl_USER_ID.DataTextField = "USERNAME";
                ddl_USER_ID.DataValueField = "USERNAME";
                ddl_USER_ID.DataBind();
            }
        }

        ////Khai them
        //private void UPDATE_QLSO(string soTB, decimal donID, decimal loaiVanBan)
        //{

        //    string nguoiKy = txtBC_Nguoiky.Text;

        //    GDTTT_HCTP_QLSO ql = new GDTTT_HCTP_QLSO();
        //    ql.ID = 0;
        //    ql.SO = soTB;
        //    if (txtBC_Ngaydk.Text + "" != "")
        //    {
        //        DateTime ngayTB = Convert.ToDateTime(txtBC_Ngaydk.Text);
        //        ql.NGAY = ngayTB;
        //    }
        //    ql.NGUOIKY = nguoiKy;
        //    ql.DONID = donID;
        //    GDTTT_DON donGDT = dt.GDTTT_DON.Where(x => x.ID == donID).FirstOrDefault();
        //    ql.SO_TT = donGDT.CD_SOTOTRINH;
        //    ql.NGAY_TT = donGDT.CD_NGAYTOTRINH;
        //    ql.LOAI = loaiVanBan;
        //    ql.NGAYTAO = DateTime.Now;
        //    ql.NGUOITAO = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

        //    GDTTT_DON_BL bl = new GDTTT_DON_BL();
        //    bl.GDTTT_HCTP_QLSO_UPDATE(ql);
        //}
    }
}
