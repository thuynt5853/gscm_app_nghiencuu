using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.IO;
using System.Web.Script.Serialization;
using DAL.DKK;
namespace WEB.DONKHOIKIEN.Personnal
{
    /// <summary>
    /// Summary description for UploadHandler
    /// </summary>
    public class UploadHandler : IHttpHandler
    {
        string folder_upload = "/TempUpload/";
        public void ProcessRequest(HttpContext context)
        {
            string fname="";
            if (context.Request.Files.Count > 0)
            {
                string file_path = context.Server.MapPath(folder_upload);
                if (!Directory.Exists(file_path))
                    Directory.CreateDirectory(file_path);

                HttpFileCollection files = context.Request.Files;
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    fname = "";
                    if (HttpContext.Current.Request.Browser.Browser.ToUpper() == "IE" || HttpContext.Current.Request.Browser.Browser.ToUpper() == "INTERNETEXPLORER")
                    {
                        string[] testfiles = file.FileName.Split(new char[] { '\\' });
                        fname = testfiles[testfiles.Length - 1];
                    }
                    else
                    {
                        fname = file.FileName;
                    }
                    fname = Path.Combine(file_path, fname);
                    file.SaveAs(fname);
                }
            }
            context.Response.ContentType = "text/plain";
            context.Response.Write(fname);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}