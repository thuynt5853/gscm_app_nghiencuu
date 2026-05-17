using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHN;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHN.TaoHS.Popup
{
    public partial class pNguoiThamGiaTT : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal Donid = 0, NguoiTGTTID = 0;
      
        protected void Page_Load(object sender, EventArgs e)
        {
            
            //CurrentYear = DateTime.Now.Year;
            if (!IsPostBack)
            {
                string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                Donid = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
                NguoiTGTTID = (String.IsNullOrEmpty(Request["uID"] + "")) ? 0 : Convert.ToDecimal(Request["uID"] + "");
                hddCurrID.Value = NguoiTGTTID.ToString();
                
                if (Donid == 0)
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");

                LoadCombobox();
                if (NguoiTGTTID > 0)
                    LoadInfo();
                uDSNguoiThamGiaToTung.Donid = Donid;
                //CheckTrangThai();
                AHN_PHUCTHAM_THULY oTLPT = dt.AHN_PHUCTHAM_THULY.Where(x => x.DONID == Donid).FirstOrDefault() ?? new AHN_PHUCTHAM_THULY();
                if (oTLPT.ID > 0)
                {
                    #region Thiều
                    GetDuongSu();
                    #endregion

                    if (ddlTucachTGTT.SelectedValue == "TGTTDS_01")
                    {
                        pnItemDs.Visible = true;
                    }
                    else
                    {
                        pnItemDs.Visible = false;
                    }
                    Cls_Comon.SetButton(cmdUpdate, false);
                    //Cls_Comon.SetButton(cmdLammoi, false);
                    LockControl();
                    return;
                }
            }
            #region Thiều
            GetDuongSu();
            #endregion

            if (ddlTucachTGTT.SelectedValue == "TGTTDS_01")
            {
                pnItemDs.Visible = true;
            }
            else
            {
                pnItemDs.Visible = false;
            }
        }

        #region Thiều
        public void GetDuongSu(string strlstId = "")
        {
            pnDuongSuDON_GHEP.Controls.Clear();
            if (string.IsNullOrEmpty(strlstId))
            {
                decimal donId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
                var lstDuongSu = (from a in dt.AHN_DON_DUONGSU.Where(s => s.DONID == donId)
                                  join d in dt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                  select new
                                  {
                                      ID = a.ID,
                                      TENDUONGSU = a.TENDUONGSU,
                                      TUCACHTOTUNG = d.TEN,
                                      TUCACHTOTUNG_MA = d.MA
                                  });
                foreach (var item in lstDuongSu)
                {
                    CheckBox checkBox = new CheckBox();
                    checkBox.Text = item.TENDUONGSU + " (" + item.TUCACHTOTUNG + ")";
                    checkBox.ToolTip = item.ID.ToString();
                    checkBox.Checked = false;
                    checkBox.InputAttributes.Add("TCTT", item.TUCACHTOTUNG_MA);
                    checkBox.CssClass = "clcheckbox";
                    pnDuongSuDON_GHEP.Controls.Add(checkBox);
                }


            }
            else
            {
                lstDataDuongSu.Value = strlstId;
                List<decimal> lstId = strlstId.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => Convert.ToDecimal(s)).ToList();
                decimal donId = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
                var lstDuongSu = (from a in dt.AHN_DON_DUONGSU.Where(s => s.DONID == donId)
                                  join d in dt.DM_DATAITEM on a.TUCACHTOTUNG_MA equals d.MA
                                  select new
                                  {
                                      ID = a.ID,
                                      TENDUONGSU = a.TENDUONGSU,
                                      TUCACHTOTUNG = d.TEN,
                                      TUCACHTOTUNG_MA = d.MA
                                  });
                foreach (var item in lstDuongSu)
                {
                    CheckBox checkBox = new CheckBox();
                    checkBox.Text = item.TENDUONGSU + " (" + item.TUCACHTOTUNG + ")";
                    checkBox.ToolTip = item.ID.ToString();
                    if (lstId.Contains(item.ID))
                    {
                        checkBox.Checked = true;
                    }
                    else
                    {
                        checkBox.Checked = false;
                    }
                    checkBox.InputAttributes.Add("TCTT", item.TUCACHTOTUNG_MA);
                    checkBox.CssClass = "clcheckbox";
                    pnDuongSuDON_GHEP.Controls.Add(checkBox);
                }
            }
            Cls_Comon.CallFunctionJS(this, this.GetType(), "loadeventchange();");
        }
        #endregion
        void CheckTrangThai()
        {
            Donid = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            AHN_DON oT = dt.AHN_DON.Where(x => x.ID == Donid).FirstOrDefault();
            
            if (oT.MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.DINHCHI)
            {
                lbthongbao.Text = "Vụ việc đã bị đình chỉ, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                //Cls_Comon.SetButton(cmdLammoi, false);
                LockControl();
                return;
            }
            else if(oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                //Cls_Comon.SetButton(cmdLammoi, false);
                LockControl();
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHN_CHUYEN_NHAN_AN_BL().Check_NhanAn(Donid,  StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                ///Cls_Comon.SetButton(cmdLammoi, false);
                LockControl();
                return;
            }
        }
        void LockControl()
        {
            ddlTucachTGTT.Enabled = ddlND_Gioitinh.Enabled = false;
            txtHoten.Enabled = txtNgaythamgia.Enabled = txtND_TTChitiet.Enabled = false;
            txtND_Ngaysinh.Enabled = txtND_Ngaysinh.Enabled = txtDienThoai.Enabled= txtND_Namsinh.Enabled = false;
             txtND_HKTT_Chitiet.Enabled= txtNgaythamgia.Enabled = false;
        }
        private void LoadCombobox()
        {
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();

            ddlTucachTGTT.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTDS);
            ddlTucachTGTT.DataTextField = "TEN";
            ddlTucachTGTT.DataValueField = "MA";
            ddlTucachTGTT.DataBind();
        }

        protected void txtND_Ngaysinh_TextChanged(object sender, EventArgs e)
        {
            DateTime d;
            d = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (d != DateTime.MinValue)
            {
                txtND_Namsinh.Text = d.Year.ToString();
            }
            Cls_Comon.SetFocus(this, this.GetType(), txtND_Namsinh.ClientID);
        }

        public void LoadInfo()
        {
            decimal ID = Convert.ToDecimal(hddCurrID.Value);
            DM_HANHCHINH_BL oHCBL = new DM_HANHCHINH_BL();
            AHN_DON_THAMGIATOTUNG oND = dt.AHN_DON_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            txtHoten.Text = oND.HOTEN;
            ddlTucachTGTT.SelectedValue = oND.TUCACHTGTTID.ToString();
            txtND_TTChitiet.Text = oND.TAMTRUCHITIET;
            txtND_HKTT_Chitiet.Text = oND.HKTTCHITIET;
            if (oND.NGAYSINH != null) txtND_Ngaysinh.Text = ((DateTime)oND.NGAYSINH).ToString("dd/MM/yyyy", cul);
            txtND_Namsinh.Text = oND.NAMSINH == 0 ? "" : oND.NAMSINH.ToString();
            ddlND_Gioitinh.SelectedValue = oND.GIOITINH.ToString();
            txtDienThoai.Text = oND.DIENTHOAI;
            txtFax.Text = oND.FAX;
            if (string.IsNullOrEmpty(oND.SOCMND))
            {
                chkBoxCMNDBD.Checked = true;

            }
            else
            {
                chkBoxCMNDBD.Checked = false;

            }
            txtBD_CMND.Text = oND.SOCMND;
            #region Thiều
            GetDuongSu(oND.DUONGSUID);
            #endregion
            //txtNDD_Hoten.Text = oND.NGUOIDAIDIEN;
            if (oND.NGAYTHAMGIA != null) txtNgaythamgia.Text = ((DateTime)oND.NGAYTHAMGIA).ToString("dd/MM/yyyy", cul);
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
                ClearForm();
                lbthongbao.Text = "Cập nhật thành công!";
                //Cls_Comon.CallFunctionJS(this, this.GetType(), "window.onunload = function (e) {opener.LoadDsNguoiThamGiaTT();};window.close(); ");
                //Cls_Comon.CallFunctionJS(this, this.GetType(), "window.onunload = function (e) {opener.LoadDsNguoiThamGiaTT();}; ");
                decimal vDONID = Convert.ToDecimal(hddid.Value);
                uDSNguoiThamGiaToTung.Donid = vDONID;
                uDSNguoiThamGiaToTung.LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
       
        void SaveData()
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "";
                if (current_id == "0" || current_id == "")
                    current_id = (String.IsNullOrEmpty(Request["hsID"] + "")) ? "0" : Request["hsID"];
                if (current_id == "0" || current_id == "")
                    current_id = Donid + "";
                decimal DONID = Convert.ToDecimal(current_id);
             

                AHN_DON_THAMGIATOTUNG oND;
                if (hddCurrID.Value == "" || hddCurrID.Value == "0")
                    oND = new AHN_DON_THAMGIATOTUNG();
                else
                {
                    decimal ID = Convert.ToDecimal(hddCurrID.Value);
                    oND = dt.AHN_DON_THAMGIATOTUNG.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                #region Thiều
                if (lstDataDuongSu.Value == ",")
                {
                    lstDataDuongSu.Value = "";

                }
                List<decimal> lstDuongsuId = lstDataDuongSu.Value.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => Convert.ToDecimal(s)).ToList();
                var data = (from s in dt.AHN_DON_DUONGSU
                            join d in dt.DM_DATAITEM on s.TUCACHTOTUNG_MA equals d.MA
                            where lstDuongsuId.Contains(s.ID)
                            select new
                            {
                                TENDUONGSU = s.TENDUONGSU + " (" + d.TEN + ")",
                            });

                oND.DUONGSUID = lstDataDuongSu.Value;
                #endregion
                oND.HOTEN = txtHoten.Text;
                oND.TUCACHTGTTID = ddlTucachTGTT.SelectedValue;
                oND.TAMTRUCHITIET = txtND_TTChitiet.Text;
                oND.HKTTCHITIET = txtND_HKTT_Chitiet.Text;
                oND.NGAYSINH = (String.IsNullOrEmpty(txtND_Ngaysinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtND_Ngaysinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NAMSINH = txtND_Namsinh.Text == "" ? 0 : Convert.ToDecimal(txtND_Namsinh.Text);
                oND.GIOITINH = Convert.ToDecimal(ddlND_Gioitinh.SelectedValue);
                oND.DIENTHOAI = txtDienThoai.Text;
                oND.FAX = txtFax.Text;
                oND.EMAIL = txtEmail.Text;
                //oND.NGUOIDAIDIEN = txtNDD_Hoten.Text;
                oND.NGAYTHAMGIA = (String.IsNullOrEmpty(txtNgaythamgia.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythamgia.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    
                    if (oND.TOA_GIAIQUYET_ID == null)
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    
                    dt.AHN_DON_THAMGIATOTUNG.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;

            }
            //hddIsReloadParent.Value = "1";
        }
        

        private bool CheckValid()
        {
            if (ddlTucachTGTT.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn tư cách tham gia tố tụng. Hãy nhập lại!";
                ddlTucachTGTT.Focus();
                return false;
            }
            if (txtHoten.Text.Trim() == "")
            {
                lbthongbao.Text = "Chưa nhập họ tên người tham gia tố tụng!";
                txtHoten.Focus();
                return false;
            }
            else if (txtHoten.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Họ tên người tham gia tố tụng không quá 250 ký tự!";
                txtHoten.Focus();
                return false;
            }
           
            if (txtND_TTChitiet.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Nơi tạm trú chi tiết không nhập quá 250 ký tự. Hãy nhập lại!";
                txtND_TTChitiet.Focus();
                return false;
            }
            if (txtND_HKTT_Chitiet.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Nơi ĐKHKTT chi tiết không nhập quá 250 ký tự. Hãy nhập lại!";
                txtND_HKTT_Chitiet.Focus();
                return false;
            }
            if (txtND_Ngaysinh.Text.Trim() != "")
            {
                if (Cls_Comon.IsValidDate(txtND_Ngaysinh.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập ngày sinh theo định dạng (dd/MM/yyyy)!";
                    txtND_Ngaysinh.Focus();
                    return false;
                }
                DateTime NgaySinh = DateTime.Parse(txtND_Ngaysinh.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (NgaySinh > DateTime.Now)
                {
                    lbthongbao.Text = "Bạn phải nhập ngày sinh nhỏ hơn ngày hiện tại!";
                    txtND_Ngaysinh.Focus();
                    return false;
                }
            }

            if (txtDienThoai.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Điện thoại không nhập quá 250 ký tự. Hãy nhập lại!";
                txtDienThoai.Focus();
                return false;
            }
            if (txtFax.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Fax không nhập quá 250 ký tự. Hãy nhập lại!";
                txtFax.Focus();
                return false;
            }
            int lengthEmail = txtEmail.Text.Trim().Length;
            if (lengthEmail > 0)
            {
                if (lengthEmail > 250)
                {
                    lbthongbao.Text = "Email không nhập quá 250 ký tự. Hãy nhập lại!";
                    txtEmail.Focus();
                    return false;
                }
                string email = txtEmail.Text.Trim();
                int atpos = email.IndexOf("@");
                var dotpos = email.LastIndexOf(".");
                if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= lengthEmail)
                {
                    lbthongbao.Text = "Địa chỉ email chưa đúng!";
                    txtEmail.Focus();
                    return false;
                }
            }

            //if (txtNDD_Hoten.Text.Trim().Length > 250)
            //{
            //    lbthongbao.Text = "Đại diện cho không nhập quá 250 ký tự. Hãy nhập lại!";
            //    txtNDD_Hoten.Focus();
            //    return false;
            //}
            return true;
        }
        void ClearForm()
        {
            lbthongbao.Text = "";
            txtHoten.Text = "";
            #region Thiều
            GetDuongSu();
            lstDataDuongSu.Value = "";
            #endregion
            //txtNDD_Hoten.Text = "";
            txtND_Ngaysinh.Text = "";
            txtND_Namsinh.Text = "";
            txtND_HKTT_Chitiet.Text = "";
            txtND_TTChitiet.Text = "";
            txtNgaythamgia.Text = "";
            txtDienThoai.Text = txtFax.Text = txtEmail.Text = "";
            hddid.Value = "0";
            ddlTucachTGTT.SelectedIndex = 0;
        }
    }
}