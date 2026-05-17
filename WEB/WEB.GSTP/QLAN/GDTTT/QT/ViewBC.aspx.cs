using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;

namespace WEB.GSTP.QLAN.GDTTT.QT
{
    public partial class ViewBC : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                try
                {
                    LoadReport();
                }
                catch (Exception ex) { }
            }
        }
        private void LoadReport()
        {
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            String TenPhongBan = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).FirstOrDefault().TENPHONGBAN;
            string report_name = ("Danh sách cấu hình thẩm tra viên báo cáo lãnh đạo " + TenPhongBan).ToUpper();
            String SessionName = "GDTTT_ConfigTTV".ToUpper();
            DataTable tblData = (DataTable)Session[SessionName];
            String ThoiGian = "(Tính đến ngày " + DateTime.Now.ToString("dd/MM/yyyy", cul)+ ")";
          
                    HS hs = new HS();
                    hs.Parameters["TieuDeBC"].Value = report_name;
                    hs.Parameters["ThoiGian"].Value = ThoiGian;
                    hs.DataSource = tblData;
                    reportcontrol.OpenReport(hs);
        }
    }
}