using BL.THONGKE;
using BL.THONGKE.Info;
using BL.THONGKE.Manager;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.ThongKe
{
    public class ConvertSessions
    {
        /// <summary>
        /// CONVERT SESSION TỪ CHƯƠNG TRÌNH GSTP SANG GSTK
        /// </summary>
        /// <returns></returns>
        public Boolean convertSession2()
        {
            /**
             * XỬ LÝ SESSION ĐĂNG NHẬP
             * 
             */

            //M_Users cUsers = new M_Users();
            //Users ousers = new Users();
            //ousers = cUsers.Get_Users_Login(UserName.Text.Trim().ToLower(), Password.Text.Trim());
            //Session.Add("Sesion_Manager_ID", ousers.USERNAME.ToLower() + ";" + ousers.TYPE + ";" + ousers.ID_COURT + ";" + ousers.COURT_NAME + ";" + ousers.USER_TYPE);
            //session_string = "admin;;0;;0"

            string username = HttpContext.Current.Session[ENUM_SESSION.SESSION_USERNAME] + "";
            string court_id = HttpContext.Current.Session[ENUM_SESSION.SESSION_DONVIID] + "";
            string court_name = HttpContext.Current.Session[ENUM_SESSION.SESSION_TENDONVI] + "";

            if (court_id == "")
            {
                return false;
            }

            //SESSION loại tòa án 
            GSTPContext gstm = new GSTPContext();
            decimal id = Convert.ToDecimal(court_id);
            DM_TOAAN toaan = gstm.DM_TOAAN.Where(x => x.ID == id).FirstOrDefault();
            string loaitoa = toaan.LOAITOA;
            HttpContext.Current.Session["LOAITOA"] = loaitoa;

            username = "admin";//CHUA MAPPING DUOC (SỬ DỤNG LẤY CHỨC NĂNG BÁO CÁO)

            string type = "";
            string user_type = "";
            if (court_id != "")
            {
                if (loaitoa == "TOICAO")
                {
                    //map TÒA ÁN TỐI CAO bên GSCM vào VỤ TỔNG HỢP bên GSTK
                    //2284:TW:Vụ Giám đốc kiểm tra I
                    type = "TW";
                    court_id = "2284";
                    court_name = "Tòa án cấp tối cao";
                    user_type = "";
                }
                else
                {
                    M_Courts cCourts = new M_Courts();
                    Courts c = cCourts.Court_List_Objecs(int.Parse(court_id));
                    if (c != null)
                    {
                        court_id = c.ID.ToString();
                        court_name = c.COURT_NAME;
                        type = c.TYPE;
                        user_type = c.USER_TYPE.ToString();
                    }
                }
            }
            else
            {
                return false;
            }

            string session_string = username + ";" + type + ";" + court_id + ";" + court_name + ";" + user_type;
            System.Diagnostics.Debug.WriteLine("Sesion_Manager_ID: " + session_string);
            HttpContext.Current.Session["Sesion_Manager_ID"] = session_string;

            /**
             * XỬ LÝ SESSION CHỨC NĂNG
             */

            M_Functions M_Objects = new M_Functions();
            List<Functions> List_Functions = new List<Functions>();
            //List_Functions = M_Objects.Function_List_Users(Database.GetUserName(HttpContext.Current.Session["Sesion_Manager_ID"].ToString()));
            //string id_courts = Database.GetUserCourt(HttpContext.Current.Session["Sesion_Manager_ID"].ToString());
            //List_Functions = M_Objects.Function_List_Courts(id_courts);
            List_Functions = M_Objects.Function_List_Courts_type(type);
            System.Diagnostics.Debug.WriteLine("Function_List_Shows: " + List_Functions);
            HttpContext.Current.Session["Function_List_Shows"] = List_Functions;

            return true;
        }
    }
}