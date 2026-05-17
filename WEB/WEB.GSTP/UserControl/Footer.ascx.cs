using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.UserControl
{
    public partial class Footer : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            lstOnline.Text = Application.Get("OnlineNow").ToString(); 
            if(!IsPostBack)
            {
                try
                {
                    GSTPContext dt = new GSTPContext();
                List<QT_THONGSO> lstLTC = dt.QT_THONGSO.ToList();              
                if (lstLTC.Count > 0)
                {
                    QT_THONGSO objLTC = lstLTC[0];
                    lstLuottruycap.Text = objLTC.LUOTTRUYCAP + "";
                }
                }
                catch (Exception ex) { }
            }
        }
    }
}