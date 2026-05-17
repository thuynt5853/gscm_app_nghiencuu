using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;
using Module.Common;
using System.Globalization;
using System.Data;

namespace WEB.DONKHOIKIEN.Personnal.UC
{
    public partial class DKNhanVB : System.Web.UI.UserControl
    {
        DKKContextContainer dt = new DKKContextContainer();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
                pn.Visible = true;
            else pn.Visible = false;                

            String mn_dkvb = "<a href='/Personnal/DangKyNhanVB.aspx'>Đăng ký nhận văn bản, thông báo của vụ việc khác</a>";
            string mn_dkk = "<a href='/Personnal/GuiDonKien.aspx' class='padding_top'>Soạn đơn khởi kiện</a>";
            
            //TK chi nhan vb tong dat co MucDichSD=2
            int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
            string CurrPage = HttpContext.Current.Request.Url.PathAndQuery.ToLower();
            
            string MenuTrai = "";
            string pagename = "PersonalIndex.aspx".ToLower();
            //ko o trang chu
            if (!CurrPage.Contains(pagename))
            {
                //ko o trang dangkynhanvb
                pagename = "DangKyNhanVB.aspx".ToLower();
                if (!CurrPage.Contains(pagename))
                    MenuTrai += "<li>" + mn_dkvb + "</li>";

                //ko o trang guidonkien
                pagename = "GuiDonKien.aspx".ToLower();
                if (!CurrPage.Contains(pagename))
                {                    
                    if (MucDichSD != 2)
                        MenuTrai += "<li>" + mn_dkk + "</li>";
                }
            }
            else
            {
                MenuTrai += "<li>"+ mn_dkvb+"</li>";
                if (MucDichSD != 2)
                    MenuTrai += "<li>" + mn_dkk + "</li>";
            }
            ltt.Text = (String.IsNullOrEmpty(MenuTrai+""))? "": ("<ul class='banner_left'>"+ MenuTrai+ " </ul>");
           
        }
    }
}