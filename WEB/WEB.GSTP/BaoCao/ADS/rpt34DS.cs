using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt34DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt34DS()
        {
            InitializeComponent();
        }

        private void xrLabel3_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel3.Text = xrLabel3.Text.ToUpper();
        }

        private void xrTableCell47_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell47.Text = xrTableCell47.Text.Replace("Ông", "").Replace("Bà", "");
        }

        private void xrTableCell46_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell46.Text = xrTableCell46.Text.Replace("Ông", "").Replace("Bà", "");
        }

        private void DetailReport_NVLQ_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NVLQ.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport_NVLQ.Visible = false;
            }
        }
    }
}
