using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using BL.GSTP.Danhmuc;

namespace WEB.DONKHOIKIEN.UserControl
{
    public partial class Footer : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DM_TRANGTINH_BL obj = new DM_TRANGTINH_BL();
                String NoiDung = obj.GetNoiDungByMaTrang(hddMa.Value);
                if (!String.IsNullOrEmpty(NoiDung))
                    ltt.Text = NoiDung;
            }
        }
    }
}