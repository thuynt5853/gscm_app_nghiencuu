using BL.GSTP;
using BL.GSTP.AHC;
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

namespace WEB.GSTP.QLAN.AHC.Hoso
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
            Session[keyDonID] = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
            Session[keyLoaiAnId] = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SetDonGhep();
                txtNgayNhan.Text = DateTime.Now.ToString("dd/MM/yyyy");
                LoadCombobox();
                string current_id = Request["ID"] + "";
                string strtype = Request["type"] + "";
                LoadLoaiDon(false);
                string strDonID = Session["HC_THEMDSK"] + "";
                if (strtype == "new")
                {
                    if (strDonID != "")
                    {

                        hddID.Value = Session["HC_THEMDSK"] + "";
                        decimal ID = Convert.ToDecimal(Session["HC_THEMDSK"]);
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
                    current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
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
                //    AHC_DON oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
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
                //    string Result = new AHC_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg);
                //    if (Result != "")
                //    {
                //        lstMsgT.Text = lstMsgB.Text = Result;
                //        //Cls_Comon.SetButton(cmdUpdate, false);
                //        //Cls_Comon.SetButton(cmdUpdateB, false);
                //        //Cls_Comon.SetButton(cmdUpdateSelect, false);
                //        //Cls_Comon.SetButton(cmdUpdateAndNew, false);
                //        //Cls_Comon.SetButton(cmdUpdateSelectB, false);
                //        //Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                //        return;
                //    }
                //}

                //if (strtype != "new")
                //{
                //    current_id = Session[ENUM_LOAIAN.AN_HANHCHINH] + "";
                //    if (!string.IsNullOrEmpty(current_id))
                //    {
                //        decimal Id = Convert.ToDecimal(current_id);
                //        AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == Id).FirstOrDefault();
                //        if (oDon.LOAIDON == 2)
                //        {
                //            lstMsgT.Text = lstMsgB.Text = "Đơn đã chuyển sang tòa án khác xử lý !";
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
            AHC_DON oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
            txtMaVuViec.Text = oT.MAVUVIEC;
            txtTenVuViec.Text = oT.TENVUVIEC;
            // if (oT.SOTHUTU != null) txtSothutu.Text = oT.SOTHUTU.ToString();
            if (oT.HINHTHUCNHANDON == 3)
                LoadLoaiDon(true);
            else
                LoadLoaiDon(false);
            ddlHinhthucnhandon.SelectedValue = oT.HINHTHUCNHANDON.ToString();
            if (oT.NGAYVIETDON != DateTime.MinValue) txtNgayViet.Text = ((String.IsNullOrEmpty(oT.NGAYVIETDON + "")) || (((DateTime)oT.NGAYVIETDON) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul); //((DateTime)oT.NGAYVIETDON).ToString("dd/MM/yyyy", cul);
            if (oT.NGAYNHANDON != DateTime.MinValue) txtNgayNhan.Text = ((String.IsNullOrEmpty(oT.NGAYNHANDON + "")) || (((DateTime)oT.NGAYNHANDON) == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul); //((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy", cul);

            txtQuanhephapluat_name(oT);
            if (oT.QHPLTKID != null)
                ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();
            if (ddlCanbonhandon.Items.FindByValue(oT.CANBONHANDONID + "") != null)
                ddlCanbonhandon.SelectedValue = oT.CANBONHANDONID + "";
            if (ddlThamphankynhandon.Items.FindByValue(oT.THAMPHANKYNHANDON + "") != null)
                ddlThamphankynhandon.SelectedValue = oT.THAMPHANKYNHANDON + "";

            ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();
            txtDonkiencuanguoikhac.Text = oT.DONKIENCUANGUOIKHAC;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
            ddlLoaidon.SelectedValue = oT.LOAIDON.ToString();
            txtNoidungkhoikien.Text = oT.NOIDUNGKHOIKIEN;
            txtQDSO.Text = oT.SOQD + "";
            txtQDHanhvi.Text = oT.HANHVIHC + "";
            txtQDTen.Text = oT.TENQD + "";
            if (oT.NGAYQD != null) txtQDNgay.Text = ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);
        }

        private bool CheckValid()
        {
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstMsgT.Text = lstMsgB.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
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
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn quan hệ pháp luật dùng thống kê";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            decimal IDChitieuTK = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
            if (dt.DM_QHPL_TK.Where(x => x.PARENT_ID == IDChitieuTK).ToList().Count > 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Quan hệ pháp luật dùng cho thống kê chỉ được chọn mã con, bạn hãy chọn lại !";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            if (ddlCanbonhandon.Items.Count == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Chưa chọn người nhận đơn";
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanbonhandon.ClientID);
                return false;
            }

            return true;
        }
        private void ResetControls()
        {
            txtQuanhephapluat.Text = null;
            ddlQuanhephapluat.SelectedIndex = 0;
            txtMaVuViec.Text = "";
            txtTenVuViec.Text = "";
            // txtSothutu.Text = "";
            txtNgayViet.Text = txtNgayNhan.Text = "";
            txtDonkiencuanguoikhac.Text = "";
            txtNoidungkhoikien.Text = "";

            hddID.Value = "0";

            LoadLoaiDon(false);
        }

        private void LoadCombobox()
        {
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
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_KHIEUKIEN_HC);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.Items.Clear();
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.HANHCHINH && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));

            //Load quốc tịch
            DataTable dtQuoctich = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUOCTICH);
        }
        private bool SaveData()
        {
            try
            {
                if (!CheckValid()) return false;
                AHC_DON oT;
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oT = new AHC_DON();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    oT = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                }
                //oT.TENVUVIEC = txtTennguyendon.Text + " - " + txtBD_Ten.Text + " - " + ddlQuanhephapluat.SelectedItem.Text;
                // oT.SOTHUTU = (txtSothutu.Text == "") ? 0 : Convert.ToDecimal(txtSothutu.Text);
                oT.HINHTHUCNHANDON = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                DateTime dNgayViet;
                DateTime dNgayNhan;
                dNgayViet = (String.IsNullOrEmpty(txtNgayViet.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayViet.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dNgayNhan = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYVIETDON = dNgayViet;
                oT.NGAYNHANDON = dNgayNhan;
                oT.LOAIQUANHE = 1;

                //oT.QUANHEPHAPLUATID = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);

                oT.QUANHEPHAPLUATID = null;
                if (txtQuanhephapluat.Text != null || txtQuanhephapluat.Text != "")
                    oT.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                if (txtQuanhephapluat.Text == "" || txtQuanhephapluat.Text == null)
                    oT.QUANHEPHAPLUAT_NAME = null;

                oT.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oT.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                oT.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                oT.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);
                oT.DONKIENCUANGUOIKHAC = txtDonkiencuanguoikhac.Text;
                oT.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                oT.NOIDUNGKHOIKIEN = txtNoidungkhoikien.Text;

                oT.SOQD = txtQDSO.Text;
                oT.HANHVIHC = txtQDHanhvi.Text;
                oT.TENQD = txtQDTen.Text;
                oT.NGAYQD = (String.IsNullOrEmpty(txtQDNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtQDNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    AHC_DON_BL dsBL = new AHC_DON_BL();
                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    oT.MAVUVIEC = ENUM_LOAIVUVIEC.AN_HANHCHINH + Session[ENUM_SESSION.SESSION_MADONVI] + oT.TT.ToString();
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                    //update 14082025
                    if (oT.TOA_GIAIQUYET_ID == null) oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    if (oT.TOA_PHUCTHAM_GIAIQUYET_ID == null)
                        oT.TOA_PHUCTHAM_GIAIQUYET_ID = oT.TOAPHUCTHAMID;
                    dt.AHC_DON.Add(oT);
                    dt.SaveChanges();
                    hddID.Value = oT.ID.ToString();
                    dt.SaveChanges();
                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("6", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                #endregion

                //Lưu người khởi kiện đại diện

                AHC_DON_DUONGSU_BL oDonBL = new AHC_DON_DUONGSU_BL();
                oDonBL.AHC_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);
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
                Session["HC_THEMDSK"] = hddID.Value;
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
                    oNSD.IDANHANHCHINH = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_HANHCHINH] = IDVuViec;
                Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng khác cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            }
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin đơn tiếp theo !";
                // txtSothutu.Focus();
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


        private void txtQuanhephapluat_name(AHC_DON oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if (obj != null) txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
                txtQuanhephapluat.Text = null;
        }
    }
}