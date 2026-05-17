using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text.RegularExpressions;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.Quantri.Nguoidung
{
    public partial class ResetPass : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
          
            if (!IsPostBack)
            {
                CheckQuyen();
                decimal current_id = Convert.ToDecimal(Request["vID"] + "");
                hddID.Value = current_id.ToString();
              
                QT_NGUOISUDUNG oT = dt.QT_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
                if (oT == null) return;
                txtUserName.Text = oT.USERNAME;
                if(oT.ISACCDOMAIN==1)
                {
                    txtPass.Enabled = txtRepass.Enabled=cmdSave.Enabled = false;
                    lttMsg.Text = "<div class='error_msg' style='color: red; '>Tài khoản domain không khởi tạo mật khẩu !</div>";
                }
            }
        }

        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdSave, oPer.CAPNHAT);
        }
        protected void cmdBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }

        protected void cmdSave_Click(object sender, EventArgs e)
        {

            if (validateForm())
            {
               
                decimal current_id = Convert.ToDecimal(Request["vID"] + "");
                hddID.Value = current_id.ToString();
                QT_NGUOISUDUNG oT = dt.QT_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();

                //anhpn
                #region Check password
                var OQUANTRI_MATKHAU = DataExtensions.FindById<QUANTRI_MATKHAU>(1);
                if (OQUANTRI_MATKHAU != null)
                {
                    if (OQUANTRI_MATKHAU.KHONG_TRUNG_MK_CU == 1 && oT.PASSWORD == Cls_Comon.MD5Encrypt(txtPass.Text))
                    {
                        lttMsg.Text = "Mật khẩu mới không được trùng mật khẩu cũ !";
                        return;
                    }
                    if (!string.IsNullOrEmpty(OQUANTRI_MATKHAU.DO_DAI_TOI_THIEU) && txtPass.Text.Length < int.Parse(OQUANTRI_MATKHAU.DO_DAI_TOI_THIEU))
                    {
                        lttMsg.Text = "Mật khẩu phải có tối thiểu " + OQUANTRI_MATKHAU.DO_DAI_TOI_THIEU + " ký tự!";
                        return;
                    }
                    var hasNumber = new Regex(@"[0-9]+");
                    var hasUpperChar = new Regex(@"[A-Z]+");
                    var hasLowerChar = new Regex(@"[a-z]+");
                    var hasSymbols = new Regex(@"[!@#$%^&*()_+=\[{\]};:<>|./?,-]");

                    if (OQUANTRI_MATKHAU.CHU_THUONG == 1 && !hasLowerChar.IsMatch(txtPass.Text))
                    {
                        lttMsg.Text = "Mật khẩu phải có tối thiểu 01 ký tự thường!";
                        return;
                    }
                    else if (OQUANTRI_MATKHAU.CHU_HOA == 1 && !hasUpperChar.IsMatch(txtPass.Text))
                    {
                        lttMsg.Text = "Mật khẩu phải có tối thiểu 01 ký tự in hoa!";
                        return;
                    }
                    else if (OQUANTRI_MATKHAU.CO_SO == 1 &&  !hasNumber.IsMatch(txtPass.Text))
                    {
                        lttMsg.Text = "Mật khẩu phải có tối thiểu 01 ký tự số!";
                        return;
                    }
                    else if (!hasSymbols.IsMatch(txtPass.Text))
                    {
                        lttMsg.Text = "Mật khẩu phải có tối thiểu 01 ký tự đặc biệt!";
                        return;
                    }
                    if (OQUANTRI_MATKHAU.CHUA_TEN_TAI_KHOAN == 1 && (txtPass.Text.ToLower()).Contains(txtUserName.Text.ToLower()))
                    {
                        lttMsg.Text += "Mật khẩu không được chứa tên tài khoản !";
                        return;
                    }
                    var OCanBo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                    if (OCanBo == null)
                    {
                        lttMsg.Text += "Tài khoản đang không gắn với người sử dụng. Vui lòng liên hệ Quản trị viên để được hỗ trợ !";
                        return;
                    }
                    if (!string.IsNullOrEmpty(OCanBo.SODIENTHOAI))
                    {
                        var strSODIENTHOAI = OCanBo.SODIENTHOAI.Replace(" ", "");
                        if (OQUANTRI_MATKHAU.CHUA_SDT == 1 && txtPass.Text.Contains(strSODIENTHOAI))
                        {
                            lttMsg.Text = "Mật khẩu không được chứa số điện thoại !";
                            return;
                        }
                    }
                    if (OQUANTRI_MATKHAU.CHUA_NAMSINH == 1 && OCanBo.NGAYSINH != null)
                    {
                        var StrNgaySinh = OCanBo.NGAYSINH.Value.ToString("ddMMyyyy");
                        var StrNgaySinh2 = OCanBo.NGAYSINH.Value.ToString("ddMMyy");
                        if (txtPass.Text.Contains(StrNgaySinh) || txtPass.Text.Contains(StrNgaySinh2))
                        {
                            lttMsg.Text = "Mật khẩu không được chứa ngày/tháng/năm sinh !";
                            return;
                        }
                    }
                    var hoten = OCanBo.HOTEN.Split(' ').ToArray();
                    var str = ConvertToUnSign(hoten[hoten.Count() - 1]);
                    var strlower = str.ToLower();
                    if (OQUANTRI_MATKHAU.CHUA_TEN_NGUOISD == 1 && (txtPass.Text.Contains(str) || txtPass.Text.Contains(strlower)))
                    {
                        lttMsg.Text += "Mật khẩu không được chứa tên người sử dụng!";
                        return;
                    }
                }
                #endregion
                //var checkvalidateTK = DataExtensions.FindById<VALIDATE_TAIKHOAN>(current_id);
                //if (checkvalidateTK != null)
                //{
                //    checkvalidateTK.NGAY_THAY_DOI_MK = DateTime.Now;
                //    checkvalidateTK.MATKHAU_OLD = oT.PASSWORD;
                //    DataExtensions.Update<VALIDATE_TAIKHOAN>(checkvalidateTK);
                //}
                //else
                //{
                //var OBL = new VALIDATE_TAIKHOAN_BL();
                //var checkvalidateTK = new VALIDATE_TAIKHOAN();
                //    checkvalidateTK.NGUOISUDUNG_ID = current_id;
                //    checkvalidateTK.NGAY_THAY_DOI_MK = DateTime.Now;
                //    checkvalidateTK.MATKHAU_OLD = oT.PASSWORD;
                //    //DataExtensions.Insert<VALIDATE_TAIKHOAN>(checkvalidateTK);
                //    OBL.VALIDATE_TAIKHOAN_INSERT(checkvalidateTK);
                //}

                var checkvalidatelog = new VALIDATE_TAIKHOAN_LOG();
                checkvalidatelog.USER_ID = current_id;
                checkvalidatelog.NGAY_THAY_DOI_MK = DateTime.Now;
                checkvalidatelog.MATKHAU_OLD = oT.PASSWORD;
                checkvalidatelog.NGUOI_DOI_MK = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                checkvalidatelog.NGUOI_DOI_MK_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                DataExtensions.Insert<VALIDATE_TAIKHOAN_LOG>(checkvalidatelog);

                oT.PASSWORD = Cls_Comon.MD5Encrypt(txtPass.Text);
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
                
                Response.Redirect("Danhsach.aspx");
            }
        }
        Boolean validateForm()
        {
            bool val = true;
            if (txtPass.Text.Trim() == "")
            {
                lttMsg.Text = "<div class='error_msg'  style='color: red; '>Bạn chưa nhập mật khẩu !</div>";
                val = false;
            }
            else if (txtPass.Text.Length < 6)
            {
                lttMsg.Text = "<div class='error_msg'  style='color: red; '>Mật khẩu tối thiểu 6 ký tự !</div>";
                val = false;
            }
            else if (txtPass.Text.Length >= 100)
            {
                lttMsg.Text = "<div class='error_msg'  style='color: red; '>Mật khẩu nhập quá 100 ký tự !</div>";
                val = false;
            }
            else if (txtPass.Text != txtRepass.Text)
            {
                lttMsg.Text = "<div class='error_msg'  style='color: red; '>Nhập lại mật không chính xác !</div>";
                val = false;
            }
            return val;
        }
        public static string ConvertToUnSign(string text)
        {
            for (int i = 33; i < 48; i++)
            {
                text = text.Replace(((char)i).ToString(), "");
            }

            for (int i = 58; i < 65; i++)
            {
                text = text.Replace(((char)i).ToString(), "");
            }

            for (int i = 91; i < 97; i++)
            {
                text = text.Replace(((char)i).ToString(), "");
            }
            for (int i = 123; i < 127; i++)
            {
                text = text.Replace(((char)i).ToString(), "");
            }
            text = text.Replace(" ", "");
            Regex regex = new Regex(@"\p{IsCombiningDiacriticalMarks}+");
            string strFormD = text.Normalize(System.Text.NormalizationForm.FormD);
            return regex.Replace(strFormD, String.Empty).Replace('\u0111', 'd').Replace('\u0110', 'D');
        }
    }
}