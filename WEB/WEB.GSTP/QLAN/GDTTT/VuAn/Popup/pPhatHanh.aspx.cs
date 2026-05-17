using BL.GSTP.BANGSETGET;
using BL.GSTP.Danhmuc;
using BL.GSTP.GDTTT;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class pPhatHanh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public int countDonVi = 0, countDoiTuong = 0, indexDgDS = 1;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {                
                LoadVBPH();
                LoadData();
            }
        }
        private void LoadVBPH()
        {
            dropVBPH.Items.Clear();
            decimal vID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            DataTable tb = oBL.GET_VAN_BAN_PHAT_HANH(vID);
            if (tb.Rows.Count > 0)
            {
                dropVBPH.DataSource = tb;
                dropVBPH.DataTextField = "VBPH";
                dropVBPH.DataValueField = "ID";
                dropVBPH.DataBind();
            }
            else
            {     
                Cls_Comon.SetButton(cmdPhatHanh, false);
            }
            dropVBPH.Items.Insert(0, new ListItem("-- Chọn --", "0"));
        }
        private void LoadNoiNhanDonVi()
        {
            decimal vID = Convert.ToDecimal(Request["vID"]);
            string giaiDoan = Regex.Replace(dropVBPH.SelectedValue, @"[\d]", string.Empty);
            decimal vbID = dropVBPH.SelectedValue.Contains("HS") ? Convert.ToDecimal(dropVBPH.SelectedValue.Replace("HS","")) : 0;
            TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            DataTable obj = oBL.GET_VAN_BAN_PHAT_HANH_NOINHAN(vID, vbID, giaiDoan);
            countDonVi = obj.Rows.Count;
            rptDonVi.DataSource = obj;
            rptDonVi.DataBind();
        }
        private void LoadNoiNhanDoiTuong()
        {
            string strVID = Request["vID"] + "";
            TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            decimal vID = Convert.ToDecimal(strVID);
            GDTTT_VUAN oVA = dt.GDTTT_VUAN.Where(x => x.ID == vID).FirstOrDefault();
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.VUVIECID == vID && x.ISTHULY == 1).FirstOrDefault();
            //TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            string giaiDoan = Regex.Replace(dropVBPH.SelectedValue, @"[\d]", string.Empty);
            decimal isKhangNghi = dropVBPH.SelectedItem.Text.Contains("Kháng nghị") ? 1 : 0;
            if (dropVBPH.SelectedValue.Contains("GDT")) isKhangNghi = 1;
            decimal vThuLy = oDon == null ? 1 : 2;
            DataTable obj = oBL.GET_VBPH_NOINHAN_DOITUONG(vID, giaiDoan, oVA.LOAIAN, vThuLy, isKhangNghi);
            countDoiTuong = obj.Rows.Count;
            rptDoiTuong.DataSource = obj;
            rptDoiTuong.DataBind();
        }
        private void LoadData()
        {
            decimal vID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            dgDS.DataSource = oBL.GET_TONGDAT_GDKT(vID);
            dgDS.DataBind();
        }
        private void Reset()
        {
            pnVBPH.Visible = true;
            txtTenVBPH.Text = "";
            pnDoiTuong.Visible = pnDonVi.Visible = lbtNoiNhan.Visible = false;
            hddID.Value = "0";
            lbtthongbao.Text = "";
            LoadVBPH();
            rptDoiTuong.DataSource = rptDonVi.DataSource = null;
            rptDoiTuong.DataBind();
            rptDonVi.DataBind();
            ENUM_GDTTT_TONGDAT td = new ENUM_GDTTT_TONGDAT();
            Session[ENUM_GDTTT_TONGDAT.IS_PHBS] = "0";
            Session[ENUM_GDTTT_TONGDAT.IS_PHATHANHLAI] = "0";
        }
        private bool CheckValid()
        {
            bool checkDoiTuong = false;
            if (rptDonVi.Items.Count > 0)
            {
                foreach (RepeaterItem Item in rptDonVi.Items)
                {
                    TextBox txtTenDonVi = (TextBox)Item.FindControl("txtTenDonVi");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtDiaChi = (TextBox)Item.FindControl("txtDiaChi");
                    DropDownList dropHinhThucGui = (DropDownList)Item.FindControl("dropHinhThucGui");
                    CheckBox chkDoiTuong = (CheckBox)Item.FindControl("chkTongDat");
                    if (chkDoiTuong.Checked) checkDoiTuong = true;
                    if (txtTenDonVi.Text == "")
                    {
                        lbtthongbao.Text = "Tên đơn vị không được để trống!";
                        txtTenDonVi.Focus();
                        return false;
                    }
                    if (dropHinhThucGui.SelectedValue == "0" || dropHinhThucGui.SelectedValue == "5")
                    {
                        if (txtNgaygui.Text == "")
                        {
                            lbtthongbao.Text = "Ngày gửi không được để trống!";
                            txtNgaygui.Focus();
                            return false;
                        }
                        if (txtDiaChi.Text == "")
                        {
                            lbtthongbao.Text = "Địa chỉ không được để trống!";
                            txtDiaChi.Focus();
                            return false;
                        }
                    }
                }
            }
            if (rptDoiTuong.Items.Count > 0)
            {
                foreach (RepeaterItem Item in rptDoiTuong.Items)
                {
                    TextBox txtTen = (TextBox)Item.FindControl("txtTen");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    TextBox txtTCTT = (TextBox)Item.FindControl("txtTCTT");
                    TextBox txtDiaChi = (TextBox)Item.FindControl("txtDiaChi");
                    DropDownList dropHinhThucGui = (DropDownList)Item.FindControl("dropHinhThucGui");
                    CheckBox chkDoiTuong = (CheckBox)Item.FindControl("chkTongDat");
                    if (chkDoiTuong.Checked) checkDoiTuong = true;
                    if (txtTen.Text == "")
                    {
                        lbtthongbao.Text = "Tên đương sự không được để trống!";
                        txtTen.Focus();
                        return false;
                    }
                    if (txtTCTT.Text == "")
                    {
                        lbtthongbao.Text = "Tư cách tố tụng không được để trống!";
                        txtTCTT.Focus();
                        return false;
                    }
                    if (dropHinhThucGui.SelectedValue == "0" || dropHinhThucGui.SelectedValue == "5")
                    {                      
                        if (txtNgaygui.Text == "")
                        {
                            lbtthongbao.Text = "Ngày gửi không được để trống!";
                            txtNgaygui.Focus();
                            return false;
                        }
                        if (txtDiaChi.Text == "")
                        {
                            lbtthongbao.Text = "Địa chỉ không được để trống!";
                            txtDiaChi.Focus();
                            return false;
                        }
                    }
                }
            }
            if (!checkDoiTuong)
            {
                lbtthongbao.Text = "Chưa có đối tượng tống đạt!";
                return false;
            }
            return true;
        }

        protected void cmdPhatHanh_Click(object sender, EventArgs e)
        {
            if (!CheckValid()) return;
            TONGDAT_GDKT oT = new TONGDAT_GDKT();
            string strVID = Request["vID"] + "";
            TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            decimal vID = Convert.ToDecimal(strVID);
            GDTTT_VUAN va = dt.GDTTT_VUAN.Where(x => x.ID == vID).FirstOrDefault();
            if (hddID.Value == "" || hddID.Value == "0")
            {
                oT.ID = 0;
                oT.NGAYTAO = DateTime.Now;
                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                string tenVBPH = dropVBPH.SelectedItem.Text;
                int index = tenVBPH.IndexOf("số") == -1 ? tenVBPH.Length : tenVBPH.IndexOf("số") - 1;
                if (dropVBPH.SelectedValue.Contains("HS"))
                {
                    oT.GIAIDOAN = 1;
                    oT.ID_HS_TLDON = dropVBPH.SelectedValue;
                    oT.LOAIVB = tenVBPH.Substring(0, index).Trim();
                    decimal hsID = Convert.ToDecimal(dropVBPH.SelectedValue.Replace("HS", ""));
                    GDTTT_QUANLYHS hs = dt.GDTTT_QUANLYHS.Where(x => x.ID == hsID).FirstOrDefault();
                    oT.SOVB = hs.SOPHIEU.ToString();
                    oT.NGAYVB = hs.NGAYTAO;
                }
                else if (dropVBPH.SelectedValue.Contains("GQD"))
                {
                    oT.GIAIDOAN = 2;
                    oT.LOAIVB = tenVBPH.Substring(0, index).Trim();
                    if (va.LOAIAN != 1)
                    {
                        oT.ID_HS_TLDON = dropVBPH.SelectedValue.Replace("GQD", "VA");
                        oT.SOVB = va.GDQ_SO;
                        oT.NGAYVB = va.GDQ_NGAY;
                        oT.NGUOIKY = va.GDQ_NGUOIKY;
                    }
                    else
                    {
                        GDTTT_DON_TRALOI tl = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == va.ID).FirstOrDefault();
                        oT.ID_HS_TLDON = dropVBPH.SelectedValue.Replace("GQD", "TL");
                        if (tl != null)
                        {
                            oT.SOVB = tl.SO;
                            oT.NGAYVB = tl.NGAY;
                            oT.NGUOIKY = tl.NGUOIKY;
                        }
                        else
                        {
                            oT.SOVB = va.GDQ_SO;
                            oT.NGAYVB = va.GDQ_NGAY;
                            oT.NGUOIKY = va.GDQ_NGUOIKY;
                        }
                    }
                }
                else if (dropVBPH.SelectedValue.Contains("GDT"))
                {
                    oT.GIAIDOAN = 3;
                    oT.ID_HS_TLDON = dropVBPH.SelectedValue.Replace("GDT", "VA");
                    oT.LOAIVB = tenVBPH.Substring(0, index).Trim();
                    if (dropVBPH.SelectedItem.Text.Contains("Thông báo thụ lý xét xử GĐT"))
                    {
                        oT.SOVB = va.SOTHULYXXGDT;
                        oT.NGAYVB = va.NGAYTHULYXXGDT;
                    }
                    else
                    {
                        oT.SOVB = va.XXGDTTT_SOQD;
                        oT.NGAYVB = va.XXGDTTT_NGAYQD;
                    }
                }
                else if (dropVBPH.SelectedValue.Contains("DBQH"))
                {
                    oT.GIAIDOAN = 4;
                    oT.ID_HS_TLDON = dropVBPH.SelectedValue.Replace("DBQH", "TL");
                    oT.LOAIVB = tenVBPH.Substring(0, index).Trim();
                    GDTTT_DON_TRALOI tl = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == va.ID).FirstOrDefault();
                    oT.SOVB = tl.SO;
                    oT.NGAYVB = tl.NGAY;
                    oT.NGUOIKY = tl.NGUOIKY;
                }
            }
            else
            {
                oT.ID = Convert.ToDecimal(hddID.Value);
                DataTable oTG = oBL.TONGDAT_GDKT_GETBYID(oT.ID);                
                if (oTG.Rows[0]["GIAIDOAN"] + "" != "") oT.GIAIDOAN = Convert.ToDecimal(oTG.Rows[0]["GIAIDOAN"].ToString());
                if (oTG.Rows[0]["ID_HS_TLDON"] + "" != "") oT.ID_HS_TLDON = oTG.Rows[0]["ID_HS_TLDON"].ToString();
                if (oTG.Rows[0]["LOAIVB"] + "" != "") oT.LOAIVB = oTG.Rows[0]["LOAIVB"].ToString();
                if (oTG.Rows[0]["SOVB"] + "" != "") oT.SOVB = oTG.Rows[0]["SOVB"].ToString();
                if (oTG.Rows[0]["NGAYVB"] + "" != "") oT.NGAYVB = Convert.ToDateTime(oTG.Rows[0]["NGAYVB"].ToString());
                if (oTG.Rows[0]["NGUOIKY"] + "" != "") oT.LYDOTHUHOI = oTG.Rows[0]["NGUOIKY"].ToString();
                if (oTG.Rows[0]["LYDOTHUHOI"] + "" != "") oT.LYDOTHUHOI = oTG.Rows[0]["LYDOTHUHOI"].ToString();
                if (oTG.Rows[0]["NGAYTHUHOI"] + "" != "") oT.NGAYTHUHOI = Convert.ToDateTime(oTG.Rows[0]["NGAYTHUHOI"].ToString());
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }
            oT.VUAN_ID = vID;
            oT.LOAIANID = va.LOAIAN;                        
            oT.TENVANBAN = txtTenVBPH.Text;
            decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
            oT.DONVIPHATHANH_ID = phongBanID;
            oT.DONVIPHATHANH = pb.TENPHONGBAN;
            oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            oT.ID = oBL.TONGDAT_GDKT_UP_IN(oT);
            List<Object> arrDoiTuong = new List<object>();
            if (rptDoiTuong.Items.Count > 0)
            {
                foreach (RepeaterItem Item in rptDoiTuong.Items)
                {
                    TextBox txtTenDuongSu = (TextBox)Item.FindControl("txtTen");
                    TextBox txtTCTT = (TextBox)Item.FindControl("txtTCTT");
                    TextBox txtDiaChi = (TextBox)Item.FindControl("txtDiaChi");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    DropDownList dropHinhThucGui = (DropDownList)Item.FindControl("dropHinhThucGui");
                    CheckBox chkTongDat = (CheckBox)Item.FindControl("chkTongDat");
                    HiddenField hddDoiTuong = (HiddenField)Item.FindControl("hddDoiTuong");
                    HiddenField hddID = (HiddenField)Item.FindControl("hddID");
                    HiddenField hddBoSung = (HiddenField)Item.FindControl("hddBoSung");
                    HiddenField hddPhatHanhLaiID = (HiddenField)Item.FindControl("hddPhatHanhLaiID");
                    TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                    if (hddID.Value == "" || hddID.Value == "0")
                    {
                        oN.ID = 0;
                        oN.DOITUONG = Convert.ToDecimal(hddDoiTuong.Value);                        
                        oN.NGAYTAO = DateTime.Now;
                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oN.PHATHANHLAI_ID = Convert.ToDecimal(hddPhatHanhLaiID.Value);
                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                    }
                    else
                    {
                        oN.ID = Convert.ToDecimal(hddID.Value);
                        DataTable oTGN = oBL.TONGDAT_GDKT_NOINHAN_GETBYID(oN.ID);
                        oN.DOITUONG = Convert.ToDecimal(oTGN.Rows[0]["DOITUONG"].ToString());
                        decimal trangThaiCu = Convert.ToDecimal(oTGN.Rows[0]["TRANGTHAI"].ToString());
                        if (oTGN.Rows[0]["TRANGTHAI"] + "" != "0" && (oTGN.Rows[0]["TRANGTHAI"] + "" != "2" && !chkTongDat.Checked))
                            oN.TRANGTHAI = trangThaiCu;
                        else oN.TRANGTHAI = chkTongDat.Checked ? 1 : 0;
                        if (dropHinhThucGui.SelectedValue == "0" && trangThaiCu != 4 && trangThaiCu != 5 && chkTongDat.Checked) oN.TRANGTHAI = 6;
                        if (dropHinhThucGui.SelectedValue == "5" && trangThaiCu != 4 && trangThaiCu != 5 && chkTongDat.Checked) oN.TRANGTHAI = 7;
                        if (oTGN.Rows[0]["LYDO"] + "" != "") oN.LYDO = oTGN.Rows[0]["LYDO"].ToString();
                        if (oTGN.Rows[0]["NGAYGUI"].ToString() != "") oN.NGAYGUI = Convert.ToDateTime(oTGN.Rows[0]["NGAYGUI"].ToString());
                        if (oTGN.Rows[0]["NGAYPHATHANH"] + "" != "") oN.NGAYPHATHANH = Convert.ToDateTime(oTGN.Rows[0]["NGAYPHATHANH"].ToString());
                        if (oTGN.Rows[0]["NGAYNHAN"] + "" != "") oN.NGAYNHAN = Convert.ToDateTime(oTGN.Rows[0]["NGAYNHAN"].ToString());
                        if (oTGN.Rows[0]["PHATHANHLAI_ID"] + "" != "" && oTGN.Rows[0]["PHATHANHLAI_ID"] + "" != "0") oN.PHATHANHLAI_ID = Convert.ToDecimal(oTGN.Rows[0]["PHATHANHLAI_ID"].ToString());
                    }
                    if (oN.TRANGTHAI == 0 || oN.TRANGTHAI == null)
                        oN.TRANGTHAI = chkTongDat.Checked ? 1 : 0;                    
                    oN.NOINHAN = txtTenDuongSu.Text;
                    oN.TUCACHTOTUNG = txtTCTT.Text;
                    oN.DIACHI = txtDiaChi.Text;
                    oN.TONGDAT_GDKT_ID = oT.ID;
                    oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                    DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                    decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                    if (isVBPH == 0)
                    {
                        oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    else if (isVBPH == 1 && chkTongDat.Checked) { oN.NGAYGUI = DateTime.Now; }
                    oN.ID = oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                    if (Session[ENUM_GDTTT_TONGDAT.IS_PHBS] + "" == "1")
                    {
                        if (chkTongDat.Checked && hddBoSung.Value == "1")
                        {
                            var oDT = new
                            {
                                noiNhan = oN.NOINHAN,
                                tuCachToTung = oN.TUCACHTOTUNG == null ? "" : oN.TUCACHTOTUNG,
                                diaChi = oN.DIACHI,
                                hinhThucGui = oN.HINHTHUCGUI,
                                phatHanhLaiId = oN.PHATHANHLAI_ID == null ? 0 : oN.PHATHANHLAI_ID,
                                noiNhanId = oN.ID
                            };
                            arrDoiTuong.Add(oDT);
                        }
                    }
                    else
                    {
                        if (chkTongDat.Checked)
                        {
                            var oDT = new
                            {
                                noiNhan = oN.NOINHAN,
                                tuCachToTung = oN.TUCACHTOTUNG == null ? "" : oN.TUCACHTOTUNG,
                                diaChi = oN.DIACHI,
                                hinhThucGui = oN.HINHTHUCGUI,
                                phatHanhLaiId = oN.PHATHANHLAI_ID == null ? 0 : oN.PHATHANHLAI_ID,
                                noiNhanId = oN.ID
                            };
                            arrDoiTuong.Add(oDT);
                        }
                    }
                }
            }
            if (rptDonVi.Items.Count > 0)
            {
                foreach (RepeaterItem Item in rptDonVi.Items)
                {
                    TextBox txtTenDonVi = (TextBox)Item.FindControl("txtTenDonVi");
                    TextBox txtDiaChi = (TextBox)Item.FindControl("txtDiaChi");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    DropDownList dropHinhThucGui = (DropDownList)Item.FindControl("dropHinhThucGui");
                    HiddenField hddID = (HiddenField)Item.FindControl("hddID");
                    HiddenField hddDonViID = (HiddenField)Item.FindControl("hddDonViID");
                    CheckBox chkTongDat = (CheckBox)Item.FindControl("chkTongDat");
                    HiddenField hddDoiTuong = (HiddenField)Item.FindControl("hddDoiTuong");
                    HiddenField hddBoSung = (HiddenField)Item.FindControl("hddBoSung");
                    HiddenField hddPhatHanhLaiID = (HiddenField)Item.FindControl("hddPhatHanhLaiID");
                    TONGDAT_GDKT_NOINHAN oN = new TONGDAT_GDKT_NOINHAN();
                    if (hddID.Value == "" || hddID.Value == "0")
                    {
                        oN.ID = 0;
                        oN.DOITUONG = Convert.ToDecimal(hddDoiTuong.Value);
                        if (oN.DOITUONG == 2 && hddDonViID.Value != "")
                        {
                            oN.NOINHAN_ID = Convert.ToDecimal(hddDonViID.Value);
                        }                       
                        oN.NGAYTAO = DateTime.Now;
                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oN.PHATHANHLAI_ID = Convert.ToDecimal(hddPhatHanhLaiID.Value);
                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                    }
                    else
                    {
                        oN.ID = Convert.ToDecimal(hddID.Value);
                        DataTable oTGN = oBL.TONGDAT_GDKT_NOINHAN_GETBYID(oN.ID);
                        oN.DOITUONG = Convert.ToDecimal(oTGN.Rows[0]["DOITUONG"].ToString());
                        if (oTGN.Rows[0]["NOINHAN_ID"] + "" != "") oN.NOINHAN_ID = Convert.ToDecimal(oTGN.Rows[0]["NOINHAN_ID"].ToString());
                        decimal trangThaiCu = Convert.ToDecimal(oTGN.Rows[0]["TRANGTHAI"].ToString());
                        if ((oTGN.Rows[0]["TRANGTHAI"] + "" == "0" || oTGN.Rows[0]["TRANGTHAI"] + "" == "2") && chkTongDat.Checked)
                            oN.TRANGTHAI = 1;
                        else oN.TRANGTHAI = trangThaiCu;
                        if (dropHinhThucGui.SelectedValue == "0" && trangThaiCu != 4 && trangThaiCu != 5) oN.TRANGTHAI = 6;
                        if (dropHinhThucGui.SelectedValue == "5" && trangThaiCu != 4 && trangThaiCu != 5) oN.TRANGTHAI = 7;
                        if (oTGN.Rows[0]["LYDO"] + "" != "") oN.LYDO = oTGN.Rows[0]["LYDO"].ToString();
                        if (oTGN.Rows[0]["NGAYGUI"].ToString() != "") oN.NGAYGUI = Convert.ToDateTime(oTGN.Rows[0]["NGAYGUI"].ToString());
                        if (oTGN.Rows[0]["NGAYPHATHANH"] + "" != "") oN.NGAYPHATHANH = Convert.ToDateTime(oTGN.Rows[0]["NGAYPHATHANH"].ToString());
                        if (oTGN.Rows[0]["NGAYNHAN"] + "" != "") oN.NGAYNHAN = Convert.ToDateTime(oTGN.Rows[0]["NGAYNHAN"].ToString());
                        if (oTGN.Rows[0]["PHATHANHLAI_ID"] + "" != "" && oTGN.Rows[0]["PHATHANHLAI_ID"] + "" != "0") oN.PHATHANHLAI_ID = Convert.ToDecimal(oTGN.Rows[0]["PHATHANHLAI_ID"].ToString());
                    }
                    if (oN.TRANGTHAI == 0 || oN.TRANGTHAI == null)  oN.TRANGTHAI = chkTongDat.Checked ? 1 : 0;                   
                    oN.NOINHAN = txtTenDonVi.Text;
                    oN.DIACHI = txtDiaChi.Text;
                    oN.TONGDAT_GDKT_ID = oT.ID;
                    oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                    DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                    decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                    if (isVBPH == 0)
                    {
                        oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    else if(isVBPH == 1 && chkTongDat.Checked) { oN.NGAYGUI = DateTime.Now; }
                    oN.ID = oBL.TONGDAT_GDKT_NOINHAN_UP_IN(oN);
                    if (Session[ENUM_GDTTT_TONGDAT.IS_PHBS] + "" == "1")
                    {
                        if (chkTongDat.Checked && hddBoSung.Value == "1")
                        {
                            var oDT = new
                            {
                                noiNhan = oN.NOINHAN,
                                tuCachToTung = oN.TUCACHTOTUNG == null ? "" : oN.TUCACHTOTUNG,
                                diaChi = oN.DIACHI,
                                hinhThucGui = oN.HINHTHUCGUI,
                                phatHanhLaiId = oN.PHATHANHLAI_ID == null ? 0 : oN.PHATHANHLAI_ID,
                                noiNhanId = oN.ID
                            };
                            arrDoiTuong.Add(oDT);
                        }
                    }
                    else
                    {
                        if (chkTongDat.Checked)
                        {
                            var oDT = new
                            {
                                noiNhan = oN.NOINHAN,
                                tuCachToTung = oN.TUCACHTOTUNG == null ? "" : oN.TUCACHTOTUNG,
                                diaChi = oN.DIACHI,
                                hinhThucGui = oN.HINHTHUCGUI,
                                phatHanhLaiId = oN.PHATHANHLAI_ID == null ? 0 : oN.PHATHANHLAI_ID,
                                noiNhanId = oN.ID
                            };
                            arrDoiTuong.Add(oDT);
                        }
                    }                    
                }
            }
            try
            {
                //gọi api tongdat_gdkt     
                WebClient client = new WebClient();
                string apiUrl = ConfigurationManager.AppSettings["IpTongDat"] + "tongdat_gdkt";
                var input = new
                {
                    id = oT.ID,
                    loaiVB = oT.LOAIVB,
                    tenVanBan = oT.TENVANBAN,
                    soVB = oT.SOVB,
                    ngayVB = oT.NGAYVB,
                    nguoiKy = oT.NGUOIKY == null ? "" : oT.NGUOIKY,
                    donViPhatHanh = oT.DONVIPHATHANH,
                    toaAnId = oT.TOAANID,
                    doiTuong = arrDoiTuong
                };
                var objInput = new object[] { input };
                string inputJson = JsonConvert.SerializeObject(objInput);
                client.Headers.Clear();
                client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                client.Encoding = Encoding.UTF8;
                string result = client.UploadString(apiUrl, inputJson);
                if (result != "SUCCESS")
                {
                    lbThongbao.Text = result;
                    LoadData();
                    Reset();
                    return;
                }
            }
            catch (Exception ex)
            {
                lbThongbao.Text = ex.Message;
            }
            
            string mess = "Lưu thành công!";
            lbtthongbao.Text = mess;
            LoadData();
            Reset();
        }

        protected void dropVBPH_SelectedIndexChanged(object sender, EventArgs e)
        {
            rptDoiTuong.DataSource = rptDonVi.DataSource = null;
            rptDoiTuong.DataBind();
            rptDonVi.DataBind();           
            if (dropVBPH.SelectedValue == "0")
            {
                pnDoiTuong.Visible = pnDonVi.Visible = lbtNoiNhan.Visible = false;
                txtTenVBPH.Text = "";
            }
            else
            {
                lbtNoiNhan.Visible = true;
                txtTenVBPH.Text = dropVBPH.SelectedItem.Text;
                pnDonVi.Visible = true;
                LoadNoiNhanDonVi();
                pnDoiTuong.Visible = true;
                if (dropVBPH.SelectedValue.Contains("GQD") || dropVBPH.SelectedValue.Contains("GDT"))
                {
                    LoadNoiNhanDoiTuong();
                    pnDoiTuong.Visible = true;
                }
                else pnDoiTuong.Visible = false;
            }           
        }

        private void LoadEdit(decimal ID, decimal NoiNhanID)
        {
            hddID.Value = ID.ToString();
            Cls_Comon.SetButton(cmdPhatHanh, true);
            pnVBPH.Visible = false;            
            TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            DataTable oTD = oBL.TONGDAT_GDKT_GETBYID(ID);          
            txtTenVBPH.Text = oTD.Rows[0]["TENVANBAN"].ToString();
            LoadNoiNhanDonViEdit(ID, NoiNhanID);
            pnDonVi.Visible = true;
            pnDoiTuong.Visible = true;
            if (oTD.Rows[0]["GIAIDOAN"] + "" == "2" || oTD.Rows[0]["GIAIDOAN"] + "" == "3")
            {
                LoadNoiNhanDoiTuongEdit(ID, NoiNhanID);
                pnDoiTuong.Visible = true;
            }
            else
            {
                rptDoiTuong.DataSource = null;
                rptDoiTuong.DataBind();
                pnDoiTuong.Visible = false;
            }
        }
        private void LoadNoiNhanDonViEdit(decimal ID, decimal NoiNhanID)
        {
            TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            DataTable obj = oBL.GET_VBPH_NOINHAN_EDIT(ID, 2, NoiNhanID);
            countDonVi = obj.Rows.Count;
            rptDonVi.DataSource = obj;
            rptDonVi.DataBind();
        }
        private void LoadNoiNhanDoiTuongEdit(decimal ID, decimal NoiNhanID)
        {
            TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
            DataTable obj = oBL.GET_VBPH_NOINHAN_EDIT(ID, 1, NoiNhanID);
            countDoiTuong = obj.Rows.Count;
            rptDoiTuong.DataSource = obj;
            rptDoiTuong.DataBind();
        }
        protected void dgDS_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            //decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
            string IDs = e.CommandArgument.ToString();
            decimal ID = Convert.ToDecimal(IDs.Split('#')[1]);
            decimal NoiNhanID = Convert.ToDecimal(IDs.Split('#')[0]);
            Session[ENUM_GDTTT_TONGDAT.IS_PHBS] = "0";
            Session[ENUM_GDTTT_TONGDAT.IS_PHATHANHLAI] = "0";
            switch (e.CommandName)
            {
                //case "Sua":
                //    LoadEdit(ID);
                //    break;
                //case "Xoa":
                //    TONGDAT_GDKT_BL oBLDel = new TONGDAT_GDKT_BL();
                //    oBLDel.TONGDAT_GDKT_DEL(ID);
                //    string mess = "Xóa thành công!";
                //    Reset();
                //    Cls_Comon.SetButton(cmdPhatHanh, true);
                //    lbtthongbao.Text = mess;
                //    LoadData();
                //    break;
                //case "LichSu":
                //    break;
                //case "PHBS":
                //    Session[ENUM_GDTTT_TONGDAT.IS_PHBS]  = "1";
                //    LoadEdit(ID);
                //    break;
                case "PhatHanhLai":
                    Session[ENUM_GDTTT_TONGDAT.IS_PHATHANHLAI] = "1";
                    
                    LoadEdit(ID, NoiNhanID);
                    break;
                case "VBDH_SUA":
                    try {
                        //gọi api tong - dat - gdkt - thu - hoi
                        WebClient client = new WebClient();
                        string apiUrl = ConfigurationManager.AppSettings["IpTongDat"] + "mo-khoa-tong-dat";
                        var input = new
                        {
                            tongDatId = ID,
                            duongSuId = NoiNhanID
                        };
                        string inputJson = JsonConvert.SerializeObject(input);
                        client.Headers.Clear();
                        client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                        client.Encoding = Encoding.UTF8;
                        string result = client.UploadString(apiUrl, inputJson);
                        if (result != "SUCCESS")
                        {
                            lbThongbao.Text = result;
                            LoadData();
                            break;
                        }
                    }
                    catch (Exception ex)
                    {
                        lbtthongbao.Text = ex.Message;
                    }
                    
                    TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                    oBL.TONGDAT_GDKT_DONG_MO_KHOA(NoiNhanID, 1);
                    string mess = "Mở khóa tống đạt thành công!";
                    lbtthongbao.Text = mess;
                    LoadData();
                    break;
                case "VBDH_DONG":
                    break;
            }
        }

        protected void dgDS_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton cmdPHLai = (LinkButton)e.Item.FindControl("cmdPhatHanhLai");
                LinkButton cmdVBHDSua = (LinkButton)e.Item.FindControl("cmdVBHDSua");
                LinkButton cmdVBDHDong = (LinkButton)e.Item.FindControl("cmdVBDHDong");
                if (rowView["RN"] + "" == "1")
                {
                    e.Item.Cells[0].RowSpan = Convert.ToInt16(rowView["ROWSPAN"] + "");
                    e.Item.Cells[1].Text = indexDgDS + "";
                    indexDgDS++;
                    e.Item.Cells[1].RowSpan = Convert.ToInt16(rowView["ROWSPAN"] + "");
                    e.Item.Cells[2].RowSpan = Convert.ToInt16(rowView["ROWSPAN"] + "");
                }
                else
                {
                    e.Item.Cells[0].Visible = false;
                    e.Item.Cells[1].Visible = false;
                    e.Item.Cells[2].Visible = false;
                }
                if(rowView["TRANGTHAI"] + "" == "Phát hành không thành công" )
                {
                    if(rowView["HAS_PHATHANHLAI"] + "" == "1") cmdPHLai.Visible = true;
                    if (rowView["IS_SUA"] + "" == "0") cmdVBHDSua.Visible = true;
                    else cmdVBDHDong.Visible = true;
                }
                else if (rowView["TRANGTHAI"] + "" == "Phát hành thành công")
                {
                    if(rowView["IS_SUA"] + "" == "0") cmdVBHDSua.Visible = true;
                    else cmdVBDHDong.Visible = true;
                }
            }
            
        }

        public class NOINHAN_DUONGSU
        {
            public string ID { get; set; }

            public string NOINHAN { get; set; }

            public string TUCACHTOTUNG { get; set; }

            public string DOITUONG { get; set; }

            public string DIACHI { get; set; }

            public bool CHECKTONGDAT { get; set; }

            public string NGAYGUI { get; set; }

            public string HINHTHUCGUI { get; set; }

            public string TRANGTHAI { get; set; }

            public string ISBOSUNG { get; set; }

            public string PHATHANHLAI_ID { get; set; }
        }

        public class NOINHAN_DONVI
        {
            public string ID { get; set; }

            public string NOINHANID { get; set; }

            public string NOINHAN { get; set; }

            public string DOITUONG { get; set; }

            public string DIACHI { get; set; }

            public bool CHECKTONGDAT { get; set; }

            public string NGAYGUI { get; set; }

            public string HINHTHUCGUI { get; set; }

            public string TRANGTHAI { get; set; }

            public string ISBOSUNG { get; set; }

            public string PHATHANHLAI_ID { get; set; }
        }

        protected void rptDoiTuong_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Them":
                    List<NOINHAN_DUONGSU> dataList = new List<NOINHAN_DUONGSU>();
                    foreach (RepeaterItem item in rptDoiTuong.Items)
                    {
                        dataList.Add(
                                        new NOINHAN_DUONGSU()
                                        {
                                            ID = (item.FindControl("hddID") as HiddenField).Value,
                                            NOINHAN = (item.FindControl("txtTen") as TextBox).Text,
                                            TUCACHTOTUNG = (item.FindControl("txtTCTT") as TextBox).Text,
                                            DOITUONG = (item.FindControl("hddDoiTuong") as HiddenField).Value,
                                            DIACHI = (item.FindControl("txtDiaChi") as TextBox).Text,
                                            CHECKTONGDAT = (item.FindControl("chkTongDat") as CheckBox).Checked,
                                            NGAYGUI = (item.FindControl("txtNgaygui") as TextBox).Text,
                                            HINHTHUCGUI = (item.FindControl("dropHinhThucGui") as DropDownList).SelectedValue,
                                            TRANGTHAI = (item.FindControl("hddTrangThai") as HiddenField).Value,
                                            ISBOSUNG = (item.FindControl("hddBoSung") as HiddenField).Value,
                                            PHATHANHLAI_ID = (item.FindControl("hddPhatHanhLaiID") as HiddenField).Value,
                                        });
                    }
                    
                    dataList.Add(new NOINHAN_DUONGSU() { DOITUONG = "3", HINHTHUCGUI = "2", TRANGTHAI = "0", ISBOSUNG = "1", PHATHANHLAI_ID = "0" });
                    countDoiTuong = dataList.Count;
                    rptDoiTuong.DataSource = dataList;
                    rptDoiTuong.DataBind();
                    break;
                case "Xoa":
                    int index = Convert.ToInt32(e.CommandArgument);
                    List<NOINHAN_DUONGSU> dataListXoa = new List<NOINHAN_DUONGSU>();
                    foreach (RepeaterItem item in rptDoiTuong.Items)
                    {
                        if (index != item.ItemIndex)
                        {
                            dataListXoa.Add(
                                        new NOINHAN_DUONGSU()
                                        {
                                            ID = (item.FindControl("hddID") as HiddenField).Value,
                                            NOINHAN = (item.FindControl("txtTen") as TextBox).Text,
                                            TUCACHTOTUNG = (item.FindControl("txtTCTT") as TextBox).Text,
                                            DOITUONG = (item.FindControl("hddDoiTuong") as HiddenField).Value,
                                            DIACHI = (item.FindControl("txtDiaChi") as TextBox).Text,
                                            CHECKTONGDAT = (item.FindControl("chkTongDat") as CheckBox).Checked,
                                            NGAYGUI = (item.FindControl("txtNgaygui") as TextBox).Text,
                                            HINHTHUCGUI = (item.FindControl("dropHinhThucGui") as DropDownList).SelectedValue,
                                            TRANGTHAI = (item.FindControl("hddTrangThai") as HiddenField).Value,
                                            ISBOSUNG = (item.FindControl("hddBoSung") as HiddenField).Value,
                                            PHATHANHLAI_ID = (item.FindControl("hddPhatHanhLaiID") as HiddenField).Value,
                                        });
                        }
                    }
                    countDoiTuong = dataListXoa.Count;
                    rptDoiTuong.DataSource = dataListXoa;
                    rptDoiTuong.DataBind();
                    break;
            }
        }

        protected void rptDoiTuong_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                ImageButton cmdAdd = (ImageButton)e.Item.FindControl("cmdAdd");
                ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                HiddenField hddDoiTuong = (HiddenField)e.Item.FindControl("hddDoiTuong");
                HiddenField hddTrangThai = (HiddenField)e.Item.FindControl("hddTrangThai");
                TextBox txtTen = (TextBox)e.Item.FindControl("txtTen");
                HiddenField hddID = (HiddenField)e.Item.FindControl("hddID");
                TextBox txtTCTT = (TextBox)e.Item.FindControl("txtTCTT");
                TextBox txtDiaChi = (TextBox)e.Item.FindControl("txtDiaChi");
                TextBox txtNgaygui = (TextBox)e.Item.FindControl("txtNgaygui");
                DropDownList dropHinhThucGui = (DropDownList)e.Item.FindControl("dropHinhThucGui");
                CheckBox chkTongDat = (CheckBox)e.Item.FindControl("chkTongDat");
                DM_HINHTHUCGUI_BL oBL = new DM_HINHTHUCGUI_BL();
                dropHinhThucGui.DataSource = oBL.GETALL_ISHIEULUC();
                dropHinhThucGui.DataTextField = "TEN_HINHTHUCGUI";
                dropHinhThucGui.DataValueField = "GIATRI";
                dropHinhThucGui.DataBind();
                if (hddDoiTuong.Value + "" == "3")
                {
                    cmdXoa.Visible = true;
                }
                if (countDoiTuong == e.Item.ItemIndex +1)
                {
                    cmdAdd.Visible = true;
                }
                if ((hddTrangThai.Value != "0" && hddTrangThai.Value != "2" && hddTrangThai.Value != "6" && hddTrangThai.Value != "7") || (hddID.Value != "" && hddID.Value != "0" && Session[ENUM_GDTTT_TONGDAT.IS_PHBS] + "" == "1"))
                {
                    cmdXoa.Visible = false;
                    txtTen.Enabled = txtTCTT.Enabled = txtDiaChi.Enabled = txtNgaygui.Enabled = chkTongDat.Enabled = dropHinhThucGui.Enabled = false;
                }
                try
                {
                    NOINHAN_DUONGSU rowView = (NOINHAN_DUONGSU)e.Item.DataItem;                   
                    dropHinhThucGui.SelectedValue = rowView.HINHTHUCGUI;
                    chkTongDat.Checked = rowView.CHECKTONGDAT;
                }
                catch
                {
                    DataRowView rowView = (DataRowView)e.Item.DataItem;
                    dropHinhThucGui.SelectedValue = rowView["HINHTHUCGUI"].ToString();
                }
            }
        }

        protected void rptDonVi_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Them":
                    List<NOINHAN_DONVI> dataList = new List<NOINHAN_DONVI>();
                    //-- add all existing values to a list
                    foreach (RepeaterItem item in rptDonVi.Items)
                    {
                        dataList.Add(
                                        new NOINHAN_DONVI()
                                        {
                                            ID = (item.FindControl("hddID") as HiddenField).Value,
                                            NOINHANID = (item.FindControl("hddDonViID") as HiddenField).Value,
                                            NOINHAN = (item.FindControl("txtTenDonVi") as TextBox).Text,
                                            DOITUONG = (item.FindControl("hddDoiTuong") as HiddenField).Value,
                                            DIACHI = (item.FindControl("txtDiaChi") as TextBox).Text,
                                            CHECKTONGDAT = (item.FindControl("chkTongDat") as CheckBox).Checked,
                                            NGAYGUI = (item.FindControl("txtNgaygui") as TextBox).Text,
                                            HINHTHUCGUI = (item.FindControl("dropHinhThucGui") as DropDownList).SelectedValue,
                                            TRANGTHAI = (item.FindControl("hddTrangThai") as HiddenField).Value,
                                            ISBOSUNG = (item.FindControl("hddBoSung") as HiddenField).Value,
                                            PHATHANHLAI_ID = (item.FindControl("hddPhatHanhLaiID") as HiddenField).Value,
                                        });
                    }

                    //-- add a blank row to list to show a new row added
                    dataList.Add(new NOINHAN_DONVI(){ DOITUONG = "4", HINHTHUCGUI= "2", TRANGTHAI = "0", ISBOSUNG = "1" , PHATHANHLAI_ID  = "0" });
                    countDonVi = dataList.Count;
                    //-- bind repeater
                    rptDonVi.DataSource = dataList;
                    rptDonVi.DataBind();
                    break;
                case "Xoa":
                    int index = Convert.ToInt32(e.CommandArgument);
                    List<NOINHAN_DONVI> dataListXoa = new List<NOINHAN_DONVI>();
                    foreach (RepeaterItem item in rptDonVi.Items)
                    {
                        if (index != item.ItemIndex)
                        {
                            dataListXoa.Add(
                                        new NOINHAN_DONVI()
                                        {
                                            ID = (item.FindControl("hddID") as HiddenField).Value,
                                            NOINHANID = (item.FindControl("hddDonViID") as HiddenField).Value,
                                            NOINHAN = (item.FindControl("txtTenDonVi") as TextBox).Text,
                                            DOITUONG = (item.FindControl("hddDoiTuong") as HiddenField).Value,
                                            DIACHI = (item.FindControl("txtDiaChi") as TextBox).Text,
                                            CHECKTONGDAT = (item.FindControl("chkTongDat") as CheckBox).Checked,
                                            NGAYGUI = (item.FindControl("txtNgaygui") as TextBox).Text,
                                            HINHTHUCGUI = (item.FindControl("dropHinhThucGui") as DropDownList).SelectedValue,
                                            TRANGTHAI = (item.FindControl("hddTrangThai") as HiddenField).Value,
                                            ISBOSUNG = (item.FindControl("hddBoSung") as HiddenField).Value,
                                            PHATHANHLAI_ID = (item.FindControl("hddPhatHanhLaiID") as HiddenField).Value,
                                        });
                        }                        
                    }
                    countDonVi = dataListXoa.Count;
                    rptDonVi.DataSource = dataListXoa;
                    rptDonVi.DataBind();
                    break;
            }
        }

        protected void cmdThuHoi_Click(object sender, EventArgs e)
        {
            if (txtNgayThuHoi.Text == "")
            {
                lbThongbao.Text = "Bạn chưa chọn ngày thu hồi!";
                txtNgayThuHoi.Focus();
                return;
            }
            if (txtLyDo.Text == "")
            {
                lbThongbao.Text = "Bạn chưa nhập lý do thu hồi!";
                txtLyDo.Focus();
                return;
            }
            int countCheck = 0;
            List<decimal> lstIDTongDat = new List<decimal>();
            DateTime txtNgayTH = DateTime.Parse(txtNgayThuHoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            foreach (DataGridItem Item in dgDS.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkThuHoi");
                HiddenField hddHasThuHoi = (HiddenField)Item.FindControl("hddHasThuHoi");
                if (chkChon.Checked && hddHasThuHoi.Value == "1")
                {
                    countCheck++;
                    HiddenField hdID = (HiddenField)Item.FindControl("hddID");
                    TONGDAT_GDKT_BL oBL = new TONGDAT_GDKT_BL();
                    oBL.THUHOI_TONGDAT_GDKT(Convert.ToDecimal(hdID.Value), txtNgayTH, txtLyDo.Text, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                    lstIDTongDat.Add(Convert.ToDecimal(hdID.Value));
                }
            }
            if (countCheck == 0)
            {
                lbThongbao.Text = "Bạn chưa chọn văn bản được thu hồi!";
                return;
            }
            else
            {
                try {
                    //gọi api tong-dat-gdkt-thu-hoi
                    WebClient client = new WebClient();
                    string apiUrl = ConfigurationManager.AppSettings["IpTongDat"] + "tong-dat-gdkt-thu-hoi";
                    var input = new
                    {
                        reallocateReason = txtLyDo.Text,
                        reallocateUser = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                        reallocateDate = txtNgayTH,
                        allocatedList = lstIDTongDat
                    };
                    string inputJson = JsonConvert.SerializeObject(input);
                    client.Headers.Clear();
                    client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
                    client.Encoding = Encoding.UTF8;
                    string result = client.UploadString(apiUrl, inputJson);
                    JToken jObject = JToken.Parse(result);
                    if ((string)jObject["status"] != "SUCCESS")
                    {
                        lbThongbao.Text = (string)jObject["message"];
                        LoadData();
                        return;
                    }
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = ex.Message;
                }                
            }
            lbThongbao.Text = "Lưu thành công";
            txtNgayThuHoi.Text = txtLyDo.Text = "";
            LoadData();
        }

        protected void rptDonVi_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                ImageButton cmdAdd = (ImageButton)e.Item.FindControl("cmdAdd");
                ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                HiddenField hddDoiTuong = (HiddenField)e.Item.FindControl("hddDoiTuong");
                HiddenField hddTrangThai = (HiddenField)e.Item.FindControl("hddTrangThai");
                HiddenField hddID = (HiddenField)e.Item.FindControl("hddID");
                TextBox txtTenDonVi = (TextBox)e.Item.FindControl("txtTenDonVi");
                TextBox txtDiaChi = (TextBox)e.Item.FindControl("txtDiaChi");
                TextBox txtNgaygui = (TextBox)e.Item.FindControl("txtNgaygui");
                DropDownList dropHinhThucGui = (DropDownList)e.Item.FindControl("dropHinhThucGui");
                CheckBox chkTongDat = (CheckBox)e.Item.FindControl("chkTongDat");                
                DM_HINHTHUCGUI_BL oBL = new DM_HINHTHUCGUI_BL();
                dropHinhThucGui.DataSource = oBL.GETALL_ISHIEULUC();
                dropHinhThucGui.DataTextField = "TEN_HINHTHUCGUI";
                dropHinhThucGui.DataValueField = "GIATRI";
                dropHinhThucGui.DataBind();
                if (hddDoiTuong.Value + "" == "4")
                {
                    cmdXoa.Visible = true;                    
                }
                if (countDonVi == e.Item.ItemIndex + 1)
                {
                    cmdAdd.Visible = true;
                }
                if ((hddTrangThai.Value != "0" && hddTrangThai.Value != "2" && hddTrangThai.Value != "6" && hddTrangThai.Value != "7") || (hddID.Value != "" && hddID.Value != "0" && Session[ENUM_GDTTT_TONGDAT.IS_PHBS] + "" == "1"))
                {
                    cmdXoa.Visible = false;
                    txtTenDonVi.Enabled = txtDiaChi.Enabled = txtNgaygui.Enabled = chkTongDat.Enabled = dropHinhThucGui.Enabled = false;
                }        
                try
                {
                    NOINHAN_DONVI rowView = (NOINHAN_DONVI)e.Item.DataItem;
                    dropHinhThucGui.SelectedValue = rowView.HINHTHUCGUI;
                    chkTongDat.Checked = rowView.CHECKTONGDAT;                    
                }
                catch
                {
                    DataRowView rowView = (DataRowView)e.Item.DataItem;
                    dropHinhThucGui.SelectedValue = rowView["HINHTHUCGUI"].ToString();
                }
            }
        }

        public bool GetNumber(object obj)
        {
            try
            {
                if ((obj + "") == "1" || (obj + "") == "2")
                    return false;
                else
                    return true;
            }
            catch { return false; }
        }

        protected void dropHinhThucGui_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList d = (DropDownList)sender;
            RepeaterItem itm = (RepeaterItem)d.Parent;

            TextBox txtNgayGui = (TextBox)itm.FindControl("txtNgaygui");
            if (d.SelectedValue == "0" || d.SelectedValue == "5")
            {
                txtNgayGui.Visible = true;
            }
            else txtNgayGui.Visible = false;
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            Reset();
        }

        protected void btnPHBS_Click(object sender, EventArgs e)
        {
            Session[ENUM_GDTTT_TONGDAT.IS_PHBS] = "1";
            Session[ENUM_GDTTT_TONGDAT.IS_PHATHANHLAI] = "0";
            decimal ID = getVBPH_ID(true);
            if (ID > 0) { LoadEdit(ID, 0); }            
        }

        protected void btnSua_Click(object sender, EventArgs e)
        {
            Session[ENUM_GDTTT_TONGDAT.IS_PHBS] = "0";
            Session[ENUM_GDTTT_TONGDAT.IS_PHATHANHLAI] = "0";
            decimal ID = getVBPH_ID(false);
            if (ID > 0) { LoadEdit(ID, 0); }
        }

        protected void btnXoa_Click(object sender, EventArgs e)
        {
            Session[ENUM_GDTTT_TONGDAT.IS_PHBS] = "0";
            Session[ENUM_GDTTT_TONGDAT.IS_PHATHANHLAI] = "0";
            decimal ID = getVBPH_ID(false);
            if (ID > 0)
            {
                TONGDAT_GDKT_BL oBLDel = new TONGDAT_GDKT_BL();
                oBLDel.TONGDAT_GDKT_DEL(ID);
                string mess = "Xóa thành công!";
                Reset();
                Cls_Comon.SetButton(cmdPhatHanh, true);
                lbtthongbao.Text = mess;
                LoadData();
            }
        }

        protected decimal getVBPH_ID(bool isPHBS)
        {
            decimal ID = 0;
            int countCheck = 0;
            foreach (DataGridItem Item in dgDS.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkThuHoi");
                HiddenField hddHasSua = (HiddenField)Item.FindControl("hddHasSua");
                if (chkChon.Checked && (hddHasSua.Value == "1" || isPHBS))
                {
                    countCheck++;
                    HiddenField hdID = (HiddenField)Item.FindControl("hddID");
                    ID = Convert.ToDecimal(hdID.Value);
                }
            }
            if (countCheck == 0)
            {
                lbThongbao.Text = "Bạn chưa chọn văn bản phát hành được sửa, xóa!";
                return 0;
            }
            if (countCheck > 1)
            {
                lbThongbao.Text = "Bạn chỉ được chọn 1 văn bản phát hành được sửa, xóa!";
                return 0;
            }
            return ID;
        }

        public string GetTextDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return (Convert.ToDateTime(obj).ToString("dd/MM/yyyy", cul));
            }
            catch { return ""; }
        }
    }
}