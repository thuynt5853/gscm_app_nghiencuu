using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt37DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt37DS()
        {
            InitializeComponent();
        }

        private void xrTableCell47_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell47.Text = xrTableCell47.Text.Replace("Ông", "").Replace("Bà", "");
        }

        private void xrTableCell46_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell46.Text = xrTableCell46.Text.Replace("Ông", "").Replace("Bà", "");
        }

        private void xrTableCell19_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell19.Text = xrTableCell19.Text.ToUpper();
        }
    }
}
