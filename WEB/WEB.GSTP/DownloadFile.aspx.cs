using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP;
using Module.Common;
namespace WEB.GSTP
{
    public partial class DownloadFile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var bytes = Context.Cache.Get(Request.QueryString.Get("cacheKey")) as byte[];
                string strFileName = Request.QueryString.Get("FileName");
                string strExtension = Request.QueryString.Get("Extension");
                Response.Clear();
                Response.AddHeader(
                    "content-disposition", string.Format("attachment; filename=" + strFileName + strExtension, "Invoice"));
                Response.ContentType = Cls_Comon.GetContentType(strExtension);
                Response.BinaryWrite(bytes);
                Response.End();
                
            }
        }
    }
}