using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt24DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt24DS()
        {
            InitializeComponent();
        }

        private void GroupHeader_sodienthoai_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("SODIENTHOAI") + "") && string.IsNullOrEmpty(GetCurrentColumnValue("FAX") + ""))
            {
                GroupHeader_sodienthoai.Visible = false;
            }
        }

        private void Detail_Email_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("EMAIL") + ""))
            {
                Detail_Email.Visible = false;
            }
        }

        private void xrTableCell12_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell12.Text = xrTableCell12.Text.ToUpper();
        }

        private void xrLine4_BeforePrint(object sender, CancelEventArgs e)
        {

        }
    }
}
