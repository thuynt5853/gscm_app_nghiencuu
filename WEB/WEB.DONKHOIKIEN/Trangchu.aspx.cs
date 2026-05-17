using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK.DanhMuc;
using Module.Common;
using WEB.DONKHOIKIEN.DichVuCong;
using DAL.GSTP;
using System.Globalization;
using BL.DonKK;
using BL.GSTP;

namespace WEB.DONKHOIKIEN
{
    public partial class Trangchu : System.Web.UI.Page
    {
        public Decimal UserID = 0;
        public String UrlCall = null;
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        //manhnd khong xac thuc qua DVC Quoc Gia
        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
        //    if (UserID > 0)
        //    {
        //        int MucDichSD = Convert.ToInt32(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
        //        DONKK_USERS_BL objUserBL = new DONKK_USERS_BL();
        //        Boolean TinhTrangSD = objUserBL.CheckIsUse(UserID, MucDichSD);
        //        switch (MucDichSD)
        //        {
        //            case 1:
        //                if (TinhTrangSD)
        //                    Response.Redirect("/Personnal/PersonalIndex.aspx");
        //                else
        //                    Response.Redirect("/Personnal/GuiDonKien.aspx");
        //                break;
        //            case 2:
        //                if (TinhTrangSD)
        //                    Response.Redirect("/Personnal/PersonalIndex.aspx");
        //                else
        //                    Response.Redirect("/Personnal/DangKyNhanVB.aspx");
        //                break;
        //        }
        //    }
        //}

        //Xac thuc toi DVC Quoc Gia
        protected async void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");



