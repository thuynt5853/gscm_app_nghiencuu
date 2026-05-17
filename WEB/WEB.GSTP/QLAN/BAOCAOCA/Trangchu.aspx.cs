using BL.GSTP;
using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

namespace WEB.GSTP.QLAN.BAOCAOCA
{
    public partial class Trangchu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MaHeThong"] + "" != "")
            {
                #region Nếu User là chánh án
                QT_MENU_BL qtBL = new QT_MENU_BL();
                decimal IDNhom = 0;
                if (Session[ENUM_SESSION.SESSION_NHOMNSDID] != null && Session[ENUM_SESSION.SESSION_NHOMNSDID] + "" != "")
                {
                    IDNhom = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID] + "");
                }
                DataTable lst_home = qtBL.Qt_Nhom_ISHome_Get_List(IDNhom);
                if (lst_home != null && lst_home.Rows.Count > 0 && lst_home.Rows[0]["VIEW_TK"] + "" == "1")
                {
                    GDTThongKe.Visible = true;

                }
                else
                {
                    GDTThongKe.Visible = false;
                }

                // Kiểm tra xem UserControl đã được gắn vào cây điều khiển của trang chưa
                //if (this.FindControl("GDTThongKe") == null)
                //{
                //    // Nếu chưa, hãy thêm UserControl vào cây điều khiển
                //    uThongKe_Chanhan control = (uThongKe_Chanhan)this.LoadControl("~/QLAN/BAOCAOCA/uThongKe_Chanhan.ascx");
                //    control.ID = "GDTThongKe";
                //    this.Controls.Add(control);  // Gắn UserControl vào Page.Controls
                //}
                #endregion
            }
        }

        //[WebMethod]
        //public static string LoadDelayedData()
        //{
        //    // Lấy Trangchu hiện tại
        //    Trangchu page = (Trangchu)HttpContext.Current.Handler;

        //    // Tìm UserControl trong trang
        //    uThongKe_Chanhan control = (uThongKe_Chanhan)page.FindControl("GDTThongKe");

        //    if (control != null)
        //    {
        //        control.LoadTK_Toaan_STPT();
        //        control.Load_DataTPTATCM1();
        //        return "Dữ liệu đã tải xong!";
        //    }
        //    else
        //    {
        //        return "Không tìm thấy UserControl!";
        //    }
        //}
    }
}
