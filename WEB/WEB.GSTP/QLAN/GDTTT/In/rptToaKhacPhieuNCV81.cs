using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.In
{
    public partial class rptToaKhacPhieuNCV81 : DevExpress.XtraReports.UI.XtraReport
    {
        public rptToaKhacPhieuNCV81()
        {
            InitializeComponent();
        }

        private void xrTableCell12_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell12.Text = xrTableCell12.Text.ToUpper();
        }
    }
}
