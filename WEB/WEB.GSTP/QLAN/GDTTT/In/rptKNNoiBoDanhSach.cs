using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.In
{
    public partial class rptKNNoiBoDanhSach : DevExpress.XtraReports.UI.XtraReport
    {
        public rptKNNoiBoDanhSach()
        {
            InitializeComponent();
        }

        private void xrTableCell12_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell12.Text = xrTableCell12.Text.ToUpper();
        }

        private void xrTableCell1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell1.Text = xrTableCell1.Text.ToUpper();
        }
    }
}
