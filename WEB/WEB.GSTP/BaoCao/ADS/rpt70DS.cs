using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt70DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt70DS()
        {
            InitializeComponent();
        }

        private void xrLabel4_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel4.Text = xrLabel4.Text.ToUpper();
        }

        private void xrTableCell36_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell36.Text = xrTableCell36.Text.Replace("Ông", "").Replace("Bà", "");
        }

        private void DetailReport_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport.GetCurrentRow();

            if (r == null || r.DataView.Count == 0)
            {
                xrTable13.Visible = false;
                xrTable9.Visible = false;
            }
        }

        private void DetailReport6_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport6.GetCurrentRow();

            if (r == null || r.DataView.Count == 0)
            {
                xrTable10.Visible = false;
                xrTable11.Visible = false;
            }
        }

        private void xrTableCell4_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell4.Text = xrTableCell4.Text.ToUpper();
        }
    }
}
