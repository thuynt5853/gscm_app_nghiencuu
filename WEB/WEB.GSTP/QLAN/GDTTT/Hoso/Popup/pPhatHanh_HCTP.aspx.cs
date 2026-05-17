using BL.GSTP;
using BL.GSTP.BANGSETGET;
using BL.GSTP.Danhmuc;
using BL.GSTP.GDTTT;
using BL.GSTP.TONGDAT;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.Hoso.Popup
{
    public partial class pPhatHanh_HCTP : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public int countDonVi = 0, countDoiTuong = 0, indexDgDS = 1;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                decimal vIDSua = Convert.ToDecimal(Request["vIDSua"] + "");
                txtNgayThuHoi.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                if (vIDSua == 0)
                {
                    LoadVBPH();
                }
                else
                {
                    hddID.Value = vIDSua + "";
                    LoadEdit(vIDSua, 0);
                }
            }
        }
        private void LoadVBPH()
        {
            dropVBPH.Items.Clear();
            decimal vID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            decimal vLoaiVB = (String.IsNullOrEmpty(Request["vLoaiVB"] + "")) ? 0 : Convert.ToDecimal(Request["vLoaiVB"] + "");
            TONGDAT_HCTP_BL oBL = new TONGDAT_HCTP_BL();
            DataTable tb = oBL.GET_VAN_BAN_PHAT_HANH(vID, vLoaiVB);
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
        private void LoadNoiNhanDoiTuong()
        {
            string strVID = Request["vID"] + "";
            TONGDAT_HCTP_BL oBL = new TONGDAT_HCTP_BL();
            decimal vID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            decimal vLoaiVB = (String.IsNullOrEmpty(Request["vLoaiVB"] + "")) ? 0 : Convert.ToDecimal(Request["vLoaiVB"] + "");
            DataTable obj = oBL.GET_VBPH_NOINHAN_DOITUONG(vID, vLoaiVB);
            countDoiTuong = obj.Rows.Count;
            rptDoiTuong.DataSource = obj;
            rptDoiTuong.DataBind();
        }

        private void Reset()
        {
            pnVBPH.Visible = true;
            txtTenVBPH.Text = "";
            pnDoiTuong.Visible = lbtNoiNhan.Visible = false;
            hddID.Value = "0";
            lbtthongbao.Text = "";
            LoadVBPH();
            rptDoiTuong.DataSource = null;
            rptDoiTuong.DataBind();
            ENUM_GDTTT_TONGDAT td = new ENUM_GDTTT_TONGDAT();
            Session[ENUM_GDTTT_TONGDAT.IS_PHBS] = "0";
            Session[ENUM_GDTTT_TONGDAT.IS_PHATHANHLAI] = "0";
        }
        private bool CheckValid()
        {
            bool checkDoiTuong = false;
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
                    //if (txtTCTT.Text == "")
                    //{
                    //    lbtthongbao.Text = "Tư cách tố tụng không được để trống!";
                    //    txtTCTT.Focus();
                    //    return false;
                    //}
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
            TONGDAT_HCTP oT = new TONGDAT_HCTP();
            string strVID = Request["vID"] + "";
            decimal vLoaiVB = (String.IsNullOrEmpty(Request["vLoaiVB"] + "")) ? 0 : Convert.ToDecimal(Request["vLoaiVB"] + "");
            TONGDAT_HCTP_BL oBL = new TONGDAT_HCTP_BL();
            decimal vID = Convert.ToDecimal(strVID);
            if (hddID.Value == "" || hddID.Value == "0")
            {
                GDTTT_DON_BL oQLSO = new GDTTT_DON_BL();
                oT.ID = 0;
                oT.NGAYTAO = DateTime.Now;
                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                string tenVBPH = dropVBPH.SelectedItem.Text;
                int index = tenVBPH.IndexOf("số") == -1 ? tenVBPH.Length : tenVBPH.IndexOf("số") - 1;
                if (vLoaiVB == 6)
                {
                    oT.DON_ID = vID;
                    oT.LOAIVB = "Công văn chuyển";
                    DataTable objQLSO = oQLSO.GET_GDTTT_HCTP_QLSO(vID);
                    oT.SOVB = objQLSO.Rows[0]["SO"].ToString();
                    if (objQLSO.Rows[0]["NGAY"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(objQLSO.Rows[0]["NGAY"].ToString());
                    oT.NGUOIKY = objQLSO.Rows[0]["NGUOIKY"].ToString();
                }
                else if (vLoaiVB == 7)
                {
                    oT.DON_ID = vID;
                    oT.LOAIVB = "Tờ trình";
                    DataTable objQLSO = oQLSO.GET_GDTTT_HCTP_QLSO(vID);
                    oT.SOVB = objQLSO.Rows[0]["SO"].ToString();
                    if (objQLSO.Rows[0]["NGAY"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(objQLSO.Rows[0]["NGAY"].ToString());
                    oT.NGUOIKY = objQLSO.Rows[0]["NGUOIKY"].ToString();
                }
                else if (vLoaiVB == 1)
                {
                    oT.DON_ID = vID;
                    oT.LOAIVB = "Yêu cầu bổ sung";
                    GDTTT_DON_BL BL_DON = new GDTTT_DON_BL();
                    DataTable oYCBS = BL_DON.GDTTT_DON_YEUCAU_BOSUNG_GETBYID(vID);
                    oT.SOVB = oYCBS.Rows[0]["SOTHONGBAO"].ToString();
                    if (oYCBS.Rows[0]["NGAYTHONGBAO"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(oYCBS.Rows[0]["NGAYTHONGBAO"].ToString());
                    oT.NGUOIKY = oYCBS.Rows[0]["NGUOIKY"].ToString();
                }
                else if (vLoaiVB == 2)
                {
                    oT.DON_ID = vID;
                    oT.LOAIVB = "Giấy xác nhận nhận đơn";
                    DataTable objQLSO = oQLSO.GET_GDTTT_HCTP_QLSO(vID);
                    oT.SOVB = objQLSO.Rows[0]["SO"].ToString();
                    if (objQLSO.Rows[0]["NGAY"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(objQLSO.Rows[0]["NGAY"].ToString());
                    oT.NGUOIKY = objQLSO.Rows[0]["NGUOIKY"].ToString();
                }
                else if (vLoaiVB == 3)
                {
                    oT.DON_ID = vID;
                    oT.LOAIVB = "Trả lại đơn";
                    GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == vID && x.CD_LOAI == 3).FirstOrDefault();
                    oT.SOVB = oDon.CD_SOCV;
                    oT.NGAYVB = oDon.CD_NGAYCV;
                    oT.NGUOIKY = oDon.CD_NGUOIKY;
                }
                else if (vLoaiVB == 4)
                {
                    oT.DON_ID = vID;
                    oT.LOAIVB = "Thông báo phân công thẩm phán";
                    DataTable objQLSO = oQLSO.GET_GDTTT_HCTP_QLSO(vID);
                    oT.SOVB = objQLSO.Rows[0]["SO"].ToString();
                    if (objQLSO.Rows[0]["NGAY"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(objQLSO.Rows[0]["NGAY"].ToString());
                    oT.NGUOIKY = objQLSO.Rows[0]["NGUOIKY"].ToString();
                }
                else if (vLoaiVB == 5)
                {
                    oT.DON_ID = vID;
                    oT.LOAIVB = "Thông báo gửi cơ quan chuyển đơn";
                    DataTable objQLSO = oQLSO.GET_GDTTT_HCTP_QLSO(vID);
                    oT.SOVB = objQLSO.Rows[0]["SO"].ToString();
                    if (objQLSO.Rows[0]["NGAY"].ToString() != "") oT.NGAYVB = Convert.ToDateTime(objQLSO.Rows[0]["NGAY"].ToString());
                    oT.NGUOIKY = objQLSO.Rows[0]["NGUOIKY"].ToString();
                }
            }
            else
            {
                oT.ID = Convert.ToDecimal(hddID.Value);
                DataTable oTG = oBL.TONGDAT_HCTP_GETBYID(oT.ID);
                oT.DON_ID = Convert.ToDecimal(oTG.Rows[0]["DON_ID"].ToString());
                if (oTG.Rows[0]["LOAIVB"] + "" != "") oT.LOAIVB = oTG.Rows[0]["LOAIVB"].ToString();
                if (oTG.Rows[0]["SOVB"] + "" != "") oT.SOVB = oTG.Rows[0]["SOVB"].ToString();
                if (oTG.Rows[0]["NGAYVB"] + "" != "") oT.NGAYVB = Convert.ToDateTime(oTG.Rows[0]["NGAYVB"].ToString());
                if (oTG.Rows[0]["NGUOIKY"] + "" != "") oT.LYDOTHUHOI = oTG.Rows[0]["NGUOIKY"].ToString();
                if (oTG.Rows[0]["LYDOTHUHOI"] + "" != "") oT.LYDOTHUHOI = oTG.Rows[0]["LYDOTHUHOI"].ToString();
                if (oTG.Rows[0]["NGAYTHUHOI"] + "" != "") oT.NGAYTHUHOI = Convert.ToDateTime(oTG.Rows[0]["NGAYTHUHOI"].ToString());
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }
            oT.TENVANBAN = txtTenVBPH.Text;
            decimal phongBanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DM_PHONGBAN pb = dt.DM_PHONGBAN.Where(x => x.ID == phongBanID).FirstOrDefault();
            oT.DONVIPHATHANH_ID = phongBanID;
            oT.DONVIPHATHANH = pb == null ? null : pb.TENPHONGBAN;
            oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            oT.ID = oBL.TONGDAT_HCTP_INS_UPD(oT);
            hddID.Value = oT.ID.ToString();
            List<Object> arrDoiTuong = new List<object>();
            if (rptDoiTuong.Items.Count > 0)
            {
                foreach (RepeaterItem Item in rptDoiTuong.Items)
                {
                    TextBox txtTenDuongSu = (TextBox)Item.FindControl("txtTen");
                    TextBox txtTCTT = (TextBox)Item.FindControl("txtTuCachTT");
                    DropDownList dropTCTT = (DropDownList)Item.FindControl("ddlTCTT");
                    TextBox txtDiaChi = (TextBox)Item.FindControl("txtDiaChi");
                    TextBox txtNgaygui = (TextBox)Item.FindControl("txtNgaygui");
                    DropDownList dropHinhThucGui = (DropDownList)Item.FindControl("dropHinhThucGui");
                    CheckBox chkTongDat = (CheckBox)Item.FindControl("chkTongDat");
                    HiddenField hddDoiTuong = (HiddenField)Item.FindControl("hddDoiTuong");
                    HiddenField hddID = (HiddenField)Item.FindControl("hddID");
                    HiddenField hddBoSung = (HiddenField)Item.FindControl("hddBoSung");
                    HiddenField hddPhatHanhLaiID = (HiddenField)Item.FindControl("hddPhatHanhLaiID");
                    HiddenField hddTrangThaiID = (HiddenField)Item.FindControl("hddTrangThaiID");
                    TONGDAT_HCTP_NOINHAN oN = new TONGDAT_HCTP_NOINHAN();
                    if (hddID.Value == "" || hddID.Value == "0" || (hddTrangThaiID.Value == "5" && chkTongDat.Checked))
                    {
                        oN.ID = 0;
                        oN.DOITUONG = Convert.ToDecimal(hddDoiTuong.Value);
                        oN.NGAYTAO = DateTime.Now;
                        oN.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        oN.PHATHANHLAI_ID = hddTrangThaiID.Value == "5" ? Convert.ToDecimal(hddID.Value) : (decimal?)null;
                        if (dropHinhThucGui.SelectedValue == "0") oN.TRANGTHAI = 6;
                        if (dropHinhThucGui.SelectedValue == "5") oN.TRANGTHAI = 7;
                        if (hddTrangThaiID.Value == "5")
                        {
                            oN.TRANGTHAI = 5;
                            oN.ID = Convert.ToDecimal(hddID.Value);
                            DataTable oTGN = oBL.TONGDAT_HCTP_NOINHAN_GETBYID(oN.ID);
                            if (oTGN.Rows[0]["NGAYPHATHANH"] + "" != "") oN.NGAYPHATHANH = Convert.ToDateTime(oTGN.Rows[0]["NGAYPHATHANH"].ToString());
                            if (oTGN.Rows[0]["NGAYNHAN"] + "" != "") oN.NGAYNHAN = Convert.ToDateTime(oTGN.Rows[0]["NGAYNHAN"].ToString());
                        }
                    }
                    else
                    {
                        oN.ID = Convert.ToDecimal(hddID.Value);
                        DataTable oTGN = oBL.TONGDAT_HCTP_NOINHAN_GETBYID(oN.ID);
                        oN.DOITUONG = Convert.ToDecimal(oTGN.Rows[0]["DOITUONG"].ToString());
                        decimal trangThaiCu = Convert.ToDecimal(oTGN.Rows[0]["TRANGTHAI"].ToString());
                        if ((oTGN.Rows[0]["TRANGTHAI"] + "" == "0" || oTGN.Rows[0]["TRANGTHAI"] + "" == "2") && chkTongDat.Checked)
                            oN.TRANGTHAI = 1;
                        else oN.TRANGTHAI = trangThaiCu;
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
                    oN.TUCACHTOTUNG = dropTCTT.SelectedValue + '.' + txtTCTT.Text;
                    oN.DIACHI = txtDiaChi.Text;
                    oN.TONGDAT_HCTP_ID = oT.ID;
                    oN.HINHTHUCGUI = Convert.ToDecimal(dropHinhThucGui.SelectedValue);
                    DM_HINHTHUCGUI_BL oHTG = new DM_HINHTHUCGUI_BL();
                    decimal isVBPH = oHTG.DM_HINHTHUCGUI_GETBYGIATRI(oN.HINHTHUCGUI);
                    if (isVBPH == 0)
                    {
                        oN.NGAYGUI = oN.NGAYNHAN = oN.NGAYPHATHANH = DateTime.Parse(txtNgaygui.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    }
                    else if (isVBPH == 1 && chkTongDat.Checked) { oN.NGAYGUI = DateTime.Now; }
                    oN.ID = oBL.TONGDAT_HCTP_NOINHAN_INS_UPD(oN);
                    if (Session[ENUM_GDTTT_TONGDAT.IS_PHBS] + "" == "1")
                    {
                        if (chkTongDat.Checked && hddBoSung.Value == "1")
                        {
                            var oDT = new
                            {
                                noiNhan = oN.NOINHAN,
                                tuCachToTung = oN.TUCACHTOTUNG == null ? "" : txtTCTT.Text,
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
                                tuCachToTung = oN.TUCACHTOTUNG == null ? "" : txtTCTT.Text,
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
                //gọi api tongdat_hctp
                WebClient client = new WebClient();
                string apiUrl = ConfigurationManager.AppSettings["IpTongDat"] + "tongdat_hctp";
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
                    Reset();
                    return;
                }
            }
            catch (Exception ex)
            {
                lbThongbao.Text = ex.Message;
            }
            LoadEdit(Convert.ToDecimal(hddID.Value), 0);
            string mess = "Lưu thành công!";
            lbtthongbao.Text = mess;
            //Reset();
        }

        protected void dropVBPH_SelectedIndexChanged(object sender, EventArgs e)
        {
            rptDoiTuong.DataSource = null;
            rptDoiTuong.DataBind();
            if (dropVBPH.SelectedValue == "0")
            {
                pnDoiTuong.Visible = lbtNoiNhan.Visible = false;
                txtTenVBPH.Text = "";
            }
            else
            {
                lbtNoiNhan.Visible = true;
                txtTenVBPH.Text = dropVBPH.SelectedItem.Text;
                pnDoiTuong.Visible = true;
                LoadNoiNhanDoiTuong();
            }
        }

        private void LoadEdit(decimal ID, decimal NoiNhanID)
        {
            hddID.Value = ID.ToString();
            Cls_Comon.SetButton(cmdPhatHanh, true);
            pnVBPH.Visible = false;
            TONGDAT_HCTP_BL oBL = new TONGDAT_HCTP_BL();
            DataTable oTD = oBL.TONGDAT_HCTP_GETBYID(ID);
            txtTenVBPH.Text = oTD.Rows[0]["TENVANBAN"].ToString();
            pnDoiTuong.Visible = true;
            LoadNoiNhanDoiTuongEdit(ID, NoiNhanID);
            DataTable oTG = oBL.TONGDAT_HCTP_GETBYID(ID);
            if (oTG.Rows[0]["LYDOTHUHOI"] + "" != "") txtLyDo.Text = oTG.Rows[0]["LYDOTHUHOI"].ToString();
            if (oTG.Rows[0]["NGAYTHUHOI"] + "" != "" && !(oTG.Rows[0]["NGAYTHUHOI"] + "").Contains("1/1/0001"))
                txtNgayThuHoi.Text = Convert.ToDateTime(oTG.Rows[0]["NGAYTHUHOI"].ToString()).ToString("dd/MM/yyyy");
        }
        private void LoadNoiNhanDoiTuongEdit(decimal ID, decimal NoiNhanID)
        {
            TONGDAT_HCTP_BL oBL = new TONGDAT_HCTP_BL();
            DataTable obj = oBL.GET_VBPH_NOINHAN_DOITUONG_EDIT(ID, NoiNhanID);
            countDoiTuong = obj.Rows.Count;
            rptDoiTuong.DataSource = obj;
            rptDoiTuong.DataBind();
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
                                            TUCACHTOTUNG = (item.FindControl("ddlTCTT") as DropDownList).SelectedValue + "." + (item.FindControl("txtTuCachTT") as TextBox).Text,
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

                    dataList.Add(new NOINHAN_DUONGSU() { DOITUONG = "1", HINHTHUCGUI = "2", TRANGTHAI = "0", ISBOSUNG = "1", PHATHANHLAI_ID = "0" });
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
                                            TUCACHTOTUNG = (item.FindControl("ddlTCTT") as DropDownList).SelectedValue + "." + (item.FindControl("txtTuCachTT") as TextBox).Text,
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
                TextBox txtTCTT = (TextBox)e.Item.FindControl("txtTuCachTT");
                TextBox txtDiaChi = (TextBox)e.Item.FindControl("txtDiaChi");
                TextBox txtNgaygui = (TextBox)e.Item.FindControl("txtNgaygui");
                DropDownList dropHinhThucGui = (DropDownList)e.Item.FindControl("dropHinhThucGui");
                CheckBox chkTongDat = (CheckBox)e.Item.FindControl("chkTongDat");
                DM_HINHTHUCGUI_BL oBL = new DM_HINHTHUCGUI_BL();
                dropHinhThucGui.DataSource = oBL.GETALL_ISHIEULUC();
                dropHinhThucGui.DataTextField = "TEN_HINHTHUCGUI";
                dropHinhThucGui.DataValueField = "GIATRI";
                dropHinhThucGui.DataBind();

                DropDownList ddlTCTT = (DropDownList)e.Item.FindControl("ddlTCTT");
                //DM_DATAITEM_BL oBLTCTT = new DM_DATAITEM_BL();
                //ddlTCTT.DataSource = oBLTCTT.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTDS);
                //ddlTCTT.DataTextField = "TEN";
                //ddlTCTT.DataValueField = "ID";
                //ddlTCTT.Visible = true;
                //ddlTCTT.DataBind();
                //ddlTCTT.Items.Add(new ListItem("Khác", "0"));

                if (hddDoiTuong.Value + "" == "1")
                {
                    cmdXoa.Visible = true;
                }
                if (hddDoiTuong.Value + "" == "0")
                {
                    txtTen.Enabled = false;
                }
                if (countDoiTuong == e.Item.ItemIndex + 1)
                {
                    cmdAdd.Visible = true;
                }
                if ((hddTrangThai.Value != "0" && hddTrangThai.Value != "2" && hddTrangThai.Value != "6" && hddTrangThai.Value != "7") || (hddID.Value != "" && hddID.Value != "0" && Session[ENUM_GDTTT_TONGDAT.IS_PHBS] + "" == "1"))
                {
                    cmdXoa.Visible = false;
                    txtTen.Enabled = txtTCTT.Enabled = txtDiaChi.Enabled = txtNgaygui.Enabled = chkTongDat.Enabled = dropHinhThucGui.Enabled = txtTCTT.Enabled = ddlTCTT.Enabled = false;
                }
                try
                {
                    NOINHAN_DUONGSU rowView = (NOINHAN_DUONGSU)e.Item.DataItem;
                    dropHinhThucGui.SelectedValue = rowView.HINHTHUCGUI;
                    chkTongDat.Checked = rowView.CHECKTONGDAT;
                    ddlTCTT.SelectedValue = rowView.TUCACHTOTUNG == null ? "4" : rowView.TUCACHTOTUNG.Split('.')[0];
                    txtTCTT.Text = txtTCTT.ToolTip = rowView.TUCACHTOTUNG == null ? "" : rowView.TUCACHTOTUNG.Split('.')[1];
                }
                catch
                {
                    DataRowView rowView = (DataRowView)e.Item.DataItem;
                    dropHinhThucGui.SelectedValue = rowView["HINHTHUCGUI"].ToString();
                    ddlTCTT.SelectedValue = rowView["TUCACHTOTUNG"].ToString() == "" ? "4" : rowView["TUCACHTOTUNG"].ToString().Split('.')[0];
                    txtTCTT.Text = txtTCTT.ToolTip = rowView["TUCACHTOTUNG"].ToString() == "" ? "" : rowView["TUCACHTOTUNG"].ToString().Split('.')[1];
                }
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
            List<decimal> lstIDTongDat = new List<decimal>();
            DateTime txtNgayTH = DateTime.Parse(txtNgayThuHoi.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            decimal vIDSua = Convert.ToDecimal(Request["vIDSua"] + "");
            TONGDAT_HCTP_BL oBL = new TONGDAT_HCTP_BL();
            lstIDTongDat.Add(vIDSua);
            try
            {
                //gọi api tong-dat-hctp-thu-hoi
                WebClient client = new WebClient();
                string apiUrl = ConfigurationManager.AppSettings["IpTongDat"] + "tong-dat-hctp-thu-hoi";
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
                    return;
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
            decimal countNoiNhan = oBL.THUHOI_TONGDAT_HCTP(vIDSua, txtNgayTH, txtLyDo.Text, Session[ENUM_SESSION.SESSION_USERNAME] + "");
            if (countNoiNhan > 0)
            {
                lbThongbao.Text = "Thu hồi thành công.";
            }
            else lbThongbao.Text = "Văn bản không được thu hồi.";
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

        protected void ddlTCTT_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlTCTT = (DropDownList)sender;
            RepeaterItem item = (RepeaterItem)ddlTCTT.Parent;
            TextBox txtTCTT = item.FindControl("txtTuCachTT") as TextBox;
            if (ddlTCTT.SelectedValue == "4" || string.IsNullOrEmpty(ddlTCTT.SelectedValue))
            {
                txtTCTT.Text = string.Empty;
                txtTCTT.ToolTip = "";
                txtTCTT.Enabled = true;
            }
            else
            {
                txtTCTT.Enabled = false;
                try
                {
                    txtTCTT.Text = ddlTCTT.SelectedItem.Text;
                    txtTCTT.ToolTip = ddlTCTT.SelectedItem.Text;
                }
                catch { }
            }
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            Reset();
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