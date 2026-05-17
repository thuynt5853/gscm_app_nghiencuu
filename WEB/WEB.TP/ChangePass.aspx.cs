using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using System.Text.RegularExpressions;
using BL.GSTP;
using BL.GSTP.BANGSETGET;

namespace WEB.TP
{
    public partial class ChangePass : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                    if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                    txtUserName.Text = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    decimal current_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    var OQUANTRI_MATKHAU_ANPHI = DataExtensions.FindById<QUANTRI_MATKHAU_ANPHI>(1);
                    if (OQUANTRI_MATKHAU_ANPHI != null)
                    {
                        txtLuuY.Text = "<b><u>Lưu ý:</u></b></br>";
                        txtLuuY.Text += "- Mật khẩu phải có tối thiểu " + OQUANTRI_MATKHAU_ANPHI.DO_DAI_TOI_THIEU + " ký tự. Bao gồm ký tự số, chữ viết hoa, chữ viết thường, ít nhất 1 ký tự đặc biệt <b>!@#$%^&*,.</b></br>";
                        txtLuuY.Text += "- Mật khẩu <b>không được chứa tên đăng nhập</b></br>";
                        txtLuuY.Text += "- Mật khẩu <b>không được chứa tên người sử dụng</b></br>";
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = ex.Message;
                }
            }
        }
        protected void cmdThoat_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
        }
        protected void cmdLogIn_Click(object sender, ImageClickEventArgs e)
        {
            if(txtPass_new.Text.Trim()=="")
            {
                lttMsg.Text = "Chưa nhập mật khẩu mới !";
                return;
            }
            //if (txtPass_new.Text.Length<6)
            //{
            //    lttMsg.Text = "Mật khẩu phải trên 6 ký tự !";
            //    return;
            //}
            if (txtPass_new.Text!=txtRePass.Text)
            {
                lttMsg.Text = "Nhập lại mật khẩu không đúng !";
                return;
            }
            decimal current_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            TUPHAP_NGUOISUDUNG oT = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
            #region Check password
            var OQUANTRI_MATKHAU_ANPHI = DataExtensions.FindById<QUANTRI_MATKHAU_ANPHI>(1);
            if (OQUANTRI_MATKHAU_ANPHI != null)
            {
                if (OQUANTRI_MATKHAU_ANPHI.KHONG_TRUNG_MK_CU == 1 && oT.PASSWORD == Cls_Comon.MD5Encrypt(txtPass_new.Text))
                {
                    lttMsg.Text = "Mật khẩu mới không được trùng mật khẩu cũ !";
                    return;
                }
                if (!string.IsNullOrEmpty(OQUANTRI_MATKHAU_ANPHI.DO_DAI_TOI_THIEU) && txtPass_new.Text.Length < int.Parse(OQUANTRI_MATKHAU_ANPHI.DO_DAI_TOI_THIEU))
                {
                    lttMsg.Text = "Mật khẩu phải có tối thiểu " + OQUANTRI_MATKHAU_ANPHI.DO_DAI_TOI_THIEU + " ký tự !";
                    return;
                }
                var hasNumber = new Regex(@"[0-9]+");
                var hasUpperChar = new Regex(@"[A-Z]+");
                var hasLowerChar = new Regex(@"[a-z]+");
                var hasSymbols = new Regex(@"[!@#$%^&*()_+=\[{\]};:<>|./?,-]");

                if (OQUANTRI_MATKHAU_ANPHI.CHU_THUONG == 1 && !hasLowerChar.IsMatch(txtPass_new.Text))
                {
                    lttMsg.Text = "Mật khẩu phải có tối thiểu 01 ký tự thường!";
                    return;
                }
                else if (OQUANTRI_MATKHAU_ANPHI.CHU_HOA == 1 && !hasUpperChar.IsMatch(txtPass_new.Text))
                {
                    lttMsg.Text = "Mật khẩu phải có tối thiểu 01 ký tự in hoa!";
                    return;
                }
                else if (OQUANTRI_MATKHAU_ANPHI.CO_SO == 1 && !hasNumber.IsMatch(txtPass_new.Text))
                {
                    lttMsg.Text = "Mật khẩu phải có tối thiểu 01 ký tự số!";
                    return;
                }
                else if (OQUANTRI_MATKHAU_ANPHI.CO_KY_TU_DAC_BIET == 1 && !hasSymbols.IsMatch(txtPass_new.Text))
                {
                    lttMsg.Text = "Mật khẩu phải có tối thiểu 01 ký tự đặc biệt!";
                    return;
                }
                if (OQUANTRI_MATKHAU_ANPHI.CHUA_TEN_TAI_KHOAN == 1 && (txtPass_new.Text.ToLower()).Contains(txtUserName.Text.ToLower()))
                {
                    lttMsg.Text += "Mật khẩu không được chứa tên tài khoản !";
                    return;
                }
                //var OCanBo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                //if (OCanBo == null)
                //{
                //    lttMsg.Text += "Tài khoản đang không gắn với người sử dụng. Vui lòng liên hệ Quản trị viên để được hỗ trợ !";
                //    return;
                //}
                if (!string.IsNullOrEmpty(oT.DIENTHOAI))
                {
                    var strSODIENTHOAI = oT.DIENTHOAI.Replace(" ", "");
                    if (OQUANTRI_MATKHAU_ANPHI.CHUA_SDT == 1 && txtPass_new.Text.Contains(strSODIENTHOAI))
                    {
                        lttMsg.Text = "Mật khẩu không được chứa số điện thoại !";
                        return;
                    }
                }
                //if (OQUANTRI_MATKHAU_ANPHI.CHUA_NAMSINH == 1 && OCanBo.NGAYSINH != null)
                //{
                //    var StrNgaySinh = OCanBo.NGAYSINH.Value.ToString("ddMMyyyy");
                //    var StrNgaySinh2 = OCanBo.NGAYSINH.Value.ToString("ddMMyy");
                //    if (txtPass_new.Text.Contains(StrNgaySinh) || txtPass_new.Text.Contains(StrNgaySinh2))
                //    {
                //        lttMsg.Text = "Mật khẩu không được chứa ngày/tháng/năm sinh !";
                //        return;
                //    }
                //}
                //var hoten = OCanBo.HOTEN.Split(' ').ToArray();
                //var str = ConvertToUnSign(hoten[hoten.Count() - 1]);
                //var strlower = str.ToLower();
                //if (OQUANTRI_MATKHAU_ANPHI.CHUA_TEN_NGUOISD == 1 && (txtPass_new.Text.Contains(str) || txtPass_new.Text.Contains(strlower)))
                //{
                //    lttMsg.Text += "Mật khẩu không được chứa tên người sử dụng!";
                //    return;
                //}
            }
            #endregion
            var checkvalidateTK = DataExtensions.FindById<VALIDATE_TAIKHOAN_ANPHI>(current_id);
            if (checkvalidateTK != null)
            {
                checkvalidateTK.NGAY_THAY_DOI_MK = DateTime.Now;
                checkvalidateTK.MATKHAU_OLD = oT.PASSWORD;
                checkvalidateTK.NGUOI_DOI_MK = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                DataExtensions.Update<VALIDATE_TAIKHOAN_ANPHI>(checkvalidateTK);
            }
            else
            {
                var OBL = new VALIDATE_TAIKHOAN_ANPHI_BL();
                checkvalidateTK = new VALIDATE_TAIKHOAN_ANPHI();
                checkvalidateTK.ID = current_id;
                checkvalidateTK.NGAY_THAY_DOI_MK = DateTime.Now;
                checkvalidateTK.MATKHAU_OLD = oT.PASSWORD;
                checkvalidateTK.NGUOI_DOI_MK = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                //DataExtensions.Insert<VALIDATE_TAIKHOAN>(checkvalidateTK);
                OBL.VALIDATE_TAIKHOAN_ANPHI_INSERT(checkvalidateTK);
            }

            oT.PASSWORD = Cls_Comon.MD5Encrypt(txtPass_new.Text);
            oT.NGAYSUA = DateTime.Now;
            oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            dt.SaveChanges();
            lttMsg.Text = "Đổi mật khẩu thành công !";
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