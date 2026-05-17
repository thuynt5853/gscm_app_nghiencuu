using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.THA
{
    public partial class rpt02THA : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt02THA()
        {
            InitializeComponent();
        }
        private void xrTableCell36_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell36.Text = xrTableCell36.Text.Replace("Ông", "").Replace("Bà", "");
        }
    }
}
