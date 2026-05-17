using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.GSTP.Danhmuc;
using BL.DonKK.DanhMuc;
using Module.Common;
using DAL.GSTP;


namespace WEB.DONKHOIKIEN
{
    public partial class ThongBao : System.Web.UI.Page
    {
        GSTPContext gsdt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadData(); 
        }
        void LoadData()
        {
            DKKContextContainer dt = new DKKContextContainer();
            Decimal taikhoan_id = 0;
            DONKK_USERS obj = null;
            String ma_thongbao = (String.IsNullOrEmpty(Request["code"]+""))?"":Request["code"].ToString();
            if (ma_thongbao != "")
            {
                switch(ma_thongbao)
                {
                    case "regacc":
                        LoadThongTinTinhTheoMa(ma_thongbao);
                        ////---------gui mail chưa chuoi active code----------
                        //taikhoan_id = (String.IsNullOrEmpty(Request["uID"] + "")) ? 0 : Convert.ToDecimal(Request["uID"].ToString());
                        //obj = dt.DONKK_USERS.Where(x => x.ID == taikhoan_id).Single<DONKK_USERS>();
                        //if (obj != null)
                        //    Module.Common.Cls_SendMail.SendDangKyTK(obj.EMAIL, obj.NDD_HOTEN, obj.EMAIL, obj.PASSWORD);
                        break;
                    case "error":
                        LoadThongTinTinhTheoMa(ma_thongbao);
                        break;
                    case "resendpass":
                        taikhoan_id = (String.IsNullOrEmpty(Request["uID"] + "")) ? 0 : Convert.ToDecimal(Request["uID"].ToString());
                        //obj = dt.DONKK_USERS.Where(x => x.ID == taikhoan_id).Single<DONKK_USERS>();
                        //if (obj != null)
                        //{
                        //    String new_pass = Cls_Comon.Randomnumber();
                        //    obj.PASSWORD = Cls_Comon.MD5Encrypt(new_pass);
                        //    obj.PASSWORDMODIFIEDDATE = DateTime.Now;
                        //    dt.SaveChanges();

                        //    Module.Common.Cls_SendMail.SendResetMatKhau(obj.EMAIL, obj.NDD_HOTEN, obj.EMAIL, new_pass);
                        //}
                        break;
                    case "guidonkk_email":
                        LoadThongTinTinhTheoMa(ma_thongbao);
                        break;
                    case "guidonkk_noemail":
                        LoadThongTinTinhTheoMa(ma_thongbao);
                        break;
                }
            }
        }
        void LoadThongTinTinhTheoMa(string MaThongBao)
        {
            DM_TRANGTINH_BL obj = new DM_TRANGTINH_BL();
            String NoiDung = obj.GetNoiDungByMaTrang(MaThongBao);
            if (!String.IsNullOrEmpty(NoiDung))
                ltt.Text = NoiDung;
        }

        //void ReSendPass(string ma_trang_tinh, DONKK_USERS obj)
        //{
        //    List<DM_TRANGTINH> lst = gsdt.DM_TRANGTINH.Where(x => x.MATRANG == ma_trang_tinh).ToList<DM_TRANGTINH>();

        //    string strFooterEmail = "";
        //    if (lst.Count > 0) strFooterEmail = lst[0].NOIDUNG + "";
        //    strFooterEmail = strFooterEmail.Replace("\r", "");
        //    strFooterEmail = strFooterEmail.Replace("\n", "");
        //    strFooterEmail = strFooterEmail.Replace("\t", "");

        //    string strTenNguoiDung = obj.NDD_HOTEN;
        //    string strTaiKhoan = obj.EMAIL;
        //    String strMatkhau = "";// Cls_Comon.M
            
        //    string strSubject = "";// "Mật khẩu khởi tạo lại trên Phần mềm gửi, nhận đơn khởi kiện, tài liệu, chứng cứ và cấp, tống đạt, thông báo văn bản tố tụng";
        //    strSubject = "Gửi lại mật khẩu người dùng'";
        //    string strContent = "<p style=\"text-align: center;\"><span style=\"font-size:18px;\"><strong>KHỞI TẠO MẬT KHẨU TÀI KHOẢN TRÊN PHẦN MỀM GỬI, NHẬN ĐƠN KHỞI KIỆN, TÀI LIỆU, CHỨNG CỨ VÀ CẤP, TỐNG ĐẠT, THÔNG BÁO VĂN BẢN TỐ TỤNG</strong></span></p>";
        //    strContent += "Kính gửi Ông/Bà : <strong>" + strTenNguoiDung + "</strong>,<br /><br />";
        //    strContent += "Như bạn đã yêu cầu, mật khẩu đã được thiết lập lại.<br />";
        //    strContent += "Chi tiết như sau:<br /><br />";
        //    strContent += "Tên tài khoản: " + strTaiKhoan + "<br />";
        //    strContent += "Mật khẩu: " + strMatkhau + "<br /><br />";
        //    strContent += strFooterEmail;

        //    Cls_Comon.SendEmail(strTaiKhoan, strSubject, strContent);
        //}
    }
}
