using System;
using System.Web;

namespace WEB.GSTP
{
    public partial class DownloadFile_Minio : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string cacheKey = Request.QueryString["cacheKey"];
            string fileName = Request.QueryString["FileName"];
            string extension = Request.QueryString["Extension"];

            if (string.IsNullOrEmpty(cacheKey))
            {
                Response.StatusCode = 400;
                Response.Write("Thiếu cacheKey.");
                return;
            }

            byte[] fileData = Context.Cache[cacheKey] as byte[];
            if (fileData == null)
            {
                Response.StatusCode = 404;
                Response.Write("File không tồn tại hoặc đã hết hạn.");
                return;
            }

            try
            {
                string fullFileName = fileName + extension;
                string contentType = MimeMapping.GetMimeMapping(fullFileName);

                Response.Clear();
                Response.Buffer = true;
                Response.ContentType = contentType;
                Response.AddHeader("Content-Disposition", $"attachment; filename=\"{fullFileName}\"");
                Response.AddHeader("Content-Length", fileData.Length.ToString());

                Response.BinaryWrite(fileData);
                Response.Flush();
                Context.Cache.Remove(cacheKey);
            }
            catch (Exception ex)
            {
                Response.StatusCode = 500;
                Response.Write("Lỗi khi tải file: " + HttpUtility.HtmlEncode(ex.Message));
            }
            finally
            {
                Response.End();
            }
        }
    }
}