using BL.GSTP;
using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
namespace WEB.GSTP.UserControl
{
    public partial class DieuHuong : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string strMaCT = Session["MaChuongTrinh"] + "";
                if (strMaCT != "" & strMaCT != "0" && strMaCT != "HDSD_APP")
                {
                    //Load tiêu đề 
                    QT_CHUONGTRINH oT = dt.QT_CHUONGTRINH.Where(x => x.MA == strMaCT).FirstOrDefault();
                    lstDieuhuong.Text = oT.TEN + "&nbsp;>&nbsp;";
                    // if (oT.DUONGDAN == null)//anhvh add liên quan chức năng hướng dẫn có phân quyền
                    // {
                    //Điều hướng menu
                    string strPath = "",strSql="";
                    if (oT.MA == "TDKT_IN_AN")
                        strPath = Request.Url.PathAndQuery.ToLower();
                    else
                        strPath = Request.FilePath.ToString().ToLower();

                    if (strPath.Substring(0, 1) == "/")
                        strSql = strPath.Substring(1);

                    List<QT_MENU> lst = dt.QT_MENU.Where(x => x.DUONGDAN.ToLower() == strSql).ToList();
                    if (lst.Count > 0)
                    {
                        QT_MENU oN = lst[0];
                        string strView = "<b>" + oN.TENMENU + "</b>";
                        if (oN.CAPCHAID != 0)
                        {
                            QT_MENU oP = dt.QT_MENU.Where(x => x.ID == oN.CAPCHAID).FirstOrDefault();
                            strView = oP.TENMENU + "&nbsp;> &nbsp;" + strView;
                            if (oP.CAPCHAID != 0)
                            {
                                QT_MENU oPP = dt.QT_MENU.Where(x => x.ID == oP.CAPCHAID).FirstOrDefault();
                                strView = oPP.TENMENU + "&nbsp;> &nbsp;" + strView;
                            }
                        }
                        lstDieuhuong.Text += strView;
                    }
                    //Kiểm tra quyền truy cập
                    QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();
                    if (!oBL.CheckPermission(strPath, Convert.ToDecimal(Session["UserID"])))
                    {
                        Response.Redirect(Cls_Comon.GetRootURL() + "/Permisson.aspx");
                    }
                    //}
                }
            }
        }
    }
}