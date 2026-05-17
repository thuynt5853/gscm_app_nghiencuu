using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using BL.DonKK;
using WEB.DONKHOIKIEN.DichVuCong;

namespace WEB.DONKHOIKIEN.UserControl
{
    public partial class Header : System.Web.UI.UserControl
    {
        DKKContextContainer dt = new DKKContextContainer();
        public Decimal UserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                lttUserName.Text = "Tài khoản: " + Session[ENUM_SESSION.SESSION_USERTEN] + "";
                pnUserInfo.Visible = true;
                pnLogin.Visible = false;
            }
            else
            {
                pnUserInfo.Visible = false;
                string CurrPage = HttpContext.Current.Request.Url.PathAndQuery.ToLower();
                if ((!CurrPage.Contains("trangchu.aspx")) && (!CurrPage.Contains("login.aspx")) && (!CurrPage.Contains("DangKy.aspx")) && (!CurrPage.Contains("DangKyTK.aspx")))
                    pnLogin.Visible = true;
            }
            LoadMenu();
        }

        void LoadMenu()
        {
            String mn_guidk = "<li><a href ='/Personnal/GuiDonKien.aspx' class='menu_link" + CheckMenuActive("guidonkien.aspx") + "'>Soạn đơn khởi kiện</a></li>";
            string mn_dknhanvb = "<li><a href ='/Personnal/DangKyNhanVB.aspx' class='menu_link" + CheckMenuActive("DangKyNhanVB.aspx") + "'>Đăng ký nhận VB/TB của vụ việc khác</a></li>";

            //------------------------
            String Menu = "";
            if (UserID > 0)
            {
                int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");

                Menu += "<li><a class='menu_link" + CheckMenuActive("PersonalIndex.aspx") + "' href='/Personnal/PersonalIndex.aspx'>trang chủ</a></li>";
                //Menu += "<li><a href = 'https://vbpq.toaan.gov.vn/webcenter/portal/htvb/home?loaiVanBan=51' class='menu_link'>Nghị quyết HĐTP</a></li>";

                //--------------------------
                //string CurrPage = HttpContext.Current.Request.Url.PathAndQuery.ToLower();               
                if (MucDichSD != 2)
                    Menu += mn_guidk;
                //------------------------------

                DONKK_USERS checkStatus = dt.DONKK_USERS.Where(x => x.ID == UserID).FirstOrDefault();
                if (checkStatus.STATUS != 3)
                {
                    Menu += "<li><a href ='/Personnal/DsDangKyNhanVBTongDat.aspx' class='menu_link" + CheckMenuActive("DsDangKyNhanVBTongDat.aspx") + "'>Danh sách vụ việc</a></li>";
                    Menu += mn_dknhanvb;

                    pnNgungGiaoDich.Visible = true;
                    pnNgungGiaoDich.CssClass = "cssPnGiaoDich";

                    pnDKGiaoDich.Visible = false;
                    pnDKGiaoDich.CssClass = "";
                }
                else
                {
                    pnDKGiaoDich.Visible = true;
                    pnDKGiaoDich.CssClass = "cssPnGiaoDich";

                    pnNgungGiaoDich.Visible = false;
                    pnNgungGiaoDich.CssClass = "";
                    lkDKGiaoDich.Visible = true;
                }

                //<a href="/Personnal/VBTongDat.aspx?status=0" class="color_black">Văn bản, thông báo mới của Tòa án</a>
                Menu += "<li><a href = '/Personnal/VBTongDat.aspx?status=0' class='menu_link" + CheckMenuActive("VBTongDat.aspx?status=0") + "'>Văn bản tống đạt mới</a></li>";
                Menu += "<li><a href = '/DStin.aspx?cID=5' class='menu_link" + CheckMenuActive("DStin.aspx?cID=5") + "'>Hướng dẫn</a></li>";
            }
            else
            {
                Menu += "<li><a class='menu_link" + CheckMenuActive("trangchu.aspx") + "' href='/trangchu.aspx'>trang chủ</a></li>";
                Menu += "<li><a href = 'https://vbpq.toaan.gov.vn/webcenter/portal/htvb/home?loaiVanBan=51' class='menu_link'>Nghị quyết HĐTP</a></li>";

                if (hddIsShowTraCuu.Value == "1")
                    Menu += "<li><a href = '/TraCuu.aspx' class='menu_link" + CheckMenuActive("tracuu.aspx") + "'>Tra cứu</a></li>";
                Menu += "<li><a href = '/DStin.aspx?cID=5' class='menu_link" + CheckMenuActive("DStin.aspx?cID=5") + "'>Hướng dẫn</a></li>";
                Menu += "<li><a href = '/DStin.aspx?cID=2' class='menu_link" + CheckMenuActive("DStin.aspx?cID=2") + "'>Thông báo</a></li>";
            }
            //---------------------------------
            Menu += "<li><a href = '/LienHe.aspx' class='menu_link" + CheckMenuActive("lienhe.aspx") + "'>liên hệ</a></li>";

            lttMenu.Text = Menu;
        }

        private void NgungGiaoDich()
        {
            decimal IdUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            List<DONKK_USER_DKNHANVB> listVB = dt.DONKK_USER_DKNHANVB.Where(x => x.USERID == IdUser).ToList();
            foreach (var item in listVB)
            {
                item.TRANGTHAI = 2;
            }
            dt.SaveChanges();
        }

        string CheckMenuActive(string pagename)
        {
            string active_menu = "";
            string CurrPage = HttpContext.Current.Request.Url.PathAndQuery.ToLower();
            if (CurrPage.Contains(pagename.ToLower()))
                active_menu = " menu_active";
            else active_menu = "";
            return active_menu;
        }

        protected void lkSigout_Click(object sender, EventArgs e)
        {
            DONKK_USER_HISTORY_BL objLogBL = new DONKK_USER_HISTORY_BL();
            objLogBL.WriteLog(UserID, ENUM_HD_NGUOIDUNG_DKK.DANGXUAT, Session[ENUM_SESSION.SESSION_USERTEN].ToString() + " - Đăng xuất thành công");

            Session[ENUM_SESSION.SESSION_USERID] = "";
            Session[ENUM_SESSION.SESSION_USERNAME] = "";

            //Session[ENUM_SESSION.SESSION_DONVIID] = obj.DONVIID;
            Session[ENUM_SESSION.SESSION_LOAIUSER] = "";
            Session[ENUM_SESSION.SESSION_USERTEN] = "";
            Session[ENUM_SESSION.SESSION_TINH_ID] = "";
            Session[ENUM_SESSION.SESSION_QUAN_ID] = "";
            Session[ENUM_SESSION.SESSION_MUCDICHSD] = "";
            if (Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO] != null)
            {
                var userInfo = (UserInforOutput)Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO];

                //goi logout tren he thong DVCQG
                //var objbapi = new CallApi(global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrl"]);
                //var inputModel = new revokeModel()
                //{
                //    client_id = global::System.Configuration.ConfigurationManager.AppSettings["DVCApiClientId"],
                //    client_secret = global::System.Configuration.ConfigurationManager.AppSettings["DVCApiClientSecret"],
                //    token= userInfo.access_token
                //};
                //xoa access token
                //objbapi.PostObjectRestApi<string>(DVCMethod.revoke, inputModel);
                Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO] = null;
                var objbapi = new CallApi(global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrl"]);
                var inputModel = new logoutModel()
                {
                    id_token_hint = userInfo.id_token,
                    post_logout_redirect_uri = global::System.Configuration.ConfigurationManager.AppSettings["DVCCallBackPage"]

                };

                //objbapi.GetObjectRestApi<string>(string.Format("{0}?id_token_hint={1}&post_logout_redirect_uri={2}", global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrlLogout"]
                //, inputModel.id_token_hint,inputModel.post_logout_redirect_uri));
                Response.Redirect(string.Format("{0}?id_token_hint={1}&post_logout_redirect_uri={2}", global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrlLogout"]
                    , inputModel.id_token_hint, inputModel.post_logout_redirect_uri));
            }
            else
                Response.Redirect("/Trangchu.aspx");
        }

        protected void lkNgungGiaoDich_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertMessage", "alert('Bạn có chắc muốn ngừng giao dịch điện tử?')", true);

            NgungGiaoDich();

            //Chuyển trạng thái của tài khoản ngừng giao dịch để ẩn 2 tab danh sách vụ việc và đăng ký vb tống đạt
            DONKK_USERS changeStatus = dt.DONKK_USERS.Where(x => x.ID == UserID).FirstOrDefault();
            changeStatus.STATUS = 3;
            dt.SaveChanges();

            LoadMenu();

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Đăng ký ngừng nhận văn bản, thông báo từ Tòa án này thành công!')", true);
        }

        protected void lkDKGiaoDich_Click(object sender, EventArgs e)
        {
            //Hiển thị popup
            string link = "/UserControl/Popup/pDKGiaoDichDienTu.aspx";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(950/2); var Mtop = (screen.height/2)-(750/2); javascript:window.open('" + link + "', '_blank', 'height=750px,width=950px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
        }
    }
}