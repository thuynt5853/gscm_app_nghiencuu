using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;

namespace WEB.GSTP.UserControl
{
    public partial class GenerateSecretPass_frm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            txtSecretPass.Text = Cls_Comon.GenerateSecretPass(40);
        }
    }
}