using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Text;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.GSTP.QLAN.GDTTT.In;
using BL.GSTP.GDTTT;
using BL.GSTP.BANGSETGET;
using System.Web.Script.Serialization;
using System.IO;
using System.Configuration;
using Aspose.Words;
using DevExpress.CodeParser;
using DevExpress.XtraRichEdit.Import.Html;
using System.Net.NetworkInformation;

namespace WEB.GSTP.QLAN.GDTTT.Hoso
{
    public partial class Danhsachdon : System.Web.UI.Page
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
            scriptManager.RegisterPostBackControl(this.btnNBInTBC);
            scriptManager.RegisterPostBackControl(this.btnNBInTotrinh);
            scriptManager.RegisterPostBackControl(this.btnNBInDSTP);
            scriptManager.RegisterPostBackControl(this.btnNBInDS);
            scriptManager.RegisterPostBackControl(this.btnNBDSChuaDDK);
            scriptManager.RegisterPostBackControl(this.btnNBInDSTrung);
            scriptManager.RegisterPostBackControl(this.btnTKDanhsach);
            scriptManager.RegisterPostBackControl(this.btnNTADanhsach);
            scriptManager.RegisterPostBackControl(this.btnNBIn_KQ_Quoc_Hoi);
            scriptManager.RegisterPostBackControl(this.btnTKCoquan);
            scriptManager.RegisterPostBackControl(this.btnGXN);
            scriptManager.RegisterPostBackControl(this.btnNBInThongbao);
            scriptManager.RegisterPostBackControl(this.btnNBPhieuchuyen_TL_Lai);
            //-----------------
            if (!IsPostBack)
            {

                if ((Session["TTBCVISIBLE"] + "") == "1")
                {
                    lbtTTBC.Text = "[ Đóng ]";
                    pnTTBC.Visible = true;
                }
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
                SetGetSessionTK(false);

                if (Session[SS_TK.SOBAQD] != null)
                    Load_Data();


                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                Cls_Comon.SetButton(btnChuyendon, oPer.CAPNHAT);
                Cls_Comon.SetButton(btnThuHoi, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdSua, oPer.CAPNHAT);
                Cls_Comon.SetButton(cmdGopdon, oPer.CAPNHAT);
                //--------
                if (Session[ENUM_SESSION.SESSION_USERNAME] + "" == "tc.vanphonga")
                {
                    kq_QuocHoi.Visible = true;
                }
                pn_vanthu.Visible = true;

            }

        }
        protected void Load_Noi_NhanSearch()
        {
            Drop_NOI_NHAN_SEARCH.Items.Clear();
            Drop_NOI_NHAN_SEARCH.Items.Add(new ListItem("Văn Thư", Session[ENUM_SESSION.SESSION_DONVIID] + ""));//giá trị = 1 chỉ là để khác null để check
            //---------------
            Drop_NOI_NHAN_SEARCH.Items.Insert(0, new ListItem("---Tất cả---", ""));
        }

        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            ///------------
            GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
            Session["DONID_CC"] = null;
            Session["VUVIECID_CC"] = null;
            //---------
            Response.Redirect("Thongtindon.aspx?type=new");
            //-----------------------------------

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
            Response.Redirect("Thongtindon.aspx?ID=" + _Id + "&vt_id=" + _VANBANDEN_ID);
            //
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
                    Session[SS_TK.LOAICVPC] = ddlLOAICVPC.SelectedValue;
                    Session[SS_TK.BC_SOCV] = txtBC_SoCV.Text;
                    Session[SS_TK.BC_NGAYCV] = txtBC_Ngaydk.Text;
                    Session[SS_TK.BC_NGUOIKY] = ddlNguoiKy.SelectedValue;
                    Session[SS_TK.NGAYNHAPTU] = txtNgaynhapTu.Text;
                    Session[SS_TK.NGAYNHAPDEN] = txtNgaynhapDen.Text;
                    Session[SS_TK.THULY_TU] = txtThuly_Tu.Text;
                    Session[SS_TK.THULY_DEN] = txtThuly_Den.Text;
                    Session[SS_TK.SOTHULY] = txtThuly_So.Text;
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

                        txtBC_SoCV.Text = Session[SS_TK.BC_SOCV] + "";
                        txtBC_Ngaydk.Text = Session[SS_TK.BC_NGAYCV] + "";
                        ddlNguoiKy.SelectedValue = Session[SS_TK.BC_NGUOIKY] + "";

                        txtNgaynhapTu.Text = Session[SS_TK.NGAYNHAPTU] + "";
                        txtNgaynhapDen.Text = Session[SS_TK.NGAYNHAPDEN] + "";
                        if (Session[SS_TK.THAMPHAN] != null) ddlThamphan.SelectedValue = Session[SS_TK.THAMPHAN] + "";
                        if (Session[SS_TK.LOAICV] != null) ddlLoaiCV.SelectedValue = Session[SS_TK.LOAICV] + "";
                        if (Session[SS_TK.LOAICVPC] != null) ddlLOAICVPC.SelectedValue = Session[SS_TK.LOAICVPC] + "";
                        if (Session[SS_TK.ISTUHINH] != null) ddlAnTuHinh.SelectedValue = Session[SS_TK.ISTUHINH] + "";

                        txtThuly_Tu.Text = Session[SS_TK.THULY_TU] + "";
                        txtThuly_Den.Text = Session[SS_TK.THULY_DEN] + "";
                        txtThuly_So.Text = Session[SS_TK.SOTHULY] + "";

                        lstDataUS.Value = Session[SS_TK.NGUOINHAP] + "";
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "call_fu_set", "ddlMultiSelect_fu_setvalue();", true);
                        txtCVPC_So.Text = Session[SS_TK.CVPC_SO] + "";
                        txtCVPC_Ngay.Text = Session[SS_TK.CVPC_NGAY] + "";
                        txtCVPC_TenCQ.Text = Session[SS_TK.CVPC_TenCQ] + "";
                        Drop_NOI_NHAN_SEARCH.SelectedValue = Session[SS_TK.NOI_NHAN_SEARCH] + "";
                        if (Session[SS_TK.GUITOI_CA_TA] != null) ddlChuyentoi.SelectedValue = Session[SS_TK.GUITOI_CA_TA] + "";

                        ShowButtonPrint();
                    }
                }
            }
            catch (Exception ex) { }
        }
        private DataTable getDS(Decimal V_GET_LIS_ID, bool isCV, bool isOnPrint, bool isTraigiam, bool isChiDao, bool isTBQuahan)
        {
            try
            {
                int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                decimal isDonGoc = 1;
                if (txtSohieudon.Text != "" || txtThuly_So.Text != "" || ddlPhanloaiDdon.SelectedValue == "2")// txtNgaynhapTu.Text != "" || txtNgaynhapDen.Text != "" ||
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
                strNguoiNhap = strNguoiNhap.Replace(",,", ",");

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
                    if (txtBC_Ngaydk.Text != "")
                    {
                        vNgayQuahan = DateTime.Parse(txtBC_Ngaydk.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (vNgayQuahan == null) vNgayQuahan = DateTime.Now;
                    }
                }
                if (isTraigiam) vTraigiam = 1;
                int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
                int pageindex = Convert.ToInt32(hddPageIndex.Value);
                vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
                if (isOnPrint)
                {
                    pageindex = 1;
                    page_size = 0;//10000
                }
                decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                decimal vGuitoiCA_TA = Convert.ToDecimal(ddlChuyentoi.SelectedValue);
                string vCVPC_So = txtCVPC_So.Text.Trim(), vCVPC_Ngay = txtCVPC_Ngay.Text, vCVPC_TenCQ = txtCVPC_TenCQ.Text.Trim();

                if (vNoichuyen == 2)
                {
                    vCD_TENDONVI = txtNgoaitoaan.Text;
                }
                else
                {
                    vCD_TENDONVI = null;
                }
                vLoaiSoVB = ddlLOAICVPC.SelectedValue;


                decimal vLOAI_GDTTT = 0;
                lb_tongsodon.Text = "Tổng đơn";

                GdtttDonSearchOptimized oBL_op = new GdtttDonSearchOptimized();

                DataTable oDT = oBL.GDTTT_DON_SEARCH(V_GET_LIS_ID, null, null, Drop_NOI_NHAN_SEARCH.SelectedValue, Drop_TRANGTHAICHUYEN.SelectedValue, Drop_LOAI_VB_Search.SelectedValue, txt_SODEN_SEARCH.Text.Trim(), txt_SODEN_SEARCH_DEN.Text.Trim()
                       , txt_NGAY_FROM.Text.Trim(), txt_NGAY_TO.Text.Trim(), txt_NGUOI_GUI_BT_SEARCH.Text.Trim()
                       , Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui
                       , SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen, DiaChiCT
                       , vLoaiSoVB, SoVanBan, NgayVanBan, TraLoi, strNguoiNhap, vNoichuyen
                       , vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                       , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                       vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, vLOAI_GDTTT, pageindex, page_size);
                return oDT;
            }
            catch (Exception ex)
            {
                Hi_Errors.Value = ex.Message;
                DataTable oDT = new DataTable();
                return oDT;
            }
        }
        private DataTable getDS_CC(Decimal V_GET_LIS_ID, bool isCV, bool isOnPrint, bool isTraigiam, bool isChiDao, bool isTBQuahan)
        {
            try
            {
                int IsHome = (string.IsNullOrEmpty(Session[SS_TK.ISHOME] + "")) ? 0 : Convert.ToInt16(Session[SS_TK.ISHOME] + "");
                decimal isDonGoc = 1;
                if (txtSohieudon.Text != "" || txtThuly_So.Text != "" || ddlPhanloaiDdon.SelectedValue == "2")// txtNgaynhapTu.Text != "" || txtNgaynhapDen.Text != "" ||
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
                strNguoiNhap = strNguoiNhap.Replace(",,", ",");

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
                    if (txtBC_Ngaydk.Text != "")
                    {
                        vNgayQuahan = DateTime.Parse(txtBC_Ngaydk.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        if (vNgayQuahan == null) vNgayQuahan = DateTime.Now;
                    }
                }
                if (isTraigiam) vTraigiam = 1;
                int page_size = Convert.ToInt32(ddlPageCountCC.SelectedValue);
                int pageindex = Convert.ToInt32(hddPageIndexCC.Value);
                vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
                if (isOnPrint)
                {
                    pageindex = 1;
                    page_size = 0;//10000
                }
                decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                decimal vGuitoiCA_TA = Convert.ToDecimal(ddlChuyentoi.SelectedValue);
                string vCVPC_So = txtCVPC_So.Text.Trim(), vCVPC_Ngay = txtCVPC_Ngay.Text, vCVPC_TenCQ = txtCVPC_TenCQ.Text.Trim();

                if (vNoichuyen == 2)
                {
                    vCD_TENDONVI = txtNgoaitoaan.Text;
                }
                else
                {
                    vCD_TENDONVI = null;
                }
                vLoaiSoVB = ddlLOAICVPC.SelectedValue;


                decimal vLOAI_GDTTT = 0;
                lb_tongsodon.Text = "Tổng đơn";
                DataTable oDT = oBL.GDTTT_DON_SEARCH_CAPCAO_FROM_TOICAO(V_GET_LIS_ID, null, null, Drop_NOI_NHAN_SEARCH.SelectedValue, Drop_TRANGTHAICHUYEN.SelectedValue, Drop_LOAI_VB_Search.SelectedValue, txt_SODEN_SEARCH.Text.Trim(), txt_SODEN_SEARCH_DEN.Text.Trim()
                       , txt_NGAY_FROM.Text.Trim(), txt_NGAY_TO.Text.Trim(), txt_NGUOI_GUI_BT_SEARCH.Text.Trim()
                       , Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui
                       , SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen, DiaChiCT
                       , vLoaiSoVB, SoVanBan, NgayVanBan, TraLoi, strNguoiNhap, vNoichuyen
                       , vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                       , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                       vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, vLOAI_GDTTT, pageindex, page_size);
                return oDT;
            }
            catch (Exception ex)
            {
                Hi_Errors.Value = ex.Message;
                DataTable oDT = new DataTable();
                return oDT;
            }
        }

        private DataTable getDS_BC(Decimal mau_bc, bool isCV, bool isOnPrint, bool isTraigiam, bool isChiDao, bool isTBQuahan)
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
                SoCongVan = txtCV_So.Text.Trim(), NgayCongVan = txtCV_Ngay.Text,
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

            foreach (ListItem item in ddl_USER_ID.Items)
            {
                if (item.Selected)
                {
                    if (strNguoiNhap == "")
                        strNguoiNhap = item.Text;
                    else
                        strNguoiNhap = strNguoiNhap + "," + item.Text;

                }
            }
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
            string vCD_TENDONVI = txtNgoaitoaan.Text;
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
                if (txtBC_Ngaydk.Text != "")
                {
                    vNgayQuahan = DateTime.Parse(txtBC_Ngaydk.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (vNgayQuahan == null) vNgayQuahan = DateTime.Now;
                }
            }
            if (isTraigiam) vTraigiam = 1;
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);
            vLoaiCVID = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            if (isOnPrint)
            {
                pageindex = 1;
                page_size = 10000;
            }
            decimal vLoaiAn = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
            decimal vGuitoiCA_TA = Convert.ToDecimal(ddlChuyentoi.SelectedValue);
            string vCVPC_So = txtCVPC_So.Text.Trim(), vCVPC_Ngay = txtCVPC_Ngay.Text, vCVPC_TenCQ = txtCVPC_TenCQ.Text.Trim();
            //Dùng kết hợp trong trường hợp chọn số tờ trình
            if (vNoichuyen == 2)
            {
                vCD_TENDONVI = txtNgoaitoaan.Text;
            }
            else
            {
                vCD_TENDONVI = null;
            }
            String VLOAISOVB = ddlLOAICVPC.SelectedValue;
            DataTable oDT = new DataTable();
            if (mau_bc == 1)//Phiếu chuyển thụ lý mới
            {
                oDT = oBL.GDTTT_DON_SEARCH_THU_LY_MOI(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                       SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                       DiaChiCT, VLOAISOVB, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                       vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                       , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                       vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 2)//Tờ trình phân công
            {
                oDT = oBL.GDTTT_DON_SEARCH_TTRINH_PHANCONG(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                      SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                      DiaChiCT, VLOAISOVB, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                      vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 3)//DS đơn & TP giải quyết
            {
                if (vArrSelectID == "")
                {
                    DataTable oDTs = getDS(1, false, true, false, false, false);//25/09/2024
                    vArrSelectID = "," + oDTs.Rows[0]["LIST_ID"] + ",";
                }
                oDT = oBL.GDTTT_DON_TP_GIAI_QUYET(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                      SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                      DiaChiCT, VLOAISOVB, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                      vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 4)//Danh sách thụ lý mới
            {
                if (vArrSelectID == "")
                {
                    DataTable oDTs = getDS(1, false, true, false, false, false);//25/10/2024
                    vArrSelectID = "," + oDTs.Rows[0]["LIST_ID"] + ",";
                }
                oDT = oBL.GDTTT_DON_DS_TL_MOI(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                      SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                      DiaChiCT, VLOAISOVB, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                      vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                      , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                      vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 5)//Danh sách đơn chưa đủ điều kiện
            {
                oDT = oBL.GDTTT_DON_DS_DON_CHUA_DU_DK(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                 SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                 DiaChiCT, VLOAISOVB, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                 vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                 , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                 vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 6)//Danh sách đơn trùng
            {
                oDT = oBL.GDTTT_DON_TRUNG(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                DiaChiCT, VLOAISOVB, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 7)//Danh sách chuyển tòa án khác
            {
                oDT = oBL.GDTTT_DON_CHUYEN_TOA_AN_KHAC(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                DiaChiCT, VLOAISOVB, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 8)//Danh sách chuyển ngoài tòa
            {
                oDT = oBL.GDTTT_DON_CHUYEN_NGOAI_TOA(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                DiaChiCT, VLOAISOVB, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 9)//Danh sách Kết quả do cơ quan của quốc hội
            {
                oDT = oBL.GDTTT_DON_CHUYEN_CQ_QUOC_HOI(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                DiaChiCT, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 10)//In phiếu gửi cơ quan chuyển đơn
            {
                oDT = oBL.GDTTT_GUI_COQUAN_CHUYENDON(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                DiaChiCT, VLOAISOVB, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 11)//Giấy xác nhận
            {
                if (vArrSelectID == "")
                {
                    DataTable oDTs = getDS(1, false, true, false, false, false);//25/10/2024
                    vArrSelectID = "," + oDTs.Rows[0]["LIST_ID"] + ",";
                }
                oDT = oBL.GDTTT_DON_SEARCH_GIAY_XAC_NHAN(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                DiaChiCT, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }
            else if (mau_bc == 12)//Thong bao yeu cau bo sung don khong du điều kiện
            {
                oDT = oBL.GDTTT_DON_SEARCH_THONG_BAO_YCBSCC(txtBC_Ngaydk.Text, null, txtBC_SoCV.Text, Session[ENUM_SESSION.SESSION_USERID] + "", ToaAnID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui,
                SoCMND, TuNgay, DenNgay, HinhThucDon, SoHieuDon, DiaChiTinh, DiaChiHuyen,
                DiaChiCT, SoCongVan, NgayCongVan, TraLoi, strNguoiNhap, vNoichuyen,
                vTrangthai, vCD_DONVIID, vCD_TA_TRANGTHAI, vCD_TENDONVI, vNgaychuyenTu, vNgaychuyenDen, vArrSelectID, vIsThuLy, vPhanloaixuly
                , vNgayThulyTu, vNgayThulyDen, vSoThuly, vChidao, vTraigiam, vTBQuahan, vNgayQuahan, vThamphanID,
                vThamtravienID, vLoaiCVID, vNgayNhapTu, vNgayNhapDen, isDonGoc, vIsTuHinh, vLoaiAn, vCVPC_So, vCVPC_Ngay, vCVPC_TenCQ, vGuitoiCA_TA, pageindex, page_size);
            }

            return oDT;
        }
        private void Load_Data()//_ORDER
        {
            cmdSua.Visible = false;
            cmdGopdon.Visible = false;
            lbtthongbao.Text = "";
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;
            DataTable oDT = getDS(0, false, false, false, false, false);
            int count_all = 0;
            if (oDT != null)
            {
                if (oDT.Rows.Count > 0)
                    count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            }
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                //  lb_tongsodon.Visible = true;
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                cmdSua.Visible = true;
                cmdGopdon.Visible = true;
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
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    Session[SS_TK.ISHOME] = 1;
                    Session["DONID_CC"] = e.CommandArgument.ToString();
                    ////
                    Decimal _Id_d = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == _Id_d).FirstOrDefault();
                    if (obj.VUVIECID != null && obj.VUVIECID != 0)
                    {
                        Session["VUVIECID_CC"] = obj.VUVIECID;
                    }
                    else
                        Session["VUVIECID_CC"] = null;
                    Response.Redirect("Thongtindon.aspx?ID=" + e.CommandArgument.ToString());
                    //
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    String ND_id = e.CommandArgument.ToString();
                    String[] ND_id_arr = ND_id.Split(';');
                    decimal vID = Convert.ToDecimal(ND_id_arr[0]);
                    decimal SODON = Convert.ToDecimal(ND_id_arr[1]);
                    if (SODON > 1)
                    {
                        lbtthongbao.Text = "Bạn không thể xóa được nhóm đơn này, bạn phải hủy ghép đơn trước khi xóa!";
                        return;
                    }
                    else
                    {
                        Session["DONID_CC"] = e.CommandArgument.ToString();

                        GDTTT_DON odon = dt.GDTTT_DON.Where(x => x.ID == vID).FirstOrDefault();
                        if (odon.CD_TRANGTHAI == 4)
                        {
                            lbtthongbao.Text = "Đơn đã có số Công văn chuyển của Thẩm phán không được xóa!";
                            return;
                        }
                        else
                        {

                            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                            decimal V_IS_DONTRUNG = 1;
                            oBL.CHECK_ARR_DON_RETURN(vID, ref V_IS_DONTRUNG);
                            if (V_IS_DONTRUNG == 1)
                            {
                                lbtthongbao.Text = "Bạn không thể xóa được đơn này, bạn phải hủy ghép đơn trước khi xóa!";
                                return;
                            }
                            else if (V_IS_DONTRUNG == 0)
                            {
                                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == vID).FirstOrDefault();
                                if (oT.THAMPHANID > 0)
                                {
                                    lbtthongbao.Text = "Đơn đã phân công thẩm phán giải quyết, không được phép xóa !";
                                    return;
                                }
                                if (oT.ISCHUYENXULY == 1)
                                {
                                    lbtthongbao.Text = "Đơn đã được chuyển xử lý, không được phép xóa !";
                                    return;
                                }
                                if (dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == vID).ToList().Count > 0)
                                {
                                    lbtthongbao.Text = "Đơn đã có thông tin chuyển , không được phép xóa !";
                                    return;
                                }
                                //Nếu đơn của người khác tạo thì không được xóa
                                string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                if (oT.NGUOITAO.ToLower() != strUserName && strUserName != "tc.vanphong")
                                {
                                    lbtthongbao.Text = "Đơn do cán bộ khác thêm mới, không được phép xóa !";
                                    return;
                                }
                                foreach (GDTTT_DON t in dt.GDTTT_DON.Where(x => x.DONTRUNGID == oT.ID).ToList())
                                {
                                    t.DONTRUNGID = 0;
                                    t.SOLUONGDON = 1;
                                }
                                //Luu thong tin Don truoc khi xoa                            
                                var json = new JavaScriptSerializer().Serialize(oT);
                                ADS_DON_BL oBL_HIS = new ADS_DON_BL();
                                if (oBL_HIS.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oT.ID), 8, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "don Giam doc tham Don vi: " + CurrDonViID + " Phong: " + PhongBanID, "Xóa", json) == false)
                                {
                                    lbtthongbao.Text = "Xóa Don de nghi GDT,TT không thành công!";
                                    return;
                                }//Ket thuc 
                                 //---17/07/2024 add xoa ND,BD,NKN, DAN SU, HINH SU
                                XOA_ND_BD_NKN(vID);
                                //--------------
                                dt.GDTTT_DON.Remove(oT);
                                dt.SaveChanges();
                                dgList.CurrentPageIndex = 0;
                                hddPageIndex.Value = "1";
                                Load_Data();
                            }
                        }
                    }
                    break;
                case "don_chuadu_dk":
                    string StrMsgArr_dk = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Lichsudong_du_dk.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr_dk, true);
                    break;
                case "SoDonTrung":
                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Lichsudon.aspx?arrid=" + e.CommandArgument + "','Danh sách đơn trùng',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    break;
                case "Lichsu":
                    string StrMsg = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Lichsudon.aspx?vid=" + e.CommandArgument + "','Lịch sử quá trình chuyển đơn',1000,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
                case "NhieuDonTrung":
                    string strThemDonTrung = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Themdontrung.aspx?vid=" + e.CommandArgument + "','Thêm đơn trùng',950,650);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), strThemDonTrung, true);
                    break;
                case "DonTrung":
                    GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
                    Session["DONID_CC"] = null;
                    Session["VUVIECID_CC"] = null;
                    Response.Redirect("Thongtindon.aspx?type=dontrung&ID=" + e.CommandArgument.ToString());
                    break;
                case "ThuLyLai":
                    Response.Redirect("Thongtindon.aspx?type=dontrung&option=thulylai&ID=" + e.CommandArgument.ToString());
                    break;
                case "Xemthem":
                    string Strxt = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Noidungdon.aspx?vid=" + e.CommandArgument + "','Nội dung đơn',800,500);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), Strxt, true);
                    break;
                case "KQGQ":
                    string Strkqgqt = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Ketquagiaiquyet.aspx?vid=" + e.CommandArgument + "','Nội dung đơn',600,350);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), Strkqgqt, true);
                    break;
                case "KINHTRINH":
                    string StrKinhtrinh = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Kinhtrinh.aspx?vid=" + e.CommandArgument + "','Nội dung đơn',600,350);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrKinhtrinh, true);
                    break;
                case "BOSUNGTL":
                    string StrBSTL = "PopupReport('/QLAN/GDTTT/Hoso/Popup/BoSungTL.aspx?vid=" + e.CommandArgument + "','Bổ sung tài liệu',800,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrBSTL, true);
                    break;
                case "YCBS":
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv();");
                    string StrYCBS = "PopupReport('/QLAN/GDTTT/Hoso/Popup/YCBoSung.aspx?vid=" + e.CommandArgument + "&ycbs=1','Yêu cầu bổ sung',820,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrYCBS, true);
                    break;
                case "DSYCBS":
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "LoadModalDiv();");
                    string StrDSYCBS = "PopupReport('/QLAN/GDTTT/Hoso/Popup/YCBoSung.aspx?vid=" + e.CommandArgument + "&ycbs=0','Danh sách yêu cầu bổ sung',820,600);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrDSYCBS, true);
                    break;
            }
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            if (chkDanhSachCC.Checked == false)
            {
                divToiCao.Visible = true;
                divCapCao.Visible = false;
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                ddlLoaiso.SelectedValue = "0";
                Drop_LoaiSo_SelectedIndexChanged(new object(), new EventArgs());
                Load_Data();
                SetGetSessionTK(true);

                lstDataUS.Value = Session[SS_TK.NGUOINHAP] + "";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "call_fu_set", "ddlMultiSelect_fu_setvalue();", true);

                Decimal SoCV = String.IsNullOrEmpty(txtCV_So.Text) ? 0 : Convert.ToDecimal(txtCV_So.Text);

            }
            else
            {
                divToiCao.Visible = false;
                divCapCao.Visible = true;
                dgListCC.CurrentPageIndex = 0;
                hddPageIndexCC.Value = "1";
                ddlLoaiso.SelectedValue = "0";
                Drop_LoaiSo_SelectedIndexChanged(new object(), new EventArgs());
                Load_DataCC();
                //SetGetSessionTK(true);

                lstDataUS.Value = Session[SS_TK.NGUOINHAP] + "";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "call_fu_set", "ddlMultiSelect_fu_setvalue();", true);

                //Decimal SoCV = String.IsNullOrEmpty(txtCV_So.Text) ? 0 : Convert.ToDecimal(txtCV_So.Text);
            }

        }
        protected void lb_tongsodon_Click(object sender, EventArgs e)
        {
            //string vArrSelectID = "";
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable oDTs = getDS(2, false, true, false, false, false);
            if (oDTs != null)
            {
                //vArrSelectID = "," + oDTs.Rows[0]["LIST_ID"] + ",";
                //DataTable oDT=oBL.DON_SEARCH_TONDON(vArrSelectID);
                //lb_tongsodon.Text = "Tổng " + oDT.Rows[0]["V_DEM"] + " đơn";
                lb_tongsodon.Text = "Tổng " + oDTs.Rows[0]["TONG_SODON"] + " đơn";
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
                ImageButton lblSua = (ImageButton)e.Item.FindControl("cmdEdit");
                ImageButton lbtXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                LinkButton cmdKQGQ = (LinkButton)e.Item.FindControl("cmdKQGQ");
                LinkButton cmdNhieuDonTrung = (LinkButton)e.Item.FindControl("cmdNhieuDonTrung");
                LinkButton cmdDonTrung = (LinkButton)e.Item.FindControl("cmdDonTrung");
                LinkButton cmdLichsu = (LinkButton)e.Item.FindControl("cmdLichsu");
                LinkButton cmdSoDonTrung = (LinkButton)e.Item.FindControl("cmdSoDonTrung");
                Panel pn_TTGQ = (Panel)e.Item.FindControl("pn_TTGQ");
                Panel pn_TTGQ_VT = (Panel)e.Item.FindControl("pn_TTGQ_VT");
                Panel pn_TTNGDVG = (Panel)e.Item.FindControl("pn_TTNGDVG");
                Panel pn_TTNGDVG_VT = (Panel)e.Item.FindControl("pn_TTNGDVG_VT");
                Panel pn_TTD = (Panel)e.Item.FindControl("pn_TTD");
                Panel pn_TTD_VT = (Panel)e.Item.FindControl("pn_TTD_VT");
                Panel pn_THAOTAC = (Panel)e.Item.FindControl("pn_THAOTAC");
                Panel pn_THAOTAC_VT = (Panel)e.Item.FindControl("pn_THAOTAC_VT");
                Panel pnDSYCBS = (Panel)e.Item.FindControl("pnDSYCBS");
                //------------------
                ImageButton cmd_xuly_vt_vbd = (ImageButton)e.Item.FindControl("cmd_xuly_vt_vbd");
                String TRANG_THAI_XLY = ((DataRowView)e.Item.DataItem)["TRANG_THAI_XLY"].ToString();
                String CANBO_NHAN_ID = ((DataRowView)e.Item.DataItem)["CANBO_NHAN_ID"].ToString();
                String YCBS = ((DataRowView)e.Item.DataItem)["YCBS"].ToString();
                String CD_TA_TRANGTHAI = ((DataRowView)e.Item.DataItem)["CD_TA_TRANGTHAI"].ToString();
                String TONG_SODON = ((DataRowView)e.Item.DataItem)["TONG_SODON"].ToString();
                String LOAIDON = ((DataRowView)e.Item.DataItem)["LOAIDON"].ToString();
                if (TRANG_THAI_XLY == "3")//du lieu don thu chưa xử lý
                {
                    cmd_xuly_vt_vbd.Visible = true;
                    pn_TTGQ.Visible = false;//Thông tin giải quyết
                    pn_TTGQ_VT.Visible = true;
                    pn_TTNGDVG.Visible = false;
                    pn_TTNGDVG_VT.Visible = true;
                    pn_TTD.Visible = false;
                    pn_TTD_VT.Visible = true;
                    pn_THAOTAC.Visible = false;
                    pn_THAOTAC_VT.Visible = true;
                    cmdSoDonTrung.Enabled = false;
                }
                else
                {

                    cmd_xuly_vt_vbd.Visible = false;
                    pn_TTGQ.Visible = true;
                    pn_TTGQ_VT.Visible = false;
                    pn_TTNGDVG.Visible = true;
                    pn_TTNGDVG_VT.Visible = false;
                    pn_TTD.Visible = true;
                    pn_TTD_VT.Visible = false;
                    pn_THAOTAC.Visible = true;
                    pn_THAOTAC_VT.Visible = false;
                    //-------------------------
                    cmdSoDonTrung.Enabled = true;
                    lblSua.Visible = oPer.CAPNHAT;
                    if (CANBO_NHAN_ID != "")
                    {
                        lbtXoa.Visible = false;
                        //lbtXoa.ImageUrl = "~/UI/img/delete_dis.png";
                    }
                    else
                    {
                        lbtXoa.Visible = oPer.XOA;
                        //lbtXoa.ImageUrl = "~/UI/img/delete.png";
                    }
                    //---------------
                    if (e.Item.Cells[9].Text == null || e.Item.Cells[9].Text == "&nbsp;")
                    {
                        cmdKQGQ.Text = "Nhập kết quả giải quyết";
                    }
                    else if (e.Item.Cells[9].Text != null && e.Item.Cells[9].Text != "&nbsp;")
                    {
                        cmdKQGQ.Text = "<p style='color:#cc0000;'> KQ GQ: " + e.Item.Cells[9].Text + "</p>";//Đã có kết quả giải quyết
                    }
                    cmdDonTrung.Visible = true;
                    cmdLichsu.Visible = true;
                    if (oCB.CHUCDANHID == ChucDanh_TPTATC)//nếu là thẩm phán
                    {
                        //cmdNhieuDonTrung.Visible = false;
                        cmdDonTrung.Visible = false;
                        cmdLichsu.Visible = false;
                        cmdSoDonTrung.Enabled = false;
                        cmdKQGQ.Visible = true;
                    }
                }
                if (YCBS != "")
                {
                    pnDSYCBS.Visible = true;
                }
                else pnDSYCBS.Visible = false;
                if (CD_TA_TRANGTHAI == "0")//0 Đơn đủ điều kiện
                {
                    cmdDonTrung.Text = "Thêm đơn trùng";
                }
                if (CD_TA_TRANGTHAI == "1")//1 Đơn chưa đủ điều kiện
                {
                    cmdDonTrung.Text = "Thêm đơn và bổ sung tài liệu";
                }
                if (TONG_SODON != "")
                {
                    if (Convert.ToInt32(TONG_SODON) > 1)
                    {
                        cmdSoDonTrung.Enabled = true;
                    }
                    else
                    {
                        cmdSoDonTrung.Enabled = false;
                    }
                }
                cmdDonTrung.Visible = true;
                cmdNhieuDonTrung.Visible = true;
                if (LOAIDON == "4" || LOAIDON == "5")
                {
                    cmdDonTrung.Visible = false;
                    cmdNhieuDonTrung.Visible = false;
                }
            }
        }
        private void LoadPhongban()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            ddlPhongban.DataSource = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID && (x.ISGIAIQUYETDON == 1 || x.ISGIAIQUYETDON == 2)).ToList();
            ddlPhongban.DataTextField = "TEN_VIET_TAT";
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


            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            //Load loại sổ văn bản
            DM_DATAITEM_BL soBL = new DM_DATAITEM_BL();
            DataTable tblso = soBL.DM_DATAITEM_GETBYGROUPNAME("QLSO_HCTP_TC");
            if (tblso.Rows.Count > 0)
            {
                ddlLoaiso.DataSource = tblso;
                ddlLoaiso.DataTextField = "TEN";
                ddlLoaiso.DataValueField = "MA";
                ddlLoaiso.DataBind();
                ddlLoaiso.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

                //load tim kiem theo loai so
                ddlLOAICVPC.DataSource = tblso;
                ddlLOAICVPC.DataTextField = "TEN";
                ddlLOAICVPC.DataValueField = "MA";
                ddlLOAICVPC.DataBind();
                ddlLOAICVPC.Items.FindByValue("SoCVC").Selected = true;

                if (ddlLoaiso.SelectedValue == "0")
                {
                    ddlNguoiKy.Items.Clear();
                    ddlNguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                }
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

            if (oCBDT.Rows.Count > 1)
            {
                if (oCB.CHUCDANHID != ChucDanh_TPTATC)
                {
                    ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                }
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

        private void LoadDropNguoiKy()
        {
            // Load Ngườiky
            ddlNguoiKy.Items.Clear();
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlNguoiKy.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_ARR_CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), "023,022", ddlLoaiso.SelectedValue);
            ddlNguoiKy.DataTextField = "MA_TEN";
            ddlNguoiKy.DataValueField = "MA_TEN";
            ddlNguoiKy.DataBind();
            ddlNguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
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
        protected void ddlNoichuyenden_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (ddlNoichuyenden.SelectedValue)
            {
                case "0":
                    ddlPhongban.Visible = true;
                    ddlTrangthaidon.Visible = true;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;

                    divPrintNoibo.Visible = true;
                    divPrintToakhac.Visible = false;
                    divPrintNgoaiTA.Visible = false;
                    divPrintTralai.Visible = false;
                    break;
                case "1":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = true;
                    txtNgoaitoaan.Visible = false;


                    divPrintNoibo.Visible = false;
                    divPrintToakhac.Visible = true;
                    divPrintNgoaiTA.Visible = false;
                    divPrintTralai.Visible = false;
                    break;
                case "2":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = true;


                    divPrintNoibo.Visible = false;
                    divPrintToakhac.Visible = false;
                    divPrintNgoaiTA.Visible = true;
                    divPrintTralai.Visible = false;
                    break;
                case "3":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;

                    divPrintNoibo.Visible = false;
                    divPrintToakhac.Visible = false;
                    divPrintNgoaiTA.Visible = false;
                    divPrintTralai.Visible = true;
                    break;
                default:
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;

                    divPrintNoibo.Visible = false;
                    divPrintToakhac.Visible = false;
                    divPrintNgoaiTA.Visible = false;
                    divPrintTralai.Visible = false;
                    break;
            }
            if (ddlNoichuyenden.SelectedValue != "-1")
            {
                decimal Trangthaidon = 0;
                if (ddlTrangthaidon.SelectedValue == "1" && ddlNoichuyenden.SelectedValue == "0")
                    Trangthaidon = Convert.ToDecimal(ddlTrangthaidon.SelectedValue);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                txtBC_SoCV.Text = oBL.CV_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlNoichuyenden.SelectedValue), Trangthaidon).ToString();
                txtBC_Ngaydk.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }
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
                    divKhieunai.Visible = false;
                    divPrintNoibo.Visible = true;
                    decimal IDPhongBan = Convert.ToDecimal(ddlPhongban.SelectedValue);
                    if (IDPhongBan > 0)
                    {
                        DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == IDPhongBan).FirstOrDefault();
                        if (oPB.ISGIAIQUYETDON > 1)
                        {
                            divKhieunai.Visible = true;
                            divPrintNoibo.Visible = false;
                        }
                    }
                    setButtonPrint(true, btnNBInDS);
                    setButtonPrint(false, btnNBPhieuchuyen);
                    setButtonPrint(false, btnNBPhieuchuyen_TL_Lai);
                    if (ddlTrangthaidon.SelectedValue == "0")
                    {
                        if (ddlThuLy.SelectedValue == "1")
                        {
                            setButtonPrint(false, btnNBDSChuaDDK);
                            setButtonPrint(false, btnNBInThongbao);
                            setButtonPrint(false, btnNBInThongbaoTG);
                            setButtonPrint(true, btnNBInCoquanchuyendon);
                            setButtonPrint(false, btnNBTralai);
                            setButtonPrint(true, btnNBInTotrinh);
                            setButtonPrint(true, btnNBInTBC);
                            setButtonPrint(true, btnNBPhieuchuyen);
                            setButtonPrint(true, btnNBPhieuchuyen_TL_Lai);
                            setButtonPrint(true, btnNBInDSTP);
                            setButtonPrint(false, btnNBInDSTrung);
                            setButtonPrint(false, btnNBInPCTrung);
                            setButtonPrint(false, btnNBInTotrinhDT);
                        }
                        else if (ddlThuLy.SelectedValue == "2")
                        {
                            setButtonPrint(false, btnNBInDS);
                            setButtonPrint(false, btnNBDSChuaDDK);
                            setButtonPrint(false, btnNBInThongbao);
                            setButtonPrint(false, btnNBInThongbaoTG);
                            setButtonPrint(true, btnNBInCoquanchuyendon);
                            setButtonPrint(false, btnNBTralai);
                            setButtonPrint(false, btnNBInTotrinh);
                            setButtonPrint(false, btnNBInTBC);
                            setButtonPrint(false, btnNBPhieuchuyen);
                            setButtonPrint(false, btnNBPhieuchuyen_TL_Lai);
                            setButtonPrint(false, btnNBInDSTP);
                            setButtonPrint(true, btnNBInDSTrung);
                            setButtonPrint(true, btnNBInPCTrung);
                            setButtonPrint(true, btnNBInTotrinhDT);
                        }
                        else
                        {
                            setButtonPrint(true, btnNBInDS);
                            setButtonPrint(false, btnNBDSChuaDDK);
                            setButtonPrint(false, btnNBInThongbao);
                            setButtonPrint(false, btnNBInThongbaoTG);
                            setButtonPrint(true, btnNBInCoquanchuyendon);
                            setButtonPrint(false, btnNBTralai);
                            setButtonPrint(true, btnNBInTotrinh);
                            setButtonPrint(true, btnNBInTBC);
                            setButtonPrint(true, btnNBPhieuchuyen);
                            setButtonPrint(true, btnNBPhieuchuyen_TL_Lai);
                            setButtonPrint(true, btnNBInDSTP);
                            setButtonPrint(true, btnNBInDSTrung);
                            setButtonPrint(true, btnNBInPCTrung);
                            setButtonPrint(true, btnNBInTotrinhDT);
                        }
                    }
                    else
                    {
                        setButtonPrint(true, btnNBDSChuaDDK);
                        setButtonPrint(true, btnNBInThongbao);
                        setButtonPrint(true, btnNBInThongbaoTG);
                        setButtonPrint(false, btnNBInCoquanchuyendon);
                        setButtonPrint(true, btnNBTralai);
                        setButtonPrint(false, btnNBInTotrinh);
                        setButtonPrint(false, btnNBInTotrinhDT);
                        setButtonPrint(false, btnNBInTBC);
                        setButtonPrint(false, btnNBPhieuchuyen);
                        setButtonPrint(false, btnNBPhieuchuyen_TL_Lai);
                        setButtonPrint(false, btnNBInDSTP);
                        setButtonPrint(false, btnNBInDSTrung);
                        setButtonPrint(false, btnNBInPCTrung);
                    }

                    break;
                case "1":
                    if (ddlToaKhac.SelectedValue == "0" || ddlTrangthaidon.SelectedValue == "3")
                    {
                        setButtonPrint(true, btnTKPhieuchuyen);
                        setButtonPrint(true, btnTKPhieuchuyenN);
                        setButtonPrint(true, btnTKDanhsach);
                        setButtonPrint(true, btnTKDuongsu);
                        setButtonPrint(true, btnTKCoquan);
                    }
                    else
                    {
                        setButtonPrint(true, btnTKPhieuchuyen);
                        setButtonPrint(true, btnTKPhieuchuyenN);
                        setButtonPrint(true, btnTKDanhsach);
                        setButtonPrint(true, btnTKDuongsu);
                        setButtonPrint(true, btnTKCoquan);

                    }
                    divKhieunai.Visible = false;
                    break;
                case "2":
                case "3":
                    divKhieunai.Visible = false;
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
        //In danh sách chuyển ngoài tòa
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
        protected void btnNTADanhsach_Click_Older(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "NTA_DANHSACH";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                string strSOCV = txtBC_SoCV.Text;
                string strNgay = "", strThang = "", strNam = "";
                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                    strNam = dNgayCV.Year.ToString();
                }
                DTGDTTT objds = new DTGDTTT();
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TT = i.ToString();
                    r.TENDONVI = strTendonvi;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                    r.NOIDUNG = oT.NOIDUNGDON + "";
                    r.SO = oT.TB1_SO + "";
                    r.NGUOIKY = oT.CD_NGUOIKY + "";
                    if (oT.TB1_NGAY != null)
                    {
                        DateTime dtNTB1 = (DateTime)oT.TB1_NGAY;
                        r.NGAY = Cls_Comon.toFullNumber(dtNTB1.Day.ToString(), false);
                        r.THANG = Cls_Comon.toFullNumber(dtNTB1.Month.ToString(), true);
                        r.NAM = dtNTB1.Year.ToString();
                    }
                    r.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    if ((obj["arrCongvan"] + "") != "")
                    {
                        if ((obj["arrCongvan"] + "") != "")
                        {
                            string strCV = obj["arrCongvan"] + ")";
                            strCV = strCV.Replace("; )", "");
                            r.NGUOIGUI = r.NGUOIGUI + " (Do " + strCV + ")";
                        }


                    }
                    else if ((obj["LOAIDON"] + "") == "2")
                    {
                        r.NGUOIGUI = r.NGUOIGUI + " (Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                    }
                    r.DIACHIGUI = obj["Diachigui"] + "";
                    r.TENDONVINHAN = obj["NOICHUYEN"] + "";
                    r.SODON = obj["SODON"] + "";
                    r.GHICHU = obj["GHICHU"] + "";
                    objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                    objds.AcceptChanges();
                }
                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

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
        //In danh sách chuyển tòa án khác
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
        protected void btnTKDanhsach_Click_Older(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "TOAKHAC_PHIEUCHUYENDS";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                #endregion
                //DANH SÁCH đơn
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    DTGDTTT.DT_NOIBO_DANHSACHRow rds = objds.DT_NOIBO_DANHSACH.NewDT_NOIBO_DANHSACHRow();
                    rds.TT = i.ToString();
                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    if ((obj["arrCongvan"] + "") != "")
                    {
                        if ((obj["arrCongvan"] + "") != "")
                        {
                            string strCV = obj["arrCongvan"] + ")";
                            strCV = strCV.Replace("; )", "");
                            rds.NGUOIGUI = rds.NGUOIGUI + " (Do " + strCV + ")";
                        }


                    }
                    else if ((obj["LOAIDON"] + "") == "2")
                    {
                        rds.NGUOIGUI = rds.NGUOIGUI + " (Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                    }
                    rds.DIAPHUONG = obj["Diachigui"] + "";
                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    else//QĐKN
                    {
                        decimal DonID = Convert.ToDecimal(obj["ID"]);
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                        rds.BA_SO = oT.BAQD_SO + "";
                        rds.BA_NGAY = GetDate(oT.BAQD_NGAYBA + "");
                        if (oT.BAQD_TOAANID > 0)
                        {
                            try
                            {
                                DM_TOAAN oTXX = dt.DM_TOAAN.Where(x => x.ID == oT.BAQD_TOAANID).FirstOrDefault();
                                rds.BA_TOAXX = oTXX.MA_TEN;
                            }
                            catch (Exception ex) { }
                        }

                        rds.QD_SO = obj["BAQD_SO"] + "";
                        rds.QD_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.QD_NGAY != "")
                            rds.QD_NGAY = GetDate(rds.QD_NGAY);
                        rds.QD_NGUOIKN = obj["TOAXX"] + "";
                    }
                    rds.SOTOTRINH = obj["CD_SOCV"] + "";
                    rds.NGAYTOTRINH = GetDate(obj["CD_NGAYCV"]);
                    rds.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    rds.TENPHONGBANNHAN = obj["NOICHUYEN"] + "";
                    rds.SODON = obj["SODON"] + "";
                    rds.GHICHU = obj["GHICHU"] + "";
                    objds.DT_NOIBO_DANHSACH.AddDT_NOIBO_DANHSACHRow(rds);
                    objds.AcceptChanges();
                }
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        }
        protected void btnTLCoquan_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "TRALAI_THONGBAOCOQUAN";
            DataTable oDT = getDS(0, true, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có đơn kèm công văn";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                string strTendonvi = "", strPBGui = "", strDiachi = "", strDiadiem = "";

                strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();

                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                #endregion
                //DANH SÁCH đơn
                decimal DonID;
                DateTime dNgayCV;
                string strNgay = "", strThang = "", strNam = "", strSOCV = "", strNguoiKy = "", vLoaiso = "";
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    rds.DIACHI = obj["Diachigui"] + "";
                    rds.TENDONVI = strTendonvi;

                    DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    vLoaiso = "SoTralaidon";

                    DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                    if (objVB.Rows.Count > 0)
                    {
                        strSOCV = objVB.Rows[0]["SOVB"].ToString();
                        dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                        strNguoiKy = objVB.Rows[0]["NGUOIKY"].ToString();


                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }

                        rds.SOTOTRINH = strSOCV;
                        rds.NGAY = strNgay;
                        rds.THANG = strThang;
                        rds.NAM = strNam;
                        rds.NGUOIKY = strNguoiKy;
                    }

                    rds.DIADIEM = strDiadiem;

                    rds.TENPHONGBANGUI = strPBGui;
                    rds.GIOITINH = "";
                    rds.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            rds.GIOITINH = "ông";
                            rds.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            rds.GIOITINH = "bà";
                            rds.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                        rds.GIOITINH = "Các ông, bà";


                    rds.BAQD_LOAIQDBA_NAME = obj["BAQD_LOAIQDBA_NAME"].ToString();
                    rds.BAQD_CAPXETXU_NAME = obj["BAQD_CAPXETXU_NAME"].ToString().ToLower();
                    rds.BAQD_LOAIAN_NAME = obj["BAQD_LOAIAN_NAME"].ToString().ToLower();
                    rds.LOAIGDTT = obj["LOAIGDTT"].ToString().ToLower();

                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    if ((obj["CD_TRALAI_LYDOID"] + "") != "")
                    {
                        if ((obj["CD_TRALAI_LYDOID"] + "") == "0")
                        {
                            rds.LYDO = obj["CD_TRALAI_LYDOKHAC"] + "";
                        }
                        else
                        {
                            try
                            {
                                decimal IDDM = Convert.ToDecimal(obj["CD_TRALAI_LYDOID"]);
                                DM_DATAITEM obji = dt.DM_DATAITEM.Where(x => x.ID == IDDM).FirstOrDefault();
                                rds.LYDO = obji.TEN;
                            }
                            catch (Exception ex) { }
                        }
                    }
                    rds.SOCV = obj["CV_SO"] + "";
                    if (obj["CV_NGAY"] != null)
                        rds.NGAYCV = GetDate(obj["CV_NGAY"]);
                    rds.TENCOQUAN = obj["CV_TENDONVI"] + "";
                    rds.DIACHICOQUAN = obj["CVDIACHI"] + "";
                    rds.TENPHONGBANNHAN = obj["NOICHUYEN"] + "";
                    rds.DIACHIPHONGBAN = strDiachi;
                    rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                    objds.DT_NOIBO_THONGBAO.AddDT_NOIBO_THONGBAORow(rds);
                    objds.AcceptChanges();
                }
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        //Danh sách đơn trùng
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
        protected void btnNBInDSTrung_Click_Older(object sender, EventArgs e)
        {
            {
                SetGetSessionTK(true);
                Session["GDTTT_MABM"] = "NOIBO_TOTRINHDSTRUNG";
                DataTable oDT = getDS(0, false, true, false, false, false);
                if (oDT != null)
                {
                    if (oDT.Rows.Count == 0)
                    {
                        lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                        return;
                    }
                    #region "Thông tin tờ trình"
                    DTGDTTT objds = new DTGDTTT();
                    DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                    bool isUpdateSCV = false;
                    r.SOTOTRINH = txtBC_SoCV.Text;
                    if (r.SOTOTRINH != "")
                        isUpdateSCV = true;

                    string vNguoiKy = ddlNguoiKy.SelectedValue;
                    string v_chucvu = "";
                    string v_hoten = "";
                    if (ddlNguoiKy.SelectedValue != "0")
                    {
                        v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                        v_hoten = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                    }
                    r.NGUOIKY = v_hoten;
                    r.TUNGAY = txtNgaynhapTu.Text;
                    r.DENNGAY = txtNgaynhapDen.Text;
                    string strNgay = "", strThang = "", strNam = "";
                    DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if (dNgayCV != DateTime.MinValue)
                    {
                        strNgay = dNgayCV.Day.ToString();
                        strThang = dNgayCV.Month.ToString();
                        strNam = dNgayCV.Year.ToString();
                    }
                    r.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    //Phòng ban
                    r.TENPHONGBANGUI = "";
                    decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                    if (oNSD.PHONGBANID != null)
                    {
                        DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                        r.TENPHONGBANGUI = oPB.TENPHONGBAN;
                    }
                    if (ddlPhongban.SelectedValue != "0")
                        r.TENPHONGBANNHAN = ddlPhongban.SelectedItem.Text;
                    //ĐỊa điểm
                    string strDiadiem = "";
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                        strDiadiem = "Hà Nội";
                    else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    r.DIADIEM = strDiadiem;
                    #endregion
                    //DANH SÁCH đơn
                    int i = 0;
                    decimal SLDON = 0;
                    foreach (DataRow obj in oDT.Rows)
                    {
                        i += 1;
                        decimal vid = Convert.ToDecimal(obj["ID"]);
                        GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == vid).FirstOrDefault();
                        DTGDTTT.DT_NOIBO_DANHSACHRow rds = objds.DT_NOIBO_DANHSACH.NewDT_NOIBO_DANHSACHRow();
                        rds.TT = i.ToString();
                        rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                        rds.TENPHONGBANNHAN = obj["NOICHUYEN"] + "";
                        //rds.TUNGAY = txtNgaynhapTu.Text;
                        //rds.DENNGAY = txtNgaynhapDen.Text;

                        if ((obj["CD_SOCV"] + "") != "")
                        {
                            rds.NGUOIKY = obj["CD_NGUOIKY"].ToString();
                            DateTime vNgayCV = Convert.ToDateTime(obj["CD_NGAYCV"]);
                            rds.NGAY = vNgayCV.Day.ToString();
                            rds.THANG = vNgayCV.Month.ToString();
                            rds.NAM = vNgayCV.Year.ToString();
                            rds.SOTOTRINH = obj["CD_SOCV"].ToString();
                        }
                        else
                        {
                            //nếu chưa có số thì để rỗng
                            rds.NGUOIKY = "";
                            rds.NGAY = "";
                            rds.THANG = "";
                            rds.NAM = "";
                            rds.SOTOTRINH = "";
                        }

                        //rds.SOTOTRINH = txtBC_SoCV.Text;
                        //rds.NGAY = strNgay;
                        //rds.THANG = strThang;
                        //rds.NAM = strNam;
                        //rds.NGUOIKY = txtBC_Nguoiky.Text;
                        if ((obj["arrCongvan"] + "") != "")
                        {
                            string strCV = obj["arrCongvan"] + ")";
                            strCV = strCV.Replace("; )", "");
                            rds.NGUOIGUI = rds.NGUOIGUI + " (Do " + strCV + ")";
                        }
                        else if ((obj["LOAIDON"] + "") == "2")
                        {
                            rds.NGUOIGUI = rds.NGUOIGUI + " (Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                        }
                        rds.DIAPHUONG = obj["Diachigui"] + "";

                        if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                        {
                            rds.BA_SO = obj["BAQD_SO"] + "";
                            rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                            if (rds.BA_NGAY != "")
                                rds.BA_NGAY = GetDate(rds.BA_NGAY);
                            rds.BA_TOAXX = obj["TOAXX"] + "";
                        }
                        else//QĐKN
                        {
                            rds.QD_SO = obj["BAQD_SO"] + "";
                            rds.QD_NGAY = obj["BAQD_NGAYBA"] + "";
                            if (rds.QD_NGAY != "")
                                rds.QD_NGAY = GetDate(rds.QD_NGAY);
                            rds.QD_NGUOIKN = obj["TOAXX"] + "";
                        }

                        rds.NGAYNHANDON = obj["NGAYNHANDON"] + "";
                        if (rds.NGAYNHANDON != "")
                            rds.NGAYNHANDON = GetDate(rds.NGAYNHANDON);
                        rds.NGAYTHULY = obj["TL_NGAY"] + "";
                        if (rds.NGAYTHULY != "")
                            rds.NGAYTHULY = GetDate(rds.NGAYTHULY);
                        rds.SOTHULY = obj["TL_SO"] + "";
                        rds.SODON = obj["SODON"] + "";
                        if (rds.SODON != "")
                            SLDON = SLDON + Convert.ToDecimal(rds.SODON);

                        string strISNOTGDTTT = obj["ISNOTGDTTT"] + "";
                        if (strISNOTGDTTT == "1")

                            rds.GHICHU = obj["GHICHU"] + " - " + "(đơn không có nội dung GDT,TT)";
                        else
                            rds.GHICHU = obj["GHICHU"] + "";


                        objds.DT_NOIBO_DANHSACH.AddDT_NOIBO_DANHSACHRow(rds);
                        objds.AcceptChanges();

                    }
                    dt.SaveChanges();
                    r.TONGSO = SLDON.ToString();
                    objds.DT_NOIBO_TOTRINH.AddDT_NOIBO_TOTRINHRow(r);
                    objds.AcceptChanges();
                    Session["NOIBO_DATASET"] = objds;
                }
                string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
        }
        //Danh sách đơn chưa đủ điều kiện
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
        protected void btnNBDSChuaDDK_Click_Older(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "NOIBO_DSCHUADUDK";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                #endregion
                //DANH SÁCH đơn
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    DTGDTTT.DT_TRALAIRow rds = objds.DT_TRALAI.NewDT_TRALAIRow();
                    rds.TT = i.ToString();
                    rds.MADON = obj["MADON"] + "";
                    rds.DUONGSU = obj["DONGKHIEUNAI"] + "";
                    rds.DIACHI = obj["Diachigui"] + "";
                    if ((obj["CD_TA_LYDO_ISBAQD"] + "") == "1")//BA
                    {
                        rds.ISBAQD = "X";
                    }
                    if ((obj["CD_TA_LYDO_ISXACNHAN"] + "") == "1")//BA
                    {
                        rds.ISXACNHAN = "X";
                    }
                    rds.LYDOKHAC = obj["CD_TA_LYDO_KHAC"] + "";
                    rds.SOTBBS = obj["TB1_SO"] + "";
                    if ((obj["TB1_NGAY"] + "") != null)//BA
                    {
                        rds.NGAYTBBS = GetDate(obj["TB1_NGAY"] + "");
                    }
                    objds.DT_TRALAI.AddDT_TRALAIRow(rds);
                    objds.AcceptChanges();
                }
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Danh sách',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        }
        //In danh sách đơn thụ lý mới
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
        protected void btnNBInDS_Click_Older(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "NOIBO_TOTRINHDS";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                bool isUpdateSCV = false;
                r.SOTOTRINH = reStr(txtBC_SoCV.Text);
                if (r.SOTOTRINH != "")
                    isUpdateSCV = true;

                string vNguoiKy = ddlNguoiKy.SelectedValue;
                string v_chucvu = "";
                string strNguoiky = "";
                if (ddlNguoiKy.SelectedValue != "0")
                {
                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }
                r.NGUOIKY = strNguoiky;
                r.TUNGAY = txtNgaynhapTu.Text;
                r.DENNGAY = txtNgaynhapDen.Text;
                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    r.NGAY = dNgayCV.Day.ToString();
                    r.THANG = dNgayCV.Month.ToString();
                    r.NAM = dNgayCV.Year.ToString();
                }
                r.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                //Phòng ban
                r.TENPHONGBANGUI = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    r.TENPHONGBANGUI = oPB.TENPHONGBAN;
                }
                if (ddlPhongban.SelectedValue != "0")
                    r.TENPHONGBANNHAN = ddlPhongban.SelectedItem.Text;
                //ĐỊa điểm
                string strDiadiem = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                r.DIADIEM = strDiadiem;
                #endregion
                //DANH SÁCH đơn
                int i = 0;
                decimal SLDON = 0;

                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    decimal vid = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == vid).FirstOrDefault();
                    DTGDTTT.DT_NOIBO_DANHSACHRow rds = objds.DT_NOIBO_DANHSACH.NewDT_NOIBO_DANHSACHRow();

                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    rds.TENPHONGBANNHAN = obj["NOICHUYEN"] + "";
                    rds.TUNGAY = txtNgaynhapTu.Text;
                    rds.DENNGAY = txtNgaynhapDen.Text;
                    rds.NGUOIKY = strNguoiky;
                    if ((obj["arrCongvan"] + "") != "")
                    {

                        if ((obj["arrCongvan"] + "") != "")
                        {
                            string strCV = obj["arrCongvan"] + ")";
                            strCV = strCV.Replace("; )", "");
                            rds.NGUOIGUI = rds.NGUOIGUI + " (Do " + strCV + ")";
                        }
                    }
                    else if ((obj["LOAIDON"] + "") == "2")
                    {
                        rds.NGUOIGUI = rds.NGUOIGUI + " (Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                    }
                    rds.DIAPHUONG = obj["Diachigui"] + "";
                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    else//QĐKN
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    rds.NGAYNHANDON = obj["NGAYNHANDON"] + "";
                    if (rds.NGAYNHANDON != "")
                        rds.NGAYNHANDON = GetDate(rds.NGAYNHANDON);
                    rds.NGAYTHULY = obj["TL_NGAY"] + "";
                    if (rds.NGAYTHULY != "")
                        rds.NGAYTHULY = GetDate(rds.NGAYTHULY);
                    rds.SOTHULY = obj["TL_SO"] + "";
                    if (rds.SOTHULY.Length == 1)
                        rds.SOTHULY = "0" + rds.SOTHULY;
                    rds.TT = rds.SOTHULY;
                    if (rds.TT.Length == 1)
                        rds.TT = "000" + rds.TT;
                    else if (rds.TT.Length == 2)
                        rds.TT = "00" + rds.TT;
                    if (rds.TT.Length == 3)
                        rds.TT = "0" + rds.TT;
                    rds.SODON = obj["SODON"] + "";
                    if (rds.SODON != "")
                        SLDON = SLDON + Convert.ToDecimal(rds.SODON);
                    rds.GHICHU = obj["GHICHU"] + "";
                    rds.CD_SOCV = obj["CD_SOCV"] + "";
                    rds.CD_NGAYCV = GetDate(obj["CD_NGAYCV"]);
                    rds.NGAYTAO = DateTime.Parse(obj["NGAYNHAP"] + "", new CultureInfo("en-US"), DateTimeStyles.NoCurrentDateDefault);

                    objds.DT_NOIBO_DANHSACH.AddDT_NOIBO_DANHSACHRow(rds);
                    objds.AcceptChanges();

                }


                dt.SaveChanges();
                r.TONGSO = SLDON.ToString();
                objds.DT_NOIBO_TOTRINH.AddDT_NOIBO_TOTRINHRow(r);
                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
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
        protected void btnNBInDSTP_Click_Older(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "NOIBO_TOTRINHTPGQ";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                r.SOTOTRINH = txtBC_SoCV.Text;

                string vNguoiKy = ddlNguoiKy.SelectedValue;
                string v_chucvu = "";
                string strNguoiky = "";
                if (ddlNguoiKy.SelectedValue != "0")
                {
                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }

                r.NGUOIKY = strNguoiky;
                r.TUNGAY = txtNgaynhapTu.Text;
                r.DENNGAY = txtNgaynhapDen.Text;
                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    r.NGAY = dNgayCV.Day.ToString();
                    r.THANG = dNgayCV.Month.ToString();
                    r.NAM = dNgayCV.Year.ToString();
                }
                r.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                //Phòng ban
                r.TENPHONGBANGUI = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    r.TENPHONGBANGUI = oPB.TENPHONGBAN;
                }
                if (ddlPhongban.SelectedValue != "0")
                    r.TENPHONGBANNHAN = ddlPhongban.SelectedItem.Text;
                r.TONGSO = oDT.Rows.Count.ToString();
                objds.DT_NOIBO_TOTRINH.AddDT_NOIBO_TOTRINHRow(r);
                objds.AcceptChanges();
                #endregion
                //DANH SÁCH đơn
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {

                    decimal vid = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == vid).FirstOrDefault();
                    i += 1;
                    DTGDTTT.DT_NOIBO_DANHSACHRow rds = objds.DT_NOIBO_DANHSACH.NewDT_NOIBO_DANHSACHRow();
                    rds.TT = i.ToString();
                    rds.SOTOTRINH = d.CD_SOTOTRINH;
                    if (d.CD_NGAYTOTRINH != null) rds.NGAYTOTRINH = ((DateTime)d.CD_NGAYTOTRINH).ToString("dd/MM/yyyy");

                    rds.NGUOIKY = strNguoiky;
                    rds.TUNGAY = txtNgaynhapTu.Text;
                    rds.DENNGAY = txtNgaynhapDen.Text;
                    if (dNgayCV != DateTime.MinValue)
                    {
                        rds.NGAY = r.NGAY;
                        rds.THANG = r.THANG;
                        rds.NAM = r.NAM;
                    }
                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    if ((obj["LOAIDON"] + "") == "3")
                    {
                        rds.NGUOIGUI = rds.NGUOIGUI + " (Do " + obj["CV_TENDONVI"] + " chuyển đến theo Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                    }
                    else if ((obj["LOAIDON"] + "") == "2")
                    {
                        rds.NGUOIGUI = rds.NGUOIGUI + " (Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                    }
                    rds.DIAPHUONG = obj["Diachigui"] + "";
                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    else//QĐKN
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    rds.LOAIAN = obj["BAQD_LOAIAN"] + "";
                    rds.NGAYNHANDON = obj["NGAYNHANDON"] + "";
                    if (rds.NGAYNHANDON != "")
                        rds.NGAYNHANDON = GetDate(rds.NGAYNHANDON);
                    rds.NGAYTHULY = obj["TL_NGAY"] + "";
                    if (rds.NGAYTHULY != "")
                        rds.NGAYTHULY = GetDate(rds.NGAYTHULY);
                    rds.SOTHULY = obj["TL_SO"] + "";
                    if (rds.SOTHULY.Length == 1)
                        rds.SOTHULY = "0" + rds.SOTHULY;
                    rds.SODON = obj["SODON"] + "";
                    rds.TENTHAMPHAN = obj["TENTHAMPHAN"] + "";
                    rds.GHICHU = obj["GHICHU"] + "";
                    if (rds.TENTHAMPHAN != "") rds.TENTHAMPHAN = "Thẩm phán " + rds.TENTHAMPHAN;
                    objds.DT_NOIBO_DANHSACH.AddDT_NOIBO_DANHSACHRow(rds);
                    objds.AcceptChanges();
                }
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
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
        //Tờ trình phân công
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
        protected void btnNBInTotrinh_Click_older(object sender, EventArgs e)
        {
        }
        //in phiếu chuyển đơn thụ lý mới
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

        protected void btnNBInTotrinhDT_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);

            Session["GDTTT_MABM"] = "NOIBO_TOTRINH02";
            string strLoaiCV8_1 = "";
            if (ddlLoaiCV.SelectedValue != "-1" && ddlLoaiCV.SelectedValue != "0")
            {
                decimal IDLoai = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
                DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();
                if (oLoai.ID == 1023 || oLoai.CAPCHAID == 1023)
                {
                    strLoaiCV8_1 = " (do Đại biểu quốc hội, Các Cơ quan của Quốc hội, Đoàn đại biểu Quốc hội chuyển đến)";
                }
            }
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                DTGDTTT objds = new DTGDTTT();
                //ĐỊa điểm
                string strDiadiem = "", strDVGui = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strDVGui = oPB.TENPHONGBAN;
                }
                string strNgay = "", strThang = "", strNam = "";
                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    strNgay = dNgayCV.Day.ToString();
                    strThang = dNgayCV.Month.ToString();
                    strNam = dNgayCV.Year.ToString();
                }


                DataTable dtTP = oDT.AsEnumerable()
                           .AsParallel()
                           .GroupBy(r => new { NOICHUYEN = r["NOICHUYEN"] })
                           .Select(g => g.OrderBy(r => r["ID"]).First())
                           .CopyToDataTable();
                foreach (DataRow rt in dtTP.Rows)
                {
                    DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                    r.SOTOTRINH = reStr(txtBC_SoCV.Text);
                    string vNguoiKy = ddlNguoiKy.SelectedValue;
                    string v_chucvu = "";
                    string strNguoiky = "";
                    if (ddlNguoiKy.SelectedValue != "0")
                    {
                        v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                        strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                    }

                    r.NGUOIKY = strNguoiky;
                    r.NGAY = strNgay;
                    r.THANG = strThang;
                    r.NAM = strNam;
                    r.TUNGAY = txtNgaynhapTu.Text;
                    r.DENNGAY = txtNgaynhapDen.Text;
                    if (r.TUNGAY == "") r.TUNGAY = "         ";
                    if (r.DENNGAY == "") r.DENNGAY = "         ";
                    r.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    //Phòng ban
                    r.TENPHONGBANGUI = strDVGui;
                    r.TENPHONGBANNHAN = rt["NOICHUYEN"] + "";
                    r.DIADIEM = strDiadiem;
                    decimal vid = Convert.ToDecimal(rt["ID"]);
                    GDTTT_DON d = dt.GDTTT_DON.Where(x => x.ID == vid).FirstOrDefault();
                    if (txtBC_SoCV.Text == "")
                    {
                        r.SOTOTRINH = reStr(d.CD_SOTOTRINH) + "";
                        r.NGUOIKY = d.CD_NGUOIKY + "";
                        if (d.CD_NGAYTOTRINH != null)
                        {
                            DateTime dNgayTT = (DateTime)d.CD_NGAYTOTRINH;
                            r.NGAY = Cls_Comon.toFullNumber(dNgayTT.Day.ToString(), false);
                            r.THANG = Cls_Comon.toFullNumber(dNgayTT.Month.ToString(), true);
                            r.NAM = dNgayTT.Year.ToString();
                        }
                    }
                    r.LOAIDON8_1 = strLoaiCV8_1;
                    objds.DT_NOIBO_TOTRINH.AddDT_NOIBO_TOTRINHRow(r);
                    objds.AcceptChanges();
                }

                Session["NOIBO_DATASET"] = objds;

                string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
        }

        protected void btnNBPhieuchuyen_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            if (Check_Bao_Cao("btnNBPhieuchuyen") == true)
            {
                Session["GDTTT_MABM"] = "NOIBO_PHIEUCHUYEN_TOICAO";
                DataTable oDT = getDS(0, false, true, false, false, false);
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
                    ///----
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
                    //DataTable dtTP = oDT.AsEnumerable()
                    //                .AsParallel()
                    //               .GroupBy(r => new { TENTHAMPHAN = r["TENTHAMPHAN"], NOICHUYEN = r["NOICHUYEN"] })
                    //               .Select(g => g.OrderBy(r => r["ID"]).First())
                    //               .CopyToDataTable();


                    var seen = new HashSet<PrintThamPhan>();
                    var resultRows = new List<DataRow>();

                    foreach (DataRow row in oDT.Rows)
                    {
                        var key = new PrintThamPhan
                        {
                            TENTHAMPHAN = row["TENTHAMPHAN"].ToString(),
                            NOICHUYEN = row["NOICHUYEN"].ToString()
                        }; // <- Dấu ; ở đây để kết thúc lệnh tạo object

                        if (seen.Add(key))
                        {
                            resultRows.Add(row);
                        }
                    }

                    DataTable dtTP = resultRows.Count > 0
                        ? resultRows.CopyToDataTable()
                        : oDT.Clone();

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
                            r.TENTHAMPHAN = obj["TENTHAMPHAN"] + "";
                            r.TENPHONGBANNHAN = "- Đồng chí " + _phong + obj["NOICHUYEN"] + ".";
                            r.SOTOTRINH = reStr(obj["CD_SOTOTRINH"] + "");
                            r.NGAYTOTRINH = GetDate(obj["CD_NGAYTOTRINH"]);




                            //Kiểm tra các đơn có cùng 1 tờ trình không
                            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                            String vLoaiso = "TBTP";
                            DateTime dNgayCV;
                            decimal vThamphanid = Convert.ToDecimal(obj["THAMPHANID"]);
                            string DonID = obj["ID"].ToString();

                            DataTable objVB = oBL.GET_TBTP_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, vThamphanid, DonID.ToString());
                            if (objVB.Rows.Count > 0)
                            {

                                strSo = objVB.Rows[0]["SOVB"].ToString();
                                dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);

                                strNguoiky = objVB.Rows[0]["NGUOIKY"].ToString();
                                strChucVu = objVB.Rows[0]["CHUCVU"].ToString();
                                if (dNgayCV != DateTime.MinValue)
                                {
                                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                                    strNam = dNgayCV.Year.ToString();
                                }

                                r.SOTHONGBAO = strSo + "";
                                r.NGAY = strNgay;
                                r.THANG = strThang;
                                r.NAM = strNam;
                                r.NGUOIKY = strNguoiky;
                                r.CHUCVU = strChucVu;
                            }

                            string tenDonViTP = string.Empty;
                            string chucVuThamPhan = new GDTTT_DON_BL().GET_CHUC_DANH_BY_THAMPHANID(vThamphanid);
                            if (chucVuThamPhan == "TPBAC3")
                                tenDonViTP = "Tòa án nhân dân bậc 3";

                            r.TENDONVITHAMPHAN = string.IsNullOrEmpty(tenDonViTP) ? strTendonvi : tenDonViTP;
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
        protected void btnNBPhieuchuyen_TL_Lai_Click(object sender, EventArgs e)
        {
            //string fileNameSave = "TB_PhanCongTP_ThuLyLai.doc";//không check tờ trình, không check số thông báo, check thẩm phán
            SetGetSessionTK(true);
            if (Check_Bao_Cao("btnNBPhieuchuyen_TL_Lai") == true)
            {
                Session["GDTTT_MABM"] = "NOIBO_PHIEUCHUYEN_TOICAO_TLL";
                DataTable oDT = getDS(0, false, true, false, false, false);
                if (oDT != null)
                {
                    if (oDT.Rows.Count == 0)
                    {
                        lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                        return;
                    }
                    //ĐỊa điểm
                    string strSo = "", strDiadiem = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "", strTenPhongban = "";
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    {
                        strDiadiem = "Hà Nội";
                    }
                    else
                    {
                        strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    }
                    ///----
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
                    DataTable dtTP = oDT.AsEnumerable()
                                    .AsParallel()
                                   .GroupBy(r => new { TENTHAMPHAN = r["TENTHAMPHAN"], NOICHUYEN = r["NOICHUYEN"] })
                                   .Select(g => g.OrderBy(r => r["ID"]).First())
                                   .CopyToDataTable();


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
                                p.TENPHONGBANNHAN += "\n- Đồng chí " + _phong + obj["NOICHUYEN"] + ".";
                                objds.AcceptChanges();
                                break;
                            }
                        }
                        if (flag == false)
                        {
                            DTGDTTT.DT_NOIBO_PHIEUCHUYENRow r = objds.DT_NOIBO_PHIEUCHUYEN.NewDT_NOIBO_PHIEUCHUYENRow();
                            r.TENTHAMPHAN = obj["TENTHAMPHAN"] + "";
                            r.TENPHONGBANNHAN = "- Đồng chí " + _phong + obj["NOICHUYEN"] + ".";
                            r.SOTOTRINH = reStr(obj["CD_SOTOTRINH"] + "");
                            r.NGAYTOTRINH = GetDate(obj["CD_NGAYTOTRINH"]);


                            //Kiểm tra các đơn có cùng 1 tờ trình không
                            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                            String vLoaiso = "TBTP";
                            DateTime dNgayCV;
                            decimal vThamphanid = Convert.ToDecimal(obj["THAMPHANID"]);
                            string DonID = obj["ID"].ToString();

                            DataTable objVB = oBL.GET_TBTP_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, vThamphanid, DonID.ToString());
                            if (objVB.Rows.Count > 0)
                            {

                                strSo = objVB.Rows[0]["SOVB"].ToString();
                                dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);

                                strNguoiky = objVB.Rows[0]["NGUOIKY"].ToString();

                                if (dNgayCV != DateTime.MinValue)
                                {
                                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                                    strNam = dNgayCV.Year.ToString();
                                }

                                r.SOTHONGBAO = strSo + "";
                                r.NGAY = strNgay;
                                r.THANG = strThang;
                                r.NAM = strNam;
                                r.NGUOIKY = strNguoiky;
                            }

                            r.TENDONVI = strTendonvi;
                            r.TENPHONGBANGUI = strTenPhongban;
                            r.DIADIEM = strDiadiem;
                            r.TAND_NHAN = TAND_NHAN_;
                            r.TUNGAY = txtNgaynhapTu.Text;
                            r.DENNGAY = txtNgaynhapDen.Text;
                            objds.DT_NOIBO_PHIEUCHUYEN.AddDT_NOIBO_PHIEUCHUYENRow(r);
                            objds.AcceptChanges();
                        }
                    }
                    objds.AcceptChanges();
                    Session["NOIBO_DATASET"] = objds;
                    //DataTable v_dt = (DataTable)objds.DT_NOIBO_PHIEUCHUYEN;
                    //string saveAs = pathTemplateWord + "TB_PhanCongTP_ThuLyLai.doc";
                    //String fileName = pathTemplateWord + "rptTB_PhanCongTP_ThuLyLai.doc";

                    //Document v_doc = new Document(fileName);
                    //DocumentBuilder builder = new DocumentBuilder(v_doc);
                    //for (int i=0;i<v_dt.Rows.Count;i++)
                    //{
                    //    v_doc.MailMerge.Execute(new[] { "SOTHONGBAO" }, new[] { v_dt.Rows[i]["SOTHONGBAO"] });
                    //    v_doc.MailMerge.Execute(new[] { "NGAY" }, new[] { v_dt.Rows[i]["NGAY"] });
                    //    v_doc.MailMerge.Execute(new[] { "THANG" }, new[] { v_dt.Rows[i]["THANG"] });
                    //    v_doc.MailMerge.Execute(new[] { "NAM" }, new[] { v_dt.Rows[i]["NAM"] });

                    //    v_doc.MailMerge.Execute(new[] { "TUNGAY" }, new[] { txtNgaynhapTu.Text });
                    //    v_doc.MailMerge.Execute(new[] { "DENNGAY" }, new[] { txtNgaynhapDen.Text });

                    //    v_doc.MailMerge.Execute(new[] { "TENTHAMPHAN" }, new[] { v_dt.Rows[i]["TENTHAMPHAN"] });
                    //    v_doc.MailMerge.Execute(new[] { "TENDONVI" }, new[] { v_dt.Rows[i]["TENDONVI"] });
                    //    v_doc.MailMerge.Execute(new[] { "TENPHONGBANNHAN" }, new[] { v_dt.Rows[i]["TENPHONGBANNHAN"] });
                    //    v_doc.MailMerge.Execute(new[] { "TENPHONGBANGUI" }, new[] { v_dt.Rows[i]["TENPHONGBANGUI"] });
                    //    v_doc.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { v_dt.Rows[i]["NGUOIKY"] });
                    //    v_doc.MailMerge.Execute(new[] { "TAND_NHAN" }, new[] { v_dt.Rows[i]["TAND_NHAN"] });
                    //    //builder.InsertBreak(BreakType.SectionBreakNewPage);
                    //}
                    //v_doc.Save(saveAs);
                    //ExportData(fileNameSave, (string)saveAs);
                }
                string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
        }
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
        protected void btnLuuVB_Click(object sender, EventArgs e)
        {
            if ((txtBC_Ngaydk.Text == "" || txtBC_SoCV.Text == "" || ddlNguoiKy.SelectedValue == "0"))
            {
                //lbtthongbao.Text = "Chưa nhập đầy đủ thông tin số công văn, ngày chuyển, người ký!";
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
                    string donid_chon = null;
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            flag = true;
                            string strID = Item.Cells[0].Text;
                            if (donid_chon == null)
                                donid_chon = strID;
                            else
                                donid_chon = donid_chon + ',' + strID;
                        }

                    }

                    if (donid_chon != null
                        && ddlLoaiso.SelectedValue != "SoTT"
                        && ddlLoaiso.SelectedValue != "SoTTXX"
                        && ddlLoaiso.SelectedValue != "SoTT_TLL"
                        && ddlLoaiso.SelectedValue != "YCBS"
                        )
                    {
                        //Kiểm tra đơn đã có số chưa, nếu có rồi thì không cho thêm số
                        string[] strarr = donid_chon.Split(',');
                        if (strarr.Length > 0)
                        {
                            for (int k = 0; k < strarr.Length; k++)
                            {
                                decimal kID = Convert.ToDecimal(strarr[k]);
                                if (oBL.CHECK_DON_LUUSO(CurrDonViID, PhongBanID, ddlLoaiso.SelectedValue, kID) == true)
                                {
                                    mess = "alert('Đơn này đã Có Số " + ddlLoaiso.SelectedItem + "! Bạn kiểm tra lại')";
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                    return;
                                }
                            }
                        }
                    }
                    if (flag == false)
                    {
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chưa chọn đơn để thêm số Công văn!')", true);
                        //lbtthongbao.Text = "Chưa chọn đơn để thêm số Công văn!";
                        return;
                    }
                    // kiem tra Văn bản da ton tai chua CHECK_SOVANBAN ngoài Tờ trình
                    decimal vPHATHANHID = 0;
                    if (oBL.CHECK_SOVANBAN(CurrDonViID, PhongBanID, ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim()) == true
                        && ddlLoaiso.SelectedValue != "SoTT" && ddlLoaiso.SelectedValue != "SoTTXX" && ddlLoaiso.SelectedValue != "SoTT_TLL")
                    {
                        mess = "alert('Số" + ddlLoaiso.SelectedItem + " " + vCD_SOCV + " Ngày " + vCD_NGAYCV.ToString("dd/MM/yyyy") + " này đã tồn tại! Bạn kiểm tra lại')";
                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                    }
                    else
                    {
                        //Them giay xac nhan hoac //"TBCQ"  Thông báo gửi cơ quan chuyển đơn
                        if (ddlLoaiso.SelectedValue == "SoGXN" || ddlLoaiso.SelectedValue == "SoGXN_DV" || ddlLoaiso.SelectedValue == "TBCQ")
                        {
                            decimal vGXN = txtBC_SoCV.Text == "" ? 1 : Cls_Comon.GetNumber(txtBC_SoCV.Text);
                            //luu so 
                            foreach (DataGridItem Item in dgList.Items)
                            {
                                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                                if (chkChon.Checked)
                                {
                                    string vNguoiKy = ddlNguoiKy.SelectedValue;
                                    string v_chucvu = "";
                                    string v_hoten = "";
                                    if (ddlNguoiKy.SelectedValue != "0")
                                    {
                                        v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                                        v_hoten = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                                    }
                                    //insert vao So Van ban voi giay xac nhan khi chua cap so
                                    vPHATHANHID = oBL.SOVANBAN_INSERT(CurrDonViID, PhongBanID, 1, null, ddlLoaiso.SelectedValue, vGXN.ToString(), txtBC_Ngaydk.Text.Trim(),
                                        v_hoten, v_chucvu, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                    if (vPHATHANHID > 0)
                                    {
                                        string strID = Item.Cells[0].Text;
                                        decimal ID = Convert.ToDecimal(strID);
                                        //Insert sophathanh_don
                                        oBL.SOPHATHANH_DON_INSERT(vPHATHANHID, ID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                        //Nếu nhiều đơn thì tự động tăng 1 giá trị với số ban đầu
                                        vGXN = vGXN + 1;
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành việc thêm số Giấy xác nhận!')", true);

                                    }
                                    else
                                    {
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Lỗi thêm số Giấy xác nhận!')", true);
                                        break;
                                    }
                                }
                            }
                            Load_Data();
                        }
                        //Thêm số Tờ Trình phân công Thẩm phán
                        else if (ddlLoaiso.SelectedValue == "SoTT")
                        {
                            //Danh sach các đơn đã chọn
                            string[] strarrd = donid_chon.Split(',');
                            //Check don chua chuyen Or Don chua co Số tờ trình 
                            //Or chưa phân công Thẩm phán không được thêm Tờ trình
                            if (strarrd.Length > 0)
                            {
                                for (int k = 0; k < strarrd.Length; k++)
                                {
                                    decimal vdonID = Convert.ToDecimal(strarrd[k]);
                                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == vdonID).FirstOrDefault();
                                    if (oT.ISTHULY == 1 && oT.ARR_DON_ID != 0)
                                    {
                                        mess = "alert('Tờ trình đơn TLM không được chọn đơn TLM trùng TP')";
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                        return;
                                    }
                                    if (oT.LOAIDON == 4)
                                    {
                                        mess = "alert('Tờ trình đơn TLM không được chọn Hồ sơ KN VKS')";
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                        return;
                                    }
                                    if (oBL.CHECK_TOTRINH(CurrDonViID, PhongBanID, vdonID, "SoTT") > 0)
                                    {
                                        mess = "alert('Đơn đã có số Tờ Trình không được thêm! Bạn kiểm tra lại')";
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                        return;

                                    }
                                    else
                                    {
                                        if (oT.CD_TRANGTHAI == 1 || oT.CD_TRANGTHAI == 2)
                                        {
                                            mess = "alert('Đơn đã chuyển đi không thêm được Tờ Trình! Bạn kiểm tra lại')";
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                            return;
                                        }
                                        else if (oT.THAMPHANID == 0 || oT.THAMPHANID == null)
                                        {
                                            mess = "alert('Đơn chưa phân công Thẩm phán không thêm được Tờ Trình! Bạn kiểm tra lại')";
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                            return;
                                        }
                                    }

                                }
                            }

                            //Kiểm tra xem tờ trình đã có thông báo phân công thảm phán chưa, nếu chưa có thì mới được thêm
                            ///DataTable objTotrinh = oBL.Get_SOTOTRINH_DON(CurrDonViID, PhongBanID, donid_chon);
                            DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataTable objTT = oBL.GET_SOTOTRINH_SOVB(CurrDonViID, PhongBanID, ddlLoaiso.SelectedValue, vCD_SOCV, dNgayCV.Year);
                            //Neu to trinh da ton tai thi them đon vao to trinh
                            if (objTT.Rows.Count > 0)
                            {
                                // thêm đơn vào tờ trình đã có
                                //Lấy id tờ trình trong sổ văn bản

                                mess = "Cập nhật Số " + ddlLoaiso.SelectedItem + " thành công!";
                                //Insert sophathanh_don
                                if (strarrd.Length > 0)
                                {
                                    for (int k = 0; k < strarrd.Length; k++)
                                    {
                                        decimal kID = Convert.ToDecimal(strarrd[k]);
                                        decimal vSoID = Convert.ToDecimal(objTT.Rows[0]["ID"]);
                                        oBL.SOPHATHANH_DON_INSERT(vSoID, kID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                    }
                                }
                            }
                            else
                            {
                                string vNguoiKy = ddlNguoiKy.SelectedValue;
                                string v_chucvu = "";
                                string v_hoten = "";
                                if (ddlNguoiKy.SelectedValue != "")
                                {
                                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                                    v_hoten = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                                }
                                //Luu so to trinh khi chưa có tờ trình
                                vPHATHANHID = oBL.SOVANBAN_INSERT(CurrDonViID, PhongBanID, 1, null, ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim(),
                                    v_hoten, v_chucvu, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                if (vPHATHANHID > 0)
                                {
                                    mess = "Cập nhật Số " + ddlLoaiso.SelectedItem + " thành công!";
                                    //Insert sophathanh_don
                                    if (strarrd.Length > 0)
                                    {
                                        for (int k = 0; k < strarrd.Length; k++)
                                        {
                                            decimal kID = Convert.ToDecimal(strarrd[k]);
                                            oBL.SOPHATHANH_DON_INSERT(vPHATHANHID, kID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                        }
                                    }

                                }

                            }

                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành việc thêm số Tờ trình vào đơn!')", true);
                            Load_Data();

                        }
                        //Thêm số Tờ Trình xét xử GDT phân công Thẩm phán
                        else if (ddlLoaiso.SelectedValue == "SoTTXX")
                        {
                            //Danh sach các đơn đã chọn
                            string[] strarrd = donid_chon.Split(',');
                            //Check don chua chuyen Or Don chua co Số tờ trình 
                            //Or chưa phân công Thẩm phán không được thêm Tờ trình
                            if (strarrd.Length > 0)
                            {
                                for (int k = 0; k < strarrd.Length; k++)
                                {
                                    decimal vdonID = Convert.ToDecimal(strarrd[k]);
                                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == vdonID).FirstOrDefault();
                                    if (oT.LOAIDON != 4)
                                    {
                                        mess = "alert('Tờ trình xét xử GDTT không được chọn các loại đơn khác ngoài Hồ sơ kháng nghị VKS')";
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                        return;
                                    }
                                    if (oBL.CHECK_TOTRINH(CurrDonViID, PhongBanID, vdonID, "SoTTXX") > 0)
                                    {
                                        mess = "alert('Hồ sơ đã có số Tờ Trình không được thêm! Bạn kiểm tra lại')";
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                        return;

                                    }
                                    else
                                    {
                                        if (oT.CD_TRANGTHAI == 1 || oT.CD_TRANGTHAI == 2)
                                        {
                                            mess = "alert('Hố sơ đã chuyển đi không thêm được Tờ Trình! Bạn kiểm tra lại')";
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                            return;
                                        }
                                        else if (oT.THAMPHANID == 0 || oT.THAMPHANID == null)
                                        {
                                            mess = "alert('Hố sơ chưa phân công Thẩm phán không thêm được Tờ Trình! Bạn kiểm tra lại')";
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                            return;
                                        }
                                    }

                                }
                            }

                            //Kiểm tra xem tờ trình đã có thông báo phân công thảm phán chưa, nếu chưa có thì mới được thêm
                            ///DataTable objTotrinh = oBL.Get_SOTOTRINH_DON(CurrDonViID, PhongBanID, donid_chon);
                            DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataTable objTT = oBL.GET_SOTOTRINH_SOVB(CurrDonViID, PhongBanID, ddlLoaiso.SelectedValue, vCD_SOCV, dNgayCV.Year);
                            //Neu to trinh da ton tai thi them đon vao to trinh
                            if (objTT.Rows.Count > 0)
                            {
                                // thêm đơn vào tờ trình đã có
                                //Lấy id tờ trình trong sổ văn bản
                                mess = "Cập nhật Số " + ddlLoaiso.SelectedItem + " thành công!";
                                //Insert sophathanh_don
                                if (strarrd.Length > 0)
                                {
                                    for (int k = 0; k < strarrd.Length; k++)
                                    {
                                        decimal kID = Convert.ToDecimal(strarrd[k]);
                                        decimal vSoID = Convert.ToDecimal(objTT.Rows[0]["ID"]);
                                        oBL.SOPHATHANH_DON_INSERT(vSoID, kID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                    }
                                }

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
                                //Luu so to trinh khi chưa có tờ trình
                                vPHATHANHID = oBL.SOVANBAN_INSERT(CurrDonViID, PhongBanID, 1, null, ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim(),
                                    v_hoten, v_chucvu, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                if (vPHATHANHID > 0)
                                {
                                    mess = "Cập nhật Số " + ddlLoaiso.SelectedItem + " thành công!";
                                    //Insert sophathanh_don
                                    if (strarrd.Length > 0)
                                    {
                                        for (int k = 0; k < strarrd.Length; k++)
                                        {
                                            decimal kID = Convert.ToDecimal(strarrd[k]);
                                            oBL.SOPHATHANH_DON_INSERT(vPHATHANHID, kID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                        }
                                    }

                                }

                            }

                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành việc thêm số Tờ trình vào đơn!')", true);
                            Load_Data();

                        }
                        //Thêm số Tờ Trình phân công Thẩm phán
                        else if (ddlLoaiso.SelectedValue == "SoTT_TLL")//28/08/2024
                        {
                            //Danh sach các đơn đã chọn
                            string[] strarrd = donid_chon.Split(',');
                            //Check don chua chuyen Or Don chua co Số tờ trình 
                            //Or chưa phân công Thẩm phán không được thêm Tờ trình
                            if (strarrd.Length > 0)
                            {
                                for (int k = 0; k < strarrd.Length; k++)
                                {
                                    decimal vdonID = Convert.ToDecimal(strarrd[k]);
                                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == vdonID).FirstOrDefault();
                                    if (oT.ISTHULY == 1 && oT.ARR_DON_ID == 0)
                                    {
                                        mess = "alert('Tờ trình đơn TLM trùng TP không được chọn đơn TLM')";
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                        return;
                                    }
                                    if (oBL.CHECK_TOTRINH_TLL(CurrDonViID, PhongBanID, vdonID) > 0)
                                    {
                                        mess = "alert('Đơn đã có số Tờ Trình không được thêm! Bạn kiểm tra lại')";
                                        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                        return;
                                    }
                                    else
                                    {

                                        if (oT.CD_TRANGTHAI == 1 || oT.CD_TRANGTHAI == 2)
                                        {
                                            mess = "alert('Đơn đã chuyển đi không thêm được Tờ Trình! Bạn kiểm tra lại')";
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                            return;
                                        }
                                        else if (oT.THAMPHANID == 0 || oT.THAMPHANID == null)
                                        {
                                            mess = "alert('Đơn chưa phân công Thẩm phán không thêm được Tờ Trình! Bạn kiểm tra lại')";
                                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", mess, true);
                                            return;
                                        }
                                    }

                                }
                            }

                            //Kiểm tra xem tờ trình đã có thông báo phân công thảm phán chưa, nếu chưa có thì mới được thêm
                            ///DataTable objTotrinh = oBL.Get_SOTOTRINH_DON(CurrDonViID, PhongBanID, donid_chon);
                            DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            DataTable objTT = oBL.GET_SOTOTRINH_SOVB(CurrDonViID, PhongBanID, ddlLoaiso.SelectedValue, vCD_SOCV, dNgayCV.Year);
                            //Neu to trinh da ton tai thi them đon vao to trinh
                            if (objTT.Rows.Count > 0)
                            {
                                // thêm đơn vào tờ trình đã có
                                //Lấy id tờ trình trong sổ văn bản

                                mess = "Cập nhật Số " + ddlLoaiso.SelectedItem + " thành công!";
                                //Insert sophathanh_don
                                if (strarrd.Length > 0)
                                {
                                    for (int k = 0; k < strarrd.Length; k++)
                                    {
                                        decimal kID = Convert.ToDecimal(strarrd[k]);
                                        decimal vSoID = Convert.ToDecimal(objTT.Rows[0]["ID"]);
                                        oBL.SOPHATHANH_DON_INSERT(vSoID, kID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                    }
                                }

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
                                //Luu so to trinh khi chưa có tờ trình
                                vPHATHANHID = oBL.SOVANBAN_INSERT(CurrDonViID, PhongBanID, 1, null, ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim(),
                                    v_hoten, v_chucvu, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                if (vPHATHANHID > 0)
                                {
                                    mess = "Cập nhật Số " + ddlLoaiso.SelectedItem + " thành công!";
                                    //Insert sophathanh_don
                                    if (strarrd.Length > 0)
                                    {
                                        for (int k = 0; k < strarrd.Length; k++)
                                        {
                                            decimal kID = Convert.ToDecimal(strarrd[k]);
                                            oBL.SOPHATHANH_DON_INSERT(vPHATHANHID, kID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                        }
                                    }

                                }
                            }



                            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành việc thêm số Tờ trình vào đơn!')", true);
                            Load_Data();

                        }
                        //Them so thong báo
                        else if (ddlLoaiso.SelectedValue == "TBTP")
                        {
                            decimal Sothongbao = 0;
                            try
                            {
                                Sothongbao = Convert.ToDecimal(vCD_SOCV);
                            }
                            catch (Exception)
                            {
                                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Số thông báo phải là số!')", true);
                                return;
                            }
                            //Kiểm tra các đơn có cùng 1 tờ trình không
                            DataTable objTotrinh = oBL.Get_SOTOTRINH_DON(CurrDonViID, PhongBanID, donid_chon);
                            if (objTotrinh.Rows.Count == 0)
                            {
                                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Đơn phải có tờ trình!')", true);
                                return;
                            }
                            else if (objTotrinh.Rows.Count > 1)
                            {
                                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Các Đơn phải cùng một tờ trình!')", true);
                                return;
                            }
                            if (ddlThamphan.SelectedValue == "0")
                            {
                                //Insert so thong bao phan cong nhiều tham phan                                
                                string vDaySoTB = null;
                                //Lấy ra các TP cùng 1 tờ trình
                                DataTable oTP = oBL.GET_THAMPHAN(CurrDonViID, PhongBanID, "SoTT,SoTTXX,SoTT_TLL", donid_chon, objTotrinh.Rows[0]["SOVB"].ToString(), ((DateTime)objTotrinh.Rows[0]["NGAYVB"]).ToString("dd/MM/yyyy"));
                                foreach (DataRow row in oTP.Rows)
                                {
                                    string thamphanid = row["thamphanid"].ToString();
                                    //Lay ra ID so phat hanh 
                                    string vNguoiKy = ddlNguoiKy.SelectedValue;
                                    string v_chucvu = "";
                                    string v_hoten = "";
                                    if (ddlNguoiKy.SelectedValue != "0")
                                    {
                                        v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                                        v_hoten = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                                    }
                                    decimal vSOTB_ID = oBL.SOVANBAN_INSERT(CurrDonViID, PhongBanID, 1, thamphanid, ddlLoaiso.SelectedValue, Sothongbao.ToString(), txtBC_Ngaydk.Text.Trim(),
                                         v_hoten, v_chucvu, Session[ENUM_SESSION.SESSION_USERNAME] + "");


                                    if (vSOTB_ID > 0)
                                    {

                                        vDaySoTB = vDaySoTB + "; " + Sothongbao + "-" + txtBC_Ngaydk.Text;
                                        Sothongbao++;
                                        //Insert sophathanh_don
                                        string[] strarr = donid_chon.Split(',');
                                        if (strarr.Length > 0)
                                        {
                                            for (int k = 0; k < strarr.Length; k++)
                                            {
                                                decimal kID = Convert.ToDecimal(strarr[k]);
                                                decimal vthamphanid = Convert.ToDecimal(thamphanid);
                                                try
                                                {
                                                    GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == kID && x.THAMPHANID == vthamphanid).FirstOrDefault();
                                                    if (obj.ID > 0)
                                                        oBL.SOPHATHANH_DON_INSERT(vSOTB_ID, kID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                                }
                                                catch (Exception ex) { }
                                            }
                                        }
                                    }

                                }
                                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành việc thêm các Số Thông báo" + vDaySoTB + "!')", true);
                                Load_Data();
                                txtBC_SoCV.Text = Sothongbao.ToString();
                            }
                            else
                            {
                                //Insert so thong bao phan cong 1 tham phan
                                //insert vao So Van ban
                                string vNguoiKy = ddlNguoiKy.SelectedValue;
                                string v_chucvu = "";
                                string v_hoten = "";
                                if (ddlNguoiKy.SelectedValue != "0")
                                {
                                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                                    v_hoten = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                                }
                                decimal vSOTB_ID = oBL.SOVANBAN_INSERT(CurrDonViID, PhongBanID, 1, ddlThamphan.SelectedValue, ddlLoaiso.SelectedValue, Sothongbao.ToString(), txtBC_Ngaydk.Text.Trim(),
                                    v_hoten, v_chucvu, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                //Insert sophathanh_don
                                string[] strarr = donid_chon.Split(',');
                                if (strarr.Length > 0)
                                {
                                    for (int k = 0; k < strarr.Length; k++)
                                    {
                                        decimal kID = Convert.ToDecimal(strarr[k]);
                                        decimal vthamphanid = Convert.ToDecimal(ddlThamphan.SelectedValue);
                                        GDTTT_DON obj = dt.GDTTT_DON.Where(x => x.ID == kID && x.THAMPHANID == vthamphanid).FirstOrDefault();
                                        if (obj.ID > 0)
                                            oBL.SOPHATHANH_DON_INSERT(vSOTB_ID, kID, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                    }
                                }

                                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành việc thêm Số Thông báo " + Sothongbao.ToString() + "-" + txtBC_Ngaydk.Text.Trim() + "!')", true);
                                Load_Data();
                                txtBC_SoCV.Text = Sothongbao.ToString();
                            }
                        }
                        //Them yeu cau bo sung
                        else if (ddlLoaiso.SelectedValue == "YCBS")
                        {
                            decimal SoYCBS = 0;
                            try
                            {
                                SoYCBS = Convert.ToDecimal(vCD_SOCV);
                            }
                            catch (Exception)
                            {
                                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Số thông báo YCBS phải là số!')", true);
                                return;
                            }
                            //Kiểm tra chỉ cho chọn 1 đơn để thêm YCBS
                            if (donid_chon.IndexOf(",") != -1)
                            {
                                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Chỉ được chọn 1 đơn để thêm Yêu cầu bổ sung!')", true);
                                return;
                            }
                            else
                            {
                                decimal LanTB = oBL.YC_GETMAXLANTHU(Convert.ToDecimal(donid_chon));
                                decimal vDonid = Convert.ToDecimal(donid_chon);
                                GDTTT_DON_YEUCAU_BOSUNG oT = new GDTTT_DON_YEUCAU_BOSUNG();
                                GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == vDonid).FirstOrDefault();
                                //Check trùng số thông báo
                                DataTable objTB = oBL.CHECK_YEUCAU_SOTHONGBAO_TRUNG(oT.ID, vDonid, txtBC_SoCV.Text.Trim());
                                if (objTB.Rows.Count > 0)
                                {
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Số thông báo đã tồn tại. Hãy nhập lại!')", true);
                                    txtBC_SoCV.Focus();
                                    return;
                                }
                                //Check ngày thông báo
                                DataTable objNTB = oBL.CHECK_YEUCAU_NGAYTHONGBAO(oT.ID, vDonid, txtBC_Ngaydk.Text.Trim(), LanTB);
                                if (objNTB.Rows.Count > 0)
                                {
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Ngày thông báo không hợp lệ. Hãy nhập lại!')", true);
                                    txtBC_Ngaydk.Focus();
                                    return;
                                }

                                oT.DONID = vDonid;
                                oT.LANTHU = LanTB;
                                string vNguoiKy = ddlNguoiKy.SelectedValue;
                                string v_chucvu = "";
                                string v_hoten = "";
                                if (ddlNguoiKy.SelectedValue != "0")
                                {
                                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                                    v_hoten = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                                }
                                oT.NGUOIKY = v_hoten;
                                oT.NGAYTHONGBAO = DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                oT.SOTHONGBAO = txtBC_SoCV.Text.Trim();
                                oT.CD_TA_LYDO_ISBAQD = oDon.CD_TA_LYDO_ISBAQD;
                                oT.CD_TA_LYDO_ISXACNHAN = oDon.CD_TA_LYDO_ISXACNHAN;
                                oT.CD_TA_LYDO_ISKHAC = oDon.CD_TA_LYDO_ISKHAC;
                                oT.NOIDUNG = oDon.CD_TA_LYDO_KHAC;
                                oT.KETQUA = 0;
                                oT.NOIDUNGKQ = "";
                                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oBL.GDTTT_DON_YEUCAU_BOSUNG_INSERT_UPDAT(oT);

                                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành việc thêm các Số Thông báo Yêu cầu bổ sung!')", true);
                                Load_Data();
                            }

                        }
                        //Thêm các loại Công Văn
                        else
                        {
                            decimal vKiemtra = 0;
                            //Kiem tra don da chuyen phải dung voi loai so phat hanh
                            foreach (DataGridItem Item in dgList.Items)
                            {
                                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                                if (chkChon.Checked)
                                {

                                    string strID = Item.Cells[0].Text;
                                    decimal ID = Convert.ToDecimal(strID);
                                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();


                                    if (ddlLoaiso.SelectedValue == "SoGXN" || ddlLoaiso.SelectedValue == "SoCVC")
                                    {
                                        if (oT.CD_LOAI != 0) // khong phai la don chuyen Noi bộ thi dừng
                                        {
                                            vKiemtra = 1;
                                            break;
                                        }
                                    }
                                    else if (ddlLoaiso.SelectedValue == "SoCVCTK")
                                    {
                                        if (oT.CD_LOAI != 1) // khong phai la don chuyen Tòa khác thi dừng
                                        {
                                            vKiemtra = 1;
                                            break;
                                        }
                                    }
                                    else if (ddlLoaiso.SelectedValue == "SoCVCN")
                                    {
                                        if (oT.CD_LOAI != 2) // khong phai la don chuyen ngoai Tòa thi dừng
                                        {
                                            vKiemtra = 1;
                                            break;
                                        }
                                    }
                                    else if (ddlLoaiso.SelectedValue == "SoTralaidon")
                                    {
                                        if (oT.CD_LOAI != 3) // khong phai la don Tra lai don thi dừng
                                        {
                                            vKiemtra = 1;
                                            break;
                                        }
                                    }
                                }
                            }
                            if (vKiemtra == 0)
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
                                vPHATHANHID = oBL.SOVANBAN_INSERT(CurrDonViID, PhongBanID, 1, null, ddlLoaiso.SelectedValue, vCD_SOCV, txtBC_Ngaydk.Text.Trim(),
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
                                            //Insert sophathanh_don
                                            oBL.SOPHATHANH_DON_INSERT(vPHATHANHID, ID, Session[ENUM_SESSION.SESSION_USERNAME] + "");

                                        }
                                    }

                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Hoàn thành việc thêm số Văn bản vào đơn!')", true);
                                    Load_Data();

                                    //Hiển thị nút chuyển đơn
                                    btnChuyendon.Enabled = true;
                                    btnChuyendon.CssClass = "buttoninput";

                                }
                                else
                                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Cập nhật Số Văn bản lỗi. Liên hệ với quản trị để được hỗ trợ!')", true);
                            }
                            else
                            {
                                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Số Văn bản không cấp đúng với loại đơn. Hay kiểm tra lại!')", true);
                            }
                        }
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
            //SetGetSessionTK(true);

            //string StrMsg = "PopupReport('/QLAN/GDTTT/Hoso/Popup/SuaCongvan.aspx','Sửa đổi công văn',1150,800);";
            //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        private string reStr(string str)
        {
            if (str.Length == 1)
                str = "0" + str;
            return str;
        }
        protected void ddlTrangthaidon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlNoichuyenden.SelectedValue != "-1")
            {
                decimal Trangthaidon = 0;
                if (ddlTrangthaidon.SelectedValue == "1" && ddlNoichuyenden.SelectedValue == "0")
                    Trangthaidon = Convert.ToDecimal(ddlTrangthaidon.SelectedValue);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                txtBC_SoCV.Text = oBL.CV_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Convert.ToDecimal(ddlNoichuyenden.SelectedValue), Trangthaidon).ToString();
                txtBC_Ngaydk.Text = DateTime.Now.ToString("dd/MM/yyyy");
            }
            ShowButtonPrint();
            if (ddlTrangthaidon.SelectedValue == "4") Load_Data();
        }
        protected void ddlThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowButtonPrint();
        }
        protected void btnNBInThongbao_Click(object sender, EventArgs e)
        {
            if (CurrDonViID != 1)
            {
                Literal Table_Str_Totals = new Literal();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                //-------------
                tbl = getDS_BC(12, false, true, false, false, false);
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                    //Table_Str_Totals.Text = "<table></table>";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=THONG_BAO_YCBS.doc");
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
            else
            {
                SetGetSessionTK(true);
                decimal IDPBNhan = Convert.ToDecimal(ddlPhongban.SelectedValue);
                Session["GDTTT_MABM"] = "NOIBO_THONGBAOLD";
                DataTable oDT = getDS(0, false, true, false, false, false);
                bool hasAdd = false;
                if (oDT != null)
                {
                    if (oDT.Rows.Count == 0)
                    {
                        lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                        return;
                    }
                    #region "Thông tin tờ trình"
                    DTGDTTT objds = new DTGDTTT();
                    string strTendonvi = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                    DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();

                    strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                    string strHauto = "";
                    if (oNSD.PHONGBANID != null)
                    {
                        DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                        if (oPB != null)
                        {
                            strDiachi = oPB.DIACHI + "";
                            strHauto = oPB.HAUTOCV + "";
                        }

                    }
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                        strDiadiem = "Hà Nội";
                    else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    decimal sotb = Cls_Comon.GetNumber(txtBC_SoCV.Text);
                    #endregion
                    string TAND_NHAN_ = "";
                    if (Session["CAP_XET_XU"] + "" == "TOICAO")
                    {
                        TAND_NHAN_ = "TANDTC";
                    }
                    else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        TAND_NHAN_ = "TANDCC";
                    }
                    //DANH SÁCH đơn
                    foreach (DataRow obj in oDT.Rows)
                    {
                        decimal DonID = Convert.ToDecimal(obj["ID"]);
                        GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        DataTable oYC = oBL.YEUCAUBOSUNG(DonID);
                        if (oYC.Rows.Count == 0)
                        {

                            string vNguoiKy = ddlNguoiKy.SelectedValue;
                            string v_chucvu = "";
                            if (ddlNguoiKy.SelectedValue != "0")
                            {
                                v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                                strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                            }

                            if (dNgayCV != DateTime.MinValue)
                            {
                                strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                                strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                                strNam = dNgayCV.Year.ToString();
                            }
                            strSo = sotb.ToString();
                            hasAdd = true;
                            sotb = sotb + 1;
                            GDTTT_DON_YEUCAU_BOSUNG oY = new GDTTT_DON_YEUCAU_BOSUNG();
                            oY.ID = 0;
                            oY.DONID = oT.ID;
                            oY.LANTHU = 1;
                            oY.NGUOIKY = strNguoiky;
                            oY.NGAYTHONGBAO = dNgayCV;
                            oY.SOTHONGBAO = strSo;
                            oY.CD_TA_LYDO_ISBAQD = oT.CD_TA_LYDO_ISBAQD;
                            oY.CD_TA_LYDO_ISXACNHAN = oT.CD_TA_LYDO_ISXACNHAN;
                            oY.CD_TA_LYDO_ISKHAC = oT.CD_TA_LYDO_ISKHAC;
                            oY.NOIDUNG = oT.CD_TA_LYDO_KHAC;
                            oY.KETQUA = 0;
                            oY.NGAYBOSUNG = DateTime.MinValue;
                            oY.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";  
                            oBL.GDTTT_DON_YEUCAU_BOSUNG_INSERT_UPDAT(oY);
                        }
                        else
                        {
                            DataTable oCheck = oBL.CHECK_YEUCAU_SOTB_NGAYTB(oT.ID, sotb.ToString(), txtBC_Ngaydk.Text);
                            if (oYC.Rows.Count == 1 && ddlTrangthaidon.SelectedValue == "4" && oCheck.Rows.Count == 0)
                            {
                                strNguoiky = oYC.Rows[0]["NGUOIKY"] + "";
                                if (dNgayCV != DateTime.MinValue)
                                {
                                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                                    strNam = dNgayCV.Year.ToString();
                                }
                                strSo = sotb.ToString();
                                hasAdd = true;
                                sotb = sotb + 1;
                                GDTTT_DON_YEUCAU_BOSUNG oY = new GDTTT_DON_YEUCAU_BOSUNG();
                                oY.ID = 0;
                                oY.DONID = oT.ID;
                                oY.LANTHU = 2;
                                oY.NGUOIKY = strNguoiky;
                                oY.NGAYTHONGBAO = dNgayCV;
                                oY.SOTHONGBAO = strSo;
                                oY.CD_TA_LYDO_ISBAQD = oT.CD_TA_LYDO_ISBAQD;
                                oY.CD_TA_LYDO_ISXACNHAN = oT.CD_TA_LYDO_ISXACNHAN;
                                oY.CD_TA_LYDO_ISKHAC = oT.CD_TA_LYDO_ISKHAC;
                                oY.NOIDUNG = oT.CD_TA_LYDO_KHAC;
                                oY.KETQUA = 0;
                                oY.NGAYBOSUNG = DateTime.MinValue;
                                oY.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                oBL.GDTTT_DON_YEUCAU_BOSUNG_INSERT_UPDAT(oY);
                            }
                            else
                            {
                                strSo = oYC.Rows[0]["SOTHONGBAO"] + "";
                                //sotb = Cls_Comon.GetNumber(strSo);
                                strNguoiky = oYC.Rows[0]["NGUOIKY"] + "";
                                dNgayCV = Convert.ToDateTime(oYC.Rows[0]["NGAYTHONGBAO"] + "");
                                strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                                strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                                strNam = dNgayCV.Year.ToString();
                            }
                        }

                        DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                        rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                        rds.DIACHI = obj["Diachigui"] + "";
                        rds.TENDONVI = strTendonvi;
                        bool isDacoSo = false;
                        if (oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3 || oT.CD_TRANGTHAI == 4)
                        {
                            if (strSo != "")
                            {
                                oT.TB1_SO = Cls_Comon.toFullNumber((strSo), false).ToString();
                                if (dNgayCV != DateTime.MinValue)
                                    oT.TB1_NGAY = dNgayCV;
                                oT.CD_NGUOIKY = strNguoiky;
                                rds.SOTHONGBAO = Cls_Comon.toFullNumber((strSo), false).ToString();
                                rds.NGUOIKY = strNguoiky;
                                rds.SOTOTRINH = strSo + strHauto;
                                rds.NGAY = strNgay;
                                rds.THANG = strThang;
                                rds.NAM = strNam;
                                isDacoSo = true;
                            }
                        }
                        if (isDacoSo == false)
                        {
                            rds.SOTHONGBAO = Cls_Comon.toFullNumber(oT.TB1_SO, false) + "";
                            rds.NGUOIKY = oT.CD_NGUOIKY + "";
                            rds.SOTOTRINH = Cls_Comon.toFullNumber(oT.CD_SOCV, false) + "";
                            if (oT.TB1_NGAY != null)
                            {
                                DateTime dtNTB1 = (DateTime)oT.TB1_NGAY;
                                rds.NGAY = Cls_Comon.toFullNumber(dtNTB1.Day.ToString(), false);
                                rds.THANG = Cls_Comon.toFullNumber(dtNTB1.Month.ToString(), true);
                                rds.NAM = dtNTB1.Year.ToString();
                            }
                        }
                        rds.DIADIEM = strDiadiem;
                        rds.LOAIAN = obj["BAQD_LOAIAN"] + "";
                        if (obj["NGAYGHITRENDON"] != null)
                            rds.NGAYGUIDON = GetDate(obj["NGAYGHITRENDON"]);
                        rds.GIOITINH = "";
                        rds.GIOITINHHOA = "";
                        if ((obj["DUNGDONLA"] + "") == "1")
                        {
                            if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                            {
                                rds.GIOITINH = "ông";
                                rds.GIOITINHHOA = "Ông";
                            }
                            else
                            {
                                rds.GIOITINH = "bà";
                                rds.GIOITINHHOA = "Bà";
                            }
                        }
                        else if ((obj["DUNGDONLA"] + "") == "2")
                        {
                            rds.GIOITINH = "các ông, bà";
                            rds.GIOITINHHOA = "Các ông, bà";
                        }
                        if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                        {
                            rds.BA_SO = obj["BAQD_SO"] + "";
                            rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                            if (rds.BA_NGAY != "")
                                rds.BA_NGAY = GetDate(rds.BA_NGAY);
                            rds.BA_TOAXX = obj["TOAXX"] + "";
                        }
                        else//QĐKN
                        {
                            rds.BA_SO = obj["BAQD_SO"] + "";
                            rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                            if (rds.BA_NGAY != "")
                                rds.BA_NGAY = GetDate(rds.BA_NGAY);
                            rds.BA_TOAXX = obj["TOAXX"] + "";
                        }
                        rds.NOIDUNG = "";
                        if (oT.NOIDUNGDON == "" || oT.NOIDUNGDON == null)//anhvh add 07/07/2020
                        {
                            if ((obj["CD_TA_LYDO_ISBAQD"] + "") == "1")
                            {
                                rds.NOIDUNG = "          - Cung cấp bản sao bản án/quyết định đã có hiệu lực pháp luật và các tài liệu, chứng cứ liên quan đến việc đề nghị giám đốc thẩm.";
                            }
                            if ((obj["CD_TA_LYDO_ISXACNHAN"] + "") == "1")
                            {
                                if (rds.NOIDUNG != "")
                                    rds.NOIDUNG += "\n";
                                rds.NOIDUNG += "          - Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.";
                            }
                            if ((obj["CD_TA_LYDO_ISKHAC"] + "") == "1")
                            {
                                if (rds.NOIDUNG != "")
                                    rds.NOIDUNG += "\n";
                                rds.NOIDUNG += "          - " + obj["CD_TA_LYDO_KHAC"];
                            }
                        }
                        if (oT.NOIDUNGDON != "" && oT.NOIDUNGDON != null)
                        {
                            rds.NOIDUNG = "          - " + oT.NOIDUNGDON;
                            if ((obj["CD_TA_LYDO_ISXACNHAN"] + "") == "1")
                            {
                                if (rds.NOIDUNG != "")
                                    rds.NOIDUNG += "\n";
                                rds.NOIDUNG += "          - Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.";
                            }
                            if ((obj["CD_TA_LYDO_ISKHAC"] + "") == "1")
                            {
                                if (rds.NOIDUNG != "")
                                    rds.NOIDUNG += "\n";
                                rds.NOIDUNG += "          - " + obj["CD_TA_LYDO_KHAC"];
                            }
                        }
                        rds.DIACHIPHONGBAN = strDiachi;
                        rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                        rds.TAND_NHAN = TAND_NHAN_;
                        objds.DT_NOIBO_THONGBAO.AddDT_NOIBO_THONGBAORow(rds);
                        objds.AcceptChanges();
                    }
                    dt.SaveChanges();
                    Session["NOIBO_DATASET"] = objds;
                }
                string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                if (hasAdd) Load_Data();
            }
        }
        protected void btnGXN_Click(object sender, EventArgs e)
        {
            if (CurrDonViID == 6)
            {
                Literal Table_Str_Totals = new Literal();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                //-------------
                tbl = getDS_BC(11, false, true, false, false, false);
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
                    //Table_Str_Totals.Text = "<table></table>";
                }
                //--------------------------
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=Giay_Xac_Nhan.doc");
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
            else
            {
                SetGetSessionTK(true);
                decimal IDPBNhan = Convert.ToDecimal(ddlPhongban.SelectedValue);
                Session["GDTTT_MABM"] = "NOIBO_GXN";
                DataTable oDT = getDS(0, false, true, false, false, false);

                if (oDT != null)
                {
                    if (oDT.Rows.Count == 0)
                    {
                        lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                        return;
                    }
                    #region "Thông tin tờ trình"
                    DTGDTTT objds = new DTGDTTT();
                    string strTendonvi = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                    DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();


                    //strSo = txtBC_SoCV.Text;
                    //strNguoiky = txtBC_Nguoiky.Text;
                    //DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //if (dNgayCV != DateTime.MinValue)
                    //{
                    //    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                    //    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                    //    strNam = dNgayCV.Year.ToString();
                    //}



                    strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                    string strHauto = "";
                    if (oNSD.PHONGBANID != null && oNSD.PHONGBANID != 0)
                    {
                        DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                        strDiachi = oPB.DIACHI + "";
                        strHauto = oPB.HAUTOCV + "";
                    }
                    if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                        strDiadiem = "Hà Nội";
                    else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                    #endregion

                    string TAND_NHAN_ = "";
                    if (Session["CAP_XET_XU"] + "" == "TOICAO")
                    {
                        TAND_NHAN_ = "TANDTC";
                    }
                    else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                    {
                        TAND_NHAN_ = "TANDCC";
                    }
                    //DANH SÁCH đơn
                    int i = 0;
                    foreach (DataRow obj in oDT.Rows)
                    {
                        decimal DonID = Convert.ToDecimal(obj["ID"]);
                        i += 1;
                        DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                        rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                        if ((obj["LOAIDON"] + "") == "3" || (obj["LOAIDON"] + "") == "31")
                        {
                            if ((obj["CV_SO"] + "") == "")
                                rds.THONGTINCVCHUYEN = " (Do " + obj["CV_TENDONVI"] + " chuyển đến)";
                            else
                                rds.THONGTINCVCHUYEN = " (Do " + obj["CV_TENDONVI"] + " chuyển đến theo Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                        }
                        else if ((obj["LOAIDON"] + "") == "2" || (obj["LOAIDON"] + "") == "6" || (obj["LOAIDON"] + "") == "9")
                        {
                            rds.NGUOIGUI = rds.NGUOIGUI + " (Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                        }
                        else
                            rds.THONGTINCVCHUYEN = "(hoặc do tổ chức dịch vụ bưu chính chuyển đến)";

                        rds.DIACHI = obj["Diachigui"] + "";
                        rds.TENDONVI = strTendonvi;


                        //Lay thong tin Giay xac nhan ca nhan
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        String vLoaiso = "SoGXN";
                        DateTime dNgayCV;

                        DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                        if (objVB.Rows.Count > 0)
                        {
                            strSo = objVB.Rows[0]["SOVB"].ToString();
                            dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);

                            strNguoiky = objVB.Rows[0]["NGUOIKY"].ToString();

                            if (dNgayCV != DateTime.MinValue)
                            {
                                strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                                strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                                strNam = dNgayCV.Year.ToString();
                            }

                            rds.SOTHONGBAO = strSo;
                            rds.SOTOTRINH = strSo + strHauto;
                            rds.NGAY = strNgay;
                            rds.THANG = strThang;
                            rds.NAM = strNam;

                        }


                        rds.DIADIEM = strDiadiem;
                        rds.LOAIAN = obj["BAQD_LOAIAN"] + "";
                        if (!string.IsNullOrEmpty(obj["NGAYGHITRENDON"] + "") && obj["NGAYGHITRENDON"].ToString() != "01/01/0001")
                        {
                            rds.NGAYGUIDON = GetDate(obj["NGAYGHITRENDON"]);
                            DateTime dNgaygui = Convert.ToDateTime(obj["NGAYGHITRENDON"] + "");
                            rds.NGAYGUI = Cls_Comon.toFullNumber(dNgaygui.Day.ToString(), false);
                            rds.THANGGUI = Cls_Comon.toFullNumber(dNgaygui.Month.ToString(), true);
                            rds.NAMGUI = dNgaygui.Year.ToString();
                        }
                        if (obj["NGAYNHANDON"] != null)
                        {
                            DateTime dNgaynhan = DateTime.ParseExact(obj["NGAYNHANDON"] + "", "dd/MM/yyyy", null);
                            rds.NGAYNHAN = Cls_Comon.toFullNumber(dNgaynhan.Day.ToString(), false);
                            rds.THANGNHAN = Cls_Comon.toFullNumber(dNgaynhan.Month.ToString(), true);
                            rds.NAMNHAN = dNgaynhan.Year.ToString();
                        }
                        rds.GIOITINH = "";
                        rds.GIOITINHHOA = "";
                        if ((obj["DUNGDONLA"] + "") == "1")
                        {
                            if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                            {
                                rds.GIOITINH = "ông";
                                rds.GIOITINHHOA = "Ông";
                            }
                            else
                            {
                                rds.GIOITINH = "bà";
                                rds.GIOITINHHOA = "Bà";
                            }
                        }
                        else if ((obj["DUNGDONLA"] + "") == "2")
                            rds.GIOITINH = "Các ông, bà";
                        if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                        {
                            rds.BA_SO = obj["BAQD_SO"] + "";
                            rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                            if (rds.BA_NGAY != "")
                                rds.BA_NGAY = GetDate(rds.BA_NGAY);
                            rds.BA_TOAXX = obj["TOAXX"] + "";
                        }
                        else//QĐKN
                        {
                            rds.BA_SO = obj["BAQD_SO"] + "";
                            rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                            if (rds.BA_NGAY != "")
                                rds.BA_NGAY = GetDate(rds.BA_NGAY);
                            rds.BA_TOAXX = obj["TOAXX"] + "";
                        }

                        rds.NGUOIKY = strNguoiky;
                        rds.DIACHIPHONGBAN = strDiachi;
                        rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                        rds.TAND_NHAN = TAND_NHAN_;
                        objds.DT_NOIBO_THONGBAO.AddDT_NOIBO_THONGBAORow(rds);
                        objds.AcceptChanges();
                    }
                    Session["NOIBO_DATASET"] = objds;
                }
                string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
        }
        protected void btnNBTralai_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            decimal IDPBNhan = Convert.ToDecimal(ddlPhongban.SelectedValue);
            Session["GDTTT_MABM"] = "NOIBO_TRALAIDON";
            DataTable oDT = getDS(0, false, true, false, false, true);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có đơn quá hạn thông báo !";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                string strTendonvi = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                strSo = txtBC_SoCV.Text;
                string vNguoiKy = ddlNguoiKy.SelectedValue;
                if (ddlNguoiKy.SelectedValue != "0")
                {
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }

                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                    strNam = dNgayCV.Year.ToString();
                }
                strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                string strHauto = "";
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strDiachi = oPB.DIACHI + "";
                    strHauto = oPB.HAUTOCV + "";
                }
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                decimal sotb = Cls_Comon.GetNumber(strSo);
                #endregion
                string TAND_NHAN_ = "";
                if (Session["CAP_XET_XU"] + "" == "TOICAO")
                {
                    TAND_NHAN_ = "TANDTC";
                }
                else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                {
                    TAND_NHAN_ = "TANDCC";
                }
                //DANH SÁCH đơn
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();

                    i += 1;
                    DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    rds.DIACHI = obj["Diachigui"] + "";
                    rds.TENDONVI = strTendonvi;
                    if (strSo != "")
                        rds.SOTHONGBAO = reStr((sotb + i - 1).ToString());
                    rds.SOTOTRINH = strSo + strHauto;
                    rds.NGAY = strNgay;
                    rds.THANG = strThang;
                    rds.NAM = strNam;
                    bool isDacoSo = false;

                    if (strSo != "")
                    {
                        oT.TBTLD_SO = reStr((sotb + i - 1).ToString());
                        if (dNgayCV != DateTime.MinValue)
                            oT.TBTLD_NGAY = dNgayCV;
                        oT.CD_NGUOIKY = strNguoiky;
                        rds.SOTHONGBAO = reStr((sotb + i - 1).ToString());
                        rds.NGUOIKY = strNguoiky;
                        rds.SOTOTRINH = strSo + strHauto;
                        rds.NGAY = strNgay;
                        rds.THANG = strThang;
                        rds.NAM = strNam;
                        isDacoSo = true;
                    }

                    if (isDacoSo == false)
                    {
                        rds.SOTHONGBAO = reStr(oT.TBTLD_SO + "");
                        rds.NGUOIKY = oT.CD_NGUOIKY + "";
                        rds.SOTOTRINH = reStr(oT.CD_SOCV + "");
                        if (oT.TBTLD_NGAY != null)
                        {
                            DateTime dtNTB1 = (DateTime)oT.TBTLD_NGAY;
                            rds.NGAY = Cls_Comon.toFullNumber(dtNTB1.Day.ToString(), false);
                            rds.THANG = Cls_Comon.toFullNumber(dtNTB1.Month.ToString(), true);
                            rds.NAM = dtNTB1.Year.ToString();
                        }
                    }

                    rds.DIADIEM = strDiadiem;
                    rds.LOAIAN = obj["BAQD_LOAIAN"] + "";
                    if (obj["NGAYGHITRENDON"] != null)
                        rds.NGAYGUIDON = GetDate(obj["NGAYGHITRENDON"]);
                    rds.GIOITINH = "";
                    rds.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            rds.GIOITINH = "ông";
                            rds.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            rds.GIOITINH = "bà";
                            rds.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                        rds.GIOITINH = "Các ông, bà";
                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    else//QĐKN
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    rds.NOIDUNG = "";
                    if ((obj["CD_TA_LYDO_ISBAQD"] + "") == "1")
                    {
                        rds.NOIDUNG = "          - Cung cấp bản sao bản án/quyết định đã có hiệu lực pháp luật và các tài liệu, chứng cứ liên quan đến việc đề nghị giám đốc thẩm.";
                    }
                    if ((obj["CD_TA_LYDO_ISXACNHAN"] + "") == "1")
                    {
                        if (rds.NOIDUNG != "")
                            rds.NOIDUNG += "\n";
                        rds.NOIDUNG += "          - Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.";
                    }
                    if ((obj["CD_TA_LYDO_ISKHAC"] + "") == "1")
                    {
                        if (rds.NOIDUNG != "")
                            rds.NOIDUNG += "\n";
                        rds.NOIDUNG += "          - " + obj["CD_TA_LYDO_KHAC"];
                    }
                    rds.NGUOIKY = strNguoiky;
                    rds.DIACHIPHONGBAN = strDiachi;
                    rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                    rds.TB1_SO = obj["TB1_SO"] + "/TB-TA";
                    rds.TB1_NGAY = obj["TB1_NGAY"] + "";
                    if (rds.TB1_NGAY != "")
                        rds.TB1_NGAY = GetDate(rds.TB1_NGAY);
                    rds.TAND_NHAN = TAND_NHAN_;
                    objds.DT_NOIBO_THONGBAO.AddDT_NOIBO_THONGBAORow(rds);
                    objds.AcceptChanges();
                }
                Session["NOIBO_DATASET"] = objds;
                dt.SaveChanges();
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnNBInThongbaoTG_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            decimal IDPBNhan = Convert.ToDecimal(ddlPhongban.SelectedValue);
            DM_PHONGBAN objPBN = dt.DM_PHONGBAN.Where(x => x.ID == IDPBNhan).FirstOrDefault();
            Session["GDTTT_MABM"] = "NOIBO_THONGBAOTG";
            DataTable oDT = getDS(0, false, true, true, false, false);
            bool hasAdd = false;
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                string strTendonvi = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                strSo = txtBC_SoCV.Text;

                string vNguoiKy = ddlNguoiKy.SelectedValue;

                if (ddlNguoiKy.SelectedValue != "0")
                {
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }


                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                    strNam = dNgayCV.Year.ToString();
                }
                strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";

                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    if (oPB != null)
                    {
                        strDiachi = oPB.DIACHI + "";
                    }

                }

                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                decimal sotb = Cls_Comon.GetNumber(strSo);
                #endregion
                //DANH SÁCH đơn
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    DataTable oYC = oBL.YEUCAUBOSUNG(DonID);
                    if (oYC.Rows.Count == 0)
                    {
                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }
                        strSo = sotb.ToString();
                        hasAdd = true;
                        sotb = sotb + 1;
                        GDTTT_DON_YEUCAU_BOSUNG oY = new GDTTT_DON_YEUCAU_BOSUNG();
                        oY.ID = 0;
                        oY.DONID = oT.ID;
                        oY.LANTHU = 1;
                        oY.NGUOIKY = strNguoiky;
                        oY.NGAYTHONGBAO = dNgayCV;
                        oY.SOTHONGBAO = strSo;
                        oY.CD_TA_LYDO_ISBAQD = oT.CD_TA_LYDO_ISBAQD;
                        oY.CD_TA_LYDO_ISXACNHAN = oT.CD_TA_LYDO_ISXACNHAN;
                        oY.CD_TA_LYDO_ISKHAC = oT.CD_TA_LYDO_ISKHAC;
                        oY.NOIDUNG = oT.CD_TA_LYDO_KHAC;
                        oY.KETQUA = 0;
                        oY.NGAYBOSUNG = DateTime.MinValue;
                        oY.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oBL.GDTTT_DON_YEUCAU_BOSUNG_INSERT_UPDAT(oY);
                    }
                    else
                    {
                        DataTable oCheck = oBL.CHECK_YEUCAU_SOTB_NGAYTB(oT.ID, sotb.ToString(), txtBC_Ngaydk.Text);
                        if (oYC.Rows.Count == 1 && ddlTrangthaidon.SelectedValue == "4" && oCheck.Rows.Count == 0)
                        {

                            if (dNgayCV != DateTime.MinValue)
                            {
                                strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                                strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                                strNam = dNgayCV.Year.ToString();
                            }
                            strSo = sotb.ToString();
                            hasAdd = true;
                            sotb = sotb + 1;
                            GDTTT_DON_YEUCAU_BOSUNG oY = new GDTTT_DON_YEUCAU_BOSUNG();
                            oY.ID = 0;
                            oY.DONID = oT.ID;
                            oY.LANTHU = 2;
                            oY.NGUOIKY = strNguoiky;
                            oY.NGAYTHONGBAO = dNgayCV;
                            oY.SOTHONGBAO = strSo;
                            oY.CD_TA_LYDO_ISBAQD = oT.CD_TA_LYDO_ISBAQD;
                            oY.CD_TA_LYDO_ISXACNHAN = oT.CD_TA_LYDO_ISXACNHAN;
                            oY.CD_TA_LYDO_ISKHAC = oT.CD_TA_LYDO_ISKHAC;
                            oY.NOIDUNG = oT.CD_TA_LYDO_KHAC;
                            oY.KETQUA = 0;
                            oY.NGAYBOSUNG = DateTime.MinValue;
                            oY.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            oBL.GDTTT_DON_YEUCAU_BOSUNG_INSERT_UPDAT(oY);
                        }
                        else
                        {
                            strSo = oYC.Rows[0]["SOTHONGBAO"] + "";
                            sotb = Cls_Comon.GetNumber(strSo);
                            strNguoiky = oYC.Rows[0]["NGUOIKY"] + "";
                            dNgayCV = Convert.ToDateTime(oYC.Rows[0]["NGAYTHONGBAO"] + "");
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }
                    }
                    DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    rds.DIACHI = obj["Diachigui"] + "";
                    rds.TENDONVI = strTendonvi;
                    bool isDacoSo = false;
                    if (oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3 || oT.CD_TRANGTHAI == 4)
                    {
                        if (strSo != "")
                        {
                            oT.TB1_SO = reStr((strSo).ToString());
                            if (dNgayCV != DateTime.MinValue)
                                oT.TB1_NGAY = dNgayCV;
                            oT.CD_NGUOIKY = strNguoiky;
                            rds.SOTHONGBAO = reStr((strSo).ToString());
                            rds.NGUOIKY = strNguoiky;
                            rds.NGAY = strNgay;
                            rds.THANG = strThang;
                            rds.NAM = strNam;
                            isDacoSo = true;
                        }
                    }
                    if (isDacoSo == false)
                    {
                        rds.SOTHONGBAO = reStr(oT.TB1_SO + "");
                        rds.NGUOIKY = oT.CD_NGUOIKY + "";
                        if (oT.TB1_NGAY != null)
                        {
                            DateTime dtNTB1 = (DateTime)oT.TB1_NGAY;
                            rds.NGAY = Cls_Comon.toFullNumber(dtNTB1.Day.ToString(), false);
                            rds.THANG = Cls_Comon.toFullNumber(dtNTB1.Month.ToString(), true);
                            rds.NAM = dtNTB1.Year.ToString();
                        }
                    }
                    rds.DIADIEM = strDiadiem;
                    if (obj["NGAYGHITRENDON"] != null)
                        rds.NGAYGUIDON = GetDate(obj["NGAYGHITRENDON"]);
                    rds.GIOITINH = "";
                    rds.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            rds.GIOITINH = "ông";
                            rds.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            rds.GIOITINH = "bà";
                            rds.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                        rds.GIOITINH = "Các ông, bà";
                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    else//QĐKN
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    rds.NOIDUNG = "";
                    if (oT.NOIDUNGDON == "" || oT.NOIDUNGDON == null)//anhvh add 07/07/2020
                    {
                        if ((obj["CD_TA_LYDO_ISBAQD"] + "") == "1")
                        {
                            rds.NOIDUNG = "          - Cung cấp bản sao bản án/quyết định";
                            if ((obj["BAQD_SO"] + "") != "")
                                rds.NOIDUNG += " số " + obj["BAQD_SO"] + " ngày " + rds.BA_NGAY + " của " + obj["TOAXX"];
                            rds.NOIDUNG += " đã có hiệu lực pháp luật và các tài liệu liên quan đến việc đề nghị giám đốc thẩm.";
                        }
                        if ((obj["CD_TA_LYDO_ISXACNHAN"] + "") == "1")
                        {
                            if (rds.NOIDUNG != "")
                                rds.NOIDUNG += "\n";
                            rds.NOIDUNG += "          - Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.";
                        }
                        if ((obj["CD_TA_LYDO_ISKHAC"] + "") == "1")
                        {
                            if (rds.NOIDUNG != "")
                                rds.NOIDUNG += "\n";
                            rds.NOIDUNG += "          - " + obj["CD_TA_LYDO_KHAC"];
                        }
                    }
                    if (oT.NOIDUNGDON != "" && oT.NOIDUNGDON != null)
                    {
                        rds.NOIDUNG = "          - " + oT.NOIDUNGDON;
                        if ((obj["CD_TA_LYDO_ISXACNHAN"] + "") == "1")
                        {
                            if (rds.NOIDUNG != "")
                                rds.NOIDUNG += "\n";
                            rds.NOIDUNG += "          - Xác nhận của Ủy ban nhân dân xã, phường, thị trấn nơi cư trú hoặc kèm theo bản photo giấy tờ tùy thân.";
                        }
                        if ((obj["CD_TA_LYDO_ISKHAC"] + "") == "1")
                        {
                            if (rds.NOIDUNG != "")
                                rds.NOIDUNG += "\n";
                            rds.NOIDUNG += "          - " + obj["CD_TA_LYDO_KHAC"];
                        }
                    }
                    if (obj["LOAIDON"] + "" == "2" || obj["LOAIDON"] + "" == "6" || obj["LOAIDON"] + "" == "9")
                        rds.DIACHICOQUAN = obj["DIACHIGUI"] + "";
                    else
                        rds.DIACHICOQUAN = obj["CVDIACHI"] + ""; //MA_TEN_HV
                    rds.TENCOQUAN = obj["CV_TENDONVI"] + "";
                    rds.TENTRAIGIAMCU = oT.CV_TENDONVI + "";
                    if ((oT.CV_TRAIGIAMHIENTAI + "") != "")
                    {
                        rds.TENCOQUAN = oT.CV_TRAIGIAMHIENTAI + "";
                    }

                    rds.NGUOIKY = strNguoiky;
                    rds.DIACHIPHONGBAN = strDiachi;
                    rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                    objds.DT_NOIBO_THONGBAO.AddDT_NOIBO_THONGBAORow(rds);
                    objds.AcceptChanges();
                    dt.SaveChanges();
                }

                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            if (hasAdd) Load_Data();
        }
        protected void btnNBInCoquanchuyendon_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            bool isLOAICV_81 = false;
            Session["GDTTT_MABM"] = "NOIBO_THONGBAOCOQUAN";
            if (ddlLoaiCV.SelectedValue != "-1" && ddlLoaiCV.SelectedValue != "0")
            {
                decimal IDLoai = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
                DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();
                if (oLoai.ID == 1023 || oLoai.CAPCHAID == 1023)
                {
                    isLOAICV_81 = true;
                    Session["GDTTT_MABM"] = "NOIBO_THONGBAOCOQUAN81";
                }
            }
            decimal IDPBNhan = Convert.ToDecimal(ddlPhongban.SelectedValue);
            DM_PHONGBAN objPBN = dt.DM_PHONGBAN.Where(x => x.ID == IDPBNhan).FirstOrDefault();

            DataTable oDT = getDS(0, true, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có đơn kèm công văn";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                string strTendonvi = "", strPBGui = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();

                //strSo = txtBC_SoCV.Text;
                //strNguoiky = txtBC_Nguoiky.Text;
                //DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //if (dNgayCV != DateTime.MinValue)
                //{
                //    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                //    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                //    strNam = dNgayCV.Year.ToString();
                //}

                strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strDiachi = oPB.DIACHI + "";
                    strPBGui = oPB.TENPHONGBAN;
                }
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                #endregion
                string TAND_NHAN_ = "";
                if (Session["CAP_XET_XU"] + "" == "TOICAO")
                {
                    TAND_NHAN_ = "TANDTC";
                }
                else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                {
                    TAND_NHAN_ = "TANDCC";
                }

                //DANH SÁCH đơn
                //decimal sotb = Cls_Comon.GetNumber(strSo);
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                    i += 1;
                    DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    rds.DIACHI = obj["Diachigui"] + "";
                    rds.TENDONVI = strTendonvi;


                    //Kiểm tra các đơn có cùng 1 tờ trình không
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    String vLoaiso = "SoGXN_DV";
                    DateTime dNgayCV;

                    DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                    if (objVB.Rows.Count > 1)
                    {
                        strSo = objVB.Rows[0]["SOVB"].ToString();
                        dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                        strNguoiky = objVB.Rows[0]["NGUOIKY"].ToString();

                        rds.SOTHONGBAO = strSo;
                        rds.SOTOTRINH = strSo;
                        //rds.SOTOTRINH = oT.CD_SOCV + "";


                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();

                            rds.NGAYTOTRINH = dNgayCV.ToString("dd/MM/yyyy");
                        }

                        rds.NGUOIKY = strNguoiky;
                        rds.NGAY = strNgay;
                        rds.THANG = strThang;
                        rds.NAM = strNam;

                    }


                    rds.DIADIEM = strDiadiem;
                    rds.TENPHONGBANGUI = strPBGui;
                    rds.GIOITINH = "";
                    rds.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            rds.GIOITINH = "ông";
                            rds.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            rds.GIOITINH = "bà";
                            rds.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                        rds.GIOITINH = "Các ông, bà";
                    rds.BA_TOAXX = obj["TOAXX"] + "";
                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);

                    }
                    rds.SOCV = obj["CV_SO"] + "";
                    if (obj["CV_NGAY"] != null)
                        rds.NGAYCV = GetDate(obj["CV_NGAY"]);
                    rds.TENCOQUAN = obj["CV_TENDONVI"] + "";
                    rds.DIACHICOQUAN = obj["CVDIACHI"] + "";
                    rds.TENPHONGBANNHAN = obj["NOICHUYEN"] + "";
                    rds.NGUOIKY = strNguoiky;
                    rds.DIACHIPHONGBAN = strDiachi;
                    if (isLOAICV_81)
                    {
                        rds.CD_NGAY = GetDate(obj["CD_NGAYCV"]);
                        if (oT.LOAICONGVAN != null)
                        {
                            DM_DATAITEM oLoaiCV = dt.DM_DATAITEM.Where(x => x.ID == oT.LOAICONGVAN).FirstOrDefault();
                            rds.NOIDUNG = "";
                            if (oLoaiCV.MA == ENUM_GDT_LOAICV.CV8_1_DBQH)
                            {
                                rds.DIACHICOQUAN = ", " + oT.CV_TRAIGIAMHIENTAI + "";
                                rds.NOIDUNG = strTendonvi + " nhận được Phiếu chuyển đơn của " + rds.TENCOQUAN + ", " + oT.CV_TRAIGIAMHIENTAI;
                                rds.NOIDUNG += ", chuyển đơn của " + rds.GIOITINH + " " + rds.NGUOIGUI + " (có địa chỉ " + rds.DIACHI + ") ";
                            }
                            else
                            {
                                rds.NOIDUNG = strTendonvi + " nhận được Công văn số " + oT.CV_SO + " ngày " + GetDate(oT.CV_NGAY) + " của " + rds.TENCOQUAN;
                                rds.NOIDUNG += " về việc chuyển đơn của " + rds.GIOITINH + " " + rds.NGUOIGUI + " (có địa chỉ " + rds.DIACHI + ") ";
                                rds.NOIDUNG += "đề ngày " + GetDate(oT.NGAYGHITRENDON) + " ";
                            }
                            rds.NOIDUNG += "có nội dung";
                            if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                            {
                                rds.NOIDUNG += " đề nghị xem xét theo thủ tục giám đốc thẩm đối với Bản án số ";
                                rds.NOIDUNG += rds.BA_SO + " ngày " + rds.BA_NGAY + " của " + rds.BA_TOAXX + ".";
                            }
                            else//Kháng nghị
                            {

                                rds.NOIDUNG += " kiến nghị đối với Quyết định kháng nghị giám đốc thẩm số " + oT.KN_SOQD + " ngày " + GetDate(oT.KN_NGAY);
                                rds.NOIDUNG += " của " + rds.BA_TOAXX + " kháng nghị đối với Bản án số " + oT.BAQD_SO + " ngày " + GetDate(oT.BAQD_NGAYBA);
                                rds.NOIDUNG += " của ";
                                try
                                {
                                    if (oT.BAQD_TOAANID != null && oT.BAQD_TOAANID != 0)
                                    {
                                        DM_TOAAN oTAIN = dt.DM_TOAAN.Where(x => x.ID == oT.BAQD_TOAANID).FirstOrDefault();
                                        rds.NOIDUNG += oTAIN.MA_TEN + ".";
                                    }
                                }
                                catch (Exception ex) { }

                            }

                        }
                        rds.LYDO = "thuộc " + strTendonvi + " ";
                    }
                    rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                    rds.TAND_NHAN = TAND_NHAN_;
                    objds.DT_NOIBO_THONGBAO.AddDT_NOIBO_THONGBAORow(rds);
                    objds.AcceptChanges();
                }
                dt.SaveChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        //In phiếu chuyển tòa khác hoặc ngoài tòa
        protected void btnTKPhieuchuyen_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            bool isLOAICV_81 = false;
            Session["GDTTT_MABM"] = "TOAKHAC_PHIEUCHUYEN";
            if (ddlLoaiCV.SelectedValue != "-1" && ddlLoaiCV.SelectedValue != "0")
            {
                decimal IDLoai = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
                DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();
                if (oLoai.ID == 1023 || oLoai.CAPCHAID == 1023)
                {
                    isLOAICV_81 = true;
                    Session["GDTTT_MABM"] = "TOAKHAC_PHIEUCHUYEN81";
                }
            }
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                DateTime dNgayCV;
                string strNgay = "", strThang = "", strNam = "", strSOCV = "", strNguoiKy = "", vLoaiso = "";

                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";

                string strPhongban = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    if (oPB != null) strPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                }
                //ĐỊa điểm
                string strDiadiem = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                DTGDTTT objds = new DTGDTTT();

                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i = i + 1;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();

                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TENDONVI = strTendonvi;
                    r.TENPHONGBANGUI = strPhongban;

                    //Lay thong tin Số Cong van chuyển Tòa khác
                    DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    vLoaiso = "SoCVCTK";

                    DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                    if (objVB.Rows.Count > 0)
                    {
                        strSOCV = objVB.Rows[0]["SOVB"].ToString();
                        dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                        strNguoiKy = objVB.Rows[0]["NGUOIKY"].ToString();


                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }


                        r.NGAY = strNgay;
                        r.THANG = strThang;
                        r.NAM = strNam;
                        r.NGUOIKY = strNguoiKy;

                        if (Session[ENUM_SESSION.SESSION_DONVIID].ToString() == "1")
                        {
                            r.SO = strSOCV + "/TANDTC-VP";
                        }
                        else r.SO = strSOCV + "/PC-TACC";


                    }
                    else
                    {
                        if (Session[ENUM_SESSION.SESSION_DONVIID].ToString() == "1")
                        {
                            r.SO = "..../TANDTC-VP";
                        }
                        else r.SO = ".../PC-TACC";
                    }

                    r.DIADIEM = strDiadiem;


                    //Nội dung đơn
                    if (oT.BAQD_LOAIQDBA == 0)//BAQD
                    {
                        if ((oT.BAQD_SO + "") != "")
                        {
                            r.NOIDUNG = " có nội dung đề nghị xem xét theo thủ tục giám đốc thẩm/tái thẩm đối với Bản án/Quyết định số " + oT.BAQD_SO + " ngày ";
                            if (oT.BAQD_NGAYBA != null) r.NOIDUNG += Convert.ToDateTime(oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") + " của ";
                            else r.NOIDUNG += "   của ";
                            if (oT.BAQD_TOAANID != null && oT.BAQD_TOAANID != 0)
                            {
                                r.NOIDUNG += obj["TOAXX"] + " đã có hiệu lực pháp luật;";
                            }
                            else
                                r.NOIDUNG += oT.BAQD_TENTOA + " đã có hiệu lực pháp luật;";
                        }
                        else
                        {
                            if ((oT.NOIDUNGDON + "").Trim() != "")
                                r.NOIDUNG = " có nội dung " + oT.NOIDUNGDON + ".";
                            else if ((oT.NOIDUNGDON + "").Trim() == "" && (oT.GHICHU + "").Trim() != "")
                                r.NOIDUNG = " có nội dung " + oT.GHICHU + ".";
                        }
                    }
                    else//Số QĐ KN
                    {
                        if ((oT.KN_SOQD + "") != "")
                        {
                            r.NOIDUNG = " có nội dung khiếu nại quyết định số " + oT.KN_SOQD + " ngày ";
                            if (oT.KN_NGAY != null) r.NOIDUNG += Convert.ToDateTime(oT.KN_NGAY).ToString("dd/MM/yyyy") + " của ";
                            else r.NOIDUNG += "   của ";
                            r.NOIDUNG += obj["TOAXX"];
                            r.NOIDUNG += " đối với bản án số " + oT.BAQD_SO + " ngày ";
                            if (oT.BAQD_NGAYBA != null) r.NOIDUNG += Convert.ToDateTime(oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") + " của ";
                            if (oT.BAQD_TOAANID != null && oT.BAQD_TOAANID != 0)
                            {
                                try
                                {
                                    DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oT.BAQD_TOAANID).FirstOrDefault();
                                    r.NOIDUNG += oTA.MA_TEN + ".";
                                }
                                catch (Exception ex) { }
                            }


                        }
                        else
                        {
                            if ((oT.NOIDUNGDON + "").Trim() != "")
                                r.NOIDUNG = " có nội dung " + oT.NOIDUNGDON + ".";
                            else if ((oT.NOIDUNGDON + "").Trim() == "" && (oT.GHICHU + "").Trim() != "")
                                r.NOIDUNG = " có nội dung " + oT.GHICHU + ".";
                        }
                    }
                    string strISNOTGDTTT = obj["ISNOTGDTTT"] + "";
                    if (strISNOTGDTTT == "1")
                    {
                        r.NOIDUNG = " có nội dung " + oT.NOIDUNGDON + "";
                    }
                    //------------------
                    r.CHIDAO_COKHONG = oT.CHIDAO_COKHONG + "";
                    r.NOIDUNGCHIDAO = oT.CHIDAO_NOIDUNG + "";
                    r.CHUCVULANHDAO = "Chánh án";
                    if (oT.CHIDAO_COKHONG > 0 && oT.CHIDAO_LANHDAOID > 0)
                    {
                        try
                        {
                            DM_CANBO oLD = dt.DM_CANBO.Where(x => x.ID == oT.CHIDAO_LANHDAOID).FirstOrDefault();
                            if (oLD.CHUCVUID == null || oLD.CHUCVUID == 0)
                            {
                                r.CHUCVULANHDAO = "Thẩm phán";
                                r.LANHDAO = " " + oLD.HOTEN;
                            }
                            else
                            {
                                DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oLD.CHUCVUID).FirstOrDefault();
                                if (oCV.MA == ENUM_CHUCVU.CHUCVU_PCA)
                                {
                                    r.CHUCVULANHDAO = "Phó Chánh án";
                                    r.LANHDAO = " " + oLD.HOTEN;
                                }
                            }
                        }
                        catch (Exception ex) { }
                    }
                    r.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    r.DIACHIGUI = obj["Diachigui"] + "";
                    r.GIOITINH = "";
                    r.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            r.GIOITINH = "ông";
                            r.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            r.GIOITINH = "bà";
                            r.GIOITINHHOA = "Bà";
                        }
                        r.NGUOIGUI = r.GIOITINH + " " + r.NGUOIGUI;
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                    {
                        r.GIOITINH = "các ông, bà";
                        r.GIOITINHHOA = "Các ông, bà";
                        r.NGUOIGUI = r.GIOITINH + " " + r.NGUOIGUI;
                    }
                    if (obj["NGAYGHITRENDON"] != null)
                        r.NGAYGUI = GetDate(obj["NGAYGHITRENDON"]);
                    r.TENDONVINHAN = obj["NOICHUYEN"] + "";
                    if (oT.LOAIDON == 1 || oT.LOAIDON == 11 || oT.LOAIDON == 8 || oT.LOAIDON == 10)
                    {
                        string strTMP1 = "đơn của " + r.NGUOIGUI + " (địa chỉ " + r.DIACHIGUI + ")";
                        strTMP1 += " đề ngày " + r.NGAYGUI + "";
                        r.TMP3 = strTMP1 + ",";
                    }
                    else if (oT.LOAIDON == 2 || oT.LOAIDON == 6 || oT.LOAIDON == 9 || oT.LOAIDON == 12)
                    {
                        string strTMP1 = "Công văn số " + oT.CV_SO + " ngày " + GetDate(oT.CV_NGAY) + " của " + oT.CV_TENDONVI;
                        r.TMP3 = strTMP1 + ",";
                    }
                    else if (oT.LOAIDON == 3 || oT.LOAIDON == 31)
                    {
                        string strTMP1 = "đơn của " + r.NGUOIGUI + " (địa chỉ " + r.DIACHIGUI + ")";
                        strTMP1 += " đề ngày " + r.NGAYGUI + "";

                        DM_DATAITEM oLoaiCV = dt.DM_DATAITEM.Where(x => x.ID == oT.LOAICONGVAN).FirstOrDefault();
                        if (oLoaiCV.MA == ENUM_GDT_LOAICV.CV8_1_DBQH)
                            r.GHICHU = " (do " + oT.CV_TENDONVI + ", " + oT.CV_TRAIGIAMHIENTAI + " chuyển đến theo Phiếu chuyển ngày " + GetDate(oT.CV_NGAY) + ")";
                        else
                        {
                            if ((oT.CV_SO + "") == "")
                                r.GHICHU = " (do " + oT.CV_TENDONVI + " chuyển đến)";
                            else
                                r.GHICHU = " (do " + oT.CV_TENDONVI + " chuyển đến theo Công văn số " + oT.CV_SO + " ngày " + GetDate(oT.CV_NGAY) + ")";
                        }
                        r.CV_TENDONVI = oT.CV_TENDONVI;
                        strTMP1 += r.GHICHU;
                        r.TMP3 = strTMP1 + ",";
                    }

                    r.TMP1 = r.TENDONVINHAN;
                    if (isLOAICV_81)
                    {
                        if (oT.CD_TK_NOIGUI == 1)
                        {
                            r.TMP1 = "Đồng chí Chánh án " + r.TENDONVINHAN;
                            if (r.TMP1.Contains("cấp cao tại thành phố Hồ"))
                                r.TMP1 = r.TMP1.Replace("cấp cao tại", "cấp cao\n tại");
                            r.TMP2 = "đồng chí Chánh án ";

                        }
                        else
                        {
                            r.TMP1 = r.TENDONVINHAN;
                            r.TMP2 = "";

                        }

                    }
                    else
                        if (oT.CD_TK_NOIGUI == 1)
                    {
                        r.TMP1 = "Đồng chí Chánh án " + r.TENDONVINHAN;
                        if (r.TMP1.Contains("cấp cao tại thành phố Hồ"))
                            r.TMP1 = r.TMP1.Replace("cấp cao tại", "cấp cao\n tại");
                    }

                    objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                    objds.AcceptChanges();
                }

                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnTKPhieuchuyenN_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            bool isLOAICV_81 = false;
            Session["GDTTT_MABM"] = "TOAKHAC_PHIEUCHUYENN";
            if (ddlLoaiCV.SelectedValue != "-1" && ddlLoaiCV.SelectedValue != "0")
            {
                decimal IDLoai = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
                DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();
                if (oLoai.ID == 1023 || oLoai.CAPCHAID == 1023)
                {
                    isLOAICV_81 = true;
                    Session["GDTTT_MABM"] = "TOAKHAC_PHIEUCHUYENN81";
                }
            }

            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                DateTime dNgayCV;
                string strNgay = "", strThang = "", strNam = "", strSOCV = "", strNguoiKy = "", vLoaiso = "";

                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                string strPhongban = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                }
                //ĐỊa điểm
                string strDiadiem = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                DTGDTTT objds = new DTGDTTT();

                int i = 0;
                string strDVNhan = "";
                bool isNewDVNhan = false;
                //Order by lại Nơi chuyển đến
                DataView dv = new DataView(oDT);
                dv.Sort = "NOICHUYEN ASC";
                oDT = dv.ToTable();

                string TAND_NHAN = "";
                if (Session["CAP_XET_XU"] + "" == "TOICAO")
                {
                    TAND_NHAN = "TANDTC";
                }
                else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                {
                    TAND_NHAN = "TANDCC";
                }

                foreach (DataRow obj in oDT.Rows)
                {
                    i = i + 1;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();

                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TENDONVI = strTendonvi;
                    r.TENPHONGBANGUI = strPhongban;
                    r.TENDONVINHAN = obj["NOICHUYEN"] + "";


                    //Lay thong tin Số Cong van chuyển Tòa khác
                    DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    vLoaiso = "SoCVCTK";

                    DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                    if (objVB.Rows.Count > 0)
                    {
                        strSOCV = objVB.Rows[0]["SOVB"].ToString();
                        dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                        strNguoiKy = objVB.Rows[0]["NGUOIKY"].ToString();


                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }

                        r.SO = strSOCV;
                        r.NGAY = strNgay;
                        r.THANG = strThang;
                        r.NAM = strNam;
                        r.NGUOIKY = strNguoiKy;
                    }


                    r.DIADIEM = strDiadiem;


                    r.TAND_NHAN = TAND_NHAN;


                    if (r.TENDONVINHAN != strDVNhan)
                    {
                        strDVNhan = r.TENDONVINHAN;
                        isNewDVNhan = true;
                    }
                    else
                        isNewDVNhan = false;


                    if (isNewDVNhan)
                    {
                        r.TMP1 = r.TENDONVINHAN;
                        if (isLOAICV_81)
                        {
                            if (oT.CD_TK_NOIGUI == 1)
                            {
                                r.TMP1 = "Đồng chí Chánh án " + r.TENDONVINHAN;
                                if (r.TMP1.Contains("cấp cao tại thành phố Hồ"))
                                    r.TMP1 = r.TMP1.Replace("cấp cao tại", "cấp cao\n tại");
                                r.TMP2 = "đồng chí Chánh án ";
                                r.TMP3 = "để chỉ đạo";
                            }
                            else
                            {
                                r.TMP1 = r.TENDONVINHAN;
                                r.TMP2 = "";
                                r.TMP3 = "để xem xét và";
                            }

                        }
                        objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                        objds.AcceptChanges();
                    }
                }

                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnTKDuongsu_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "TOAKHAC_PHIEUCHUYENGUIDS";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                // DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime dNgayCV;
                string strNgay = "", strThang = "", strNam = "", strSOCV = "", strNguoiKy = "", vLoaiso = "";

                #endregion
                //DANH SÁCH đơn
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    DTGDTTT.DT_NOIBO_DANHSACHRow rds = objds.DT_NOIBO_DANHSACH.NewDT_NOIBO_DANHSACHRow();
                    rds.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    rds.TENPHONGBANNHAN = obj["NOICHUYEN"] + "";

                    //Lay thong tin Số Cong van chuyển Tòa khác
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    vLoaiso = "SoCVCTK";

                    DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                    if (objVB.Rows.Count > 0)
                    {
                        strSOCV = objVB.Rows[0]["SOVB"].ToString();
                        dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                        strNguoiKy = objVB.Rows[0]["NGUOIKY"].ToString();

                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }

                        rds.SOTOTRINH = strSOCV;
                        rds.NGAY = strNgay;
                        rds.THANG = strThang;
                        rds.NAM = strNam;
                    }


                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    if ((obj["arrCongvan"] + "") != "")
                    {
                        rds.NGUOIGUI = rds.NGUOIGUI + " (Do " + obj["arrCongvan"] + ")";
                    }
                    else if ((obj["LOAIDON"] + "") == "2")
                    {
                        rds.NGUOIGUI = rds.NGUOIGUI + " (Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                    }
                    rds.DIAPHUONG = obj["Diachigui"] + "";
                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    else//QĐKN
                    {
                        rds.QD_SO = obj["BAQD_SO"] + "";
                        rds.QD_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.QD_NGAY != "")
                            rds.QD_NGAY = GetDate(rds.QD_NGAY);
                        rds.QD_NGUOIKN = obj["TOAXX"] + "";
                    }
                    //rds.SOTOTRINH = obj["CD_SOCV"] + "";
                    //rds.NGAYTOTRINH = GetDate(obj["CD_NGAYCV"]);
                    rds.SOTOTRINH = strSOCV;
                    rds.NGAYTOTRINH = strNgay + "/" + strThang + "/" + strNam;
                    rds.SODON = obj["SODON"] + "";
                    rds.GHICHU = obj["GHICHU"] + "";
                    rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                    objds.DT_NOIBO_DANHSACH.AddDT_NOIBO_DANHSACHRow(rds);
                    objds.AcceptChanges();
                }
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        }
        ////in phiếu Gửi cơ quan chuyển đơn
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
        protected void btnTKCoquan_Click_Older(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            bool isLOAICV_81 = false;
            Session["GDTTT_MABM"] = "TOAKHAC_THONGBAOCOQUAN";
            if (ddlLoaiCV.SelectedValue != "-1" && ddlLoaiCV.SelectedValue != "0")
            {
                decimal IDLoai = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
                DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();
                if (oLoai.ID == 1023 || oLoai.CAPCHAID == 1023)
                {
                    isLOAICV_81 = true;
                    Session["GDTTT_MABM"] = "NOIBO_THONGBAOCOQUAN81";
                }
            }

            DataTable oDT = getDS(0, true, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có đơn kèm công văn";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                string strTendonvi = "", strPBGui = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                strSo = txtBC_SoCV.Text;

                string vNguoiKy = ddlNguoiKy.SelectedValue;

                if (ddlNguoiKy.SelectedValue != "0")
                {
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }
                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                    strNam = dNgayCV.Year.ToString();
                }
                strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();

                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                #endregion
                //DANH SÁCH đơn
                decimal sotb = Cls_Comon.GetNumber(strSo);
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                    DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    rds.DIACHI = obj["Diachigui"] + "";
                    rds.TENDONVI = strTendonvi;
                    rds.SOTHONGBAO = reStr((sotb + i - 1).ToString());
                    rds.NGAY = strNgay;
                    rds.THANG = strThang;
                    rds.NAM = strNam;
                    rds.DIADIEM = strDiadiem;
                    rds.TENPHONGBANGUI = strPBGui;
                    rds.GIOITINH = "";
                    rds.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            rds.GIOITINH = "ông";
                            rds.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            rds.GIOITINH = "bà";
                            rds.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                        rds.GIOITINH = "Các ông, bà";
                    rds.BA_TOAXX = "";
                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    if ((oT.BAQD_SO + "") != "")
                    {
                        rds.NOIDUNG = "đề nghị xem xét theo thủ tục giám đốc thẩm/tái thẩm đối với Bản án/Quyết định số " + oT.BAQD_SO + " ngày ";
                        if (oT.BAQD_NGAYBA != null)
                            rds.NOIDUNG += Convert.ToDateTime(oT.BAQD_NGAYBA).ToString("dd/MM/yyyy") + " của ";
                        else rds.NOIDUNG += "   của ";
                        if (oT.BAQD_TOAANID != null && oT.BAQD_TOAANID != 0)
                        {
                            rds.NOIDUNG += obj["TOAXX"] + " đã có hiệu lực pháp luật;";
                        }
                        else
                            rds.NOIDUNG += oT.BAQD_TENTOA + " đã có hiệu lực pháp luật;";
                    }
                    else
                    {
                        if ((oT.NOIDUNGDON + "").Trim() != "")
                            rds.NOIDUNG = "" + oT.NOIDUNGDON + ".";
                        else if ((oT.NOIDUNGDON + "").Trim() == "" && (oT.GHICHU + "").Trim() != "")
                            rds.NOIDUNG = "" + oT.GHICHU + ".";
                    }
                    rds.SOTOTRINH = obj["CD_SOCV"] + "";
                    if (obj["CD_NGAYCV"] != null)
                        rds.NGAYTOTRINH = GetDate(obj["CD_NGAYCV"]);

                    rds.SOCV = obj["CV_SO"] + "";
                    if (obj["CV_NGAY"] != null)
                        rds.NGAYCV = GetDate(obj["CV_NGAY"]);
                    rds.TENCOQUAN = obj["CV_TENDONVI"] + ",";
                    rds.DIACHICOQUAN = obj["CVDIACHI"] + "";
                    rds.TENPHONGBANNHAN = obj["NOICHUYEN"] + "";
                    rds.NGUOIKY = strNguoiky;
                    rds.DIACHIPHONGBAN = strDiachi;
                    rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                    if (isLOAICV_81)
                    {
                        rds.CD_NGAY = GetDate(obj["CD_NGAYCV"]);
                        if (oT.LOAICONGVAN != null)
                        {
                            DM_DATAITEM oLoaiCV = dt.DM_DATAITEM.Where(x => x.ID == oT.LOAICONGVAN).FirstOrDefault();
                            rds.NOIDUNG = "";
                            if (oLoaiCV.MA == ENUM_GDT_LOAICV.CV8_1_DBQH)
                            {
                                rds.DIACHICOQUAN = ", " + oT.CV_TRAIGIAMHIENTAI + "";
                                rds.NOIDUNG = strTendonvi + " nhận được Phiếu chuyển đơn của " + rds.TENCOQUAN + ", " + oT.CV_TRAIGIAMHIENTAI;
                                rds.NOIDUNG += ", chuyển đơn của " + rds.GIOITINH + " " + rds.NGUOIGUI + " (có địa chỉ " + rds.DIACHI + ") ";
                            }
                            else
                            {
                                rds.NOIDUNG = strTendonvi + " nhận được Công văn số " + oT.CV_SO + " ngày " + GetDate(oT.CV_NGAY) + " của " + rds.TENCOQUAN;
                                rds.NOIDUNG += " về việc chuyển đơn của " + rds.GIOITINH + " " + rds.NGUOIGUI + " (có địa chỉ " + rds.DIACHI + ") ";
                                rds.NOIDUNG += "đề ngày " + GetDate(oT.NGAYGHITRENDON) + " ";
                            }
                            rds.NOIDUNG += "có nội dung";
                            if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                            {
                                if ((oT.BAQD_SO + "") != "")
                                {
                                    rds.NOIDUNG += " đề nghị xem xét theo thủ tục giám đốc thẩm/tái thẩm đối với Bản án số ";
                                    rds.NOIDUNG += rds.BA_SO + " ngày " + rds.BA_NGAY + " của " + rds.BA_TOAXX + ".";
                                }
                                else
                                {
                                    if ((oT.NOIDUNGDON + "").Trim() != "")
                                        rds.NOIDUNG += " " + oT.NOIDUNGDON + ".";
                                    else if ((oT.NOIDUNGDON + "").Trim() == "" && (oT.GHICHU + "").Trim() != "")
                                        rds.NOIDUNG += " " + oT.GHICHU + ".";
                                }

                            }
                            else//Kháng nghị
                            {

                                rds.NOIDUNG += " kiến nghị đối với Quyết định kháng nghị giám đốc thẩm số " + oT.KN_SOQD + " ngày " + GetDate(oT.KN_NGAY);
                                rds.NOIDUNG += " của " + rds.BA_TOAXX + " kháng nghị đối với Bản án số " + oT.BAQD_SO + " ngày " + GetDate(oT.BAQD_NGAYBA);
                                rds.NOIDUNG += " của ";
                                try
                                {
                                    if (oT.BAQD_TOAANID != null && oT.BAQD_TOAANID != 0)
                                    {
                                        DM_TOAAN oTAIN = dt.DM_TOAAN.Where(x => x.ID == oT.BAQD_TOAANID).FirstOrDefault();
                                        rds.NOIDUNG += oTAIN.MA_TEN + ".";
                                    }
                                }
                                catch (Exception ex) { }

                            }

                        }
                    }
                    objds.DT_NOIBO_THONGBAO.AddDT_NOIBO_THONGBAORow(rds);
                    objds.AcceptChanges();
                }
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnNTAPhieuchuyenN_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);

            Session["GDTTT_MABM"] = "NTA_PHIEUCHUYENN";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }

                DateTime dNgayCV;
                string strNgay = "", strThang = "", strNam = "", strSOCV = "", strNguoiKy = "", vLoaiso = "";


                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";

                string strPhongban = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                }
                //ĐỊa điểm
                string strDiadiem = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                DTGDTTT objds = new DTGDTTT();

                int i = 0;
                string strDVNhan = "";
                bool isNewDVNhan = false;
                DataView dv = new DataView(oDT);
                dv.Sort = "NOICHUYEN ASC";
                oDT = dv.ToTable();

                string TAND_NHAN_ = "";
                if (Session["CAP_XET_XU"] + "" == "TOICAO")
                {
                    TAND_NHAN_ = "TANDTC";
                }
                else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                {
                    TAND_NHAN_ = "TANDCC";
                }
                foreach (DataRow obj in oDT.Rows)
                {
                    i = i + 1;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();

                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TENDONVI = strTendonvi;
                    r.TENPHONGBANGUI = strPhongban;
                    r.TENDONVINHAN = obj["NOICHUYEN"] + "";

                    //Lay thong tin Số Cong van chuyển Ngoài Tòa
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    vLoaiso = "SoCVCN";

                    DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                    if (objVB.Rows.Count > 0)
                    {
                        strSOCV = objVB.Rows[0]["SOVB"].ToString();
                        dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                        strNguoiKy = objVB.Rows[0]["NGUOIKY"].ToString();


                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }

                        r.SO = strSOCV;
                        r.NGAY = strNgay;
                        r.THANG = strThang;
                        r.NAM = strNam;
                        r.NGUOIKY = strNguoiKy;
                    }

                    r.DIADIEM = strDiadiem;


                    r.TAND_NHAN = TAND_NHAN_;

                    if (r.TENDONVINHAN != strDVNhan)
                    {
                        strDVNhan = r.TENDONVINHAN;
                        isNewDVNhan = true;
                    }
                    else
                        isNewDVNhan = false;


                    objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                    objds.AcceptChanges();
                }

                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnNTAPhieuchuyen_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "NTA_PHIEUCHUYEN";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }

                DateTime dNgayCV;
                string strNgay = "", strThang = "", strNam = "", strSOCV = "", strNguoiKy = "", vLoaiso = "";

                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";

                string strPhongban = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                }
                //ĐỊa điểm
                string strDiadiem = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                DTGDTTT objds = new DTGDTTT();

                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i = i + 1;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();

                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TENDONVI = strTendonvi;
                    r.TENPHONGBANGUI = strPhongban;

                    //Lay thong tin Số Cong van chuyển Ngoài Tòa                   
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    vLoaiso = "SoCVCN";

                    DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                    if (objVB.Rows.Count > 0)
                    {
                        strSOCV = objVB.Rows[0]["SOVB"].ToString();
                        dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                        strNguoiKy = objVB.Rows[0]["NGUOIKY"].ToString();


                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }

                        r.NGAY = strNgay;
                        r.THANG = strThang;
                        r.NAM = strNam;
                        r.NGUOIKY = strNguoiKy;
                        if (Session[ENUM_SESSION.SESSION_DONVIID].ToString() == "1")
                        {
                            r.SO = strSOCV + "/TANDTC-VP";
                        }
                        else r.SO = strSOCV + "/PC-TACC";
                    }
                    else
                    {
                        if (Session[ENUM_SESSION.SESSION_DONVIID].ToString() == "1")
                        {
                            r.SO = ".../TANDTC-VP";
                        }
                        else r.SO = ".../PC-TACC";
                    }

                    r.DIADIEM = strDiadiem;


                    if (oT.NOIDUNGDON + "" != "")
                        r.NOIDUNG = oT.NOIDUNGDON + "";
                    else
                        r.NOIDUNG = oT.GHICHU + "";

                    r.CHIDAO_COKHONG = oT.CHIDAO_COKHONG + "";
                    r.NOIDUNGCHIDAO = oT.CHIDAO_NOIDUNG + "";
                    r.CHUCVULANHDAO = "Chánh án";
                    if (oT.CHIDAO_COKHONG > 0 && oT.CHIDAO_LANHDAOID > 0)
                    {
                        try
                        {
                            DM_CANBO oLD = dt.DM_CANBO.Where(x => x.ID == oT.CHIDAO_LANHDAOID).FirstOrDefault();
                            DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oLD.CHUCVUID).FirstOrDefault();
                            if (oCV.MA == ENUM_CHUCVU.CHUCVU_PCA)
                            {
                                r.CHUCVULANHDAO = "Phó Chánh án";
                                r.LANHDAO = " " + oLD.HOTEN;
                            }
                        }
                        catch (Exception ex) { }
                    }
                    if (oT.LOAIDON == 3)
                    {
                        if ((oT.CV_SO + "") == "")
                            r.GHICHU = " (do " + oT.CV_TENDONVI + " chuyển đến)";
                        else
                            r.GHICHU = " (do " + oT.CV_TENDONVI + " chuyển đến theo Công văn số " + oT.CV_SO + " ngày " + GetDate(oT.CV_NGAY) + ")";

                    }

                    r.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    r.DIACHIGUI = obj["Diachigui"] + "";
                    r.GIOITINH = "";
                    r.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            r.GIOITINH = "ông";
                            r.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            r.GIOITINH = "bà";
                            r.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                    {
                        r.GIOITINH = "các ông, bà";
                        r.GIOITINHHOA = "Các ông, bà";
                    }
                    if (obj["NGAYGHITRENDON"] != null)
                        r.NGAYGUI = GetDate(obj["NGAYGHITRENDON"]);
                    r.TENDONVINHAN = obj["NOICHUYEN"] + "";

                    objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                    objds.AcceptChanges();
                }
                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnKinhtrinh_Click(object sender, EventArgs e)
        {
            Session["GDTTT_MABM"] = "KINHTRINHLANHDAO";
            DataTable oDT = getDS(0, false, true, false, true, false);

            if (oDT != null)
            {

                string strSOCV = txtBC_SoCV.Text;
                string vNguoiKy = ddlNguoiKy.SelectedValue;
                string v_chucvu = "";
                string strNguoiky = "";
                if (ddlNguoiKy.SelectedValue != "0")
                {
                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }

                string strNgay = "", strThang = "", strNam = "";
                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                    strNam = dNgayCV.Year.ToString();
                }
                string strPhongban = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                }
                //ĐỊa điểm
                string strDiadiem = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                DTGDTTT objds = new DTGDTTT();

                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i = i + 1;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();

                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TENDONVI = strTendonvi;
                    r.TENPHONGBANGUI = strPhongban;
                    r.SO = strSOCV;
                    r.DIADIEM = strDiadiem;
                    r.NGAY = strNgay;
                    r.THANG = strThang;
                    r.NAM = strNam;
                    r.NGUOIKY = strNguoiky;
                    r.NOIDUNG = oT.NOIDUNGDON + "";
                    r.CHIDAO_COKHONG = oT.CHIDAO_COKHONG + "";
                    r.NOIDUNGCHIDAO = oT.CHIDAO_NOIDUNG + "";
                    r.CHUCVULANHDAO = "Chánh án";
                    r.HUONGDAN = oT.CHIDAO_KINHTRINH + "";
                    if (oT.CHIDAO_COKHONG > 0 && oT.CHIDAO_LANHDAOID > 0)
                    {
                        try
                        {
                            DM_CANBO oLD = dt.DM_CANBO.Where(x => x.ID == oT.CHIDAO_LANHDAOID).FirstOrDefault();
                            DM_DATAITEM oCV = dt.DM_DATAITEM.Where(x => x.ID == oLD.CHUCVUID).FirstOrDefault();

                            r.CHUCVULANHDAO = oCV.TEN;
                            r.LANHDAO = " " + oLD.HOTEN;

                        }
                        catch (Exception ex) { }
                    }
                    if (oT.LOAIDON == 3)
                    {
                        r.GHICHU = " (do " + oT.CV_TENDONVI + " chuyển đến)";
                    }
                    if (strSOCV != "")
                    {
                        r.SO = strSOCV;
                        r.NGUOIKY = strNguoiky;
                        r.NGAY = strNgay;
                        r.THANG = strThang;
                        r.NAM = strNam;
                    }


                    r.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    r.DIACHIGUI = obj["Diachigui"] + "";
                    r.GIOITINH = "";
                    r.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            r.GIOITINH = "ông";
                            r.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            r.GIOITINH = "bà";
                            r.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                        r.GIOITINH = "Các ông, bà";
                    if (obj["NGAYGHITRENDON"] != null)
                        r.NGAYGUI = GetDate(obj["NGAYGHITRENDON"]);
                    r.TENDONVINHAN = obj["NOICHUYEN"] + "";

                    objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                    objds.AcceptChanges();
                }

                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnNTADuongsu_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "NTA_DANHSACHGUIDS";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                DateTime dNgayCV;
                string strNgay = "", strThang = "", strNam = "", strSOCV = "", strNguoiKy = "", vLoaiso = "";

                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";

                DTGDTTT objds = new DTGDTTT();
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TT = i.ToString();
                    r.TENDONVI = strTendonvi;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                    r.NOIDUNG = oT.NOIDUNGDON + "";

                    //Lay thong tin Số Cong van chuyển Ngoài Tòa                   
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    vLoaiso = "SoCVCN";

                    DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                    if (objVB.Rows.Count > 0)
                    {
                        strSOCV = objVB.Rows[0]["SOVB"].ToString();
                        dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                        strNguoiKy = objVB.Rows[0]["NGUOIKY"].ToString();


                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }

                        r.SO = strSOCV;
                        r.NGAY = strNgay;
                        r.THANG = strThang;
                        r.NAM = strNam;
                        r.NGUOIKY = strNguoiKy;
                    }


                    r.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    if ((obj["arrCongvan"] + "") != "")
                    {
                        r.NGUOIGUI = r.NGUOIGUI + " (Do " + obj["arrCongvan"] + ")";
                    }
                    else if ((obj["LOAIDON"] + "") == "2")
                    {
                        r.NGUOIGUI = r.NGUOIGUI + " (Công văn số " + obj["CV_SO"] + " ngày " + GetDate(obj["CV_NGAY"]) + ")";
                    }
                    r.DIACHIGUI = obj["Diachigui"] + "";
                    r.TENDONVINHAN = obj["NOICHUYEN"] + "";
                    r.GHICHU = obj["GHICHU"] + "";
                    objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                    objds.AcceptChanges();
                }
                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnNTACoquan_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "NTA_THONGBAOCOQUAN";
            DataTable oDT = getDS(0, true, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có đơn kèm công văn";
                    return;
                }
                #region "Thông tin tờ trình"
                DTGDTTT objds = new DTGDTTT();
                string strTendonvi = "", strPBGui = "", strDiachi = "", strDiadiem = "", strSo = "", strNgay = "", strThang = "", strNam = "", strNguoiky = "";
                strSo = txtBC_SoCV.Text;
                string vNguoiKy = ddlNguoiKy.SelectedValue;
                string v_chucvu = "";
                if (ddlNguoiKy.SelectedValue != "0")
                {
                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }


                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                    strNam = dNgayCV.Year.ToString();
                }
                strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();

                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                #endregion
                //DANH SÁCH đơn
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    DTGDTTT.DT_NOIBO_THONGBAORow rds = objds.DT_NOIBO_THONGBAO.NewDT_NOIBO_THONGBAORow();
                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    rds.DIACHI = obj["Diachigui"] + "";
                    rds.TENDONVI = strTendonvi;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();
                    rds.NOIDUNG = oT.NOIDUNGDON + "";
                    rds.SOTOTRINH = oT.TB1_SO + "";
                    rds.NGUOIKY = oT.CD_NGUOIKY + "";
                    if (oT.TB1_NGAY != null)
                    {
                        DateTime dtNTB1 = (DateTime)oT.TB1_NGAY;
                        rds.NGAY = dtNTB1.Day.ToString();
                        rds.THANG = dtNTB1.Month.ToString();
                        rds.NAM = dtNTB1.Year.ToString();
                    }
                    rds.DIADIEM = strDiadiem;
                    rds.TENPHONGBANGUI = strPBGui;
                    rds.GIOITINH = "";
                    rds.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            rds.GIOITINH = "ông";
                            rds.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            rds.GIOITINH = "bà";
                            rds.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                        rds.GIOITINH = "Các ông, bà";
                    if ((obj["BAQD_LOAIQDBA"] + "") == "0")//BA
                    {
                        rds.BA_SO = obj["BAQD_SO"] + "";
                        rds.BA_NGAY = obj["BAQD_NGAYBA"] + "";
                        if (rds.BA_NGAY != "")
                            rds.BA_NGAY = GetDate(rds.BA_NGAY);
                        rds.BA_TOAXX = obj["TOAXX"] + "";
                    }
                    rds.SOCV = obj["CV_SO"] + "";
                    if (obj["CV_NGAY"] != null)
                        rds.NGAYCV = GetDate(obj["CV_NGAY"]);
                    rds.SOTOTRINH = obj["SVB_SOCV"] + "";
                    if (obj["SVB_NGAYCV"] != null)
                        rds.NGAYTOTRINH = GetDate(obj["SVB_NGAYCV"]);

                    rds.TENCOQUAN = obj["CV_TENDONVI"] + "";
                    rds.DIACHICOQUAN = obj["CVDIACHI"] + "";

                    rds.TENPHONGBANNHAN = obj["NOICHUYEN"] + "";
                    rds.NGUOIKY = strNguoiky;
                    rds.DIACHIPHONGBAN = strDiachi;
                    rds.BIDANH = obj["MADON"] + "-" + obj["BIDANH"];
                    objds.DT_NOIBO_THONGBAO.AddDT_NOIBO_THONGBAORow(rds);
                    objds.AcceptChanges();
                }
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnTralaidon_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "NTA_TRALAI";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }

                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                string strPhongban = "", strBidanh = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                }
                strBidanh = oNSD.GHICHU + "";
                string TAND_NHAN_ = "";
                if (Session["CAP_XET_XU"] + "" == "TOICAO")
                {
                    TAND_NHAN_ = "TANDTC";
                }
                else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
                {
                    TAND_NHAN_ = "TANDCC";
                }
                //ĐỊa điểm
                string strDiadiem = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));

                decimal DonID;
                DateTime dNgayCV;
                string strNgay = "", strThang = "", strNam = "", strSOCV = "", strNguoiKy = "", vLoaiso = "";

                DTGDTTT objds = new DTGDTTT();
                foreach (DataRow obj in oDT.Rows)
                {
                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TENDONVI = strTendonvi;
                    r.TENPHONGBANGUI = strPhongban;
                    //Lay thong tin Số trả lại đơn
                    DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    vLoaiso = "SoTralaidon";

                    DataTable objVB = oBL.GET_DON_SOVANBAN(CurrDonViID, PhongBanID, vLoaiso, DonID.ToString());
                    if (objVB.Rows.Count > 0)
                    {
                        strSOCV = objVB.Rows[0]["SOVB"].ToString();
                        dNgayCV = (String.IsNullOrEmpty(objVB.Rows[0]["NGAYVB"].ToString())) ? DateTime.MinValue : DateTime.Parse(objVB.Rows[0]["NGAYVB"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault);
                        strNguoiKy = objVB.Rows[0]["NGUOIKY"].ToString();


                        if (dNgayCV != DateTime.MinValue)
                        {
                            strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                            strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                            strNam = dNgayCV.Year.ToString();
                        }

                        r.SO = strSOCV;
                        r.NGAY = strNgay;
                        r.THANG = strThang;
                        r.NAM = strNam;
                        r.NGUOIKY = strNguoiKy;
                    }

                    r.DIADIEM = strDiadiem;


                    r.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    r.DIACHIGUI = obj["Diachigui"] + "";
                    r.BIDANH = obj["MADON"] + strBidanh;
                    r.GIOITINH = "";
                    r.GIOITINHHOA = "";
                    r.TAND_NHAN = TAND_NHAN_;
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            r.GIOITINH = "ông";
                            r.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            r.GIOITINH = "bà";
                            r.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                    {
                        r.GIOITINH = "các ông, bà";
                        r.GIOITINHHOA = "Các ông, bà";
                    }
                    if (obj["NGAYGHITRENDON"] != null)
                        r.NGAYGUI = GetDate(obj["NGAYGHITRENDON"]);
                    r.HUONGDAN = obj["CD_TRALAI_YEUCAU"] + "";
                    if ((obj["CD_TRALAI_LYDOID"] + "") != "")
                    {
                        if ((obj["CD_TRALAI_LYDOID"] + "") == "0")
                        {
                            r.LYDO = obj["CD_TRALAI_LYDOKHAC"] + "";
                        }
                        else
                        {
                            try
                            {
                                decimal IDDM = Convert.ToDecimal(obj["CD_TRALAI_LYDOID"]);
                                DM_DATAITEM obji = dt.DM_DATAITEM.Where(x => x.ID == IDDM).FirstOrDefault();
                                r.LYDO = obji.TEN;
                            }
                            catch (Exception ex) { }
                        }
                    }
                    r.BAQD_CAPXETXU_NAME = obj["BAQD_CAPXETXU_NAME"].ToString().ToLower();
                    if (Session["CAP_XET_XU"] + "" == "TOICAO" && obj["BAQD_LOAIQDBA_NAME"].ToString() == "BA/QĐ")
                    {
                        r.BAQD_LOAIQDBA_NAME = "Bản án/Quyết định";
                    }
                    else
                    {
                        r.BAQD_LOAIQDBA_NAME = obj["BAQD_LOAIQDBA_NAME"].ToString();
                    }

                    r.BAQD_LOAIAN_NAME = obj["BAQD_LOAIAN_NAME"].ToString().ToLower();
                    r.LOAIGDTT = obj["LOAIGDTT"].ToString().ToLower();

                    r.SOBA = obj["BAQD_SO"] + "";
                    if (obj["BAQD_NGAYBA"] + "" != "")
                        r.NGAYBA = Convert.ToDateTime(obj["BAQD_NGAYBA"]).ToString("dd/MM/yyyy");
                    r.TOA_PHUC_THAM = obj["TOAXX"] + "";
                    objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                    objds.AcceptChanges();
                }
                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnNBInPCTrung_Click(object sender, EventArgs e)
        {
            {
                SetGetSessionTK(true);
                Session["GDTTT_MABM"] = "NOIBO_TBCHUYENTRUNG";
                DataTable oDT = getDS(0, false, true, false, false, false);
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

                        if ((obj["CD_SOCV"] + "") != "")
                        {

                            r.NGUOIKY = obj["CD_NGUOIKY"].ToString();
                            DateTime vNgayCV = Convert.ToDateTime(obj["CD_NGAYCV"]);
                            r.NGAY = vNgayCV.Day.ToString();
                            r.THANG = vNgayCV.Month.ToString();
                            r.NAM = vNgayCV.Year.ToString();
                            r.SOTOTRINH = obj["CD_SOCV"].ToString();
                            sotb += 1;
                        }
                        else if ((obj["SVB_SOCV"] + "") != "")
                        {

                            r.NGUOIKY = obj["SVB_NGUOIKY"].ToString();
                            DateTime vNgayCV = Convert.ToDateTime(obj["SVB_NGAYCV"]);
                            r.NGAY = vNgayCV.Day.ToString();
                            r.THANG = vNgayCV.Month.ToString();
                            r.NAM = vNgayCV.Year.ToString();
                            r.SOTOTRINH = obj["SVB_SOCV"].ToString();
                            sotb += 1;
                        }
                        else
                        {
                            //nếu chưa có số thì để rỗng
                            r.NGUOIKY = "";
                            r.NGAY = "";
                            r.THANG = "";
                            r.NAM = "";
                            r.SOTOTRINH = "";
                            sotb += 1;

                        }

                        //r.NGUOIKY = strNguoiky;
                        //r.NGAY = strNgay;
                        //r.THANG = strThang;
                        //r.NAM = strNam;
                        //if (txtBC_SoCV.Text != "")
                        //{
                        //    r.SOTOTRINH = sotb + "";
                        //    sotb += 1;
                        //}
                        r.TUNGAY = txtNgaynhapTu.Text;
                        r.DENNGAY = txtNgaynhapDen.Text;
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
        protected void ddlTrangthaichuyen_SelectedIndexChanged(object sender, EventArgs e)
        {
            ShowButtonPrint();
        }
        protected void Drop_LOAICVPC_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void Drop_LoaiSo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlLoaiso.SelectedValue != "0")
            {
                //Lay so van ban theo loại VB
                Layso_SoVB();
                if (ddlLoaiso.SelectedValue == "SoGXN" || ddlLoaiso.SelectedValue == "SoCVC")
                    ddlNoichuyenden.SelectedValue = "0"; //Noi bộ
                else if (ddlLoaiso.SelectedValue == "SoCVCTK")
                    ddlNoichuyenden.SelectedValue = "1"; //Tòa khác
                else if (ddlLoaiso.SelectedValue == "SoCVCN")
                    ddlNoichuyenden.SelectedValue = "2"; //Ngoài tòa
                else if (ddlLoaiso.SelectedValue == "SoTralaidon")
                    ddlNoichuyenden.SelectedValue = "3"; //Tra lai don
                else if (ddlLoaiso.SelectedValue == "SoTT")
                {
                    ddlNoichuyenden.SelectedValue = "0"; //Noi bộ
                    ddlTrangthaidon.SelectedValue = "0"; //Đủ điều kiện
                    ddlThuLy.SelectedValue = "6"; // TLmoi
                }
                else if (ddlLoaiso.SelectedValue == "SoTTXX")//27/08/2024
                {
                    ddlNoichuyenden.SelectedValue = "0"; //Noi bộ
                    ddlTrangthaidon.SelectedValue = "0"; //Đủ điều kiện
                    ddlHinhthucdon.SelectedValue = "4"; // Hồ sơ kháng nghị VKS
                }
                else if (ddlLoaiso.SelectedValue == "SoTT_TLL")//27/08/2024
                {
                    ddlNoichuyenden.SelectedValue = "0"; //Noi bộ
                    ddlTrangthaidon.SelectedValue = "0"; //Đủ điều kiện
                    ddlThuLy.SelectedValue = "3";//Tim to trinh Thu ly moi trùng - thụ lý lại
                }
                else if (ddlLoaiso.SelectedValue == "TBTP")
                {
                    ddlNoichuyenden.SelectedValue = "0"; //Noi bộ
                    ddlTrangthaidon.SelectedValue = "0"; //Đủ điều kiện                                    

                }
                else if (ddlLoaiso.SelectedValue == "YCBS")
                {
                    ddlNoichuyenden.SelectedValue = "0"; //Noi bộ
                    ddlTrangthaidon.SelectedValue = "1"; //Đủ điều kiện                 

                }
                btnLuuVBchuyen.Enabled = true;
                btnLuuVBchuyen.CssClass = "buttoninput";
                LoadNoichuyenden();
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
                txtBC_SoCV.Text = oBL.SOVB_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), PhongBanID, dNgayCV.Year, vddlLoaiso).ToString();
                txtBC_Ngaydk.Text = dNgayCV.ToString("dd/MM/yyyy");
            }
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

                    divPrintNoibo.Visible = true;
                    divPrintToakhac.Visible = false;
                    divPrintNgoaiTA.Visible = false;
                    divPrintTralai.Visible = false;
                    break;
                case "1":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = true;
                    txtNgoaitoaan.Visible = false;


                    divPrintNoibo.Visible = false;
                    divPrintToakhac.Visible = true;
                    divPrintNgoaiTA.Visible = false;
                    divPrintTralai.Visible = false;
                    break;
                case "2":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = true;


                    divPrintNoibo.Visible = false;
                    divPrintToakhac.Visible = false;
                    divPrintNgoaiTA.Visible = true;
                    divPrintTralai.Visible = false;
                    break;
                case "3":
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;

                    divPrintNoibo.Visible = false;
                    divPrintToakhac.Visible = false;
                    divPrintNgoaiTA.Visible = false;
                    divPrintTralai.Visible = true;
                    break;
                default:
                    ddlPhongban.Visible = false;
                    ddlTrangthaidon.Visible = false;
                    pnToakhac.Visible = false;
                    txtNgoaitoaan.Visible = false;

                    divPrintNoibo.Visible = false;
                    divPrintToakhac.Visible = false;
                    divPrintNgoaiTA.Visible = false;
                    divPrintTralai.Visible = false;
                    break;

            }
            ShowButtonPrint();
        }
        private bool Check_Chuyendon()
        {
            //"SoGXN"  Giấy xác nhận
            //"SoCVC"  Công văn chuyển
            //"SoCVCTK"  Công văn chuyển Tòa khác
            //"SoCVCN"  Công văn chuyển ngoài
            //"SoTralaidon"  Trả lại đơn
            //"SoTT"  Tờ trình
            //"TBTP"  Thông báo phân công Thẩm phán
            String strMsg = "";
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    string strID = Item.Cells[0].Text;
                    decimal ID = Convert.ToDecimal(strID);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    if (oT.LOAIDON == 8 || oT.LOAIDON == 10)
                    {
                        strMsg = "Đơn khiếu nại tư pháp không hỗ trợ chuyển";
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return false;
                    }
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
                            if (oT.LOAIDON == 4)
                            {
                                if (oBL.CHECK_SOVB_DON("SoTTXX", CurrDonViID, PhongBanID, ID) == 0)
                                {
                                    strMsg = "Bạn chưa nhập thông tin tờ trình thụ lý xét xử GDT";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    return false;
                                }
                            }
                            else
                            {
                                if (oT.ARR_DON_ID > 0)
                                {
                                    if (oBL.CHECK_SOVB_DON("SoTT_TLL", CurrDonViID, PhongBanID, ID) == 0)
                                    {
                                        strMsg = "Bạn chưa nhập thông tin tờ trình thụ lý lại";
                                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                        return false;
                                    }
                                }
                                //-----05/03/2026--yêu cầu của Duy phuong--------------
                                //có nội dung này của Văn phong anh xem xử lý giúp em.
                                //Theo quy chế mới về xử lý đơn đề nghị GĐT thì đơn thụ lý mới của Văn phòng phải chuyển tới Vụ GĐKT trong vòng 48h.
                                //Hiện trạng là đơn thụ lý mới phải gắn với tờ trình và thông báo phân công TP thì VP mới được chuyển đơn đi.
                                //Yêu cầu mới của VP: đơn thụ lý mới đã phân công TP và đã gắn số CV chuyển Vụ sẽ được chuyển thẳng tới Vụ GĐKT mà ko cần điều kiện phải có tờ trình và thông báo phân công

                                //else
                                //{
                                //    if (oBL.CHECK_SOVB_DON("SoTT", CurrDonViID, PhongBanID, ID) == 0)
                                //    {
                                //        strMsg = "Bạn chưa nhập thông tin tờ trình";
                                //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                //        return false;
                                //    }
                                //}
                            }
                            //-----05/03/2026----------------
                            //if (oBL.CHECK_SOVB_DON("TBTP", CurrDonViID, PhongBanID, ID) == 0)
                            //{
                            //    strMsg = "Bạn chưa nhập thông báo phân công Thẩm phán";
                            //    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                            //    return false;
                            //}
                            //---------------------
                            //21/01/2026 đóng vào theo yêu cầu của luồng mới
                            //nếu là thẩm phán bậc 3 thì phải check thêm số công văn chuyển - dieppv 01/11/2025
                            //if (oT.ISTPB3 == 1)
                            //{

                            //oT.LOAIDON != 4) //theo yêu cầu của Duy ngày 09/03/2026 
                            //hỗ trợ chị Hường giúp em trường hợp này: danh sách hồ sơ KN VKS này chị Hường nhờ chuyển Vụ GĐKT 3 giúp vì hồ sơ KN VKS sẽ chuyển theo tờ trình chứ không có CV chuyển Vụ, giờ nếu chị add số CV chuyển vụ để chuyển tạm thì sẽ bị ảnh hưởng tới dãy số CV chuyển.
                            //if (oT.LOAIDON != 4)
                            //{
                                if (oBL.CHECK_SOVB_DON("SoCVC", CurrDonViID, PhongBanID, ID) == 0)
                                {
                                    strMsg = "Bạn chưa nhập thông tin công văn chuyển";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    return false;
                                }
                            //}
                            //}
                        }
                        else//đã thụ lý hoặc chưa thụ lý và loại đơn của thẩm phán bậc 3
                        {
                            if (oBL.CHECK_SOVB_DON("SoCVC", CurrDonViID, PhongBanID, ID) == 0)
                            {
                                strMsg = "Bạn chưa nhập thông tin công văn chuyển";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                return false;
                            }
                        }
                    }
                    else
                    {
                        strMsg = "Đơn không đủ điều kiện để chuyển";
                        if (oT.CD_TRANGTHAI == 1 || oT.CD_TRANGTHAI == 2)
                            strMsg = "Đơn đã được chuyển, bạn không thể chuyển đơn tiếp";

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                        return false;
                    }
                }
            }
            return true;
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
        protected void btnChuyendon_Click(object sender, EventArgs e)
        {
            if (Check_Chuyendon() == true)
            {
                try
                {
                    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
                    decimal PBID = 0;
                    if (strPBID != "") PBID = Convert.ToDecimal(strPBID);

                    bool flag = false;
                    int iCount = 0;
                    foreach (DataGridItem Item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            flag = true;
                            string strID = Item.Cells[0].Text;
                            decimal ID = Convert.ToDecimal(strID);
                            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                            //Chỉ với đơn chuyển noi bo, chuyen ngoai toa, chuyen toa khac moi thực hien viec chuyen don
                            if (oT.CD_LOAI == 0 || oT.CD_LOAI == 1 || oT.CD_LOAI == 2)
                            {
                                if ((oT.CD_TRANGTHAI == 0 || oT.CD_TRANGTHAI == 3 || oT.CD_TRANGTHAI == 4) && (oT.CD_LOAI > 0 || (oT.CD_LOAI == 0 && oT.CD_TA_TRANGTHAI == 0)))
                                {
                                    //node:03.08.2020  
                                    //COMMENT ON COLUMN GDTTT_DON.CD_TRANGTHAI IS 'TRANG THAI CHUYEN(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại (phải xóa công văn chuyển vụ mới được trả lại),4 Bị trả lại nhưng không được sửa)';
                                    //COMMENT ON COLUMN GDTTT_DON.CD_LOAI  IS 'NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)';
                                    //COMMENT ON COLUMN GDTTT_DON.CD_TA_TRANGTHAI IS '(1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện)';
                                    //COMMENT ON COLUMN GDTTT_DON.BAQD_TOAANID IS 'Tòa xét xử';
                                    //COMMENT ON COLUMN GDTTT_DON.BAQD_LOAIAN IS 'Loại án ID';
                                    //COMMENT ON COLUMN GDTTT_DON.BAQD_CAPXETXU IS 'Cấp xét xử';
                                    //COMMENT ON COLUMN GDTTT_DON.DONTRUNGID IS 'Đơn trùng';
                                    //COMMENT ON COLUMN GDTTT_DON.CD_SOCV IS 'Số công văn chuyển';

                                    //Kiem tra xem don da co so CV chua, neu chua co thi khong cho chuyen
                                    //Lay thong tin Số Cong van chuyển  NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)'                
                                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                                    string vLoaiso = "";
                                    if (oT.CD_LOAI == 0)
                                        vLoaiso = "SoCVC";
                                    else if (oT.CD_LOAI == 1)
                                        vLoaiso = "SoCVCTK";
                                    else
                                        vLoaiso = "SoCVCN";
                                    //Chi kiem tra voi don chuyen ra ngoai don vi
                                    if (oBL.CHECK_SOVB_DON(vLoaiso, CurrDonViID, PhongBanID, ID) == 0 && oT.CD_LOAI != 0)
                                    {
                                        string strMsg = "Bạn chưa nhập thông tin số Văn bản chuyển";
                                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    }
                                    else
                                    {
                                        //-----Chỉ áp dụng tạm thoi khi chua xac dịnh duoc don chuyen cung Don TLM sẽ chuyển cho Thẩm phán ma khong co so CV chuyen-
                                        if (oT.ISTHULY == 1)//
                                        {

                                            iCount += 1;
                                            //Lưu Thong tin chuyen don
                                           // Update_DonChuyen_TP(oT, PBID, oT.ID.ToString());
                                           //22/01/2026
                                            Update_DonChuyen_Vu(oT, PBID, oT.ID.ToString());
                                            oT.CD_TRANGTHAI = 1;
                                            oT.CD_NGAYXULY = DateTime.Now;
                                        }
                                        else
                                        {

                                            iCount += 1;
                                            Update_DonChuyen_Vu(oT, PBID, chkChon.ToolTip);
                                            oT.CD_TRANGTHAI = 1;
                                            oT.CD_NGAYXULY = DateTime.Now;
                                            //CHuyển đồng thời các đơn trùng kèm theo
                                            string[] strarr = chkChon.ToolTip.Split(',');
                                            if (strarr.Length > 1)
                                            {
                                                for (int k = 0; k < strarr.Length; k++)
                                                {
                                                    decimal kID = Convert.ToDecimal(strarr[k]);
                                                    GDTTT_DON kDon = dt.GDTTT_DON.Where(x => x.ID == kID).FirstOrDefault();
                                                    kDon.CD_TRANGTHAI = 1;
                                                    kDon.CD_NGAYXULY = oT.CD_NGAYXULY;

                                                }
                                            }

                                        }
                                    }

                                }

                            }
                            else
                            {
                                oT.CD_TRANGTHAI = 1;
                                oT.CD_NGAYXULY = DateTime.Now;
                            }
                        }
                    }
                    dt.SaveChanges();
                    if (flag == false)
                    {
                        lbtthongbao.Text = "Chưa chọn đơn để chuyển !";
                        return;
                    }
                    else
                    {
                        Load_Data();
                        lbtthongbao.Text = "Hoàn thành chuyển " + iCount.ToString() + " đơn !";
                        //Đóng nút chuyển đơn
                        //btnChuyendon.Enabled = false;
                        //btnChuyendon.CssClass = "buttonprintdisable";
                    }
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = "Lỗi khi chuyển đơn: " + ex.Message;
                }
            }
            else
            {
                return;
            }
        }
        void Update_DonChuyen_TP(GDTTT_DON oT, Decimal PBID, String ArrDonTrung)
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
            else if (oT.CD_LOAI == 1)
                vLoaiso = "SoCVCTK";
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


            //string[] strarr = ArrDonTrung.Split(',');
            //objLS.SOLUONGDON = strarr.Length;//Số lượng đơn chuyển đến
            //objLS.ARRDONTRUNG = ArrDonTrung;//Danh sách các đơn chuyển cùng 
            switch ((int)oT.CD_LOAI) //COMMENT ON COLUMN GDTTT_DON.CD_LOAI  IS 'NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)';
            {
                case 0:
                    objLS.DONVINHANID = oT.TOAANID;
                    //thụ lý mới và là thẩm phán tối cao
                    if (oT.ISTHULY == 1 && oT.ISTPB3 == 0)//neu la don thu ly moi thi chuyen tham phan
                    {
                        if (oT.THAMPHANID == null || oT.THAMPHANID == 0)
                        {
                            lbtthongbao.Text = "Bạn chưa phân công Thẩm phán, phải phân công thẩm phán trước";
                            return;
                        }
                        else
                        {
                            DM_CANBO cb = dt.DM_CANBO.Where(x => x.ID == oT.THAMPHANID).FirstOrDefault();
                            objLS.PHONGBANNHANID = cb.PHONGBANID; //gán phòng ban nhận = phòng ban của thẩm phán
                           //--------------------
                           //objLS.TRANGTHAI = 2;//đã nhận theo yêu cầu luồng thẩm phán mặc định là đã nhận
                            //--------------------
                        }

                    }
                    else //Đã thụ lý hoặc thụ lý mới và là đơn thẩm phán bậc 3
                    {
                        objLS.PHONGBANNHANID = oT.CD_TA_DONVIID; //gán phòng ban nhận = Đơn vị chuyển đến (màn quản lý đơn)
                    }
                    break;
                case 1:
                    objLS.DONVINHANID = oT.CD_TK_DONVIID;
                    objLS.PHONGBANNHANID = 0;
                    break;
            }
            if (lstC.Count == 0)
                dt.GDTTT_DON_CHUYEN.Add(objLS);
            dt.SaveChanges();
            //end 
        }
        void Update_DonChuyen_Vu(GDTTT_DON oT, Decimal PBID, String ArrDonTrung)
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
            else if (oT.CD_LOAI == 1)
                vLoaiso = "SoCVCTK";
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


            //string[] strarr = ArrDonTrung.Split(',');
            //objLS.SOLUONGDON = strarr.Length;//Số lượng đơn chuyển đến
            //objLS.ARRDONTRUNG = ArrDonTrung;//Danh sách các đơn chuyển cùng 
            switch ((int)oT.CD_LOAI) //COMMENT ON COLUMN GDTTT_DON.CD_LOAI  IS 'NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)';
            {
                case 0:
                    objLS.DONVINHANID = oT.TOAANID;
                    objLS.PHONGBANNHANID = oT.CD_TA_DONVIID; //gán phòng ban nhận = Đơn vị chuyển đến (màn quản lý đơn)
                    break;
                case 1:
                    objLS.DONVINHANID = oT.CD_TK_DONVIID;
                    objLS.PHONGBANNHANID = 0;
                    break;
            }
            if (lstC.Count == 0)
                dt.GDTTT_DON_CHUYEN.Add(objLS);
            dt.SaveChanges();
            //end 
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
                int iCount = 0;
                String da_nhan = "";
                int count_Chuachuyen = 0;
                int count_Checked = 0;

                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");

                    if (Item.Cells[10].Text != "Chưa chuyển")
                    {
                        if (chkChon.Checked)
                        {
                            count_Checked += 1;
                            flag = true;
                            string strID = Item.Cells[0].Text;
                            decimal ID = Convert.ToDecimal(strID);
                            GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                            //----Lấy đơn vị của thẩm phán được phân công
                            DM_CANBO cb = dt.DM_CANBO.Where(x => x.ID == oT.THAMPHANID).FirstOrDefault();
                            GDTTT_DON_CHUYEN objc = new GDTTT_DON_CHUYEN();
                            GDTTT_DON_CHUYEN objc_tp = new GDTTT_DON_CHUYEN();
                            if (oT.ISTHULY == 1)//--1 Thụ lý mới,2 Đã thụ lý
                            {
                                objc_tp = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == ID && x.DONVINHANID == oT.TOAANID
                                         && x.PHONGBANNHANID == cb.PHONGBANID).FirstOrDefault();
                                //29/01/2026 thêm khi thay đổi luồng mới thụ lý mới chuyển thẳng các vụ GĐKT
                                if(objc_tp == null)
                                {
                                    objc = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == ID && x.DONVINHANID == oT.TOAANID
                                            && x.PHONGBANNHANID == oT.CD_TA_DONVIID).FirstOrDefault();
                                }
                                else
                                {
                                    objc=objc_tp;
                                }    
                            }
                            else
                            {
                                objc = dt.GDTTT_DON_CHUYEN.Where(x => x.DONID == ID && x.DONVINHANID == oT.TOAANID
                                             && x.PHONGBANNHANID == oT.CD_TA_DONVIID).FirstOrDefault();
                            }
                            //COMMENT ON COLUMN GDTTT_DON.CD_TRANGTHAI IS 'TRANG THAI CHUYEN(0,null Chưa chuyển,1 Đã chuyển,2 Đã nhận,3 Bị trả lại)';
                            //COMMENT ON COLUMN GDTTT_DON.CD_LOAI  IS 'NOICHUYEN(0 nội bộ,1 tòa khác,2 ngoài tòa án)';
                            //COMMENT ON COLUMN GDTTT_DON.CD_TA_TRANGTHAI IS '(1 Đơn chưa đủ điều kiện,0 Đơn đủ điều kiện)';
                            //COMMENT ON COLUMN GDTTT_DON.BAQD_TOAANID IS 'Tòa xét xử';
                            //COMMENT ON COLUMN GDTTT_DON.BAQD_LOAIAN IS 'Loại án ID';
                            //COMMENT ON COLUMN GDTTT_DON.BAQD_CAPXETXU IS 'Cấp xét xử';
                            //COMMENT ON COLUMN GDTTT_DON.DONTRUNGID IS 'Đơn trùng';
                            //COMMENT ON COLUMN GDTTT_DON.CD_SOCV IS 'Số công văn chuyển';

                            if (objc.TRANGTHAI == 2)//1 Chưa nhận; 2 Đã nhận; 3 Trả lại; 4 Đã chuyển
                            {
                                da_nhan += oT.NGUOIGUI_HOTEN + ";";
                            }
                            if ((objc.TRANGTHAI == 1) && (oT.CD_LOAI > 0 || (oT.CD_LOAI == 0 && oT.CD_TA_TRANGTHAI == 0)))
                            {
                                iCount += 1;

                                string strArrDon = chkChon.ToolTip;
                                string[] strarr = strArrDon.Split(',');

                                //CHuyển đồng thời các đơn trùng kèm theo
                                if (strarr.Length > 1)
                                {
                                    for (int k = 0; k < strarr.Length; k++)
                                    {
                                        decimal kID = Convert.ToDecimal(strarr[k]);
                                        GDTTT_DON kDon = dt.GDTTT_DON.Where(x => x.ID == kID).FirstOrDefault();
                                        kDon.CD_TRANGTHAI = 0;
                                        dt.SaveChanges();
                                    }
                                }
                                //Xóa thông tin đẫ chuyển từ bảng đơn chuyển KHi Thu Hồi đơn
                                //objLS.DONVINHANID = oT.CD_TK_DONVIID--Don vi nhan tòa khác,--CD_TA_DONVIID đơn vị nhận nội bộ
                                switch ((int)oT.CD_LOAI)//(0 nội bộ,1 tòa khác,2 ngoài tòa án)
                                {
                                    case 0:
                                        if (oT.ISTHULY == 1)//--1 Thụ lý mới,2 Đã thụ lý
                                        {
                                            //29/01/2026 thêm khi thay đổi luồng mới thụ lý mới chuyển thẳng các vụ GĐKT
                                            if(objc_tp != null)
                                            {
                                                xoa_thongtinchuyen(ID, Convert.ToDecimal(cb.PHONGBANID));//xóa thông tin chuyển tới thẩm phán
                                            }    
                                            else
                                            {
                                                xoa_thongtinchuyen(ID, Convert.ToDecimal(oT.CD_TA_DONVIID));
                                            }    
                                        }
                                        else
                                        {
                                            xoa_thongtinchuyen(ID, Convert.ToDecimal(oT.CD_TA_DONVIID));//xóa thông chuyển những đơn đã thụ lý đến đơn vị nhận nội bộ
                                        }
                                        break;
                                    case 1:
                                        xoa_thongtinchuyen(ID, Convert.ToDecimal(oT.CD_TK_DONVIID));
                                        break;
                                }


                            }
                            dt.SaveChanges();
                        }
                    }
                    else
                    {
                        count_Chuachuyen += 1;
                        count_Checked += 1;
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
                    if (da_nhan != "")
                    {
                        lbtthongbao.Text = "Đơn đã nhận không thể thu hồi";
                    }
                    else
                    {
                        if (count_Chuachuyen == count_Checked)
                        {
                            lbtthongbao.Text = "Đơn chưa chuyển không thể thu hồi !";
                        }
                        else if (count_Chuachuyen > 0 && iCount > 0)
                        {
                            lbtthongbao.Text = "Hoàn thành thu hồi " + iCount.ToString() + " đơn, " + count_Chuachuyen + " đơn chưa chuyển không thể thu hồi !";
                        }
                        else
                        {
                            lbtthongbao.Text = "Hoàn thành thu hồi " + iCount.ToString() + " đơn !";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = "Lỗi khi chuyển đơn: " + ex.Message;
            }
            //catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            //{
            //    foreach (var validationErrors in dbEx.EntityValidationErrors)
            //    {
            //        foreach (var validationError in validationErrors.ValidationErrors)
            //        {
            //            string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
            //        }
            //    }
            //}

        }
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
        protected void cmdSua_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            if (ddlNoichuyenden.SelectedValue == "1")
            {
                string StrMsg = "PopupReport('/QLAN/GDTTT/Hoso/Popup/SuaToaKhac.aspx','Sửa đổi danh sách',1150,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
            else if (ddlNoichuyenden.SelectedValue == "2")
            {
                string StrMsg = "PopupReport('/QLAN/GDTTT/Hoso/Popup/SuaNgoaiTA.aspx','Sửa đổi danh sách',1150,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
            else
            {
                string StrMsg = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Suadanhsach.aspx','Sửa đổi danh sách',1150,800);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
            }
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            ddlLoaiso.SelectedValue = "0";
            Drop_LoaiSo_SelectedIndexChanged(new object(), new EventArgs());

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
            // ddlPhanloaiDdon.SelectedIndex = 0;
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

            ddl_USER_ID.ClearSelection();
            lstDataUS.Value = "";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "call_fu_set", "ddlMultiSelect_fu_setvalue();", true);

            ddlNoichuyenden_SelectedIndexChanged(new object(), new EventArgs());
        }
        protected void cmdGopdon_Click(object sender, EventArgs e)
        {
            string vArrSelectID = "";
            int count = 0;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    count += 1;
                    if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                    else vArrSelectID = vArrSelectID + "," + chkChon.ToolTip;
                }
            }
            if (count == 0)
            {
                lbtthongbao.Text = "Chưa chọn các đơn để gộp đơn trùng !";
                return;
            }
            else if (count == 1)
            {
                lbtthongbao.Text = "Số lượng chọn để gộp đơn trùng phải lớn hơn 1 !";
                return;
            }
            string[] arrID = vArrSelectID.Split(',');
            decimal DonGocID = Convert.ToDecimal(arrID[0]);
            decimal SoDonTrung = 0;
            decimal dblVuViecID = 0;
            //Update các đơn trùng
            string strKQGQ = "";
            for (int i = 1; i < arrID.Length; i++)
            {
                SoDonTrung += 1;
                decimal ID = Convert.ToDecimal(arrID[i]);
                GDTTT_DON oDT = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                oDT.DONTRUNGID = DonGocID;
                oDT.SOLUONGDON = 1;
                if (oDT.VUVIECID != null)
                {
                    if (oDT.VUVIECID > 0) dblVuViecID = (decimal)oDT.VUVIECID;
                }
                dt.SaveChanges();
                if ((oDT.CV_TRALOI_NOIDUNG + "") != "")
                {
                    if (strKQGQ == "")
                        strKQGQ = oDT.CV_TRALOI_NOIDUNG;
                    else
                        strKQGQ = oDT.CV_TRALOI_NOIDUNG + "\n" + strKQGQ;
                }
                List<GDTTT_DON> lstTrung = dt.GDTTT_DON.Where(x => x.DONTRUNGID == ID).ToList();
                if (lstTrung.Count > 0)
                {
                    foreach (GDTTT_DON d in lstTrung)
                    {
                        d.DONTRUNGID = DonGocID;
                        d.SOLUONGDON = 1;
                        SoDonTrung += 1;
                        dt.SaveChanges();
                        if ((d.CV_TRALOI_NOIDUNG + "") != "")
                        {
                            if (strKQGQ == "")
                                strKQGQ = d.CV_TRALOI_NOIDUNG;
                            else
                                strKQGQ = d.CV_TRALOI_NOIDUNG + "\n" + strKQGQ;
                        }
                    }
                }
            }
            //Update đơn gốc
            GDTTT_DON oDGoc = dt.GDTTT_DON.Where(x => x.ID == DonGocID).FirstOrDefault();
            oDGoc.DONTRUNGID = 0;
            oDGoc.SOLUONGDON = oDGoc.SOLUONGDON + SoDonTrung;
            if (oDGoc.VUVIECID == null || oDGoc.VUVIECID == 0)
            {
                oDGoc.VUVIECID = dblVuViecID;
            }
            if (strKQGQ != "")
            {
                oDGoc.CV_TRALOI_NOIDUNG = strKQGQ + "\n" + oDGoc.CV_TRALOI_NOIDUNG;
            }
            dt.SaveChanges();
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            oBL.UPDATESOLUONGDON(DonGocID);
            Load_Data();
            lbtthongbao.Text = "Hoàn thành gộp đơn !";
        }
        protected void btnKNPhieuchuyen_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);

            Session["GDTTT_MABM"] = "NOIBO_KNTCPHIEUCHUYEN1";

            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                string strSOCV = txtBC_SoCV.Text;

                string vNguoiKy = ddlNguoiKy.SelectedValue;
                string v_chucvu = "";
                string strNguoiky = "";
                if (ddlNguoiKy.SelectedValue != "0")
                {
                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }


                string strNgay = "", strThang = "", strNam = "";
                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                    strNam = dNgayCV.Year.ToString();
                }
                string strPhongban = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                }
                //ĐỊa điểm
                string strDiadiem = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                DTGDTTT objds = new DTGDTTT();

                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i = i + 1;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();

                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TENDONVI = strTendonvi;
                    r.TENPHONGBANGUI = strPhongban;
                    r.SO = strSOCV;
                    r.DIADIEM = strDiadiem;
                    r.NGAY = strNgay;
                    r.THANG = strThang;
                    r.NAM = strNam;
                    r.NGUOIKY = strNguoiky;
                    r.NOIDUNG = oT.NOIDUNGDON + "";

                    r.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    r.DIACHIGUI = obj["Diachigui"] + "";
                    r.GIOITINH = "";
                    r.GIOITINHHOA = "";
                    if ((obj["DUNGDONLA"] + "") == "1")
                    {
                        if ((obj["NGUOIGUI_GIOITINH"] + "") == "1")
                        {
                            r.GIOITINH = "ông";
                            r.GIOITINHHOA = "Ông";
                        }
                        else
                        {
                            r.GIOITINH = "bà";
                            r.GIOITINHHOA = "Bà";
                        }
                    }
                    else if ((obj["DUNGDONLA"] + "") == "2")
                    {
                        r.GIOITINH = "các ông, bà";
                        r.GIOITINHHOA = "Các ông, bà";
                    }
                    if (obj["NGAYGHITRENDON"] != null)
                        r.NGAYGUI = GetDate(obj["NGAYGHITRENDON"]);
                    r.TENDONVINHAN = obj["NOICHUYEN"] + "";


                    r.TMP1 = r.TENDONVINHAN;
                    if (oT.LOAIDON == 3)
                    {
                        if ((oT.CV_SO + "") == "")
                            r.GHICHU = " (do " + oT.CV_TENDONVI + " chuyển đến)";
                        else
                            r.GHICHU = " (do " + oT.CV_TENDONVI + " chuyển đến theo Công văn số " + oT.CV_SO + " ngày " + GetDate(oT.CV_NGAY) + ")";

                    }
                    objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                    objds.AcceptChanges();
                }

                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnKNPhieuchuyenN_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            bool isLOAICV_81 = false;
            Session["GDTTT_MABM"] = "NOIBO_KNTCPHIEUCHUYENN";
            //if (ddlLoaiCV.SelectedValue != "-1" && ddlLoaiCV.SelectedValue != "0")
            //{
            //    decimal IDLoai = Convert.ToDecimal(ddlLoaiCV.SelectedValue);
            //    DM_DATAITEM oLoai = dt.DM_DATAITEM.Where(x => x.ID == IDLoai).FirstOrDefault();
            //    if (oLoai.ID == 1023 || oLoai.CAPCHAID == 1023)
            //    {
            //        isLOAICV_81 = true;
            //        Session["GDTTT_MABM"] = "NOIBO_KNTCPHIEUCHUYENN81";
            //    }
            //}

            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }
                string strSOCV = txtBC_SoCV.Text;

                string vNguoiKy = ddlNguoiKy.SelectedValue;
                string v_chucvu = "";
                string strNguoiky = "";
                if (ddlNguoiKy.SelectedValue != "0")
                {
                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }


                string strNgay = "", strThang = "", strNam = "";
                string strTendonvi = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    strNgay = Cls_Comon.toFullNumber(dNgayCV.Day.ToString(), false);
                    strThang = Cls_Comon.toFullNumber(dNgayCV.Month.ToString(), true);
                    strNam = dNgayCV.Year.ToString();
                }
                string strPhongban = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    strPhongban = oPB.TENPHONGBAN.Replace("TANDTC", " ");
                }
                //ĐỊa điểm
                string strDiadiem = "";
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == "1")
                    strDiadiem = "Hà Nội";
                else strDiadiem = getDiaDiem(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                DTGDTTT objds = new DTGDTTT();

                int i = 0;
                string strDVNhan = "";
                bool isNewDVNhan = false;
                //Order by lại Nơi chuyển đến
                DataView dv = new DataView(oDT);
                dv.Sort = "NOICHUYEN ASC";
                oDT = dv.ToTable();

                foreach (DataRow obj in oDT.Rows)
                {
                    i = i + 1;
                    decimal DonID = Convert.ToDecimal(obj["ID"]);
                    GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == DonID).FirstOrDefault();

                    DTGDTTT.DT_NTA_PHIEUCHUYENRow r = objds.DT_NTA_PHIEUCHUYEN.NewDT_NTA_PHIEUCHUYENRow();
                    r.TENDONVI = strTendonvi;
                    r.TENPHONGBANGUI = strPhongban;
                    r.TENDONVINHAN = obj["NOICHUYEN"] + "";
                    r.SO = strSOCV;
                    r.DIADIEM = strDiadiem;
                    r.NGAY = strNgay;
                    r.THANG = strThang;
                    r.NAM = strNam;
                    r.NGUOIKY = strNguoiky;


                    if (r.TENDONVINHAN != strDVNhan)
                    {
                        strDVNhan = r.TENDONVINHAN;
                        isNewDVNhan = true;
                    }
                    else
                        isNewDVNhan = false;

                    if (isNewDVNhan)
                    {
                        r.TMP1 = r.TENDONVINHAN;
                        if (isLOAICV_81)
                        {
                            if (oT.CD_TK_NOIGUI == 1)
                            {
                                r.TMP1 = "Đồng chí Chánh án " + r.TENDONVINHAN;
                                if (r.TMP1.Contains("cấp cao tại thành phố Hồ"))
                                    r.TMP1 = r.TMP1.Replace("cấp cao tại", "cấp cao\n tại");
                                r.TMP2 = "đồng chí Chánh án ";
                                r.TMP3 = "để chỉ đạo";
                            }
                            else
                            {
                                r.TMP1 = r.TENDONVINHAN;
                                r.TMP2 = "";
                                r.TMP3 = "để xem xét và";
                            }

                        }
                        objds.DT_NTA_PHIEUCHUYEN.AddDT_NTA_PHIEUCHUYENRow(r);
                        objds.AcceptChanges();
                    }
                }

                objds.AcceptChanges();
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Phiếu chuyển',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

        }
        protected void btnKNDanhsach_Click(object sender, EventArgs e)
        {
            SetGetSessionTK(true);
            Session["GDTTT_MABM"] = "NOIBO_KNTCDS";
            DataTable oDT = getDS(0, false, true, false, false, false);
            if (oDT != null)
            {
                if (oDT.Rows.Count == 0)
                {
                    lbtthongbao.Text = "Không có dữ liệu theo yêu cầu tìm kiếm !";
                    return;
                }

                DTGDTTT objds = new DTGDTTT();
                #region "Thông tin tờ trình"
                string vNguoiKy = ddlNguoiKy.SelectedValue;
                string v_chucvu = "";
                string strNguoiky = "";
                if (ddlNguoiKy.SelectedValue != "0")
                {
                    v_chucvu = vNguoiKy.Substring(vNguoiKy.IndexOf("-") + 1);
                    strNguoiky = vNguoiKy.Substring(0, vNguoiKy.IndexOf("-"));
                }



                DTGDTTT.DT_NOIBO_TOTRINHRow r = objds.DT_NOIBO_TOTRINH.NewDT_NOIBO_TOTRINHRow();
                r.SOTOTRINH = txtBC_SoCV.Text;
                r.NGUOIKY = strNguoiky;
                r.TUNGAY = txtNgaynhapTu.Text;
                r.DENNGAY = txtNgaynhapDen.Text;
                DateTime dNgayCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayCV != DateTime.MinValue)
                {
                    r.NGAY = dNgayCV.Day.ToString();
                    r.THANG = dNgayCV.Month.ToString();
                    r.NAM = dNgayCV.Year.ToString();
                }
                r.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                //Phòng ban
                r.TENPHONGBANGUI = "";
                decimal IDNSD = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDNSD).FirstOrDefault();
                if (oNSD.PHONGBANID != null)
                {
                    DM_PHONGBAN oPB = dt.DM_PHONGBAN.Where(x => x.ID == oNSD.PHONGBANID).FirstOrDefault();
                    r.TENPHONGBANGUI = oPB.TENPHONGBAN;
                }
                if (ddlPhongban.SelectedValue != "0")
                    r.TENPHONGBANNHAN = ddlPhongban.SelectedItem.Text;

                objds.DT_NOIBO_TOTRINH.AddDT_NOIBO_TOTRINHRow(r);
                objds.AcceptChanges();
                #endregion
                int i = 0;
                foreach (DataRow obj in oDT.Rows)
                {
                    i += 1;
                    DTGDTTT.DT_KNTC_DANHSACHRow rds = objds.DT_KNTC_DANHSACH.NewDT_KNTC_DANHSACHRow();
                    rds.TT = i.ToString();
                    rds.NGUOIGUI = obj["DONGKHIEUNAI"] + "";
                    rds.DIAPHUONG = obj["Diachigui"] + "";
                    rds.SODON = obj["SODON"] + "";
                    rds.NOIDUNGDON = obj["NOIDUNGTOMTAT"] + "";
                    objds.DT_KNTC_DANHSACH.AddDT_KNTC_DANHSACHRow(rds);
                    objds.AcceptChanges();
                }
                Session["NOIBO_DATASET"] = objds;
            }
            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
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
                                                                            && x.PHONGBANNHANID == CurrDonViNhanID).OrderByDescending(x => x.NGAYCHUYEN).ToList();
                if (lstC.Count > 0)
                {
                    GDTTT_DON_CHUYEN oC = lstC[0];
                    //Xóa thông tin đẫ chuyển từ bảng đơn chuyển
                    dt.GDTTT_DON_CHUYEN.Remove(oC);
                    dt.SaveChanges();

                }
                GDTTT_DON oT = dt.GDTTT_DON.Where(x => x.ID == CurrDonID).FirstOrDefault();
                ////update lai chưa chuyển
                oT.CD_TRANGTHAI = 0;
                dt.SaveChanges();

            }
            catch (Exception ex) { }
        }

        protected void txtBC_Ngaydk_TextChanged(object sender, EventArgs e)
        {
            if (ddlNoichuyenden.SelectedValue != "-1")
            {
                decimal Trangthaidon = 0;
                if (ddlTrangthaidon.SelectedValue == "1" && ddlNoichuyenden.SelectedValue == "0")
                    Trangthaidon = Convert.ToDecimal(ddlTrangthaidon.SelectedValue);
                DateTime vCD_YEARCV = (String.IsNullOrEmpty(txtBC_Ngaydk.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtBC_Ngaydk.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                //txtBC_SoCV.Text = oBL.CV_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), vCD_YEARCV.Year, Convert.ToDecimal(ddlNoichuyenden.SelectedValue), Trangthaidon).ToString();
            }
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

        private void Load_DataCC()
        {

            //lbtthongbao.Text = "";
            lbTFirstCC.Visible = ddlPageCountCC.Visible = lbBFirstCC.Visible = ddlPageCount2CC.Visible = true;
            DataTable oDT = getDS_CC(0, false, false, false, false, false);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPageCC.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCountCC.SelectedValue)).ToString();
                lstSobanghiTCC.Text = lstSobanghiBCC.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> đơn trong <b>" + hddTotalPageCC.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPageCC, hddPageIndexCC, lbTFirstCC, lbBFirstCC, lbTLastCC, lbBLastCC, lbTNextCC, lbBNextCC, lbTBackCC, lbBBackCC, lbTStep1CC, lbBStep1CC, lbTStep2CC,
                             lbBStep2CC, lbTStep3CC, lbBStep3CC, lbTStep4CC, lbBStep4CC, lbTStep5CC, lbBStep5CC, lbTStep6CC, lbBStep6CC);
                #endregion                
            }
            else
            {
                hddTotalPageCC.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPageCC, hddPageIndexCC, lbTFirstCC, lbBFirstCC, lbTLastCC, lbBLastCC, lbTNextCC, lbBNextCC, lbTBackCC, lbBBackCC, lbTStep1CC, lbBStep1CC, lbTStep2CC,
                           lbBStep2CC, lbTStep3CC, lbBStep3CC, lbTStep4CC, lbBStep4CC, lbTStep5CC, lbBStep5CC, lbTStep6CC, lbBStep6CC);
                lstSobanghiTCC.Text = lstSobanghiBCC.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgListCC.PageSize = Convert.ToInt32(ddlPageCountCC.SelectedValue);
            dgListCC.DataSource = oDT;
            dgListCC.DataBind();

        }
        protected void dgListCC_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {

                case "ChiTiet":
                    string StrMsgArr = "PopupReport('/QLAN/GDTTT/Hoso/Popup/Thongtindon_cc.aspx?ID=" + e.CommandArgument + "','Thông tin đơn tòa cấp cao',2000,1000);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsgArr, true);
                    break;


            }

        }
        protected void dgListCC_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            Decimal ChucDanh_TPTATC = 0;
            try { ChucDanh_TPTATC = dt.DM_DATAITEM.Where(x => x.MA == "TPTATC").FirstOrDefault().ID; } catch (Exception ex) { }
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
            //----------------
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                Panel pn_TTGQ = (Panel)e.Item.FindControl("pn_TTGQCC");
                Panel pn_TTGQ_VT = (Panel)e.Item.FindControl("pn_TTGQ_VTCC");
                Panel pn_TTNGDVG = (Panel)e.Item.FindControl("pn_TTNGDVGCC");
                Panel pn_TTNGDVG_VT = (Panel)e.Item.FindControl("pn_TTNGDVG_VTCC");
                Panel pn_TTD = (Panel)e.Item.FindControl("pn_TTDCC");
                Panel pn_TTD_VT = (Panel)e.Item.FindControl("pn_TTD_VTCC");
                Panel pn_THAOTAC = (Panel)e.Item.FindControl("pn_THAOTACCC");
                //Panel pn_THAOTAC_VT = (Panel)e.Item.FindControl("pn_THAOTAC_VTCC");
                Panel pn_TTD_HCTP = (Panel)e.Item.FindControl("pn_TTD_HCTPCC");
                Panel pnDSYCBS = (Panel)e.Item.FindControl("pnDSYCBSCC");
                //------------------

                String TRANG_THAI_XLY = ((DataRowView)e.Item.DataItem)["TRANG_THAI_XLY"].ToString();
                String CANBO_NHAN_ID = ((DataRowView)e.Item.DataItem)["CANBO_NHAN_ID"].ToString();
                String LOAIDON = ((DataRowView)e.Item.DataItem)["LOAIDON"].ToString();
                String YCBS = ((DataRowView)e.Item.DataItem)["YCBS"].ToString();

                if (TRANG_THAI_XLY == "3")//du lieu don thu chưa xử lý
                {

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

                    pn_TTGQ.Visible = true;
                    pn_TTGQ_VT.Visible = false;
                    pn_TTNGDVG.Visible = true;
                    pn_TTNGDVG_VT.Visible = false;
                    pn_TTD.Visible = true;
                    pn_TTD_VT.Visible = false;
                    pn_THAOTAC.Visible = true;
                    //pn_THAOTAC_VT.Visible = false;
                    pn_TTD_HCTP.Visible = true;


                }
                if (YCBS != "")
                {
                    pnDSYCBS.Visible = true;
                }
                else pnDSYCBS.Visible = false;
            }
        }

        #region "Phân trang"
        protected void lbTBackCC_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndexCC.Value = (Convert.ToInt32(hddPageIndexCC.Value) - 1).ToString();
            Load_DataCC();
        }
        protected void lbTFirstCC_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = 0;
            hddPageIndexCC.Value = "1";
            Load_DataCC();
        }
        protected void lbTLastCC_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndexCC.Value = Convert.ToInt32(hddTotalPageCC.Value).ToString();
            Load_DataCC();
        }
        protected void lbTNextCC_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndexCC.Value) + 1).ToString();
            Load_DataCC();
        }
        protected void lbTStepCC_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndexCC.Value = lbCurrent.Text;
            Load_DataCC();
        }
        protected void ddlPageCountCC_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2CC.SelectedValue = ddlPageCountCC.SelectedValue;
            //  dgList.CurrentPageIndex = 0;
            hddPageIndexCC.Value = "1";
            Load_DataCC();
        }
        protected void ddlPageCount2CC_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCountCC.SelectedValue = ddlPageCount2CC.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndexCC.Value = "1";
            Load_DataCC();
        }
        #endregion

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
