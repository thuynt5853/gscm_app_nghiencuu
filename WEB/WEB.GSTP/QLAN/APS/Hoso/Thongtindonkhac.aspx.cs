using BL.GSTP;
using BL.GSTP.APS;
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

namespace WEB.GSTP.QLAN.APS.Hoso
{
    public partial class Thongtindonkhac : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
        private void SetDonGhep()
        {
            string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            Session[keyDonID] = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
            Session[keyLoaiAnId] = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SetDonGhep();
                LoadCombobox();
                string current_id = Request["ID"] + "";
                string strtype = Request["type"] + "";
                LoadLoaiDon(false);
                string strDonID = Session["PS_THEMDSK"] + "";
                if (strtype == "new")
                {
                    if (strDonID != "")
                    {
                        hddID.Value = Session["PS_THEMDSK"] + "";
                        decimal ID = Convert.ToDecimal(Session["PS_THEMDSK"]);
                        LoadInfo(ID);
                    }
                }
                else if (strtype == "list")
                {
                    if (current_id != "" && current_id != "0")
                    {
                        hddID.Value = current_id.ToString();
                        decimal ID = Convert.ToDecimal(current_id);
                        LoadInfo(ID);
                    }
                }
                else
                {
                    current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                    if (current_id != "" && current_id != "0")
                    {
                        hddID.Value = current_id.ToString();
                        decimal ID = Convert.ToDecimal(current_id);
                        LoadInfo(ID);
                    }
                }
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                //Cls_Comon.SetButton(cmdUpdateSelect, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdateAndNew, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdateSelectB, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdateAndNewB, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdateB, oPer.CAPNHAT);
                //if (hddID.Value != "" && hddID.Value != "0")
                //{
                //    decimal ID = Convert.ToDecimal(hddID.Value);
                //    APS_DON oT = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
                //    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                //    {
                //        lstMsgT.Text = lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                //        //Cls_Comon.SetButton(cmdUpdateSelect, false);
                //        //Cls_Comon.SetButton(cmdUpdateAndNew, false);
                //        //Cls_Comon.SetButton(cmdUpdateSelectB, false);
                //        //Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                //        //Cls_Comon.SetButton(cmdUpdate, false);
                //        //Cls_Comon.SetButton(cmdUpdateB, false);
                //        return;
                //    }
                //    string StrMsg = "Không được sửa đổi thông tin.";
                //    string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                //    if (Result != "")
                //    {
                //        lstMsgT.Text = lstMsgB.Text = Result;
                //        //Cls_Comon.SetButton(cmdUpdateSelect, false);
                //        //Cls_Comon.SetButton(cmdUpdateAndNew, false);
                //        //Cls_Comon.SetButton(cmdUpdateSelectB, false);
                //        //Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                //        //Cls_Comon.SetButton(cmdUpdate, false);
                //        //Cls_Comon.SetButton(cmdUpdateB, false);
                //        return;
                //    }
                //}


                //if (strtype != "new")
                //{
                //    //current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                //    if (!string.IsNullOrEmpty(current_id))
                //    {
                //        decimal Id = Convert.ToDecimal(current_id);
                //        List<APS_DON_XULY> oDON_XLY = dt.APS_DON_XULY.Where(x => x.DONID == Id).ToList<APS_DON_XULY>();
                //        if (oDON_XLY.Count > 0)
                //        {
                //            lstMsgT.Text = lstMsgB.Text = "Đơn đã được xử lý không được thay đổi !";
                //            //Cls_Comon.SetButton(cmdUpdate, false);
                //            //Cls_Comon.SetButton(cmdUpdateB, false);
                //            //Cls_Comon.SetButton(cmdUpdateSelect, false);
                //            //Cls_Comon.SetButton(cmdUpdateAndNew, false);
                //            //Cls_Comon.SetButton(cmdUpdateSelectB, false);
                //            //Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                //        }
                //    }

                //}
                //if (Request["ChiTiet"] != null)
                //{
                //    //chỉ xem chi tiết
                //    //cmdUpdate.Visible = false;
                //    //cmdUpdateSelect.Visible = false;
                //    //cmdUpdateAndNew.Visible = false;
                //    //cmdQuaylai.Visible = false;
                //    //cmdUpdateB.Visible = false;
                //    //cmdUpdateSelectB.Visible = false;
                //    //cmdUpdateAndNewB.Visible = false;
                //    //cmdQuaylaiB.Visible = false;
                //}

            }
        }

        void LoadLoaiDon(bool blnTructuyen)
        {
            ddlHinhthucnhandon.Items.Clear();
            if (blnTructuyen)
                ddlHinhthucnhandon.Items.Add(new ListItem("Trực tuyến", "3"));
            else
            {
                ddlHinhthucnhandon.Items.Add(new ListItem("Trực tiếp", "1"));
                ddlHinhthucnhandon.Items.Add(new ListItem("Qua bưu điện", "2"));
            }
        }
        private void LoadInfo(decimal ID)
        {
            APS_DON oT = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
            txtMaVuViec.Text = oT.MAVUVIEC;
            txtTenVuViec.Text = oT.TENVUVIEC;
            // if (oT.SOTHUTU != null) txtSothutu.Text = oT.SOTHUTU.ToString();
            ddlHinhthucnhandon.SelectedValue = oT.HINHTHUCNHANDON.ToString();
            if (oT.HINHTHUCNHANDON == 3)
                LoadLoaiDon(true);
            else
                LoadLoaiDon(false);
            if (oT.NGAYVIETDON != DateTime.MinValue) txtNgayViet.Text = ((String.IsNullOrEmpty(oT.NGAYVIETDON + "")) || (((DateTime)oT.NGAYVIETDON) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul); //((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
            if (oT.NGAYNHANDON != DateTime.MinValue) txtNgayNhan.Text = ((String.IsNullOrEmpty(oT.NGAYNHANDON + "")) || (((DateTime)oT.NGAYNHANDON) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul); //((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul);
            ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
            ddlQuanhephapluat.SelectedValue = oT.QUANHEPHAPLUATID.ToString();
            if (ddlCanbonhandon.Items.FindByValue(oT.CANBONHANDONID + "") != null)
                ddlCanbonhandon.SelectedValue = oT.CANBONHANDONID + "";
            if (ddlThamphankynhandon.Items.FindByValue(oT.THAMPHANKYNHANDON + "") != null)
                ddlThamphankynhandon.SelectedValue = oT.THAMPHANKYNHANDON + "";
            ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();
            txtDonkiencuanguoikhac.Text = oT.DONKIENCUANGUOIKHAC;
            ddlLoaidon.SelectedValue = oT.LOAIDON.ToString();
            txtNoidungkhoikien.Text = oT.NOIDUNGKHOIKIEN;
            
        }
        private bool CheckValid()
        {
            if (txtNgayNhan.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập ngày nhận đơn";
                txtNgayNhan.Focus();
                return false;
            }
            DateTime dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgT.Text = lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại !";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlCanbonhandon.Items.Count == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn người nhận đơn";
                return false;
            }

            return true;
        }
        private void ResetControls()
        {
            txtMaVuViec.Text = "";
            txtTenVuViec.Text = "";
            // txtSothutu.Text = "";
            txtNgayViet.Text = txtNgayNhan.Text = "";
            txtDonkiencuanguoikhac.Text = "";
            txtNoidungkhoikien.Text = "";

            hddID.Value = "0";
        }
        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            //Load đối tượng nộp đơn
            //Load cán bộ
            ddlCanbonhandon.Items.Clear();
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanbonhandon.DataSource = oCBDT;
            ddlCanbonhandon.DataTextField = "MA_TEN";
            ddlCanbonhandon.DataValueField = "ID";
            ddlCanbonhandon.DataBind();
            //Set mặc định cán bộ loginf
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlCanbonhandon.SelectedValue = strCBID;
            }
            catch { }
            ddlThamphankynhandon.Items.Clear();
            ddlThamphankynhandon.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphankynhandon.DataTextField = "MA_TEN";
            ddlThamphankynhandon.DataValueField = "ID";
            ddlThamphankynhandon.DataBind();
            ddlThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            //Load Quan hệ pháp luật
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAUPS);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load quốc tịch
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
        }
        private bool SaveData()
        {
            try
            {
                if (!CheckValid()) return false;
                APS_DON oT;
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oT = new APS_DON();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    oT = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
                }
                // oT.SOTHUTU = (txtSothutu.Text == "") ? 0 : Convert.ToDecimal(txtSothutu.Text);
                oT.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                DateTime dNgayViet;
                DateTime dNgayNhan;
                dNgayViet = (String.IsNullOrEmpty(txtNgayViet.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYVIETDON = dNgayViet;
                oT.NGAYNHANDON = dNgayNhan;
                oT.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oT.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
                oT.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                oT.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                oT.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);
                oT.DONKIENCUANGUOIKHAC = txtDonkiencuanguoikhac.Text;
                oT.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                oT.NOIDUNGKHOIKIEN = txtNoidungkhoikien.Text;

                if (hddID.Value == "" || hddID.Value == "0")
                {
                    APS_DON_BL dsBL = new APS_DON_BL();
                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    oT.MAVUVIEC = Session[ENUM_SESSION.SESSION_MADONVI] + "." + ENUM_LOAIVUVIEC.AN_PHASAN + "." + oT.TT.ToString();
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    dt.APS_DON.Add(oT);
                    dt.SaveChanges();
                    hddID.Value = oT.ID.ToString();
                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("7", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                #endregion
                //Lưu nguyên đơn đại diện
                APS_DON_DUONGSU_BL oDonBL = new APS_DON_DUONGSU_BL();
                oDonBL.APS_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);
                return true;
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin đơn thành công !";
                Session["PS_THEMDSK"] = hddID.Value;
            }
        }
        protected void cmdUpdateSelect_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                decimal IDVuViec = Convert.ToDecimal(hddID.Value);
                //Lưu vào người dùng
                decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                {
                    oNSD.IDANPHASAN = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_PHASAN] = IDVuViec;
                Response.Redirect("Thongtindon.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng khác cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            }
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin đơn tiếp theo !";
            }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCombobox();
        }
    }
}