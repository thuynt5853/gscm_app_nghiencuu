using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.AHC
{
    public partial class rpt35HC : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt35HC()
        {
            InitializeComponent();
        }

        private void xrTableCell19_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell19.Text = xrTableCell19.Text.ToUpper();
        }
    }
}
