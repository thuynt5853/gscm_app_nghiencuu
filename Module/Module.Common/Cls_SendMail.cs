using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;


namespace Module.Common
{
    public static class Cls_SendMail
    {
        //Reset mật khẩu

        public static string TenHeThong = "Phần mêm gửi, nhận đơn khởi kiện, tài liệu, chứng cứ và cấp, tống đạt, thông báo văn bản tố tụng";

        public static void SendResetMatKhau(string toEmail, string strTenNguoiDung, string strTaiKhoan, string strMatkhau)
        {
            GSTPContext dt = new GSTPContext();
            try
            {
                List<DM_TRANGTINH> lst = dt.DM_TRANGTINH.Where(x => x.MATRANG == "Guimailresetmatkhau").ToList<DM_TRANGTINH>();

                string strFooterEmail = "";
                if (lst.Count > 0) strFooterEmail = lst[0].NOIDUNG + "";
                strFooterEmail = strFooterEmail.Replace("\r", "");
                strFooterEmail = strFooterEmail.Replace("\n", "");
                strFooterEmail = strFooterEmail.Replace("\t", "");

                string strSubject = "";// "Mật khẩu khởi tạo lại trên Phần mềm gửi, nhận đơn khởi kiện, tài liệu, chứng cứ và cấp, tống đạt, thông báo văn bản tố tụng";
                strSubject = "Khởi tạo mật khẩu '" + TenHeThong + "'";
                string strContent = "<p style=\"text-align: center;\"><span style=\"font-size:18px;\"><strong>KHỞI TẠO MẬT KHẨU TÀI KHOẢN TRÊN PHẦN MỀM GỬI, NHẬN ĐƠN KHỞI KIỆN, TÀI LIỆU, CHỨNG CỨ VÀ CẤP, TỐNG ĐẠT, THÔNG BÁO VĂN BẢN TỐ TỤNG</strong></span></p>";
                strContent += "Kính gửi Ông/Bà : <strong>" + strTenNguoiDung + "</strong>,<br /><br />";
                strContent += "Như Ông/Bà đã yêu cầu, mật khẩu đã được thiết lập lại.<br />";
                strContent += "Chi tiết như sau:<br /><br />";
                strContent += "Tên tài khoản: " + strTaiKhoan + "<br />";
                strContent += "Mật khẩu: " + strMatkhau + "<br /><br />";
                strContent += strFooterEmail;

                Cls_Comon.SendEmail(toEmail, strSubject, strContent);
            }
            catch (Exception ex)
            {
            }
        }
               
        public static void SendDangKyTK(string toEmail, string strTenNguoiDung
                                        , string strTaiKhoan, string strMatkhau)
        {
            GSTPContext dt = new GSTPContext();
            try
            {
                List<DM_TRANGTINH> lst = dt.DM_TRANGTINH.Where(x => x.MATRANG == "GuimaildangkyTK").ToList<DM_TRANGTINH>();

                string strFooterEmail = "";
                if (lst.Count > 0) strFooterEmail = lst[0].NOIDUNG + "";
                strFooterEmail = strFooterEmail.Replace("\r", "");
                strFooterEmail = strFooterEmail.Replace("\n", "");
                strFooterEmail = strFooterEmail.Replace("\t", "");

                string strSubject = "Thông báo tạo Tài khoản tại '" + TenHeThong + "'";
                string strContent = "<p style=\"text-align: center;\"><span style=\"font-size:18px;\"><strong>THÔNG BÁO TÀI KHOẢN ĐÃ ĐƯỢC TẠO THÀNH CÔNG TẠI PHẦN MỀM GỬI, NHẬN ĐƠN KHỞI KIỆN, TÀI LIỆU, CHỨNG CỨ VÀ CẤP, TỐNG ĐẠT, THÔNG BÁO VĂN BẢN TỐ TỤNG</strong></span></p>";
                strContent += "Kính gửi Ông/Bà : <strong>" + strTenNguoiDung + "</strong>,<br /><br />";
                strContent += "Tài khoản của bạn đã được tạo thành công.<br /><br />";
                strContent += "Tên tài khoản: " + strTaiKhoan + "<br />";
                strContent += "Mật khẩu: " + strMatkhau + "<br /><br />";
                strContent += strFooterEmail;

                Cls_Comon.SendEmail(toEmail, strSubject, strContent);
            }
            catch (Exception ex)
            {
            }
        }
    }
}