            //Neu URL khong phai la DVC thi cho phep login tu nopdonkhoikien.toaan.gov.vn
            //if (!string.IsNullOrEmpty(UrlCall) && UrlCall.Contains("nopdonkhoikien.toaan.gov.vn"))
            //Kiem tra URL goi là tu DVC 
            //if (!string.IsNullOrEmpty(Request.QueryString["code"]))
            UrlCall = HttpContext.Current.Request.Url.AbsoluteUri;
            if (!UrlCall.Contains("code") && !UrlCall.Contains("MaTTHCDP"))
            {
                Response.Redirect("/Login.aspx", false);
            }
            else
            {
                //Lay mã DVC để phân biệt Gửi Don khoi kien và Nhan VB Tong Dat
                if (!string.IsNullOrEmpty(Request.QueryString["MaDVC"]))
                {
                    string MaDVC = Request.QueryString["MaDVC"].Trim();
                    if (MaDVC == "3.000163.01")
                        Session[ENUM_SESSION.SESSION_MUCDICHSD] = "1";
                    else
                        Session[ENUM_SESSION.SESSION_MUCDICHSD] = "2";
                }

                if (UserID == 0)
                {
                    //neu chua co UserID thi phai kiem tra xem co request tu DVC 
                    if (string.IsNullOrEmpty(Request.QueryString["code"]))
                    {
                        //nhay toi trang DVCQG de login
                        string _urldvc = string.Format("{0}{1}?response_type=code&client_id={2}&redirect_uri={3}&scope=openid&acr_values=LoA1"
                            , global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrl"]
                            , DVCMethod.authorize
                            , global::System.Configuration.ConfigurationManager.AppSettings["DVCApiClientId"]
                            , global::System.Configuration.ConfigurationManager.AppSettings["DVCCallBackPage"]);
                        this.Response.Redirect(_urldvc, false);
                        HttpContext.Current.ApplicationInstance.CompleteRequest();

                        return;

                    }
                    string _code = Request.QueryString["code"].Trim();


                    var objbapi = new CallApi(global::System.Configuration.ConfigurationManager.AppSettings["DVCApiUrl"]);
                    var inputModel = new tokenModel()
                    {
                        client_id = global::System.Configuration.ConfigurationManager.AppSettings["DVCApiClientId"],
                        client_secret = global::System.Configuration.ConfigurationManager.AppSettings["DVCApiClientSecret"],
                        grant_type = "authorization_code",
                        code = _code,
                        redirect_uri = global::System.Configuration.ConfigurationManager.AppSettings["DVCCallBackPage"]
                    };
                    //lay access token
                    var objAccessToken = objbapi.PostObjectRestApi<TokenOutput>(DVCMethod.token, inputModel);
                    if (objAccessToken != null)
                    {

                        //lay thong tin user info
                        var userInput = new UserInforModel();
                        userInput.access_token = objAccessToken.access_token;
                        var userInfo = objbapi.PostObjectRestApi<UserInforOutput>(DVCMethod.userinfo, userInput, objAccessToken.access_token);
                        //Kiem tra user

                        if (userInfo != null)
                        {
                            //luu thong tin user infor vao session
                            userInfo.id_token = objAccessToken.id_token;
                            Session[ENUM_SESSION.SESSION_DVCQG_USER_INFO] = userInfo;

                            //kiem tra user da ton tai thi get user de set UserID
                            //, neu chua ton tai thi nhay toi trang dang ky de thuc hien viec hoan thien thong tin
                            //, giong nhu dang ky tai khoan binh thuong (chi khac la khong nhap mat khau)
                            //lay CMT or CCCD de kiem tra thong tin ton tai
                            string _cmt = userInfo.SoCMND;
                            if (!string.IsNullOrEmpty(userInfo.SoDinhDanh))
                            {
                                _cmt = userInfo.SoDinhDanh;
                            }
                            //cmt phai co du lieu thi moi so sanh
                            if (!string.IsNullOrEmpty(_cmt))
                            {
                                DONKK_USERS userDKK;
                                try
                                {
                                    userDKK = dt.DONKK_USERS.FirstOrDefault(c => c.NDD_CMND == _cmt);
                                }
                                catch { userDKK = null; }
                                if (userDKK != null)
                                {
                                    //co ton tai user
                                    //kiem tra user co day du thong tin ko, neu ko du phai vao phan hoan thien ho so
                                    if (string.IsNullOrEmpty(userDKK.EMAIL)
                                        || string.IsNullOrEmpty(userDKK.NDD_NOICAP)

                                        || string.IsNullOrEmpty(userDKK.DIACHI_CHITIET)
                                        )
                                        Login(userDKK, "/Personnal/TaikhoanInfo.aspx?code=" + Request.QueryString["code"]);
                                    //Login(userDKK, "/Personnal/PersonalIndex.aspx?code=" + Request.QueryString["code"]);


                                    else
                                        Login(userDKK);
                                }
                                else
                                {
                                    //Khi chưa co tài khoản thì nhẩy đến trang để đăng ký tài khoản
                                    string vMucDicSD;
                                    try
                                    {
                                        vMucDicSD = Session[ENUM_SESSION.SESSION_MUCDICHSD].ToString();
                                    }
                                    catch { vMucDicSD = "1"; }
                                    if (vMucDicSD == "2")
                                        Response.Redirect("/DangKy.aspx?code=" + _code, false);
                                    else
                                        Response.Redirect("/DangKyTK.aspx?code=" + _code, false);
                                    //Login(userDKK, "/DangKy.aspx?code=" + Request.QueryString["code"]);
                                    ////tao user de lay id
                                    //TaoTaiKhoan(userInfo);
                                    ////neu ko ton tai

                                    ////nhay toi trang dang ky theo code
                                    //Response.Redirect("/Personnal/TaikhoanInfo.aspx?code=" + _code, false);
                                    //HttpContext.Current.ApplicationInstance.CompleteRequest();
                                }
                            }


                        }
                        else
                        {
                            //co loi ko lay dc user, thi ko lam gi ca
                        }
                    }

                }
                else
                if (UserID > 0)
                {
                    int MucDichSD = Convert.ToInt32(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
                    DONKK_USERS_BL objUserBL = new DONKK_USERS_BL();
                    Boolean TinhTrangSD = objUserBL.CheckIsUse(UserID, MucDichSD);
                    switch (MucDichSD)
                    {
                        case 1:
                            {
                                if (TinhTrangSD)
                                    Response.Redirect("/Personnal/PersonalIndex.aspx", false);
                                else
                                    Response.Redirect("/Personnal/GuiDonKien.aspx", false);

                                break;
                            }


                        case 2:
                            {
                                if (TinhTrangSD)
                                    Response.Redirect("/Personnal/PersonalIndex.aspx", false);
                                else
                                    Response.Redirect("/Personnal/DangKyNhanVB.aspx", false);
                                break;
                            }

                    }
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
            }
        }

        void Login(DONKK_USERS row, string UrlPage = "/Personnal/GuiDonKien.aspx")
        {
            UserID = row.ID;
            Session[ENUM_SESSION.SESSION_USERID] = UserID;
            Session[ENUM_SESSION.SESSION_USERNAME] = row.EMAIL;

            //Session[ENUM_SESSION.SESSION_DONVIID] = obj.DONVIID;
            Session[ENUM_SESSION.SESSION_TINH_ID] = row.DIACHI_TINH_ID;
            Session[ENUM_SESSION.SESSION_QUAN_ID] = row.DIACHI_HUYEN_ID;
            Session[ENUM_SESSION.SESSION_LOAIUSER] = row.USERTYPE;
            Session[ENUM_SESSION.SESSION_MUCDICHSD] = row.MUCDICH_SD;
            string temp = (string.IsNullOrEmpty(row.NDD_HOTEN)) ? row.EMAIL : row.NDD_HOTEN;
            int user_type = Convert.ToInt16(row.USERTYPE);
            if (user_type == 1)
                Session[ENUM_SESSION.SESSION_USERTEN] = temp;
            else
                Session[ENUM_SESSION.SESSION_USERTEN] = (string.IsNullOrEmpty(row.DN_TENVN)) ? temp : row.DN_TENVN;



            DONKK_USER_HISTORY_BL objLogBL = new DONKK_USER_HISTORY_BL();
            objLogBL.WriteLog(UserID, ENUM_HD_NGUOIDUNG_DKK.DANGNHAP, Session[ENUM_SESSION.SESSION_USERTEN].ToString() + " - Đăng nhập thành công");

            //------------------------
            //int MucDichSD = Convert.ToInt32(row.MUCDICH_SD);
            //DONKK_USERS_BL objUserBL = new DONKK_USERS_BL();
            //Boolean TinhTrangSD = objUserBL.CheckIsUse(UserID, MucDichSD);
            //switch (MucDichSD)
            //{
            //    case 1:
            //        if (TinhTrangSD)
            //            Response.Redirect("/Personnal/PersonalIndex.aspx", false);
            //        else
            //            Response.Redirect("/Personnal/GuiDonKien.aspx", false);
            //        break;
            //    case 2:
            //        if (TinhTrangSD)
            //            Response.Redirect("/Personnal/PersonalIndex.aspx", false);
            //        else
            //            Response.Redirect("/Personnal/DangKyNhanVB.aspx", false);
            //        break;
            //}
            //luon nhay toi trang gui don kien luc co y/c tu DVCQG
            Response.Redirect(UrlPage, false);
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
        void TaoTaiKhoan(UserInforOutput item)
        {
            DONKK_USERS obj = new DONKK_USERS();
            int CurrID = 0;
            obj.USERTYPE = 1;//ca nhan, tam thoi cac user tu DVC truyen ve dang la ca nhan cua nguoi dan
            obj.TUCACHTT = "NGUYENDON";
            obj.IS_DUOC_UYQUYEN = 0;
            obj.EMAIL = item.ThuDienTu;
            obj.MUCDICH_SD = 1;//bo qua chung thuc so
            obj.PASSWORD = Cls_Comon.MD5Encrypt(Guid.NewGuid().ToString());

            obj.NDD_HOTEN = Cls_Comon.FormatTenRieng(item.HoVaTen);
            try
            {
                DateTime _ngaysinh;
                if (DateTime.TryParseExact(item.NgayThangNamSinh, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out _ngaysinh))
                {
                    obj.NDD_NGAYSINH = _ngaysinh;
                    obj.NDD_NAMSINH = _ngaysinh.Year;
                }
            }
            catch { }

            obj.NDD_QUOCTICH = new DM_DATAITEM_BL().GetQuocTichID_VN();//viet nam
            //-----------------------------------
            obj.NDD_GIOITINH = 1;

            //-----------------------------------
            string _cmt = item.SoCMND;
            if (!string.IsNullOrEmpty(item.SoDinhDanh))
            {
                _cmt = item.SoDinhDanh;
            }
            obj.NDD_CMND = _cmt;

            //---------------------------
            obj.TELEPHONE = item.SoDienThoai;
            obj.MOBILE = item.SoDienThoai;

            obj.STATUS = 2;//cho phep su dung luon            
            obj.DONVICAPCTSO = "DVCQG";

            if (CurrID == 0)
            {
                obj.ACTIVATIONCODE = Guid.NewGuid().ToString();
                obj.CREATEDATE = DateTime.Now;
                obj.MODIFIEDDATE = DateTime.Now;
                dt.DONKK_USERS.Add(obj);
            }
            else
                obj.MODIFIEDDATE = DateTime.Now;
            dt.SaveChanges();
            Login(obj, "/Personnal/TaikhoanInfo.aspx?code=" + Request.QueryString["code"]);
        }
    }
}