using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt27DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt27DS()
        {
            InitializeComponent();
        }

        private void xrTableCell19_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell19.Text = xrTableCell19.Text.ToUpper();
        }

        private void GroupHeader_Sodienthoai_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("SODIENTHOAI") + "") && string.IsNullOrEmpty(GetCurrentColumnValue("FAX") + ""))
            {
                GroupHeader_Sodienthoai.Visible = false;
            }
        }

        private void Detail_Email_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("EMAIL") + ""))
            {
                Detail_Email.Visible = false;
            }
        }
    }
}
