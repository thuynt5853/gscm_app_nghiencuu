using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;

namespace WEB.DONKHOIKIEN.UserControl
{
    public partial class Home_TraCuuHS : System.Web.UI.UserControl
    {
        int SoLuongKyTu = 6;
        protected void Page_Load(object sender, EventArgs e)
        {
            String StrRandom = Cls_Comon.RandomString(SoLuongKyTu);
            lttRandom.Text = hddTempCode.Value = StrRandom;
        }

        protected void cmdTraCuu_Click(object sender, EventArgs e)
        {

        }
       
    }
}