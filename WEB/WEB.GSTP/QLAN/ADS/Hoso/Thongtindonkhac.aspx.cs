using BL.GSTP;
using BL.GSTP.ADS;
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

namespace WEB.GSTP.QLAN.ADS.Hoso
{
    public partial class Thongtindonkhac : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;

        private void SetDonGhep()
        {
            string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId= "DONGHEP.LOAIANID"+ Session[ENUM_SESSION.SESSION_USERID].ToString();
            Session[keyDonID] = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU]);
            Session[keyLoaiAnId] = Convert.ToDecimal(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU);
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
                string strDonID = Session["DS_THEMDSK"] + "";
                if (strtype == "new")
                {
                    if (strDonID != "")
                    {
                        hddID.Value = Session["DS_THEMDSK"] + "";
                        decimal ID = Convert.ToDecimal(Session["DS_THEMDSK"]);
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
                    current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                    if (current_id != "" && current_id != "0")
                    {
                        hddID.Value = current_id.ToString();
                        decimal ID = Convert.ToDecimal(current_id);
                        LoadInfo(ID);
                    }
                }
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                //Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdateB, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdateSelect, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdateAndNew, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdateSelectB, oPer.CAPNHAT);
                //Cls_Comon.SetButton(cmdUpdateAndNewB, oPer.CAPNHAT);
                Cls_Comon.SetFocus(this, this.GetType(), ddlHinhthucnhandon.ClientID);
                //if (hddID.Value != "" && hddID.Value != "0")
                //{
                //    decimal ID = Convert.ToDecimal(hddID.Value);
                //    ADS_DON oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
                //    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                //    {
                //        lstMsgT.Text = lstMsgB.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                //        //Cls_Comon.SetButton(cmdUpdate, false);
                //        //Cls_Comon.SetButton(cmdUpdateB, false);
                //        //Cls_Comon.SetButton(cmdUpdateSelect, false);
                //        //Cls_Comon.SetButton(cmdUpdateAndNew, false);
                //        //Cls_Comon.SetButton(cmdUpdateSelectB, false);
                //        //Cls_Comon.SetButton(cmdUpdateAndNewB, false);
                //        return;
                //    }
                //    string StrMsg = "Không được sửa đổi thông tin.";
                //    string Result = new ADS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg);
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
                //    current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                //    if (!string.IsNullOrEmpty(current_id))
                //    {
                //        decimal Id = Convert.ToDecimal(current_id);
                //        List<ADS_DON_XULY> oDON_XLY = dt.ADS_DON_XULY.Where(x => x.DONID == Id).ToList<ADS_DON_XULY>();
                //        if (oDON_XLY.Count > 0)
                //        {
                //            lstMsgT.Text = lstMsgB.Text = "Đơn đã được xử lý không được thay đổi !";
                //            //Cls_Comon.SetButton(cmdUpdate, false);
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
            ADS_DON oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
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
            ddlLoaiQuanhe.SelectedValue = oT.LOAIQUANHE.ToString();
            txtQuanhephapluat_name(oT);
            if (oT.QHPLTKID != null)
                ddlQHPLTK.SelectedValue = oT.QHPLTKID.ToString();

            if (ddlCanbonhandon.Items.FindByValue(oT.CANBONHANDONID + "") != null)
                ddlCanbonhandon.SelectedValue = oT.CANBONHANDONID + "";
            if (ddlThamphankynhandon.Items.FindByValue(oT.THAMPHANKYNHANDON + "") != null)
                ddlThamphankynhandon.SelectedValue = oT.THAMPHANKYNHANDON + "";

            ddlYeutonuocngoai.SelectedValue = oT.YEUTONUOCNGOAI.ToString();

            ddlLoaidon.SelectedValue = oT.LOAIDON.ToString();
            txtNoidungkhoikien.Text = oT.NOIDUNGKHOIKIEN + "";
        }
        #region Thiều

        #endregion
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
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa nhập ngày nhận đơn.";
                txtNgayNhan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn phải nhập ngày nhận đơn theo định dạng dd/MM/yyyy.";
                txtNgayNhan.Focus();
                return false;
            }
            DateTime dNgayNhan = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgT.Text = lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại.";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn quan hệ pháp luật dùng thống kê.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            decimal IDChitieuTK = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
            if (dt.DM_QHPL_TK.Where(x => x.PARENT_ID == IDChitieuTK).ToList().Count > 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Quan hệ pháp luật dùng cho thống kê chỉ được chọn mã con. Hãy chọn lại.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            if (ddlCanbonhandon.Items.Count == 0)
            {
                lstMsgT.Text = lstMsgB.Text = "Bạn chưa chọn người nhận đơn.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlCanbonhandon.ClientID);
                return false;
            }
            return true;
            // Bị đơn
        }
        private void ResetControls()
        {
            txtQuanhephapluat.Text = null;
            ddlQuanhephapluat.SelectedIndex = 0;
            txtMaVuViec.Text = "";
            txtTenVuViec.Text = "";
            // txtSothutu.Text = "";
            txtNgayViet.Text = txtNgayNhan.Text = "";

            txtNoidungkhoikien.Text = "";

            hddID.Value = "0";
            LoadLoaiDon(false);
        }
        private void LoadCombobox()
        {
            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlCanbonhandon.Items.Clear();

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
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU, ENUM_DANHMUC.QUANHEPL_TRANHCHAP);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();
            //Load QHPL Thống kê.
            ddlQHPLTK.Items.Clear();
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.DANSU && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));

        }
        private bool SaveData()
        {
            try
            {
                if (!CheckValid()) return false;
                ADS_DON oT;
                #region "THÔNG TIN ĐƠN KHỞI KIỆN"
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    oT = new ADS_DON();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    oT = dt.ADS_DON.Where(x => x.ID == ID).FirstOrDefault();
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
                oT.LOAIQUANHE = Convert.ToDecimal(ddlLoaiQuanhe.SelectedValue);
                oT.QUANHEPHAPLUATID = null;
                if (txtQuanhephapluat.Text != null || txtQuanhephapluat.Text != "")
                    oT.QUANHEPHAPLUAT_NAME = txtQuanhephapluat.Text;
                if (txtQuanhephapluat.Text == "" || txtQuanhephapluat.Text == null)
                    oT.QUANHEPHAPLUAT_NAME = null; oT.QHPLTKID = Convert.ToDecimal(ddlQHPLTK.SelectedValue);
                oT.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                oT.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                oT.YEUTONUOCNGOAI = Convert.ToDecimal(ddlYeutonuocngoai.SelectedValue);

                oT.LOAIDON = Convert.ToDecimal(ddlLoaidon.SelectedValue);
                oT.NOIDUNGKHOIKIEN = txtNoidungkhoikien.Text;
                if (hddID.Value == "" || hddID.Value == "0")
                {
                    ADS_DON_BL dsBL = new ADS_DON_BL();
                    oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                    oT.TRANGTHAI = ENUM_DS_TRANGTHAI.TAOMOI;
                    oT.MAVUVIEC = ENUM_LOAIVUVIEC.AN_DANSU + Session[ENUM_SESSION.SESSION_MADONVI] + oT.TT.ToString();
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;// anhvh edit 17/04/2020 không dùng ENUM_GIAIDOANVUAN.HOSO vì không phù hợp với nghiệp vụ tòa án
                    oT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oT.TOA_PHUCTHAM_GIAIQUYET_ID = oT.TOAPHUCTHAMID;
                    dt.ADS_DON.Add(oT);
                    dt.SaveChanges();
                    hddID.Value = oT.ID.ToString();
                    //anhvh add 26/06/2020
                    GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                    GD.GAIDOAN_INSERT_UPDATE("2", oT.ID,2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]),0,0,0,0);
                }
                else
                {
                    oT.NGAYSUA = DateTime.Now;
                    oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                #endregion
                //Lưu nguyên đơn đại diện
                ADS_DON_DUONGSU_BL oDonBL = new ADS_DON_DUONGSU_BL();
                oDonBL.ADS_DON_YEUTONUOCNGOAI_UPDATE(oT.ID);
                return true;
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        //lbtimkiem_Click
        
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin đơn thành công !";
                Session["DS_THEMDSK"] = hddID.Value;
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
                    oNSD.IDANDANSU = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_DANSU] = IDVuViec;
                Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");

            }
        }

        protected void txtNgayNhan_TextChanged(object sender, EventArgs e)
        {
            if (txtNgayNhan.Text != "" && Cls_Comon.IsValidDate(txtNgayNhan.Text))
            {
                DateTime NgayNhan = DateTime.Parse(txtNgayNhan.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            }
        }

        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Hoàn thành Lưu, bạn hãy nhập thông tin đơn tiếp theo !";
                Cls_Comon.SetFocus(this, this.GetType(), ddlHinhthucnhandon.ClientID);
            }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
        
        protected void ddlQuanhephapluat_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal IDQHPL = Convert.ToDecimal(ddlQuanhephapluat.SelectedValue);
            DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
            DM_DATAGROUP oGroup = dt.DM_DATAGROUP.Where(x => x.ID == obj.GROUPID).FirstOrDefault();
            if (oGroup.MA == ENUM_DANHMUC.QUANHEPL_TRANHCHAP)
                ddlLoaiQuanhe.SelectedValue = "1";
            else
                ddlLoaiQuanhe.SelectedValue = "2";
            Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);

        }

        private  void SetValueComboBox(DropDownList ddl, object value)
        {
            ddl.ClearSelection();
            string str = value + "";
            if (str == "") return;
            if (ddl.Items.FindByValue(str) != null)
                ddl.SelectedValue = str;
        }
       
        private int TinhTuoi(DateTime NgaySinh, DateTime NgayNhanDon)
        {
            try
            {
                int nam = NgayNhanDon.Year - NgaySinh.Year;
                if (nam > 0)
                {
                    int thang = NgayNhanDon.Month - NgaySinh.Month;
                    if (thang == 0)
                    {
                        int ngay = NgayNhanDon.Day - NgaySinh.Day;
                        if (ngay <= 0)
                        { nam = nam - 1; }
                    }
                    else if (thang < 0)
                    {
                        nam = nam - 1;
                    }
                }
                return nam;
            }
            catch { return 0; }
        }

        
        private void txtQuanhephapluat_name(ADS_DON oT)
        {
            if (oT.QUANHEPHAPLUAT_NAME != null)
            {
                txtQuanhephapluat.Text = oT.QUANHEPHAPLUAT_NAME;
            }
            else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
            {
                decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                if(obj != null)
                txtQuanhephapluat.Text = obj.TEN.ToString();
            }
            else
                txtQuanhephapluat.Text = null;
        }

    }
}