using System;
using System.Linq;
using System.Web;
using System.Web.Http;
using NLog;

namespace WEB.GSTP
{
    public class Global : System.Web.HttpApplication
    {
        void Application_Start(Object sender, EventArgs e)
        {
            // Code that runs on application startup
            Application.Set("OnlineNow", 0);
            DevExpress.XtraReports.Web.ASPxWebDocumentViewer.StaticInitialize();

            // Cấu hình Web API
            GlobalConfiguration.Configure(WebApiConfig.Register);
        }

        void Application_End(Object sender, EventArgs e)
        {
            // Code that runs on application shutdown
        }

        void Application_Error(Object sender, EventArgs e)
        {
            
            
            Exception ex = Server.GetLastError();

            //Ghi lỗi ra log file
            var logger = NLog.LogManager.GetCurrentClassLogger();

            string url = HttpContext.Current?.Request?.Url?.ToString() ?? "N/A";
            string ip = HttpContext.Current?.Request?.UserHostAddress ?? "N/A";

            // Tìm thông tin dòng lỗi từ StackTrace
            var trace = new System.Diagnostics.StackTrace(ex, true);
            var frame = trace.GetFrames()?.FirstOrDefault(f => f.GetFileLineNumber() > 0);
            string file = frame?.GetFileName() ?? "Không rõ file";
            int line = frame?.GetFileLineNumber() ?? 0;

            logger.Error(ex, $"❌ [GLOBAL ERROR] URL: {url} | IP: {ip} | File: {file} | Line: {line} | Time: {DateTime.Now:yyyy-MM-dd HH:mm:ss}");

            

            // Lấy thông tin lỗi        
            string errorMessage = ex != null ? ex.Message : "Đã xảy ra lỗi không xác định!";

            // Xóa phản hồi hiện tại
            Response.Clear();

            // Thêm mã JavaScript để hiển thị alert
            string script = $"<script type='text/javascript'>alert('Lỗi: {errorMessage.Replace("'", "\\'")}');</script>";
            Response.Write(script);

            // Xóa lỗi để ngăn xử lý tiếp theo
            Server.ClearError();

        }

        void Session_Start(Object sender, EventArgs e)
        {

        }

        void Session_End(Object sender, EventArgs e)
        {
            // Xóa file js của bản đồ khi hết phiên làm việc
            //string strFileName_js = "mapdata_" + Session[ENUM_SESSION.SESSION_DONVIID] + ".js";
            //string path_js = Server.MapPath("~/GSTP/") + strFileName_js;
            //FileInfo oF_js = new FileInfo(path_js);
            //if (oF_js.Exists)// Nếu file đã tồn tại
            //{
            //    File.Delete(path_js);
            //}
            //
            int so = int.Parse(Application.Get("OnlineNow").ToString());
            if (so > 0) so--;
            else
                so = 0;
            Application.Set("OnlineNow", so);
        }

    }
}