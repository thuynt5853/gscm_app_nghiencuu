using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt65DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt65DS()
        {
            InitializeComponent();
        }

        private void xrTableCell10_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell10.Text = xrTableCell10.Text.ToUpper();
        }
    }
}
