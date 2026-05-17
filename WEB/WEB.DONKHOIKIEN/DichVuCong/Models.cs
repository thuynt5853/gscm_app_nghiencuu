using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.DONKHOIKIEN.DichVuCong
{
    public class dvcBaseModel
    {
        public string client_id { get; set; }
        public string client_secret { get; set; }
    }
    public class introspectModel
    {
        public long nbf { get; set; }
        public string scope { get; set; }
        public bool active { get; set; }
        public string token_type { get; set; }
        public long exp { get; set; }
        public long iat { get; set; }
        public string client_id { get; set; }
        public string username { get; set; }


    }
    public class tokenModel:dvcBaseModel
    {
        public string grant_type { get; set; }
        public string code { get; set; }
        public string redirect_uri { get; set; }
    }
    public class TokenOutput
    {
        public string access_token { get; set; }
        public string refresh_token { get; set; }
        public string scope { get; set; }
        public string id_token { get; set; }
        public string token_type { get; set; }
        public string expires_in { get; set; }
    }
    public class UserInforModel
    {
        public UserInforModel()
        {
            scope = "phone";
        }
        public string access_token { get; set; }
        public string scope { get; set; }
    }
    public class UserInforOutput
    {
        public string sub { get; set; }
        public string SoCMND { get; set; }
        public string SoDinhDanh { get; set; }
        public string TechID { get; set; }
        public string LoaiTaiKhoan { get; set; }
        public string loAs { get; set; }
        public string HoVaTen { get; set; }
        public string ThuDienTu { get; set; }
        public string SoDienThoai { get; set; }
        /// <summary>
        /// Co dinh dang yyyyMMdd
        /// </summary>
        public string NgayThangNamSinh { get; set; }
        public string id_token { get; set; }
    }
    public class revokeModel:dvcBaseModel
    {
        public revokeModel()
        {
            token_type_hint = "access_token";
        }
        public string token { get; set; }
        public string token_type_hint { get; set; }
    }
    public class logoutModel
    {
        public string id_token_hint { get; set; }
        public string post_logout_redirect_uri { get; set; }
    }
}