using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.TempUpload
{
    public partial class TempUploadFiles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //anhvh add 10/08/2020
            //mục đích của file này là để có folder 'TempUpload' tồn tại trên source control của Team group
            //thì phải tồn tại một file giao diện TempUploadFiles.aspx
            //và khi public dự án thì sẽ tồn tại folder này, folder này phục vụ cho việp upload file
        }
    }
}